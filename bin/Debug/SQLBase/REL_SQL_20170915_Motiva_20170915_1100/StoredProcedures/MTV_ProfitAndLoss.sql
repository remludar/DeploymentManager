/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_ProfitAndLoss]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ProfitAndLoss] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ProfitAndLoss >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ProfitAndLoss]
										@c_IsThisNavigation   Char(1)  = 'N',  
										@c_ReverseRebooks  Char(1) = 'A', -- 'A' = within AP, 'E' = exclude all 'S' = Show All  
										@i_P_EODSnpShtID  Int = Null,  
										@vc_P_PrtflioID   Varchar(8000) = '1',
										@sdt_AccntngPrdID_From  smalldatetime = null,
										@sdt_AccntngPrdID_To  smalldatetime = null,
										@sdt_DeliveryPeriod_From smalldatetime = Null,  
										@sdt_DeliveryPeriod_To  smalldatetime = Null,  
										@vc_PrntBAID   Varchar(8000) = '1',
										@i_XGrpID   Int = Null, --   
										@c_InventoryView  Char(1) = 'F', -- First accounting period of snapshot 
										@vc_TrnsctnTypID  Varchar(8000) = Null,   
										@vc_PrdctID   Varchar(8000) = Null,  
										@vc_LcleID   Varchar(8000) = Null,  
										@vc_DealNumber   Varchar(20)= Null,  
										@vc_DlDtlTmplteID  Varchar(8000) = Null,  
										@i_WhatIfScenario  Int = 0,  
										@c_InterimBilling  Char(1)  = 'E', -- E = Exclude, I = Include  
										@c_RiskAdjustments  Char(1)  = 'I', -- E = Exclude, I = Include  
										@i_P_EODSnpShtID_Compare Int = Null,  
										@c_IncludeStrategyInCompare Char(1) = 'N',  
										@c_FallBackToMkt Char(1) = 'N',
										@c_ShowRemittableTaxes Char(1) = 'N',   
										@c_ExcludeMovedEstimates Char(1) = 'N',
										@c_InventoryValue Char(1) = 'M', --M = Mkt Transfer at market, Z = Mkt transfer at zero, S = System
										@c_InventoryOptions Char(1) = 'C', -- B = Beg Inv Only, C = Beg Inv with Inv change, F = Beg Inv reversed and est ending inventory

										@i_RprtCnfgID   Int  = Null,  
										@vc_AdditionalColumns  VarChar(8000) = Null,  
										@c_OnlyShowSQL   Char(1)  = 'N',
										@CompareToSnapshot	char(1) = 'N',
										@IncludeWhatIf		char(1) = 'N'

AS
----------------------------------------------------------------------------------------------------------------------------  
-- SP:            MTV_ProfitAndLoss  
-- Arguments:    
-- Tables:         Tables  
-- Indexes: LIST ANY INDEXES used in OPTIMIZER hints  
-- Stored Procs:   StoredProcedures  
-- Dynamic Tables: DynamicTables  
-- Overview:       DocumentFunctionalityHere  
--  
-- Created by:     Matt Perry  
-- Issues  
-- Doing currency conversion for accountdetails based on transaction date  
-- Doing currency conversion for estimatedaccountdetails based on endofday b/c they do not put future month rates in  
-- History:      - First Created  
-- Date Modified Modified By        Modification  

-- exec MTV_ProfitAndLoss @i_P_EODSnpshtID = 14, @vc_P_PrtFlioID = 1, @vc_PrntBAID = '1', @sdt_AccntngPrdID_From  = '4/1/2016', @sdt_AccntngPrdID_To = '7/1/2016'
Set NoCount ON  
Set Quoted_Identifier off  
  
--drop table #MTVProfitAndLoss  
--drop table #MTVProfitAndLoss_main  
  
 
Declare @c_HasWhere Char(1)  
  
----------------------------------------------------------------------------------------------------------------  
-- Need the following code b/c navigation replaces ints with 0 and varchars with ''  
----------------------------------------------------------------------------------------------------------------  
If @i_XGrpID = 0 Select @i_XGrpID = Null  
If @vc_TrnsctnTypID in ('-1','') Select @vc_TrnsctnTypID = Null   
if @vc_PrdctID in ('0','') select @vc_PrdctID = Null  
if @vc_LcleID in ('0','') select @vc_LcleID = Null  
if @vc_DlDtlTmplteID in ('0','') select @vc_DlDtlTmplteID = Null  
If @i_whatifscenario is Null select @i_whatifscenario = 0  
if IsNull(LTrim(RTrim(@vc_DealNumber)),'') = '' select @vc_DealNumber = Null  
if @c_InterimBilling = '' select @c_InterimBilling = 'E'  
If @c_RiskAdjustments = '' select @c_RiskAdjustments = 'I'  
If @c_InventoryView = '' select @c_InventoryView = 'F'  
If @c_ReverseRebooks = '' select @c_ReverseRebooks = 'E'  
If @vc_P_PrtflioID in ('0','') select @vc_P_PrtflioID = Null  
If @vc_PrntBAID in ('0','') select @vc_PrntBAID = Null  
If @c_IncludeStrategyInCompare = '' select @c_IncludeStrategyInCompare = 'N'  
  

if @c_IsThisNavigation = '' Select @c_IsThisNavigation = 'Y'  
  
If @c_IsThisNavigation = 'Y'  
Begin  
 select @sdt_AccntngPrdID_From = Null,  
  @sdt_AccntngPrdID_To = Null,  
  @sdt_DeliveryPeriod_From = Null,  
  @sdt_DeliveryPeriod_To = Null,  
  @i_P_EODSnpShtID_Compare = Null  
End  
  
-----------------------------------------------------------------------------------------------------------------  
-- Make sure the from dates are the first day of the selected month
-----------------------------------------------------------------------------------------------------------------  
If Day(@sdt_AccntngPrdID_From) <> 1
Begin  
 Select @sdt_AccntngPrdID_From = DateAdd(DAY, -1*DatePart(Day, @sdt_AccntngPrdID_From) ,@sdt_AccntngPrdID_From)
End  
  
If Day(@sdt_DeliveryPeriod_From) <> 1
Begin  
 Select @sdt_DeliveryPeriod_From = DateAdd(DAY, -1*DatePart(Day, @sdt_DeliveryPeriod_From) ,@sdt_DeliveryPeriod_From)
End  
-----------------------------------------------------------------------------------------------------------------  
-- Make sure the to dates are the last minute of the month
-----------------------------------------------------------------------------------------------------------------  
If Day(@sdt_AccntngPrdID_To) = 1  
Begin  
 Select @sdt_AccntngPrdID_To = DateAdd(mi,-1,DateAdd(m,1,@sdt_AccntngPrdID_To))  
End  
  
If Day(@sdt_DeliveryPeriod_To) = 1  
Begin  
 Select @sdt_DeliveryPeriod_To = DateAdd(mi,-1,DateAdd(m,1,@sdt_DeliveryPeriod_To))  
End  
  
  

------------------------------------------------------------------------------------------------------------------  
-- Create the temp tables that we will needed  
------------------------------------------------------------------------------------------------------------------  
if @c_OnlyShowSQL = 'Y'  
Begin  
 Select  
'  
 Create Table #MTVProfitAndLoss
	(
	DealNumber					Varchar(2000),
	AcctDtlID					Int Null,
	P_EODBAVID					Int Null,
	P_EODEstmtedAccntDtlID		Int Null,
	RiskID						Int Null,
	DlHdrID						Int Null,
	DlDtlID						Int Null,
	PlnndTrnsfrID				Int Null,
	PrdctID						Int,
	ChildPrdctID				Int,
	LcleID						Int,
	MvtHdrID					Int Null,
	DlDtlPrvsnID				Int Null,
	DlDtlPrvsnRwID				Int Null,
	TrnsctnTypID				Int,
	AccountingPeriodStartDate	smalldatetime,
	DeliveryPeriodStartDate		smalldatetime,
	StrtgyID					Int,
	InternalBAID				Int,
	ExternalBAID				Int,
	AcctDtlSrceTble				Char(2) Null,
	AcctDtlSrceID				Int Null,
	RiskSourceTable				Char(2) Null,
	RiskCostSourceTable			Char(2) Null,
	ValuationGallons			Decimal(28,6),
	PositionGallons				Decimal(28,6),
	PositionPounds				Decimal(28,6),
	TotalValue					Decimal(28,6),
	MarketValue					Decimal(28,6),
	TotalPnL					Decimal(28,6),
	PaymentCrrncyID				Int,
	MarketCrrncyID				Int,
	TotalValueFXRate			Float Default 1.0,
	MarketValueFXRate			Float Default 1.0,
	DlDtlTmplteID				Int Null,
	SpecificGravity				Decimal(28, 13),
	Energy						Float,
	CostType					Char(1),
	DealValueIsMissing			bit Not Null,
	MarketValueIsMissing		bit Not NULL,
	IsFlat						Char(1) Not NUll,
	WePayTheyPay				Char(1) Not Null,
	IsReversal					Char(1) Not Null,
	VETradePeriodID_BAV			Int Null,
	ReceiptDelivery				Char(1) Null,
	Trader						Int Null,
	TradeDate					SmallDateTime,
	IsPPA						Char(1) Null,
	TransactionDate				SmallDateTime Null,
	WhatIfScenario				Int Null,
	DlDtlPrvsnActual			char(1) Null,
	P_EODSnpShtID				Int,
	COB							SmallDateTime,
	COB_Compare					SmallDateTime,
	P_EODSnpShtID_Compare		Int Null,
	PositionGallons_Compare		Decimal(28,6),
	PositionPounds_Compare		Decimal(28,6),
	TotalValue_Compare			Decimal(28,6),
	MarketValue_Compare			Decimal(28,6),
	XDtlStat					Char(1) Null,
	AcctDtlPrntID				Int Null,
	XHdrID						Int Null,
	XDtlID						Int Null,
	DlDtlPrvsnUOMID				Int Null,
	DlDtlDsplyUOM				Int Null,
	MarketValue_Override		Decimal(28,6),
	P_EODEstmtedAccntDtlID_Market	Int Null,
	AcctDtlID_Market				Int Null,
	UserID_OverriddenBy				Int Null,
	P_EODEstmtedAccntDtlVleID		Int,
	TotalValue_Override				Decimal(28,6),
	UserID_OverriddenBy_Trade		Int Null,
	PaymentDueDate					SmallDateTime Null,
	SalesInvoiceID					Int Null,
	PurchaseInvoiceID				Int Null,
	DiscountFactor					Float Default 1.0,
	DiscountFactor_Compare			Float Default 0.0,
	FlatPriceRwPrceLcleID			Int Null,
	FlatPricePriceTypeIdnty			Int Null,
	FlatPriceCurveName				Varchar(100) Null,
	BaseMarketRwPrceLcleID			Int Null,
	BaseMarketCurveName				Varchar(100) Null,
	FormulaOffset					Decimal(19,6) Null,
	FormulaPercentage				Decimal(19,6) Null,
	FormulaEvaluationID				Int Null,
	MarketRiskCurveID				Int Null,
	PricedInPercentage				Float,
	QuoteStartDate					SmallDateTime,
	QuoteEndDate					SmallDateTime,
	IsWriteOnWriteOff				Char(1),
	SystemInventoryValue			Decimal(28,6)
	)  
'  

  
  
End  
Else  
Begin 
 Create Table #MTVProfitAndLoss  
	(
	DealNumber					Varchar(2000),
	AcctDtlID					Int Null,
	P_EODBAVID					Int Null,
	P_EODEstmtedAccntDtlID		Int Null,
	RiskID						Int Null,
	DlHdrID						Int Null,
	DlDtlID						Int Null,
	PlnndTrnsfrID				Int Null,
	PrdctID						Int,
	ChildPrdctID				Int,
	LcleID						Int,
	MvtHdrID					Int Null,
	DlDtlPrvsnID				Int Null,
	DlDtlPrvsnRwID				Int Null,
	TrnsctnTypID				Int,
	AccountingPeriodStartDate	smalldatetime,
	DeliveryPeriodStartDate		smalldatetime,
	StrtgyID					Int,
	InternalBAID				Int,
	ExternalBAID				Int,
	AcctDtlSrceTble				Char(2) Null,
	AcctDtlSrceID				Int Null,
	RiskSourceTable				Char(2) Null,
	RiskCostSourceTable			Char(2) Null,
	ValuationGallons			Decimal(28,6),
	PositionGallons				Decimal(28,6),
	PositionPounds				Decimal(28,6),
	TotalValue					Decimal(28,6),
	MarketValue					Decimal(28,6),
	TotalPnL					Decimal(28,6),
	PaymentCrrncyID				Int,
	MarketCrrncyID				Int,
	TotalValueFXRate			Float Default 1.0,
	MarketValueFXRate			Float Default 1.0,
	DlDtlTmplteID				Int Null,
	SpecificGravity				Decimal(28, 13),
	Energy						Float,
	CostType					Char(1),
	DealValueIsMissing			bit Not Null,
	MarketValueIsMissing		bit Not NULL,
	IsFlat						Char(1) Not NUll,
	WePayTheyPay				Char(1) Not Null,
	IsReversal					Char(1) Not Null,
	VETradePeriodID_BAV			Int Null,
	ReceiptDelivery				Char(1) Null,
	Trader						Int Null,
	TradeDate					SmallDateTime,
	IsPPA						Char(1) Null,
	TransactionDate				SmallDateTime Null,
	WhatIfScenario				Int Null,
	DlDtlPrvsnActual			char(1) Null,
	P_EODSnpShtID				Int,
	COB							SmallDateTime,
	COB_Compare					SmallDateTime,
	P_EODSnpShtID_Compare		Int Null,
	PositionGallons_Compare		Decimal(28,6),
	PositionPounds_Compare		Decimal(28,6),
	TotalValue_Compare			Decimal(28,6),
	MarketValue_Compare			Decimal(28,6),
	XDtlStat					Char(1) Null,
	AcctDtlPrntID				Int Null,
	XHdrID						Int Null,
	XDtlID						Int Null,
	DlDtlPrvsnUOMID				Int Null,
	DlDtlDsplyUOM				Int Null,
	MarketValue_Override		Decimal(28,6),
	P_EODEstmtedAccntDtlID_Market	Int Null,
	AcctDtlID_Market				Int Null,
	UserID_OverriddenBy				Int Null,
	P_EODEstmtedAccntDtlVleID		Int,
	TotalValue_Override				Decimal(28,6),
	UserID_OverriddenBy_Trade		Int Null,
	PaymentDueDate					SmallDateTime Null,
	SalesInvoiceID					Int Null,
	PurchaseInvoiceID				Int Null,
	DiscountFactor					Float Default 1.0,
	DiscountFactor_Compare			Float Default 1.0,
	FlatPriceRwPrceLcleID			Int Null,
	FlatPricePriceTypeIdnty			Int Null,
	FlatPriceCurveName				Varchar(100) Null,
	BaseMarketRwPrceLcleID			Int Null,
	BaseMarketCurveName				Varchar(100) Null,
	FormulaOffset					Decimal(19,6) Null,
	FormulaPercentage				Decimal(19,6) Null,
	FormulaEvaluationID				Int Null,
	MarketRiskCurveID				Int Null,
	PricedInPercentage				Float,
	QuoteStartDate					SmallDateTime,
	QuoteEndDate					SmallDateTime,
	IsWriteOnWriteOff				Char(1),
	SystemInventoryValue			Decimal(28,6)
	)  

End  
  
  
If @c_OnlyShowSQL = 'Y'  
Begin  
	select  
	'  
	Select * into #MTVProfitAndLoss_EAD From #MTVProfitAndLoss where 1=2  
	Select * into #MTVProfitAndLoss_RiskAdj From #MTVProfitAndLoss where 1=2  
	'  
End  
Else  
Begin  
	Select * into #MTVProfitAndLoss_EAD From #MTVProfitAndLoss where 1=2  
	Select * into #MTVProfitAndLoss_RiskAdj From #MTVProfitAndLoss where 1=2  
End  
  
  
if @c_OnlyShowSQL = 'Y'  
Begin  
	Select  
	'  
	Create Table #BAs  
	(  
	BAID Int  
	)  
	'  
End  
Else  
Begin  
	Create Table #BAs  
	(  
	BAID Int  
	)  
End  
  
if @c_OnlyShowSQL = 'Y'  
Begin  
	Select  
	'  
	Create Table #TransactionTypes  
	(
	TrnsctnTypID Int  
	)  
	'  
End  
Else  
Begin  
	Create Table #TransactionTypes  
	(
	TrnsctnTypID Int  
	)    
End  

if @c_OnlyShowSQL = 'Y'  
Begin  
	Select  
	'  
	Create Table #Strategies  
	(  
	StrtgyID Int  
	)  
	'  
End  
Else  
	Begin  
	Create Table #Strategies  
	(  
	StrtgyID Int  
	)  
End  
  
  
  
if @c_OnlyShowSQL = 'Y'  
Begin  
	Select  
	'  
	Create Table #SwapFloatSide  
	(  
	P_EODEstmtedAccntDtlID_Float Int Null,  
	AccntDtlID_Float Int Null,  
	MarketValue Float,  
	MarketValue_Override Float,  
	DealValueIsMissing bit,  
	P_EODEstmtedAccntDtlID_Fixed Int Null,  
	AccntDtlID_Fixed Int Null,
	UserID_OverriddenBy Int Null,
	BaseMarketRwPrceLcleID Int Null,
	BaseMarketCurveName	 Varchar(100),
	PricedInPercentage Float Null,
	QuoteStartDate	SmallDateTime Null,
	QuoteEndDate	SmallDateTime Null
	)  
	'  
End  
Else  
Begin  
	Create Table #SwapFloatSide  
	(  
	P_EODEstmtedAccntDtlID_Float Int Null,
	AccntDtlID_Float Int Null,  
	MarketValue Float,
	MarketValue_Override Float,  
	DealValueIsMissing bit,
	P_EODEstmtedAccntDtlID_Fixed Int Null,  
	AccntDtlID_Fixed Int Null,  
	UserID_OverriddenBy Int Null,
	BaseMarketRwPrceLcleID Int Null,
	BaseMarketCurveName	 Varchar(100),
	PricedInPercentage Float Null,
	QuoteStartDate	SmallDateTime Null,
	QuoteEndDate	SmallDateTime Null
	)  
End  
  
  
---------------------------------------------------------------------------------------------------------------  
-- Declare the variable we will use to build dynamic sql  
---------------------------------------------------------------------------------------------------------------  
Declare @vc_SQL  Varchar(8000)  
Declare @vc_Select Varchar(8000)  
Declare @vc_Select_Additional Varchar(8000)  
Declare @vc_From Varchar(8000)  
Declare @vc_Where Varchar(8000)  
Declare @vc_WaterDensity Varchar(80)  
Declare @i_BaseCurrencyID Int  
Declare @i_DefaultCurrencyService Int  
  
Declare @sdt_EndOfDay  SmallDateTime  
Declare @sdt_EndOfDay_Compare SmallDateTime  
  
Declare @sdt_InstanceDateTime SmallDateTime  
Declare @sdt_InstanceDateTime_Compare SmallDateTime  
  
  
---------------------------------------------------------------------------------------------------------------  
-- Declare the variables we will use in the inserts into the results temp table  
---------------------------------------------------------------------------------------------------------------  
/*  
Declare @i_AccntngPrdID_SnapshotStart int  
Declare @i_AccntngPrdID_To_AccountDetailWhere Int  
Declare @sdt_AccntngPrdBgnDte_SnapShotStart SmallDateTime  
Declare @sdt_AccntngPrdBgnDte_To  SmallDateTime  
Declare @sdt_EndOfDay    SmallDateTime  
Declare @i_VETradePeriodID_From   Int  
Declare @i_VETradePeriodID_To   Int  
Declare @i_VETradePeriodID_Inventory  Int  
Declare @i_VETradePeriodID_SnapShotStart Int  
Declare @sdt_AccntngPrdBgnDte_Inventory SmallDateTime  
Declare @sdt_InstanceDateTime SmallDateTime  
Declare @i_AccntngPrdID_Inventory Int  
Declare @i_AccntngPrdID_From Int  
Declare @i_AccntngPrdID_To Int  
*/  
  
--------------------------------------------------------------------------------------------------------------------------  
-- Get the WaterDensity so we can convert gallons to pounds where the weight columns is null on BestAvailableVolumeVolume  
-- or RiskPosition in the case of Risk Adjustments  
--------------------------------------------------------------------------------------------------------------------------  
Select	@vc_WaterDensity = GeneralConfiguration.GnrlCnfgMulti  
From	GeneralConfiguration (NoLock)  
where	GeneralConfiguration.GnrlCnfgQlfr = 'WaterDensity'  
And		GeneralConfiguration.GnrlCnfgTblNme = 'System'  
  
  
---------------------------------------------------------------------------------------------------------  
-- Get the base currency  
---------------------------------------------------------------------------------------------------------  
/*  
exec sp_get_registry_value 'System\GlobalSettings\Default Currency' , @i_BaseCurrencyID out  
if @i_BaseCurrencyID is null   
Begin  
 select @i_BaseCurrencyID = CrrncyID from Currency where CrrncySmbl = 'USD'  
End  
*/  
---------------------------------------------------------------------------------------------------------  
-- Hard code base currency since it is a custom report  
---------------------------------------------------------------------------------------------------------  
select @i_BaseCurrencyID = 19  
  
---------------------------------------------------------------------------------------------------------  
-- Get currency price service  
---------------------------------------------------------------------------------------------------------  
exec sp_get_registry_value 'System\Currency\DefaultPriceSrvce' , @i_DefaultCurrencyService out  
  
if isnull(@i_DefaultCurrencyService,'') = ''  
Begin  
	select @i_DefaultCurrencyService = min(RPHdrID) from rawpriceheader where RPHdrTpe = 'C'  
End  
  
  
  
-----------------------------------------------------------------------------------------------------------------------  
-- Get the strategies for the portfolio  
-----------------------------------------------------------------------------------------------------------------------  
if @vc_P_PrtflioID is Not Null  
Begin  
	If @c_OnlyShowSQL = 'Y'  
	Begin  
		select 'Create Table #AttachUnassignedStrategies (Id Int)'  
	End

	Create Table #AttachUnassignedStrategies (Id Int)  

	Select @vc_SQL =  
	'  
	Insert #AttachUnassignedStrategies  
	select 1  
	From P_Portfolio (NoLock)  
	Where P_PrtflioID in (' + @vc_P_PrtflioID + ')  
	And P_Portfolio.AttachUnassignedStrategies = ''Y''  
	'  

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  

	if @@RowCount > 0
	--If (select count(*) from #AttachUnassignedStrategies) > 0  
	Begin  
		Select @vc_P_PrtflioID = Null  
	End  
End  
  
If @vc_P_PrtflioID is Not Null  
Begin  
	Select @vc_SQL =  
	'  
	Insert	#Strategies  
	select	P_PortfolioStrategyFlat.StrtgyID  
	From	P_PortfolioStrategyFlat (NoLock)  
	Where	P_PortfolioStrategyFlat.P_PrtflioID in (' + @vc_P_PrtflioID + ')  
	'  
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
End  
  
  
-----------------------------------------------------------------------------------------------------------------------  
-- Get the BAs, we will require a PrntBAID to be passed in, except on navigation  
-----------------------------------------------------------------------------------------------------------------------  
If @vc_PrntBAID is Not Null  
Begin  
	Select @vc_SQL =  
	'  
	Insert	#BAs  
	Select	BusinessAssociate.BAID  
	From	BusinessAssociate (NoLock)  
	Where	BusinessAssociate.BAPrntBAID in (' + @vc_PrntBAID + ')  
	'  
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  

	Select @vc_SQL =  
	'  
	Insert	#BAs  
	Select	BusinessAssociate.BAID  
	From	BusinessAssociate (NoLock)  
	Where	BusinessAssociate.BAID in (' + @vc_PrntBAID + ')  
	'  
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
End  
  
-----------------------------------------------------------------------------------------------------------------------  
-- Get Transaction Types  
-----------------------------------------------------------------------------------------------------------------------  
If @i_XGrpID is Not null  
Begin  
	Select @vc_SQL =  
	'  
	Insert	#TransactionTypes  
	Select	TransactionTypeGroup.XTpeGrpTrnsctnTypID  
	From	TransactionTypeGroup (NoLock)  
	Where	TransactionTypeGroup.XTpeGrpXGrpID = ' + convert(varchar,@i_XGrpID) + '  
	'  
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
End  
  
  
  
  
-----------------------------------------------------------------------------------------------------------------  
-- Call the Stored procedure for the main snapshot  
-----------------------------------------------------------------------------------------------------------------  
Execute dbo.MTV_ProfitAndLoss_A_SnapShot	@c_ReverseRebooks  = @c_ReverseRebooks,  
										@i_P_EODSnpShtID  = @i_P_EODSnpShtID OUT,  
										@vc_P_PrtflioID   = @vc_P_PrtflioID,  
										@sdt_AccntngPrdID_From  = @sdt_AccntngPrdID_From,  
										@sdt_AccntngPrdID_To  = @sdt_AccntngPrdID_To,  
										@sdt_DeliveryPeriod_From = @sdt_DeliveryPeriod_From,  
										@sdt_DeliveryPeriod_To  = @sdt_DeliveryPeriod_To,  
										@vc_PrntBAID   = @vc_PrntBAID,  
										@i_XGrpID   = @i_XGrpID,  
										@c_InventoryView  = @c_InventoryView,  
										@vc_TrnsctnTypID  = @vc_TrnsctnTypID, 
										@vc_PrdctID   = @vc_PrdctID,  
										@vc_LcleID   = @vc_LcleID,  
										@vc_DealNumber   = @vc_DealNumber,  
										@vc_DlDtlTmplteID  = @vc_DlDtlTmplteID,  
										@i_whatifscenario  = @i_whatifscenario,  
										@c_InterimBilling  = @c_InterimBilling,  
										@c_RiskAdjustments  = @c_RiskAdjustments,  
										@c_FallBackToMkt = @c_FallBackToMkt,  
										@vc_WaterDensity  = @vc_WaterDensity,  
										@i_BaseCurrencyID  = @i_BaseCurrencyID,  
										@i_DefaultCurrencyService = @i_DefaultCurrencyService,  
										@c_Compare_SnapShot  = 'N',  
										@sdt_InstanceDateTime  = @sdt_InstanceDateTime OutPut,  
										@sdt_EndOfDay   = @sdt_EndOfDay OutPut,  
										@c_InventoryValue = @c_InventoryValue,
										@c_InventoryOptions = @c_InventoryOptions,
										@c_IsThisNavigation   = @c_IsThisNavigation,  
										@i_RprtCnfgID   = @i_RprtCnfgID,  
										@vc_AdditionalColumns  = @vc_AdditionalColumns,  
										@c_OnlyShowSQL   = @c_OnlyShowSQL  



  
If isnull(@i_P_EODSnpShtID_Compare, -999) <> -999
Begin  
  
	If @c_OnlyShowSQL = 'Y'  
	Begin  
		Select  
		'  
		Select * into #MTVProfitAndLoss_Main From #MTVProfitAndLoss  
		Delete #MTVProfitAndLoss  
		'  
	End  
	Else  
	Begin  
		Select * into #MTVProfitAndLoss_Main From #MTVProfitAndLoss  
		Delete #MTVProfitAndLoss  
	End  
	  
	  
	  
	 Execute dbo.MTV_ProfitAndLoss_A_SnapShot	@c_ReverseRebooks  = @c_ReverseRebooks,  
												@i_P_EODSnpShtID  = @i_P_EODSnpShtID_Compare OUT,  
												@vc_P_PrtflioID   = @vc_P_PrtflioID,  
												@sdt_AccntngPrdID_From  = @sdt_AccntngPrdID_From,  
												@sdt_AccntngPrdID_To  = @sdt_AccntngPrdID_To,  
												@sdt_DeliveryPeriod_From = @sdt_DeliveryPeriod_From,  
												@sdt_DeliveryPeriod_To  = @sdt_DeliveryPeriod_To,  
												@vc_PrntBAID   = @vc_PrntBAID,  
												@i_XGrpID   = @i_XGrpID,  
												@c_InventoryView  = @c_InventoryView,  
												@vc_TrnsctnTypID  = @vc_TrnsctnTypID,  
												@vc_PrdctID   = @vc_PrdctID,  
												@vc_LcleID   = @vc_LcleID,  
												@vc_DealNumber   = @vc_DealNumber,  
												@vc_DlDtlTmplteID  = @vc_DlDtlTmplteID,  
												@i_whatifscenario  = @i_whatifscenario,  
												@c_InterimBilling  = @c_InterimBilling,  
												@c_RiskAdjustments  = @c_RiskAdjustments,  
												@c_FallBackToMkt = @c_FallBackToMkt,
												@vc_WaterDensity  = @vc_WaterDensity,  
												@i_BaseCurrencyID  = @i_BaseCurrencyID,  
												@i_DefaultCurrencyService = @i_DefaultCurrencyService,  
												@c_Compare_SnapShot  = 'Y',  
												@sdt_InstanceDateTime  = @sdt_InstanceDateTime_compare OutPut,  
												@sdt_EndOfDay   = @sdt_EndOfDay_compare OutPut,
												@c_InventoryValue = @c_InventoryValue,
												@c_InventoryOptions = @c_InventoryOptions,
												@c_IsThisNavigation   = @c_IsThisNavigation,  
												@i_RprtCnfgID   = @i_RprtCnfgID,  
												@vc_AdditionalColumns  = @vc_AdditionalColumns,  
												@c_OnlyShowSQL   = @c_OnlyShowSQL  
 
End  

    
Execute dbo.MTV_ProfitAndLoss_ExternalColumns  
												@sdt_InstanceDateTime = @sdt_InstanceDateTime,  
												@sdt_EndOfDay   = @sdt_EndOfDay,  
												@vc_P_PrtflioID         = @vc_P_PrtflioID, -- PVCS 11227  
												@vc_AdditionalColumns = @vc_AdditionalColumns,  
												@c_OnlyShowSQL   = @c_OnlyShowSQL  



/*
select @vc_sql =  
' 
ALTER	TABLE #MTVProfitAndLoss 
ADD		MarketValue_2   Decimal(28,6) default 0,
		TotalPnL_2      Decimal(28,6) default 0
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

If @i_P_EODSnpShtID_Compare is not null
Begin

	select @vc_sql =  
	' 
	ALTER	TABLE #MTVProfitAndLoss_Main
	ADD		MarketValue_2   Decimal(28,6) default 0,
			TotalPnL_2      Decimal(28,6) default 0
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	select @vc_sql =  
	' 
	Update	#MTVProfitAndLoss 
	Set		MarketValue_2 = MarketValue,
			TotalPnL_2    = IsNull(TotalValue,0.0) + Isnull(MarketValue,0.0)
	From	#MTVProfitAndLoss
 
	Update	#MTVProfitAndLoss_Main
	set		MarketValue_2 = pnl.MarketValue_2,
			TotalPnL_2    = pnl.TotalPnL_2
	From	#MTVProfitAndLoss pnl,
			#MTVProfitAndLoss_Main pnlm    
	Where	pnlm.AcctDtlID = pnl.AcctDtlID
	and		pnlm.AcctDtlID is Not Null

	Update	#MTVProfitAndLoss_Main
	set		MarketValue_2 = pnl.MarketValue_2,
			TotalPnL_2    = pnl.TotalPnL_2
	From	#MTVProfitAndLoss pnl,
			#MTVProfitAndLoss_Main pnlm    
	Where	pnlm.P_EODEstmtedAccntDtlID = pnl.P_EODEstmtedAccntDtlID
	and		pnlm.P_EODEstmtedAccntDtlID is Not Null
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  

End 

*/

if @i_P_EODSnpShtID_Compare is not null
begin



	------------------------------------------------------------------------------------------------------------------------------------------  
	-- Update the records in the main snapshot that are accountdetails if they also exist in the compare snapshot  
	------------------------------------------------------------------------------------------------------------------------------------------  

	select @vc_sql =  
	'  
	Update	#MTVProfitAndLoss_Main  
	Set		#MTVProfitAndLoss_Main.P_EODSnpShtID_Compare = ' + Convert(Varchar,@i_P_EODSnpShtID_Compare) + ',  
			#MTVProfitAndLoss_Main.COB_Compare = ''' + Convert(Varchar,@sdt_EndOfDay_compare,120) + ''',  
			#MTVProfitAndLoss_Main.PositionGallons_Compare = #MTVProfitAndLoss.PositionGallons,  
			#MTVProfitAndLoss_Main.PositionPounds_Compare = #MTVProfitAndLoss.PositionPounds,  
			#MTVProfitAndLoss_Main.TotalValue_Compare = #MTVProfitAndLoss.TotalValue,  
			#MTVProfitAndLoss_Main.MarketValue_Compare = Coalesce(#MTVProfitAndLoss.MarketValue_Override,#MTVProfitAndLoss.MarketValue,0.0),
			#MTVProfitAndLoss_Main.DiscountFactor_Compare = #MTVProfitAndLoss.DiscountFactor
	From	#MTVProfitAndLoss
	Where	#MTVProfitAndLoss_Main.AcctDtlID = #MTVProfitAndLoss.AcctDtlID  
	'  

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  

	 ------------------------------------------------------------------------------------------------------------------------------------------  
	 -- Delete the AccountDetails in the compare that are in the main snapshot  
	 ------------------------------------------------------------------------------------------------------------------------------------------  
	select @vc_sql =  
	'  
	Delete	#MTVProfitAndLoss  
	Where	Exists  
			(  
			Select	1  
			From	#MTVProfitAndLoss_Main  
			Where	#MTVProfitAndLoss_Main.AcctDtlID = #MTVProfitAndLoss.AcctDtlID  
			)  
	'  
  
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)   

 

  
	IF (@vc_AdditionalColumns LIKE '%MTVPL.FlatExposurePricedInPercentage2%' and @vc_AdditionalColumns LIKE '%MTVPL.FlatExposurePricedInPercentage,%')
		or (lower(@vc_AdditionalColumns) LIKE '%MTVPL.curveshift%')
	BEGIN  
		select @vc_sql =  
		'  
		Update	#MTVProfitAndLoss_Main  
		Set		FlatExposurePricedInPercentage2 = (select FlatExposurePricedInPercentage  
		from	#MTVProfitAndLoss    
		Where	#MTVProfitAndLoss_Main.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID)  

		'              
		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
	End  
  
	IF (@vc_AdditionalColumns LIKE '%MTVPL.FlatPriceValue2%' and @vc_AdditionalColumns LIKE '%MTVPL.FlatPriceValue,%')
		or (lower(@vc_AdditionalColumns) LIKE '%MTVPL.curveshift%')
	BEGIN  
		select @vc_sql =  
		'  
		Update	#MTVProfitAndLoss_Main  
		Set		FlatPriceValue2 = (select FlatPriceValue  
		from	#MTVProfitAndLoss    
		Where	#MTVProfitAndLoss_Main.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID)  
		'              
		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
	End  
  
  
	IF (@vc_AdditionalColumns LIKE '%MTVPL.FlatExposurePricedInPercentage2%' and @vc_AdditionalColumns LIKE '%MTVPL.FlatExposurePricedInPercentage,%')
		or (lower(@vc_AdditionalColumns) LIKE '%MTVPL.curveshift%') 
	BEGIN  
		select @vc_sql =  
		'  
		Update	#MTVProfitAndLoss_Main  
		Set		FlatExposurePricedInPercentage2 =
									(
									select	FlatExposurePricedInPercentage  
									from	#MTVProfitAndLoss    
									Where	#MTVProfitAndLoss_Main.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID
									' + Case When @c_IncludeStrategyInCompare = 'Y' Then 'And #MTVProfitAndLoss_Main.StrtgyID = #MTVProfitAndLoss.StrtgyID' Else '' End + '  
									)  

		'              
		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
	End  
  
	IF (@vc_AdditionalColumns LIKE '%MTVPL.FlatPriceValue2%' and @vc_AdditionalColumns LIKE '%MTVPL.FlatPriceValue,%')
		or (lower(@vc_AdditionalColumns) LIKE '%MTVPL.curveshift%')
	BEGIN  
		select @vc_sql =  
		'  
		Update	#MTVProfitAndLoss_Main  
		Set		FlatPriceValue2 =
									(
									select	FlatPriceValue  
									from	#MTVProfitAndLoss    
									Where	#MTVProfitAndLoss_Main.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID  
									' + Case When @c_IncludeStrategyInCompare = 'Y' Then 'And #MTVProfitAndLoss_Main.StrtgyID = #MTVProfitAndLoss.StrtgyID' Else '' End + '  
									)

		'              
		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
	End  
  

  
	 ------------------------------------------------------------------------------------------------------------------------------------------  
	 -- This code is only here due to the RightAngle bug concerning the valuation of swaps and their transaction type assignment.  It causes  
	 -- one side of the swap to reverse and rebook causing the two sides to be in different accounting periods  
	 -- First we will update rows in the main that are swaps that are accountdetails where the two sides are in different periods  
	 ------------------------------------------------------------------------------------------------------------------------------------------  
/*
	If @c_ReverseRebooks in ('E','A')  
	Begin  
		select @vc_sql =  
		'  
		Update	#MTVProfitAndLoss_Main  
		Set		#MTVProfitAndLoss_Main.P_EODSnpShtID_Compare = ' + Convert(Varchar,@i_P_EODSnpShtID_Compare) + ',  
				#MTVProfitAndLoss_Main.COB_Compare = ''' + Convert(Varchar,@sdt_EndOfDay_compare,120) + ''',  
				#MTVProfitAndLoss_Main.PositionGallons_Compare = #MTVProfitAndLoss_Main.PositionGallons,  
				#MTVProfitAndLoss_Main.PositionPounds_Compare = #MTVProfitAndLoss_Main.PositionPounds,  
				#MTVProfitAndLoss_Main.TotalValue_Compare = #MTVProfitAndLoss_Main.TotalValue,  
				#MTVProfitAndLoss_Main.MarketValue_Compare = #MTVProfitAndLoss_Main.MarketValue  
		Where	#MTVProfitAndLoss_Main.AcctDtlID is Not Null  
		And		#MTVProfitAndLoss_Main.AcctDtlID_Market is Not Null  
		And		#MTVProfitAndLoss_Main.DlDtlTmplteID in (22500,32000,32001,27001)  
		And		Exists  
				(  
				Select	1  
				From	AccountDetail Fixed (NoLock)  
						Inner Join AccountDetail Float (NoLock)	On	Float.AcctDtlID = #MTVProfitAndLoss_Main.AcctDtlID_Market  
																And	IsNull(Float.AcctDtlAccntngPrdID,0) <> IsNull(Fixed.AcctDtlAccntngPrdID,0)  
				Where	Fixed.AcctDtlID = #MTVProfitAndLoss_Main.AcctDtlID  
				)
		'  

		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  

		select @vc_sql =  
		'  
		Delete #MTVProfitAndLoss  
		Where #MTVProfitAndLoss.DlDtlTmplteID in (22500,32000,32001,27001)  
		And #MTVProfitAndLoss.AcctDtlID is Not Null   
		And #MTVProfitAndLoss.MarketValueIsMissing | #MTVProfitAndLoss.DealValueIsMissing = 1  
		And #MTVProfitAndLoss.AccountingPeriodStartDate > #MTVProfitAndLoss.TransactionDate  
		'  

		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
	End  
*/
  
  
  
	------------------------------------------------------------------------------------------------------------------------------------------  
	-- Update the EstimatedAccountDetails records that are in both snapshots  
	------------------------------------------------------------------------------------------------------------------------------------------  
	select @vc_sql =  
	'  
	Update	#MTVProfitAndLoss_Main  
	Set		#MTVProfitAndLoss_Main.P_EODSnpShtID_Compare = #MTVProfitAndLoss.P_EODSnpShtID,  
			#MTVProfitAndLoss_Main.COB_Compare = #MTVProfitAndLoss.COB,  
			#MTVProfitAndLoss_Main.PositionGallons_Compare = #MTVProfitAndLoss.PositionGallons,  
			#MTVProfitAndLoss_Main.PositionPounds_Compare = #MTVProfitAndLoss.PositionPounds,  
			#MTVProfitAndLoss_Main.TotalValue_Compare = #MTVProfitAndLoss.TotalValue,  
			#MTVProfitAndLoss_Main.MarketValue_Compare = Coalesce(#MTVProfitAndLoss.MarketValue_Override,#MTVProfitAndLoss.MarketValue,0.0),
			#MTVProfitAndLoss_Main.DiscountFactor_Compare = #MTVProfitAndLoss_Main.DiscountFactor 
	From	#MTVProfitAndLoss (NoLock)  
	Where	#MTVProfitAndLoss_Main.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID  
			' + Case When @c_IncludeStrategyInCompare = 'Y' Then 'And #MTVProfitAndLoss_Main.StrtgyID = #MTVProfitAndLoss.StrtgyID' Else '' End  

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  

  
	------------------------------------------------------------------------------------------------------------------------------------------  
	-- Delete the EADS in the compare that are in both snapshots  
	------------------------------------------------------------------------------------------------------------------------------------------  

	select @vc_sql =  
	'  
	Delete	#MTVProfitAndLoss  
	Where	Exists  
			(  
			Select	1  
			From	#MTVProfitAndLoss_Main  
			Where	#MTVProfitAndLoss_Main.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID  
			' + Case When @c_IncludeStrategyInCompare = 'Y' Then 'And #MTVProfitAndLoss_Main.StrtgyID = #MTVProfitAndLoss.StrtgyID' Else '' End + '  
			)
	'  

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
  
  
	------------------------------------------------------------------------------------------------------------------------------------------  
	-- Update the Risk records that are in both snapshots  
	------------------------------------------------------------------------------------------------------------------------------------------  
	select @vc_sql =  
	'  
	Update	#MTVProfitAndLoss_Main  
	Set		#MTVProfitAndLoss_Main.P_EODSnpShtID_Compare = #MTVProfitAndLoss.P_EODSnpShtID,  
			#MTVProfitAndLoss_Main.COB_Compare = #MTVProfitAndLoss.COB,  
			#MTVProfitAndLoss_Main.PositionGallons_Compare = #MTVProfitAndLoss.PositionGallons,  
			#MTVProfitAndLoss_Main.PositionPounds_Compare = #MTVProfitAndLoss.PositionPounds,  
			#MTVProfitAndLoss_Main.TotalValue_Compare = #MTVProfitAndLoss.TotalValue,  
			#MTVProfitAndLoss_Main.MarketValue_Compare = #MTVProfitAndLoss.MarketValue,
			#MTVProfitAndLoss_Main.DiscountFactor_Compare = #MTVProfitAndLoss_Main.DiscountFactor 
	From	#MTVProfitAndLoss (NoLock)  
	Where	#MTVProfitAndLoss_Main.RisKID is Not Null  
	And		#MTVProfitAndLoss.RisKID is Not Null  
	And		#MTVProfitAndLoss_Main.RisKID = #MTVProfitAndLoss.RisKID  
	' + Case When @c_IncludeStrategyInCompare = 'Y' Then 'And #MTVProfitAndLoss_Main.StrtgyID = #MTVProfitAndLoss.StrtgyID' Else '' End  


	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
  
  

	------------------------------------------------------------------------------------------------------------------------------------------  
	-- Delete the Risk records in the compare that are in both snapshots  
	------------------------------------------------------------------------------------------------------------------------------------------  
	select @vc_sql =  
	'  
	Delete	#MTVProfitAndLoss  
	Where	Exists
			(
			Select	1  
			From	#MTVProfitAndLoss_Main  
			Where	#MTVProfitAndLoss_Main.RiskID = #MTVProfitAndLoss.RiskID  
			' + Case When @c_IncludeStrategyInCompare = 'Y' Then 'And #MTVProfitAndLoss_Main.StrtgyID = #MTVProfitAndLoss.StrtgyID' Else '' End + '  
			)  
	'  

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
  
  
  
	------------------------------------------------------------------------------------------------------------------------------------------  
	-- Update the remaining records in the comparison snapshot  
	------------------------------------------------------------------------------------------------------------------------------------------  
	select @vc_sql =  
	'  
	Update	#MTVProfitAndLoss  
	Set		#MTVProfitAndLoss.P_EODSnpShtID = ' + Convert(varchar,@i_P_EODSnpShtID) + ',  
			#MTVProfitAndLoss.COB = ''' + Convert(Varchar,@sdt_EndOfDay,120) + ''',  
			#MTVProfitAndLoss.P_EODSnpShtID_Compare = #MTVProfitAndLoss.P_EODSnpShtID,  
			#MTVProfitAndLoss.COB_Compare = #MTVProfitAndLoss.COB,  
			#MTVProfitAndLoss.PositionGallons_Compare = #MTVProfitAndLoss.PositionGallons,  
			#MTVProfitAndLoss.PositionPounds_Compare = #MTVProfitAndLoss.PositionPounds,  
			#MTVProfitAndLoss.MarketValue_Compare = Coalesce(#MTVProfitAndLoss.MarketValue_Override,#MTVProfitAndLoss.MarketValue,0.0),  
			#MTVProfitAndLoss.TotalValue_Compare = #MTVProfitAndLoss.TotalValue,  
			#MTVProfitAndLoss.PositionGallons = 0.0,  
			#MTVProfitAndLoss.PositionPounds = 0.0,  
			#MTVProfitAndLoss.MarketValue = 0.0,  
			#MTVProfitAndLoss.TotalPnL = 0.0,  
			#MTVProfitAndLoss.TotalValue = 0.0,  
			#MTVProfitAndLoss.MarketValue_Override = 0.0,
			#MTVProfitAndLoss.DiscountFactor = 0.0  
	'  

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
  
  
	------------------------------------------------------------------------------------------------------------------------------------------  
	-- Insert the main records into the temp table  
	------------------------------------------------------------------------------------------------------------------------------------------  
	select @vc_sql =  
	'  
	Insert	#MTVProfitAndLoss  
	select	*  
	From	#MTVProfitAndLoss_Main (NoLock)
	'  

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  

	 ------------------------------------------------------------------------------------------------------------------------------------------  
	 -- Update the the compare instancedatetime and end of day on all the records  
	 ------------------------------------------------------------------------------------------------------------------------------------------  
	 select @vc_sql =  
	'  
	Update	#MTVProfitAndLoss  
	Set		#MTVProfitAndLoss.P_EODSnpShtID_Compare = ' + Convert(Varchar,@i_P_EODSnpShtID_compare,120) + ',  
			#MTVProfitAndLoss.COB_Compare = ''' + Convert(Varchar,@sdt_EndOfDay_compare,120) + '''  
	Where	#MTVProfitAndLoss.P_EODSnpShtID_Compare is Null  
	And		#MTVProfitAndLoss.COB_Compare is Null  
	'  

	if @c_OnlyShowSQL = 'Y' if @vc_sql is not null select @vc_SQL else select '--@vc_SQL is null' Else if @vc_sql is not null Exec(@vc_SQL)   

END -- if @i_P_EODSnpShtID_Compare is not null
 

IF @vc_AdditionalColumns LIKE '%MTVPL.CurveShift%'   BEGIN  
	select @vc_sql =  
	'  
	Update	#MTVProfitAndLoss  
	Set		CurveShift = (FlatPriceValue - FlatPriceValue2) * FlatExposurePricedInPercentage2  
	'              
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)  
End  

  
  
 
--------------------------------------------------------------------------
-- Add and Update the CorporatePortfolio column
---------------------------------------------------------------------------
select	@vc_SqL =
'
Alter	Table  #MTVProfitAndLoss 
Add		CorporatePortfolio	Varchar(50)  
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



select	@vc_SQL = 
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss .CorporatePortfolio = P_Portfolio.Name
From	P_PortfolioStrategyFlat (NoLock)
		Inner Join P_Portfolio (NoLock)	On	P_Portfolio.P_PrtflioID = P_PortfolioStrategyFlat.P_PrtflioID
Where	P_PortfolioStrategyFlat.StrtgyID = #MTVProfitAndLoss.StrtgyID
And		Exists
		(
		Select	1
		From	P_PortfolioBranch (NoLock)
		Where	P_PortfolioBranch.PrntP_PrtflioID = (Select top 1 P_Portfolio.P_PrtflioID From P_Portfolio where P_Portfolio.IsCorporate = ''Y'')
		And		P_PortfolioBranch.ChldP_PrtflioID = P_PortfolioStrategyFlat.P_PrtflioID
		)


'


If @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


--------------------------------------------------------------------------
-- Add and Update the DelVETradePeriodID
---------------------------------------------------------------------------
select	@vc_SqL =
'
Alter	Table  #MTVProfitAndLoss 
Add		DelVETradePeriodID	Int  
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


select	@vc_SQL = 
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.DelVETradePeriodID = VETradePeriod.VETradePeriodID
From	VETradePeriod
Where	VETradePeriod.[Type] = ''M''
And		#MTVProfitAndLoss.DeliveryPeriodStartDate Between VETradePeriod.StartDate And VETradePeriod.EndDate
'


If @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


-------------------------------------------------------------------------------
-- Update the trader for in houses where it is null b/c for some reason it is not
-- being saved on both details in DealDetail.DlDtlIntrnlUserID
-------------------------------------------------------------------------------
Select	@vc_SQL =
'
Update	#MTVProfitAndLoss
Set		#MTVProfitAndLoss.Trader = Isnull(Users.UserID, DealHeader.DlHdrIntrnlUserID)
From	#MTVProfitAndLoss
		Inner Join DealHeader (NoLock) on DealHeader.DlHdrID = #MTVProfitAndLoss.DlHdrID
		Left Outer Join Users (NoLock) on Users.UserCntctID = DealHeader.DlHdrExtrnlCntctID
Where	#MTVProfitAndLoss.Trader is Null
And		#MTVProfitAndLoss.DlDtlTmplteID in (340000,341000,32000,32001,35000,23100,23101,23102,23103,33000,33001,33002,33003,30000,30001,31000,31001)
'

If @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

---------------------------------------------------------------------------------------------------------------------------------------------  
-- Delete remittable taxes if paramater is set to exclude them
---------------------------------------------------------------------------------------------------------------------------------------------  
If @c_ShowRemittableTaxes = 'N'
Begin
	Select	@vc_SQL = 
	'
	Delete	#MTVProfitAndLoss
	Where	#MTVProfitAndLoss.AcctDtlSrceTble = ''T''
	And		Exists
			(
			Select	1
			From	TaxDetailLog
					Inner Join TaxDetail	On	TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
											And	TaxDetail.TxDtlRmt = ''Y''
			Where	TaxDetailLog.TxDtlLgID = #MTVProfitAndLoss.AcctDtlSrceID
			)
	'
	If @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End 



Select	@vc_SQL = 'Alter Table #MTVProfitAndLoss Add ID Int Identity'
If @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


---------------------------------------------------------------------------------------------------------------------------------------------  
-- Have to make the navigation keys not null or navigation will not work (AcctDtlID, P_EODEstmtedAccntDtlID, RiskID, P_EODSnpShtID)  
---------------------------------------------------------------------------------------------------------------------------------------------  
  
select @vc_Select =   
'   
Select  MTVPL.ID															as		ID,
		MTVPL.DealNumber													as		DealNumber						, --	Varchar(2000)
		IsNull(MTVPL.AcctDtlID,0)											as		AcctDtlID						, --	Int
		MTVPL.P_EODBAVID													as		P_EODBAVID						, --	Int
		IsNull(MTVPL.P_EODEstmtedAccntDtlID,0)								as		P_EODEstmtedAccntDtlID			, --	Int
		IsNull(MTVPL.RiskID,0)												as		RiskID							, --	Int
		MTVPL.DlHdrID														as		DlHdrID							, --	Int
		MTVPL.DlDtlID														as		DlDtlID							, --	Int
		MTVPL.PlnndTrnsfrID													as		PlnndTrnsfrID					, --	Int
		MTVPL.PrdctID														as		PrdctID							, --	Int
		MTVPL.ChildPrdctID													as		ChildPrdctID					, --	Int
		MTVPL.LcleID														as		LcleID							, --	Int
		MTVPL.MvtHdrID														as		MvtHdrID						, --	Int
		MTVPL.DlDtlPrvsnID													as		DlDtlPrvsnID					, --	Int
		MTVPL.DlDtlPrvsnRwID												as		DlDtlPrvsnRwID					, --	Int
		MTVPL.TrnsctnTypID													as		TrnsctnTypID					, --	Int
		MTVPL.AccountingPeriodStartDate										as		AccountingPeriodStartDate		, --	SmallDateTime
		MTVPL.DeliveryPeriodStartDate										as		DeliveryPeriodStartDate			, --	SmallDateTime
		MTVPL.TransactionDate												as		TransactionDate					, --	SmallDateTime
		MTVPL.StrtgyID														as		StrtgyID						, --	Int
		MTVPL.InternalBAID													as		InternalBAID					, --	Int
		MTVPL.ExternalBAID													as		ExternalBAID					, --	Int
		MTVPL.AcctDtlSrceTble												as		AcctDtlSrceTble					, --	Char(2)
		MTVPL.AcctDtlSrceID													as		AcctDtlSrceID					, --	Int
		MTVPL.RiskSourceTable												as		RiskSourceTable					, --	Char(2)
		MTVPL.RiskCostSourceTable											as		RiskCostSourceTable				, --	Char(2)
		/*IsNull((Case When MTVPL.ValuationGallons = 0 Then 0.0 Else Case When IsNull(MTVPL.P_EODBAVID,0) = 0 And IsNull(MTVPL.AcctDtlID,0) <> 0 Then Case When MTVPL.IsReversal = ''Y'' Then -1.0 Else 1.0 End * Case When MTVPL.WePayTheyPay = ''R'' Then -1.0 Else 1.0 End * MTVPL.TotalValue / abs(MTVPL.ValuationGallons) Else Case When MTVPL.WePayTheyPay in (''R'',''B'') Then -1.0 Else 1.0 End * Case When MTVPL.IsReversal=''Y'' Then -1.0 Else 1.0 End * MTVPL.TotalValue / abs(MTVPL.ValuationGallons) End End),0.0)  PerUnitValue,  */
		IsNull((Case	When MTVPL.ValuationGallons = 0
						Then 0.0 Else Case	When MTVPL.WePayTheyPay in (''R'',''B'')
											Then -1.0 Else 1.0
										End
					* Case	When MTVPL.IsReversal=''Y''
							Then -1.0 Else 1.0
						End
					* MTVPL.TotalValue / abs(MTVPL.ValuationGallons)
				End ),0.0)													as		PerUnitValue,
		MTVPL.ValuationGallons												as		ValuationGallons				, --	Decimal(28,6)
		MTVPL.PositionGallons												as		PositionGallons					, --	Decimal(28,6)
		MTVPL.PositionPounds												as		PositionPounds					, --	Decimal(28,6)
		IsNull(MTVPL.TotalValue,0.0)										as		TotalValue						, --	Decimal(28,6)
		IsNull((MTVPL.MarketValue / Case	When MTVPL.PositionGallons = 0
											Then 1.0 Else MTVPL.PositionGallons
									End),0.0)								as		MktPerUnitValue,
		IsNull(MTVPL.MarketValue,0.0)										as		MarketValue						, --	Decimal(28,6)
		IsNull(MTVPL.TotalValue,0.0) + Isnull(MTVPL.MarketValue,0.0)		as		TotalPnL						, --	Decimal(28,6)

		IsNull((Isnull(MTVPL.MarketValue_Override,MTVPL.MarketValue) / Case When MTVPL.PositionGallons = 0 Then 1.0 Else MTVPL.PositionGallons End),0.0) as	MktPerUnitValue_Override,  
		Coalesce(MTVPL.MarketValue_Override,MTVPL.MarketValue,0.0)			as		MarketValue_Override			, --	Decimal(28,6)
		Coalesce(MTVPL.TotalValue_Override,MTVPL.TotalValue,0.0) + Coalesce(MTVPL.MarketValue_Override,MTVPL.MarketValue,0.0) as	TotalPnL_Override,  
		MTVPL.PaymentCrrncyID												as		PaymentCrrncyID					, --	Int
		MTVPL.MarketCrrncyID												as		MarketCrrncyID					, --	Int
		MTVPL.TotalValueFXRate												as		TotalValueFXRate				, --	Float
		MTVPL.MarketValueFXRate												as		MarketValueFXRate				, --	Float
		MTVPL.DlDtlTmplteID													as		DlDtlTmplteID					, --	Int
		MTVPL.SpecificGravity												as		SpecificGravity					, --	Decimal(28, 13)
		MTVPL.Energy														as		Energy							, --	Float
		MTVPL.CostType														as		CostType						, --	Char(1)
		Case MTVPL.DealValueIsMissing When 1 Then ''Y'' Else ''N'' End		as		DealValueIsMissing				, --	Char(1)
		Case MTVPL.MarketValueIsMissing When 1 Then ''Y'' Else ''N'' End	as		MarketValueIsMissing			, --	Char(1)
		MTVPL.WePayTheyPay													as		WePayTheyPay					, --	Char(1)
		MTVPL.IsReversal													as		IsReversal						, --	Char(1)
		MTVPL.COB															as		COB								, --	SmallDateTime
		Case	When MTVPL.DlDtlTmplteID in (22500,32000,32001,27001)
				Then MTVPL.WePayTheyPay Else MTVPL.ReceiptDelivery
		End																	as		ReceiptDelivery					, --	Char(1)
		MTVPL.Trader														as		Trader							, --	Int
		Case	When MTVPL.TradeDate is Null
				Then Convert(smalldatetime,null)
				else convert(smalldateTime,str(Year(MTVPL.TradeDate)) + ''-'' + str(month(MTVPL.TradeDate)) + ''-'' + str(day(MTVPL.TradeDate)))
		End																	as		TradeDate						, --	SmallDateTime
		MTVPL.IsPPA															as		IsPPA							, --	Char(1)
		MTVPL.P_EODSnpShtID													as		P_EODSnpShtID					, --	Int
		MTVPL.COB_Compare													as		COB_Compare						, --	SmallDateTime
		MTVPL.P_EODSnpShtID_Compare											as		P_EODSnpShtID_Compare			, --	Int
		Isnull(MTVPL.PositionGallons_Compare,0.0)							as		PositionGallons_Compare			, --	Decimal(28,6)
		IsNull(MTVPL.PositionPounds_Compare,0.0)							as		PositionPounds_Compare			, --	Decimal(28,6)
		Isnull(MTVPL.TotalValue_Compare,0.0)								as		TotalValue_Compare				, --	Decimal(28,6)
		Isnull(MTVPL.MarketValue_Compare,0.0)								as		MarketValue_Compare				, --	Decimal(28,6)
		IsNull(MTVPL.TotalValue_Compare,0.0) + Isnull(MTVPL.MarketValue_Compare,0.0) as	TotalPnL_Compare,  
		MTVPL.DlDtlPrvsnUOMID												as		DlDtlPrvsnUOMID					, --	Int
		MTVPL.DlDtlDsplyUOM													as		DlDtlDsplyUOM					, --	Int
		MTVPL.P_EODEstmtedAccntDtlID_Market									as		P_EODEstmtedAccntDtlID_Market	, --	Int
		MTVPL.UserID_OverriddenBy											as		UserID_OverriddenBy				, --	Int
--		MTVPL.DlHdrDscrptn,  
		Coalesce(MTVPL.TotalValue_Override,MTVPL.TotalValue,0.0)			as		TotalValue_Override				, --	Decimal(28,6)
		IsNull((Case	When MTVPL.ValuationGallons = 0
						Then 0.0
						Else Coalesce(MTVPL.TotalValue_Override,Case	When MTVPL.WePayTheyPay in (''R'',''B'')
																		Then -1.0 Else 1.0
																End
															* Case	When MTVPL.IsReversal=''Y''
																	Then -1.0 Else 1.0
															End
															* MTVPL.TotalValue) / Case When MTVPL.TrnsctnTypID in (2155, 2154) and MTVPL.ValuationGallons = .000001 Then 1.0 Else ABS(MTVPL.ValuationGallons) End End),0.0) as	PerUnitValue_Override,  
		MTVPL.userid_overriddenby_Trade										as		UserID_OverriddenBy_Trade		, --	Int
		MTVPL.P_EODEstmtedAccntDtlVleID										as		P_EODEstmtedAccntDtlVleID		, --	Int
		MTVPL.PaymentDueDate												as		PaymentDueDate					, --	SmallDateTime
		MTVPL.DiscountFactor												as		DiscountFactor					, --	Float
		MTVPL.DiscountFactor_Compare										as		DiscountFactor_Compare			, --	Float
		IsNull(MTVPL.CorporatePortfolio, ''Unassigned''),
		MTVPL.FlatPriceCurveName											as		FlatPriceCurveName				, --	Varchar(100)
		MTVPL.BaseMarketCurveName											as		BaseMarketCurveName				, --	Varchar(100)
		MTVPL.FormulaOffset													as		FormulaOffset					, --	Decimal(19,6)
		MTVPL.FormulaPercentage												as		FormulaPercentage				, --	Decimal(19,6)
		MTVPL.PricedInPercentage											as		PricedInPercentage				, --	Float
		MTVPL.QuoteStartDate												as		QuoteStartDate					, --	SmallDateTime
		MTVPL.QuoteEndDate													as		QuoteEndDate					, --	SmallDateTime
'  
  
select @vc_Select_Additional =  
'  
		SystemInventoryValue												as		SystemInventoryValue			 --	Decimal(28,6)
'  
  
select @vc_From =   
'
From	#MTVProfitAndLoss MTVPL
'  
  
Select @vc_Where =   
'  
Where 1=1  
'  
  
  
Execute dbo.sp_Add_Additional_Columns	@i_RprtCnfgID  = @i_RprtCnfgID,  
										@vc_AdditionalColumns = @vc_AdditionalColumns,  
										@c_UseANSISQL  = 'Y',  
										@vc_DynamicSQL_Select = @vc_Select_Additional Out,  
										@vc_DynamicSQL_From = @vc_From Out,  
										@vc_DynamicSQL_Where = @vc_Where Out  
  

  
  
select @vc_From = Replace(@vc_From,'@@InstanceDateTime@@','''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''')  
select @vc_where = Replace(@vc_where,'@@InstanceDateTime@@','''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''')  
select @vc_From = Replace(@vc_From,'@@SnapShotInstanceDateTime@@','''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''')  
select @vc_where = Replace(@vc_where,'@@SnapShotInstanceDateTime@@','''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''')  
  
  
if @c_OnlyShowSQL = 'Y'  
Begin  
	select @vc_select  
	select @vc_Select_Additional  
	select @vc_From  
	select @vc_where  
End  
Else  
Begin  
	exec(@vc_select + @vc_Select_Additional + @vc_From + @vc_where)  
End  
  

  
  
  
Set NoCount OFF  

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_ProfitAndLoss.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ProfitAndLoss >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ProfitAndLoss >>>'
	  END