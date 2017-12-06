
/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_GetTempMarkToMarket WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_GetTempMarkToMarket]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_GetTempMarkToMarket.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetTempMarkToMarket]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_GetTempMarkToMarket] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_GetTempMarkToMarket >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTV_GetTempMarkToMarket]
-- =============================================
-- Author:		Amar Kenguva
-- Create date: 09/27/2018
-- Description:	Load latest snapshot Mark to Market data into Custom Table [db_datareader].[MTVTempMarkToMarket]
-- =============================================

	
AS
BEGIN
	
	
IF NOT EXISTS (SELECT TOP 1 1 FROM Snapshot(NOLOCK)
WHERE NightlySnapshot = 'Y' AND IsValid = 'N' AND Purged = 'N')
BEGIN




SET NOCOUNT ON; 

DECLARE @i_P_EODSnpShtID Int,@SnapshotId Int, @StartedFromVETradePeriodID Int,@SnapshotInstanceDateTime SmallDateTime,@CompareSnapshotInstanceDateTime SmallDateTime,@SnapshotEndOfDay SmallDateTime
,@CompareSnapshotEndOfDay SmallDateTime,@CompareWithAnotherSnapshot Bit,@ComparisonSnapshotId Int,@1DayInstanceDateTime SmallDateTime,@5DayInstanceDateTime SmallDateTime
,@WklyInstanceDateTime SmallDateTime,@MtDInstanceDateTime SmallDateTime,@QtDInstanceDateTime SmallDateTime,@YtDInstanceDateTime SmallDateTime,@RiskReportCriteriaRetrievalOption VarChar (8000)
,@PositionGroupId VarChar (8000),@ProductLocationChemicalId VarChar (8000),@PortfolioId VarChar (8000),@StrategyId VarChar (8000),@InternalBa VarChar (8000),@StartingVeTradePeriodId SmallInt
,@NumberOfPeriods VarChar (8000),@AggregateRecordsOutsideOfDateRange Bit,@AppendWhatIfScenarios Bit,@WhatIfScenarioId Int,@RiskReportInventoryRetrievalOption VarChar (8000)
,@TradePeriodStartDate SmallDateTime,@MaxTradePeriodStartDate SmallDateTime,@MaxTradePeriodEndDate SmallDateTime,@EndOfTimePeriodStartDate SmallDateTime,@EndOfTimePeriodEndDate SmallDateTime
,@InventoryTradePeriodStart SmallDateTime,@InventoryTradePeriodEnd SmallDateTime,@BegInvSourceTable Char,@RetrievalOptions Int,@35@RiskDealDetail@DlDtlIntrnlUserID Int,@36@Risk@StrtgyID Int


SELECT @i_P_EODSnpShtID='-1',@CompareWithAnotherSnapshot='False',@ComparisonSnapshotId='-2',@1DayInstanceDateTime='1990-01-01 00:00:00'
,@WklyInstanceDateTime='1990-01-01 00:00:00',@MtDInstanceDateTime='1990-01-01 00:00:00',@QtDInstanceDateTime='1990-01-01 00:00:00'
,@YtDInstanceDateTime='1990-01-01 00:00:00',@RiskReportCriteriaRetrievalOption='P',@PositionGroupId= NULL 
,@ProductLocationChemicalId= NULL ,@PortfolioId='53',@StrategyId= NULL ,@InternalBa='20',@StartingVeTradePeriodId='0'
,@NumberOfPeriods='-1',@AggregateRecordsOutsideOfDateRange='False',@AppendWhatIfScenarios='False',@WhatIfScenarioId= NULL 
,@RiskReportInventoryRetrievalOption='I',@MaxTradePeriodStartDate='2076-05-01 00:00:00',@MaxTradePeriodEndDate='2076-05-31 23:59:00'
,@EndOfTimePeriodStartDate='2050-12-01 00:00:00',@EndOfTimePeriodEndDate='2050-12-01 23:59:00', @BegInvSourceTable='S',@RetrievalOptions='265',@35@RiskDealDetail@DlDtlIntrnlUserID= NULL 
,@36@Risk@StrtgyID= NULL 



SELECT @SnapshotId =  P_EODSnpShtID ,@SnapshotInstanceDateTime = InstanceDateTime, @StartedFromVETradePeriodID = StartedFromVETradePeriodID
,@CompareSnapshotInstanceDateTime = InstanceDateTime, @SnapshotEndOfDay = EndOfDay, @CompareSnapshotEndOfDay = EndOfDay
,@5DayInstanceDateTime=InstanceDateTime,
@TradePeriodStartDate = (SELECT [StartDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
,@InventoryTradePeriodStart = (SELECT [StartDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
,@InventoryTradePeriodEnd = (SELECT [EndDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
FROM Snapshot(NOLOCK)
WHERE P_EODSnpShtID = (SELECT max(P_EODSnpShtID) FROM Snapshot(NOLOCK)
WHERE NightlySnapshot = 'Y' AND IsValid = 'Y' AND Purged = 'N')


IF NOT EXISTS(SELECT TOP 1 1 FROM [db_datareader].[MTVTempMarkToMarket]
WHERE snapshot_id = @SnapshotId AND end_of_day = @SnapshotEndOfDay)

BEGIN

IF EXISTS(SELECT TOP 1 1 FROM [db_datareader].[MTVTempMarkToMarket])
	TRUNCATE TABLE [db_datareader].[MTVTempMarkToMarket]

Create Table #StrategyReportCriteria
(
	StrtgyID 		Int Not Null
)

Insert Into [#StrategyReportCriteria] ([StrtgyID])
 (Select	[P_PortfolioStrategyFlat].[StrtgyID]
From	[P_PortfolioStrategyFlat] (NoLock)

Where	(
	[P_PortfolioStrategyFlat].[P_PrtflioID] In (53)
	))

Create Table #RiskResults
(
	Idnty 		Int identity  Not Null,
	RiskSourceValueID 		Int Null default 0,
	RiskID 		Int Not Null,
	SourceTable 		VarChar(3) COLLATE DATABASE_DEFAULT  Not Null,
	IsPrimaryCost 		Bit Not Null,
	DlDtlTmplteID 		Int Null,
	TmplteSrceTpe 		VarChar(2) COLLATE DATABASE_DEFAULT  Null,
	RiskExposureTableIdnty 		Int Null,
	Percentage 		Float Null,
	RiskCurveID 		Int Null,
	DeliveryPeriodStartDate 		SmallDateTime Not Null,
	DeliveryPeriodEndDate 		SmallDateTime Not Null,
	AccountingPeriodStartDate 		SmallDateTime Not Null,
	AccountingPeriodEndDate 		SmallDateTime Not Null,
	Position 		Decimal(38,15) Null default 0.0,
	ValuationPosition 		Decimal(38,15) Null default 0.0,
	SpecificGravity 		Decimal(38,15) Null default 0.0,
	Energy 		Decimal(38,15) Null default 0.0,
	TotalPnL 		Float Null default 0.0,
	PricedPnL 		Float Null default 0.0,
	TotalValue 		Float Null default 0.0,
	PricedValue 		Float Null default 0.0,
	MarketValue 		Float Null default 0.0,
	PricedInPercentage 		Decimal(28,13) Null default 1.0,
	MarketValueIsMissing 		Bit Not Null default 0,
	DealValueIsMissing 		Bit Not Null default 0,
	MarketCrrncyID 		SmallInt Null,
	PaymentCrrncyID 		SmallInt Null,
	MarketValueFXRate 		Float Not Null default 1.0,
	TotalValueFXRate 		Float Not Null default 1.0,
	PricedValueFXRate 		Float Not Null default 1.0,
	DiscountFactor 		Float Not Null default 1.0,
	DiscountFactorID 		Int Null,
	MarketDiscountFactor 		Float Not Null default 1.0,
	MarketDiscountFactorID 		Int Null,
	SplitType 		VarChar(10) COLLATE DATABASE_DEFAULT  Null,
	DefaultCurrencyID 		Int Null,
	InstanceDateTime 		SmallDateTime Not Null,
	IsPPA 		Bit Not Null default 0,
	IsPriorMonthTransaction 		Bit Not Null default 0,
	IsEstMovementWithFuturePricing 		Bit Not Null default 0,
	FloatingPerUnitValue 		Float Null default 0.0,
	PricedInPerUnitValue 		Float Null default 0.0,
	CloseOfBusiness 		SmallDateTime Null,
	Snapshot 		Int Null,
	SnapshotDateTime 		SmallDateTime Null,
	SnapshotAccountingPeriod 		SmallDateTime Null,
	SnapshotTradePeriod 		SmallDateTime Null,
	SnapshotIsArchived 		Bit Not Null default 0,
	HistoricalPnLExists 		Bit Not Null default 0,
	ShowZeroPosition 		Bit Not Null default 0,
	ShowZeroMarketValue 		Bit Not Null default 0,
	IsInventoryMove 		VarChar(3) COLLATE DATABASE_DEFAULT  Null default 'No',
	Account 		VarChar(9) COLLATE DATABASE_DEFAULT  Null default 'Trading',
	IsEstMovementWithFuturePricing_Balance 		Bit Not Null default 0,
	ReplaceTotalValuewithMarket 		Bit Not Null default 0,
	AttachedInHouse 		Char(1) COLLATE DATABASE_DEFAULT  Not Null default 'N',
	EstimatedPaymentDate 		SmallDateTime Null,
	UnAdjustedPosition 		Float Not Null default 0.0,
	RelatedSwapRiskID 		Int Null,
	IsFlatFee 		Bit Not Null default 0,
	PrdctID 		Int Null,
	ChmclID 		Int Null,
	LcleID 		Int Null,
	TotalQuotePercentage 		Float Not Null default 0.0,
	TotalPricedPercentage 		Float Not Null default 0.0,
	SellSwapPricedValue 		Float Null default 0,
	LeaseDealDetailID 		Int Null,
	IsOption 		Bit Not Null default 0,
	CombineSwap 		Bit Not Null default 1,
	ConversionCrrncyID 		Int Null,
	RelatedDealNumber 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	MoveExternalDealID 		Int Null,
	ApplyDiscount 		Bit Not Null default 0,
	MarketValueFXConversionDate 		SmallDateTime Null,
	DealValueFXConversionDate 		SmallDateTime Null,
	CurrencyPairID 		SmallInt Null,
	IsReciprocal 		Bit Null,
	FxForwardRate 		Float Null,
	CurrencyPairFxRate 		Float Null,
	CurrencyPairFxRateErrors 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null
)

Create NonClustered Index IE_RiskID_DlDtlTmplteID on #RiskResults (RiskID,DlDtlTmplteID)

Create NonClustered Index ID_RiskID_InstanceDateTime_IsPriorMonthTransaction on #RiskResults (RiskID, InstanceDateTime,IsPriorMonthTransaction )

Create Table #RiskResultsOptions
(
	RiskID 		Int Not Null,
	RiskDealDetailOptionID 		Int Not Null,
	RiskResultsTableIdnty 		Int Null,
	DeliveryPeriodStart 		SmallDateTime Not Null,
	DeliveryPeriodEnd 		SmallDateTime Not Null,
	IsOTC 		Bit Not Null default 0,
	DlHdrID 		Int Not Null,
	DlDtlID 		Int Not Null,
	ExpirationDate 		SmallDateTime Null,
	ExercisedDate 		SmallDateTime Null,
	Exercised 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	ExercisedQuantity 		Float Null,
	PutCall 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	Flavor 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	StrikePrice 		Float Null,
	StrikePriceUOM 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	PriceService 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	OTCSettlementTerm 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	OTCPremiumTerm 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	EffectiveStartDate 		SmallDateTime Null,
	EffectiveEndDate 		SmallDateTime Null,
	Premium 		Float Null,
	OTCQuantity 		Float Null,
	BuySell 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	Period 		SmallDateTime Null,
	OTCBuySell1 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	OTCPeriod1 		SmallDateTime Null,
	OTCWeight 		Float Null,
	OTCRow 		Int Null,
	OTCPriceType 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwID 		Int Null,
	OTCBuySell2 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	OTCPeriod2 		SmallDateTime Null,
	OTCWeight2 		Float Null,
	OTCRow2 		Int Null,
	OTCPriceType2 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwID2 		Int Null,
	OTCBuySell3 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	OTCPeriod3 		SmallDateTime Null,
	OTCWeight3 		Float Null,
	OTCRow3 		Int Null,
	OTCPriceType3 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwID3 		Int Null,
	PayOut 		Float Null,
	BarrierPrice 		Float Null,
	KnockOutStatus 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	BarrierType 		VarChar(20) COLLATE DATABASE_DEFAULT  Null,
	OptionRiskID 		Int Null
)

Create NonClustered Index RiskIndex on #RiskResultsOptions (RiskID)

Create Table #RiskResultsMtI
(
	Idnty 		Int identity ,
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RiskDealDetailMarketOverrideID 		Int Null,
	DealDetailMarketOverrideID 		Int Null,
	Percentage 		Float Null default 1.0,
	DealDetailID 		Int Null,
	RwPrceLcleID 		Int Null,
	RiskCurveID 		Int Null,
	MarketIndicator 		VarChar(3) COLLATE DATABASE_DEFAULT  Not Null default 'MtM',
	Position 		Decimal(38,15) Not Null default 0.0,
	Volume 		Decimal(38,15) Not Null default 0.0,
	Offset 		Float Not Null default 0.0,
	IntentType 		VarChar(13) COLLATE DATABASE_DEFAULT  Null,
	PriceTypeID 		SmallInt Null,
	CurveVETradePeriodID 		SmallInt Null,
	FromDate 		SmallDateTime Null,
	ToDate 		SmallDateTime Null,
	MtIMarketValue 		Float Null,
	MtMMarketValue 		Float Null,
	UserReviewRequired 		VarChar(3) COLLATE DATABASE_DEFAULT  Not Null default 'No',
	DlHdrID 		Int Null,
	DlDtlID 		Int Null,
	PlnndTrnsfrID 		Int Null,
	InstanceDateTime 		SmallDateTime Not Null,
	MtIPerUnitValue 		Float Not Null default 0.0,
	TotalTransferPositionForIntent 		Float Null,
	TotalIntentPosition 		Float Null,
	TotalTransferCount 		Int Null,
	TotalIntentCount 		Int Null,
	FXRate 		Float Not Null default 1.0,
	MarketInfoMissing 		Bit Not Null default 0,
	MarketCurrencyID 		Int Null,
	Description 		VarChar(1000) COLLATE DATABASE_DEFAULT  Null,
	ReferenceDate 		SmallDateTime Null
 	Primary Key(Idnty)
)

Create NonClustered Index IE_#RiskResultsMtI_RiskID on #RiskResultsMtI (RiskID)

Create Table #RiskResultsPL
(
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RiskSourceValueID 		Int Null,
	SourceTable 		Char(3) COLLATE DATABASE_DEFAULT  Not Null,
	Yesterday_TotalValue 		Float Not Null default 0.0,
	Yesterday_MarketValue 		Float Not Null default 0.0,
	Yesterday_MarketFXRate 		Float Not Null default 1.0,
	FiveDay_TotalValue 		Float Not Null default 0.0,
	FiveDay_MarketValue 		Float Not Null default 0.0,
	FiveDay_MarketFXRate 		Float Not Null default 1.0,
	LastWeek_TotalValue 		Float Not Null default 0.0,
	LastWeek_MarketValue 		Float Not Null default 0.0,
	LastWeek_MarketFXRate 		Float Not Null default 1.0,
	LastMonth_TotalValue 		Float Not Null default 0.0,
	LastMonth_MarketValue 		Float Not Null default 0.0,
	LastMonth_MarketFXRate 		Float Not Null default 1.0,
	LastQuarter_TotalValue 		Float Not Null default 0.0,
	LastQuarter_MarketValue 		Float Not Null default 0.0,
	LastQuarter_MarketFXRate 		Float Not Null default 1.0,
	LastYear_TotalValue 		Float Not Null default 0.0,
	LastYear_MarketValue 		Float Not Null default 0.0,
	LastYear_MarketFXRate 		Float Not Null default 1.0,
	CurrentPnL 		Float Not Null default 0.0,
	ReferencePnL 		Float Not Null default 0.0,
	PreviousDayPnL 		Float Null default 0.0,
	DayToDayProfitLoss 		Float Not Null default 0.0,
	FiveDaysToDateProfitLoss 		Float Not Null default 0.0,
	WeekToDateProfitLoss 		Float Not Null default 0.0,
	MonthToDateProfitLoss 		Float Not Null default 0.0,
	QuarterToDateProfitLoss 		Float Not Null default 0.0,
	YearToDateProfitLoss 		Float Not Null default 0.0,
	PrevDayMonthToDateProfitLoss 		Float Not Null default 0.0,
	PrevDayQuarterToDateProfitLoss 		Float Not Null default 0.0,
	PrevDayYearToDateProfitLoss 		Float Not Null default 0.0,
	HistoricalPnLExists 		Bit Not Null default 0,
	Percentage 		Float Not Null default 1.0,
	IsEstMovementWithFuturePricing_Balance 		Bit Not Null default 0,
	IsPriorMonthTransaction 		Bit Not Null default 0,
	Ref_ConversionCrrncyID 		Int Null,
	Ref_MarketCrrncyID 		Int Null
)

Create NonClustered Index RiskIndex on #RiskResultsPL (RiskID)

Create Table #RiskResultsSnapshot
(
	RetrievedSnapshot 		Int Null,
	RetrievedCreationDate 		SmallDateTime Null,
	RetrievedDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	RetrievedAccountingStartDate 		SmallDateTime Null,
	RetrievedTradeStartDate 		SmallDateTime Null,
	RetrievedCloseOfBusiness 		SmallDateTime Null,
	DayToDaySnapshot 		Int Null,
	DayToDayCreationDate 		SmallDateTime Null,
	DayToDayDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	DayToDayCloseOfBus 		SmallDateTime Null,
	FiveDaySnapshot 		Int Null,
	FiveDayCreationDate 		SmallDateTime Null,
	FiveDayDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	FiveDayCloseOfBus 		SmallDateTime Null,
	WeekToDateSnapshot 		Int Null,
	WeekToDateCreationDate 		SmallDateTime Null,
	WeekToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	WeekToDateCloseOfBus 		SmallDateTime Null,
	MonthToDateSnapshot 		Int Null,
	MonthToDateCreationDate 		SmallDateTime Null,
	MonthToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	MonthToDateCloseOfBus 		SmallDateTime Null,
	QtrToDateSnapshot 		Int Null,
	QtrToDateCreationDate 		SmallDateTime Null,
	QtrToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	QtrToDateCloseOfBus 		SmallDateTime Null,
	YearToDateSnapshot 		Int Null,
	YearToDateCreationDate 		SmallDateTime Null,
	YearToDateDescription 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	YearToDateCloseOfBus 		SmallDateTime Null
)

Create Index RiskRetrievedSnapshot on #RiskResultsSnapshot (RetrievedSnapshot)

Create Table #RiskResultsSwap
(
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RelatedSwapRiskID 		Int Null,
	RiskSourceValueId 		Int Null,
	BuySell 		Char(4) COLLATE DATABASE_DEFAULT  Null,
	Product 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	Location 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	Period 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	BuyProvision 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	SellProvision 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	SwapBuySellPosition 		Float Not Null default 0.0,
	BuyProduct 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	SellProduct 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	BuyLocale 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	SellLocale 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	BuyPeriod 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	SellPeriod 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	BuyIsFixed 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	SellIsFixed 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwIds 		VarChar(500) COLLATE DATABASE_DEFAULT  Null,
	PricedInPercentage 		Float Null,
	RiskBuySell 		Char(4) COLLATE DATABASE_DEFAULT  Null,
	CombineSwap 		Bit Not Null default 1,
	DeleteRow 		Bit Not Null default 0,
	InstanceDateTime 		SmallDateTime Null,
	ExpiredRiskRow 		Bit Null default 0
)

Create NonClustered Index IE_#RiskResultsSwap_RiskID on #RiskResultsSwap (RiskID)

Create Table #RiskResultsValue
(
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RiskSourceValueID 		Int Null,
	OneDayAgoDealValue 		Float Null default 0.0,
	OneDayAgoMarketValue 		Float Null default 0.0,
	OneDayAgoFX 		Float Null default 1.0,
	OneDayAgoDealFX 		Float Null default 1.0,
	FiveDaysAgoDealValue 		Float Null default 0.0,
	FiveDaysAgoMarketValue 		Float Null default 0.0,
	FiveDaysAgoFX 		Float Null default 1.0,
	FiveDaysAgoDealFX 		Float Null default 1.0,
	LastWeekDealValue 		Float Null default 0.0,
	LastWeekMarketValue 		Float Null default 0.0,
	LastWeekFX 		Float Null default 1.0,
	LastWeekDealFX 		Float Null default 1.0,
	LastMonthDealValue 		Float Null default 0.0,
	LastMonthMarketValue 		Float Null default 0.0,
	LastMonthFX 		Float Null default 1.0,
	LastMonthDealFX 		Float Null default 1.0,
	LastQuarterDealValue 		Float Null default 0.0,
	LastQuarterMarketValue 		Float Null default 0.0,
	LastQuarterFX 		Float Null default 1.0,
	LastQuarterDealFX 		Float Null default 1.0,
	LastYearDealValue 		Float Null default 0.0,
	LastYearMarketValue 		Float Null default 0.0,
	LastYearFX 		Float Null default 1.0,
	LastYearDealFX 		Float Null default 1.0
)

Create NonClustered Index RiskIndex on #RiskResultsValue (RiskID)

Create Table #RiskResultsPosition
(
	RiskID 		Int Not Null,
	RiskResultsTableIdnty 		Int Not Null,
	RiskSourceValueID 		Int Null,
	OneDayAgoPosition 		Decimal(38,15) Null default 0.0,
	OneDayAgoSpecificGravity 		Decimal(38,15) Null default 1.0,
	OneDayAgoEnergy 		Decimal(38,15) Null default 1.0,
	FiveDaysAgoPosition 		Decimal(38,15) Null default 0.0,
	FiveDaysAgoSpecificGravity 		Decimal(38,15) Null default 1.0,
	FiveDaysAgoEnergy 		Decimal(38,15) Null default 1.0,
	LastWeekPosition 		Decimal(38,15) Null default 0.0,
	LastWeekSpecificGravity 		Decimal(38,15) Null default 1.0,
	LastWeekEnergy 		Decimal(38,15) Null default 1.0,
	LastMonthPosition 		Decimal(38,15) Null default 0.0,
	LastMonthSpecificGravity 		Decimal(38,15) Null default 1.0,
	LastMonthEnergy 		Decimal(38,15) Null default 1.0,
	LastQuarterPosition 		Decimal(38,15) Null default 0.0,
	LastQuarterSpecificGravity 		Decimal(38,15) Null default 1.0,
	LastQuarterEnergy 		Decimal(38,15) Null default 1.0,
	LastYearPosition 		Decimal(38,15) Null default 0.0,
	LastYearSpecificGravity 		Decimal(38,15) Null default 1.0,
	LastYearEnergy 		Decimal(38,15) Null default 1.0,
	OptionExercisedEndOfDay 		SmallDateTime Null,
	OptionExercisedIDT 		SmallDateTime Null
)

Create NonClustered Index RiskIndex on #RiskResultsPosition (RiskID)

Create Table #RiskMtMExposure
(
	RiskID 		Int Null,
	RiskResultsTableIdnty 		Int Null,
	DisaggregateRiskType 		VarChar(255) COLLATE DATABASE_DEFAULT  Null,
	FormulaExists 		Bit Not Null default 1,
	BasisExposureRiskCurveID 		Int Null,
	BasisExposureRwPrceLcleID 		Int Null,
	BasisExposureDlDtlPrvsnRwID 		Int Null,
	BasisExposurePeriodStartDate 		SmallDateTime Null,
	BasisExposurePeriodEndDate 		SmallDateTime Null,
	BasisExposureQuoteCount 		Int Null,
	BasisExposureQuoteStart 		SmallDateTime Null,
	BasisExposureQuoteEnd 		SmallDateTime Null,
	FlatExposureRiskCurveID 		Int Null,
	FlatExposureRwPrceLcleID 		Int Null,
	FlatExposureDlDtlPrvsnRwID 		Int Null,
	FlatExposurePeriodStartDate 		SmallDateTime Null,
	FlatExposurePeriodEndDate 		SmallDateTime Null,
	FlatExposurePricedInPercentage 		Int Null,
	FlatExposureQuoteCount 		Int Null,
	FlatExposureQuoteStart 		SmallDateTime Null,
	FlatExposureQuoteEnd 		SmallDateTime Null,
	FlatExposureRollOnDate 		SmallDateTime Null,
	FlatExposureRollOffDate 		SmallDateTime Null,
	GradeDiffExpRiskCurveID 		Int Null,
	GradeDiffExpRwPrceLcleID 		Int Null,
	GradeDiffExpDlDtlPrvsnRwID 		Int Null,
	GradeDiffExpPeriodStartDate 		SmallDateTime Null,
	GradeDiffExpPeriodEndDate 		SmallDateTime Null,
	GradeDiffExpQuoteCount 		Int Null,
	GradeDiffExpQuoteStart 		SmallDateTime Null,
	GradeDiffExpQuoteEnd 		SmallDateTime Null,
	RollOnDate 		SmallDateTime Null,
	RollOffDate 		SmallDateTime Null
)

Create Table #FinalResultsMtM
(
	RiskResultsIdnty 		Int Null,
	RiskID 		Int Null,
	Description 		VarChar(2000) COLLATE DATABASE_DEFAULT  Null,
	DlDtlID 		Int Null,
	InternalBAID 		Int Null,
	ExternalBAID 		Int Null,
	UserID 		Int Null,
	DlDtlCrtnDte 		SmallDateTime Null,
	PrdctID 		Int Null,
	ChmclID 		Int Null,
	LcleID 		Int Null,
	DeliveryPeriodStartDate 		SmallDateTime Null,
	DeliveryPeriodEndDate 		SmallDateTime Null,
	AccountingPeriodStartDate 		SmallDateTime Null,
	CloseOfBusiness 		SmallDateTime Null,
	StrtgyID 		Int Null,
	PricedInPercentage 		Float Null,
	Position 		Float Null,
	PricedPosition 		Float Null,
	FloatPosition 		Float Null,
	PricedPnL 		Float Null,
	TotalPnL 		Float Null,
	FloatPnl 		Float Null,
	FloatValue 		Float Null,
	SpecificGravity 		Float Null,
	Energy 		Float Null,
	DefaultCurrencyID 		Int Null,
	AggregationGroupName 		VarChar(300) COLLATE DATABASE_DEFAULT  Null,
	AttachedInHouse 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	TotalValue 		Float Null,
	PricedValue 		Float Null,
	MarketValue 		Float Null,
	MaxPeriodStartDate 		SmallDateTime Null,
	MarketValueIsMissing 		Bit Null,
	DealValueIsMissing 		Bit Null,
	DlDtlTmplteID 		Int Null,
	PerUnitValue 		Float Null,
	MarketPerUnitValue 		Float Null,
	MarketCrrncyID 		Int Null,
	PaymentCrrncyID 		Int Null,
	MarketValueFXRate 		Float Null,
	TotalValueFXRate 		Float Null,
	PricedValueFXRate 		Float Null,
	IsSwap 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	InstanceDateTime 		SmallDateTime Null,
	ConversionCrrncyID 		Int Null,
	RiskResultsMtIIdnty 		Int Null,
	RiskAdjustmentID 		Int Null,
	ConversionDeliveryPeriodID 		SmallInt Null,
	MarketValueFXConversionDate 		SmallDateTime Null,
	DealValueFXConversionDate 		SmallDateTime Null
)

Create NonClustered Index IE_#FinalResultsMtM_RiskID_DlDtlTmplteID on #FinalResultsMtM (RiskID,DlDtlTmplteID)

Create NonClustered Index ID_#FinalResultsMtM_RiskID_InstanceDateTime_IsPriorMonthTransaction on #FinalResultsMtM (RiskID, InstanceDateTime )

-- Physical Insert 

Insert Into [#RiskResults] ([RiskID]
	,[SourceTable]
	,[RiskExposureTableIdnty]
	,[Percentage]
	,[RiskCurveID]
	,[DlDtlTmplteID]
	,[IsPrimaryCost]
	,[DeliveryPeriodStartDate]
	,[DeliveryPeriodEndDate]
	,[AccountingPeriodStartDate]
	,[AccountingPeriodEndDate]
	,[InstanceDateTime]
	,[IsPriorMonthTransaction]
	,[IsInventoryMove]
	,[Account])
 (Select	[Risk].[RiskID]
	,[Risk].[SourceTable]
	,Null
	,1.0
	,Null
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsPrimaryCost]
	,[Risk].[DeliveryPeriodStartDate]
	,[Risk].[DeliveryPeriodEndDate]
	,[Risk].[AccountingPeriodStartDate]
	,[Risk].[AccountingPeriodEndDate]
	,@SnapshotInstanceDateTime
	,0
	,'No' IsInventoryMove
	,'Trading' Account
From	[Risk] (NoLock)
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source].DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and @SnapshotInstanceDateTime between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
Where	(
	[Risk].[IsVolumeOnly] = 0
And	Not Exists (Select 1 From #RiskResults X Where X.RiskID = Risk.RiskID and X.InstanceDateTime = @SnapshotInstanceDateTime)
And	[Risk].[CostSourceTable] <> 'IV'
And	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	Exists ( Select 1 From dbo.TransactionTypeGroup x (NoLock) Where x.XTpeGrpXGrpID = 76 And Risk.TrnsctnTypID = x. XTpeGrpTrnsctnTypID) 
And	[Risk].[IsRemittable] = 0
And	[Risk].[SourceTable] <> 'B'
And	[Risk].[SourceTable] <> 'S'
And	[Risk].[SourceTable] <> 'ES'
And	[Risk].[SourceTable] <> 'EB'
And	[Risk].[CostSourceTable] <> 'IV'
And	[Risk].[CostSourceTable] <> 'S'
And	(Risk.IsWriteOnWriteOff = Convert(Bit, 0) or Risk. SourceTable In('EIX','EIP','I'))
And	( IsNull(Risk.DlDtlTmplteId, 0) Not In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103)Or Not (IsNull(Risk. DlDtlTmplteID, 0) In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103) And Risk.SourceTable = 'A'And Risk.AccountingPeriodStartDate < @TradePeriodStartDate

))
And	[Risk].[CostSourceTable] <> 'ML'
And	 (IsNull(Risk. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or Risk.SourceTable In ('EIX','EIP') )
And	1 = Case When Risk.SourceTable = 'P' And Risk.DeliveryPeriodEndDate Between @TradePeriodStartDate and '2076-05-31 23:59:00'

 Then 1 

 When IsNull(Risk. InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate)	Between @TradePeriodStartDate and '2076-05-31 23:59:00'

 Then 1 Else 0 End


And	((

( Risk. AccountingPeriodStartDate Between @TradePeriodStartDate and '2076-05-31 23:59:00' Or Risk.AccountingPeriodEndDate Between @TradePeriodStartDate and '2076-05-31 23:59:00' )

And ( Risk. AccountingPeriodStartDate >= @TradePeriodStartDate )

)

)


And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
	))

-- PPA Insert 

Insert Into [#RiskResults] ([RiskID]
	,[SourceTable]
	,[RiskExposureTableIdnty]
	,[Percentage]
	,[RiskCurveID]
	,[DlDtlTmplteID]
	,[IsPrimaryCost]
	,[DeliveryPeriodStartDate]
	,[DeliveryPeriodEndDate]
	,[AccountingPeriodStartDate]
	,[AccountingPeriodEndDate]
	,[InstanceDateTime]
	,[IsPriorMonthTransaction]
	,[IsInventoryMove]
	,[Account])
 (Select	[Risk].[RiskID]
	,[Risk].[SourceTable]
	,Null
	,1.0
	,Null
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsPrimaryCost]
	,[Risk].[DeliveryPeriodStartDate]
	,[Risk].[DeliveryPeriodEndDate]
	,[Risk].[AccountingPeriodStartDate]
	,[Risk].[AccountingPeriodEndDate]
	,@SnapshotInstanceDateTime
	,0
	,'No' IsInventoryMove
	,'Trading' Account
From	[Risk] (NoLock)
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source].DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and @SnapshotInstanceDateTime between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
Where	(
	[Risk].[IsVolumeOnly] = 0
And	Not Exists (Select 1 From #RiskResults X Where X.RiskID = Risk.RiskID and X.InstanceDateTime = @SnapshotInstanceDateTime)
And	[Risk].[CostSourceTable] <> 'IV'
And	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	Exists ( Select 1 From dbo.TransactionTypeGroup x (NoLock) Where x.XTpeGrpXGrpID = 76 And Risk.TrnsctnTypID = x. XTpeGrpTrnsctnTypID) 
And	[Risk].[IsRemittable] = 0
And	[Risk].[SourceTable] <> 'B'
And	[Risk].[SourceTable] <> 'S'
And	[Risk].[SourceTable] <> 'ES'
And	[Risk].[SourceTable] <> 'EB'
And	[Risk].[CostSourceTable] <> 'IV'
And	[Risk].[CostSourceTable] <> 'S'
And	(Risk.IsWriteOnWriteOff = Convert(Bit, 0) or Risk. SourceTable In('EIX','EIP','I'))
And	Risk.SourceTable <> 'T'
And	IsNull(Risk. InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate)	< @TradePeriodStartDate
And	( Risk. AccountingPeriodStartDate Between @TradePeriodStartDate and '2076-05-31 23:59:00' Or Risk. AccountingPeriodEndDate Between @TradePeriodStartDate and '2076-05-31 23:59:00')
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
	))

-- Balances Insert 

Insert Into [#RiskResults] ([RiskID]
	,[SourceTable]
	,[RiskExposureTableIdnty]
	,[Percentage]
	,[RiskCurveID]
	,[DlDtlTmplteID]
	,[IsPrimaryCost]
	,[DeliveryPeriodStartDate]
	,[DeliveryPeriodEndDate]
	,[AccountingPeriodStartDate]
	,[AccountingPeriodEndDate]
	,[InstanceDateTime]
	,[IsPriorMonthTransaction]
	,[IsInventoryMove]
	,[Account])
 (Select	[Risk].[RiskID]
	,[Risk].[SourceTable]
	,Null
	,1.0
	,Null
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsPrimaryCost]
	,[Risk].[DeliveryPeriodStartDate]
	,[Risk].[DeliveryPeriodEndDate]
	,[Risk].[AccountingPeriodStartDate]
	,[Risk].[AccountingPeriodEndDate]
	,@SnapshotInstanceDateTime
	,0
	,'No' IsInventoryMove
	,'Trading' Account
From	[Risk] (NoLock)
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source].DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and @SnapshotInstanceDateTime between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
Where	(
	[Risk].[IsVolumeOnly] = 0
And	Not Exists (Select 1 From #RiskResults X Where X.RiskID = Risk.RiskID and X.InstanceDateTime = @SnapshotInstanceDateTime)
And	[Risk].[CostSourceTable] <> 'IV'
And	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	Exists ( Select 1 From dbo.TransactionTypeGroup x (NoLock) Where x.XTpeGrpXGrpID = 76 And Risk.TrnsctnTypID = x. XTpeGrpTrnsctnTypID) 
And	[Risk].[IsInventory] = 1
And	Risk.SourceTable In('S','EB')
And	( Risk.DeliveryPeriodStartDate Between @TradePeriodStartDate and @InventoryTradePeriodEnd)
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
	))

-- Select * From #RiskResults

execute dbo.SRA_Risk_Report_MtM_UpdateTempTables @c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@sdt_StartingAccountingPeriodStartDate = @TradePeriodStartDate,@vc_AdditionalColumns = 'Select	Top 1 ''Y''
From	RiskDealIdentifier(NoLock) OtherDealSide
	inner Join Risk(NoLock) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NoLock) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk.IsInventory,Risk.DlDtlTmplteID,Risk Transfer.SchdlngPrdID,Risk Deal Detail.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.PlannedTransfer.PTParcelNumber,Risk Deal Link.PlannedTransfer.PTReceiptDelivery,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,Risk.TrnsctnTypID,Risk Transfer.PlnndTrnsfrID,{Calculated Columns}.CloseOfBusiness,{Calculated Columns}.Snapshot,Risk Deal Detail.DlDtlCrtnDte,Risk Deal Price.(First Row) RiskDealDetailProvisionRow.FormulaOffset,Risk Deal Detail.DlHdrStat,Risk Deal Detail.DlDtlDsplyUOM,Risk Deal Detail.NegotiatedDate,{Calculated Columns}.IsPrimaryCost,Risk Deal Price Source.RiskDealDetailProvision.(First Row) RiskDealDetailProvisionRow.RawPriceLocale.RPLcleIntrfceCde,Risk Deal Link.DealHeader.GeneralConfiguration.AccountingTreatment,Risk Deal Detail.DealDetail.DlDtlMthdTrnsprttn',@b_IncludeWhatIfScenarios = False,@i_TradePeriodFromID = @StartedFromVETradePeriodID,@vc_InternalBAID = '20',@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_IsThisNavigation = 'N',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@b_discountpositions = False,@c_disaggregatepositions = False,@b_UseMtI = False,@b_RetrieveInBaseCurrency = False,@vc_InventoryBasis = 'Beginning',@b_DeleteZeroPnLRows = True

execute dbo.SRA_Risk_Report_MtM_UpdateTempTables @c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@sdt_StartingAccountingPeriodStartDate = @TradePeriodStartDate,@vc_AdditionalColumns = 'Select	Top 1 ''Y''
From	RiskDealIdentifier(NoLock) OtherDealSide
	inner Join Risk(NoLock) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NoLock) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk.IsInventory,Risk.DlDtlTmplteID,Risk Transfer.SchdlngPrdID,Risk Deal Detail.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.PlannedTransfer.PTParcelNumber,Risk Deal Link.PlannedTransfer.PTReceiptDelivery,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,Risk.TrnsctnTypID,Risk Transfer.PlnndTrnsfrID,{Calculated Columns}.CloseOfBusiness,{Calculated Columns}.Snapshot,Risk Deal Detail.DlDtlCrtnDte,Risk Deal Price.(First Row) RiskDealDetailProvisionRow.FormulaOffset,Risk Deal Detail.DlHdrStat,Risk Deal Detail.DlDtlDsplyUOM,Risk Deal Detail.NegotiatedDate,{Calculated Columns}.IsPrimaryCost,Risk Deal Price Source.RiskDealDetailProvision.(First Row) RiskDealDetailProvisionRow.RawPriceLocale.RPLcleIntrfceCde,Risk Deal Link.DealHeader.GeneralConfiguration.AccountingTreatment,Risk Deal Detail.DealDetail.DlDtlMthdTrnsprttn',@b_IncludeWhatIfScenarios = False,@i_TradePeriodFromID = @StartedFromVETradePeriodID,@vc_InternalBAID = '20',@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_IsThisNavigation = 'N',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@b_discountpositions = False,@c_disaggregatepositions = False,@b_UseMtI = False,@b_RetrieveInBaseCurrency = False,@vc_InventoryBasis = 'Beginning',@b_IsFinalSelect = True,@b_DeleteZeroPnLRows = True

Select	[Risk].[RiskID]
	,[#FinalResultsMtM].[Description]
	,[#FinalResultsMtM].[DlDtlID]
	,[#FinalResultsMtM].[PrdctID]
	,[#FinalResultsMtM].[LcleID]
	,[#FinalResultsMtM].[DeliveryPeriodStartDate]
	,[#FinalResultsMtM].[AccountingPeriodStartDate]
	,[#FinalResultsMtM].[InternalBAID]
	,[#FinalResultsMtM].[ExternalBAID]
	,[#FinalResultsMtM].[UserID]
	,[#FinalResultsMtM].[StrtgyID]
	,[#FinalResultsMtM].[PricedInPercentage]
	,[#FinalResultsMtM].[Position]
	,[#FinalResultsMtM].[TotalValue]
	,[#FinalResultsMtM].[MarketValue]
	,[#FinalResultsMtM].[TotalPnL]
	,[#FinalResultsMtM].[PricedPnL]
	,[#FinalResultsMtM].[FloatPnl]
	,[#FinalResultsMtM].[PricedValue]
	,[#FinalResultsMtM].[FloatValue]
	,[#FinalResultsMtM].[PricedPosition]
	,[#FinalResultsMtM].[FloatPosition]
	,[#FinalResultsMtM].[PerUnitValue]
	,[#FinalResultsMtM].[MarketPerUnitValue]
	,[#FinalResultsMtM].[DlDtlTmplteID]
	,[#FinalResultsMtM].[AggregationGroupName]
	,[#FinalResultsMtM].[CloseOfBusiness]
	,[#FinalResultsMtM].[AttachedInHouse]
	,[#FinalResultsMtM].[ChmclID]
	,[#FinalResultsMtM].[MaxPeriodStartDate]
	,[#FinalResultsMtM].[MarketValueIsMissing]
	,[#FinalResultsMtM].[DealValueIsMissing]
	,[#FinalResultsMtM].[MarketCrrncyID]
	,[#FinalResultsMtM].[MarketValueFXRate]
	,[#FinalResultsMtM].[PaymentCrrncyID]
	,[#FinalResultsMtM].[TotalValueFXRate]
	,[#FinalResultsMtM].[PricedValueFXRate]
	,[#FinalResultsMtM].[DefaultCurrencyID]
	,[#FinalResultsMtM].[SpecificGravity]
	,[#FinalResultsMtM].[Energy]
	,[#FinalResultsMtM].[DeliveryPeriodEndDate]
	,[#FinalResultsMtM].[ConversionCrrncyID]
	,[#FinalResultsMtM].[RiskAdjustmentID]
	,[#FinalResultsMtM].[ConversionDeliveryPeriodID]
	,[#FinalResultsMtM].[MarketValueFXConversionDate]
	,[#FinalResultsMtM].[DealValueFXConversionDate]
	,[{Calculated Columns}].[SourceTable]
	,SnapshotIsArchived
	,Convert(DateTime, @SnapshotInstanceDateTime) [SnapshotInstanceDateTime]
	,1540 [SnapshotID]
	,(Select	Top 1 'Y'
From	RiskDealIdentifier OtherDealSide
	inner Join Risk OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like '%inventory%'
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID) [Subselect_Dyn52]
	,[Risk].[IsInventory] [IsInventory_Dyn54]
	,[Risk].[DlDtlTmplteID] [DlDtlTmplteID_Dyn56]
	,[Risk Transfer].[SchdlngPrdID] [SchdlngPrdID_Dyn57]
	,[GC19_Dyn].[GnrlCnfgMulti] [HedgeMonth_Dyn58]
	,[GC21_Dyn].[GnrlCnfgMulti] [HedgeMonth_Dyn60]
	,[PT22_Dyn].[PTParcelNumber] [PTParcelNumber_Dyn59]
	,[PT22_Dyn].[PTReceiptDelivery] [PTReceiptDelivery_Dyn60]
	,[Risk].[InventoryAccountingPeriodStartDate] [InventoryAccountingPeriodStartDate_Dyn61]
	,[Risk Deal Detail].[DlDtlRvsnDte] [DlDtlRvsnDte_Dyn62]
	,[Risk].[TrnsctnTypID] [TrnsctnTypID_Dyn63]
	,[Risk Transfer].[PlnndTrnsfrID] [PlnndTrnsfrID_Dyn64]
	,[{Calculated Columns}].[CloseOfBusiness] [CloseOfBusiness_Dyn65]
	,[{Calculated Columns}].[Snapshot] [Snapshot_Dyn66]
	,[Risk Deal Detail].[DlDtlCrtnDte] [DlDtlCrtnDte_Dyn67]
	,[RDPR23_Dyn].[FormulaOffset] [FormulaOffset_Dyn75]
	,[Risk Deal Detail].[DlHdrStat] [DlHdrStat_Dyn71]
	,[Risk Deal Detail].[DlDtlDsplyUOM] [DlDtlDsplyUOM_Dyn72]
	,[Risk Deal Detail].[NegotiatedDate] [NegotiatedDate_Dyn73]
	,[{Calculated Columns}].[IsPrimaryCost] [IsPrimaryCost_Dyn74]
	,[RPL26_Dyn].[RPLcleIntrfceCde] [RPLcleIntrfceCde_Dyn73]
	,[GC27_Dyn].[GnrlCnfgMulti] [AccountingTreatment_Dyn74]
	,[DD18_Dyn].[DlDtlMthdTrnsprttn] [DlDtlMthdTrnsprttn_Dyn75]
	,Cast(3 AS SmallInt) [AutoGeneratedBaseUOM]
	,Cast(19 AS Int) [AutoGeneratedBaseCurrency]
INTO #temp_MTM
From	[#FinalResultsMtM] (NoLock)
	Join [#RiskResults] [{Calculated Columns}] (NoLock) On
		[{Calculated Columns}]. Idnty = #FinalResultsMtM. RiskResultsIdnty
	Join [Risk] (NoLock) On
			[{Calculated Columns}].[RiskID] = [Risk].[RiskID]
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link]. DlHdrID = [Risk Deal Detail]. DlHdrID and [Risk Deal Link]. DlDtlID = [Risk Deal Detail]. DlDtlID And	[{Calculated Columns}]. InstanceDateTime	Between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate And	[Risk Deal Detail]. SrceSystmID	= [Risk Deal Link].ExternalType
	Left Join [LeaseDealDetail] [Lease Deal Detail] (NoLock) On
			[{Calculated Columns}].[LeaseDealDetailID] = [Lease Deal Detail].[LeaseDealDetailID]
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source]. DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and [{Calculated Columns}]. InstanceDateTime	Between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
	Left Join [RiskPlannedTransfer] [Risk Transfer] (NoLock) On
		[Risk Deal Link]. PlnndTrnsfrID = [Risk Transfer]. PlnndTrnsfrID and [{Calculated Columns}]. InstanceDateTime	Between [Risk Transfer].StartDate and [Risk Transfer].EndDate and ([Risk]. ChmclID = [Risk Transfer]. ChmclChdPrdctID Or [Risk Transfer]. ChmclChdPrdctID = [Risk Transfer].ChmclParPrdctID)
	Left Join [#RiskResultsPL] [{Calculated P/L Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated P/L Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsOptions] [{Option Information Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Option Information Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsPosition] [{Calculated Position Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated Position Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsValue] [{Calculated Value Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated Value Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsSwap] [{Calculated Swap Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated Swap Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsMtI] [{Mark to Intent Columns}] (NoLock) On
			[#FinalResultsMtM].[RiskResultsMtIIdnty] = [{Mark to Intent Columns}].[Idnty]
	Left Join [#RiskMtMExposure] [{Calculated Exposure Columns}] (NoLock) On
			[{Calculated Columns}].[Idnty] = [{Calculated Exposure Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsSnapshot] [{Snapshot Information Columns}] (NoLock) On
		1 = 1
	Left Join [DealDetail] [DD18_Dyn] (NoLock) On
		[Risk Deal Detail].DealDetailID = [DD18_Dyn].DealDetailID
	Left Join [GeneralConfiguration] [GC19_Dyn] (NoLock) On
		[DD18_Dyn].DlDtlDlHdrID = [GC19_Dyn].GnrlCnfgHdrID And [DD18_Dyn].DlDtlID = [GC19_Dyn].GnrlCnfgDtlID And [GC19_Dyn].GnrlCnfgTblNme = 'DealDetail' And [GC19_Dyn].GnrlCnfgQlfr = 'HedgeMonth' And [GC19_Dyn].GnrlCnfgHdrID <> 0
	Left Join [DealHeader] [DH20_Dyn] (NoLock) On
		[Risk Deal Link].DlHdrID = [DH20_Dyn].DlHdrID and [Risk Deal Link].DealDetailID is not null
	Left Join [GeneralConfiguration] [GC21_Dyn] (NoLock) On
		[DH20_Dyn].DlHdrID = [GC21_Dyn].GnrlCnfgHdrID And [GC21_Dyn].GnrlCnfgTblNme = 'DealHeader' And [GC21_Dyn].GnrlCnfgQlfr = 'HedgeMonth' And [GC21_Dyn].GnrlCnfgHdrID <> 0
	Left Join [PlannedTransfer] [PT22_Dyn] (NoLock) On
		[Risk Deal Link].PlnndTrnsfrID = [PT22_Dyn].PlnndTrnsfrID
	Left Join [RiskDealDetailProvisionRow] [RDPR23_Dyn] (NoLock) On
		[Risk Deal Price].FirstRowFormulaDlDtlPrvsnRwID = [RDPR23_Dyn].DlDtlPrvsnRwID and @SnapshotInstanceDateTime between [RDPR23_Dyn].StartDate and [RDPR23_Dyn].EndDate
	Left Join [RiskDealDetailProvision] [RDPV24_Dyn] (NoLock) On
		[Risk Deal Price Source].DlDtlPrvsnID = [RDPV24_Dyn]. DlDtlPrvsnID and @SnapshotInstanceDateTime between [RDPV24_Dyn].StartDate and [RDPV24_Dyn].EndDate
	Left Join [RiskDealDetailProvisionRow] [RDPR25_Dyn] (NoLock) On
		[RDPV24_Dyn].FirstRowFormulaDlDtlPrvsnRwID = [RDPR25_Dyn].DlDtlPrvsnRwID and @SnapshotInstanceDateTime between [RDPR25_Dyn].StartDate and [RDPR25_Dyn].EndDate
	Left Join [RawPriceLocale] [RPL26_Dyn] (NoLock) On
		[RDPR25_Dyn].FormulaRwPrceLcleID = [RPL26_Dyn].RwPrceLcleID
	Left Join [GeneralConfiguration] [GC27_Dyn] (NoLock) On
		[DH20_Dyn].DlHdrID = [GC27_Dyn].GnrlCnfgHdrID And [GC27_Dyn].GnrlCnfgTblNme = 'DealHeader' And [GC27_Dyn].GnrlCnfgQlfr = 'AccountingTreatment' And [GC27_Dyn].GnrlCnfgHdrID <> 0




---Join Respective tables to get respective columns values and computed columns

SET NOCOUNT ON; 
IF OBJECT_ID('tempdb..#temp_MTM_Join') IS NOT NULL
    DROP TABLE #temp_MTM_Join


SELECT 
CONVERT(Varchar(20), [Description]) AS deal 
,CONVERT(Varchar(10), DlDtlID) AS deal_detail_id 
,CASE WHEN [DlHdrStat_Dyn71] = 'A' THEN 'Active'
		WHEN [DlHdrStat_Dyn71] = 'C' THEN 'Canceled' END status  
,CloseofBusiness  AS end_of_day
,CloseofBusiness  AS close_of_business
,[NegotiatedDate_Dyn73]  AS trade_date 
,[DlDtlRvsnDte_Dyn62]  AS revision_date  
,[DlDtlCrtnDte_Dyn67]  AS creation_date 
,[DeliveryPeriodStartDate]  AS delivery_period  
,[DeliveryPeriodStartDate]  AS delivery_period_group  
,HedgeMonth_Dyn60 AS hedge_month 
,[AccountingPeriodStartDate]  AS accounting_period 
, [HedgeMonth_Dyn58] AS deal_detail_hedge_month    
,(SELECT [FromDate] FROM [dbo].[SchedulingPeriod](NOLOCK) WHERE [SchdlngPrdID] = [SchdlngPrdID_Dyn57]) AS scheduling_period
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.PrdctID) AS product
,(SELECT LcleAbbrvtn FROM [dbo].[Locale](NOLOCK) Lcle WHERE Lcle.LcleID = t.LcleID) AS location
,(SELECT Abbreviation FROM [dbo].[BusinessAssociate](NOLOCK) BA WHERE BA.BAID = t.InternalBAID) AS our_company
,(SELECT Abbreviation FROM [dbo].[BusinessAssociate](NOLOCK) BA WHERE BA.BAID = t.ExternalBAID) AS their_company
,(SELECT CntctFrstNme + ' ' +CntctLstNme FROM [dbo].Users(NOLOCK) U 
	INNER JOIN Contact(NOLOCK) C ON U.UserCntctID = C.CntCtID 
	WHERE U.UserID = t.UserID) AS trader
,(SELECT [Name] FROM [dbo].[StrategyHeader](NOLOCK) SH WHERE SH.StrtgyID = t.StrtgyID) AS strategy
,[AggregationGroupName] AS portfolio_position_group
,Convert(Varchar(20), (Round(PricedInPercentage*100,2))) + '%' AS priced_percentage
,Position AS position
,[TotalValue] AS total_value
,(SELECT UOMAbbv FROM UnitOfMeasure(NOLOCK) UOM WHERE UOM.UOM = t.DlDtlDsplyUOM_Dyn72) AS uom
,[MarketValue] AS market_value
,[TotalPnL] AS profit_loss
,[PricedPnL] AS priced_profit_loss
,[FloatPnl] AS float_profit_loss
,[PricedValue] AS priced_value
,[FloatValue] AS float_value
,[PricedPosition] AS priced_position
,[FloatPosition] AS float_position
,[PerUnitValue] AS per_unit_value
,[MarketPerUnitValue] AS market_per_unit_value
,(SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID) AS detail_template
,CASE WHEN [AttachedInHouse] = 'N' THEN 'No'
	ELSE 'Yes' END AS attached_inhouse
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.PrdctID) AS chemical
,CASE WHEN [MarketValueIsMissing] = 0 THEN 'No'
		ELSE 'Yes' END AS missing_market_value
,CASE WHEN [DealValueIsMissing] = 0 THEN 'No'
		ELSE 'Yes' END AS missing_deal_value
, CONVERT(DECIMAL(10,2),[MarketValueFXRate])  AS market_fx_rate
,CONVERT(DECIMAL(10,2),[TotalValueFXRate]) AS total_value_fx_rate
,CONVERT(DECIMAL(10,2),[PricedValueFXRate]) AS priced_value_fx_rate
,(SELECT [CrrncySmbl] FROM [dbo].[Currency](NOLOCK) Curr WHERE Curr.[CrrncyID] = t.[MarketCrrncyID]) AS market_currency
,(SELECT [CrrncySmbl] FROM [dbo].[Currency](NOLOCK) Curr WHERE Curr.[CrrncyID] = t.[PaymentCrrncyID]) AS payment_currency
,(SELECT [CrrncySmbl] FROM [dbo].[Currency](NOLOCK) Curr WHERE Curr.[CrrncyID] = t.DefaultCurrencyID) AS base_currency
,CASE WHEN t.SourceTable = 'P' THEN 'Planned Transfer'
	WHEN t.SourceTable = 'A' THEN 'Accounting Transaction'
	WHEN t.SourceTable = 'I' THEN 'Inventory Change'
	WHEN t.SourceTable = 'X' THEN 'Movement Transaction'
	WHEN t.SourceTable = 'O' THEN 'Obligation'
	WHEN t.SourceTable = 'E' THEN 'External Transaction'
	WHEN t.SourceTable = 'S' THEN 'Actual Balance'
	WHEN t.SourceTable = 'N' THEN 'NA'
	WHEN t.SourceTable = 'B' THEN 'Estimated Balance'
	WHEN t.SourceTable = 'L' THEN 'Planned Expense'
	WHEN t.SourceTable = 'T' THEN 'Time Based Estimated Transaction'
	WHEN t.SourceTable = 'S' THEN 'Actual Balance'
	WHEN t.SourceTable = 'EP' THEN 'External Estimated Movement'
	WHEN t.SourceTable = 'EX' THEN 'External Movement'
	WHEN t.SourceTable = 'EA' THEN 'External Actual'
	WHEN t.SourceTable = 'EIP' THEN 'External Estimated Inventory Change'
	WHEN t.SourceTable = 'EIX' THEN 'External Actual Inventory Change'
	WHEN t.SourceTable = 'H' THEN 'Hedging Detail'
	END source
,CASE WHEN [IsInventory_Dyn54] = 1 THEN 'Yes' 
		ELSE 'No' END inventory
,(SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT1 WHERE DDT1.[DlDtlTmplteID] = T.[DlDtlTmplteID_Dyn56]) AS deal_detail_template 
,t.[PTReceiptDelivery_Dyn60] AS receipt_delivery
,CAST(CASE WHEN t.[PTParcelNumber_Dyn59] = '' THEN NULL ELSE t.[PTParcelNumber_Dyn59] END AS DECIMAL(10,2)) AS parcel_no
,t.[AccountingTreatment_Dyn74] AS accounting_treatment
,(SELECT [TrnsctnTypDesc] FROM [dbo].[TransactionType](NOLOCK) TTY WHERE TTY.[TrnsctnTypID] = t.[TrnsctnTypID_Dyn63]) AS transaction_type
,(SELECT [DynLstBxAbbv] 
	FROM [DynamicListBox](NOLOCK) DLB WHERE T.DlDtlMthdTrnsprttn_Dyn75 = DLB.DynLstBxTyp 
		AND DynLstBxQlfr = 'TransportationMethod' ) AS method_of_transportation
, t.[RPLcleIntrfceCde_Dyn73] AS interface_code
,CONVERT(VARCHAR(10), t.[PlnndTrnsfrID_Dyn64]) AS transfer_id 
,CONVERT(VARCHAR(10),t.[Snapshot_Dyn66]) AS snapshot_id
,CONVERT(VARCHAR(10), t.[RiskID]) AS risk_id
,t.[FormulaOffset_Dyn75] AS offset
,CASE WHEN t.[IsPrimaryCost_Dyn74] = 1 THEN 'Yes'
	ELSE 'No' END calc_is_primary_cost
,Iif(t.[PTParcelNumber_Dyn59] Is Null Or t.[PTParcelNumber_Dyn59] = '(Empty)' Or t.[PTParcelNumber_Dyn59] = '', 
	Iif(CONVERT(VARCHAR(10),t.[HedgeMonth_Dyn58], 101) Is Null Or CONVERT(VARCHAR(10),t.[HedgeMonth_Dyn58], 101) = '(Empty)' Or CONVERT(VARCHAR(10),t.[HedgeMonth_Dyn58], 101) = '', 
		Iif(CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61], 101) Is Null Or CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61], 101) = '(Empty)' Or CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61], 101) = '', 
		Iif(CONVERT(VARCHAR(10),HedgeMonth_Dyn60, 101) Is Null Or CONVERT(VARCHAR(10),HedgeMonth_Dyn60, 101) = '(Empty)' Or CONVERT(VARCHAR(10),HedgeMonth_Dyn60, 101) = '', CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61], 101), CONVERT(VARCHAR(10),HedgeMonth_Dyn60, 101)), 
		CONVERT(VARCHAR(10),[InventoryAccountingPeriodStartDate_Dyn61],101)) 
	,CONVERT(VARCHAR(10),t.[HedgeMonth_Dyn58], 101))
, t.[PTParcelNumber_Dyn59])
AS calc_program_month
,CAST(DATEPART(MM,[DeliveryPeriodStartDate]) AS VARCHAR(10))+'/1/'+CAST(DATEPART(YYYY,[DeliveryPeriodStartDate]) AS VARCHAR(10)) AS calc_delivery_month
,Iif([AttachedInHouse] = 'N' And [IsInventory_Dyn54] = '1', 'True', 'False') AS calc_is_inventory
,(
Select	Top 1 'Y'
From	RiskDealIdentifier(NOLOCK) AS OtherDealSide
	inner Join Risk(NOLOCK) AS OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like '%inventory%'
Where	t.DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = (SELECT DlHdrID FROM DealHeader(NOLOCK) WHERE DlHdrIntrnlNbr = t.[Description])
) AS calc_involves_inventory_book
,'' AS [InventoryBuySaleBuildDraw]
,'' AS [RiskCategory]
,Iif((SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID) Like '%Fut%' 
	Or (SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID) Like '%EFP Paper%', 'Future', 
		Iif((SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID) Like '%Swap%', 'Swap', 'Error'))
AS calc_future_swap
INTO #temp_MTM_Join
FROM #temp_MTM t



---Final load into temp tables with calculated columns

SET NOCOUNT ON; 
IF OBJECT_ID('tempdb..#temp_MTM_Final') IS NOT NULL
    DROP TABLE #temp_MTM_Final

SELECT 
deal
,deal_detail_id
,status
,end_of_day
,close_of_business
,trade_date
,revision_date
,creation_date
,delivery_period
,delivery_period_group
,hedge_month
,accounting_period
,deal_detail_hedge_month
,scheduling_period
,product
,location
,our_company
,their_company
,trader
,strategy
,portfolio_position_group
,priced_percentage
,position
,total_value
,uom
,market_value
,profit_loss
,priced_profit_loss
,float_profit_loss
,priced_value
,float_value
,priced_position
,float_position
,per_unit_value
,market_per_unit_value
,detail_template
,attached_inhouse
,chemical
,missing_market_value
,missing_deal_value
,market_fx_rate
,total_value_fx_rate
,priced_value_fx_rate
,market_currency
,payment_currency
,base_currency
,source
,inventory
,deal_detail_template
,receipt_delivery
,parcel_no
,accounting_treatment
,transaction_type
,method_of_transportation
,interface_code
,transfer_id
,snapshot_id
,risk_id
,offset
,calc_is_primary_cost
,calc_program_month
,calc_delivery_month
,calc_is_inventory
,calc_involves_inventory_book
,Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory'
  , Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', Iif(attached_inhouse = 'Y' And receipt_delivery = 'D', 'Buy-Internal'
    , Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', Iif(deal_detail_template In ('Inhouse Delivery'), 'Sale-Internal'
       , Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party'
           ,Iif(receipt_delivery = 'R' And inventory = 'True', 'Draw', Iif(receipt_delivery = 'D' And inventory = 'True', 'Build'
		     , Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt', 'Future Detail'), 'Paper', 'UNKNOWN')))))))))
AS
calc_inventory_buy_sale_build_draw
,[RiskCategory]
,calc_future_swap
INTO #temp_MTM_Final
FROM #temp_MTM_Join(NOLOCK)

---Insert Data into Custom Tables



SET NOCOUNT ON;
SET ansi_warnings OFF;

INSERT INTO [db_datareader].[MTVTempMarkToMarket] with (tablockx)
(
[deal]
      ,[deal_detail_id]
      ,[status]
      ,[end_of_day]
      ,[close_of_business]
      ,[trade_date]
      ,[revision_date]
      ,[creation_date]
      ,[delivery_period]
      ,[delivery_period_group]
      ,[hedge_month]
      ,[accounting_period]
      ,[deal_detail_hedge_month]
      ,[scheduling_period]
      ,[product]
      ,[location]
      ,[our_company]
      ,[their_company]
      ,[trader]
      ,[strategy]
      ,[portfolio_position_group]
      ,[priced_percentage]
      ,[position]
      ,[total_value]
      ,[uom]
      ,[market_value]
      ,[profit_loss]
      ,[priced_profit_loss]
      ,[float_profit_loss]
      ,[priced_value]
      ,[float_value]
      ,[priced_position]
      ,[float_position]
      ,[per_unit_value]
      ,[market_per_unit_value]
      ,[detail_template]
      ,[attached_inhouse]
      ,[chemical]
      ,[missing_market_value]
      ,[missing_deal_value]
      ,[market_fx_rate]
      ,[total_value_fx_rate]
      ,[priced_value_fx_rate]
      ,[market_currency]
      ,[payment_currency]
      ,[base_currency]
      ,[source]
      ,[inventory]
      ,[deal_detail_template]
      ,[receipt_delivery]
      ,[parcel_no]
      ,[accounting_treatment]
      ,[transaction_type]
      ,[method_of_transportation]
      ,[interface_code]
      ,[transfer_id]
      ,[snapshot_id]
      ,[risk_id]
      ,[offset]
      ,[calc_is_primary_cost]
      ,[calc_program_month]
      ,[calc_delivery_month]
      ,[calc_is_inventory]
      ,[calc_involves_inventory_book]
      ,[calc_inventory_buy_sale_build_draw]
      ,[RiskCategory]
      ,[calc_future_swap]

)
SELECT 
deal
,deal_detail_id
,status
,end_of_day
,close_of_business
,trade_date
,revision_date
,creation_date
,delivery_period
,delivery_period_group
,hedge_month
,accounting_period
,deal_detail_hedge_month
,scheduling_period
,product
,location
,our_company
,REPLACE(their_company, ',', '') AS their_company
,trader
,strategy
,portfolio_position_group
,priced_percentage
,position
,total_value
,uom
,market_value
,profit_loss
,priced_profit_loss
,float_profit_loss
,priced_value
,float_value
,priced_position
,float_position
,per_unit_value
,market_per_unit_value
,CONVERT(VARCHAR(50), detail_template) AS detail_template
,attached_inhouse
,chemical
,missing_market_value
,missing_deal_value
,market_fx_rate
,total_value_fx_rate
,priced_value_fx_rate
,market_currency
,payment_currency
,base_currency
,source
,inventory
,CONVERT(VARCHAR(50),deal_detail_template) AS deal_detail_template
,receipt_delivery
,parcel_no
,accounting_treatment
,transaction_type
,method_of_transportation
,interface_code
,transfer_id
,snapshot_id
,risk_id
,offset
,calc_is_primary_cost
,calc_program_month
,calc_delivery_month
,calc_is_inventory
,calc_involves_inventory_book
,Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory'
  , Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', Iif(attached_inhouse = 'Y' And receipt_delivery = 'D', 'Buy-Internal'
    , Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', Iif(deal_detail_template In ('Inhouse Delivery'), 'Sale-Internal'
       , Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party'
           ,Iif(receipt_delivery = 'R' And inventory = 'True', 'Draw', Iif(receipt_delivery = 'D' And inventory = 'True', 'Build'
		     , Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt', 'Future Detail'), 'Paper', 'UNKNOWN')))))))))
AS
calc_inventory_buy_sale_build_draw
, Iif(calc_inventory_buy_sale_build_draw In ('Inventory', 'Build', 'Draw'), '1-Beg Inv', '') 
	+ Iif(calc_inventory_buy_sale_build_draw In ('Sale-Internal'), '3-Demand', '') + Iif(calc_inventory_buy_sale_build_draw In ('3rd Party'), '4-3rd Party', '') 
	+ Iif(calc_inventory_buy_sale_build_draw In ('Paper'), '5-Paper', '') + Iif(calc_inventory_buy_sale_build_draw In ('Buy-Internal'), '2-Supply', '') 
	+ Iif(deal = 'MOA17TP0003', '3-Demand', '') 
AS calc_risk_category
,calc_future_swap
FROM #temp_MTM_Final(NOLOCK)

END

END

END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[MTV_GetTempMarkToMarket]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_GetTempMarkToMarket.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_GetTempMarkToMarket >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_GetTempMarkToMarket >>>'
	  END

