/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_A_SnapShot WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_ProfitAndLoss_A_SnapShot]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_A_SnapShot.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_A_SnapShot]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ProfitAndLoss_A_SnapShot] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ProfitAndLoss_A_SnapShot >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ProfitAndLoss_A_SnapShot]
							@c_ReverseRebooks		Char(1) = 'A', -- 'A' = within AP, 'E' = exclude all 'S' = Show All
							@i_P_EODSnpShtID		Int = Null Output,
							@vc_P_PrtflioID			Varchar(8000) = '187', -- Europe Supply & Trading
							@sdt_AccntngPrdID_From		smalldatetime = Null,
							@sdt_AccntngPrdID_To		smalldatetime = Null,
							@sdt_DeliveryPeriod_From	smalldatetime = Null,
							@sdt_DeliveryPeriod_To		smalldatetime = Null,
							@vc_PrntBAID			Varchar(8000) = '77', -- ES&T
							@i_XGrpID			Int = 174, -- London MTM Pnl
							@c_InventoryView		Char(1) = 'A', -- Open AccountingPeriod
							@vc_TrnsctnTypID		Varchar(8000) = Null,
							@vc_PrdctID			Varchar(8000) = Null,
							@vc_LcleID			Varchar(8000) = Null,
							@vc_DealNumber			Varchar(20)= Null,
							@vc_DlDtlTmplteID		Varchar(8000) = Null,
							@i_whatifscenario		Int = 0,
							@c_InterimBilling		Char(1)		= 'E', -- E = Excludde, I = Include
							@c_RiskAdjustments		Char(1)		= 'I', -- E = Excludde, I = Include
							@c_FallBackToMkt		Char(1),
							@vc_WaterDensity		Varchar(80),
							@i_BaseCurrencyID		Int,
							@i_DefaultCurrencyService	Int,
							@c_Compare_SnapShot		Char(1)		= 'N',
							@sdt_InstanceDateTime		smalldatetime OutPut,
							@sdt_EndOfDay			smalldatetime OutPUt,
							@c_InventoryValue		Char(1) = 'M',
							@c_InventoryOptions		Char(1) = 'C',
							@c_IsThisNavigation 		Char(1) 	= 'N',
							@i_RprtCnfgID			Int		= Null,
							@vc_AdditionalColumns		VarChar(8000)	= Null,
							@c_OnlyShowSQL			Char(1)		= 'N'
AS
-----------------------------------------------------------------------------------------------------------------------------
-- SP:            MTV_ProfitAndLoss_A_SnapShot
-- Arguments:	 
-- Tables:         Tables
-- Indexes: LIST ANY INDEXES used in OPTIMIZER hints
-- Stored Procs:   StoredProcedures
-- Dynamic Tables: DynamicTables
-- Overview:       DocumentFunctionalityHere
--
-- Created by:     Matt Perry
-- Issues
--	Figure out how to get the snapshot selection window to come up on navigation
--	Probably want to set @i_AccntngPrdID_Inventory for when crossing months based on what user picks
--		For example if EOD is March 4th but Feb is still open, user may want to see inventory in March or Feb
--		depending on accounting or trading view
--	Doing currency conversion for accountdetails based on transaction date
--	Doing currency conversion for estimatedaccountdetails based on endofday b/c they do not put future month rates in
-- History:       
-- Date Modified Modified By        Modification
-- ------------- ------------------ -------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set Quoted_Identifier off

declare @Year int, @Month int, @Day INT
declare @hour int, @Min int, @sec INT
declare @i_P_EODSnpShtID2 int 
declare @dt_dt1 datetime
declare @dt_dt2 datetime
Declare @sdt_LatestEndOfDay SmallDateTime


-----------------------------------------------------------------------------------------------------------------
-- If @i_P_EODSnpShtID is zero or null then get the latest valid snapshot unless navigating
-----------------------------------------------------------------------------------------------------------------
If IsNull(@i_P_EODSnpShtID,0) = 0
Begin
	If @c_IsThisNavigation = 'N'
	Begin
		Select	@i_P_EODSnpShtID = Max(SnapShot.P_EODSnpshtID)
		From	SnapShot (NoLock)
		where	SnapShot.IsValid = 'Y'
	End
	Else
	Begin
		Select	@i_P_EODSnpShtID = min(#MTVProfitAndLoss_Navigation.P_EODSnpshtID)
		From	#MTVProfitAndLoss_Navigation (NoLock)
	End
End
Else
-----------------------------------------------------------------------------------------------------------------
-- If @i_P_EODSnpShtID = -1 then get the latest nightly
-----------------------------------------------------------------------------------------------------------------
If @i_P_EODSnpShtID = -1
Begin
	Select	@i_P_EODSnpShtID = Max(SnapShot.P_EODSnpshtID)
	From	SnapShot (NoLock)
	where	SnapShot.IsValid = 'Y'
	And		SnapShot.NightlySnapshot = 'Y'
End
Else
-----------------------------------------------------------------------------------------------------------------
-- If @i_P_EODSnpShtID = -2 then get the next to latest nightly
-----------------------------------------------------------------------------------------------------------------
If @i_P_EODSnpShtID = -2
Begin
	Select	@i_P_EODSnpShtID = Max(SnapShot.P_EODSnpshtID),
			@sdt_LatestEndOfDay = Max(SnapShot.EndOfDay)
	From	SnapShot (NoLock)
	where	SnapShot.IsValid = 'Y'
	And		SnapShot.NightlySnapshot = 'Y'

	Select	@i_P_EODSnpShtID = Max(SnapShot.P_EODSnpshtID)
	From	SnapShot (NoLock)
	where	SnapShot.IsValid = 'Y'
	And		SnapShot.NightlySnapshot = 'Y'
	And		SnapShot.P_EODSnpshtID < @i_P_EODSnpShtID
	And		SnapShot.EndOfDay < @sdt_LatestEndOfDay 
End
Else
-----------------------------------------------------------------------------------------------------------------
-- If @i_P_EODSnpShtID = -4 then get the latest Month - End
-----------------------------------------------------------------------------------------------------------------
If @i_P_EODSnpShtID = -4
Begin
	Select	@i_P_EODSnpShtID = Max(SnapShot.P_EODSnpshtID)
	From	SnapShot (NoLock)
	where	SnapShot.IsValid = 'Y'
	And		SnapShot.IsAsOfSnapshot = 'Y'	
End 

---------------------------------------------------------------------------------------------------------------
-- Declare the variable we will use to build dynamic sql
---------------------------------------------------------------------------------------------------------------
Declare @vc_SQL		Varchar(8000)
Declare @vc_Select	Varchar(8000)
Declare @vc_Select_Additional	Varchar(8000)
Declare @vc_From	Varchar(8000)
Declare @vc_Where	Varchar(8000)


---------------------------------------------------------------------------------------------------------------
-- Declare the variables we will use in the inserts into the results temp table
---------------------------------------------------------------------------------------------------------------
Declare @i_AccntngPrdID_SnapshotStart int
Declare @i_AccntngPrdID_To_AccountDetailWhere	Int
Declare @sdt_AccntngPrdBgnDte_SnapShotStart	SmallDateTime
Declare @sdt_AccntngPrdBgnDte_To		SmallDateTime
--Declare @sdt_EndOfDay				SmallDateTime
Declare @i_VETradePeriodID_From			Int
Declare @i_VETradePeriodID_To			Int
Declare @i_VETradePeriodID_Inventory		Int
Declare @i_VETradePeriodID_SnapShotStart	Int
Declare @sdt_AccntngPrdBgnDte_Inventory	SmallDateTime
--Declare @sdt_InstanceDateTime	SmallDateTime
Declare @i_AccntngPrdID_Inventory Int
Declare @i_AccntngPrdID_From Int
Declare @i_AccntngPrdID_To Int

Declare @sdt_AccntngPrdID_To_Orig SmallDateTime

Declare @c_MonthEndSnapShot Char(1)
Declare @c_MonthEndSnapShotLogic Char(1)


-----------------------------------------------------------------------------------------------------------------
-- If we do not have a snapshot then get the latest valid snapshot
-----------------------------------------------------------------------------------------------------------------
If @i_P_EODSnpShtID is Null
Begin
	Select	@i_P_EODSnpShtID = Max(SnapShot.P_EODSnpshtID)
	From	SnapShot (NoLock)
	where	SnapShot.IsValid = 'Y'
End

-----------------------------------------------------------------------------------------------------------------
-- Get the starting AccountingPeriod of the snapshot
-- This will tell is what the accounting period criteria will be for the accountdetail select and if we
-- even need to get accountdetails
-----------------------------------------------------------------------------------------------------------------
Select	@i_AccntngPrdID_SnapshotStart		= PeriodTranslation.AccntngPrdID,
		@sdt_AccntngPrdBgnDte_SnapShotStart	= AccountingPeriod.AccntngPrdBgnDte,
		@sdt_InstanceDateTime			= SnapShot.InstanceDateTime,
		@i_VETradePeriodID_SnapShotStart	= SnapShot.StartedFromVETradePeriodID,
		@sdt_EndOfDay				= SnapShot.EndOfDay,
		@c_MonthEndSnapShot			= Snapshot.IsAsOfSnapshot
From	SnapShot (NoLock)
		Inner Join PeriodTranslation (NoLock) On PeriodTranslation.VETradePeriodID = Snapshot.StartedFromVETradePeriodID
		Inner Join AccountingPeriod (NoLock) On AccountingPeriod.AccntngPrdID = PeriodTranslation.AccntngPrdID
Where	SnapShot.P_EODSnpShtID = @i_P_EODSnpShtID

---------------------------------------------------------------------------------------------------------------------
-- If @sdt_AccntngPrdID_From is null then we will assume the beginning of the year of the @i_AccntngPrdID_SnapshotStart
---------------------------------------------------------------------------------------------------------------------
If @sdt_AccntngPrdID_From is null
Begin
	If @c_IsThisNavigation = 'N'
	Begin
		Select	@i_AccntngPrdID_From = AccountingPeriod.AccntngPrdID
		From	AccountingPeriod (NoLock)
		Where	AccountingPeriod.AccntngPrdBgnDte = Convert(Varchar,Year(@sdt_AccntngPrdBgnDte_SnapShotStart)) + '-01-01'
	End
	Else
	Begin
		Select	@i_AccntngPrdID_From = Min(AccountingPeriod.AccntngPrdID)
		From	AccountingPeriod (NoLock)
	End
End
Else
Begin
	Select	@i_AccntngPrdID_From = AccountingPeriod.AccntngPrdID
	From	AccountingPeriod (NoLock)
	Where	AccountingPeriod.AccntngPrdBgnDte = @sdt_AccntngPrdID_From
End

---------------------------------------------------------------------------------------------------------------------
-- If @c_InventoryView is null then we will assume the first accounting period of the snapshot
---------------------------------------------------------------------------------------------------------------------
If Isnull(@c_InventoryView,'F') = 'F'
Begin
	select	@i_AccntngPrdID_Inventory = @i_AccntngPrdID_SnapshotStart
End
Else if @c_InventoryView = 'E'
Begin
	Select	@i_AccntngPrdID_Inventory = AccountingPeriod.AccntngPrdID
	From	AccountingPeriod (NoLock)
	Where	@sdt_EndOfDay Between AccountingPeriod.AccntngPrdBgnDte And AccountingPeriod.AccntngPrdEndDte
End
Else
Begin
	Select @i_AccntngPrdID_Inventory = Null
End


-----------------------------------------------------------------------------------------------------------------------
-- IF the to accounting period passed is less than the staring accountig period of the snapshot then this means
-- we will not get Risk records, so this is checked again later, but this also means that the to accounting period
-- in the where clause of the accountdetail select will not be @i_AccntngPrdID_SnapshotStart -1, but @i_AccntngPrdID_To
-----------------------------------------------------------------------------------------------------------------------
select @sdt_AccntngPrdID_To_Orig = @sdt_AccntngPrdID_To

If @sdt_AccntngPrdID_To is Null or @sdt_AccntngPrdID_To < @sdt_AccntngPrdID_From
Begin
	select	@i_AccntngPrdID_To = Max(AccountingPeriod.AccntngPrdID)
	From	AccountingPeriod (NoLock)
	
End
Else
Begin
	Select	@i_AccntngPrdID_To = AccountingPeriod.AccntngPrdID
	From	AccountingPeriod (NoLock)
	Where	AccountingPeriod.AccntngPrdEndDte = @sdt_AccntngPrdID_To
End

/*
select @i_AccntngPrdID_From
select @i_AccntngPrdID_SnapshotStart
*/

-----------------------------------------------------------------------------------------------------------------------
-- Only execute the insert for account details if the from account period passed in is less than the starting
-- accountinger period of the snapshot and this is not for the snapshot we are comparing to
-- Or if it is a month end snapshot and the @i_AccntngPrdID_From <= @i_AccntngPrdID_SnapshotStart
-----------------------------------------------------------------------------------------------------------------------
--If ((@i_AccntngPrdID_From < @i_AccntngPrdID_SnapshotStart) Or (@i_AccntngPrdID_From <= @i_AccntngPrdID_SnapshotStart And @c_MonthEndSnapShot = 'Y' )  ) And @c_Compare_SnapShot = 'N'
If ((@i_AccntngPrdID_From < @i_AccntngPrdID_SnapshotStart)   ) And @c_Compare_SnapShot = 'N'
Begin
	
	If @i_AccntngPrdID_To < @i_AccntngPrdID_SnapshotStart
	Begin
		select	@c_MonthEndSnapShotLogic = 'N'
		select	@i_AccntngPrdID_To_AccountDetailWhere = @i_AccntngPrdID_To
	End
	Else
	Begin
		select	@c_MonthEndSnapShotLogic = @c_MonthEndSnapShot
		select	@i_AccntngPrdID_To_AccountDetailWhere = @i_AccntngPrdID_SnapshotStart - 1
	End

	Execute dbo.MTV_ProfitAndLoss_AccountDetail	@c_ReverseRebooks		= @c_ReverseRebooks,
								@i_P_EODSnpShtID		= @i_P_EODSnpShtID,
								@vc_P_PrtflioID			= @vc_P_PrtflioID,
								@i_AccntngPrdID_From		= @i_AccntngPrdID_From,
								@i_AccntngPrdID_To		= @i_AccntngPrdID_To,
								@sdt_DeliveryPeriod_From	= @sdt_DeliveryPeriod_From,
								@sdt_DeliveryPeriod_To		= @sdt_DeliveryPeriod_To,
								@vc_PrntBAID			= @vc_PrntBAID,
								@i_XGrpID			= @i_XGrpID,
								@i_AccntngPrdID_Inventory	= @i_AccntngPrdID_Inventory,
								@vc_TrnsctnTypID		= @vc_TrnsctnTypID,
								@vc_PrdctID			= @vc_PrdctID,
								@vc_LcleID			= @vc_LcleID,
								@vc_DealNumber			= @vc_DealNumber,
								@vc_DlDtlTmplteID		= @vc_DlDtlTmplteID,
								@c_InterimBilling		= @c_InterimBilling,
								@c_IsThisNavigation 		= @c_IsThisNavigation,
								@i_RprtCnfgID			= @i_RprtCnfgID,
								@vc_AdditionalColumns		= @vc_AdditionalColumns,
								@c_OnlyShowSQL			= @c_OnlyShowSQL,
								@sdt_InstanceDateTime		= @sdt_InstanceDateTime,
								@sdt_EndOfDay			= @sdt_EndOfDay,
								@i_AccntngPrdID_To_AccountDetailWhere	= @i_AccntngPrdID_To_AccountDetailWhere,
								@vc_WaterDensity		= @vc_WaterDensity,
								@i_DefaultCurrencyService	= @i_DefaultCurrencyService,
								@c_MonthEndSnapShotLogic = 'N'
								--@c_MonthEndSnapShotLogic	= @c_MonthEndSnapShotLogic
End



-----------------------------------------------------------------------------------------------------------------------
-- Only execute the insert for the estimates and risk adjustments if the to accounting period is greater than the starting period
-----------------------------------------------------------------------------------------------------------------------
If @i_AccntngPrdID_To >= @i_AccntngPrdID_SnapshotStart
Begin

/*
	If @c_OnlyShowSQL = 'Y'
	Begin
		select
			'
			Select * into #MTVProfitAndLoss_EAD From #MTVProfitAndLoss where 1=2
			'
	End
	Else
	Begin
		Select * into #MTVProfitAndLoss_EAD From #MTVProfitAndLoss where 1=2
	End
*/

	Execute dbo.MTV_ProfitAndLoss_EstimatedAccountDetail
								@c_ReverseRebooks		= @c_ReverseRebooks,
								@i_P_EODSnpShtID		= @i_P_EODSnpShtID,
								@vc_P_PrtflioID			= @vc_P_PrtflioID,
								@i_AccntngPrdID_From		= @i_AccntngPrdID_From,
								@i_AccntngPrdID_To		= @i_AccntngPrdID_To,
								@sdt_DeliveryPeriod_From	= @sdt_DeliveryPeriod_From,
								@sdt_DeliveryPeriod_To		= @sdt_DeliveryPeriod_To,
								@vc_PrntBAID			= @vc_PrntBAID,
								@i_XGrpID			= @i_XGrpID,
								@i_AccntngPrdID_Inventory	= @i_AccntngPrdID_Inventory,
								@vc_TrnsctnTypID		= @vc_TrnsctnTypID,
								@vc_PrdctID			= @vc_PrdctID,
								@vc_LcleID			= @vc_LcleID,
								@vc_DealNumber			= @vc_DealNumber,
								@vc_DlDtlTmplteID		= @vc_DlDtlTmplteID,
								@i_whatifscenario		= @i_whatifscenario,
								@c_InterimBilling		= @c_InterimBilling,
								@c_FallBackToMkt		= @c_FallBackToMkt,
								@c_IsThisNavigation 		= @c_IsThisNavigation,
								@i_RprtCnfgID			= @i_RprtCnfgID,
								@vc_AdditionalColumns		= @vc_AdditionalColumns,
								@c_OnlyShowSQL			= @c_OnlyShowSQL,
								@sdt_InstanceDateTime		= @sdt_InstanceDateTime,
								@i_VETradePeriodID_SnapshotStart = @i_VETradePeriodID_SnapshotStart,
								@vc_WaterDensity		= @vc_WaterDensity,
								@sdt_EndOfDay			= @sdt_EndOfDay,
								@i_DefaultCurrencyService	= @i_DefaultCurrencyService,
								@c_Compare_SnapShot		= @c_Compare_SnapShot,
								@c_MonthEndSnapShotLogic =  'N',
--								@c_MonthEndSnapShotLogic	= @c_MonthEndSnapShotLogic,
								@c_InventoryValue		= @c_InventoryValue,
								@c_InventoryOptions		= @c_InventoryOptions


	If @c_OnlyShowSQL = 'Y'
	Begin
		Select
		'
		Insert  #MTVProfitAndLoss select * from #MTVProfitAndLoss_EAD
		Delete #MTVProfitAndLoss_EAD
		'
	End
	Else
	Begin
		Insert  #MTVProfitAndLoss select * from #MTVProfitAndLoss_EAD
		Delete #MTVProfitAndLoss_EAD
	End


	-----------------------------------------------------------------------------------------------------------------------
	-- Only execute the insert for risk adjustments if the flag says to include them
	-----------------------------------------------------------------------------------------------------------------------
	If @c_RiskAdjustments = 'I'
	Begin
/*
		If @c_OnlyShowSQL = 'Y'
		Begin
			Select
			'
			Select * into #MTVProfitAndLoss_RiskAdj From #MTVProfitAndLoss where 1=2
			'
		End
		Else
		Begin
			Select * into #MTVProfitAndLoss_RiskAdj From #MTVProfitAndLoss where 1=2
		End
*/

		--------------------------------------------------------------------------------------------------------------------------------------
		-- Get any Risk Adjustments
		--------------------------------------------------------------------------------------------------------------------------------------
		Execute dbo.MTV_ProfitAndLoss_RiskAdjustment
									@i_P_EODSnpShtID		= @i_P_EODSnpShtID,
									@vc_P_PrtflioID			= @vc_P_PrtflioID,
									@i_AccntngPrdID_From		= @i_AccntngPrdID_From,
									@i_AccntngPrdID_To		= @i_AccntngPrdID_To,
									@sdt_DeliveryPeriod_From	= @sdt_DeliveryPeriod_From,
									@sdt_DeliveryPeriod_To		= @sdt_DeliveryPeriod_To,
									@vc_PrntBAID			= @vc_PrntBAID,
									@i_XGrpID			= @i_XGrpID,
									@i_AccntngPrdID_Inventory	= @i_AccntngPrdID_Inventory,
									@vc_TrnsctnTypID		= @vc_TrnsctnTypID,
									@vc_PrdctID			= @vc_PrdctID,
									@vc_LcleID			= @vc_LcleID,
									@vc_DealNumber			= @vc_DealNumber,
									@vc_DlDtlTmplteID		= @vc_DlDtlTmplteID,
									@c_IsThisNavigation 		= @c_IsThisNavigation,
									@i_RprtCnfgID			= @i_RprtCnfgID,
									@vc_AdditionalColumns		= @vc_AdditionalColumns,
									@c_OnlyShowSQL			= @c_OnlyShowSQL,

									@sdt_InstanceDateTime		= @sdt_InstanceDateTime,
									@sdt_EndOfDay			= @sdt_EndOfDay,
									@sdt_AccntngPrdBgnDte_SnapShotStart = @sdt_AccntngPrdBgnDte_SnapShotStart,
									@vc_WaterDensity		= @vc_WaterDensity


		If @c_OnlyShowSQL = 'Y'
		Begin
			Select
			'
			Insert  #MTVProfitAndLoss select * from #MTVProfitAndLoss_RiskAdj
			Delete #MTVProfitAndLoss_RiskAdj
			'
		End
		Else
		Begin
			Insert  #MTVProfitAndLoss select * from #MTVProfitAndLoss_RiskAdj
			Delete #MTVProfitAndLoss_RiskAdj
		End
	End

End

---------------------------------------------------------------------------------------------------------------------
-- The Book unrealized that were being booked in CAD need a special update. The new book unrealized process
-- will be booking in USD and will not have this issue.
---------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
If exists
	(
	Select	1
	From	#MTVProfitAndLoss
	Where	#MTVProfitAndLoss.TrnsctnTypID in (2027,2028,2029,2030)
	)
Begin

	Update	#MTVProfitAndLoss
	Set		#MTVProfitAndLoss.TotalValueFXRate = 
			(
			Select	Top 1
					1.0/V_RiskCurrencyConversion.ConversionFactor
			From	V_RiskCurrencyConversion (nolock)
			Where	V_RiskCurrencyConversion.FromCurrency	= #MTVProfitAndLoss.PaymentCrrncyID					--The From and to currency are switched because the view is currency switched.
			And		V_RiskCurrencyConversion.ToCurrency	= 19			--The From and to currency are switched because the view is currency switched.
			And		V_RiskCurrencyConversion.FromDate <= AccountingPeriod.AccntngPrdEndDte 
			And		V_RiskCurrencyConversion.RPHdrID	= ' + convert(varchar,@i_DefaultCurrencyService) + '
			And		V_RiskCurrencyConversion.ConversionFactor <> 0.0
			Order By
					V_RiskCurrencyConversion.FromDate Desc
			)
	From	#MTVProfitAndLoss
			Inner Join ManualLedgerEntryLog				On	ManualLedgerEntryLog.MnlLdgrEntryLgID = #MTVProfitAndLoss.AcctDtlSrceID
			Inner Join ManualLedgerEntryLog Original	On	Original.MnlLdgrEntryID = ManualLedgerEntryLog.MnlLdgrEntryID
														And	Original.Reversed = "N"
			Inner Join AccountingPeriod					On	AccountingPeriod.AccntngPrdID = Original.AccntngPrdID
	Where	#MTVProfitAndLoss.PaymentCrrncyID <> 19
	And		#MTVProfitAndLoss.TrnsctnTypID in (2027,2028,2029,2030) --All old book unrealized entries


	Update	#MTVProfitAndLoss
	Set		#MTVProfitAndLoss.TotalValue = #MTVProfitAndLoss.TotalValue * #MTVProfitAndLoss.TotalValueFXRate,
			#MTVProfitAndLoss.TotalPnL = #MTVProfitAndLoss.TotalPnL * #MTVProfitAndLoss.TotalValueFXRate
	Where	#MTVProfitAndLoss.PaymentCrrncyID <> 19
	And		#MTVProfitAndLoss.TrnsctnTypID in (2027,2028,2029,2030) --Exclude all old book unrealized entries
	And		#MTVProfitAndLoss.TotalValueFXRate is Not Null
End
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)




--------------------------------------------------------------------------------------------------------------------------
-- Update the DlDtlPrvsnUOMID = to DlDtlDsplyUOM for those that are null like movement expenseses and risk adjustments
--------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL =
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.DlDtlPrvsnUOMID = #MTVProfitAndLoss.DlDtlDsplyUOM
Where	#MTVProfitAndLoss.DlDtlPrvsnUOMID Is Null
And		#MTVProfitAndLoss.DlDtlDsplyUOM Is Not Null
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
-- Update the DlDtlPrvsnUOMID and DlDtlDsplyUOM for those that are null like movement expenseses and risk adjustments
-- will determine it based on commodity Crude = BBLs, Products and NGLS = MT select * from Commodity
--------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL =
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.DlDtlPrvsnUOMID = Case When Commodity.CmmdtyID = 2 Then 2 Else 11 End,
		#MTVProfitAndLoss.DlDtlDsplyUOM = Case When Commodity.CmmdtyID = 2 Then 2 Else 11 End
From	Product (NoLock)
		Inner Join Commodity (NoLock) on Commodity.CmmdtyID = Product.CmmdtyID
Where	Product.PrdctID = #MTVProfitAndLoss.PrdctID
And		(
		#MTVProfitAndLoss.DlDtlPrvsnUOMID Is Null
		Or	#MTVProfitAndLoss.DlDtlDsplyUOM Is Null
		)
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------------------------------------------
-- Delete Interim Billing transctions if we are to exclude them
--------------------------------------------------------------------------------------------------------------------------
If @c_InterimBilling = 'E'
Begin
	select	@vc_SQL =
'	Delete	#MTVProfitAndLoss
	Where	#MTVProfitAndLoss.DlDtlPrvsnActual = "I"
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End


Declare @i_LastAcctDtlID Int
select	@i_LastAcctDtlID = SnapShot.LastAcctDtlID
From	SnapShot (NoLock)
Where	SnapShot.P_EODSnpShtID = @i_P_EODSnpShtID


-----------------------------------------------------------------------------------------------------------------------------------
-- If reverse/rebooks that net to zero within an accounting period are to be excluded then delete them from the temp table
-----------------------------------------------------------------------------------------------------------------------------------
If @c_ReverseRebooks in ('E','A')
Begin
	----------------------------------------------------------------------------------------------------------------------------------------
	-- Delete accountdetails that have a XDtlStat of reversed and are the reversal accountdetails
	-- But only if they are reversing accountdetails after the accounting begin date selected in the criteria
	-- Ones that are reversals of transactions in a period before the accounting period start date in the criteria
	-- will need to be brought into the report
	-- If doing by accounting period (@c_ReverseRebooks = 'A') then make sure they have the same accounting period
	----------------------------------------------------------------------------------------------------------------------------------------
	select	@vc_SQL =
'
	Delete	#MTVProfitAndLoss
	Where	#MTVProfitAndLoss.XDtlStat = "R"
	And	#MTVProfitAndLoss.IsReversal = "Y"
	And	Exists
		(
		Select	1
		From	TransactionDetailLog (NoLock)
				Inner join AccountDetail (NoLock)	On	AccountDetail.AcctDtlID = TransactionDetailLog.XDtlLgAcctDtlID
													And	IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') >= ' + convert(varchar,@i_AccntngPrdID_From) + '
' + case When @c_ReverseRebooks = 'A' Then 'Inner Join AccountingPeriod (NoLock)	on	AccountingPeriod.AccntngPrdID = IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ')
													And	AccountingPeriod.AccntngPrdBgnDte = #MTVProfitAndLoss.AccountingPeriodStartDate
' Else '' End + '
		Where	TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
		And		TransactionDetailLog.XDtlLgXDtlXHdrID = #MTVProfitAndLoss.XHdrID
		And		TransactionDetailLog.XDtlLgXDtlID = #MTVProfitAndLoss.XDtlID
		And		TransactionDetailLog.XDtlLgRvrsd = "N"
		)
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	----------------------------------------------------------------------------------------------------------------------------------------
	-- Delete accountdetails that have a XDtlStat of reversed and have been reversed by an accoundetail before the ending accounting period
	-- to that was selected in the criteria unless there was no to selected in the criteria (@sdt_AccntngPrdID_To_Orig is null)
	-- have to use transactiondetaillog to find them b/c of bug with AcctlPrntID for movementbased
	-- If doing by accounting period (@c_ReverseRebooks = 'A') then make sure they have the same accounting period
	----------------------------------------------------------------------------------------------------------------------------------------
	select	@vc_SQL =
'
	Delete	#MTVProfitAndLoss
	Where	#MTVProfitAndLoss.XDtlStat = "R"
	And	#MTVProfitAndLoss.IsReversal = "N"
	And	#MTVProfitAndLoss.AccountingPeriodStartDate < "' +  convert(Varchar,@sdt_AccntngPrdBgnDte_SnapShotStart,120) + '"
	And	Exists
		(
		Select	1
		From	TransactionDetailLog (NoLock)
				Inner join AccountDetail (NoLock)	On	AccountDetail.AcctDtlID = TransactionDetailLog.XDtlLgAcctDtlID 
' + case When @sdt_AccntngPrdID_To_Orig is Null Then '' Else
'
													And	IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') <= ' + convert(varchar,@i_AccntngPrdID_To) + '
' End +
'
													And	IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') <= ' + convert(varchar,@i_AccntngPrdID_SnapshotStart) + '
' + case When @c_ReverseRebooks = 'A' Then '
				Inner Join AccountingPeriod (NoLock)
													on	AccountingPeriod.AccntngPrdID = IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ')
													And	AccountingPeriod.AccntngPrdBgnDte = #MTVProfitAndLoss.AccountingPeriodStartDate
' Else '' End + '
		Where	TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
		And		TransactionDetailLog.XDtlLgXDtlXHdrID = #MTVProfitAndLoss.XHdrID
		And		TransactionDetailLog.XDtlLgXDtlID = #MTVProfitAndLoss.XDtlID
		And		TransactionDetailLog.XDtlLgRvrsd = "Y"
		)
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	----------------------------------------------------------------------------------------------------------------------------------------
	-- Delete accountdetails that have a XDtlStat of reversed and have been reversed by an accoundetail before the ending
	-- accounting period in the criteria
	-- have to use transactiondetaillog to find them b/c of bug with AcctlPrntID for movementbased
	----------------------------------------------------------------------------------------------------------------------------------------
	select	@vc_SQL =
'
	Delete	#MTVProfitAndLoss
	Where	#MTVProfitAndLoss.XDtlStat = "R"
	And		#MTVProfitAndLoss.IsReversal = "N"
	--And	#MTVProfitAndLoss.AccountingPeriodStartDate >= "' +  convert(Varchar,@sdt_AccntngPrdBgnDte_SnapShotStart,120) + '"
	And	Exists
		(
		Select	1
		From	TransactionDetailLog (NoLock)
				Inner join AccountDetail (NoLock)	On	AccountDetail.AcctDtlID = TransactionDetailLog.XDtlLgAcctDtlID
' + case When @sdt_AccntngPrdID_To_Orig is Null Then '' Else
'
													And	IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') <= ' + convert(varchar,@i_AccntngPrdID_To) + '
' End +
'
													And	IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') >= ' + convert(varchar,@i_AccntngPrdID_SnapshotStart) + '
' + case When @c_ReverseRebooks = 'A' Then '
				Inner Join AccountingPeriod (NoLock)
													on	AccountingPeriod.AccntngPrdID = IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ')
													And	AccountingPeriod.AccntngPrdBgnDte = #MTVProfitAndLoss.AccountingPeriodStartDate
' Else '' End + '
				Inner Join EstimatedAccountDetail (NoLock)
													On	EstimatedAccountDetail.AcctDtlID = AccountDetail.AcctDtlID
													And	"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between EstimatedAccountDetail.StartDate And EstimatedAccountDetail.EndDate
		Where	TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
		And		TransactionDetailLog.XDtlLgXDtlXHdrID = #MTVProfitAndLoss.XHdrID
		And		TransactionDetailLog.XDtlLgXDtlID = #MTVProfitAndLoss.XDtlID
		And		TransactionDetailLog.XDtlLgRvrsd = "Y"
		)
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)




	----------------------------------------------------------------------------------------------------------------------------------------
	-- Delete AccountDetails that have reversed another accountdetail only if the one they reversed is after or equal to the
	-- from accounting period id selected in the criteria, do not attempt tax transactions
	----------------------------------------------------------------------------------------------------------------------------------------
	select	@vc_SQL =
'
	Delete	#MTVProfitAndLoss
	From	#MTVProfitAndLoss
			Inner Join AccountDetail (NoLock)	On	AccountDetail.AcctDtlID = #MTVProfitAndLoss.AcctDtlPrntID
												And	Isnull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') >= ' + Convert(Varchar,@i_AccntngPrdID_From) + '
												And	AccountDetail.AcctDtlSrceTble = #MTVProfitAndLoss.AcctDtlSrceTble
' + case When @c_ReverseRebooks = 'A' Then '
			Inner Join AccountingPeriod (NoLock)
												on	AccountingPeriod.AccntngPrdID = IsNull(AccountDetail.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ')
												And	AccountingPeriod.AccntngPrdBgnDte = #MTVProfitAndLoss.AccountingPeriodStartDate
' Else '' End + '
	Where	IsNull(#MTVProfitAndLoss.AcctDtlID,0) <> 0
	And		#MTVProfitAndLoss.AcctDtlSrceTble <> "T"
	And		#MTVProfitAndLoss.IsReversal = "Y"
	And		#MTVProfitAndLoss.XDtlStat is Null
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	----------------------------------------------------------------------------------------------------------------------------------------
	-- Delete parent accountdetails that have beeen reversed by a child and both accountdetails are before the ending accounting period
	-- selected in the criteria and before the snapshot starting period
	----------------------------------------------------------------------------------------------------------------------------------------

	
	select	@vc_SQL =
'
	Delete	#MTVProfitAndLoss
	From	#MTVProfitAndLoss
	Where	IsNull(#MTVProfitAndLoss.AcctDtlID,0) <> 0
	And		#MTVProfitAndLoss.AcctDtlSrceTble <> "T"
	And		#MTVProfitAndLoss.IsReversal = "N"
	And		#MTVProfitAndLoss.AccountingPeriodStartDate < "' +  convert(Varchar,@sdt_AccntngPrdBgnDte_SnapShotStart,120) + '"
	And		Exists
			(
			Select	1
			From	AccountDetail Reversal (NoLock)
' + case When @c_ReverseRebooks = 'A' Then '
					Inner Join AccountingPeriod (NoLock)	on	AccountingPeriod.AccntngPrdID = IsNull(Reversal.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ')
															And	AccountingPeriod.AccntngPrdBgnDte = #MTVProfitAndLoss.AccountingPeriodStartDate
' Else '' End + '
			Where	Reversal.AcctDtlPrntID = #MTVProfitAndLoss.AcctDtlID
			And		Reversal.AcctDtlSrceTble = #MTVProfitAndLoss.AcctDtlSrceTble
			And		Reversal.Reversed = "Y"
' + case when @sdt_AccntngPrdID_To_Orig is Null Then '' Else
'
			And		IsNull(Reversal.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') <= ' + convert(varchar,@i_AccntngPrdID_To) + '
' End + 
'
			And		IsNull(Reversal.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') < ' + convert(varchar,@i_AccntngPrdID_SnapshotStart) + '
		)

'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



	----------------------------------------------------------------------------------------------------------------------------------------
	-- Delete parent accountdetails that have beeen reversed by a child, and be sure the accountdetail is in the snapshot
	-- This is for account details that have been pulled in from the risk tables.  If we went back to the account detail table only
	-- we would exclude ones that were not really meant to be excluded at the time of the snapshot
	-- In order to handle month end snapshots and our nightly shell have to go to EstimatedAccountDetail
	-- Cannot rely on LastAcctDtlID or LastRunAcctDtlID on the snapshot record
	----------------------------------------------------------------------------------------------------------------------------------------


	select	@vc_SQL =
'
	Delete	#MTVProfitAndLoss
	From	#MTVProfitAndLoss
	Where	IsNull(#MTVProfitAndLoss.AcctDtlID,0) <> 0
	And		#MTVProfitAndLoss.AcctDtlSrceTble <> "T"
	And		#MTVProfitAndLoss.IsReversal = "N"
	--And	#MTVProfitAndLoss.AccountingPeriodStartDate >= "' +  convert(Varchar,@sdt_AccntngPrdBgnDte_SnapShotStart,120) + '"
	And	Exists
		(
		Select	1
		From	AccountDetail Reversal (NoLock)
' + case When @c_ReverseRebooks = 'A' Then '
				Inner Join AccountingPeriod (NoLock)
													on	AccountingPeriod.AccntngPrdID = IsNull(Reversal.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ')
													And	AccountingPeriod.AccntngPrdBgnDte = #MTVProfitAndLoss.AccountingPeriodStartDate
' Else '' End + '
				Inner Join EstimatedAccountDetail (NoLock)
													On	EstimatedAccountDetail.AcctDtlID = Reversal.AcctDtlID
													And	"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between EstimatedAccountDetail.StartDate And EstimatedAccountDetail.EndDate
		Where	Reversal.AcctDtlPrntID = #MTVProfitAndLoss.AcctDtlID
		And		Reversal.AcctDtlSrceTble = #MTVProfitAndLoss.AcctDtlSrceTble
		And		Reversal.Reversed = "Y"
' + case when @sdt_AccntngPrdID_To_Orig is Null Then '' Else
'
		And	IsNull(Reversal.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') <= ' + convert(varchar,@i_AccntngPrdID_To) + '
' End + 
'
		And	Isnull(Reversal.AcctDtlAccntngPrdID,' + convert(varchar,@i_AccntngPrdID_SnapshotStart + 1) + ') >= ' + convert(varchar,@i_AccntngPrdID_SnapshotStart) + '
		)
'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



End





--------------------------------------------------------------------------------------------------------------------------
-- Determine the delivery period for OTC option transactions that are not external (risk adjustments)
-- here matt, not sure if still necessary
--------------------------------------------------------------------------------------------------------------------------
Select @vc_SQL =
'	Update	#MTVProfitAndLoss
	Set		#MTVProfitAndLoss.DeliveryPeriodStartDate = DealDetailPrvsnAttribute.DlDtlPnAttrDta,
			#MTVProfitAndLoss.BaseMarketRwPrceLcleID = #MTVProfitAndLoss.FlatPriceRwPrceLcleID,
			#MTVProfitAndLoss.BaseMarketCurveName = #MTVProfitAndLoss.FlatPriceCurveName,
			#MTVProfitAndLoss.FlatPriceRwPrceLcleID = Null,
			#MTVProfitAndLoss.FlatPriceCurveName = Null
	From	DealDetailProvisionRow (NoLock)
			Inner Join DealDetailPrvsnAttribute (NoLock)	on	DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnID = DealDetailProvisionRow.DlDtlPrvsnID
															And	DealDetailPrvsnAttribute.RowNumber = DealDetailProvisionRow.RowNumber
															And	DealDetailPrvsnAttribute.DlDtlPnAttrPrvsnAttrTpeID = 2063 --OptionStripStartDate
	Where	DealDetailProvisionRow.DlDtlPrvsnRwID = #MTVProfitAndLoss.DlDtlPrvsnRwID
	And		#MTVProfitAndLoss.DlDtlTmplteID in (23000,23001,23100,23101,23102,23103)
	And		Isnull(#MTVProfitAndLoss.RiskSourceTable,"Z") <> "E"	
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
-- Apply Delivery Period criteria if necessary
--------------------------------------------------------------------------------------------------------------------------
If @sdt_DeliveryPeriod_From is Not Null or @sdt_DeliveryPeriod_To is Not Null
Begin
	Select @sdt_DeliveryPeriod_From = Isnull(@sdt_DeliveryPeriod_From,'1900-01-01 00:00')
	Select @sdt_DeliveryPeriod_To = Isnull(@sdt_DeliveryPeriod_To,'2049-12-31 23:59')

	Select	@vc_SQL =
'	Delete	#MTVProfitAndLoss
	Where	#MTVProfitAndLoss.DeliveryPeriodStartDate not between "' + Convert(Varchar,@sdt_DeliveryPeriod_From,120) + '" And "' + Convert(Varchar,@sdt_DeliveryPeriod_To,120) + '"
	And		Isnull(#MTVProfitAndLoss.RiskSourceTable,"Z") <> "E"
'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End


--------------------------------------------------------------------------------------------------------------------------
-- Update the Market value of the float side of swaps to be = to the total value
--------------------------------------------------------------------------------------------------------------------------
select @vc_SQL = '
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.MarketValue = TotalValue,
		#MTVProfitAndLoss.MarketValue_Override = IsNull(MarketValue_Override,TotalValue),
		#MTVProfitAndLoss.TotalValue = 0.0,
		#MTVProfitAndLoss.P_EODEstmtedAccntDtlID_Market = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID,
		#MTVProfitAndLoss.AcctDtlID_Market = #MTVProfitAndLoss.AcctDtlID,
		#MTVProfitAndLoss.BaseMarketRwPrceLcleID = #MTVProfitAndLoss.FlatPriceRwPrceLcleID,
		#MTVProfitAndLoss.BaseMarketCurveName	 = #MTVProfitAndLoss.FlatPriceCurveName
/*
,
		#MTVProfitAndLoss.FlatPriceRwPrceLcleID = Null,
		#MTVProfitAndLoss.FlatPriceCurveName	= Null
*/
Where	#MTVProfitAndLoss.CostType = "P"
And		IsNull(#MTVProfitAndLoss.RiskSourceTable,"Z") <> "E"
And		#MTVProfitAndLoss.DlDtlTmplteID in (22500,32000,32001,27001)
And		Exists
		(
		Select	1
		From	DealDetailProvision (NoLock)
				Inner Join Prvsn (NoLock)	on	Prvsn.PrvsnID	= DealDetailProvision.DlDtlPrvsnPrvsnID
											And	Prvsn.PrvsnNme	like "%float%"
		Where	DealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
		)
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



----------------------------------------------------------------------------------------------------------------------------------------------------------
-- If all reverse rebooks are excluded then put swaps on one line
----------------------------------------------------------------------------------------------------------------------------------------------------------
If @c_ReverseRebooks in ('E','A')
--If @c_ReverseRebooks in ('E')
Begin

	--------------------------------------------------------------------------------------------------------------------------
	-- Put the float side of the swaps into a temp table that also have a fixed side. This way we can know which ones
	-- we will have to put MarketValueMissing or DealValueMissing
	--------------------------------------------------------------------------------------------------------------------------
/*
#MTVProfitAndLoss_EAD.PricedInPercentage = Case When #MTVProfitAndLoss_EAD.AcctDtlID is Null Then FormulaEvaluationPercentage.PricedInPercentage else 1.0 End,
		#MTVProfitAndLoss_EAD.QuoteStartDate	= FormulaEvaluationPercentage.QuoteRangeBeginDate,
		#MTVProfitAndLoss_EAD.QuoteEndDate		= FormulaEvaluationPercentage.QuoteRangeEndDate
*/

	Select	@vc_SQL = '
	Insert	#SwapFloatSide
			(
			P_EODEstmtedAccntDtlID_Float,
			AccntDtlID_Float,
			MarketValue,
			MarketValue_Override,
			DealValueIsMissing,
			P_EODEstmtedAccntDtlID_Fixed,
			AccntDtlID_Fixed,
			UserID_OverriddenBy,
			BaseMarketRwPrceLcleID,
			BaseMarketCurveName,
			PricedInPercentage,
			QuoteStartDate,
			QuoteEndDate
			)
	Select	FloatSide.P_EODEstmtedAccntDtlID,
			FloatSide.AcctDtlID,
			FloatSide.MarketValue,
			FloatSide.MarketValue_Override,
			FloatSide.DealValueIsMissing,
			FixedSide.P_EODEstmtedAccntDtlID,
			FixedSide.AcctDtlID,
			FloatSide.UserID_OverriddenBy,
			FloatSide.BaseMarketRwPrceLcleID,
			FloatSide.BaseMarketCurveName,
			FloatSide.PricedInPercentage,
			FloatSide.QuoteStartDate,
			FloatSide.QuoteEndDate
	From	#MTVProfitAndLoss FloatSide (NoLock)
			Inner Join #MTVProfitAndLoss FixedSide (NoLock)
										On	FixedSide.DlHdrID = FloatSide.DlHdrID
										And	FixedSide.DlDtlID = FloatSide.DlDtlID
' +
Case When @c_ReverseRebooks = 'E' Then '' Else '
										And	FixedSide.AccountingPeriodStartDate = FloatSide.AccountingPeriodStartDate
										And	FixedSide.DeliveryPeriodStartDate = FloatSide.DeliveryPeriodStartDate
						' End +
'
										And	FixedSide.TransactionDate = FloatSide.TransactionDate
										And	FixedSide.CostType	= "P"
										And	IsNull(FixedSide.RiskSourceTable,"Z") <> "E"
										And	FixedSide.IsReversal = FloatSide.IsReversal
										And	Exists
										(
										Select	1
										From	DealDetailProvision (NoLock)
												Inner Join Prvsn (NoLock)	on	Prvsn.PrvsnID	= DealDetailProvision.DlDtlPrvsnPrvsnID
																			And	Prvsn.PrvsnNme	not like "%float%"
										Where	DealDetailProvision.DlDtlPrvsnID = FixedSide.DlDtlPrvsnID
										)
	Where	FloatSide.CostType = "P"
	And		IsNull(FloatSide.RiskSourceTable,"Z") <> "E"
	And		FloatSide.DlDtlTmplteID in (22500,32000,32001,27001)
	And		Exists
			(
			Select	1
			From	DealDetailProvision (NoLock)
					Inner Join Prvsn (NoLock)	on	Prvsn.PrvsnID	= DealDetailProvision.DlDtlPrvsnPrvsnID
												And	Prvsn.PrvsnNme	like "%float%"
			Where	DealDetailProvision.DlDtlPrvsnID = FloatSide.DlDtlPrvsnID
			)
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	--------------------------------------------------------------------------------------------------------------------------
	-- Update the market value for the fixed side of swaps with the float side total value
	--------------------------------------------------------------------------------------------------------------------------
	select @vc_SQL = '
	Update	#MTVProfitAndLoss
	Set		#MTVProfitAndLoss.MarketValue = #SwapFloatSide.MarketValue,
			#MTVProfitAndLoss.MarketValue_Override = #SwapFloatSide.MarketValue_Override,
			#MTVProfitAndLoss.MarketValueIsMissing = #SwapFloatSide.DealValueIsMissing,
			#MTVProfitAndLoss.P_EODEstmtedAccntDtlID_Market = #SwapFloatSide.P_EODEstmtedAccntDtlID_Float,
			#MTVProfitAndLoss.AcctDtlID_Market = #SwapFloatSide.AccntDtlID_Float,
			#MTVProfitAndLoss.UserID_OverriddenBy = #SwapFloatSide.UserID_OverriddenBy,
			#MTVProfitAndLoss.BaseMarketRwPrceLcleID = #SwapFloatSide.BaseMarketRwPrceLcleID,
			#MTVProfitAndLoss.BaseMarketCurveName	 = #SwapFloatSide.BaseMarketCurveName,
			#MTVProfitAndLoss.PricedInPercentage = 1.0 - #SwapFloatSide.PricedInPercentage,
			#MTVProfitAndLoss.QuoteStartDate = #SwapFloatSide.QuoteStartDate,
			#MTVProfitAndLoss.QuoteEndDate = #SwapFloatSide.QuoteEndDate
	From	#SwapFloatSide
	Where	Isnull(#MTVProfitAndLoss.P_EODEstmtedAccntDtlID,0) = Isnull(#SwapFloatSide.P_EODEstmtedAccntDtlID_Fixed,0)
	And		IsNull(#MTVProfitAndLoss.AcctDtlID,0) = Isnull(#SwapFloatSide.AccntDtlID_Fixed,0)
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



	--------------------------------------------------------------------------------------------------------------------------
	--Delete the float side of swaps since we are putting their value in the market value of the fixed side
	--------------------------------------------------------------------------------------------------------------------------
	select @vc_SQL = '
	Delete	#MTVProfitAndLoss
	From	#SwapFloatSide
	Where	IsNull(#MTVProfitAndLoss.P_EODEstmtedAccntDtlID,0) = IsNull(#SwapFloatSide.P_EODEstmtedAccntDtlID_Float,0)
	And		IsNull(#MTVProfitAndLoss.AcctDtlID,0) = IsNull(#SwapFloatSide.AccntDtlID_Float,0)
	' 

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	--------------------------------------------------------------------------------------------------------------------------
	-- Update the DealValueIsMissing, TotalValue, and MarketValueIsMissng for float legs that did not have a fixed leg
	--------------------------------------------------------------------------------------------------------------------------
	select @vc_SQL = '
	Update	#MTVProfitAndLoss
	Set		#MTVProfitAndLoss.MarketValueIsMissing = DealValueIsMissing,
			#MTVProfitAndLoss.DealValueIsMissing = 1
	Where	#MTVProfitAndLoss.CostType = "P"
	And		IsNull(#MTVProfitAndLoss.RiskSourceTable,"Z") <> "E"
	And		#MTVProfitAndLoss.DlDtlTmplteID in (22500,32000,32001,27001)
	And		Exists
			(
			Select	1
			From	DealDetailProvision (NoLock)
					Inner Join Prvsn (NoLock)	on	Prvsn.PrvsnID	= DealDetailProvision.DlDtlPrvsnPrvsnID
												And	Prvsn.PrvsnNme	like "%float%"
			Where	DealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
			)
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	select @vc_SQL = 'Delete #SwapFloatSide'

	If @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End

--------------------------------------------------------------------------------------------------------------------------
-- Change rows to secondary costs and update position, market value,  for provisions that are not to show position or be MTM
--------------------------------------------------------------------------------------------------------------------------
select @vc_SQL =
'
Update	#MTVProfitAndLoss
Set		PositionGallons = 0.0,
		PositionPounds = 0.0,
		MarketValue = 0.0,
		CostType = "S"
Where	Exists
		(
		Select	1
		From	DealDetailProvision
				Inner Join Prvsn	On	Prvsn.PrvsnID = DealDetailProvision.DlDtlPrvsnPrvsnID
									And	Prvsn.ExposureStatus = "N"
									And	Prvsn.MarketValueStatus = "N"
		Where	DealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
		)
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
-- Delete rows that have zero position and value
--------------------------------------------------------------------------------------------------------------------------
select @vc_SQL =
'
Delete	#MTVProfitAndLoss
Where	IsNull(Round(#MTVProfitAndLoss.PositionGallons,2),0.0) = 0.0
And		IsNull(Round(#MTVProfitAndLoss.PositionPounds,2),0.0) = 0.0
And		IsNull(Round(#MTVProfitAndLoss.TotalValue,2),0.0) = 0.0
And		IsNull(Round(#MTVProfitAndLoss.MarketValue,2),0.0) = 0.0
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
-- Delete rows that have zero value and are secondary costs
--------------------------------------------------------------------------------------------------------------------------
select @vc_SQL =
'
Delete	#MTVProfitAndLoss
Where	#MTVProfitAndLoss.DealValueIsMissing = 0
And		#MTVProfitAndLoss.TotalValue = 0.0
And		#MTVProfitAndLoss.CostType = "S"
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


-----------------------------------------------------------------------------------------------------------------------------
-- Update the ManualLedgerEntries that are for the Book Estimates process with the gravity and quantities from the InventoryReconcile
-----------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL = '
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.SpecificGravity =	InventoryReconcile.XHdrSpcfcGrvty,
		#MTVProfitAndLoss.Gravity			=	InventoryReconcile.Energy,
		#MTVProfitAndLoss.PositionGallons =	Case	When #MTVProfitAndLoss.ReceiptDelivery = "D" Then -1.0 Else 1.0 End *
												Case	When #MTVProfitAndLoss.IsReversal = "Y" Then -1.0 Else 1.0 End *
												InventoryReconcile.XhdrQty,
		#MTVProfitAndLoss.PositionPounds =		Case	When #MTVProfitAndLoss.ReceiptDelivery = "D" Then -1.0 Else 1.0 End *
												Case	When #MTVProfitAndLoss.IsReversal = "Y" Then -1.0 Else 1.0 End *
												InventoryReconcile.NetWeight,
		#MTVProfitAndLoss.ValuationGallons =	Case	When #MTVProfitAndLoss.ReceiptDelivery = "D" Then -1.0 Else 1.0 End *
												Case	When #MTVProfitAndLoss.IsReversal = "Y" Then -1.0 Else 1.0 End *
												InventoryReconcile.XhdrQty
From	#MTVProfitAndLoss (NoLock)
		Inner Join ManualLedgerEntryLog (NoLock)	On	ManualLedgerEntryLog.MnlLdgrEntryLgID = #MTVProfitAndLoss.AcctDtlSrceID
		Inner Join MTV_ManualLedgerEntry (NoLock)	On	MTV_ManualLedgerEntry.MnlLdgrEntryID = ManualLedgerEntryLog.MnlLdgrEntryID
													And	MTV_ManualLedgerEntry.Source = "E" --Book Estimates
													And	MTV_ManualLedgerEntry.Type = "O" --Original
													And	MTV_ManualLedgerEntry.RelatedMnlLdgrEntryID is Null --Last in chain
		Inner Join InventoryReconcile (NoLock)		On	InventoryReconcile.InvntryRcncleID = MTV_ManualLedgerEntry.InvntryRcncleID
Where	#MTVProfitAndLoss.AcctDtlSrceTble = "ML"
'
-- Here Matt not using custom book estimates
--if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



--------------------------------------------------------------------------------------------------------------------------
--Update the PaymentDueDate for AccountDetails that are not on an invoice, use AccountDetailEstimatedDate.EstimatedDueDate
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.PaymentDueDate = AccountDetailEstimatedDate.EstimatedDueDate
From	AccountDetailEstimatedDate (NoLock)
Where	#MTVProfitAndLoss.PurchaseInvoiceID is Null
And		#MTVProfitAndLoss.SalesInvoiceID	is Null
And		AccountDetailEstimatedDate.AcctDtlID = #MTVProfitAndLoss.AcctDtlID	
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
--Update the PaymentDueDate for AccountDetails that ARE on an sales invoice, use SalesInvoiceHeader.SlsInvceHdrDueDte
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.PaymentDueDate = SalesInvoiceHeader.SlsInvceHdrDueDte
From	SalesInvoiceHeader (NoLock)
Where	#MTVProfitAndLoss.SalesInvoiceID is Not Null
And		SalesInvoiceHeader.SlsInvceHdrID = #MTVProfitAndLoss.SalesInvoiceID	
And		SalesInvoiceHeader.SlsInvceHdrDueDte is Not Null
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------------------------------------------
--Update the PaymentDueDate for AccountDetails that ARE on an purchase invoice, use PurchaseInvoiceHeader.PrchseInvceHdrDueDte
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.PaymentDueDate = PurchaseInvoiceHeader.PrchseInvceHdrDueDte
From	PurchaseInvoiceHeader (NoLock)
Where	#MTVProfitAndLoss.PurchaseInvoiceID is Not Null
And		PurchaseInvoiceHeader.PrchseInvceHdrID = #MTVProfitAndLoss.PurchaseInvoiceID	
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------------------------------------------
--Update the PaymentDueDate for EstimatedAccountDetails
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.PaymentDueDate = EstimatedAccountDetailPayment.PaymentDueDate
From	EstimatedAccountDetailPayment (NoLock)
Where	#MTVProfitAndLoss.AcctDtlID is Null
And		EstimatedAccountDetailPayment.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID
And		"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '" Between EstimatedAccountDetailPayment.StartDate and EstimatedAccountDetailPayment.EndDate	
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
--Update the DiscountFactor
--------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
-- Update the DiscountFactor for all transactions that are
--dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types,Exchange Traded Options All Types,Futures All Types')
-- The not exists will exclude cleard swaps
----------------------------------------------------------------------------------------------
Declare @sdt_SnapShotStartAcountingPeriod SmallDateTime

select	@sdt_SnapShotStartAcountingPeriod = VETradePeriod.StartDate
From	VETradePeriod (NoLock)
Where	VETradePeriod.VETradePeriodID = @i_VETradePeriodID_SnapshotStart

select	@vc_sql =
'
Update	#MTVProfitAndLoss
Set		DiscountFactor = IsNull(DiscountFactorValue.DiscountFactor, 1.0)
From	DiscountFactor (NoLock)
		Left Outer Join DiscountFactorValue (NoLock)	On	DiscountFactor.DiscountFactorID = DiscountFactorValue.DiscountFactorID
														And	"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '" Between DiscountFactorValue.StartDate and DiscountFactorValue.EndDate
Where	#MTVProfitAndLoss.DeliveryPeriodStartDate >= #MTVProfitAndLoss.AccountingPeriodStartDate
And		#MTVProfitAndLoss.AccountingPeriodStartDate >= "' + convert(varchar,@sdt_SnapShotStartAcountingPeriod,120) + '"
And		DiscountFactor.DaysOut = DateDiff(Day,"' +  Convert(Varchar,@sdt_EndOfDay ,120) + '", #MTVProfitAndLoss.PaymentDueDate)
And		DiscountFactor.CrrncyID = IsNull(#MTVProfitAndLoss. PaymentCrrncyID,' + Convert(Varchar,@i_BaseCurrencyID) + ' )
And		#MTVProfitAndLoss.PaymentDueDate > "' + Convert(Varchar,@sdt_EndOfDay ,120) + '"
And		#MTVProfitAndLoss.DlDtlTmplteID Not In (' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types,Exchange Traded Options All Types,Futures All Types') + ')
And		Not Exists
		(
		Select	1
		From	DealHeader (NoLock)
				Inner Join UserInterFaceTemplate (NoLock)	On	UserInterFaceTemplate.UserInterfaceTemplateID = DealHeader.UserInterfaceTemplateID
															And	UserInterFaceTemplate.TemplateName like "%cleared%"
		Where	DealHeader.DlHdrID = #MTVProfitAndLoss.DlHdrID
		)
And		Not Exists
		(
		Select	1
		From	dbo.ProductInstrument	(NoLock)
		Where	ProductInstrument.PrdctId		= #MTVProfitAndLoss.PrdctID
		And		ProductInstrument.InstrumentType	= "F"
		And		ProductInstrument.DefaultSettlementType = "C"
		)
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------------
-- If this is the month end snapshot then delete any book unrealized for that month that are not reversals from the prior month
--------------------------------------------------------------------------------------------------------------------------------

If @c_MonthEndSnapShot = 'Y'
Begin
	select	@vc_sql =
	'
	Delete	#MTVProfitAndLoss
	Where	TrnsctnTypID In(2027,2028,2029,2030,2264,2265,2266,2267,2268,2269,2270,2271)
	And		VETradePeriodID_BAV = ' + Convert(Varchar,@i_VETradePeriodID_SnapshotStart) + '
	And		IsReversal = "N"
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	select	@vc_sql =
	'
	Delete	#MTVProfitAndLoss
	Where	TrnsctnTypID In(2008)
	And		VETradePeriodID_BAV = ' + Convert(Varchar,@i_VETradePeriodID_SnapshotStart) + '
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End



Set NoCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_A_SnapShot]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_ProfitAndLoss_A_SnapShot.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ProfitAndLoss_A_SnapShot >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ProfitAndLoss_A_SnapShot >>>'
	  END