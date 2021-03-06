
/****** Object:  StoredProcedure [dbo].[MTV_Credit_Interface_Extract]    Script Date: 11/23/2016 1:06:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_Credit_Interface_Extract]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Credit_Interface_Extract] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Credit_Interface_Extract >>>'
	  END
GO

-- =======================================================================================================================================
-- Author:		Craig Albright	
-- Create date: 02/08/2016
-- Description:	This report is roughly the same as the MtM report but has additional columns required by the credit interface
-- =======================================================================================================================================
ALTER PROCEDURE [dbo].[MTV_Credit_Interface_Extract] 


	-- Add the parameters for the stored procedure here
	@RiskReportCriteriaRetrievalOption VarChar(8000),
	@PositionGroupID VarChar(8000),
	@InternalBa VarChar (8000),
	@RiskReportInventoryRetrievalOption VarChar (8000),
	@BegInvSourceTable Char,
	@ExposureType Char,
	@LookbackMonths int
AS
BEGIN

IF 1=0 BEGIN
    SET FMTONLY OFF
END
IF OBJECT_ID('tempdb..#RiskResults') IS NOT NULL
    DROP TABLE #RiskResults
IF OBJECT_ID('tempdb..#RiskResultsOptions') IS NOT NULL
    DROP TABLE #RiskResultsOptions
IF OBJECT_ID('tempdb..#RiskResultsMtI') IS NOT NULL
    DROP TABLE #RiskResultsMtI
IF OBJECT_ID('tempdb..#RiskResultsPL') IS NOT NULL
    DROP TABLE #RiskResultsPL
IF OBJECT_ID('tempdb..#RiskResultsSnapshot') IS NOT NULL
    DROP TABLE #RiskResultsSnapshot
IF OBJECT_ID('tempdb..#RiskResultsSwap') IS NOT NULL
    DROP TABLE #RiskResultsSwap
IF OBJECT_ID('tempdb..#RiskResultsValue') IS NOT NULL
    DROP TABLE #RiskResultsValue
IF OBJECT_ID('tempdb..#RiskResultsPosition') IS NOT NULL
    DROP TABLE #RiskResultsPosition
IF OBJECT_ID('tempdb..#RiskMtMExposure') IS NOT NULL
    DROP TABLE #RiskMtMExposure
IF OBJECT_ID('tempdb..#FinalResultsMtM') IS NOT NULL
    DROP TABLE #FinalResultsMtM
IF OBJECT_ID('tempdb..#Contact') IS NOT NULL
    DROP TABLE #Contact
IF OBJECT_ID('tempdb..#ClassOfTrade') IS NOT NULL
	DROP TABLE #ClassOfTrade
IF OBJECT_ID('tempdb..#ArapTable') IS NOT NULL
	DROP TABLE #ArapTable
IF OBJECT_ID('tempdb..#RawPriceHeader') IS NOT NULL
    DROP TABLE #RawPriceHeader
IF OBJECT_ID('tempdb..#RawPriceLocaleT') IS NOT NULL
    DROP TABLE #RawPriceLocaleT

Declare
	 @SnapshotId Int = (select Top 1 (P_EODSnpShtID) 
                from Snapshot (nolock) join VETradePeriod (nolock) Vtp on Vtp.VETradePeriodID = StartedFromVETradePeriodID 
                Group By P_EODSnpShtID, StartedFromVETradePeriodID, InstanceDateTime,EndOfDay,vtp.StartDate, vtp.EndDate 
                order by P_EODSnpShtID desc),
		@StartingVeTradePeriodId SmallInt = (select Top 1 VETradePeriodID from VETradePeriod (nolock) where DateAdd(Month,@LookbackMonths*-1,GetDate())
		 between StartDate and EndDate and Type = 'M'),
		@SnapshotInstanceDateTime SmallDateTime = (select Top 1 InstanceDateTime 
                from Snapshot  (nolock) join VETradePeriod (nolock) Vtp on Vtp.VETradePeriodID = StartedFromVETradePeriodID 
                Group By P_EODSnpShtID, StartedFromVETradePeriodID, InstanceDateTime,EndOfDay,vtp.StartDate, vtp.EndDate 
                order by P_EODSnpShtID desc),
		@SnapshotEndOfDay SmallDateTime = (select Top 1 EndOfDay
                from Snapshot (nolock) join VETradePeriod (nolock) Vtp on Vtp.VETradePeriodID = StartedFromVETradePeriodID 
                Group By P_EODSnpShtID, StartedFromVETradePeriodID, InstanceDateTime,EndOfDay,vtp.StartDate, vtp.EndDate 
                order by P_EODSnpShtID desc),
		@TradePeriodStartDate SmallDateTime = (select Top 1 StartDate  from VETradePeriod (nolock) where DATEADD(Month,@LookbackMonths*-1,GetDate()) 
		between StartDate and EndDate and Type = 'M'),

		@MaxTradePeriodEndDate SmallDateTime = '2076-05-31 23:59:00',
		@InventoryTradePeriodStart SmallDateTime = (select Top 1 StartDate  from VETradePeriod  (nolock) 
		where DATEADD(Month,@LookbackMonths*-1,GetDate()) between StartDate and EndDate and Type = 'M'),
		@InventoryTradePeriodEnd SmallDateTime = (select Top 1 EndDate from VETradePeriod (nolock) 
		where DATEADD(Month,@LookbackMonths*-1,GetDate()) between StartDate and EndDate and Type = 'M'),
		@TradePeriod int = (select Top 1 VETradePeriodID from VETradePeriod (nolock) 
		where DATEADD(Month,@LookbackMonths*-1,GetDate()) between StartDate and EndDate and Type = 'M')

Create Table #Contact(
CntctID int primary key not null,
CntctFrstNme varchar(20) null,
CntctLstNme varchar(20) null
)

insert #Contact
(CntctID,CntctFrstNme,CntctLstNme)
Select CntctID,CntctFrstNme,CntctLstNme from Contact (nolock)

Create Nonclustered index contactindex on #Contact (CntctID)
include (CntctFrstNme,CntctLstNme)

Create Table #ClassOfTrade(
BAID int,
BANme varchar(500),
BAAbbrvtn varchar(500),
SoldTo varchar(20),
ClassOfTrade varchar(80),
DynLstBxDesc varchar(8000)
)
insert #ClassOfTrade
(BAID,BANme,BAAbbrvtn,SoldTo,ClassOfTrade,DynLstBxDesc)
select distinct BA.BAID, BA.BANme, BA.BAAbbrvtn, BAST.SoldTo, BAST.ClassOfTrade, dlb.DynLstBxDesc
as ClassOfTradeDesc
from BusinessAssociate  (nolock) BA inner join MTVSAPBASoldTo (nolock) BAST on BA.BAID = BAST.BAID
join dynamiclistbox (nolock) dlb on dlb.dynlstbxqlfr = 'BASoldToClassOfTrade' and dlb.dynlstbxtyp = BAST.ClassOfTrade
order by BA.BAAbbrvtn, BAST.ClassOfTrade

create nonclustered index cotindex on #ClassOfTrade (BAID)
include (ClassOfTrade,SoldTo)

Create Table #ArapTable (
ID int,
CIIMssgQID int,
InvoiceNumber varchar(20),
ARAPStaged bit,
ARAPExtracted bit
)
insert #ArapTable (ID, CIIMssgQID, InvoiceNumber, ARAPStaged, ARAPExtracted)
SELECT        ID, CIIMssgQID, InvoiceNumber, ARAPStaged, ARAPExtracted
FROM            MTVInvoiceInterfaceStatus (nolock)

create table #RawPriceHeader
(
RawPriceHeaderID int,
RawPriceHeaderDesc varchar(80)
)

create table #RawPriceLocaleT
(
RawPriceLocaleID int,
RawPriceHeaderID int,
CurveName varchar(250),
ParentProductID int,
ChildProductID int,
LocaleID int
)

insert #RawPriceHeader
(
RawPriceHeaderID,
RawPriceHeaderDesc
)
Select rph.RPHdrID,
rph.RPHdrDesc
from RawPriceHeader rph

insert #RawPriceLocaleT
(
RawPriceLocaleID,
RawPriceHeaderID,
CurveName,
ParentProductID,
ChildProductID,
LocaleID
)
Select rpl.RwPrceLcleID,
rpl.RPLcleRPHdrID,
rpl.CurveName,
rpl.RPLcleChmclParPrdctID,
rpl.RPLcleChmclChdPrdctID,
rpl.RPLcleLcleID
From RawPriceLocale rpl


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
And	( IsNull(Risk.DlDtlTmplteId, 0) Not In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103)
Or Not (IsNull(Risk.DlDtlTmplteID, 0) In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103) 
And Risk.SourceTable = 'A'And Risk.AccountingPeriodStartDate < @TradePeriodStartDate
))
And	[Risk].[CostSourceTable] <> 'ML'
And	 (IsNull(Risk. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or Risk.SourceTable In ('EIX','EIP') )
And	1 = Case When Risk.SourceTable = 'P' And Risk.DeliveryPeriodEndDate Between @TradePeriodStartDate and @MaxTradePeriodEndDate
 Then 1 
 When IsNull(Risk. InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate)	Between @TradePeriodStartDate and @MaxTradePeriodEndDate
 Then 1 Else 0 End
And	((
(Risk. AccountingPeriodStartDate Between @TradePeriodStartDate and @MaxTradePeriodEndDate Or Risk.AccountingPeriodEndDate 
Between @TradePeriodStartDate and @MaxTradePeriodEndDate )
And ( Risk. AccountingPeriodStartDate >= @TradePeriodStartDate )
)
)
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
And	( Risk. AccountingPeriodStartDate Between @TradePeriodStartDate and @MaxTradePeriodEndDate Or Risk. AccountingPeriodEndDate Between @TradePeriodStartDate and @MaxTradePeriodEndDate)
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
	))

-- Select * From #RiskResults

execute dbo.SRA_Risk_Report_MtM_UpdateTempTables @c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@sdt_StartingAccountingPeriodStartDate = @TradePeriodStartDate,@vc_AdditionalColumns = '{Calculated Swap Columns}.BuyIsFixed,{Calculated Columns}.Snapshot,Risk Transfer.DlDtlID,{Calculated Columns}.CloseOfBusiness,Risk.DlDtlTmplteID,Risk.TrnsctnTypID,Risk Deal Price.InHouseStrtgyID,Risk Deal Price.CostType,{Calculated Swap Columns}.Product,RiskDealDetail.DealHeader.GeneralConfiguration.HedgeMonth,RiskDealDetail.DealHeader.GeneralConfiguration.PhysXRef,Risk.Product.CmmdtyID,Risk Deal Detail.DlDtlDsplyDte,RiskDealDetail.DealDetail.DealDetailTemplate.IsPhysical,RiskDealDetail.DealDetail.GeneralConfiguration.Asset,{Calculated Swap Columns}.SellIsFixed,Risk Transfer.SchdlngPrdID,Risk.AccountingPeriodStartDate,Risk Deal Detail.DealDetail.PlannedTransfer.TransactionHeader.MovementDocument.TransactionHeader.MovementDate[Min]',@b_IncludeWhatIfScenarios = False,@i_TradePeriodFromID = 506,@vc_InternalBAID = '',@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_IsThisNavigation = 'N',@i_id = 1,@vc_type = 'PositionGroup',@i_P_EODSnpShtID = 24,@b_discountpositions = False,@c_disaggregatepositions = False,@b_UseMtI = False,@b_RetrieveInBaseCurrency = False,@vc_InventoryBasis = 'Beginning',@b_DeleteZeroPnLRows = True

execute dbo.SRA_Risk_Report_MtM_UpdateTempTables @c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@sdt_StartingAccountingPeriodStartDate = @TradePeriodStartDate,@vc_AdditionalColumns = '{Calculated Swap Columns}.BuyIsFixed,{Calculated Columns}.Snapshot,Risk Transfer.DlDtlID,{Calculated Columns}.CloseOfBusiness,Risk.DlDtlTmplteID,Risk.TrnsctnTypID,Risk Deal Price.InHouseStrtgyID,Risk Deal Price.CostType,{Calculated Swap Columns}.Product,RiskDealDetail.DealHeader.GeneralConfiguration.HedgeMonth,RiskDealDetail.DealHeader.GeneralConfiguration.PhysXRef,Risk.Product.CmmdtyID,Risk Deal Detail.DlDtlDsplyDte,RiskDealDetail.DealDetail.DealDetailTemplate.IsPhysical,RiskDealDetail.DealDetail.GeneralConfiguration.Asset,{Calculated Swap Columns}.SellIsFixed,Risk Transfer.SchdlngPrdID,Risk.AccountingPeriodStartDate,Risk Deal Detail.DealDetail.PlannedTransfer.TransactionHeader.MovementDocument.TransactionHeader.MovementDate[Min]',@b_IncludeWhatIfScenarios = False,@i_TradePeriodFromID = 506,@vc_InternalBAID = '',@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_IsThisNavigation = 'N',@i_id = 1,@vc_type = 'PositionGroup',@i_P_EODSnpShtID = 24,@b_discountpositions = False,@c_disaggregatepositions = False,@b_UseMtI = False,@b_RetrieveInBaseCurrency = False,@vc_InventoryBasis = 'Beginning',@b_IsFinalSelect = True,@b_DeleteZeroPnLRows = True

Begin
With StagingRecords (
AccountingPeriodStartDate
,AggregationGroupName
,Agreement
,AgreementType
,AttachedInHouse
,BaseUOM
,BestAvailableQuantity
,BuySell
,ChargeType
,ChmclID
,ClassOfTrade
,CloseOfBusiness
,CommDeal
,ConversionCrrncyID
,ConversionDeliveryPeriodID
,ConversionFactor
,CreationDate
,CurFxRate
,CustomStatus
,DealCurrency
,DealDetailId
,DealHeaderId
,DealNotionalValue
,DealValueFXConversionDate
,DealValueIsMissing
,DefaultCurrency
,DeliveryPeriod
,DeliveryPeriodEndDate
,DeliveryPeriodStartDate
,Description
,DlDtlPrvsnID
,DlDtlPrvsnRwID
,DlDtlPrvsnRwID2
,DlDtlPrvsnRwID3
,DlDtlTmplteID
,DlvyProductA
,Ele
,Energy
,EstimatedMovementDate
,EstPmtDate
,ExposureType
,ExternalBAID
,FlatPriceOrBasis
,FloatPnl
,FwdAmountA
,FloatPosition
,Ile
,InitialDealVolume
,InitSysPrice
,InitSysVolume
,InternalBAID
,InvoiceNumber
,LocaleID
,MarketCurrency
,MarketPerUnitValue
,MarketValue
,MarketValueFXConversionDate
,MarketValueIsMissing
,MaxPeriodStartDate
,MethodofTransportation
,MovementStatus
,PaymentCurrency
,Portfolio
,Position
,PriceDescription
,PricedInPercentage
,PricedInPerUnitValue
,PricedPnL
,PriceProductA
,PriceType
,PricingSeq
,Product
,ProductID
,Provision
,RD
,RiskAdjustmentID
,RiskID
,RiskPriceIdentifierID
,SalesInvoiceNumber
,SentToMSAP
,SettledAmountA
,SettledVolumeA
,SnapshotID
,SnapshotInstanceDateTime
,SnapshotIsArchived
,SoldTo
,SourceSystem
,SourceTable
,SpecificGravity
,StrategyID
,TemplateName
,TimeBasedDlDtlPrvsnRwID
,TmplteSrceTpe
,TotalPnL
,TotalQuantity
,TotalValueFXRate
,Trader
,TradeTag
,TradeType
--,TransDate
,UserID
,VolumeUOM
) as
(
Select 
	[#FinalResultsMtM].[AccountingPeriodStartDate]
	,[#FinalResultsMtM].[AggregationGroupName]	
	,(select (ma.InternalNumber) from  MasterAgreement ma where ma.MasterAgreementId = dh.MasterAgreement) as Agreement
	,(Select CASE WHEN (select m.MasterAgreementType from MasterAgreement m where m.MasterAgreementId = dh.MasterAgreement) IS NULL then 'GT&C' 
	ELSE (select m.MasterAgreementType from MasterAgreement m where m.MasterAgreementId = dh.MasterAgreement)END) AgreementType
	,[#FinalResultsMtM].[AttachedInHouse]
	,(select UOMAbbv from UnitOfMeasure where UOM = 3) as BaseUOM
	,[Risk Transfer].BestAvailableQuantity
	,(select CASE when dd.DlDtlSpplyDmnd = 'D' THEN 'SELL' When dd.DlDtlSpplyDmnd = 'R' THEN 'BUY' END) as BuySell
	,(select description from DealType where DlTypID = dh.DlHdrTyp) as ChargeType
	,[#FinalResultsMtM].[ChmclID]
	,(select top 1 (ClassOfTrade) from [#ClassOfTrade] where [#ClassOfTrade].BAID = #FinalResultsMtM.ExternalBAID) ClassOfTrade
	,ISNULL([#FinalResultsMtM].[CloseOfBusiness], @SnapshotEndOfDay) CloseOfBusiness
	,(select concat((select name from commodity where cmmdtyID = 
	(select cmmdtyID from Product where prdctid = [#FinalResultsMtM].[PrdctID])), ' ',(select description from DealType where DlTypID = dh.DlHdrTyp))) as CommDeal
	,[#FinalResultsMtM].[ConversionCrrncyID]
	,[#FinalResultsMtM].[ConversionDeliveryPeriodID]
	,[#FinalResultsMtM].[MarketValueFXRate] as ConversionFactor
	,(select dh.DlHdrDsplyDte from dealheader dh where DlHdrIntrnlNbr = [#FinalResultsMtM].Description) as CreationDate
	,[#FinalResultsMtM].[MarketValueFXRate] as CurFxRate
	,[Risk Transfer].Status as CustomStatus
	,(select CrrncySmbl from Currency where CrrncyID = 19) as DealCurrency
	,[#FinalResultsMtM].[DlDtlID] as DealDetailID
	,dh.DlHdrID DealHeaderID
	,[#FinalResultsMtM].[TotalValue] as DealNotionalValue
	,[#FinalResultsMtM].[DealValueFXConversionDate]
	,[#FinalResultsMtM].[DealValueIsMissing]
	,(select CrrncySmbl from Currency where CrrncyID = [#FinalResultsMtM].[DefaultCurrencyID]) DefaultCurrency
	,(select min (name) from VETradePeriod where StartDate = Case when (DatePart(Day,[#FinalResultsMtM].[DeliveryPeriodStartDate]))>1 
	then DATEADD(DAY, -DATEPART(DAY, [#FinalResultsMtM].[DeliveryPeriodStartDate]) + 1, [#FinalResultsMtM].[DeliveryPeriodStartDate]) 
	else [#FinalResultsMtM].[DeliveryPeriodStartDate] end) as DeliveryPeriod
	,[#FinalResultsMtM].[DeliveryPeriodEndDate]
	,[#FinalResultsMtM].[DeliveryPeriodStartDate]
	,[#FinalResultsMtM].[Description] --dlhdrintrnlnbr
	,[Risk Deal Price Source].[DlDtlPrvsnID] DlDtlPrvsnID
	,[{Option Information Columns}].[DlDtlPrvsnRwID] 
	,[{Option Information Columns}].[DlDtlPrvsnRwID2] 
	,[{Option Information Columns}].[DlDtlPrvsnRwID3] 
	,[#FinalResultsMtM].[DlDtlTmplteID]
	,(Concat('Market - ', PrdctAbbv,' @ ', (select LcleAbbrvtn from Locale where LcleID = dd.DlDtlLcleID))) as DlvyProductA 
	,extba.BANme as Ele
	,[#FinalResultsMtM].[Energy]
	,ISNULL(ISNULL((select min(ir.MovementDate) from Risk r (NoLock)
			join RiskSourceValue rsv (NoLock) on r.RiskID = rsv.RiskID 
			 Join BestAvailableVolume bav (NoLock) on rsv.P_EODBAVID = bav.P_EODBAVID 
			 Join InventoryReconcile (nolock) ir on ir.InvntryRcncleID = bav.InvntryRcncleID
			Where Risk.SourceTable in ('x', 'a') -- only Risk records that are movement based or in Accounting
			And  Risk.CostSourceTable in ('X', 'D') -- only Risk records where cost is Actual Movement or Estimate
		)
	,(select min(th.movementdate) from TransactionHeader th where th.DealChmclParPrdctID = dd.DlDtlPrdctID and th.DestinationLcleID = dd.DestinationLcleID
	and th.XHdrPlnndTrnsfrID = [Risk Transfer].PlnndTrnsfrID and th.DealDetailID = dd.DealDetailID)),[Risk Transfer].EstimatedMovementDate)  EstimatedMovementDate
	,riskres.EstimatedPaymentDate as EstimatedPaymentDate
	,@ExposureType as ExposureType
	,[#FinalResultsMtM].[ExternalBAID]
	,(select case when (select top 1 (rpl.IsBasisCurve) from RawPriceLocale rpl  (nolock) where rpl.CurveName = CurveName) = 0 then 'FlatPrice' else 'Basis' END) FlatPriceOrBasis
	,[#FinalResultsMtM].[FloatPnl]
	,[#FinalResultsMtM].[FloatValue] as FwdAmountA
	,[#FinalResultsMtM].[FloatPosition]
	,intba.BANme Ile
	,[Risk Deal Detail].DlDtlQntty as InitialDealVolume	
	,Cast(19 AS Int) [InitSysPrice]
	,Cast(3 AS SmallInt) [InitSysVolume]
	,[#FinalResultsMtM].[InternalBAID]
	,''	as InvoiceNumber
	,[#FinalResultsMtM].[LcleID] as LocaleID
	,(select CrrncySmbl from Currency (nolock) where CrrncyID =  [#FinalResultsMtM].[MarketCrrncyID]) MarketCurrency
	,[#FinalResultsMtM].[MarketPerUnitValue]
	,[#FinalResultsMtM].[MarketValue]
	,[#FinalResultsMtM].[MarketValueFXConversionDate]
	,[#FinalResultsMtM].[MarketValueIsMissing]
	,[#FinalResultsMtM].[MaxPeriodStartDate]
	,dd.DlDtlMthdTrnsprttn as [MethodOfTransportation]
	,[Risk Transfer].Status MovementStatus
	,(select CrrncySmbl from Currency  (nolock) where CrrncyID = [#FinalResultsMtM].[PaymentCrrncyID]) PaymentCurrency
	,'Corporate Area Rollup' as Portfolio 
	,[#FinalResultsMtM].[Position] 
	,[Risk Deal Price Source].[Description] PriceDescription
	,[#FinalResultsMtM].[PricedInPercentage]
	,riskres.[PricedInPerUnitValue] 
	,[#FinalResultsMtM].[PricedPnL]
	,ISNULL((select curvename from rawpricelocale (nolock) where rwprcelcleid = 
	(select RwPrceLcleID from RiskCurve where RiskCurveID  = [{Calculated Exposure Columns}].FlatExposureRiskCurveID)),
	(select CurveName from RawPriceLocale where RawPriceLocale.RwPrceLcleID = 
		(select top 1(ddp.MarketRwPrceLcleID) from DealDetailProvision ddp join DealDetailProvisionRow ddpr on ddp.DlDtlPrvsnID = ddpr.DlDtlPrvsnID 
		and ddpr.DlDtlPRvsnRwTpe = 'F' where ddp.DlDtlPrvsnDlDtlDlHdrID = dh.DlHdrID and ddp.DlDtlPrvsnDlDtlID = dd.DlDtlID and ddp.DlDtlPrvsnSqnce = 1 ))) as PriceProductA
	,(case when (select top 1 p.PrvsnNme from prvsn p where p.prvsnid = (select top 1 (ddp.DlDtlPrvsnPrvsnID) from DealDetailProvision ddp where ddp.DlDtlPrvsnDlDtlDlHdrID = dh.dlhdrid 
	and ddp.DlDtlPrvsnDlDtlID = dd.DlDtlID)) = 'FixedPrice' then 'Fixed' Else 'Formula' END) as PriceType
	,1 as PricingSeq
	,p.PrdctAbbv Product
	,p.PrdctID as ProductID
	,Case when [Risk Deal Price Source].[DlDtlPrvsnID] is not null then	
		(select top 1 (prvsn.PrvsnNme) from prvsn (nolock) where PrvsnID = [Risk Deal Price Source].[DlDtlPrvsnID]) 
			else (select top 1 (prvsn.PrvsnNme) from prvsn (nolock) where PrvsnID = 
			(select top 1 (dldtlprvsnprvsnid) from dealdetailprovision ddp (nolock) 
			where (ddp.DlDtlPrvsnID = DlDtlPrvsnID and ddp.DlDtlPrvsnDlDtlID = [#FinalResultsMtM].DlDtlID 
			and ddp.DlDtlPrvsnDlDtlDlHdrID = [Risk Deal Detail].DlHdrID ))) end Provision
	,dd.DlDtlSpplyDmnd as RD
	,[#FinalResultsMtM].RiskAdjustmentID
	,[Risk].[RiskID]
	,[Risk Deal Price Source].[RiskPriceIdentifierID] 
	,''	as SalesInvoiceNumber
	,0 as SentToMSAP
	,[#FinalResultsMtM].[PricedValue] as SettledAmountA
	,[#FinalResultsMtM].[PricedPosition] as SettledVolumeA
	,@SnapshotId [SnapshotID]
	,Convert(DateTime, @SnapshotInstanceDateTime) [SnapshotInstanceDateTime]
	,SnapshotIsArchived
	,(select Max(SoldTo) 
	from #ClassOfTrade 
	where #ClassOfTrade.BAID = [#FinalResultsMtM].[ExternalBAID]
	) SoldTo
	,'RightAngle' as SourceSystem
	,riskres.[SourceTable]
	,[#FinalResultsMtM].[SpecificGravity]
	,[#FinalResultsMtM].[StrtgyID] as StrategyID
	,(select description from DealHeaderTemplate dht (nolock) where dht.DlHdrTmplteID = dh.DlHdrTmplteID) TemplateName
	,[Risk Deal Price Source].[TimeBasedDlDtlPrvsnRwID] TimeBasedDlDtlPrvsnRwID
	,[Risk Deal Price Source].[TmplteSrceTpe]
	,[#FinalResultsMtM].[TotalPnL]
	,[Risk Transfer].PlnndTrnsfrTtlQty TotalQuantity
	,[#FinalResultsMtM].[TotalValueFXRate]
	,(select Concat(CntctFrstNme,' ',CntctLstNme) from #Contact where #Contact.CntctID =(select users.UserCntctID from Users where Users.UserID = dh.DlHdrIntrnlUserID)) as Trader
	,(select name from strategyheader where StrtgyID = [Risk Transfer].StrtgyID) as TradeTag
	--,TRY_Convert(DateTime,dh.DlHdrCrtnDte) as TransDate
	,(select description from DealType where DlTypID = dh.DlHdrTyp) TradeType
	,[#FinalResultsMtM].[UserID]
	,(select UOMAbbv from UnitOfMeasure where UOM = dd.DlDtlDsplyUOM) as VolumeUOM
	FROM 
	[#FinalResultsMtM] (NoLock)
	Join [#RiskResults] riskres (NoLock) On
		riskres. Idnty = #FinalResultsMtM. RiskResultsIdnty
	Join [Risk] (NoLock) On
			riskres.[RiskID] = [Risk].[RiskID]
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link]. DlHdrID = [Risk Deal Detail]. DlHdrID and [Risk Deal Link]. DlDtlID = [Risk Deal Detail]. DlDtlID And	riskres.InstanceDateTime	
		Between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate And	[Risk Deal Detail]. SrceSystmID	= [Risk Deal Link].ExternalType
	Left Join [LeaseDealDetail] [Lease Deal Detail] (NoLock) On
			riskres.[LeaseDealDetailID] = [Lease Deal Detail].[LeaseDealDetailID]
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Source]. DlDtlPrvsnID = [Risk Deal Price]. DlDtlPrvsnID and riskres. InstanceDateTime	Between [Risk Deal Price].StartDate and [Risk Deal Price].EndDate
	Left Join [RiskPlannedTransfer] [Risk Transfer] (NoLock) On
		[Risk Deal Link]. PlnndTrnsfrID = [Risk Transfer]. PlnndTrnsfrID and riskres.InstanceDateTime	Between [Risk Transfer].StartDate and [Risk Transfer].EndDate 
		and ([Risk]. ChmclID = [Risk Transfer]. ChmclChdPrdctID Or [Risk Transfer]. ChmclChdPrdctID = [Risk Transfer].ChmclParPrdctID)
	Left Join [#RiskResultsPL] [{Calculated P/L Columns}] (NoLock) On
			riskres.[Idnty] = [{Calculated P/L Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsOptions] [{Option Information Columns}] (NoLock) On
			riskres.[Idnty] = [{Option Information Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsPosition] [{Calculated Position Columns}] (NoLock) On
			riskres.[Idnty] = [{Calculated Position Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsValue] [{Calculated Value Columns}] (NoLock) On
			riskres.[Idnty] = [{Calculated Value Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsSwap] [{Calculated Swap Columns}] (NoLock) On
			riskres.[Idnty] = [{Calculated Swap Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsMtI] [{Mark to Intent Columns}] (NoLock) On
			[#FinalResultsMtM].[RiskResultsMtIIdnty] = [{Mark to Intent Columns}].[Idnty]
	Left Join [#RiskMtMExposure] [{Calculated Exposure Columns}] (NoLock) On
			riskres.[Idnty] = [{Calculated Exposure Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsSnapshot] [{Snapshot Information Columns}] (NoLock) On
		1 = 1
		Left Join [BusinessAssociate] intba on intba.BAID = [#FinalResultsMtM].[InternalBAID]
		Left Join [BusinessAssociate] extba on extba.BAID = [#FinalResultsMtM].[ExternalBAID]
		LEft join dealheader dh on dh.DlHdrID = [Risk Deal Detail].DlHdrID
		left join dealdetail dd on dd.DlDtlDlHdrID = [Risk Deal Detail].DlHdrID and dd.DlDtlID = [Risk Deal Detail].DlDtlID
	Left Join [Product] p (NoLock) On
		[Risk].ChmclID = p.PrdctID
	Left Join [DealDetailTemplate] [DDT23_Dyn] (NoLock) On
		dd.DlDtlTmplteID = [DDT23_Dyn].DlDtlTmplteID
)

insert into MTVCreditInterfaceStaging(

AccountingPeriodStartDate
,AggregationGroupName
,Agreement
,AgreementType
,AttachedInHouse
,BaseUOM
,BestAvailableQuantity
,BuySell
,ChargeType
,ChmclID
,ClassOfTrade
,CloseOfBusiness
,CommDeal
,ConversionCrrncyID
,ConversionDeliveryPeriodID
,ConversionFactor
,CreationDate
,CurFxRate
,CustomStatus
,DealCurrency
,DealDetailId
,DealHeaderId
,DealNotionalValue
,DealValueFXConversionDate
,DealValueIsMissing
,DefaultCurrency
,DeliveryPeriod
,DeliveryPeriodEndDate
,DeliveryPeriodStartDate
,Description
,DlDtlPrvsnID
,DlDtlPrvsnRwID
,DlDtlPrvsnRwID2
,DlDtlPrvsnRwID3
,DlDtlTmplteID
,DlvyProductA
,Ele
,Energy
,EstimatedMovementDate
,EstPmtDate
,ExposureType
,ExternalBAID
,FlatPriceOrBasis
,FloatPnl
,FwdAmountA
,FloatPosition
,Ile
,InitialDealVolume
,InitSysPrice
,InitSysVolume
,InternalBAID
,InvoiceNumber
,LocaleID
,MarketCurrency
,MarketPerUnitValue
,MarketValue
,MarketValueFXConversionDate
,MarketValueIsMissing
,MaxPeriodStartDate
,MethodofTransportation
,MovementStatus
,PaymentCurrency
,Portfolio
,Position
,PriceDescription
,PricedInPercentage
,PricedInPerUnitValue
,PricedPnL
,PriceProductA
,PriceType
,PricingSeq
,Product
,ProductID
,Provision
,RD
,RiskAdjustmentID
,RiskID
,RiskPriceIdentifierID
,SalesInvoiceNumber
,SentToMSAP
,SettledAmountA
,SettledVolumeA
,SnapshotID
,SnapshotInstanceDateTime
,SnapshotIsArchived
,SoldTo
,SourceSystem
,SourceTable
,SpecificGravity
,StrategyID
,TemplateName
,TimeBasedDlDtlPrvsnRwID
,TmplteSrceTpe
,TotalPnL
,TotalQuantity
,TotalValueFXRate
,Trader
,TradeTag
,TradeType
--,TransDate
,UserID
,VolumeUOM
)
select Distinct
AccountingPeriodStartDate
,AggregationGroupName
,Agreement
,AgreementType
,AttachedInHouse
,BaseUOM
,BestAvailableQuantity
,BuySell
,ChargeType
,ChmclID
,ClassOfTrade
,CloseOfBusiness
,CommDeal
,ConversionCrrncyID
,ConversionDeliveryPeriodID
,ConversionFactor
,CreationDate
,CurFxRate
,CustomStatus
,DealCurrency
,DealDetailId
,DealHeaderId
,DealNotionalValue
,DealValueFXConversionDate
,DealValueIsMissing
,DefaultCurrency
,DeliveryPeriod
,DeliveryPeriodEndDate
,DeliveryPeriodStartDate
,Description
,DlDtlPrvsnID
,DlDtlPrvsnRwID
,DlDtlPrvsnRwID2
,DlDtlPrvsnRwID3
,DlDtlTmplteID
,DlvyProductA
,Ele
,Energy
,EstimatedMovementDate
,EstPmtDate
,ExposureType
,ExternalBAID
,FlatPriceOrBasis
,FloatPnl
,FwdAmountA
,FloatPosition
,Ile
,InitialDealVolume
,InitSysPrice
,InitSysVolume
,InternalBAID
,InvoiceNumber
,LocaleID
,MarketCurrency
,MarketPerUnitValue
,MarketValue
,MarketValueFXConversionDate
,MarketValueIsMissing
,MaxPeriodStartDate
,MethodofTransportation
,MovementStatus
,PaymentCurrency
,Portfolio
,Position
,PriceDescription
,PricedInPercentage
,PricedInPerUnitValue
,PricedPnL
,PriceProductA
,PriceType
,PricingSeq
,Product
,ProductID
,Provision
,RD
,RiskAdjustmentID
,RiskID
,RiskPriceIdentifierID
,SalesInvoiceNumber
,SentToMSAP
,SettledAmountA
,SettledVolumeA
,SnapshotID
,SnapshotInstanceDateTime
,SnapshotIsArchived
,SoldTo
,SourceSystem
,SourceTable
,SpecificGravity
,StrategyID
,TemplateName
,TimeBasedDlDtlPrvsnRwID
,TmplteSrceTpe
,TotalPnL
,TotalQuantity
,TotalValueFXRate
,Trader
,TradeTag
,TradeType
--,TransDate
,UserID
,VolumeUOM
 from StagingRecords

End
--ToDo get invoice number and slsinvoicenumber

Begin
Update MTVCreditInterfaceStaging  set InvoiceNumber = 
(
select MAX(ph.InvoiceNumber) from 
PayableHeader ph
join AccountDetail 
ad on ad.AcctDtlPrchseInvceHdrID = ph.PybleHdrID 
where ad.AcctDtlDlDtlDlHdrID = 
(select dlhdrid from dealheader where 
DlHdrIntrnlNbr = MTVCreditInterfaceStaging.Description)
)

End

Begin
Update MTVCreditInterfaceStaging  set SalesInvoiceNumber = 
(
select MAX(sh.SlsInvceHdrNmbr) from 
SalesInvoiceHeader sh
join AccountDetail 
ad on ad.AcctDtlSlsInvceHdrID = sh.SlsInvceHdrID
where ad.AcctDtlDlDtlDlHdrID = 
(select dlhdrid from dealheader where 
DlHdrIntrnlNbr = MTVCreditInterfaceStaging.Description)
)

End

Begin
Update MTVCreditInterfaceStaging  set SoldTo = 
(
Select MIN(mba.SoldTo)
from MTVSAPBASoldTo mba 
left Join GeneralConfiguration gc on gc.GnrlCnfgQlfr = 'SAPSoldTo' and mba.ID = gc.GnrlCnfgMulti
WHERE Gc.GnrlCnfgHdrID = (select dlhdrid from dealheader where 
DlHdrIntrnlNbr = MTVCreditInterfaceStaging.Description)
and GnrlCnfgHdrID > 0
)

END

BEGIN
Update MTVCreditInterfaceStaging  set SoldTo = 
(
Select MIN(mba.VendorNumber)
from MTVSAPBASoldTo mba 
where mba.BAID = MTVCreditInterfaceStaging.ExternalBAID 
)
WHERE  MTVCreditInterfaceStaging.SoldTo is null or LTRIM(RTRIM(MTVCreditInterfaceStaging.SoldTo)) = ''
END

Begin
Update MTVCreditInterfaceStaging  set SentToMSAP = (
select top 1 (a.ARAPExtracted) from #ArapTable a 
where a.InvoiceNumber = MTVCreditInterfaceStaging.InvoiceNumber )
End

Begin
Update MTVCreditInterfaceStaging  set SentToMSAP = (
select a.ARAPExtracted from #ArapTable a 
where a.InvoiceNumber = MTVCreditInterfaceStaging.SalesInvoiceNumber
)
End

Begin
Update MTVCreditInterfaceStaging set DlvyProductA = (
select curvename from #RawPriceLocaleT rpl
join #RawPriceHeader rph on rpl.RawPriceHeaderID = rph.RawPriceHeaderID
where rph.RawPriceHeaderDesc like '%Market Prices%' and MTVCreditInterfaceStaging.LocaleID = rpl.LocaleID 
and MTVCreditInterfaceStaging.ProductID = rpl.ParentProductID
)
End
Begin
Update MTVCreditInterfaceStaging set EstPmtDate =
(select #RiskResults.AccountingPeriodEndDate from #RiskResults where #RiskResults.RiskID = MTVCreditInterfaceStaging.RiskID)
where EstPmtDate is null
End

End