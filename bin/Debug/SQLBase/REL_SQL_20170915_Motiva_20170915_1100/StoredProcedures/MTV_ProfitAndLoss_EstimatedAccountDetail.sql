/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_EstimatedAccountDetail WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_EstimatedAccountDetail.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ProfitAndLoss_EstimatedAccountDetail >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail]
							@c_ReverseRebooks		Char(1),
							@i_P_EODSnpShtID		Int,
							@vc_P_PrtflioID			Varchar(8000) = Null,
							@i_AccntngPrdID_From		Int,
							@i_AccntngPrdID_To		Int,
							@sdt_DeliveryPeriod_From	smalldatetime = Null,
							@sdt_DeliveryPeriod_To		smalldatetime = Null,
							@vc_PrntBAID			Varchar(800) = Null,
							@i_XGrpID			Int,
							@i_AccntngPrdID_Inventory	Int = Null,
							@vc_TrnsctnTypID		Varchar(8000) = Null,
							@vc_PrdctID			Varchar(8000) = Null,
							@vc_LcleID			Varchar(8000) = Null,
							@vc_DealNumber			Varchar(20)= Null,
							@vc_DlDtlTmplteID		Varchar(8000) = Null,
							@i_whatifscenario		Int = 0,
							@c_InterimBilling		Char(1)		= 'E', -- E = Excludde, I = Include
							@c_FallBackToMkt		Char(1),
							@c_IsThisNavigation 		Char(1) 	= 'N',
							@i_RprtCnfgID			Int		= Null,
							@vc_AdditionalColumns		VarChar(8000)	= Null,
							@c_OnlyShowSQL			Char(1)		= 'N',
							@sdt_InstanceDateTime		SmallDateTime,
							@i_VETradePeriodID_SnapshotStart Int,
							@vc_WaterDensity		Varchar(80),
							@sdt_EndOfDay			SmallDateTime,
							@i_DefaultCurrencyService	Int,
							@c_Compare_SnapShot		Char(1) = 'N',
							@c_MonthEndSnapShotLogic	Char(1),
							@c_InventoryValue		Char(1) = 'M', --M = Mkt Transfer at market, Z = Mkt transfer at zero, S = System
							@c_InventoryOptions		Char(1) = 'C' -- B = Beg Inv Only, C = Beg Inv with Inv change, F = Beg Inv reversed and est ending inventory
As


/*
' + case when @c_MonthEndSnapShotLogic = 'N' Then
'
							And	EstimatedAccountDetail.AccountingVETradePeriodID Between ' + convert(varchar,@i_VETradePeriodID_From) + ' And ' + Convert(Varchar,(@i_VETradePeriodID_To)) + '
'
Else
							'
							And	EstimatedAccountDetail.AccountingVETradePeriodID Between case When EstimatedAccountDetail.SourceTable in ("TT","ML") Then ' + convert(varchar,@i_VETradePeriodID_From + 1) + ' Else ' + convert(varchar,@i_VETradePeriodID_From) + ' End And ' + Convert(Varchar,(@i_VETradePeriodID_To)) + '
'
End + '
*/



Declare @vc_SQL		Varchar(8000)
Declare	@vc_SQL_Select	VarChar(8000)
Declare	@vc_SQL_From	VarChar(8000)
Declare	@vc_SQL_Where	VarChar(8000)
Declare @sdt_SnapShotStartAcountingPeriod SmallDateTime
Declare @sdt_SnapShotStartAcountingPeriodEnd SmallDateTime
Declare @i_PriceTypeSettle Int


Declare @i_VETradePeriodID_To Int
Declare @i_VETradePeriodID_From Int
Declare @i_VETradePeriodID_Inventory Int

-----------------------------------------------------------------------------------------------------------------
-- Get the TradePeriod that corresponds to the ending accountingperiod
-----------------------------------------------------------------------------------------------------------------
Select	@i_VETradePeriodID_To = PeriodTranslation.VETradePeriodID
From	PeriodTranslation (NoLock)
Where	PeriodTranslation.AccntngPrdID = @i_AccntngPrdID_To


Select	@i_VETradePeriodID_From = PeriodTranslation.VETradePeriodID
From	PeriodTranslation (NoLock)
Where	PeriodTranslation.AccntngPrdID = @i_AccntngPrdID_From


select	@sdt_SnapShotStartAcountingPeriod = VETradePeriod.StartDate,
		@sdt_SnapShotStartAcountingPeriodEnd = VETradePeriod.EndDate
From	VETradePeriod (NoLock)
Where	VETradePeriod.VETradePeriodID = @i_VETradePeriodID_SnapshotStart




-----------------------------------------------------------------------------------------------------------------
-- Build the snapshot select for the insert into the temp table
-----------------------------------------------------------------------------------------------------------------
Select	@vc_SQL_Select =
'
	Insert	#MTVProfitAndLoss_EAD
	Select	DealHeader.DlHdrIntrnlNbr,
			EstimatedAccountDetail.AcctDtlID,
			BestAvailableVolume.P_EODBAVID,
			EstimatedAccountDetail.P_EODEstmtedAccntDtlID,
			Null, --RiskID
			BestAvailableVolume.ObDlDtlDlHdrID,
			BestAvailableVolume.ObDlDtlID,
			BestAvailableVolume.PlnndTrnsfrID,
			BestAvailableVolume.ChmclParPrdctID,
			BestAvailableVolume.ChmclChdPrdctID,
			BestAvailableVolume.LcleID,
			Isnull(AccountDetail.AcctDtlMvtHdrID,BestAvailableVolume.InvntryRcncleID), --MvtHdrID, but putting InventoryReconcileID here for moment
			EstimatedAccountDetail.DlDtlPrvsnID,
			EstimatedAccountDetail.DlDtlPrvsnRwID,
			EstimatedAccountDetail.TrnsctnTypID,
			Isnull(EADVETradePeriod.StartDate,VETradePeriod.StartDate),
			Logical.StartDate,
--			Case When BestAvailableVolume.ReceiptDelivery="B" Then DateAdd(m,-1,VETradePeriod.StartDate) Else Isnull(EADVETradePeriod.StartDate,VETradePeriod.StartDate) End,
--			Case When BestAvailableVolume.ReceiptDelivery="B" Then DateAdd(m,-1,Logical.StartDate) Else Logical.StartDate End,

			Null, --StrtgyID update
			BestAvailableVolume.InternalBAID,
			IsNull(EstimatedAccountDetail.ExternalBAID, BestAvailableVolume.ExternalBAID),
			AccountDetail.AcctDtlSrceTble, --AcctDtlSrceTble
			AccountDetail.AcctDtlSrceID, --AcctDtlSrceID
			BestAvailableVolume.SourceTable,
			EstimatedAccountDetail.SourceTable,
			0.0, --ValuationGallons update from EADV
	--		0.0, --NetGallons update from BAVV
	--		0.0, --NetPounds update from BAVV
			0.0, --PositionGallons update
			0.0, --PositionPounds update
			Null, --TotalValue update from BAVV
			Null, --MarketValue update
			Null, --TotalPnL
			EstimatedAccountDetail.CrrncyID,
			19, --MarketCrncyID update
			Case When EstimatedAccountDetail.CrrncyID = 19 Then 1.0 Else Null End, --TotalValueFXRate update
			1.0, --MarketValueFXRate update
			Coalesce(DealDetail.DlDtlTmplteID,BestAvailableVolume.DlDtlTmplteID), --DlDtlTmplteID update
			Null, --SpecificGravity update
			Null, --Energy update
			EstimatedAccountDetail.CostType,
			1, --DealValueMissing update
			Case When EstimatedAccountDetail.CostType = "P" Then 1 Else 0 End, --MarketValueMissing update
			EstimatedAccountDetail.IsFlat,
			EstimatedAccountDetail.WePayTheyPay,
			EstimatedAccountDetail.IsReversal,
			BestAvailableVolume.VETradePeriodID,
--			BestAvailableVolume.VETradePeriodID - Case When BestAvailableVolume.ReceiptDelivery="B" Then 1 Else 0 End,
			Case When EstimatedAccountDetail.AttachedInHouse = "Y" Then EstimatedAccountDetail.WePayTheyPay Else BestAvailableVolume.ReceiptDelivery End,
			Case When DealHeader.DlHdrTyp in (76,77,78,79,80) Then DealDetail.DlDtlIntrnlUserID Else DealHeader.DlHdrIntrnlUserID End, --Inhouses get from deal detail
			--Case When DealDetail.DlDtlTmplteID in (32000,32001,340000,341000) Then DealDetail.DlDtlIntrnlUserID Else DealHeader.DlHdrIntrnlUserID End, -- here matt put 32001 back in
			DealHeader.DlHdrDsplyDte,
			Null, --IsPPA update
			Null,
			DealHeader.WhatIfScenario,
			Null, --DlDtlPrvsnActual, updated later
			' + Convert(Varchar,@i_P_EODSnpShtID) + ', --p_EODSnpShtID
			"' + Convert(Varchar,@sdt_EndOfDay,120) + '", --COB
			NUll, --COB compare
			Null, --p_EODSnpShtID_Compare
			0.0, --PositionGallons_Compare
			0.0, --PositionPounds_Compare
			0.0, --TotalValue_Compare
			0.0, --MarketValue_Compare
			Null, --XDtlStat
			AccountDetail.AcctDtlPrntID,
			Null, --XHdrID
			Null, --XDtlID
			AccountDetail.AcctDtlUOMID, --DlDtlPrvsnUOMID
			DealDetail.DlDtlDsplyUOM,
			NULL, --MarketVAlue_Override
			EstimatedAccountDetail.P_EODEstmtedAccntDtlID, --P_EODEstmtedAccntDtlID_Market here matt was null
			Null, --AcctDtlID_Market
			Null, --Overridden by UserID
	--		ISNull(DealHeader.DlHdrDscrptn,""),
			Null, -- P_EODEstmtedAccntDtlVleID update later
			NULL, --TotalValue_Override
			NULL, -- UserID_OverriddenBy_Trade
			NULL, --PaymentDueDate
			AccountDetail.AcctDtlSlsInvceHdrID,
			AccountDetail.AcctDtlPrchseInvceHdrID,
			1.0, --DiscountFactor
			0.0, --DiscountFactor_Compare
			Null, --FlatPriceRwPrceLcleID
			Null, --FlatPricePriceTypeIdnty
			Null, --FlatPriceCurveName
			Null, --BaseMarketRwPrceLcleID
			Null, --BaseMarketCurveName
			Null, --FormulaOffset
			Null, --FormulaPercentage
			Null, --FormulaEvaluationID
			Null, --MarketRiskCurveID
			1.0, -- PricedInPercentage
			Null, --QuoteStartDate
			Null,  --QuoteEndDate
			BestAvailableVolume.IsWriteOnWriteOff,
			0.0
	From	BestAvailableVolume (NoLock)
			Inner Join EstimatedAccountDetail (NoLock)
														On	EstimatedAccountDetail.P_EODBAVID = BestAvailableVolume.P_EODBAVID
														And	"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between EstimatedAccountDetail.StartDate And EstimatedAccountDetail.EndDate
														And	EstimatedAccountDetail.AccountingVETradePeriodID Between ' + case when @i_VETradePeriodID_SnapshotStart < @i_VETradePeriodID_From Then convert(varchar,@i_VETradePeriodID_From) Else Convert(varchar,@i_VETradePeriodID_SnapshotStart) End  + ' And ' + Convert(Varchar,(@i_VETradePeriodID_To)) + '
														And	EstimatedAccountDetail.SourceTable in ("I","ML","M","X","P","T","TT","D","B","S")
														And	Not exists
															(
															select 1
															From	#MTVProfitAndLoss (NoLock)
															Where	#MTVProfitAndLoss.AcctDtlID = EstimatedAccountDetail.AcctDtlID
															)
														And EstimatedAccountDetail.TrnsctnTypID <> 2007 -- Plug Adjustment
		Inner Join VETradePeriod (NoLock)				On	VETradePeriod.VETradePeriodID  = EstimatedAccountDetail.AccountingVETradePeriodID
		Inner Join VETradePeriod Logical (NoLock)		On	Logical.VETRadePeriodID = BestAvailableVolume.LogicalVETradePeriodID
		Left outer Join VETradePeriod EADVETradePeriod (NoLock)
														On	EADVETradePeriod.VETradePeriodID = EstimatedAccountDetail.AccountingVETradePeriodID
		Left Outer Join DealHeader (NoLock) 			On	DealHeader.DlHdrID = BestAvailableVolume.ObDlDtlDlHdrID
		Left Outer Join DealDetail (NoLock)				On	DealDetail.DlDtlDlHdrID = BestAvailableVolume.ObDlDtlDlHdrID
														And	DealDetail.DlDtlID = BestAvailableVolume.ObDlDtlID
		Left Outer Join AccountDetail (NoLock)			On	AccountDetail.AcctDtlID = EstimatedAccountDetail.AcctDtlID
'



-----------------------------------------------------------------------------------------------------------------------
-- Build the where clause
-----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------
-- Put the where clause on BestAvailable Volume
-----------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL_Where =
'
	Where	"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between BestAvailableVolume.StartDate And BestAvailableVolume.EndDate
	And		BestAvailableVolume.SourceTable in ("A","S","X","T","P","O","I"' + Case When @c_InventoryOptions = 'F' then ',"B"' else '' End + ')
	-- Here Matt, commented out to tie with OLF
	--And		BestAvailableVolume.IsWriteOnWriteOff = "N"
	--Here Matt, added to tie with OLF
	And		IsNull(BestAvailableVolume.DlDtlTmplteID, -1) not in (12000, 12001)

'


--------------------------------------------------------------------------------------------------------------------------
-- If navigated to then use the navigation temp table
--------------------------------------------------------------------------------------------------------------------------
If @c_IsThisNavigation = 'Y'
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Exists
		(
		Select	1
		From	#MTVProfitAndLoss_Navigation (NoLock)
		Where	#MTVProfitAndLoss_Navigation.P_EODEstmtedAccntDtlID = EstimatedAccountDetail.P_EODEstmtedAccntDtlID
		)
'
End


--------------------------------------------------------------------------------------------------------------------------
-- If a parent BA was passed add an exists to the where clause
--------------------------------------------------------------------------------------------------------------------------
if @vc_PrntBAID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Exists
		(
		Select	1
		From	#BAs (NoLock)
		Where	#BAs.BAID = BestAvailableVolume.InternalBAID
		)
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a transaction group was passed then add an exists to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @i_XGrpID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Exists
		(
		Select	1
		From	#TransactionTypes (NoLock)
		Where	#TransactionTypes.TrnsctnTypID = EstimatedAccountDetail.TrnsctnTypID
		)
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a transaction type was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_TrnsctnTypID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	EstimatedAccountDetail.TrnsctnTypID in (' + @vc_TrnsctnTypID + ')
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a product was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_PrdctID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	BestAvailableVolume.ChmclParPrdctID in (' + @vc_PrdctID + ')
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a locale was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_LcleID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	BestAvailableVolume.LcleID in (' + @vc_LcleID + ')
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a DealNumber was passed add an exists to the where clause
--------------------------------------------------------------------------------------------------------------------------
if @vc_DealNumber is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	DealHeader.DlHdrIntrnlNbr = "' + @vc_DealNumber + '"
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a DlDtlTmplteID was passed in add to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_DlDtlTmplteID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	DealDetail.DlDtlTmplteID in (' + @vc_DlDtlTmplteID + ')
'
End



if @c_OnlyShowSQL = 'Y'
Begin
	select @vc_SQL_Select
	select @vc_SQL_Where
End
Else
Begin
	exec( @vc_SQL_Select + @vc_SQL_Where )
End

-----------------------------------------------------------------------------------------------------------------------------------
-- Delete whatif scenarios that are not to be included
-----------------------------------------------------------------------------------------------------------------------------------

select	@vc_SQL =
'
Delete	#MTVProfitAndLoss_EAD
Where	#MTVProfitAndLoss_EAD.WhatIfScenario Is Not Null
' + Case When @i_whatifscenario <> 0 Then 'And #MTVProfitAndLoss_EAD.WhatIfScenario <> ' + Convert(Varchar,@i_whatifscenario) else '' End

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

-----------------------------------------------------------------------------------------------------------------------------------
-- Delete movement transactions that are write on/offs
-----------------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL =
'
Delete	#MTVProfitAndLoss_EAD
Where	#MTVProfitAndLoss_EAD.IsWriteOnWriteOff = "Y"
And		#MTVProfitAndLoss_EAD.RiskSourceTable = "X"
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

-------------------------------------------------------------------------------------------------------------------
-- Check to see if we are bringing back Inventory Valuation Transaction types
-- If we are bring back Ending Inventory then we need to look at the EOD to decide which month of balances
-- to keep and also to shift their accounting period back b/c we show them as ending, but they are stored
-- as beginning
-- Same goes for the inventory receipts and deliveries, except we don't mess with their dates
-------------------------------------------------------------------------------------------------------------------

-- 2004=Inv Sub Receipt,2005=Inv Sub Ending,2006=Inv Sub Delivery, 2007 = Plug adjustment
-----------------------------------------------------------------------------------------------------------
-- Delete all inventory records for the month except the one month we want to keep
-- Right now setting it always to be the accounting view (the first month of the snapshot)
-----------------------------------------------------------------------------------------------------------
If @i_AccntngPrdID_Inventory is Null
Begin
	Select @i_VETradePeriodID_Inventory = @i_VETradePeriodID_SnapshotStart
End
Else
Begin
	select	@i_VETradePeriodID_Inventory = PeriodTranslation.VETradePeriodID
	From	PeriodTranslation (NoLock)
	Where	PeriodTranslation.AccntngPrdID = @i_AccntngPrdID_Inventory
End

-----------------------------------------------------------------------------------------------------------------------
-- Delete all actual inventory builds, draws, and inventory change, regardless of the @c_InventoryOptions parameter
-----------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL='	
Delete	#MTVProfitAndLoss_EAD
Where	#MTVProfitAndLoss_EAD.RiskCostSourceTable = "S"
And		#MTVProfitAndLoss_EAD.TrnsctnTypID In (2004,2006,2032,2033)
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

----------------------------------------------------------------------------------------------------------
-- If this is the flash view, we want to only have the actual beginning and the estimated ending
----------------------------------------------------------------------------------------------------------

If @c_InventoryOptions = 'F' -- F = Flash with est inventory change
Begin

	----------------------------------------------------------------------------------------------------------
	-- Delete the actual beginning balances, except for the one that is the beginning for starting period
	----------------------------------------------------------------------------------------------------------
	Select	@vc_SQL='	
	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.RiskCostSourceTable = "S"
	And		#MTVProfitAndLoss_EAD.TrnsctnTypID = 2005
	And		#MTVProfitAndLoss_EAD.VETradePeriodID_BAV <> ' + convert(varchar,@i_VETradePeriodID_Inventory) + '
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	----------------------------------------------------------------------------------------------------------
	-- Delete the estimated beginning balances, except for the one that is the ending for starting period
	----------------------------------------------------------------------------------------------------------
	Select	@vc_SQL='	
	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.RiskCostSourceTable = "B"
	And		#MTVProfitAndLoss_EAD.TrnsctnTypID = 2005
	And		#MTVProfitAndLoss_EAD.VETradePeriodID_BAV <> ' + convert(varchar,@i_VETradePeriodID_Inventory + 1) + '
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	----------------------------------------------------------------------------------------------------------
	-- Delete Estimated Inventory Moves
	----------------------------------------------------------------------------------------------------------
	Select	@vc_SQL='	
	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.RiskCostSourceTable = "B"
	And		#MTVProfitAndLoss_EAD.TrnsctnTypID In (2004,2006,2032,2033)
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End
Else
If @c_InventoryOptions = 'A' -- A = Flash with act inventory change
Begin
	----------------------------------------------------------------------------------------------------------
	-- Delete the actual beginning balances, except for the ones that are the beginning for starting period
	-- or ending for the starting period
	----------------------------------------------------------------------------------------------------------
	Select	@vc_SQL='	
	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.RiskCostSourceTable = "S"
	And		#MTVProfitAndLoss_EAD.TrnsctnTypID = 2005
	And		#MTVProfitAndLoss_EAD.VETradePeriodID_BAV Not In (' + convert(varchar,@i_VETradePeriodID_Inventory) + ',' + convert(varchar,@i_VETradePeriodID_Inventory + 1) + ')
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	----------------------------------------------------------------------------------------------------------
	-- Delete the estimated beginning balances And Estimated inventory moves
	----------------------------------------------------------------------------------------------------------
	Select	@vc_SQL='	
	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.RiskCostSourceTable = "B"
	And		#MTVProfitAndLoss_EAD.TrnsctnTypID in (2005,2004,2006,2032,2033)
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


End
Else
If @c_InventoryOptions in ('B','C')
Begin


	----------------------------------------------------------------------------------------------------------
	-- Delete All Estimated Balances, we are always going to use actual. When crossing months before the period
	-- is closed the actual will be an "estimated" actual, but based on actuals only
	----------------------------------------------------------------------------------------------------------
	Select	@vc_SQL='	
	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.RiskCostSourceTable = "B"
	And		#MTVProfitAndLoss_EAD.TrnsctnTypID = 2005
	--And		#MTVProfitAndLoss_EAD.VETradePeriodID_BAV <> ' + convert(varchar,@i_VETradePeriodID_Inventory) + '
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



	--Select * from TransactionType where TrnsctnTypID in (2004,2006,2005,2032,2033)


	----------------------------------------------------------------------------------------------------------
	-- Delete any inventory that is incorrect accounting period
	----------------------------------------------------------------------------------------------------------
	Select	@vc_SQL='	
	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.TrnsctnTypID In (2004,2006,2005,2032,2033)
	And		#MTVProfitAndLoss_EAD.VETradePeriodID_BAV <> ' + convert(varchar,@i_VETradePeriodID_Inventory) + '
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	If @c_InventoryOptions = 'B'
	Begin
		----------------------------------------------------------------------------------------------------------
		-- Delete Estimated Inventory Moves
		----------------------------------------------------------------------------------------------------------
		Select	@vc_SQL='	
		Delete	#MTVProfitAndLoss_EAD
		Where	#MTVProfitAndLoss_EAD.RiskCostSourceTable = "B"
		And		#MTVProfitAndLoss_EAD.TrnsctnTypID In (2004,2006,2032,2033)
		'
		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
	End
End


----------------------------------------------------------------------------------------------------------------------
-- Delete any inventory for third party locations, like P66, also delete product consumption transactin type 2151
----------------------------------------------------------------------------------------------------------------------


Select	@vc_SQL='	
Delete	#MTVProfitAndLoss_EAD
Where	#MTVProfitAndLoss_EAD.TrnsctnTypID In (2004,2006,2005,2032,2033,2151)
And		Exists
		(
		Select	1
		From	Locale
		Where	Locale.LcleID = #MTVProfitAndLoss_EAD.LcleID
		And		Locale.LcleTpeID = 110
		)
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



--------------------------------------------------------------------------------------------------------------------------
--Update the DlDtlPrvsnActual column
-- Changed to use the snapshot table so snapshots do not change
--------------------------------------------------------------------------------------------------------------------------

Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.DlDtlPrvsnActual = RiskDealDetailProvision.Actual,
		#MTVProfitAndLoss_EAD.DlDtlPrvsnUOMID = Case When #MTVProfitAndLoss_EAD.DlDtlPrvsnUOMID Is Null Then RiskDealDetailProvision.UOMID Else #MTVProfitAndLoss_EAD.DlDtlPrvsnUOMID  End,
		#MTVProfitAndLoss_EAD.StrtgyID = IsNull(RiskDealDetailProvision.InHouseStrtgyID,#MTVProfitAndLoss_EAD.StrtgyID),
		#MTVProfitAndLoss_EAD.InternalBAID = IsNull(RiskDealDetailProvision.InhouseIntrnlBAID,#MTVProfitAndLoss_EAD.InternalBAID),
		#MTVProfitAndLoss_EAD.ExternalBAID = Case When RiskDealDetailProvision.TmplteSrceTpe = "EP" Then RiskDealDetailProvision.ExternalBAID Else #MTVProfitAndLoss_EAD.ExternalBAID End
From	RiskDealDetailProvision (NoLock)
Where	RiskDealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss_EAD.DlDtlPrvsnID
And		"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


/*
Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.DlDtlPrvsnActual = DealDetailProvision.Actual,
		#MTVProfitAndLoss_EAD.DlDtlPrvsnUOMID = Case When #MTVProfitAndLoss_EAD.DlDtlPrvsnUOMID Is Null Then DealDetailProvision.UOMID Else #MTVProfitAndLoss_EAD.DlDtlPrvsnUOMID  End,
		#MTVProfitAndLoss_EAD.StrtgyID = IsNull(DealDetailProvision.InhouseBAStrategyID,#MTVProfitAndLoss_EAD.StrtgyID),
		#MTVProfitAndLoss_EAD.InternalBAID = IsNull(DealDetailProvision.InhouseIntrnlBAID,#MTVProfitAndLoss_EAD.InternalBAID),
		#MTVProfitAndLoss_EAD.ExternalBAID = Case When DealDetailProvision.TmplteSrceTpe = "EP" Then DealDetailProvision.BAID Else #MTVProfitAndLoss_EAD.ExternalBAID End
From	DealDetailProvision (NoLock)
Where	DealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss_EAD.DlDtlPrvsnID
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
*/




--------------------------------------------------------------------------------------------------------------------------
-- Delete where the strtgyid is not nutll and not in the list
--------------------------------------------------------------------------------------------------------------------------
If @vc_P_PrtflioID Is Not Null
Begin
	select	@vc_SQL =
'	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.StrtgyID Is Not Null
	And		Not Exists
			(
			Select	1
			From	#Strategies (NoLock)
			Where	#Strategies.StrtgyID = #MTVProfitAndLoss_EAD.StrtgyID
			)
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End



--------------------------------------------------------------------------------------------------------------------------
-- Update the strategy on the BAVs
--------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.StrtgyID = BestAvailableVolumeStrategy.StrtgyID
From	BestAvailableVolumeStrategy (NoLock)
Where	BestAvailableVolumeStrategy.P_EODBAVID = #MTVProfitAndLoss_EAD.P_EODBAVID
And		#MTVProfitAndLoss_EAD.StrtgyID Is Null
And		"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between BestAvailableVolumeStrategy.StartDate And BestAvailableVolumeStrategy.EndDate
'

--------------------------------------------------------------------------------------------------------------------------
-- If passed a portfolio then add exist clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_P_PrtflioID Is Not Null
Begin
	Select @vc_sql = @vc_sql + '
	And	Exists
		(
		Select	1
		From	#Strategies (NoLock)
		Where	#Strategies.StrtgyID = BestAvailableVolumeStrategy.StrtgyID
		)
	'
End

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------------------------------------------
-- Delete where the strtgyid is null
--------------------------------------------------------------------------------------------------------------------------
If @vc_P_PrtflioID Is Not Null
Begin
	select	@vc_SQL =
'	Delete	#MTVProfitAndLoss_EAD
	Where	#MTVProfitAndLoss_EAD.StrtgyID Is Null
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End



--------------------------------------------------------------------------------------------------------------------------
-- Update the MvtHdrID, #MTVProfitAndLoss_EAD.MvtHdrID is really initially InvntryRcncleID
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
From	InventoryReconcile (NoLock)
		Inner Join TransactionHeader (NoLock)	On TransactionHeader.XHdrID = InventoryReconcile.InvntryRcncleSrceID
Where	InventoryReconcile.InvntryRcncleID	= #MTVProfitAndLoss_EAD.MvtHdrID
And		#MTVProfitAndLoss_EAD.AcctDtlID is Null
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



--select * from DealDetailTemplate where DlHdrTmplteID in (2000,2600,34000)
--------------------------------------------------------------------------------------------------------------------------
-- Update the Gravity and position
-- NOTE: We use the WePayTheyPay flag to determine the sign of the position for swaps and futures
-- Futures do this b/c of PVCS 11209 to work around a SolArc bug
-- Future deal detail templates are 20000 (future), 26000 (future side of EFP), 340000 and 341000 (Inhouse futures)
--------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.TransactionDate = BestAvailableVolumeVolume.EstimatedMovementDate,
		#MTVProfitAndLoss_EAD.SpecificGravity = BestAvailableVolumeVolume.SpecificGravity,
		#MTVProfitAndLoss_EAD.Energy = BestAvailableVolumeVolume.Energy,
		#MTVProfitAndLoss_EAD.PositionGallons =	
											Case	When #MTVProfitAndLoss_EAD.ReceiptDelivery = "D" And #MTVProfitAndLoss_EAD.DlDtlTmplteID Not in (22500,32000,32001,27001,20000,26000,340000,341000) Then -1.0 Else 1.0 End *
											Case	When #MTVProfitAndLoss_EAD.WePayTheyPay = "D" And #MTVProfitAndLoss_EAD.DlDtlTmplteID in (22500,32000,32001,27001,20000,26000,340000,341000) Then -1.0 Else 1.0 End *
											Case	When #MTVProfitAndLoss_EAD.IsReversal = "Y" Then -1.0 Else 1.0 End *
											BestAvailableVolumeVolume.Volume,
		#MTVProfitAndLoss_EAD.PositionPounds	=
											Case	When #MTVProfitAndLoss_EAD.ReceiptDelivery = "D" And #MTVProfitAndLoss_EAD.DlDtlTmplteID Not in (22500,32000,32001,27001,20000,26000,340000,341000) Then -1.0 Else 1.0 End *
											Case	When #MTVProfitAndLoss_EAD.WePayTheyPay = "D" And #MTVProfitAndLoss_EAD.DlDtlTmplteID in (22500,32000,32001,27001,20000,26000,340000,341000) Then -1.0 Else 1.0 End *
											Case	When #MTVProfitAndLoss_EAD.IsReversal = "Y" Then -1.0 Else 1.0 End *
											Case	When BestAvailableVolumeVolume.Weight is Not Null Then BestAvailableVolumeVolume.Weight
												Else BestAvailableVolumeVolume.Volume * BestAvailableVolumeVolume.SpecificGravity * ' + @vc_WaterDensity + '
											End,
		#MTVProfitAndLoss_EAD.IsPPA = Case When BestAvailableVolumeVolume.EstimatedMovementDate < #MTVProfitAndLoss_EAD.AccountingPeriodStartDate Then "Y" Else "N" End
From	BestAvailableVolumeVolume (NoLock)
Where	BestAvailableVolumeVolume.P_EODBAVID = #MTVProfitAndLoss_EAD.P_EODBAVID
And		"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between BestAvailableVolumeVolume.StartDate And BestAvailableVolumeVolume.EndDate
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------------------------------------------
--Overwrite the gravity for records that are inventory balances b/c SRA will have put the product typical gravity there
--instead of the real gravity
--------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.SpecificGravity = #MTVProfitAndLoss_EAD.PositionPounds / #MTVProfitAndLoss_EAD.PositionGallons / ' + @vc_WaterDensity + '
Where	#MTVProfitAndLoss_EAD.TrnsctnTypID = 2005
And		#MTVProfitAndLoss_EAD.PositionGallons <> 0.0
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
--Update the total value, DealValueMissing, and ValuationGallons
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.TotalValue =
									EstimatedAccountDetailValue.ValuationVolume * EstimatedAccountDetailValue.ForecastedPerUnitValue *
									Case When #MTVProfitAndLoss_EAD.WePayTheyPay in ("R","B") Then -1.0 Else 1.0 End *
									Case When #MTVProfitAndLoss_EAD.IsReversal = "Y" Then -1.0 Else 1.0 End,
		#MTVProfitAndLoss_EAD.DealValueIsMissing = Case When EstimatedAccountDetailValue.ValueStatus = "E" Then 1 Else 0 End,
		--#MTVProfitAndLoss_EAD.DealValueIsMissing = Case When EstimatedAccountDetailValue.ValueStatus <> "C" Then 1 Else 0 End,
		#MTVProfitAndLoss_EAD.ValuationGallons = EstimatedAccountDetailValue.ValuationVolume,
		#MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlVleID = EstimatedAccountDetailValue.P_EODEstmtedAccntDtlVleID
From	EstimatedAccountDetailValue (NoLock)
Where	EstimatedAccountDetailValue.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlID
And		"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between EstimatedAccountDetailValue.StartDate And EstimatedAccountDetailValue.EndDate
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------------------------------------------
-- Update the position columns on lease transactions that are transfers
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss_EAD
Set		PositionGallons = ValuationGallons,
		PositionPounds = ValuationGallons * SpecificGravity * ' + @vc_WaterDensity + '
Where	RiskSourceTable = "P"
And		Exists
		(
		Select	1
		From	RiskDealDetailProvision
		Where	RiskDealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss_EAD.DlDtlPrvsnID
		And		"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		And		RiskDealDetailProvision.LeaseProductSourceID is Not Null
		)
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



--------------------------------------------------------------------------------------------------------------------------
--Update the total value and the TotalValueFXRate for non USD transactions
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.TotalValue = #MTVProfitAndLoss_EAD.TotalValue * Isnull(RiskCurrencyConversionValue.ConversionValue,RiskCurrencyConversion.LatestValue),
		#MTVProfitAndLoss_EAD.TotalValueFXRate = Isnull(RiskCurrencyConversionValue.ConversionValue,RiskCurrencyConversion.LatestValue)
From	#MTVProfitAndLoss_EAD
		Inner Join RiskCurrencyConversion (nolock)
														on 	RiskCurrencyConversion.FromCurrencyID	= #MTVProfitAndLoss_EAD.PaymentCrrncyID
														And	RiskCurrencyConversion.ToCurrencyID = 19
														and	#MTVProfitAndLoss_EAD.TransactionDate between RiskCurrencyConversion.FromDate and RiskCurrencyConversion.ToDate	
		Left Outer Join RiskCurrencyConversionValue (NoLock)
														On	RiskCurrencyConversionValue.RiskCurrencyConversionID = RiskCurrencyConversion.RiskCurrencyConversionID
														And	"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between RiskCurrencyConversionValue.StartDate And RiskCurrencyConversionValue.EndDate
Where	#MTVProfitAndLoss_EAD.TrnsctnTypID Not in (2004,2006,2005,2007,2027,2028,2029,2030) --Inventory and TrnsctnTypID Not in (2027,2028,2029,2030) --Exclude all old book unrealized entries
And		#MTVProfitAndLoss_EAD.PaymentCrrncyID <> 19
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
-- Update the valuationgallons to be = to the positiongallons when it is not a provision based transaction
-- This is b/c MovementExpense, and ManualLedger Entries will always have a 1 there b/c risk treats them like flat fees
-- However, we need to be able to display a perunit on the report and will always use the valuationgallons column to do this
-- also inventory valuation eads need to have this filled in
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_sql = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.ValuationGallons = #MTVProfitAndLoss_EAD.PositionGallons
Where	#MTVProfitAndLoss_EAD.DlDtlPrvsnID is Null
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


------------------------------------------------------------------------------------------------------------------
-- Update the position to be zero on secondary costs unless they have a provision that is meant to mtm and show
-- exposure when a secondary cost
------------------------------------------------------------------------------------------------------------------
Select	@vc_sql = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.PositionGallons = 0.0
Where	#MTVProfitAndLoss_EAD.CostType = "S"
And		Not Exists
		(
		Select	1
		From	RiskDealDetailProvision
				Inner Join Prvsn	On	Prvsn.PrvsnID = RiskDealDetailProvision.DlDtlPrvsnPrvsnID
									And	Prvsn.MarketValueStatus in ("S","B")	
		Where	RiskDealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss_EAD.DlDtlPrvsnID
		And		"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '"	Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		)
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

/*
here matt
EstimatedAccountDetail
EstimatedAccountDetailValue
*/

--------------------------------------------------------------------------------------------------------------------------
--Update the market value and market currency
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.MarketValue =
				Case When UnitOfMeasure.UOMTpe = "W" then  #MTVProfitAndLoss_EAD.PositionPounds Else #MTVProfitAndLoss_EAD.PositionGallons End *
				 RiskCurveValue.BaseValue *
				IsNull((
					Select	v_UOMConversion.ConversionFactor
					From	v_UOMConversion (NoLock)
					Where	v_UOMConversion.FromUOM	= Case When UnitOfMeasure.UOMTpe = "W" Then 9 else 3 End
					And	v_UOMConversion.ToUOM	= RiskCurve.UOMID
					), 1.0),
		#MTVProfitAndLoss_EAD.MarketCrrncyID = RiskCurve.CrrncyID,
		#MTVProfitAndLoss_EAD.MarketValueIsMissing = RiskCurveValue.InformationIsMissing,
		#MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlID_Market = #MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlID,
		#MTVProfitAndLoss_EAD.MarketRiskCurveID = RiskCurve.RiskCurveID
From	#MTVProfitAndLoss_EAD
		Inner Join RiskCurveLink (NoLock)	On	RiskCurveLink.SourceID		= #MTVProfitAndLoss_EAD.P_EODBAVID
											And	RiskCurveLink.SourceTable	= 0
											And	"' + Convert(VarChar, @sdt_InstanceDateTime, 120) + '" Between RiskCurveLink.StartDate And RiskCurveLink.EndDate

		Inner Join RiskCurve (NoLock)		On	RiskCurve. RiskCurveID		= RiskCurveLink. RiskCurveID
		Inner Join RiskCurveValue (NoLock)	ON	RiskCurveValue.RiskCurveID	= RiskCurve. RiskCurveID
											And	"' + Convert(VarChar, @sdt_InstanceDateTime, 120) + '" Between RiskCurveValue.StartDate And RiskCurveValue.EndDate
		Inner Join UnitOfMeasure (NoLock)	On	UnitOfMeasure.UOM		= RiskCurve.UOMID
Where	#MTVProfitAndLoss_EAD.DlDtlTmplteID not in (22500,32000,32001,27001) --Swap Detail, Swap Inhouse Receipt, Swap Inhouse Delivery, EFS Swap Detail
--And	#MTVProfitAndLoss_EAD.CostType <> "S"
And	#MTVProfitAndLoss_EAD.PositionGallons <> 0.0
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
-- Update the Market value for those EstimatedAccountDetails that are overridden
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.MarketValue_Override = 
								Case When UnitOfMeasure.UOMTpe = "W" then  #MTVProfitAndLoss_EAD.PositionPounds Else #MTVProfitAndLoss_EAD.PositionGallons End *
								Case When #MTVProfitAndLoss_EAD.DlDtlTmplteID in (22500,32000,32001,27001) Then -1.0 Else 1.0 End *
								 MTV_RiskOverride.MarketValue *
								IsNull((
									Select	v_UOMConversion.ConversionFactor
									From	v_UOMConversion (NoLock)
									Where	v_UOMConversion.FromUOM	= Case When UnitOfMeasure.UOMTpe = "W" Then 9 else 3 End
									And	v_UOMConversion.ToUOM	= MTV_RiskOverride.MarketUOM
									), 1.0),
		#MTVProfitAndLoss_EAD.UserID_OverriddenBy = MTV_RiskOverride.UserID
From	#MTVProfitAndLoss_EAD (NoLock)
		Inner Join MTV_RiskOverride (NoLock)
												On	MTV_RiskOverride.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlID
												And	MTV_RiskOverride.EndOfDay = "' + Convert(Varchar,@sdt_EndOfDay,120) + '"
		Inner Join UnitOfMeasure (NoLock)		On	UnitOfMeasure.UOM		= MTV_RiskOverride.MarketUOM
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
-- Update the Total value for those EstimatedAccountDetailValue records that are overridden
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.TotalValue_Override = 
							Case When UnitOfMeasure.UOMTpe = "W" then  abs(#MTVProfitAndLoss_EAD.PositionPounds) Else abs(#MTVProfitAndLoss_EAD.PositionGallons) End *
							Case When #MTVProfitAndLoss_EAD.WePayTheyPay in ("R","B") Then -1.0 Else 1.0 End *
							Case When #MTVProfitAndLoss_EAD.IsReversal = "Y" Then -1.0 Else 1.0 End	*		
							MTV_RiskOverride_Trade.TradeValue *
							(
							IsNull((
								Select	v_UOMConversion.ConversionFactor
								From	v_UOMConversion (NoLock)
								Where	v_UOMConversion.FromUOM	= Case When UnitOfMeasure.UOMTpe = "W" Then 9 else 3 End
								And	v_UOMConversion.ToUOM	= MTV_RiskOverride_Trade.TradeUOM
								), 1.0)),
		#MTVProfitAndLoss_EAD.UserID_OverriddenBy_Trade = MTV_RiskOverride_Trade.UserID
From	#MTVProfitAndLoss_EAD (NoLock)
		Inner Join MTV_RiskOverride_Trade (NoLock)
												On	MTV_RiskOverride_Trade.P_EODEstmtedAccntDtlVleID = #MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlVleID
												And	MTV_RiskOverride_Trade.P_EODSnpShtID_From <= ' + Convert(Varchar,@i_P_EODSnpShtID) + '
		Inner Join UnitOfMeasure (NoLock)		On	UnitOfMeasure.UOM		= MTV_RiskOverride_Trade.TradeUOM
'


if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

------------------------------------------------------------------------------------------
-- Fallback to market for the total value where there was a valuation error if the @c_FallBackToMkt = 'Y'
--------------------------------------------------------------------------------------------
If @c_FallBackToMkt = 'Y'
Begin
	Select	@vc_SQL = 
	'
	Update	#MTVProfitAndLoss_EAD
	Set		#MTVProfitAndLoss_EAD.TotalValue = -1.0 * #MTVProfitAndLoss_EAD.MarketValue
	Where	#MTVProfitAndLoss_EAD.DealValueIsMissing = 1
	And		#MTVProfitAndLoss_EAD.UserID_OverriddenBy_Trade is Null
	And		#MTVProfitAndLoss_EAD.MarketValue is Not Null
	And		IsNull(#MTVProfitAndLoss_EAD.TotalValue,0.0) = 0.0
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End
---------------------------------------------------------------------------------------------------------------------------
-- Some special code for the future order or future fill provision of EFPs
-- If there is a quantity on the future order and no order price and no fill then make the trade price =  to the market price
-- If there is a fill quantity and no fill price then make the trade price = to the market price
---------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.TotalValue = -1 * Coalesce(#MTVProfitAndLoss_EAD.MarketValue_Override,#MTVProfitAndLoss_EAD.MarketValue)
Where	#MTVProfitAndLoss_EAD.DlDtlTmplteID = 26000
And		Exists
		(
		Select	1
		From	DealDetailProvision (NoLock)
				Inner Join DealDetailProvisionRow (NoLock)	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
															And	Convert(float,DealDetailProvisionRow.PriceAttribute2) = 0.0 -- Fixed
															And	IsNumeric(DealDetailProvisionRow.PriceAttribute2) = 1
															And	Convert(float,DealDetailProvisionRow.priceattribute1) <> 0.0 -- FillQuantity
															And	IsNumeric(DealDetailProvisionRow.PriceAttribute1) = 1
															And	DealDetailProvisionRow.DlDtlPrvsnRwID = #MTVProfitAndLoss_EAD.DlDtlPrvsnRwID
		Where	DealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss_EAD.DlDtlPrvsnID
		And		DealDetailProvision.DlDtlPrvsnPrvsnID in (77,78) -- Future Order Provision, Time Based Future Fill
		)
'
-- here Matt.  Not executing b/c BP does not do EFPs
--if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--here matt comment this

Select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.MarketValueIsMissing = Case When #MTVProfitAndLoss_EAD.DeliveryPeriodStartDate < #MTVProfitAndLoss_EAD.AccountingPeriodStartDate Then 0 Else 1 End
Where	#MTVProfitAndLoss_EAD.MarketValue Is Null
And		#MTVProfitAndLoss_EAD.CostType <> "S"
And		#MTVProfitAndLoss_EAD.DlDtlTmplteID Not in (22500,32000,32001,27001)
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
-- If the end of day is greater than the last day of the starting month of the snapshot and the title has transfered (Movement has occurred)
-- then make the market price zero, as we are crossing months and since we have both sides we do not need a market value
-- If one or both sides has not completed pricing an accrual will be booked using the book estimates functionality
--------------------------------------------------------------------------------------------------------------------------
If @sdt_EndOfDay > @sdt_SnapShotStartAcountingPeriodEnd
Begin
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		#MTVProfitAndLoss_EAD.MarketValueIsMissing = 0,
			#MTVProfitAndLoss_EAD.MarketValue_Override = Null,
			#MTVProfitAndLoss_EAD.MarketValue = 0.0
	Where	#MTVProfitAndLoss_EAD.DeliveryPeriodStartDate = "' + Convert(Varchar,@sdt_SnapShotStartAcountingPeriod,120) + '"
	And		#MTVProfitAndLoss_EAD.AccountingPeriodStartDate = "' + Convert(Varchar,@sdt_SnapShotStartAcountingPeriod,120) + '"
	And		#MTVProfitAndLoss_EAD.MvtHdrID is Not Null
	'
	/* Here Matt, commenting out for ??? to tie to OLF report
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
	*/
End



--------------------------------------------------------------------------------------------------------------------------
-- Due to Bug found on movement based AccountDetails that are reversed sometimes not pointing back to the accountdetail
-- they are reversing we have to get the XDtlStat
-- here matt, may not need this anymore b/c I gave up on taxes
--------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL = '
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.XDtlStat = TransactionDetail.XDtlStat,
		#MTVProfitAndLoss_EAD.XHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID,
		#MTVProfitAndLoss_EAD.XDtlID = TransactionDetail.XDtlID
From	TransactionDetailLog (NoLock)
		Inner Join TransactionDetail (NoLock)	On	TransactionDetail.XDtlXHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
												And	TransactionDetail.XDtlDlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
												And	TransactionDetail.XDtlID = TransactionDetailLog.XDtlLgXDtlID
Where	TransactionDetailLog.XDtlLgID = #MTVProfitAndLoss_EAD.AcctDtlSrceID
And		#MTVProfitAndLoss_EAD.AcctDtlSrceTble = "X"
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


---------------------------------------------------------------------------------------------------------
--	Update the FlatPriceRwPrceLcleID, FlatPriceCurveName, FormulaOffset, and FormulaPercentage
---------------------------------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.FlatPriceRwPrceLcleID = Convert(Int,DealDetailProvisionRow.PriceAttribute3),
		#MTVProfitAndLoss_EAD.FlatPricePriceTypeIdnty = Convert(Int,DealDetailProvisionRow.PriceAttribute7),
		#MTVProfitAndLoss_EAD.FlatPriceCurveName = RawPriceLocale.CurveName,
		#MTVProfitAndLoss_EAD.FormulaPercentage = Convert(Float,DealDetailProvisionRow.PriceAttribute1),
		#MTVProfitAndLoss_EAD.FormulaOffset = Convert(Float,DealDetailProvisionRow.PriceAttribute2),
		#MTVProfitAndLoss_EAD.FormulaEvaluationID = EstimatedAccountDetailRisk.FormulaEvaluationID
From	#MTVProfitAndLoss_EAD
		Inner Join EstimatedAccountDetailRisk (NoLock)	On EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlID
														And		"' + Convert(Varchar,@sdt_InstanceDateTime,120) + '" Between EstimatedAccountDetailRisk.StartDate And EstimatedAccountDetailRisk.EndDate
		Inner Join DealDetailProvisionRow (NoLock)	On	IsNumeric(DealDetailProvisionRow.PriceAttribute3) = 1
														And	IsNumeric(DealDetailProvisionRow.PriceAttribute1) = 1
														And	IsNumeric(DealDetailProvisionRow.PriceAttribute2) = 1
														And	IsNumeric(DealDetailProvisionRow.PriceAttribute7) = 1
														And DealDetailProvisionRow.DlDtlPrvsnRwID = EstimatedAccountDetailRisk.DlDtlPrvsnRwID
														And	DealDetailProvisionRow.DlDtlPRvsnRwTpe = "F"
		Inner Join RawPriceLocale (NoLock)			On	RawPriceLocale.RwPrceLcleID = Convert(Int,DealDetailProvisionRow.PriceAttribute3)
													And	RawPriceLocale.IsBasisCurve = 0
Where	#MTVProfitAndLoss_EAD.PositionGallons <> 0
'


if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


---------------------------------------------------------------------------------------------------------
--	Update the product, location, and market value of the future side of the simulated 
--  in-house EFP so that it is marked to the market value of the first nearby future contract
---------------------------------------------------------------------------------------------------------

Select	@vc_SQL =
'
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.MarketValue =
				Case When UnitOfMeasure.UOMTpe = "W" then  #MTVProfitAndLoss_EAD.PositionPounds Else #MTVProfitAndLoss_EAD.PositionGallons End *
				 RiskCurveValue.BaseValue *
				IsNull((
					Select	v_UOMConversion.ConversionFactor
					From	v_UOMConversion (NoLock)
					Where	v_UOMConversion.FromUOM	= Case When UnitOfMeasure.UOMTpe = "W" Then 9 else 3 End
					And	v_UOMConversion.ToUOM	= RiskCurve.UOMID
					), 1.0),
		#MTVProfitAndLoss_EAD.MarketCrrncyID = RiskCurve.CrrncyID,
		#MTVProfitAndLoss_EAD.MarketValueIsMissing = RiskCurveValue.InformationIsMissing,
		#MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlID_Market = #MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlID,
		#MTVProfitAndLoss_EAD.MarketRiskCurveID = RiskCurve.RiskCurveID,
		#MTVProfitAndLoss_EAD.PrdctID = RiskCurve.PrdctID,
		#MTVProfitAndLoss_EAD.ChildPrdctID = RiskCurve.ChmclID,
		#MTVProfitAndLoss_EAD.LcleID = RiskCurve.LcleID,
		#MTVProfitAndLoss_EAD.DeliveryPeriodStartDate = RiskCurve.TradePeriodFromDate
From	#MTVProfitAndLoss_EAD	
		Inner Join RiskCurve (NoLock)		On	RiskCurve.RwPrceLcleID	= #MTVProfitAndLoss_EAD.FlatPriceRwPrceLcleID
											And	RiskCurve.PrceTpeIdnty = #MTVProfitAndLoss_EAD.FlatPricePriceTypeIdnty
											And	RiskCurve.IsMarketCurve = 1
											And	RiskCurve.VETradePeriodID =
											(
											Select	Top 1
													PricingPeriodCategoryVETradePeriod.VETradePeriodID
											From	RawPriceLocalePricingPeriodCategory (NoLock)
													Inner Join PricingPeriodCategoryVETradePeriod (NoLock)
																			On	PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID = RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID
																			And	#MTVProfitAndLoss_EAD.TransactionDate Between PricingPeriodCategoryVETradePeriod.RollOnBoardDate And PricingPeriodCategoryVETradePeriod.RollOffBoardDate					
											Where	RawPriceLocalePricingPeriodCategory.RwPrceLcleID = #MTVProfitAndLoss_EAD.FlatPriceRwPrceLcleID
											And		RawPriceLocalePricingPeriodCategory.IsUsedForSettlement = 1
											Order	By PricingPeriodCategoryVETradePeriod.RollOffBoardDate Asc
											)
		Inner Join RiskCurveValue (NoLock)	ON	RiskCurveValue.RiskCurveID	= RiskCurve. RiskCurveID
											And	"' + Convert(VarChar, @sdt_InstanceDateTime, 120) + '" Between RiskCurveValue.StartDate And RiskCurveValue.EndDate
		Inner Join UnitOfMeasure (NoLock)	On	UnitOfMeasure.UOM		= RiskCurve.UOMID
Where	Exists
		(
		Select	1
		From	RiskDealDetailProvision
		Where	RiskDealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss_EAD.DlDtlPrvsnID
		And		RiskDealDetailProvision.DlDtlPrvsnPrvsnID = 350 --IHRuleEFPFuture
		And	"' + Convert(VarChar, @sdt_InstanceDateTime, 120) + '" Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		)
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



---------------------------------------------------------------------------------------------------------
--	Update the MarketRwPrceLcleID, MarketCurveName
--  There is a one to many relationship b/t RiskCurve and RiskCurveExposure, but we are only always expecting
--	one and if two we will just take one
---------------------------------------------------------------------------------------------------------
Select	@vc_SQL = 
'
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.BaseMarketRwPrceLcleID = RiskCurve.RwPrceLcleID, -- ,#MTVProfitAndLoss_EAD.FlatPriceRwPrceLcleID),
		#MTVProfitAndLoss_EAD.BaseMarketCurveName = RawPriceLocale.CurveName --,#MTVProfitAndLoss_EAD.FlatPriceCurveName)
From	RiskCurveExposure (NoLock)
		Inner Join RiskCurve (NoLock)		On	RiskCurve.RiskCurveID = RiskCurveExposure.ChildRiskCurveID
		Inner Join RawPriceLocale (NoLock)	On	RawPriceLocale.RwPrceLcleID = RiskCurve.RwPrceLcleID
											And	RawPriceLocale.IsBasisCurve = 0
Where	RiskCurveExposure.RiskCurveID = #MTVProfitAndLoss_EAD.MarketRiskCurveID
And		#MTVProfitAndLoss_EAD.BaseMarketRwPrceLcleID Is Null
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------
-- Update the base market
--------------------------------------------------------------------------------------

Select	@vc_SQL = 
'
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.BaseMarketRwPrceLcleID = RawPriceLocale.RwPrceLcleID,
		#MTVProfitAndLoss_EAD.BaseMarketCurveName = RawPriceLocale.CurveName
From	#MTVProfitAndLoss_EAD
		Inner Join Product (NoLock)			On Product.PrdctID = #MTVProfitAndLoss_EAD.PrdctID
											And Product.PrdctSbTyp = "F"
		Inner	Join DealDetail (NoLock)	On DealDetail.DlDtlDlHdrID = #MTVProfitAndLoss_EAD.DlHdrID
											And	DealDetail.DlDtlID = #MTVProfitAndLoss_EAD.DlDtlID
		Inner Join RawPriceLocale (NoLock)	On	RawPriceLocale.RPLcleRPHdrID = DealDetail.RPHdrID
											And RawPriceLocale.RPLcleChmclParPrdctID = DealDetail.DlDtlPrdctID
											And RawPriceLocale.RPLcleChmclChdPrdctID = DealDetail.DlDtlPrdctID
											And	RawPriceLocale.RPLcleLcleID = DealDetail.DlDtlLcleID

'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------------------------------
-- Determine the priced in percentage
--------------------------------------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss_EAD
Set		#MTVProfitAndLoss_EAD.PricedInPercentage = Case When #MTVProfitAndLoss_EAD.AcctDtlID is Null Then FormulaEvaluationPercentage.PricedInPercentage else 1.0 End,
		#MTVProfitAndLoss_EAD.QuoteStartDate	= FormulaEvaluationPercentage.QuoteRangeBeginDate,
		#MTVProfitAndLoss_EAD.QuoteEndDate		= FormulaEvaluationPercentage.QuoteRangeEndDate
From	FormulaEvaluationPercentage (NoLock)
Where	FormulaEvaluationPercentage.FormulaEvaluationID = #MTVProfitAndLoss_EAD.FormulaEvaluationID
And		#MTVProfitAndLoss_EAD.COB Between FormulaEvaluationPercentage.EndOfDayStartDate And FormulaEvaluationPercentage.EndOfDayEndDate
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


------------------------------------------------------------------------------------------------------------------------
-- If the inventory is to be shown as valued at market, then update the following transactions types total value,
-- But keep the system value
-- 2004 = Inventory Subledger Receipt
-- 2006 = Inventory Subledger Delivery
-- 2033 = Risk - Inventory Change - Delivery
-- Update 2032 = Risk - Inventory Change - Receipt to the market value of the Planned Transfer it is associated with
-- IsWriteOnWriteOff will be valued at zero for all
------------------------------------------------------------------------------------------------------------------------
--select * from TransactionType where TrnsctnTypID In (2004,2006,2032,2033)

If @c_InventoryValue = 'M'
Begin
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		SystemInventoryValue = TotalValue,
			TotalValue = -1 * MarketValue
	Where	#MTVProfitAndLoss_EAD.TrnsctnTypID In (2004,2006,2032,2033)
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	-------------------------------------------------------------------------------------------------
	-- Update the Risk - Inventory Change - Receipt, this makes the inventory change value = market
	-- of where the build occurred so that we show the gain in MTM value of moving product from one
	-- location to another
	-------------------------------------------------------------------------------------------------
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		#MTVProfitAndLoss_EAD.TotalValue = - 1 *
					Case When UnitOfMeasure.UOMTpe = "W" then  #MTVProfitAndLoss_EAD.PositionPounds Else #MTVProfitAndLoss_EAD.PositionGallons End *
					 RiskCurveValue.BaseValue *
					IsNull((
						Select	v_UOMConversion.ConversionFactor
						From	v_UOMConversion (NoLock)
						Where	v_UOMConversion.FromUOM	= Case When UnitOfMeasure.UOMTpe = "W" Then 9 else 3 End
						And	v_UOMConversion.ToUOM	= RiskCurve.UOMID
						), 1.0)
	From	#MTVProfitAndLoss_EAD
			Inner Join BestAvailableVolume BavInvRec
												On  BavInvRec.P_EODBAVID = #MTVProfitAndLoss_EAD.P_EODBAVID
			Inner Join BestAvailableVolume		On	BestAvailableVolume.PlnndTrnsfrID = #MTVProfitAndLoss_EAD.PlnndTrnsfrID
												And	"' + Convert(VarChar, @sdt_InstanceDateTime, 120) + '" Between BestAvailableVolume.StartDate And	BestAvailableVolume.EndDate
												And	BestAvailableVolume.P_EODBAVID <> #MTVProfitAndLoss_EAD.P_EODBAVID
												And	BestAvailableVolume.PlnndTrnsfrID = BavInvRec.PlnndTrnsfrID
												And	IsNull(BestAvailableVolume.InvntryRcncleID,0) = IsNull(BavInvRec.InvntryRcncleID,0)
												--And	BestAvailableVolume.LcleID <> #MTVProfitAndLoss_EAD.LcleID
			Inner Join RiskCurveLink (NoLock)	On	RiskCurveLink.SourceID		= BestAvailableVolume.P_EODBAVID
												And	RiskCurveLink.SourceTable	= 0
												And	"' + Convert(VarChar, @sdt_InstanceDateTime, 120) + '" Between RiskCurveLink.StartDate And RiskCurveLink.EndDate

			Inner Join RiskCurve (NoLock)		On	RiskCurve. RiskCurveID		= RiskCurveLink. RiskCurveID
			Inner Join RiskCurveValue (NoLock)	ON	RiskCurveValue.RiskCurveID	= RiskCurve. RiskCurveID
												And	"' + Convert(VarChar, @sdt_InstanceDateTime, 120) + '" Between RiskCurveValue.StartDate And RiskCurveValue.EndDate
			Inner Join UnitOfMeasure (NoLock)	On	UnitOfMeasure.UOM		= RiskCurve.UOMID
	Where	#MTVProfitAndLoss_EAD.TrnsctnTypID = 2032
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		TotalValue = 0
	Where	#MTVProfitAndLoss_EAD.IsWriteOnWriteOff = "Y"
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


End

	
If @c_InventoryValue = 'Z'
Begin
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		SystemInventoryValue = TotalValue,
			TotalValue = 0
	Where	#MTVProfitAndLoss_EAD.TrnsctnTypID In (2004,2006,2032,2033)
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End

If @c_InventoryValue In ('M','Z')
Begin
	---------------------------------------------------------------------------------------------------------------------------
	-- Get the value for the beginning balances to be market on the last day of the month
	---------------------------------------------------------------------------------------------------------------------------
	Declare @i_OverrideRPHdrID Int
	-------------------------------------------------------------------------------------------------------------------------
	-- Check for a market override
	-------------------------------------------------------------------------------------------------------------------------
	Select	@i_OverrideRPHdrID = 228

	Declare @sdt_LastDayOfPriorMonth SmallDateTime

	-------------------------------------------------------------------------------------------------------------------------
	-- Get the last business of the month
	-------------------------------------------------------------------------------------------------------------------------	
	Select	@sdt_LastDayOfPriorMonth = DateAdd(d,-1,StartDate)
	From	VETradePeriod
	Where	VETradePeriod.VETradePeriodID = @i_VETradePeriodID_Inventory

	
	---------------------------------------------------------------------------------------------------------------------------
	-- Set the value for the beginning balances to be market on the last day of the month
	---------------------------------------------------------------------------------------------------------------------------
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		SystemInventoryValue = TotalValue,
			TotalValue = 0.0
	Where	#MTVProfitAndLoss_EAD.TrnsctnTypID = 2005
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	---------------------------------------------------------------------------------------------------------------------------
	-- If there is an override, then use it
	---------------------------------------------------------------------------------------------------------------------------
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		#MTVProfitAndLoss_EAD.TotalValue = -1 * Case When UnitOfMeasure.UOMTpe = "W" then  #MTVProfitAndLoss_EAD.PositionPounds Else #MTVProfitAndLoss_EAD.PositionGallons End *
					 RawPrice.RPVle *
					IsNull((
						Select	v_UOMConversion.ConversionFactor
						From	v_UOMConversion (NoLock)
						Where	v_UOMConversion.FromUOM	= Case When UnitOfMeasure.UOMTpe = "W" Then 9 else 3 End
						And	v_UOMConversion.ToUOM	= RawPriceDetail.RPDtlUOM
						), 1.0)
	From	RawPriceDetail
			Inner Join dbo.RawPrice On	RawPrice.RPRPDtlIdnty = RawPriceDetail.Idnty
									And	RawPrice.RPPrceTpeIdnty = 9 --Market Price Type
			Inner Join UnitOfMeasure on UnitOfMeasure.UOM = RawPriceDetail.RPDtlUOM
	Where	RawPriceDetail.RPDtlRPLcleRPHdrID = ' + Convert(Varchar,@i_OverrideRPHdrID) + '
	And		RawPriceDetail.RPDtlRPLcleChmclParPrdctID = #MTVProfitAndLoss_EAD.PrdctID
	And		RawPriceDetail.RPDtlRPLcleChmclChdPrdctID = #MTVProfitAndLoss_EAD.ChildPrdctID
	And		RawPriceDetail.RPDtlRPLcleLcleID = #MTVProfitAndLoss_EAD.LcleID
	And		"' + Convert(VarChar, @sdt_LastDayOfPriorMonth, 120) + '" Between RawPriceDetail.RPDtlQteFrmDte And RawPriceDetail.RPDtlQteToDte
	And		#MTVProfitAndLoss_EAD.TrnsctnTypID = 2005		
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	Declare @sdt_LastMonthInstanceDateTime SmallDateTime
	-----------------------------------------------------------------------------------------------------------------------------
	-- Look up last month end snapshot
	-----------------------------------------------------------------------------------------------------------------------------
	Select @sdt_LastMonthInstanceDateTime = InstanceDateTime
	From	[Snapshot]
	Where	StartedFromVETradePeriodID = @i_VETradePeriodID_Inventory - 1
	And		IsAsOfSnapshot = 'Y'


	---------------------------------------------------------------------------------------------------------------------------
	--
	---------------------------------------------------------------------------------------------------------------------------
	Select	@vc_SQL =
	'
	Update	#MTVProfitAndLoss_EAD
	Set		#MTVProfitAndLoss_EAD.TotalValue = - 1 *
					Case When UnitOfMeasure.UOMTpe = "W" then  #MTVProfitAndLoss_EAD.PositionPounds Else #MTVProfitAndLoss_EAD.PositionGallons End *
					 RiskCurveValue.BaseValue *
					IsNull((
						Select	v_UOMConversion.ConversionFactor
						From	v_UOMConversion (NoLock)
						Where	v_UOMConversion.FromUOM	= Case When UnitOfMeasure.UOMTpe = "W" Then 9 else 3 End
						And	v_UOMConversion.ToUOM	= RiskCurve.UOMID
						), 1.0	)
	From	#MTVProfitAndLoss_EAD
			Inner Join BestAvailableVolume		On	BestAvailableVolume.P_EODBAVID = #MTVProfitAndLoss_EAD.P_EODBAVID
			Inner Join RiskCurve (NoLock)		On	RiskCurve.RwPrceLcleID		= BestAvailableVolume.MarketRwPrceLcleID
												And	RiskCurve.VETradePeriodID = ' + Convert(Varchar,@i_VETradePeriodID_Inventory - 1) + '						
			Inner Join RiskCurveValue (NoLock)	ON	RiskCurveValue.RiskCurveID	= RiskCurve. RiskCurveID
												And	"' + Convert(VarChar, @sdt_LastMonthInstanceDateTime, 120) + '" Between RiskCurveValue.StartDate And RiskCurveValue.EndDate
			Inner Join UnitOfMeasure (NoLock)	On	UnitOfMeasure.UOM		= RiskCurve.UOMID
	Where	#MTVProfitAndLoss_EAD.TrnsctnTypID = 2005
	And		#MTVProfitAndLoss_EAD.TotalValue = 0

	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End

If @c_InventoryOptions in ('F','A')
Begin

	--------------------------------------------------------------------------------------------------------------------------
	--Update the market value to zero on ending and reverse it
	--------------------------------------------------------------------------------------------------------------------------
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		MarketValue = 0.0,
			MarketValue_Override = 0.0,
			PositionGallons = -PositionGallons,
			PositionPounds = -PositionPounds,
			ValuationGallons = -ValuationGallons,
			TotalValue = -TotalValue
	Where	VETradePeriodID_BAV = ' + convert(varchar,@i_VETradePeriodID_Inventory + 1) + '
	And		TrnsctnTypID = 2005
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	--------------------------------------------------------------------------------------------------------------------------
	--Update the market value to zero on the beginning balance
	--------------------------------------------------------------------------------------------------------------------------
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		MarketValue = 0.0,
			MarketValue_Override = 0.0
	Where	VETradePeriodID_BAV = ' + convert(varchar,@i_VETradePeriodID_Inventory) + '
	And		TrnsctnTypID = 2005
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	--------------------------------------------------------------------------------------------------------------------------
	--Update the market value on purchase and sales in month of beginning inventory
	--------------------------------------------------------------------------------------------------------------------------
	Select	@vc_SQL = '
	Update	#MTVProfitAndLoss_EAD
	Set		MarketValue = 0.0,
			MarketValue_Override = 0.0
	Where	VETradePeriodID_BAV = ' + convert(varchar,@i_VETradePeriodID_Inventory) + '	
	And		CostType = "P"
	And		RiskSourceTable in ("P","X","A")
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	--------------------------------------------------------------------------------------------------------------------------
	-- Delete out forward lease purchase positions
	--------------------------------------------------------------------------------------------------------------------------
	Select	@vc_SQL = '
	Delete	#MTVProfitAndLoss_EAD
	Where	VETradePeriodID_BAV > ' + convert(varchar,@i_VETradePeriodID_Inventory) + '	
	And		TrnsctnTypID = 2107
	'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End

---------------------------------------------------------------------------------------------------------------------
-- Delete any transactions that are movement based (PlnndTrnsfrID is not null), secondary costs, and are in the future
-- And positiongallons = 0 (this means we are not marking to market and it will be set earlier looking at marketvaluestatus
-- on the prvsn table
---------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Delete	#MTVProfitAndLoss_EAD
From	#MTVProfitAndLoss_EAD
Where	VETradePeriodID_BAV > ' + convert(varchar,@i_VETradePeriodID_Inventory) + '	
And		PlnndTrnsfrID is Not Null
And		CostType = "S"
And		RiskSourceTable in ("P","X")
And		PositionGallons = 0
And		Exists
		(
		Select	1
		From	EstimatedAccountDetail
		Where	EstimatedAccountDetail.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss_EAD.P_EODEstmtedAccntDtlID
		And		EstimatedAccountDetail.IsInventoryRelated = "Y"
		And		EstimatedAccountDetail.AttachedInHouse = "N"
		)
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



---------------------------------------------------------------------------------------------------------------------
-- Update the market value of the future side of the in-house rule EFP. In-house rules will naturally mark to physical
-- we want to mark these to the underlying future that the formula tablet references
---------------------------------------------------------------------------------------------------------------------

--FlatPriceRwPrceLcleID


Set NoCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_ProfitAndLoss_EstimatedAccountDetail.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ProfitAndLoss_EstimatedAccountDetail >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ProfitAndLoss_EstimatedAccountDetail >>>'
	  END