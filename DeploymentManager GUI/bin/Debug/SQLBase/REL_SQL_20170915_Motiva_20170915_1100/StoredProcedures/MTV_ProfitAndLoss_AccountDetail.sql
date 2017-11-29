/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_AccountDetail WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_ProfitAndLoss_AccountDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_AccountDetail.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_AccountDetail]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ProfitAndLoss_AccountDetail] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ProfitAndLoss_AccountDetail >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ProfitAndLoss_AccountDetail]
							@c_ReverseRebooks		char(1),
							@i_P_EODSnpShtID		Int,
							@vc_P_PrtflioID			Varchar(8000) = Null,
							@i_AccntngPrdID_From		Int,
							@i_AccntngPrdID_To		Int,
							@sdt_DeliveryPeriod_From	smalldatetime = Null,
							@sdt_DeliveryPeriod_To		smalldatetime = Null,
							@vc_PrntBAID			Varchar(8000) = Null,
							@i_XGrpID			Int,
							@i_AccntngPrdID_Inventory	Int = Null,
							@vc_TrnsctnTypID		Varchar(8000) = Null,
							@vc_PrdctID			Varchar(8000) = Null,
							@vc_LcleID			Varchar(8000) = Null,
							@vc_DealNumber			Varchar(20)= Null,
							@vc_DlDtlTmplteID		Varchar(8000) = Null,
							@c_InterimBilling		Char(1)		= 'E', -- E = Excludde, I = Include
							@c_IsThisNavigation 		Char(1) 	= 'N',
							@i_RprtCnfgID			Int		= Null,
							@vc_AdditionalColumns		VarChar(8000)	= Null,
							@c_OnlyShowSQL			Char(1)		= 'N',
							@sdt_InstanceDateTime		SmallDateTime,
							@sdt_EndOfDay			SmallDateTime,
							@i_AccntngPrdID_To_AccountDetailWhere Int,
							@vc_WaterDensity		Varchar(80),
							@i_DefaultCurrencyService	Int,
							@c_MonthEndSnapShotLogic	Char(1)
							

As
Declare @vc_SQL		Varchar(8000)
Declare	@vc_SQL_Select	VarChar(8000)
Declare	@vc_SQL_From	VarChar(8000)
Declare	@vc_SQL_Where	VarChar(8000)


-----------------------------------------------------------------------------------------------------------------
-- Build the AccountDetail select for the insert into the temp table
-----------------------------------------------------------------------------------------------------------------
Select	@vc_SQL_Select =
'
	Insert	#MTVProfitAndLoss
	Select	DealHeader.DlHdrIntrnlNbr,
			AccountDetail.AcctDtlID,
			Null, --P_EODBAVID
			Null, --P_EODEstmtedAccntDtlID
			Null, --RiskID
			AccountDetail.AcctDtlDlDtlDlHdrID,
			AccountDetail.AcctDtlDlDtlID,
			AccountDetail.AcctDtlPlnndTrnsfrID,
			AccountDetail.ParentPrdctID,
			AccountDetail.ChildPrdctID,
			AccountDetail.AcctDtlLcleID,
			AccountDetail.AcctDtlMvtHdrID,
			Null, --DlDtlPrvsnID update
			Null, --DlDtlPrvsnRwID update
			AccountDetail.AcctDtlTrnsctnTypID,
			AccountingPeriod.AccntngPrdBgnDte,
			Case When DealDetail.DlDtlTmplteID in (20000,21000,26000) Then DealDetail.DlDtlFrmDte Else AccountDetail.AcctDtlTrnsctnDte End,
			AccountDetail.AcctDtlStrtgyID,
			AccountDetail.InternalBAID,
			AccountDetail.ExternalBAID,
			AccountDetail.AcctDtlSrceTble,
			AccountDetail.AcctDtlSrceID,
			Null,--RiskSourceTable
			Null,--RiskCostSourceTable,
			AccountDetail.Volume, --ValuationVolume
			0.0, --PositionGallons
			0.0, --PositionPounds
			AccountDetail.Value,
			0.0, --MarketValue,
			AccountDetail.Value, -- TotalPnL
			AccountDetail.CrrncyID,
			AccountDetail.CrrncyID,
			1.0, --TotalValueFXRate
			1.0, --MarketValueFXRate
			DealDetail.DlDtlTmplteID, --DlDtlTmplteID
			Null, --SpecificGravity
			Null, --Energy
			"S", -- CostType
			0, -- DealValueMissing
			0, -- MarketValueMissing
			"N", --IsFlat
			AccountDetail.WePayTheyPay,
			AccountDetail.Reversed,
			Null, -- VETradePeriodID_BAV
			AccountDetail.SupplyDemand,
			Case When DealHeader.DlHdrTyp in (76,77,78,79,80) Then DealDetail.DlDtlIntrnlUserID Else DealHeader.DlHdrIntrnlUserID End, --Inhouses get from deal detail
			--Case When DealDetail.DlDtlTmplteID in (32000,32001,340000,341000) Then DealDetail.DlDtlIntrnlUserID Else DealHeader.DlHdrIntrnlUserID End, -- Trader here matt put 32001 back in
			DealHeader.DlHdrDsplyDte,
			Case When AccountDetail.AcctDtlTrnsctnDte < AccountingPeriod.AccntngPrdBgnDte Then "Y" Else "N" End, --IsPPA
			AccountDetail.AcctDtlTrnsctnDte,
			Null, --What If
			Null, --DlDtlPrvsnActual updated later
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
			AccountDetail.AcctDtlUOMID,
			DealDetail.DlDtlDsplyUOM,
			Null, --MarketVAlue_Override
			Null, --P_EODEstmtedAccntDtlID_Market
			Null, --AcctDtlID_Market
			Null, --Overridden by UserID
	--		ISNull(DealHeader.DlHdrDscrptn,""),
			Null, -- P_EODEstmtedAccntDtlVleID
			NULL, --TotalValue_Override
			NULL, -- UserID_OverriddenBy_Trade
			NULL, --PaymentDueDate
			AccountDetail.AcctDtlSlsInvceHdrID,
			AccountDetail.AcctDtlPrchseInvceHdrID,
			1.0, --DiscountFactor
			0.0,  --DiscountFactor_Compare
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
			"N", --IsWriteOnWriteOff
			0.0 --SystemInventoryValue
	From	AccountDetail (NoLock)
			Inner Join AccountingPeriod (NoLock)	On	AccountingPeriod.AccntngPrdID  = AccountDetail.AcctDtlAccntngPrdID
			Left Outer Join DealHeader (NoLock) 	On	DealHeader.DlHdrID = AccountDetail.AcctDtlDlDtlDlHdrID
			Left Outer Join DealDetail (NoLock)		On	DealDetail.DlDtlDlHdrID = AccountDetail.AcctDtlDlDtlDlHdrID
													And	DealDetail.DlDtlID = AccountDetail.AcctDtlDlDtlID
'




-----------------------------------------------------------------------------------------------------------------------
-- Build the where clause
-- Unfortunately the AcctDtlStrtgyID is not currently filled out in this version, so @i_P_PrtflioID will not be
-- part of our main criteria.  We will have to delete out of the temp table after the insert. We are only applying
-- criteria in our initial where clause that is on AccountDetail
-----------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------
-- The accounting period criteria will always be in our where clause
-- When the @c_MonthEndSnapShotLogic = 'Y' we use a slightly different where clause as we want to get any
-- time transactions from the starting period of the snapshot
-- The logic to determine how @c_MonthEndSnapShotLogic is set is in MTV_ProfitAndLoss_A_SnapShot
-----------------------------------------------------------------------------------------------------------------------
If @c_MonthEndSnapShotLogic = 'N'
Begin
	Select	@vc_SQL_Where =
	'
		Where	AccountDetail.AcctDtlAccntngPrdID Between ' + convert(varchar,@i_AccntngPrdID_From) + ' And ' + Convert(Varchar,(@i_AccntngPrdID_To_AccountDetailWhere)) + '
	'
End
Else
Begin
	Select	@vc_SQL_Where =
	'
		Where	AccountDetail.AcctDtlAccntngPrdID Between ' + convert(varchar,@i_AccntngPrdID_From) + ' And Case When AccountDetail.AcctDtlSrceTble in ("TT","ML") Then ' + Convert(Varchar,(@i_AccntngPrdID_To_AccountDetailWhere + 1)) + ' Else ' + Convert(Varchar,(@i_AccntngPrdID_To_AccountDetailWhere)) + ' End
	'
End


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
		Where	#MTVProfitAndLoss_Navigation.AcctDtlID = AccountDetail.AcctDtlID
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
		Where	#BAs.BAID = AccountDetail.InternalBAID
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
		Where	#TransactionTypes.TrnsctnTypID = AccountDetail.AcctDtlTrnsctnTypID
		)
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a transaction type was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_TrnsctnTypID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	AccountDetail.AcctDtlTrnsctnTypID in (' + @vc_TrnsctnTypID + ')
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a product was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_PrdctID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	AccountDetail.ParentPrdctID in (' + @vc_PrdctID + ')
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a locale was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_LcleID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	AccountDetail.AcctDtlLcleID in (' + @vc_LcleID + ')
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



--------------------------------------------------------------------------------------------------------------------------
-- If a @vc_P_PrtflioID was passed and in a version greater than S9 that has strategy on account detailadd an exists to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_P_PrtflioID is Not Null
Begin

	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Exists
		(
		Select	1
		From	#Strategies (NoLock)
		Where	#Strategies.StrtgyID = AccountDetail.AcctDtlStrtgyID
		)
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




--------------------------------------------------------------------------------------------------------------------------
-- Update the DlDtlPrvnsID for movementbased provisions here matt
--------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL = '
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.DlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID,
		#MTVProfitAndLoss.CostType = DealDetailProvision.CostType,
		#MTVProfitAndLoss.SpecificGravity = TransactionHeader.XHdrSpcfcGrvty,
		#MTVProfitAndLoss.Energy = TransactionHeader.Energy,
		#MTVProfitAndLoss.DlDtlPrvsnActual = DealDetailProvision.Actual,
		#MTVProfitAndLoss.XDtlStat = TransactionDetail.XDtlStat,
		#MTVProfitAndLoss.XHdrID = TransactionHeader.XHdrID,
		#MTVProfitAndLoss.XDtlID = TransactionDetail.XDtlID
From	TransactionDetailLog (NoLock)
		Inner Join DealDetailProvision (NoLock) On	DealDetailProvision.DlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
		Inner Join TransactionDetail (NoLock)	On	TransactionDetail.XDtlXHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
												And	TransactionDetail.XDtlDlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
												And	TransactionDetail.XDtlID = TransactionDetailLog.XDtlLgXDtlID
		Inner Join TransactionHeader (NoLock)	On TransactionHeader.XhdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
Where	TransactionDetailLog.XDtlLgID = #MTVProfitAndLoss.AcctDtlSrceID
And		#MTVProfitAndLoss.AcctDtlSrceTble = "X"
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--------------------------------------------------------------------------------------------------------------------------
-- Update the DlDtlPrvnsID and DlDtlPrvsnRwID for time based AccountDetails
--------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL = '
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.DlDtlPrvsnID = TimeTransactionDetail.TmeXDtlDlDtlPrvsnID,
		#MTVProfitAndLoss.DlDtlPrvsnRwID = TimeTransactionDetail.TmeXDtlDlDtlPrvsnRwID,
		#MTVProfitAndLoss.CostType = DealDetailProvision.CostType,
		#MTVProfitAndLoss.DlDtlPrvsnActual = DealDetailProvision.Actual
From	TimeTransactionDetailLog (NoLock)
		Inner Join TimeTransactionDetail (NoLock)	On TimeTransactionDetail.TmeXDtlIdnty = TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty
		Inner Join DealDetailProvision (NoLock)		On DealDetailProvision.DlDtlPrvsnID = TimeTransactionDetail.TmeXDtlDlDtlPrvsnID
Where	TimeTransactionDetailLog.TmeXDtlLgID = #MTVProfitAndLoss.AcctDtlSrceID
And		#MTVProfitAndLoss.AcctDtlSrceTble = "TT"
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

---------------------------------------------------------------------------------------------------------
--	Update the FlatPriceRwPrceLcleID, FlatPriceCurveName, FormulaOffset, and FormulaPercentage
---------------------------------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.FlatPriceRwPrceLcleID = Convert(Int,DealDetailProvisionRow.PriceAttribute3),
		#MTVProfitAndLoss.FlatPriceCurveName = RawPriceLocale.CurveName,
		#MTVProfitAndLoss.FormulaPercentage = Convert(Float,DealDetailProvisionRow.PriceAttribute1),
		#MTVProfitAndLoss.FormulaOffset = Convert(Float,DealDetailProvisionRow.PriceAttribute2)
From	#MTVProfitAndLoss
		Inner Join DealDetailProvisionRow (NoLock)	On	DealDetailProvisionRow.DlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
													And	DealDetailProvisionRow.DlDtlPRvsnRwTpe = "F"
													And	IsNumeric(DealDetailProvisionRow.PriceAttribute3) = 1
													And	IsNumeric(DealDetailProvisionRow.PriceAttribute1) = 1
													And	IsNumeric(DealDetailProvisionRow.PriceAttribute2) = 1
		Inner Join RawPriceLocale (NoLock)	On	RawPriceLocale.RwPrceLcleID = Convert(Int,DealDetailProvisionRow.PriceAttribute3)
											And	RawPriceLocale.IsBasisCurve = 0
Where	#MTVProfitAndLoss.CostType = "P"		
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


---------------------------------------------------------------------------------------------------------
--	Update the MarketRwPrceLcleID, MarketCurveName
--  There is a one to many relationship b/t RiskCurve and RiskCurveExposure, but we are only always expecting
--	one and if two we will just take one
---------------------------------------------------------------------------------------------------------
Select	@vc_SQL = 
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.BaseMarketRwPrceLcleID = ChildRiskCurve.RwPrceLcleID,
		#MTVProfitAndLoss.BaseMarketCurveName = ChildRawPriceLocale.CurveName
From	#MTVProfitAndLoss
		Inner Join RawPriceLocale (NoLock)		On	RawPriceLocale.RPLcleRPHdrID = 4 -- Market
												And	RawPriceLocale.RPLcleChmclParPrdctID = #MTVProfitAndLoss.PrdctID
												And	RawPriceLocale.RPLcleChmclChdPrdctID = #MTVProfitAndLoss.ChildPrdctID
												And	RawPriceLocale.RPLcleLcleID = #MTVProfitAndLoss.LcleID
		Inner Join RawPriceLocaleCurrencyUOM (NoLock)	
												On	RawPriceLocaleCurrencyUOM.RwPrceLcleID = RawPriceLocale.RwPrceLcleID
		Inner Join RiskCurve (NoLock)			On	RiskCurve.RwPrceLcleID = RawPriceLocaleCurrencyUOM.RwPrceLcleID
												And	RiskCurve.CrrncyID = RawPriceLocaleCurrencyUOM.CrrncyID
												And	RiskCurve.UOMID = RawPriceLocaleCurrencyUOM.UOM
												And	RiskCurve.TradePeriodFromDate	= #MTVProfitAndLoss.DeliveryPeriodStartDate
		Inner Join RiskCurveExposure (NoLock)	On	RiskCurveExposure.RiskCurveID = RiskCurve.RiskCurveID
		Inner Join RiskCurve ChildRiskCurve (NoLock)
												On	ChildRiskCurve.RiskCurveID = RiskCurveExposure.ChildRiskCurveID
		Inner Join RawPriceLocale ChildRawPriceLocale (NoLock)
												On	ChildRawPriceLocale.RwPrceLcleID = ChildRiskCurve.RwPrceLcleID
												And	ChildRawPriceLocale.IsBasisCurve = 0
Where	#MTVProfitAndLoss.CostType = "P"
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)




-----------------------------------------------------------------------------------------------------------------------------
-- Update the ManualLedgerEntries that are for the Book Estimates process with the gravity from the InventoryReconcile
-----------------------------------------------------------------------------------------------------------------------------
/*
select	@vc_SQL = '
Update	#MTVProfitAndLoss
Set	#MTVProfitAndLoss.SpecificGravity = InventoryReconcile.XHdrSpcfcGrvty
From	#MTVProfitAndLoss (NoLock)
	Inner Join ManualLedgerEntryLog (NoLock)		On	ManualLedgerEntryLog.MnlLdgrEntryLgID = #MTVProfitAndLoss.AcctDtlSrceID
	Inner Join BP_ManualLedgerEntry (NoLock)	On	BP_ManualLedgerEntry.MnlLdgrEntryID = ManualLedgerEntryLog.MnlLdgrEntryID
								And	BP_ManualLedgerEntry.Source = "E" --Book Estimates
								And	BP_ManualLedgerEntry.Type = "O" --Original
								And	BP_ManualLedgerEntry.RelatedMnlLdgrEntryID is Null --Last in chain
	Inner Join InventoryReconcile (NoLock)			On	InventoryReconcile.InvntryRcncleID = BP_ManualLedgerEntry.InvntryRcncleID
Where	#MTVProfitAndLoss.AcctDtlSrceTble = "ML"
And	#MTVProfitAndLoss.SpecificGravity is Null
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
*/


-----------------------------------------------------------------------------------------------------------------------------
-- Update the gravity for everything else with either movementheader gravity,DealDetail.Gravity, or the product gravity
-- Search accounting transactinos uses product gravity
-- while search transfes uses the deal detail gravity
-----------------------------------------------------------------------------------------------------------------------------
select	@vc_SQL = '
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.SpecificGravity = Coalesce(MovementHeader.MvtHdrGrvty,DealDetail.Gravity,Product.PrdctSpcfcGrvty),
		#MTVProfitAndLoss.Energy = Coalesce(MovementHeader.Energy,DealDetail.Energy,Product.PrdctEnrgy)
From	#MTVProfitAndLoss (NoLock)
		Left Outer Join MovementHeader (NoLock)	On	#MTVProfitAndLoss.MvtHdrID = MovementHeader.MvtHdrID
		Left Outer Join DealDetail (NoLock) 	On	DealDetail.DlDtlDlHdrID = #MTVProfitAndLoss.DlHdrID
												And	DealDetail.DlDtlID = #MTVProfitAndLoss.DlDtlID
		Left Outer Join Product (NoLock)		On	Product.PrdctID = #MTVProfitAndLoss.PrdctID
Where	#MTVProfitAndLoss.SpecificGravity is Null
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
--Update the PositionGallons and PositionPounds for primary costs and inventory valuation transaction type
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.PositionGallons = #MTVProfitAndLoss.ValuationGallons,
		#MTVProfitAndLoss.PositionPounds = #MTVProfitAndLoss.ValuationGallons * #MTVProfitAndLoss.SpecificGravity * ' + @vc_WaterDensity + '
Where	#MTVProfitAndLoss.CostType = "P"
Or		#MTVProfitAndLoss.TrnsctnTypID = 2008
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------------------------------------------------------
--Update the total value and TotalPnL and the TotalValueFXRate for non USD transactions
--------------------------------------------------------------------------------------------------------------------------
Select	@vc_SQL = '
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.TotalValueFXRate = 
		(
		Select	Top 1
				1.0/V_RiskCurrencyConversion.ConversionFactor
		From	V_RiskCurrencyConversion (nolock)
		Where	V_RiskCurrencyConversion.FromCurrency	= #MTVProfitAndLoss.PaymentCrrncyID					--The From and to currency are switched because the view is currency switched.
		And		V_RiskCurrencyConversion.ToCurrency	= 19			--The From and to currency are switched because the view is currency switched.
		And		V_RiskCurrencyConversion.FromDate <= #MTVProfitAndLoss.TransactionDate 
		And		V_RiskCurrencyConversion.RPHdrID	= ' + convert(varchar,@i_DefaultCurrencyService) + '
		And		V_RiskCurrencyConversion.ConversionFactor <> 0.0
		Order By
				V_RiskCurrencyConversion.FromDate Desc
		)
Where	#MTVProfitAndLoss.PaymentCrrncyID <> 19
And		#MTVProfitAndLoss.TrnsctnTypID Not in (2027,2028,2029,2030) --Exclude all old book unrealized entries
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

Select	@vc_SQL = '
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.TotalValue = #MTVProfitAndLoss.TotalValue * #MTVProfitAndLoss.TotalValueFXRate,
		#MTVProfitAndLoss.TotalPnL = #MTVProfitAndLoss.TotalPnL * #MTVProfitAndLoss.TotalValueFXRate
Where	#MTVProfitAndLoss.PaymentCrrncyID <> 19
And		#MTVProfitAndLoss.TrnsctnTypID Not in (2027,2028,2029,2030) --Exclude all old book unrealized entries
And		 #MTVProfitAndLoss.TotalValueFXRate is Not Null
'
if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)




Set NoCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_AccountDetail]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_ProfitAndLoss_AccountDetail.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ProfitAndLoss_AccountDetail >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ProfitAndLoss_AccountDetail >>>'
	  END