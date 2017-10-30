If OBJECT_ID('Custom_Calculate_Unrealized_Earnings') Is Not NULL
Begin
    DROP PROC Custom_Calculate_Unrealized_Earnings
    PRINT '<<< DROPPED PROC Custom_Calculate_Unrealized_Earnings>>>'
End
GO
Create Procedure dbo.Custom_Calculate_Unrealized_Earnings	 @i_P_EODSnpShtID	int				= Null
															,@i_AccntngPrdID	int				= Null
															,@vc_InternalBAID	varchar(2000)	= '0'
															,@vc_SQL_Insert		varchar(8000)	= Null
															,@c_OnlyShowSQL		char(1)			= 'N'
															
As	
-----------------------------------------------------------------------------------------------------------------------------
-- Name:			Custom_Calculate_Unrealized_Earnings @i_P_EODSnpShtID = 144, @i_AccntngPrdID = 295, @c_OnlyShowSQL = 'Y'  Copyright 2003 SolArc
-- Overview:	
--		
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:		Joshua Weber
-- History:			18/06/2012 - First Created
--
-- 	Date Modified 	Modified By			Issue#	Modification
-- 	--------------- -------------- 		------	-------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set ANSI_NULLS ON
Set ANSI_PADDING ON
Set ANSI_Warnings OFF
Set Quoted_Identifier OFF
Set Concat_Null_Yields_Null ON

----------------------------------------------------------------------------------------------------------------------------------
-- Block 10: Local Variables 
----------------------------------------------------------------------------------------------------------------------------------
Declare	@vc_DynamicSQL					varchar(max)
		,@i_StartedFromVETradePeriodID	int
		,@sdt_InstanceDateTime			smalldatetime
		,@sdt_EndOfDay					smalldatetime
		,@i_XGroup_Qualifier			int
		,@sdt_TradePeriodStartDate		smalldatetime
		,@sdt_TradePeriodEndDate		smalldatetime
		,@sdt_AccntngPrdBgnDte			smalldatetime
		,@sdt_AccntngPrdEndDte			smalldatetime
		,@i_FwdVETradePeriodID			int
		,@sdt_FwdVETradePeriodStartDate	smalldatetime
		,@sdt_FwdVETradePeriodEndDate	smalldatetime
		,@i_FwdAccntngPrdID				int	
		,@i_MonthlyGL_XGrpID			int
		,@i_CurrencyRPHdrID				int	
		,@i_CurrentDefaultPriceType		int
		,@i_CurrencyDefaultLcleID		int
		,@i_SalesAccrualXTypeID			int
		,@i_PurchAccrualXTypeID			int
		,@i_IncompleteAccrualXTypeID	int			

----------------------------------------------------------------------------------------------------------------------------------
-- Set the snapshot control variables
----------------------------------------------------------------------------------------------------------------------------------		
Select	 @i_StartedFromVETradePeriodID	= StartedFromVETradePeriodID
		,@sdt_InstanceDateTime			= InstanceDateTime 
		,@sdt_EndOfDay					= EndOfDay
From	Snapshot	(NoLock)
Where	P_EODSnpShtID	= @i_P_EODSnpShtID

----------------------------------------------------------------------------------------------------------------------------------
-- Set the trade period from and to date
----------------------------------------------------------------------------------------------------------------------------------
Select	 @sdt_TradePeriodStartDate	= StartDate
		,@sdt_TradePeriodEndDate	= EndDate
From	VETradePeriod	(NoLock)
Where	VETradePeriodID	= @i_StartedFromVETradePeriodID 

----------------------------------------------------------------------------------------------------------------------------------
-- Set the current accounting period
----------------------------------------------------------------------------------------------------------------------------------
If	@i_AccntngPrdID	Is Null
	Select	@i_AccntngPrdID	= AccntngPrdID
	From	PeriodTranslation	(NoLock)
	Where	VETradePeriodID = @i_StartedFromVETradePeriodID 

----------------------------------------------------------------------------------------------------------------------------------
-- Set the current accounting period from and to dates
----------------------------------------------------------------------------------------------------------------------------------
Select	 @sdt_AccntngPrdBgnDte	= AccntngPrdBgnDte			
		,@sdt_AccntngPrdEndDte	= AccntngPrdEndDte
From	AccountingPeriod	(NoLock)
Where	AccntngPrdID	= @i_AccntngPrdID

----------------------------------------------------------------------------------------------------------------------------------
-- Set the forward trade period
----------------------------------------------------------------------------------------------------------------------------------
Select	@i_FwdVETradePeriodID	= (	Select	Top 1 VETradePeriodID 
									From	VETradePeriod	(NoLock)
									Where	VETradePeriodID	> @i_StartedFromVETradePeriodID
									And		Type			= 'M'
									Order By VETradePeriodID Asc)

----------------------------------------------------------------------------------------------------------------------------------
-- Set the forward trade period from and to date
----------------------------------------------------------------------------------------------------------------------------------
Select	 @sdt_FwdVETradePeriodStartDate	= StartDate	
		,@sdt_FwdVETradePeriodEndDate	= EndDate
From	VETradePeriod	(NoLock)
Where	VETradePeriodID	= @i_FwdVETradePeriodID

----------------------------------------------------------------------------------------------------------------------------------
-- Set the forward accounting period
----------------------------------------------------------------------------------------------------------------------------------
Select	@i_FwdAccntngPrdID	= AccntngPrdID
From	PeriodTranslation	(NoLock)
Where	VETradePeriodID	= @i_FwdVETradePeriodID

----------------------------------------------------------------------------------------------------------------------------------
-- Check to see if the user is retrieving MTM based on XGroup, this is set up in the PAT control panel
----------------------------------------------------------------------------------------------------------------------------------
Execute sp_get_registry_value 'System\PortfolioAnalysis\MTMXGroupQualifier', @i_XGroup_Qualifier Output
Select	@i_SalesAccrualXTypeID = TransactionType.TrnsctnTypID
From	Registry (NoLock)
		Inner Join TransactionType (NoLock)
			on	TransactionType.TrnsctnTypDesc = Registry.RgstryDtaVle
Where	RgstryFllKyNme = 'Motiva\SAP\GLXctnTypes\SalesAccrual\'

Select	@i_PurchAccrualXTypeID = TransactionType.TrnsctnTypID
From	Registry (NoLock)
		Inner Join TransactionType (NoLock)
			on	TransactionType.TrnsctnTypDesc = Registry.RgstryDtaVle
Where	RgstryFllKyNme = 'Motiva\SAP\GLXctnTypes\PurchaseAccrual\'

Select	@i_IncompleteAccrualXTypeID = TransactionType.TrnsctnTypID
From	Registry (NoLock)
		Inner Join TransactionType (NoLock)
			on	TransactionType.TrnsctnTypDesc = Registry.RgstryDtaVle
Where	RgstryFllKyNme = 'Motiva\SAP\GLXctnTypes\IncompletePricingAccrual\'

----------------------------------------------------------------------------------------------------------------------
-- Set the Transaction Type/Group Values that we will need
----------------------------------------------------------------------------------------------------------------------
Select	@i_MonthlyGL_XGrpID = XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Exclude From Monthly GL'

----------------------------------------------------------------------------------------------------------------------
-- Set the price service variables
----------------------------------------------------------------------------------------------------------------------
Select	@i_CurrencyRPHdrID			= ExchangeRatePublisherId
		,@i_CurrentDefaultPriceType	= ExchangeRatePriceTypeId	
		,@i_CurrencyDefaultLcleID	= ExchangeRateLocationId	
From	ConfigValuation	(NoLock)
Where	ConfigurationName	= 'Default'

----------------------------------------------------------------------------------------------------------------------------------
-- Block 20: Temp Tables
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Create #RiskResults
----------------------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'Y'
	Begin
		Select	'	
		Create Table	#RiskResults
						(Idnty									Int				Not Null	Identity,
						RiskSourceValueID 						Int 			Null		Default 0,
						RiskID									Int				Not Null,
						SourceTable								VarChar(3)		Not Null,
						IsPrimaryCost							Bit				Not Null,
						DlDtlTmplteID							Int				Null,
						TmplteSrceTpe							VarChar(2)		Null,
						RiskExposureTableIdnty					Int				Null,
						Percentage								Float			Null,
						RiskCurveID								Int				Null,
						DeliveryPeriodStartDate					smalldatetime	Not Null,
						DeliveryPeriodEndDate					smalldatetime 	Not Null,
						AccountingPeriodStartDate				smalldatetime	Not Null,
						AccountingPeriodEndDate					smalldatetime	Not Null,
						Position								Decimal(28, 6)	Null		Default 0.0,
						ValuationPosition						Decimal(28, 6)	Null		Default 0.0,
						SpecificGravity							Float			Null		Default 0.0,
						Energy									Float			Null		Default 0.0,
						TotalPnL								Float			Null		Default 0.0,
						PricedPnL								Float			Null		Default 0.0,
						TotalValue								Float			Null		Default 0.0,
						PricedValue								Float			Null		Default 0.0,
						MarketValue								Float			Null		Default 0.0,
						PricedInPercentage						Decimal(28, 13)	Null		Default 1.0,
						MarketValueIsMissing					Bit				Not Null	Default	0,
						DealValueIsMissing						Bit				Not Null	Default	0,
						MarketCrrncyID							SmallInt		Null,
						PaymentCrrncyID							smallint		Null,
						MarketValueFXRate						Float			Not Null	Default 1.0,
						TotalValueFXRate						Float			Not Null	Default	1.0,
						PricedValueFXRate						Float			Not Null	Default 1.0,
						DiscountFactor							Float			Not Null	Default 1.0,
						DiscountFactorID						Int				Null,
						MarketDiscountFactor					Float			Not Null	Default 1.0,
						MarketDiscountFactorID					Int				Null,
						SplitType								VarChar(10)		Null,
						DefaultCurrencyID						Int				Null,
						InstanceDateTime						smalldatetime	Not Null,
						IsPPA									Bit				Not Null	Default 0,
						IsPriorMonthTransaction					Bit				Not Null	Default 0,
						IsEstMovementWithFuturePricing			Bit				Not Null	Default 0,
						FloatingPerUnitValue					Float			Null		Default 0.0,
						PricedInPerUnitValue					Float			Null		Default 0.0,
						CloseOfBusiness							SmallDateTime	Null,
						Snapshot								Int				Null,
						SnapshotDateTime						SmallDateTime	Null,
						SnapshotAccountingPeriod				SmallDateTime	Null,
						SnapshotTradePeriod						SmallDateTime	Null,
						SnapshotIsArchived						Bit				Not Null	Default 0,
						HistoricalPnLExists						Bit				Not Null	Default 0,
						ShowZeroPosition						Bit				Not Null	Default 0,
						ShowZeroMarketValue						Bit				Not Null	Default 0,
						IsInventoryMove 						VarChar(3) 		Null		Default ''No'',
						Account 								VarChar(9)		Null		Default ''Trading'',
						IsEstMovementWithFuturePricing_Balance	Bit				Not Null	Default 0,
						ReplaceTotalValuewithMarket				Bit				Not Null	Default 0,
						AttachedInHouse							Char(1)			Not Null	Default ''N'',
						EstimatedPaymentDate					SmallDateTime	Null,
						UnAdjustedPosition						Float			Not Null	Default 0.0
						,RelatedSwapRiskID						Int				Null
						,IsFlatFee								Bit				Not Null	Default 0
						,PrdctID								Int				Null
						,ChmclID								Int				Null
						,LcleID									Int				Null
						,TotalQuotePercentage					Float			Not Null	Default 0.0
						,TotalPricedPercentage					Float			Not Null	Default 0.0
						,SellSwapPricedValue					Float			Null		Default 0.0
						,LeaseDealDetailID						Int				Null
						,IsOption								Bit				Not Null	Default 0
						,MoveExternalDealID						Int				Null
						,ConversionCrrncyID						Int				Null
						,RelatedDealNumber						Varchar(200)	Null
						,ApplyDiscount 							Bit				Not Null default 0
						,MarketValueFXConversionDate 			SmallDateTime	Null
						,DealValueFXConversionDate 				SmallDateTime	Null
						,CurrencyPairID 						SmallInt		Null
						,IsReciprocal 							Bit				Null
						,FxForwardRate 							Float			Null
						,CurrencyPairFxRate 					Float			Null
						,CurrencyPairFxRateErrors 				VarChar(8000)	Null	
						,DlDtlPrvsnPriceCurveID					int				Null
						,MarketCurveID							int				Null)

						Create NonClustered Index ID_RiskID_InstanceDateTime_IsPriorMonthTransaction on #RiskResults (RiskID, InstanceDateTime,IsPriorMonthTransaction )
						Create NonClustered Index IE_RiskID_DlDtlTmplteID on #RiskResults (RiskID,DlDtlTmplteID)	
				'
	End
Else
	Begin
		Create Table	#RiskResults
						(Idnty									Int				Not Null	Identity,
						RiskSourceValueID 						Int 			Null		Default 0,
						RiskID									Int				Not Null,
						SourceTable								VarChar(3)		Not Null,
						IsPrimaryCost							Bit				Not Null,
						DlDtlTmplteID							Int				Null,
						TmplteSrceTpe							VarChar(2)		Null,
						RiskExposureTableIdnty					Int				Null,
						Percentage								Float			Null,
						RiskCurveID								Int				Null,
						DeliveryPeriodStartDate					smalldatetime	Not Null,
						DeliveryPeriodEndDate					smalldatetime 	Not Null,
						AccountingPeriodStartDate				smalldatetime	Not Null,
						AccountingPeriodEndDate					smalldatetime	Not Null,
						Position								Decimal(28, 6)	Null		Default 0.0,
						ValuationPosition						Decimal(28, 6)	Null		Default 0.0,
						SpecificGravity							Float			Null		Default 0.0,
						Energy									Float			Null		Default 0.0,
						TotalPnL								Float			Null		Default 0.0,
						PricedPnL								Float			Null		Default 0.0,
						TotalValue								Float			Null		Default 0.0,
						PricedValue								Float			Null		Default 0.0,
						MarketValue								Float			Null		Default 0.0,
						PricedInPercentage						Decimal(28, 13)	Null		Default 1.0,
						MarketValueIsMissing					Bit				Not Null	Default	0,
						DealValueIsMissing						Bit				Not Null	Default	0,
						MarketCrrncyID							SmallInt		Null,
						PaymentCrrncyID							smallint		Null,
						MarketValueFXRate						Float			Not Null	Default 1.0,
						TotalValueFXRate						Float			Not Null	Default	1.0,
						PricedValueFXRate						Float			Not Null	Default 1.0,
						DiscountFactor							Float			Not Null	Default 1.0,
						DiscountFactorID						Int				Null,
						MarketDiscountFactor					Float			Not Null	Default 1.0,
						MarketDiscountFactorID					Int				Null,
						SplitType								VarChar(10)		Null,
						DefaultCurrencyID						Int				Null,
						InstanceDateTime						smalldatetime	Not Null,
						IsPPA									Bit				Not Null	Default 0,
						IsPriorMonthTransaction					Bit				Not Null	Default 0,
						IsEstMovementWithFuturePricing			Bit				Not Null	Default 0,
						FloatingPerUnitValue					Float			Null		Default 0.0,
						PricedInPerUnitValue					Float			Null		Default 0.0,
						CloseOfBusiness							SmallDateTime	Null,
						Snapshot								Int				Null,
						SnapshotDateTime						SmallDateTime	Null,
						SnapshotAccountingPeriod				SmallDateTime	Null,
						SnapshotTradePeriod						SmallDateTime	Null,
						SnapshotIsArchived						Bit				Not Null	Default 0,
						HistoricalPnLExists						Bit				Not Null	Default 0,
						ShowZeroPosition						Bit				Not Null	Default 0,
						ShowZeroMarketValue						Bit				Not Null	Default 0,
						IsInventoryMove 						VarChar(3) 		Null		Default 'No',
						Account 								VarChar(9)		Null		Default 'Trading',
						IsEstMovementWithFuturePricing_Balance	Bit				Not Null	Default 0,
						ReplaceTotalValuewithMarket				Bit				Not Null	Default 0,
						AttachedInHouse							Char(1)			Not Null	Default 'N',
						EstimatedPaymentDate					SmallDateTime	Null,
						UnAdjustedPosition						Float			Not Null	Default 0.0
						,RelatedSwapRiskID						Int				Null
						,IsFlatFee								Bit				Not Null	Default 0
						,PrdctID								Int				Null
						,ChmclID								Int				Null
						,LcleID									Int				Null
						,TotalQuotePercentage					Float			Not Null	Default 0.0
						,TotalPricedPercentage					Float			Not Null	Default 0.0
						,SellSwapPricedValue					Float			Null		Default 0.0
						,LeaseDealDetailID						Int				Null
						,IsOption								Bit				Not Null	Default 0
						,MoveExternalDealID						Int				Null
						,ConversionCrrncyID						Int				Null
						,RelatedDealNumber						Varchar(200)	Null
						,ApplyDiscount 							Bit				Not Null default 0
						,MarketValueFXConversionDate 			SmallDateTime	Null
						,DealValueFXConversionDate 				SmallDateTime	Null
						,CurrencyPairID 						SmallInt		Null
						,IsReciprocal 							Bit				Null
						,FxForwardRate 							Float			Null
						,CurrencyPairFxRate 					Float			Null
						,CurrencyPairFxRateErrors 				VarChar(8000)	Null						
						,DlDtlPrvsnPriceCurveID					int				Null
						,MarketCurveID							int				Null)

						Create NonClustered Index ID_RiskID_InstanceDateTime_IsPriorMonthTransaction on #RiskResults (RiskID, InstanceDateTime,IsPriorMonthTransaction )
						Create NonClustered Index IE_RiskID_DlDtlTmplteID on #RiskResults (RiskID,DlDtlTmplteID)			
	End	
	
----------------------------------------------------------------------------------------------------------------------------------
-- Create #GLResults
----------------------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'Y'
	Begin
		Select	'	
		Create Table	#GLResults
						(ID							int				Not Null	Identity
						,P_EODSnpShtID				int				Not Null
						,InstanceDateTime			smalldatetime	Not Null
						,EndOfDay					smalldatetime	Not Null
						,RecordSource				varchar(50)		Null						
						,RiskID						int				Null
						,IsInventory				smallint		Null		Default 0
						,IsAccrual					smallint		Null		Default 0
						,DlHdrID					int				Null 
						,DlHdrIntrnlNbr				varchar(20)		Null
						,DlHdrDsplyDte				smalldatetime	Null					
						,InternalBAID				int				Null
						,ExternalBAID				int				Null
						,BATpe						char(1)			Null
						,DlDtlID					smallint		Null
						,DlDtlSpplyDmnd				char(1)			Null	
						,DlDtlTmplteID				int				Null
						,LcleID						int				Null
						,PrdctID					int				Null
						,ChmclID					int				Null
						,DlDtlPrvsnID				int				Null
						,DlDtlPrvsnMntryDrctn		char(1)			Null	
						,DlDtlPrvsnUOMID			smallint		Null			
						,IsPrimaryCost				char(1)			Not Null	Default ''N''
						,PriceEndDate				smalldatetime	Null
						,TrnsctnTypID				int				Null				
						,PlnndTrnsfrID				int				Null
						,StrtgyID					int				Null
						,Volume						decimal(19,6)	Null		Default 0
						,ValuationVolume			decimal(19,6)	Null		Default 0
						,TotalValuePerUnit			float			Null		Default 0
						,TotalValue					decimal(19,6)	Null		Default 0
						,TotalValueFXRate			float			Null		Default 1
						,TotalValueCrrncyID			int				Null
						,MarketValuePerUnit			float			Null		Default 0
						,MarketValue				decimal(19,6)	Null		Default 0
						,MarketValueFXRate			float			Null		Default 1
						,MarketValueCrrncyID		int				Null
						,MarketRwPrceLcleID			int				Null
						,ProfitLoss					float			Null		Default	0
						,ProfitLoss_USD				float			Null		Default 0
						,AccntngPrdBgnDte			smalldatetime	Null
						,DeliveryPeriodStartDate	smalldatetime	Null
						,DeliveryPeriodEndDate		smalldatetime	Null
						,SourceTable				varchar(3)		Null						
						,CostSourceTable			varchar(2)		Null
						,P_EODBAVID					int				Null						-- Used to support the existing SolArc Unrealized Proc													
						,TrdePrdid					int				Null						-- Used to support the existing SolArc Unrealized Proc
						,BAVTradePeriod				int				Null						-- Used to support the existing SolArc Unrealized Proc
						,ReferenceDate				smalldatetime	Null						-- Used to support the existing SolArc Unrealized Proc
						,P_EODEstmtedAccntDtlID		int				Null						-- Used to support the existing SolArc Unrealized Proc
						,Credit						char(1)			Null		Default ''N''	-- Used to support the existing SolArc Unrealized Proc
						,SpecificGravity			float			Null		Default 1
						,Energy						float			Null		Default 1
						,VETradePeriodID			int				Null
						,SpotTradeFXRate			float			Null		Default 1
						,SpotMarketFXRate			float			Null		Default 1
						,TransactionDate			smalldatetime	Null
						,MarketValueOffset			float			Null		Default 0)	
						
						Create NonClustered Index IE1_InventoryResults_DlHdrID on #GLResults (DlHdrID)
						Create NonClustered Index IE2_InventoryResults_IsInventory on #GLResults (IsInventory)					
				'  	
	End
Else
	Begin
		Create Table	#GLResults
						(ID							int				Not Null	Identity
						,P_EODSnpShtID				int				Not Null
						,InstanceDateTime			smalldatetime	Not Null
						,EndOfDay					smalldatetime	Not Null
						,RecordSource				varchar(50)		Null						
						,RiskID						int				Null
						,IsInventory				smallint		Null		Default 0
						,IsAccrual					smallint		Null		Default 0
						,DlHdrID					int				Null 
						,DlHdrIntrnlNbr				varchar(20)		Null
						,DlHdrDsplyDte				smalldatetime	Null					
						,InternalBAID				int				Null
						,ExternalBAID				int				Null
						,BATpe						char(1)			Null
						,DlDtlID					smallint		Null
						,DlDtlSpplyDmnd				char(1)			Null	
						,DlDtlTmplteID				int				Null
						,LcleID						int				Null
						,PrdctID					int				Null
						,ChmclID					int				Null
						,DlDtlPrvsnID				int				Null
						,DlDtlPrvsnMntryDrctn		char(1)			Null	
						,DlDtlPrvsnUOMID			smallint		Null					
						,IsPrimaryCost				char(1)			Not Null	Default 'N'
						,PriceEndDate				smalldatetime	Null
						,TrnsctnTypID				int				Null				
						,PlnndTrnsfrID				int				Null
						,StrtgyID					int				Null
						,Volume						decimal(19,6)	Null		Default 0
						,ValuationVolume			decimal(19,6)	Null		Default 0
						,TotalValuePerUnit			float			Null		Default 0
						,TotalValue					decimal(19,6)	Null		Default 0
						,TotalValueFXRate			float			Null		Default 1
						,TotalValueCrrncyID			int				Null
						,MarketValuePerUnit			float			Null		Default 0
						,MarketValue				decimal(19,6)	Null		Default 0
						,MarketValueFXRate			float			Null		Default 1
						,MarketValueCrrncyID		int				Null
						,MarketRwPrceLcleID			int				Null
						,ProfitLoss					float			Null		Default	0
						,ProfitLoss_USD				float			Null		Default 0
						,AccntngPrdBgnDte			smalldatetime	Null
						,DeliveryPeriodStartDate	smalldatetime	Null
						,DeliveryPeriodEndDate		smalldatetime	Null
						,SourceTable				varchar(3)		Null						
						,CostSourceTable			varchar(2)		Null
						,P_EODBAVID					int				Null						-- Used to support the existing SolArc Unrealized Proc	
						,TrdePrdid					int				Null						-- Used to support the existing SolArc Unrealized Proc
						,BAVTradePeriod				int				Null						-- Used to support the existing SolArc Unrealized Proc
						,ReferenceDate				smalldatetime	Null						-- Used to support the existing SolArc Unrealized Proc
						,P_EODEstmtedAccntDtlID		int				Null						-- Used to support the existing SolArc Unrealized Proc	
						,Credit						char(1)			Null		Default 'N'		-- Used to support the existing SolArc Unrealized Proc										
						,SpecificGravity			float			Null		Default 1
						,Energy						float			Null		Default 1
						,VETradePeriodID			int				Null
						,SpotTradeFXRate			float			Null		Default 1
						,SpotMarketFXRate			float			Null		Default 1
						,TransactionDate			smalldatetime	Null
						,MarketValueOffset			float			Null		Default 0)								
						
						Create NonClustered Index IE1_InventoryResults_DlHdrID on #GLResults (DlHdrID)
						Create NonClustered Index IE2_InventoryResults_IsInventory on #GLResults (IsInventory)	
						
	End	

----------------------------------------------------------------------------------------------------------------------------------
-- Create #MarketCurves
----------------------------------------------------------------------------------------------------------------------------------	
If	@c_OnlyShowSQL = 'Y'
	Begin
		Select	'		
		Create Table	#MarketCurves
						(RiskCurveID			int				Null
						,TradePeriodFromDate	smalldatetime	Null
						,RwPrceLcleID			int				Null
						,PrdctID				int				Null
						,ChmclID				int				Null
						,LcleID					int				Null
						,UOMID					smallint		Null						
						,CrrncyID				int				Null
						,Settle					float			Null	Default 0)
				' 	
	End
Else
	Begin
		Create Table	#MarketCurves
						(RiskCurveID			int				Null
						,TradePeriodFromDate	smalldatetime	Null
						,RwPrceLcleID			int				Null
						,PrdctID				int				Null
						,ChmclID				int				Null
						,LcleID					int				Null
						,UOMID					smallint		Null						
						,CrrncyID				int				Null
						,Settle					float			Null	Default 0)
	End
	
----------------------------------------------------------------------------------------------------------------------------------
-- Block 30: Populate the temp table with the records from risk
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
-- Execute sp_Risk_Report_MTM to populate #RiskResults 
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Execute	dbo.sp_Risk_Report_MTM	@c_IsThisNavigation					= ''N''
								,@c_MultiSelected					= ''N''
								,@i_id								= 1
								,@vc_type							= ''PositionGroup''
								,@vc_PositionGroupIDs				= ''''
								,@vc_PortfolioIDs					= ''''
								,@vc_ProdLocIDs						= ''''
								,@vc_StrategyIDs					= ''''
								,@vc_UnAssignedProdLoc				= ''''
								,@vc_UnAssignedStrategy				= ''''
								,@i_TradePeriodFromID				= 0
								,@vc_internalBAID					= ''0''
								,@dt_maximumtradeperiodstartdate	= ''12-1-2050 0:0:0.000''
								,@i_P_EODSnpShtID					= ' + convert(varchar,IsNull(@i_P_EODSnpShtID,0)) + '
								,@i_Compare_P_EODSnpShtID			= Null
								,@c_ShowOutMonth					= ''N''
								,@c_strategy						= ''Y''
								,@c_InventoryType					= ''I''
								,@vc_InventoryBasis					= ''Beginning''
								,@i_WhatIf_ID						= Null
								,@i_WhatIf_Compare_ID				= Null
								,@vc_AdditionalColumns				= ''''
								,@i_RprtCnfgID						= 573
								,@c_PerformSelect					= ''N''
								,@c_OnlyShowSQL						= ''N''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Remove any inventory related risk records Pass 1 - we are going to add these back later
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Delete	#RiskResults
From	#RiskResults		(NoLock)
		Inner Join	Risk	(NoLock)	On	#RiskResults. RiskID	= Risk. RiskID
Where	Risk. TrnsctnTypID				In (2004, 2005, 2006, 2007, 2008, 2032, 2033)										   	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Remove any transactions that should be filtered out
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Delete	#RiskResults
From	#RiskResults						(NoLock)
		Inner Join	Risk					(NoLock)	On	#RiskResults. RiskID				= Risk. RiskID
		Inner Join	TransactionTypeGroup	(NoLock)	On	Risk. TrnsctnTypID					= TransactionTypeGroup. XTpeGrpTrnsctnTypID
														And	TransactionTypeGroup. XTpeGrpXGrpID	= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + '									   	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Remove any inventory related risk records Pass 2 - we are going to add these back later
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Delete	#RiskResults
From	#RiskResults		(NoLock)
Where	#RiskResults. SourceTable	In (''I'', ''S'', ''B'')										   	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Remove Write Off Deals
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Delete	#RiskResults
From	#RiskResults					(NoLock)
		Inner Join	Risk				(NoLock)	On	#RiskResults. RiskID		= Risk. RiskID
		Inner Join	RiskDealIdentifier	(NoLock)	On	Risk. RiskDealIdentifierID	= RiskDealIdentifier. RiskDealIdentifierID
		Inner Join	DealHeader			(NoLock)	On	RiskDealIdentifier. DlHdrID	= DealHeader. DlHdrID 
Where	DealHeader. DlHdrTyp		= 62									   	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	


----------------------------------------------------------------------------------------------------------------------------------
-- Block 40: Insert the Risk Based Records - Non Adjustment Records
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Insert	#GLResults
		(P_EODSnpShtID
		,InstanceDateTime
		,EndOfDay
		,RecordSource
		,RiskID
		,DlHdrID
		,DlHdrIntrnlNbr
		,DlHdrDsplyDte
		,InternalBAID
		,ExternalBAID
		,DlDtlID
		,DlDtlSpplyDmnd
		,DlDtlTmplteID
		,LcleID
		,PrdctID
		,ChmclID
		,DlDtlPrvsnID
		,DlDtlPrvsnMntryDrctn
		,DlDtlPrvsnUOMID		
		,IsPrimaryCost
		,TrnsctnTypID
		,PlnndTrnsfrID
		,StrtgyID
		,Volume
		,ValuationVolume
		,TotalValuePerUnit
		,TotalValue
		,TotalValueFXRate
		,TotalValueCrrncyID
		,MarketValuePerUnit
		,MarketValue
		,MarketValueFXRate
		,MarketValueCrrncyID
		,ProfitLoss
		,AccntngPrdBgnDte
		,DeliveryPeriodStartDate
		,DeliveryPeriodEndDate
		,SourceTable
		,CostSourceTable
		,SpecificGravity
		,Energy
		,VETradePeriodID)
Select	#RiskResults. Snapshot							-- P_EODSnpShtID
		,#RiskResults. SnapshotDateTime					-- InstanceDateTime
		,#RiskResults. CloseOfBusiness					-- EndOfDay
		,''Forwards''									-- RecordSource
		,#RiskResults. RiskID							-- RiskID
		,RiskDealIdentifier. DlHdrID					-- DlHdrID
		,RiskDealDetail. DlHdrIntrnlNbr					-- DlHdrIntrnlNbr
		,DealHeader. DlHdrDsplyDte						-- DlHdrDsplyDte
		,Risk. InternalBAID								-- InternalBAID
		,Risk. ExternalBAID								-- ExternalBAID
		,RiskDealDetail. DlDtlID						-- DlDtlID
		,RiskDealDetail. DlDtlSpplyDmnd					-- DlDtlSpplyDmnd
		,Risk. DlDtlTmplteID							-- DlDtlTmplteID
		,Risk. LcleID									-- LcleID
		,Risk. PrdctID									-- PrdctID
		,Risk. ChmclID									-- ChmclID
		,RiskPriceIdentifier. DlDtlPrvsnID				-- DlDtlPrvsnID
		,RiskDealDetailProvision. DlDtlPrvsnMntryDrctn	-- DlDtlPrvsnMntryDrctn
		,RiskDealDetailProvision. UOMID					-- DlDtlPrvsnUOMID
		,Case
			When	#RiskResults. IsPrimaryCost = 1	Then ''Y''
			Else	''N''
		 End											-- IsPrimaryCost
		,Risk. TrnsctnTypID								-- TrnsctnTypID	
		,RiskDealIdentifier. PlnndTrnsfrID				-- PlnndTrnsfrID
		,Risk. StrtgyID									-- StrtgyID
		,Case
			When	#RiskResults. IsPrimaryCost = 1	Then #RiskResults. Position 
			Else	0.0 
		 End											-- Volume
		,#RiskResults. ValuationPosition				-- ValuationVolume
		,Case When #RiskResults.ValuationPosition <> 0.0 Then Abs(#RiskResults.TotalValue / #RiskResults.ValuationPosition) Else 0 End					-- TotalValuePerUnit
		,#RiskResults. TotalValue						-- TotalValue
		,#RiskResults. TotalValueFXRate					-- TotalValueFXRate
		,#RiskResults. PaymentCrrncyID					-- TotalValueCrrncyID
		,Case When #RiskResults. IsPrimaryCost = 1 And #RiskResults.Position <> 0 Then Abs(#RiskResults.MarketValue / #RiskResults.Position) Else 0 End	-- MarketValuePerUnit
		,#RiskResults. MarketValue						-- MarketValue
		,#RiskResults. MarketValueFXRate				-- MarketValueFXRate
		,#RiskResults. MarketCrrncyID					-- MarketValueCrrncyID
		,#RiskResults. TotalPnL							-- ProfitLoss
		,#RiskResults. AccountingPeriodStartDate		-- AccntngPrdBgnDte
		,#RiskResults. DeliveryPeriodStartDate			-- DeliveryPeriodStartDate
		,#RiskResults. DeliveryPeriodEndDate			-- DeliveryPeriodEndDate
		,Risk. SourceTable								-- SourceTable
		,Risk. CostSourceTable							-- CostSourceTable			
		,#RiskResults. SpecificGravity					-- SpecificGravity
		,#RiskResults. Energy							-- Energy
		,VETradePeriod. VETradePeriodID					-- VETradePeriodID
From	#RiskResults							(NoLock)
		Inner Join Risk 						(NoLock)	On	#RiskResults. RiskID						= Risk. RiskID
		Left Outer Join RiskDealIdentifier		(NoLock)	On	Risk. RiskDealIdentifierID					= RiskDealIdentifier. RiskDealIdentifierID
		Left Outer Join RiskDealDetail  		(NoLock)	On	RiskDealDetail. DlHdrID						= RiskDealIdentifier. DlHdrID
															And	RiskDealDetail. DlDtlID						= RiskDealIdentifier. DlDtlID															
															And	#RiskResults. InstanceDateTime				Between RiskDealDetail. StartDate And RiskDealDetail. EndDate
		Left Outer Join RiskPriceIdentifier		(NoLock)	On	RiskPriceIdentifier. RiskPriceIdentifierID	= Risk. RiskPriceIdentifierID
		Left Outer Join RiskDealDetailProvision (NoLock)	On	RiskDealDetailProvision. DlDtlPrvsnID		= RiskPriceIdentifier. DlDtlPrvsnID
															And	#RiskResults. InstanceDateTime				Between RiskDealDetailProvision. StartDate And RiskDealDetailProvision. EndDate
		Left Outer Join	DealHeader				(NoLock)	On	RiskDealDetail. DlHdrID						= DealHeader. DlHdrID
		Left Outer Join	VETradePeriod			(NoLock)	On	#RiskResults. DeliveryPeriodStartDate		Between	VETradePeriod. StartDate And VETradePeriod. EndDate
															And	VETradePeriod. Calculated					= 0
															And	VETradePeriod. Type							= ''M''		
Where	1=1
And		#RiskResults. SourceTable				<> ''E''
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Delete any records that are in the current period
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Delete	#GLResults
Where	AccntngPrdBgnDte	<= ''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- JPW - 01/10/2013 -- Added Support for Accruals
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		IsAccrual	= 1
Where	DeliveryPeriodEndDate	<= ''' + convert(varchar,@sdt_TradePeriodEndDate) + '''
And		SourceTable				= ''X''
And		IsPrimaryCost			= ''Y''
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Delete any records that moved in a prior period but are still pricing - the accrual engine will pick these up
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Delete	#GLResults
Where	DeliveryPeriodEndDate	<= ''' + convert(varchar,@sdt_TradePeriodEndDate) + '''
And		SourceTable				= ''X''
And		IsAccrual				= 0
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- JPW - 01/10/2013 -- Added Support for Accruals - Set the PriceEndDate (Pass 1) for Accrual Records
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		PriceEndDate		=	(	Select	Max(FormulaEvaluationQuote. QuoteDate)
										From	RiskQuotationalExposure				(NoLock)
												Inner Join	FormulaEvaluationQuote	(NoLock)	On	RiskQuotationalExposure. FormulaEvaluationID	= FormulaEvaluationQuote. FormulaEvaluationID 	
										Where	RiskQuotationalExposure. RiskID					= #GLResults. RiskID	
										And		#GLResults. InstanceDateTime	Between RiskQuotationalExposure. StartDate And RiskQuotationalExposure. EndDate)
Where	#GLResults. IsAccrual	= 1
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- JPW - 01/10/2013 -- Added Support for Accruals - Set the PriceEndDate (Pass 2) for Accrual Records
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		PriceEndDate		=	(	Select	Max(FormulaEvaluationQuote. QuoteDate)
									From	RiskQuotationalExposure				(NoLock)
											Inner Join	FormulaEvaluationQuote	(NoLock)	On	RiskQuotationalExposure. FormulaEvaluationID	= FormulaEvaluationQuote. FormulaEvaluationID 	
											Inner Join	DealDetailProvisionRow	(NoLock)	On	RiskQuotationalExposure. DlDtlPrvsnRwID			= DealDetailProvisionRow. DlDtlPrvsnRwID
																							And	DealDetailProvisionRow. DlDtlPRvsnRwTpe			= ''F''	
											Inner Join	DealDetailProvision		(NoLock)	On	DealDetailProvisionRow. DlDtlPrvsnID			=  #GLResults. DlDtlPrvsnID			
									Where	#GLResults. InstanceDateTime	Between RiskQuotationalExposure. StartDate And RiskQuotationalExposure. EndDate)
Where	#GLResults. IsAccrual		= 1
And		#GLResults. PriceEndDate	Is Null
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- JPW - 01/10/2013 -- Added Support for Accruals - Remove any X Based Records that should have Priced In Already
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Delete	#GLResults
Where	PriceEndDate	<= ''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''
And		IsAccrual		= 1
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- JPW - 01/10/2013 -- Added Support for Accruals - Remove any X Based Records that have a NULL Pricing Date
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Delete	#GLResults
Where	PriceEndDate	Is Null
And		IsAccrual		= 1
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- JPW - 01/10/2013 -- Added Support for Accruals - Set the Transaction Date for Accruals
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Update	#GLResults
Set		TransactionDate	= BestAvailableVolumeVolume. EstimatedMovementDate
From	#GLResults								(NoLock)
		Inner Join	RiskSourceValue				(NoLock)	On	#GLResults. RiskID					= RiskSourceValue. RiskID
		Inner Join	BestAvailableVolume			(NoLock)	On	RiskSourceValue. P_EODBAVID			= BestAvailableVolume. P_EODBAVID
															And	#GLResults. InstanceDateTime		Between BestAvailableVolume. StartDate And BestAvailableVolume. EndDate
		Inner Join	BestAvailableVolumeVolume	(NoLock)	On	BestAvailableVolume. P_EODBAVID		= BestAvailableVolumeVolume. P_EODBAVID
															And	#GLResults. InstanceDateTime		Between BestAvailableVolumeVolume. StartDate And BestAvailableVolumeVolume. EndDate
Where	IsAccrual		= 1															
'
								
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the SpotTradeFXRate value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLResults
Set		SpotTradeFXRate	=	IsNull((	Select	Top 1 RawPrice. RPVle
									From	RawPriceDetail				(NoLock)
											Left Outer Join	RawPrice	(NoLock)	On	RawPriceDetail.Idnty		= RawPrice. RPRPDtlIdnty
																					And	RawPrice. Status			= ''A''	
																					And	RawPrice. RPPrceTpeIdnty	= ' + convert(varchar,IsNull(@i_CurrentDefaultPriceType,0)) + '
									Where	RawPriceDetail. RPDtlCrrncyID				= 19
									And		RawPriceDetail. RPDtlRPLcleRPHdrID			= ' + convert(varchar,IsNull(@i_CurrencyRPHdrID,0)) + '		-- Exchange Rate Close
									And		RawPriceDetail. RPDtlRPLcleLcleID			= ' + convert(varchar,IsNull(@i_CurrencyDefaultLcleID,0)) + '
									And		RawPriceDetail. RPDtlRPLcleChmclParPrdctID	= TotalValueCrrncyID
									And		''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''	Between	RawPriceDetail. RPDtlQteFrmDte And RawPriceDetail. RPDtlQteToDte	
									And		RawPriceDetail. RPDtlTpe					= ''A''
									And		RawPriceDetail. RPDtlStts					= ''A''
									Order By RawPriceDetail. RPDtlQteFrmDte Desc), 1.0)
Where	#GLResults. TotalValueCrrncyID	<> 19										 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Update the Trade Spot FX Rate - // JPW 04/02 - We may have to swap this for the closing price curve   20 Exchange Rate Monthly  
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		SpotTradeFXRate	= RiskCurrencyConversionValue. ConversionValue
From	#GLResults								(NoLock) 
		Inner Join	RiskCurrencyConversion		(NoLock)	On	#GLResults. TotalValueCrrncyID						= RiskCurrencyConversion. FromCurrencyID
															And	RiskCurrencyConversion. ToCurrencyID				= 19
															And	RiskCurrencyConversion. VETradePeriodID				= ' + convert(varchar,@i_StartedFromVETradePeriodID) + '			
		Inner Join	RiskCurrencyConversionValue	(NoLock)	On	RiskCurrencyConversion. RiskCurrencyConversionID	= RiskCurrencyConversionValue. RiskCurrencyConversionID	
															And	#GLResults. InstanceDateTime						Between RiskCurrencyConversionValue. StartDate And RiskCurrencyConversionValue. EndDate
Where	#GLResults. TotalValueCrrncyID	<> 19	
'	
					
-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the SpotMarketFXRate value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLResults
Set		SpotMarketFXRate	=	IsNull((	Select	Top 1 RawPrice. RPVle
									From	RawPriceDetail				(NoLock)
											Left Outer Join	RawPrice	(NoLock)	On	RawPriceDetail.Idnty		= RawPrice. RPRPDtlIdnty
																					And	RawPrice. Status			= ''A''	
																					And	RawPrice. RPPrceTpeIdnty	= ' + convert(varchar,IsNull(@i_CurrentDefaultPriceType,0)) + '
									Where	RawPriceDetail. RPDtlCrrncyID				= 19
									And		RawPriceDetail. RPDtlRPLcleRPHdrID			= ' + convert(varchar,IsNull(@i_CurrencyRPHdrID,0)) + '			-- Exchange Rate Close
									And		RawPriceDetail. RPDtlRPLcleLcleID			= ' + convert(varchar,IsNull(@i_CurrencyDefaultLcleID,0)) + '
									And		RawPriceDetail. RPDtlRPLcleChmclParPrdctID	= MarketValueCrrncyID
									And		''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''	Between	RawPriceDetail. RPDtlQteFrmDte And RawPriceDetail. RPDtlQteToDte	
									And		RawPriceDetail. RPDtlTpe					= ''A''
									And		RawPriceDetail. RPDtlStts					= ''A''
									Order By RawPriceDetail. RPDtlQteFrmDte Desc), 1.0)
Where	#GLResults. MarketValueCrrncyID	<> 19										 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Update the Market Spot FX Rate // JPW 04/02 - We may have to swap this for the closing price curve 20 Exchange Rate Monthly 
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		SpotMarketFXRate = RiskCurrencyConversionValue. ConversionValue
From	#GLResults								(NoLock) 
		Inner Join	RiskCurrencyConversion		(NoLock)	On	#GLResults. MarketValueCrrncyID						= RiskCurrencyConversion. FromCurrencyID
															And	RiskCurrencyConversion. ToCurrencyID				= 19
															And	RiskCurrencyConversion. VETradePeriodID				= ' + convert(varchar,@i_StartedFromVETradePeriodID) + '			
		Inner Join	RiskCurrencyConversionValue	(NoLock)	On	RiskCurrencyConversion. RiskCurrencyConversionID	= RiskCurrencyConversionValue. RiskCurrencyConversionID	
															And	#GLResults. InstanceDateTime						Between RiskCurrencyConversionValue. StartDate And RiskCurrencyConversionValue. EndDate
Where	#GLResults. MarketValueCrrncyID	<> 19	
'	
					
-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the Profit/Loss in USD
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		ProfitLoss_USD = (TotalValue * SpotTradeFXRate) + (MarketValue * SpotMarketFXRate)
Where	IsAccrual	= 0
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- JPW - 01/10/2013 -- Added Support for Accruals - Set the Profit/Loss in USD
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		ProfitLoss_USD = (TotalValue * SpotTradeFXRate)
Where	IsAccrual	= 1
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Block 50: Insert the Inventory Records
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Insert	#GLResults
		(P_EODSnpShtID
		,InstanceDateTime
		,EndOfDay
		,RecordSource
		,RiskID
		,IsInventory
		,DlHdrID
		,DlHdrIntrnlNbr
		,DlHdrDsplyDte
		,InternalBAID
		,ExternalBAID
		,DlDtlID
		,DlDtlSpplyDmnd
		,DlDtlTmplteID
		,LcleID
		,PrdctID
		,ChmclID	
		,DlDtlPrvsnUOMID
		,IsPrimaryCost
		,TrnsctnTypID
		,StrtgyID
		,Volume
		,ValuationVolume
		,TotalValue
		,TotalValueFXRate
		,TotalValueCrrncyID
		,AccntngPrdBgnDte
		,DeliveryPeriodStartDate
		,DeliveryPeriodEndDate
		,ReferenceDate
		,SourceTable
		,CostSourceTable
		,TrdePrdid
		,BAVTradePeriod
		,SpecificGravity
		,Energy)
Select	' + convert(varchar,@i_P_EODSnpShtID) + '				-- P_EODSnpShtID
		,''' + convert(varchar,@sdt_InstanceDateTime) + '''		-- InstanceDateTime
		,''' + convert(varchar,@sdt_EndOfDay) + '''				-- EndOfDay
		,''Inventory Subledger''								-- RecordSource	
		,Risk. RiskID											-- RiskID
		,1														-- IsInventory
		,RiskDealIdentifier. DlHdrID							-- DlHdrID
		,RiskDealDetail. DlHdrIntrnlNbr							-- DlHdrIntrnlNbr
		,DealHeader. DlHdrDsplyDte								-- DlHdrDsplyDte
		,Risk. InternalBAID										-- InternalBAID
		,Risk. ExternalBAID										-- ExternalBAID
		,RiskDealIdentifier. DlDtlID							-- DlDtlID
		,RiskDealDetail. DlDtlSpplyDmnd							-- DlDtlSpplyDmnd
		,Risk. DlDtlTmplteID									-- DlDtlTmplteID
		,Risk. LcleID											-- LcleID
		,Risk. PrdctID											-- PrdctID
		,Risk. ChmclID											-- ChmclID	
		,3														-- DlDtlPrvsnUOMID
		,''N''													-- IsPrimaryCost
		,Risk. TrnsctnTypID										-- TrnsctnTypID
		,Risk. StrtgyID											-- StrtgyID
		,IsNull(RiskPosition. Position, 0) 						-- Volume
		,IsNull(RiskPosition. Position, 0) 						-- ValuationVolume
		,IsNull(TotalValue. TotalValue,0)						-- TotalValue
		,1														-- TotalValueFXRate
		,IsNull(TotalValue. CrrncyID, 19)						-- TotalValueCrrncyID	
		,''' + convert(varchar,@sdt_AccntngPrdBgnDte) + '''		-- AccntngPrdBgnDte
		,''' + convert(varchar,@sdt_TradePeriodStartDate) + '''	-- DeliveryPeriodStartDate
		,''' + convert(varchar,@sdt_TradePeriodEndDate) + '''	-- DeliveryPeriodEndDate	
		,''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''		-- ReferenceDate						
		,Risk. SourceTable										-- SourceTable
		,Risk. CostSourceTable									-- CostSourceTable	
		,' + convert(varchar,@i_AccntngPrdID) + '				-- TrdePrdid
		,' + convert(varchar,@i_StartedFromVETradePeriodID) + '	-- BAVTradePeriod			
		,RiskPosition. SpecificGravity							-- SpecificGravity
		,RiskPosition. Energy									-- Energy
From	Risk											(NoLock)
		Inner Join		RiskDealIdentifier				(NoLock)	On	Risk. RiskDealIdentifierID	= RiskDealIdentifier. RiskDealIdentifierID	
		Left Outer Join	RiskPosition					(NoLock)	On	Risk. RiskID				= RiskPosition. RiskID
																	And	''' + convert(varchar,@sdt_InstanceDateTime) + ''' 		Between	RiskPosition. StartDate And RiskPosition. EndDate
		Left Outer Join	RiskValue			TotalValue	(NoLock)	On	Risk. RiskID				= TotalValue. RiskID
																	And	''' + convert(varchar,@sdt_InstanceDateTime) + '''		Between TotalValue. StartDate And TotalValue. EndDate
																	And	TotalValue. Type			= 1
		Left Outer Join	RiskDealDetail					(NoLock)	On	RiskDealIdentifier. DlHdrID	= RiskDealDetail. DlHdrID
																	And RiskDealIdentifier. DlDtlID	= RiskDealDetail. DlDtlID
																	And	''' + convert(varchar,@sdt_InstanceDateTime) + '''		Between RiskDealDetail. StartDate And RiskDealDetail. EndDate
		Left Outer Join	DealHeader						(NoLock)	On	RiskDealDetail. DlHdrID		= DealHeader. DlHdrID														
Where	1=1 
And		Risk. IsVolumeOnly						= 0
And		Risk. CostSourceTable					<> ''IV''
And		Risk. IsInventory						= 1
And		Risk. SourceTable						= ''S''
And		Risk. IsInventoryValuationAdjustment	= 0
And		Risk. DeliveryPeriodStartDate			Between	''' + convert(varchar,@sdt_FwdVETradePeriodStartDate) + ''' And ''' + convert(varchar,@sdt_FwdVETradePeriodEndDate) + ''' 
And		1 =	Case
				When 	IsNull(RiskDealIdentifier. DlHdrID, 0) <> 0 And IsNull(RiskDealIdentifier. WhatIfScenarioID, 0) <> 0 Then 0
				Else	1
			End 
And		Not Exists (	Select	''X'' 
						From	#GLResults	(NoLock)
						Where	#GLResults. RiskID	= Risk. RiskID)
And		Exists	(		Select	''X''
						From	TransactionTypeGroup	(NoLock)
						Where	TransactionTypeGroup. XTpeGrpXGrpID 	= ' + convert(varchar,@i_XGroup_Qualifier) + '
						And		Risk. TrnsctnTypID 						= TransactionTypeGroup. XTpeGrpTrnsctnTypID)
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Remove any 0 volume records
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Delete	#GLResults
Where	Volume	= 0
And		#GLResults. IsInventory	= 1	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Resest the Deal Header fields if missing ( caused by in-transit inventory)
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Update	#GLResults
Set		DlHdrIntrnlNbr	= DealHeader. DlHdrIntrnlNbr
		,DlHdrDsplyDte	= DealHeader. DlHdrDsplyDte
From	#GLResults				(NoLock)
		Inner Join	DealHeader	(NoLock)	On	#GLResults. DlHdrID	= DealHeader. DlHdrID	
Where	#GLResults. IsInventory			= 1	
And		#GLResults. DlHdrIntrnlNbr	Is Null
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the Inventory Market Value & Currency
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Update	#GLResults
Set		MarketValue				= IsNull(MarketValue. TotalValue, 0)
		,MarketValueCrrncyID	= IsNull(MarketValue. CrrncyID, 19)
From	#GLResults								(NoLock)
		Left Outer Join	RiskValue	MarketValue	(NoLock)	On	#GLResults. RiskID			= MarketValue. RiskID
														And	#GLResults. InstanceDateTime	Between MarketValue. StartDate And MarketValue. EndDate
														And	MarketValue. Type				= 4
Where	#GLResults. IsInventory			= 1	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the Per Units
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Update	#GLResults
Set		MarketValuePerUnit		= Abs(Case When Volume <> 0 Then MarketValue / Volume Else MarketValue End)
		,TotalValuePerUnit		= Abs(Case When Volume <> 0 Then TotalValue / Volume Else TotalValue End)
From	#GLResults		(NoLock)
Where	#GLResults. IsInventory			= 1	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the Inventory Market Curve
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Update	#GLResults
Set		MarketRwPrceLcleID	= RiskCurve. RwPrceLcleID
From	#GLResults				(NoLock)
		Inner	Join	RiskPhysicalExposure	(NoLock)	On	#GLResults. RiskID					= RiskPhysicalExposure. RiskID
															And	#GLResults. InstanceDateTime		Between RiskPhysicalExposure. StartDate And RiskPhysicalExposure. EndDate
		Inner	Join	RiskCurve				(NoLock)	On	RiskPhysicalExposure. RiskCurveID	= RiskCurve. RiskCurveID
Where	#GLResults. IsInventory			= 1	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
	
----------------------------------------------------------------------------------------------------------------------------------
-- Get the volume and value from the subledger
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Update	#GLResults
Set		Volume					= InventorySubledgerDetail. BeginningVolume	
		,TotalValue				= InventorySubledgerDetail. BeginningValue
		,TotalValuePerUnit		= Case When InventorySubledgerDetail. BeginningVolume <> 0 Then InventorySubledgerDetail. BeginningValue / InventorySubledgerDetail. BeginningVolume Else 0 End
		,MarketRwPrceLcleID		= InventorySubledgerDetail. MarketRwPrceLcleID 
From	#GLResults								(NoLock)
		Inner Join	InventorySubledgerDetail	(NoLock)	On	#GLResults. DlHdrID		= InventorySubledgerDetail. DlDtlChmclDlDtlDlHdrID
															And	#GLResults. DlDtlID		= InventorySubledgerDetail. DlDtlChmclDlDtlID
															And	#GLResults. PrdctID		= InventorySubledgerDetail. DlDtlChmclChmclPrntPrdctID
															And	#GLResults. ChmclID		= InventorySubledgerDetail. DlDtlChmclChmclChldPrdctID
															And	#GLResults. StrtgyID	= InventorySubledgerDetail. StrtgyID
Where	InventorySubledgerDetail. AccntngPrdID	= ' + convert(varchar,@i_FwdAccntngPrdID) + '	
And		#GLResults. IsInventory			= 1															
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	


----------------------------------------------------------------------------------------------------------------------------------
-- Get a distinct list of prod/locs to build out the market values
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Insert	#MarketCurves
		(TradePeriodFromDate
		,RwPrceLcleID)
Select	Distinct ''' + convert(varchar,@sdt_TradePeriodStartDate) + ''' 
		,MarketRwPrceLcleID
From	#GLResults	(NoLock)
Where	#GLResults. IsInventory	= 1	
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the inventory market curve properties
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Update	#MarketCurves
Set		RiskCurveID		= RiskCurve. RiskCurveID
		,PrdctID		= RiskCurve. PrdctID
		,ChmclID		= RiskCurve. ChmclID
		,LcleID			= RiskCurve. LcleID
		,UOMID			= RiskCurve. UOMID
		,CrrncyID		= RiskCurve. CrrncyID
From	#MarketCurves				(NoLock)		
		Inner Join	RiskCurve		(NoLock)	On	#MarketCurves. RwPrceLcleID			= RiskCurve. RwPrceLcleID
												And	#MarketCurves. TradePeriodFromDate	= RiskCurve. TradePeriodFromDate
												And	RiskCurve. RPHdrID					= 4
												And	RiskCurve. PrceTpeIdnty				= 9 
		Inner Join	RawPriceLocale	(NoLock)	On	RiskCurve. RwPrceLcleID				= RawPriceLocale. RwPrceLcleID
												And	RawPriceLocale. Status				= ''A''
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)																								
	
----------------------------------------------------------------------------------------------------------------------------------
-- Remove any records that did not have a risk curve
----------------------------------------------------------------------------------------------------------------------------------		
Select 	@vc_DynamicSQL = '	
Delete	#MarketCurves
Where	RiskCurveID	Is Null			
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)			

----------------------------------------------------------------------------------------------------------------------------------
-- Determine the actual market price
----------------------------------------------------------------------------------------------------------------------------------			
Select 	@vc_DynamicSQL = '	
Update	#MarketCurves
Set		Settle	= RiskCurveValue. BaseValue
From	#MarketCurves				(NoLock)
		Inner Join	RiskCurveValue	(NoLock)	On	#MarketCurves. RiskCurveID	= RiskCurveValue. RiskCurveID
												And	''' + convert(varchar,@sdt_InstanceDateTime) + ''' Between RiskCurveValue. StartDate And RiskCurveValue. EndDate
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Bring the market per unit back up to the results table
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults	
Set		MarketValuePerUnit	= IsNull(#MarketCurves. Settle , 0.0) / ( v_UOMConversion.ConversionFactor / 
																		Case	v_UOMConversion. FromUOMTpe + v_UOMConversion. ToUOMTpe
																				When	''WV''
																				Then	Case When convert(float,#GLResults.SpecificGravity) <> 0.0 Then convert(float,#GLResults.SpecificGravity) Else 1.0 End
																				When	''VW''
																				Then	1.0 / Case When convert(float,#GLResults.SpecificGravity) <> 0.0 Then convert(float,#GLResults.SpecificGravity) Else 1.0 End
																				When	''EV''
																				Then	Case When convert(float,#GLResults.Energy) <> 0.0 Then convert(float,#GLResults.Energy) Else 1.0 End
																				When	''VE''
																				Then	1.0 / Case When convert(float,#GLResults.Energy) <> 0.0 Then convert(float,#GLResults.Energy) Else 1.0 End
																				When	''WE''
																				Then	convert(float,#GLResults.SpecificGravity) / Case When convert(float,#GLResults.Energy) <> 0.0 Then convert(float,#GLResults.Energy) Else 1.0 End
																				When	''EW''
																				Then	convert(float,#GLResults.Energy) / Case When convert(float,#GLResults.SpecificGravity) <> 0.0 Then convert(float,#GLResults.SpecificGravity) Else 1.0 End
																				Else	1.0
																		End)
		,MarketValueCrrncyID	= #MarketCurves. CrrncyID																
From	#GLResults						(NoLock)
		Inner Join	#MarketCurves		(NoLock)	On	#GLResults. MarketRwPrceLcleID	= #MarketCurves. RwPrceLcleID
		Left Outer Join v_UOMConversion	(Nolock)	On	v_UOMConversion. FromUOM				= #MarketCurves. UOMID	
													And	v_UOMConversion. ToUOM					= 3																														
Where	#GLResults. IsInventory	= 1	
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the SpotTradeFXRate value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLResults
Set		SpotTradeFXRate	=	IsNull((	Select	Top 1 RawPrice. RPVle
									From	RawPriceDetail				(NoLock)
											Left Outer Join	RawPrice	(NoLock)	On	RawPriceDetail.Idnty		= RawPrice. RPRPDtlIdnty
																					And	RawPrice. Status			= ''A''	
																					And	RawPrice. RPPrceTpeIdnty	= ' + convert(varchar,IsNull(@i_CurrentDefaultPriceType,0)) + '
									Where	RawPriceDetail. RPDtlCrrncyID				= 19
									And		RawPriceDetail. RPDtlRPLcleRPHdrID			= ' + convert(varchar,IsNull(@i_CurrencyRPHdrID,0)) + '			-- Exchange Rate Close
									And		RawPriceDetail. RPDtlRPLcleLcleID			= ' + convert(varchar,IsNull(@i_CurrencyDefaultLcleID,0)) + '
									And		RawPriceDetail. RPDtlRPLcleChmclParPrdctID	= TotalValueCrrncyID
									And		''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''	Between	RawPriceDetail. RPDtlQteFrmDte And RawPriceDetail. RPDtlQteToDte	
									And		RawPriceDetail. RPDtlTpe					= ''A''
									And		RawPriceDetail. RPDtlStts					= ''A''
									Order By RawPriceDetail. RPDtlQteFrmDte Desc), 1.0)
Where	#GLResults. TotalValueCrrncyID	<> 19	
And		#GLResults. IsInventory			= 1										 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Update the Trade Spot FX Rate
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		SpotTradeFXRate	= RiskCurrencyConversionValue. ConversionValue
From	#GLResults								(NoLock) 
		Inner Join	RiskCurrencyConversion		(NoLock)	On	#GLResults. TotalValueCrrncyID						= RiskCurrencyConversion. FromCurrencyID
															And	RiskCurrencyConversion. ToCurrencyID				= 19
															And	RiskCurrencyConversion. VETradePeriodID				= ' + convert(varchar,@i_StartedFromVETradePeriodID) + '			
		Inner Join	RiskCurrencyConversionValue	(NoLock)	On	RiskCurrencyConversion. RiskCurrencyConversionID	= RiskCurrencyConversionValue. RiskCurrencyConversionID	
															And	#GLResults. InstanceDateTime						Between RiskCurrencyConversionValue. StartDate And RiskCurrencyConversionValue. EndDate
Where	#GLResults. TotalValueCrrncyID	<> 19
And		#GLResults. IsInventory			= 1		
'	
					
--If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the SpotMarketFXRate value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLResults
Set		SpotMarketFXRate	=	IsNull((	Select	Top 1 RawPrice. RPVle
									From	RawPriceDetail				(NoLock)
											Left Outer Join	RawPrice	(NoLock)	On	RawPriceDetail.Idnty		= RawPrice. RPRPDtlIdnty
																					And	RawPrice. Status			= ''A''	
																					And	RawPrice. RPPrceTpeIdnty	= ' + convert(varchar,IsNull(@i_CurrentDefaultPriceType,0)) + '
									Where	RawPriceDetail. RPDtlCrrncyID				= 19
									And		RawPriceDetail. RPDtlRPLcleRPHdrID			= ' + convert(varchar,IsNull(@i_CurrencyRPHdrID,0)) + '			-- Exchange Rate Close
									And		RawPriceDetail. RPDtlRPLcleLcleID			= ' + convert(varchar,IsNull(@i_CurrencyDefaultLcleID,0)) + '
									And		RawPriceDetail. RPDtlRPLcleChmclParPrdctID	= MarketValueCrrncyID
									And		''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''	Between	RawPriceDetail. RPDtlQteFrmDte And RawPriceDetail. RPDtlQteToDte	
									And		RawPriceDetail. RPDtlTpe					= ''A''
									And		RawPriceDetail. RPDtlStts					= ''A''
									Order By RawPriceDetail. RPDtlQteFrmDte Desc), 1.0)
Where	#GLResults. MarketValueCrrncyID	<> 19	
And		#GLResults. IsInventory			= 1										 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Update the Market Spot FX Rate
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		SpotMarketFXRate = RiskCurrencyConversionValue. ConversionValue
From	#GLResults								(NoLock) 
		Inner Join	RiskCurrencyConversion		(NoLock)	On	#GLResults. MarketValueCrrncyID						= RiskCurrencyConversion. FromCurrencyID
															And	RiskCurrencyConversion. ToCurrencyID				= 19
															And	RiskCurrencyConversion. VETradePeriodID				= ' + convert(varchar,@i_StartedFromVETradePeriodID) + '			
		Inner Join	RiskCurrencyConversionValue	(NoLock)	On	RiskCurrencyConversion. RiskCurrencyConversionID	= RiskCurrencyConversionValue. RiskCurrencyConversionID	
															And	#GLResults. InstanceDateTime						Between RiskCurrencyConversionValue. StartDate And RiskCurrencyConversionValue. EndDate
Where	#GLResults. MarketValueCrrncyID	<> 19
And		#GLResults. IsInventory			= 1			
'	
					
-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Bring the market per unit back up to the results table
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		ProfitLoss	= TotalValue + MarketValue
Where	#GLResults. IsInventory	= 1	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the Profit/Loss in USD
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		ProfitLoss_USD = (TotalValue * SpotTradeFXRate) + (MarketValue * SpotMarketFXRate)
Where	#GLResults. IsInventory	= 1	
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the transaction type on inventory based on whether or not the profit is positive or negative
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		TrnsctnTypID	=	Case
								When	ProfitLoss	< 0 Then	2029	-- Inventory Fair Value Decrease
								Else	2027 							-- Inventory Fair Value Increase
							End
Where	#GLResults. IsInventory	= 1								
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the cash direction based on whether or not the profit is positive or negative
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		DlDtlPrvsnMntryDrctn	=	Case
										When	ProfitLoss	< 0 Then	''R''
										Else	''D''
									End
Where	#GLResults. IsInventory	= 1										
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- General Updates to the risk records
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Set the BAV ID
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		P_EODBAVID		=	(	Select	Max(BestAvailableVolume. P_EODBAVID)
								From	BestAvailableVolume				(NoLock)
										Inner Join	RiskSourceValue		(NoLock)	On	BestAvailableVolume. P_EODBAVID			= RiskSourceValue. P_EODBAVID
																					And	BestAvailableVolume. StartDate			<= ''' + convert(varchar,@sdt_InstanceDateTime) + '''
																					And	BestAvailableVolume. EndDate			>= ''' + convert(varchar,@sdt_InstanceDateTime) + '''
																					And	BestAvailableVolume. VETradePeriodID	Is Not Null
																					And	RiskSourceValue. RiskID					= #GLResults. RiskID)												 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the values derived from BAV
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		 TrdePrdid		= PeriodTranslation. AccntngPrdID	
		,BAVTradePeriod	= BestAvailableVolume.  VETradePeriodID 
From	#GLResults						(NoLock)
		Inner Join	BestAvailableVolume	(NoLock)	On	#GLResults. P_EODBAVID					= BestAvailableVolume. P_EODBAVID
		Inner Join	PeriodTranslation	(NoLock)	On	BestAvailableVolume. VETradePeriodID	= PeriodTranslation. VETradePeriodID	
Where	#GLResults. IsInventory	= 0															 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)													
												
----------------------------------------------------------------------------------------------------------------------------------
-- Set the P_EODEstmtedAccntDtlID
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		P_EODEstmtedAccntDtlID		=	(	Select	Max(EstimatedAccountDetail. P_EODEstmtedAccntDtlID)
											From	EstimatedAccountDetail			(NoLock)
													Inner Join	RiskSourceValue		(NoLock)	On	EstimatedAccountDetail. P_EODEstmtedAccntDtlID	= RiskSourceValue. P_EODEstmtedAccntDtlID
																								And	EstimatedAccountDetail. StartDate				<= ''' + convert(varchar,@sdt_InstanceDateTime) + '''
																								And	EstimatedAccountDetail. EndDate					>= ''' + convert(varchar,@sdt_InstanceDateTime) + '''
																								-- And	EstimatedAccountDetail. ReferenceDate			Is Not Null	
																								And	RiskSourceValue. RiskID							= #GLResults. RiskID)												 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)													

----------------------------------------------------------------------------------------------------------------------------------
-- Set the values derived from EAD
----------------------------------------------------------------------------------------------------------------------------------													
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		ReferenceDate	= EstimatedAccountDetail. ReferenceDate	
From	#GLResults							(NoLock)
		Inner Join	EstimatedAccountDetail	(NoLock)	On	#GLResults. P_EODEstmtedAccntDtlID	= EstimatedAccountDetail. P_EODEstmtedAccntDtlID
Where	#GLResults. IsInventory	= 0	
And		#GLResults. IsAccrual	= 0														 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the Reference Date for Accruals
----------------------------------------------------------------------------------------------------------------------------------													
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		ReferenceDate	= TransactionDate
From	#GLResults	(NoLock)
Where	#GLResults. IsAccrual	= 1														 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

/*	-- JPW 05/13/14 Commenting for now - Risk Adjustments are not yet in scope
----------------------------------------------------------------------------------------------------------------------------------
-- Insert the Risk Based Records - Pass 3 - Adjustment Records
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Insert	#GLResults
		(P_EODSnpShtID
		,InstanceDateTime
		,EndOfDay
		,RecordSource
		,RiskID
		,DlHdrID
		,DlHdrIntrnlNbr
		,DlHdrDsplyDte
		,InternalBAID
		,ExternalBAID
		,DlDtlID
		,DlDtlSpplyDmnd
		,DlDtlTmplteID
		,LcleID
		,PrdctID
		,ChmclID
		,DlDtlPrvsnMntryDrctn
		,DlDtlPrvsnUOMID		
		,IsPrimaryCost
		,TrnsctnTypID
		,PlnndTrnsfrID
		,StrtgyID
		,Volume
		,ValuationVolume
		,TotalValuePerUnit
		,TotalValue
		,TotalValueFXRate
		,TotalValueCrrncyID
		,MarketValuePerUnit
		,MarketValue
		,MarketValueFXRate
		,MarketValueCrrncyID
		,ProfitLoss
		,AccntngPrdBgnDte
		,DeliveryPeriodStartDate
		,DeliveryPeriodEndDate
		,SourceTable
		,CostSourceTable
		,ReferenceDate
		,SpecificGravity
		,Energy
		,VETradePeriodID)
Select	#RiskResults. Snapshot							-- P_EODSnpShtID
		,#RiskResults. SnapshotDateTime					-- InstanceDateTime
		,#RiskResults. CloseOfBusiness					-- EndOfDay
		,''Forwards''									-- RecordSource
		,#RiskResults. RiskID							-- RiskID
		,DealHeader. DlHdrID							-- DlHdrID
		,DealHeader. DlHdrIntrnlNbr						-- DlHdrIntrnlNbr
		,DealHeader. DlHdrDsplyDte						-- DlHdrDsplyDte
		,Risk. InternalBAID								-- InternalBAID
		,Risk. ExternalBAID								-- ExternalBAID
		,RiskDealIdentifier. DlDtlID					-- DlDtlID
		,DealDetail. DlDtlSpplyDmnd						-- DlDtlSpplyDmnd
		,Risk. DlDtlTmplteID							-- DlDtlTmplteID
		,Risk. LcleID									-- LcleID
		,Risk. PrdctID									-- PrdctID
		,Risk. ChmclID									-- ChmclID
		,Case
			When	Risk. TrnsctnTypID	= 2265	Then	''D''
			Else	''R''
		 End											-- DlDtlPrvsnMntryDrctn
		,3												-- DlDtlPrvsnUOMID
		,Case
			When	#RiskResults. IsPrimaryCost = 1	Then ''Y''
			Else	''N''
		 End											-- IsPrimaryCost
		,Case
			When	Risk. TrnsctnTypID	= 2265	Then	2027
			Else	2029
		 End											-- TrnsctnTypID	
		,RiskDealIdentifier. PlnndTrnsfrID				-- PlnndTrnsfrID
		,Risk. StrtgyID									-- StrtgyID
		,Case
			When	#RiskResults. IsPrimaryCost = 1	Then #RiskResults. Position 
			Else	0.0 
		 End											-- Volume
		,#RiskResults. ValuationPosition				-- ValuationVolume
		,Case When #RiskResults.ValuationPosition <> 0.0 Then Abs(#RiskResults.TotalValue / #RiskResults.ValuationPosition) Else 0 End					-- TotalValuePerUnit
		,#RiskResults. TotalValue						-- TotalValue
		,#RiskResults. TotalValueFXRate					-- TotalValueFXRate
		,#RiskResults. PaymentCrrncyID					-- TotalValueCrrncyID
		,Case When #RiskResults. IsPrimaryCost = 1 And #RiskResults.Position <> 0 Then Abs(#RiskResults.MarketValue / #RiskResults.Position) Else 0 End	-- MarketValuePerUnit
		,#RiskResults. MarketValue						-- MarketValue
		,#RiskResults. MarketValueFXRate				-- MarketValueFXRate
		,#RiskResults. MarketCrrncyID					-- MarketValueCrrncyID
		,#RiskResults. TotalPnL							-- ProfitLoss
		,#RiskResults. AccountingPeriodStartDate		-- AccntngPrdBgnDte
		,#RiskResults. DeliveryPeriodStartDate			-- DeliveryPeriodStartDate
		,#RiskResults. DeliveryPeriodEndDate			-- DeliveryPeriodEndDate
		,Risk. SourceTable								-- SourceTable
		,Risk. CostSourceTable							-- CostSourceTable	
		,#RiskResults. AccountingPeriodStartDate		-- ReferenceDate		
		,#RiskResults. SpecificGravity					-- SpecificGravity
		,#RiskResults. Energy							-- Energy
		,VETradePeriod. VETradePeriodID					-- VETradePeriodID
From	#RiskResults							(NoLock)
		Inner Join		Risk 					(NoLock)	On	#RiskResults. RiskID			= Risk. RiskID
		Inner Join		RiskDealIdentifier		(NoLock)	On	Risk. RiskDealIdentifierID		= RiskDealIdentifier. RiskDealIdentifierID
		Inner Join		DealHeader				(NoLock)	On	RiskDealIdentifier. Description	= DealHeader. DlHdrIntrnlNbr
		Inner Join		DealDetail				(NoLock)	On	DealHeader. DlHdrID				= DealDetail. DlDtlDlHdrID
															And	RiskDealIdentifier. DlDtlID		= DealDetail. DlDtlID
		Left Outer Join	VETradePeriod			(NoLock)	On	#RiskResults. DeliveryPeriodStartDate		Between	VETradePeriod. StartDate And VETradePeriod. EndDate
															And	VETradePeriod. Calculated					= 0
															And	VETradePeriod. Type							= ''M''																
Where	1=1
And		#RiskResults. SourceTable	= ''E''
And		Risk. TrnsctnTypID			In (2265, 2266) -- PnL Adjustment - Profit, PnL Adjustment - Loss 
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	


----------------------------------------------------------------------------------------------------------------------------------
-- Delete any records that moved in a prior period but are still pricing - the accrual engine will pick these up
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Delete	#GLResults
Where	DeliveryPeriodEndDate	<= ''' + convert(varchar,@sdt_TradePeriodEndDate) + '''
And		#GLResults. SourceTable		= ''E''	
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Adjustments don't have BAVs so get the value from the Trade Period architecture
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		 TrdePrdid		= PeriodTranslation. AccntngPrdID	
		,BAVTradePeriod	= VETradePeriod.  VETradePeriodID 
From	#GLResults						(NoLock)
		Inner Join	VETradePeriod		(NoLock)	On	#GLResults. DeliveryPeriodStartDate	Between	VETradePeriod. StartDate And VETradePeriod. EndDate
													And	VETradePeriod. Calculated			= 0
													And	VETradePeriod. Type					= ''M''
		Inner Join	PeriodTranslation	(NoLock)	On	VETradePeriod. VETradePeriodID		= PeriodTranslation. VETradePeriodID	
Where	#GLResults. SourceTable	= ''E''													
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Update the Trade Spot FX Rate
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		SpotTradeFXRate	= RiskCurrencyConversionValue. ConversionValue
From	#GLResults								(NoLock) 
		Inner Join	RiskCurrencyConversion		(NoLock)	On	#GLResults. TotalValueCrrncyID						= RiskCurrencyConversion. FromCurrencyID
															And	RiskCurrencyConversion. ToCurrencyID				= 19
															And	RiskCurrencyConversion. VETradePeriodID				= ' + convert(varchar,@i_StartedFromVETradePeriodID) + '			
		Inner Join	RiskCurrencyConversionValue	(NoLock)	On	RiskCurrencyConversion. RiskCurrencyConversionID	= RiskCurrencyConversionValue. RiskCurrencyConversionID	
															And	#GLResults. InstanceDateTime						Between RiskCurrencyConversionValue. StartDate And RiskCurrencyConversionValue. EndDate
Where	#GLResults. TotalValueCrrncyID	<> 19
And		#GLResults. SourceTable			= ''E''		
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Update the Market Spot FX Rate
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		SpotMarketFXRate = RiskCurrencyConversionValue. ConversionValue
From	#GLResults								(NoLock) 
		Inner Join	RiskCurrencyConversion		(NoLock)	On	#GLResults. MarketValueCrrncyID						= RiskCurrencyConversion. FromCurrencyID
															And	RiskCurrencyConversion. ToCurrencyID				= 19
															And	RiskCurrencyConversion. VETradePeriodID				= ' + convert(varchar,@i_StartedFromVETradePeriodID) + '			
		Inner Join	RiskCurrencyConversionValue	(NoLock)	On	RiskCurrencyConversion. RiskCurrencyConversionID	= RiskCurrencyConversionValue. RiskCurrencyConversionID	
															And	#GLResults. InstanceDateTime						Between RiskCurrencyConversionValue. StartDate And RiskCurrencyConversionValue. EndDate
Where	#GLResults. MarketValueCrrncyID	<> 19
And		#GLResults. SourceTable			= ''E''			
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Set the Profit/Loss in USD
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		ProfitLoss_USD = (TotalValue * SpotTradeFXRate) + (MarketValue * SpotMarketFXRate)
Where	#GLResults. SourceTable	= ''E''	
'	
					
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
*/

----------------------------------------------------------------------------------------------------------------------------------
-- Block 40: General Updates
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Remove any deals entered after the accounting period being closed
----------------------------------------------------------------------------------------------------------------------------------	
Select 	@vc_DynamicSQL = '
Delete	#GLResults
From	#GLResults				(NoLock)
		Inner Join	DealHeader	(NoLock)	On	#GLResults. DlHdrID	= DealHeader. DlHdrID
Where	DealHeader. DlHdrDsplyDte	> ''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''
And		#GLResults.	IsInventory		= 0
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


----------------------------------------------------------------------------------------------------------------------------------
-- Remove Deals where AccountingTreatment is NULL or "N"
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '	
Delete	#GLResults
From	#GLResults
		Left Outer Join GeneralConfiguration (NoLock)
			on	GeneralConfiguration.GnrlCnfgTblNme			= ''DealHeader''
			and	GeneralConfiguration.GnrlCnfgQlfr			= ''AccountingTreatment''
			and GeneralConfiguration.GnrlCnfgHdrID			= #GLResults. DlHdrID
		Left Outer Join v_MTV_XrefAttributes (NoLock)
			on	v_MTV_XrefAttributes.Source					= ''XRef''
			and	v_MTV_XrefAttributes.Qualifier				= ''Accounting Treatment'' -- note the space
			and	v_MTV_XrefAttributes.ExternalValue			= GeneralConfiguration.GnrlCnfgMulti
Where	IsNull(v_MTV_XrefAttributes.RAValue, ''N'')	<> ''Y''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Delete any records with a 0 gain/loss
----------------------------------------------------------------------------------------------------------------------------------		
Select 	@vc_DynamicSQL = '
Delete	#GLResults
Where	Round(ProfitLoss, 2)	= 0.00	
And		IsAccrual				= 0											 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Set the BATpe
----------------------------------------------------------------------------------------------------------------------------------	
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		 BATpe		= BusinessAssociate. BATpe
From	#GLResults						(NoLock)
		Inner Join	BusinessAssociate	(NoLock)	On	#GLResults. ExternalBAID	= BusinessAssociate. BAID										
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Set the DlDtlSpplyDmnd value for records that may not have one
----------------------------------------------------------------------------------------------------------------------------------	
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		 DlDtlSpplyDmnd		=	Case
									When	Volume	>= 0	Then	''R''
									Else	''D''
								End
From	#GLResults						(NoLock)
Where	DlDtlSpplyDmnd	Is Null									
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Set the transaction type to either an asset or a loss on physicals
----------------------------------------------------------------------------------------------------------------------------------	
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		TrnsctnTypID	=	Case
								When	ProfitLoss	< 0	Then	'+Convert(varchar, @i_PurchAccrualXTypeID)+'	-- Purchase - Accrual
								Else	'+Convert(varchar, @i_SalesAccrualXTypeID)+'							-- Sales - Accrual
							End
Where	#GLResults. IsInventory		= 0
And		#GLResults. IsAccrual		= 1
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Set the transaction type to either an asset or a loss on physicals
----------------------------------------------------------------------------------------------------------------------------------	
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		TrnsctnTypID	=	'+Convert(varchar, @i_IncompleteAccrualXTypeID)+'							-- Sales - Accrual
Where	#GLResults. IsInventory		= 0
And		#GLResults. IsAccrual		= 1
And		#GLResults. PriceEndDate	> ''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Set the transaction type to either an asset or a loss on physicals
----------------------------------------------------------------------------------------------------------------------------------	
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		TrnsctnTypID	=	Case
								When	ProfitLoss	< 0	Then	2029	-- Unrealized Earnings - Physical Fwd Liability  
								Else	2027							-- Unrealized Earnings - Physical Fwd Asset 	
							End
Where	#GLResults. IsInventory		= 0
And		#GLResults. IsAccrual		= 0	
-- And		IsNull(#GLResults. DlDtlTmplteID,-1)	Not In (' + dbo.GetDlDtlTmplteIDs('Futures,Exchange Traded Options,Over the Counter Options ,Swaps') + ')					
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Set the transaction type to either an asset or a loss on physicals
----------------------------------------------------------------------------------------------------------------------------------	
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		TrnsctnTypID	=	Case
								When	ProfitLoss	< 0	Then	2029	-- Unrealized Earnings - Derivative Liability 
								Else	2027							-- Unrealized Earnings - Derivative Asset  	
							End
Where	#GLResults. IsInventory		= 0
And		#GLResults. IsAccrual		= 0	
And		#GLResults. DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Futures,Exchange Traded Options,Over the Counter Options ,Swaps') + ')						
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Set the cash direction based on whether or not the profit is positive or negative - should we exclude adjustments here ??
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		DlDtlPrvsnMntryDrctn	=	Case
										When	TrnsctnTypID In (2029)	Then	''R''
										Else	''D''
									End		
Where	#GLResults. IsInventory	= 0
And		#GLResults. IsAccrual	= 0
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Users will enter negative receivables to offest profit rather than entering a loss so we have to compensate for this scenario
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		Credit		= ''Y''	
From	#GLResults	(NoLock)
Where	#GLResults. IsInventory		<> 1
And		#GLResults. IsAccrual		= 0
And		#GLResults. TrnsctnTypID	In (2027)
And		#GLResults. ProfitLoss		< 0												
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------------------
-- Users will enter negative receivables to offest profit rather than entering a loss so we have to compensate for this scenario
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		Credit		= ''Y''	
From	#GLResults	(NoLock)
Where	#GLResults. IsInventory		<> 1
And		#GLResults. IsAccrual		= 0
And		#GLResults. TrnsctnTypID	In (2029)
And		#GLResults. ProfitLoss		> 0	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Move all the inhouse deals to the asset account // JPW 04/02 - Follow up with BWO
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		TrnsctnTypID	= 2027
From	#GLResults	(NoLock)
Where	#GLResults. DlDtlTmplteID	In	(33000
,33001
,33002
,33003
,30000
,30001
,31000
,31001
,32000
,32001) 
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
	
----------------------------------------------------------------------------------------------------------------------------------
-- NULL out the Deal Detail ID if it doesn't exist currently else it will fail the Deal Detail Check on the Account Detail Insert
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		DlDtlID	= NULL
Where	#GLResults. DlDtlID	Is Not Null	
And		Not Exists	(	Select	''X''
						From	DealDetail	(NoLock)
						Where	DealDetail. DlDtlDlHdrID	= #GLResults. DlHdrID
						And		DealDetail. DlDtlID			= #GLResults. DlDtlID)																	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- NULL out the Transfer ID if it doesn't exist currently else it will fail the Transfer Check on the Account Detail Insert
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		PlnndTrnsfrID	= NULL	
Where	#GLResults. PlnndTrnsfrID	Is Not Null
And		Not Exists	(	Select	''X''
						From	PlannedTransfer	(NoLock)
						Where	PlannedTransfer. PlnndTrnsfrID	= #GLResults. PlnndTrnsfrID)											
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- NULL out the Strategy ID if it doesn't exist currently else it will fail the Transfer Check on the Account Detail Insert
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Update	#GLResults
Set		StrtgyID	= 1
Where	#GLResults. StrtgyID	Is Null
Or		Not Exists	(	Select	''X''
						From	StrategyHeader	(NoLock)
						Where	StrategyHeader. StrtgyID	= #GLResults. StrtgyID)											
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------------------
-- Remove any internal BA records that aren't part of this run
----------------------------------------------------------------------------------------------------------------------------------
If	IsNull(@vc_InternalBAID,'0')	<> '0'
	Begin
		Select 	@vc_DynamicSQL = '
		Delete	#GLResults	
		Where	InternalBAID	Not In (' + @vc_InternalBAID + ')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		
	End


----------------------------------------------------------------------------------------------------------------------------------
-- Populate #GLTempData
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Select	 #GLResults. RiskID									-- RiskID
		,#GLResults. SourceTable							-- SourceTable
		,#GLResults. DlHdrID								-- DlHdrID
		,#GLResults. DlDtlID								-- DlDtlID
		,#GLResults. PlnndTrnsfrID							-- AcctDtlPlnndTrnsfrID 
		,Null												-- MnlLdgrEntryID
		,Null												-- MnlLdgrEntryLgID
		,#GLResults. InternalBAID							-- InternalBAID
		,#GLResults. ExternalBAID							-- ExternalBAID
		,' + convert(varchar,@i_AccntngPrdID) + '			-- AcctPrdid
		,#GLResults. TrdePrdid								-- TrdePrdid
		,Case When IsAccrual = 1 Then #GLResults. Volume Else 0 End 										-- Volume
		,Abs(#GLResults. TotalValuePerUnit)					-- TradePrice
		,Abs(#GLResults. MarketValuePerUnit)				-- MarketPrice				
		,#GLResults. ProfitLoss_USD 						-- GainLoss						-- #GLResults. ProfitLoss
		,#GLResults. TrnsctnTypID							-- TransactionTypeID
		,#GLResults. DlDtlPrvsnMntryDrctn					-- WePayTheyPay
		,#GLResults. PrdctID								-- ParentPrdctID
		,#GLResults. ChmclID								-- ChildPrdctID
		,#GLResults. StrtgyID								-- StrtgyID
		,IsNull(#GLResults. ReferenceDate, ''' + convert(varchar,@sdt_AccntngPrdEndDte) + ''')					-- ReferenceDate			
		,#GLResults. LcleID									-- AcctDtlLcleID
		,#GLResults. BATpe									-- BARelationship
		,#GLResults. DlDtlSpplyDmnd							-- SupplyDemand
		,Null												-- MLAcctPrdId
		,19													-- CrrncyID						-- #GLResults. TotalValueCrrncyID
		,''Y''												-- New
		,Null												-- OriginalAcctDtlID
		,#GLResults. P_EODEstmtedAccntDtlID					-- P_EODEstmtedAccntDtlID
		,#GLResults. SpotTradeFXRate 						-- BaseExchangeRate				-- IsNull(#GLResults. TotalValueFXRate, 1)
		,Null												-- RawPriceDetailID
		,19													-- BaseCurrencyID
		,#GLResults. BAVTradePeriod 						-- BAVTradePeriod
		,IsNull(#GLResults. DlDtlPrvsnUOMID, 3)				-- UOMID
		,Null												-- HedgeHeaderID
 		,Null												-- Term	
		,''U''												-- Type
		,Null												-- HedgeType
		,''N''												-- IsHedge
		,Null												-- OldStyleVolume
		,Null												-- OldStyleValue
		,''N''												-- ApplyNegative 
		,#GLResults. Credit									-- Credit
		,#GLResults. IsPrimaryCost							-- IsPrimaryCost
From	#GLResults	(NoLock)
'

If @c_OnlyShowSQL = 'Y' Select IsNull(@vc_SQL_Insert,'') + @vc_DynamicSQL Else Execute (@vc_SQL_Insert + @vc_DynamicSQL)	
						

/*
----------------------------------------------------------------------------------------------------------------------------------
-- Bring the market per unit back up to the results table
----------------------------------------------------------------------------------------------------------------------------------
Select 	@vc_DynamicSQL = '
Select	P_EODSnpShtID
		,InstanceDateTime
		,EndOfDay
		,RecordSource
		,RiskID
		,DlHdrID
		,DlHdrIntrnlNbr
		,DlHdrDsplyDte
		,InternalBAID
		,ExternalBAID
		,BACountryCode
		,DlDtlID
		,DlDtlINCO
		,DlDtlSpplyDmnd
		,DlDtlTmplteID		
		,LcleID
		,PrdctID
		,ChmclID
		,DlDtlPrvsnID
		,PrvsnID
		,DlDtlPrvsnMntryDrctn
		,IsPrimaryCost
		,IsFlatFee
		,TrnsctnTypID
		,TrnsctnTypDesc
		,TrmAbbrvtn
		,PlnndTrnsfrID
		,StrtgyID
		,Volume
		-- ,ValuationVolume
		,PricedInPercentage
		,TotalValuePerUnit
		,TotalValue
		,TotalValueFXRate
		,TotalValueCrrncyID
		,MarketValuePerUnit
		,MarketValue
		,MarketValueFXRate
		,MarketValueCrrncyID
		,ProfitLoss
		,AccntngPrdBgnDte
		,DeliveryPeriodStartDate
		,DeliveryPeriodEndDate
		,SourceTable
		,CostSourceTable
		,SpecificGravity
		,Energy
From	#GLResults	(NoLock)
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

*/

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('Custom_Calculate_Unrealized_Earnings') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC Custom_Calculate_Unrealized_Earnings>>>'
	Grant Execute on Custom_Calculate_Unrealized_Earnings to SYSUSER
	Grant Execute on Custom_Calculate_Unrealized_Earnings to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure Custom_Calculate_Unrealized_Earnings>>>'
GO


