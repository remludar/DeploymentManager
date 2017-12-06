/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_GetTempRiskExposure WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_GetTempRiskExposure]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_GetTempRiskExposure.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetTempRiskExposure]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_GetTempRiskExposure] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_GetTempRiskExposure >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTV_GetTempRiskExposure]
	
-- =============================================
-- Author:		Amar Kenguva
-- Create date: 09/27/2018
-- Description:	Load latest snapshot Risk Exposure Report data into Custom Table [db_datareader].[MTVTempRiskExposure]
-- =============================================

AS
BEGIN
	
IF NOT EXISTS (SELECT TOP 1 1 FROM Snapshot(NOLOCK)
WHERE NightlySnapshot = 'Y' AND IsValid = 'N' AND Purged = 'N')
BEGIN


SET NOCOUNT ON; 
	
DECLARE @i_P_EODSnpShtID Int,@SnapshotId Int, @StartedFromVETradePeriodID Int,@SnapshotInstanceDateTime SmallDateTime,@CompareSnapshotInstanceDateTime SmallDateTime,@SnapshotEndOfDay SmallDateTime
,@CompareSnapshotEndOfDay SmallDateTime,@CompareWithAnotherSnapshot Bit,@ComparisonSnapshotId Int,@1DayInstanceDateTime SmallDateTime,@5DayInstanceDateTime SmallDateTime,@WklyInstanceDateTime SmallDateTime,@MtDInstanceDateTime SmallDateTime
,@QtDInstanceDateTime SmallDateTime,@YtDInstanceDateTime SmallDateTime,@RiskReportCriteriaRetrievalOption VarChar (8000),@PositionGroupId VarChar (8000),@ProductLocationChemicalId VarChar (8000),@PortfolioId VarChar (8000),@StrategyId VarChar (8000),@InternalBa VarChar (8000)
,@StartingVeTradePeriodId SmallInt,@NumberOfPeriods VarChar (8000),@AggregateRecordsOutsideOfDateRange Bit,@AppendWhatIfScenarios Bit,@WhatIfScenarioId Int,@RiskReportInventoryRetrievalOption VarChar (8000)
,@TradePeriodStartDate SmallDateTime,@MaxTradePeriodStartDate SmallDateTime,@MaxTradePeriodEndDate SmallDateTime,@EndOfTimePeriodStartDate SmallDateTime,@EndOfTimePeriodEndDate SmallDateTime
,@InventoryTradePeriodStart SmallDateTime,@InventoryTradePeriodEnd SmallDateTime,@BegInvSourceTable Char,@RetrievalOptions Int,@35@RiskDealDetail@DlDtlIntrnlUserID Int,@36@Risk@StrtgyID int



--Get Latest successful snapshot ID

SELECT @i_P_EODSnpShtID='-1',@CompareWithAnotherSnapshot='False',@ComparisonSnapshotId='-2',@1DayInstanceDateTime='1990-01-01 00:00:00'
,@WklyInstanceDateTime='1990-01-01 00:00:00',@MtDInstanceDateTime='1990-01-01 00:00:00',@QtDInstanceDateTime='1990-01-01 00:00:00'
,@YtDInstanceDateTime='1990-01-01 00:00:00',@RiskReportCriteriaRetrievalOption='P',@PositionGroupId= NULL 
,@ProductLocationChemicalId= NULL ,@PortfolioId='53',@StrategyId= NULL ,@InternalBa='20',@StartingVeTradePeriodId='0'
,@NumberOfPeriods='-1',@AggregateRecordsOutsideOfDateRange='False',@AppendWhatIfScenarios='False',@WhatIfScenarioId= NULL 
,@RiskReportInventoryRetrievalOption='I',@MaxTradePeriodStartDate='2076-05-01 00:00:00',@MaxTradePeriodEndDate='2076-05-31 23:59:00'
,@EndOfTimePeriodStartDate='2050-12-01 00:00:00',@EndOfTimePeriodEndDate='2050-12-01 23:59:00', @BegInvSourceTable='S',@RetrievalOptions='265',@35@RiskDealDetail@DlDtlIntrnlUserID= NULL ,@36@Risk@StrtgyID= NULL--'23,25,26,27,20,18,17,16'



SELECT @SnapshotId =  P_EODSnpShtID ,@SnapshotInstanceDateTime = InstanceDateTime, @StartedFromVETradePeriodID = StartedFromVETradePeriodID
,@CompareSnapshotInstanceDateTime = InstanceDateTime, @SnapshotEndOfDay = EndOfDay, @CompareSnapshotEndOfDay = EndOfDay
,@5DayInstanceDateTime=InstanceDateTime,
@TradePeriodStartDate = (SELECT [StartDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
,@InventoryTradePeriodStart = (SELECT [StartDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
,@InventoryTradePeriodEnd = (SELECT [EndDate] FROM [dbo].[VETradePeriod](NOLOCK) WHERE [VETradePeriodID] = StartedFromVETradePeriodID)
FROM Snapshot(NOLOCK)
WHERE P_EODSnpShtID = (SELECT max(P_EODSnpShtID) FROM Snapshot(NOLOCK)
WHERE NightlySnapshot = 'Y' AND IsValid = 'Y' AND Purged = 'N')


IF NOT EXISTS(SELECT TOP 1 1 FROM [db_datareader].[MTVTempRiskExposure]
WHERE snapshot_id = @SnapshotId AND end_of_day = @SnapshotEndOfDay)

BEGIN

IF EXISTS(SELECT TOP 1 1 FROM [db_datareader].[MTVTempRiskExposure])
	TRUNCATE TABLE [db_datareader].[MTVTempRiskExposure]


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

Create Table #RiskExposureResults
(
	Idnty 		Int identity  Not Null,
	RiskExposureTableIdnty 		Int Null,
	ExposureID 		Int Null,
	RiskSourceID 		Int Null,
	DlHdrID 		Int Null,
	DlDtlID 		Int Null,
	DlDtlPrvsnID 		Int Null,
	DlDtlPrvsnRwID 		Int Null,
	FormulaEvaluationID 		Int Null,
	SourceTable 		VarChar(3) COLLATE DATABASE_DEFAULT  Null,
	SourceID 		Int Null default 0,
	DlDtlTmplteID 		Int Null,
	RiskType 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	StrtgyID 		Int Null,
	PrdctID 		Int Null,
	ChmclID 		Int Null,
	LcleID 		Int Null,
	IsPrimaryCost 		Bit Not Null default 0,
	IsQuotational 		Bit Not Null default 0,
	IsInventory 		Bit Not Null default 0,
	RiskCurveID 		Int Null,
	PrceTpeIdnty 		SmallInt Null,
	RwPrceLcleID 		Int Null,
	VETradePeriodID 		SmallInt Null,
	CurveServiceID 		Int Null,
	CurveProductID 		Int Null,
	CurveChemProductID 		Int Null,
	CurveLcleID 		Int Null,
	IsBasisCurve 		Bit Not Null default 0,
	CurveLevel 		TinyInt Null,
	PeriodStartDate 		SmallDateTime Null,
	PeriodEndDate 		SmallDateTime Null,
	ExposureStartDate 		SmallDateTime Null,
	ExposureQuoteStartDate 		SmallDateTime Null,
	ExposureQuoteEndDate 		SmallDateTime Null,
	NumberOfQuotesForPeriod 		Int Null,
	Position 		Decimal(38,15) Null default 0.0,
	OriginalPhysicalPosition 		Decimal(38,15) Not Null default 0.0,
	SpecificGravity 		Float Null default 0.0,
	Energy 		Float Null default 0.0,
	PricedInPercentage 		Float Null default 1.0,
	Percentage 		Decimal(38,15) Null default 0.0,
	TotalPercentage 		Float Null default 1.0,
	QuotePercentage 		Float Null,
	IsDailyPricingRow 		Bit Not Null default 0,
	EndOfDay 		SmallDateTime Null,
	DiscountFactor 		Float Null default 1.0,
	DiscountFactorID 		Int Null,
	EstimatedPaymentDate 		SmallDateTime Null,
	EstimatedPaymentDateIsMissing 		Char(1) COLLATE DATABASE_DEFAULT  Null default 'N',
	CrrncyID 		Int Null,
	DuplicateAsQuotational 		Bit Not Null default 0,
	Argument 		VarChar(1000) COLLATE DATABASE_DEFAULT  Null,
	LeaseDealDetailID 		Int Null,
	AttachedInHouse 		Char COLLATE DATABASE_DEFAULT  Null default 'N',
	PricingPeriodCategoryVETradePeriodID 		Int Null,
	CurveRiskType 		VarChar(255) COLLATE DATABASE_DEFAULT  Null,
	PeriodName 		VarChar(255) COLLATE DATABASE_DEFAULT  Null,
	PeriodAbbv 		VarChar(255) COLLATE DATABASE_DEFAULT  Null,
	RelatedInventoryChangeId 		Int Null,
	PlnndTrnsfrID 		Int Null,
	PrimaryPlnndTrnsfrID 		Int Null,
	SrceSystmID 		Int Null,
	Weight 		Float Not Null default 0.0,
	IsCashSettledFuture 		Bit Not Null default 0,
	ValueID 		Int Null,
	ReferenceDate 		SmallDateTime Null,
	LogicalVETradePeriodID 		Int Null,
	InternalBAID 		Int Null,
	RiskID 		Int Null,
	Snapshot 		Int Null,
	SnapshotAccountingPeriod 		SmallDateTime Null,
	SnapshotTradePeriod 		SmallDateTime Null,
	InstanceDateTime 		SmallDateTime Null,
	RiskDealDetailOptionOTCId 		Int Null,
	RelatedDealNumber 		VarChar(200) COLLATE DATABASE_DEFAULT  Null,
	MoveExternalDealID 		Int Null,
	CurveStructureDescription 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null
)

Create Clustered Index IE_RiskExposureResultsRiskID On #RiskExposureResults (RiskID)

Create Unique Index IE_RiskExposureResultsIdnty On #RiskExposureResults (Idnty)

Create Table #RiskExposureResultsOptions
(
	RiskID 		Int Not Null,
	RiskExposureTableIdnty 		Int Not Null,
	RiskResultsTableIdnty 		Int Null,
	RwPrceLcleID 		Int Null,
	IsOTC 		Bit Not Null default 0,
	RiskDealDetailOptionOTCID 		Int Null,
	RiskDealDetailOptionID 		Int Not Null,
	DlHdrID 		Int Not Null,
	DlDtlID 		Int Not Null,
	RowNumber 		Int Null,
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
	BuySell 		VarChar(4) COLLATE DATABASE_DEFAULT  Null,
	DlDtlPrvsnRwID 		Int Null,
	Delta 		Float Not Null default 1.0,
	Gamma 		Float Not Null default 0.0,
	Theta 		Float Not Null default 0.0,
	Rho 		Float Not Null default 0.0,
	Volatility 		Float Not Null default 0.0,
	Weight 		Float Not Null default 1.0,
	Vega 		Float Not Null default 0.0,
	BarrierPrice 		Float Null,
	KnockOutStatus 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	BarrierType 		VarChar(8) COLLATE DATABASE_DEFAULT  Null,
	PayOut 		Float Null,
	OptionRiskID 		Int Null
)

Create NonClustered Index RiskIndex on #RiskExposureResultsOptions (RiskID, RiskExposureTableIdnty)

Create Table #RiskExposureResultsHedge
(
	RiskResultsTableIdnty 		Int Not Null,
	RiskID 		Int Not Null,
	HedgeDlHdrID 		Int Null,
	HedgeSrceSystmID 		Int Null,
	HedgeContract 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	HedgeDetail 		Int Null,
	HedgingDlHdrID 		Int Null,
	HedgingSrceSystmID 		Int Null,
	HedgingContract 		VarChar(100) COLLATE DATABASE_DEFAULT  Null,
	HedgingDetail 		Int Null,
	HedgingFromDate 		SmallDateTime Null,
	HedgingToDate 		SmallDateTime Null,
	HedgingPercentage 		Float Null,
	HedgePosition 		Float Null default 0.0,
	HedgeGroup 		VarChar(50) COLLATE DATABASE_DEFAULT  Null
)

Create NonClustered Index RiskIndex on #RiskExposureResultsHedge (RiskID)

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

Create Table #RiskExposureFinalResults
(
	RiskID 		Int Null,
	RiskExposureResultsIdnty 		Int Null,
	Description 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null,
	DlDtlID 		Int Null,
	RiskType 		Char(1) COLLATE DATABASE_DEFAULT  Null,
	PeriodStartDate 		SmallDateTime Null,
	PeriodEndDate 		SmallDateTime Null,
	PeriodGroupStartDate 		SmallDateTime Null,
	PeriodGroupEndDate 		SmallDateTime Null,
	Position 		Float Null,
	StrtgyID 		Int Null,
	PricedInPercentage 		Float Null,
	PortfolioOrPositionGroup 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null,
	ExposureQuoteDate 		SmallDateTime Null,
	PrdctID 		Int Null,
	ChmclID 		Int Null,
	LcleID 		Int Null,
	CurveStructureDescription 		VarChar(8000) COLLATE DATABASE_DEFAULT  Null,
	RelatedDealNumber 		VarChar(4000) COLLATE DATABASE_DEFAULT  Null
)

Create Clustered Index ID_#RiskExposureFinalResults_RiskID on #RiskExposureFinalResults (RiskID)

Create NonClustered Index IE_#RiskExposureFinalResults_RiskExposureResultsIdnty on #RiskExposureFinalResults (RiskExposureResultsIdnty)

-- Physicals

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	 (IsNull([Risk]. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or [Risk].SourceTable In ('EIX','EIP') )
And	[Risk].[IsVolumeOnly] = 1
And	[Risk].SourceTable In ('X', 'P', 'O', 'E', 'EP', 'EX', 'T','I','EIX','EIP')
And	

                        ( -- Show Os for Futures. OTCs need to show Ts for each leg

	                    [Risk].SourceTable			<> 'O'

                    Or	[Risk].DlDtlTmplteID			Not In (23100,23101,23102,23103,23000,23100,23101,23102,23103)

	                    )

                    And	(  -- Show Os for ETOs

	                    [Risk]. SourceTable			<> 'T'

                    Or	[Risk].DlDtlTmplteID			in (23100,23101,23102,23103,23000,23100,23101,23102,23103) 

	                    )

                    And	(

	                    [Risk]. DeliveryPeriodEndDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

                    Or	[Risk]. DeliveryPeriodStartDate	Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	                    )

                    And	Not ( -- Show Quotation T for Asian ETOs

		                    [Risk].DlDtlTmplteID			in (21000,35000,310000) 

                    And	Exists		( 

				                    Select 1

				                    From	dbo.[RiskDealDetailOption]	(NoLock)

				                    Where	[RiskDealDetailOption]. DlHdrID	= [Risk Deal Link]. DlHdrID

				                    And	[RiskDealDetailOption]. DlDtlID	= [Risk Deal Link]. DlDtlID

				                    And	@SnapshotInstanceDateTime		Between	[RiskDealDetailOption]. StartDate and [RiskDealDetailOption]. EndDate

				                    And	[RiskDealDetailOption]. Flavor	= 'O'

				                    )

	                        )
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- Physical Inhouse

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	 (IsNull([Risk]. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or [Risk].SourceTable In ('EIX','EIP') )
And	[Risk].[IsVolumeOnly] = 0
And	[Risk].RiskPriceIdentifierID		Is Not Null

                    And	(

	                    IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

                    Or	[Risk].IsPrimaryCost			= 0

	                    )

                    And	(

	                    [Risk]. DeliveryPeriodEndDate		Between @TradePeriodStartDate And  Convert(SmallDateTime, '2076-05-31 23:59:00')

                    Or	[Risk]. DeliveryPeriodStartDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	                    )
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- PPA

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	 (IsNull([Risk]. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or [Risk].SourceTable In ('EIX','EIP') )
And	[Risk].[IsVolumeOnly] = 1
And	[Risk].SourceTable In ('X', 'P', 'E', 'EP', 'EX', 'T','I','EIX','EIP')
And	(

	                    [Risk]. DeliveryPeriodEndDate								< @TradePeriodStartDate

                    And	IsNull([Risk].InventoryAccountingPeriodStartDate, [Risk].AccountingPeriodStartDate)	>= @TradePeriodStartDate

	                )
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- PPA InHouse Rules

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	 (IsNull([Risk]. DlDtlTmplteID, 0) NOT IN (9080, 9090) Or [Risk].SourceTable In ('EIX','EIP') )
And	[Risk].[IsVolumeOnly] = 0
And	[Risk].RiskPriceIdentifierID		Is Not Null

                    And	(

	                    IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

                    Or	[Risk].IsPrimaryCost			= 0

	                    )

                    And	(

	                    [Risk]. DeliveryPeriodEndDate		< @TradePeriodStartDate

                    And	IsNull([Risk]. InventoryAccountingPeriodStartDate, [Risk]. AccountingPeriodStartDate)		>= @TradePeriodStartDate

	                    )
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- Balances

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,Max([Risk Physical Exposure].[RiskPhysicalExposureID]) [RiskExposureTableIdnty]
	,Convert(Int, Null) [FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,[Risk Curve].[RiskCurveID]
	,[Risk Curve].[RwPrceLcleID]
	,[Risk Curve].[VETradePeriodID]
	,[Risk Curve].[PrceTpeIdnty]
	,Case 	When	Risk. SourceTable			In( @BegInvSourceTable, 'I', 'EIX', 'EIP')

        And	Risk. IsInventory			= 1

        Then	'I'	-- Inventory

        When	Coalesce([Risk].InventoryAccountingPeriodStartDate, [Risk].DeliveryPeriodEndDate)		< @TradePeriodStartDate

        And     [Risk]. AccountingPeriodStartDate		>= @TradePeriodStartDate

        Then	'A'	--Prior Period 'A'djustment

        Else	'P'	-- Physical

    End [RiskType]
	,Convert(Bit, 0) [IsQuotational]
	,Null [DlDtlPrvsnID]
	,Null [DlDtlPrvsnRwID]
	,Sum([Risk Physical Exposure].[Percentage]) [Percentage]
	,Sum([Risk Physical Exposure].[Percentage]) [PricedPercentage]
	,Sum([Risk Physical Exposure].[Percentage]) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,IsNull([Risk Physical Exposure].QuoteDate, @SnapshotEndOfDay) [ExposureStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteStartDate]
	,Convert(SmallDateTime, Null) [ExposureQuoteEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[Risk].RiskID = [Risk Physical Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Physical Exposure].StartDate and [Risk Physical Exposure].EndDate
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
		[Risk Curve].RiskCurveID = [Risk Physical Exposure].RiskCurveID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		1 = 2
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	IsNull([Risk Physical Exposure].Percentage, 1.0) <> 0.0
And	[Risk].[IsVolumeOnly] = 1
And	Risk.SourceTable In('S','EB')
And	[Risk].[IsInventory] = 1
And	[Risk]. DeliveryPeriodStartDate	Between @InventoryTradePeriodStart And @InventoryTradePeriodEnd
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Risk Curve].[RiskCurveID], [Risk Curve].[RwPrceLcleID], [Risk Curve].[VETradePeriodID], [Risk Curve].[PrceTpeIdnty], Coalesce(Risk.InventoryAccountingPeriodStartDate, Risk. DeliveryPeriodEndDate), [Risk].[AccountingPeriodStartDate], [Risk Physical Exposure].[QuoteDate])

-- Non Options Quotational

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,[Risk Quotational Exposure].[RiskQuotationalExposureID] [RiskExposureTableIdnty]
	,[Risk Quotational Exposure].[FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,Convert(Int, Null) [RiskCurveID]
	,[Price Curve].[RwPrceLcleID]
	,[Formula Evaluation Percentage].[VETradePeriodID]
	,[Risk Deal Price Row Formula].[FormulaPrceTpeIdnty]
	,Case 	When 	[Risk].SourceTable 			= 'A' 

		And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

		And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	<> 'ED'

		Then 	'H' -- Inhouse

		Else	'Q' -- Quotational

	End [RiskType]
	,Convert(Bit, 1) [IsQuotational]
	,[Risk Deal Price Row Formula].[DlDtlPrvsnID]
	,[Risk Quotational Exposure].[DlDtlPrvsnRwID]
	,[Formula Evaluation Percentage].[PricedInPercentage]
	,[Formula Evaluation Percentage].PricedInPercentage * [Risk Quotational Exposure].FormulaPercentage [PricedInPercentage]
	,[Formula Evaluation Percentage].TotalPercentage * [Risk Quotational Exposure].FormulaPercentage [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,Convert(SmallDateTime, Null) [ExposureStartDate]
	,[Formula Evaluation Percentage].[QuoteRangeBeginDate]
	,[Formula Evaluation Percentage].[QuoteRangeEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskQuotationalExposure] [Risk Quotational Exposure] (NoLock) On
		[Risk].RiskID = [Risk Quotational Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Quotational Exposure].StartDate and [Risk Quotational Exposure].EndDate
	Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		[Risk Deal Price Row Formula].DlDtlPrvsnRwID = [Risk Quotational Exposure].DlDtlPrvsnRwID and @SnapshotInstanceDateTime between [Risk Deal Price Row Formula].StartDate and [Risk Deal Price Row Formula].EndDate
	Join [FormulaEvaluationPercentage] [Formula Evaluation Percentage] (NoLock) On
		[Formula Evaluation Percentage].FormulaEvaluationID = [Risk Quotational Exposure].FormulaEvaluationID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Delivery Period].VETradePeriodID = [Formula Evaluation Percentage].VETradePeriodID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Deal Price Row Formula].FormulaRwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	[Formula Evaluation Percentage]. TotalPercentage		<> 0.0
And	[Risk Quotational Exposure]. PercentageOfProvision		<> 0.0
And	 @SnapshotEndOfDay Between [Formula Evaluation Percentage]. EndOfDayStartDate And [Formula Evaluation Percentage].EndOfDayEndDate
And	(

	[Risk]. DlDtlTmplteID			Not In (21000,35000,310000) -- ETOs

Or	( -- Show Quotation T for Asian ETOs so we can show daily exposure

		[Risk].DlDtlTmplteID			In (21000,35000,310000) 

	and	Exists		( 

				Select 1

				From	dbo.[RiskDealDetailOption] RDDO	(NoLock)

				Where	RDDO. DlHdrID	= [Risk Deal Link]. DlHdrID

				and	RDDO. DlDtlID	= [Risk Deal Link]. DlDtlID

				And	@SnapshotInstanceDateTime		Between	RDDO.StartDate and RDDO.EndDate

				and	RDDO. Flavor	= 'O'

				)

	)

	Or	( -- Show Quotational for spreads

		[Risk].DlDtlTmplteID			In (21000,35000,310000) 

	and	Exists		( 

				Select 1

				From	dbo.[RiskDealDetailProvision] RDDP (NoLock)

				Where	RDDP.DlDtlPrvsnID		= [Risk Deal Price Row Formula]. DlDtlPrvsnID

				And	@SnapshotInstanceDateTime		Between RDDP.StartDate and RDDP.EndDate

				And	RDDP. DlDtlPrvsnPrvsnID	= 90

				)

	))
And	

        (

	        [Risk].DlDtlTmplteID NOT IN (9080, 9090)

        OR	[Risk].SourceTable IN ('EIX', 'EIP')

	        )

        
And	(

	IsNull([Risk Deal Price Source].TmplteSrceTpe, 'XX')	Not Like 'D%'

Or	[Risk].SourceTable			= 'A'

	)

And	(

	(

	[Risk]. DeliveryPeriodStartDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

Or	[Risk]. DeliveryPeriodEndDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	)

Or	(

	[Delivery Period]. StartDate		    Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

Or	[Delivery Period]. EndDate			Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	)

	)
And	(   [Risk]. DlDtlTmplteID Not In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103)Or ( [Risk].DlDtlTmplteID In(23100,23101,23102,23103,23000,23100,23101,23102,23103)    And IsNull([Price Curve].IsSpotPrice, 1) = Convert(Bit, 0)  ))
And	Abs([Formula Evaluation Percentage]. PricedInPercentage)	< Abs([Formula Evaluation Percentage]. TotalPercentage)
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	))

-- Options Quotational

Insert Into [#RiskExposureResults] ([RiskID]
	,[RiskExposureTableIdnty]
	,[FormulaEvaluationID]
	,[SourceTable]
	,[DlDtlTmplteID]
	,[IsInventory]
	,[IsPrimaryCost]
	,[RiskCurveID]
	,[RwPrceLcleID]
	,[VETradePeriodID]
	,[PrceTpeIdnty]
	,[RiskType]
	,[IsQuotational]
	,[DlDtlPrvsnID]
	,[DlDtlPrvsnRwID]
	,[Percentage]
	,[PricedInPercentage]
	,[TotalPercentage]
	,[InstanceDateTime]
	,[EndOfDay]
	,[ExposureStartDate]
	,[ExposureQuoteStartDate]
	,[ExposureQuoteEndDate]
	,[CurveLevel])
 (Select	[Risk].[RiskID]
	,[Risk Quotational Exposure].[RiskQuotationalExposureID] [RiskExposureTableIdnty]
	,[Risk Quotational Exposure].[FormulaEvaluationID]
	,[Risk].[SourceTable]
	,[Risk].[DlDtlTmplteID]
	,[Risk].[IsInventory]
	,[Risk].[IsPrimaryCost]
	,Convert(Int, Null) [RiskCurveID]
	,[Price Curve].[RwPrceLcleID]
	,Max([Delivery Period].VETradePeriodID) [VETradePeriodID]
	,[Risk Deal Price Row Formula].[FormulaPrceTpeIdnty]
	,Case 	When 	[Risk].SourceTable 			= 'A' 

		And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

		And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	<> 'ED'

		Then 	'H' -- Inhouse

		Else	'Q' -- Quotational

	End [RiskType]
	,Convert(Bit, 1) [IsQuotational]
	,[Risk Deal Price Row Formula].[DlDtlPrvsnID]
	,[Risk Quotational Exposure].[DlDtlPrvsnRwID]
	,Sum([Formula Evaluation Percentage].PricedInPercentage) [Percentage]
	,Sum([Formula Evaluation Percentage].PricedInPercentage * [Risk Quotational Exposure].FormulaPercentage) [PricedInPercentage]
	,Sum([Formula Evaluation Percentage].TotalPercentage * [Risk Quotational Exposure].FormulaPercentage) [TotalPercentage]
	,@SnapshotInstanceDateTime [InstanceDateTime]
	,@SnapshotEndOfDay [EndOfDay]
	,Convert(SmallDateTime, Null) [ExposureStartDate]
	,Min([Formula Evaluation Percentage].QuoteRangeBeginDate) [QuoteRangeBeginDate]
	,Max([Formula Evaluation Percentage].QuoteRangeEndDate) [QuoteRangeEndDate]
	,Convert(Int, 0) [CurveLevel]
From	[Risk] (NoLock)
	Join [RiskQuotationalExposure] [Risk Quotational Exposure] (NoLock) On
		[Risk].RiskID = [Risk Quotational Exposure].RiskID and @SnapshotInstanceDateTime between [Risk Quotational Exposure].StartDate and [Risk Quotational Exposure].EndDate
	Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		[Risk Deal Price Row Formula].DlDtlPrvsnRwID = [Risk Quotational Exposure].DlDtlPrvsnRwID and @SnapshotInstanceDateTime between [Risk Deal Price Row Formula].StartDate and [Risk Deal Price Row Formula].EndDate
	Join [FormulaEvaluationPercentage] [Formula Evaluation Percentage] (NoLock) On
		[Formula Evaluation Percentage].FormulaEvaluationID = [Risk Quotational Exposure].FormulaEvaluationID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Delivery Period].VETradePeriodID = [Formula Evaluation Percentage].VETradePeriodID
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Deal Price Row Formula].FormulaRwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [RiskPriceIdentifier] [Risk Deal Price Source] (NoLock) On
		[Risk].RiskPriceIdentifierID = [Risk Deal Price Source].RiskPriceIdentifierID
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID and @SnapshotInstanceDateTime between [Risk Deal Detail].StartDate and [Risk Deal Detail].EndDate
Where	(
	1 = 	Case When IsNull([Risk Deal Link].DlHdrID, 0) <> 0 And IsNull([Risk Deal Link].WhatIfScenarioID, 0) <> 0 Then 0 Else 1 End
And	[Formula Evaluation Percentage]. TotalPercentage		<> 0.0
And	[Risk Quotational Exposure]. PercentageOfProvision		<> 0.0
And	 @SnapshotEndOfDay Between [Formula Evaluation Percentage]. EndOfDayStartDate And [Formula Evaluation Percentage].EndOfDayEndDate
And	(

	[Risk]. DlDtlTmplteID			Not In (21000,35000,310000) -- ETOs

Or	( -- Show Quotation T for Asian ETOs so we can show daily exposure

		[Risk].DlDtlTmplteID			In (21000,35000,310000) 

	and	Exists		( 

				Select 1

				From	dbo.[RiskDealDetailOption] RDDO	(NoLock)

				Where	RDDO. DlHdrID	= [Risk Deal Link]. DlHdrID

				and	RDDO. DlDtlID	= [Risk Deal Link]. DlDtlID

				And	@SnapshotInstanceDateTime		Between	RDDO.StartDate and RDDO.EndDate

				and	RDDO. Flavor	= 'O'

				)

	)

	Or	( -- Show Quotational for spreads

		[Risk].DlDtlTmplteID			In (21000,35000,310000) 

	and	Exists		( 

				Select 1

				From	dbo.[RiskDealDetailProvision] RDDP (NoLock)

				Where	RDDP.DlDtlPrvsnID		= [Risk Deal Price Row Formula]. DlDtlPrvsnID

				And	@SnapshotInstanceDateTime		Between RDDP.StartDate and RDDP.EndDate

				And	RDDP. DlDtlPrvsnPrvsnID	= 90

				)

	))
And	

        (

	        [Risk].DlDtlTmplteID NOT IN (9080, 9090)

        OR	[Risk].SourceTable IN ('EIX', 'EIP')

	        )

        
And	(

	IsNull([Risk Deal Price Source].TmplteSrceTpe, 'XX')	Not Like 'D%'

Or	[Risk].SourceTable			= 'A'

	)

And	(

	(

	[Risk]. DeliveryPeriodStartDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

Or	[Risk]. DeliveryPeriodEndDate		Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	)

Or	(

	[Delivery Period]. StartDate		    Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

Or	[Delivery Period]. EndDate			Between @TradePeriodStartDate And Convert(SmallDateTime, '2076-05-31 23:59:00')

	)

	)
And	[Risk]. DlDtlTmplteID In(21000,35000,310000,23100,23101,23102,23103,23000,23100,23101,23102,23103) And Not ( [Risk].DlDtlTmplteID In(23100,23101,23102,23103,23000,23100,23101,23102,23103)and IsNull([Price Curve].IsSpotPrice, 1)	= Convert(Bit, 0))
And	 Exists (Select	1 [One]
From	[#StrategyReportCriteria] (NoLock)

Where	(
	[#StrategyReportCriteria].[StrtgyID] = Risk.StrtgyID
	))
And	Risk.InternalBAID In (20)
And	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)
GROUP BY
	 [Risk].[RiskID], [Risk Quotational Exposure].[RiskQuotationalExposureID], [Risk Quotational Exposure].[FormulaEvaluationID], [Risk].[SourceTable], [Risk].[DlDtlTmplteID], [Risk].[IsInventory], [Risk].[IsPrimaryCost], [Price Curve].[RwPrceLcleID], [Risk Deal Price Row Formula].[FormulaPrceTpeIdnty], Case 	When 	[Risk].SourceTable 			= 'A'

		                                        And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	Not Like 'D%'

		                                        And	IsNull([Risk Deal Price Source]. TmplteSrceTpe, 'DD')	<> 'ED'

		                                        Then 	'H' -- Inhouse

		                                        Else	'Q' 	-- Quotational

	                                        End, [Risk Deal Price Row Formula].[DlDtlPrvsnID], [Risk Quotational Exposure].[DlDtlPrvsnRwID], Case When 	[Risk].DlDtlTmplteID In(21000,35000,310000) Then [Delivery Period].StartDate Else [Risk Deal Detail].DlDtlFrmDte End, Case When 	[Risk].DlDtlTmplteID In(21000,35000,310000) Then [Delivery Period].EndDate Else [Risk Deal Detail].DlDtlToDte End)

-- Select * From #RiskExposureResults

Execute dbo.sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables @vc_StatementGrouping = 'Updates',@c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@vc_AdditionalColumns = 'Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.DlDtlTmplteID,{Calculated Columns}.AttachedInHouse,Risk.IsInventory,Risk Deal Link.RiskPlannedTransfer.SchdlngPrdID,Risk Curve.RawPriceLocale.IsBasisCurve,Select	Top 1 ''Y''
From	RiskDealIdentifier(NOLOCK) OtherDealSide
	inner Join Risk(NOLOCK) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk Deal Detail.DealDetail.DlDtlSpplyDmnd,Select	Top 1 ''Y''
From	[RiskPlannedTransfer](NOLOCK) OtherTransfer
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID
And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> [Risk Transfer].StrtgyID),Select	Top 1 ''Y''

From	[RiskPlannedTransfer](NOLOCK) OtherTransfer

	Inner Join [RiskDealIdentifier](NOLOCK) OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk](NOLOCK) OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	Risk.IsInventory = 0
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID

And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate),Risk.DlDtlTmplteID,Risk.DeliveryPeriodStartDate,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,{Calculated Columns}.Snapshot,Risk Deal Link.DealDetail.DlDtlCrtnDte,Risk Deal Link.DealDetail.DlDtlRvsnDte,Risk Deal Link.DealDetail.DlDtlStat,Risk Deal Link.DealDetail.DlDtlDsplyUOM,Risk Deal Link.DealHeader.DlHdrIntrnlUserID,Risk Deal Link.PlnndTrnsfrID,Risk Deal Detail.NegotiatedDate,Risk.IsPrimaryCost',@i_TradePeriodFromID = @StartedFromVETradePeriodID,@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_Beg_Inv_SourceTable = 'S',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@c_ExposureType = 'Y',@c_ShowRiskType = 'A',@b_ShowRiskDecomposed = True,@b_DiscountPositions = False

Execute dbo.sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables @vc_StatementGrouping = 'DecompositionAndUpdates',@c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@vc_AdditionalColumns = 'Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.DlDtlTmplteID,{Calculated Columns}.AttachedInHouse,Risk.IsInventory,Risk Deal Link.RiskPlannedTransfer.SchdlngPrdID,Risk Curve.RawPriceLocale.IsBasisCurve,Select	Top 1 ''Y''
From	RiskDealIdentifier(NOLOCK) OtherDealSide
	inner Join Risk(NOLOCK) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk Deal Detail.DealDetail.DlDtlSpplyDmnd,Select	Top 1 ''Y''
From	[RiskPlannedTransfer](NOLOCK) OtherTransfer
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID
And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> [Risk Transfer].StrtgyID),Select	Top 1 ''Y''

From	[RiskPlannedTransfer] OtherTransfer

	Inner Join [RiskDealIdentifier](NOLOCK) OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk](NOLOCK) OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	Risk.IsInventory = 0
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID

And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate),Risk.DlDtlTmplteID,Risk.DeliveryPeriodStartDate,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,{Calculated Columns}.Snapshot,Risk Deal Link.DealDetail.DlDtlCrtnDte,Risk Deal Link.DealDetail.DlDtlRvsnDte,Risk Deal Link.DealDetail.DlDtlStat,Risk Deal Link.DealDetail.DlDtlDsplyUOM,Risk Deal Link.DealHeader.DlHdrIntrnlUserID,Risk Deal Link.PlnndTrnsfrID,Risk Deal Detail.NegotiatedDate,Risk.IsPrimaryCost',@i_TradePeriodFromID = @StartedFromVETradePeriodID,@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_Beg_Inv_SourceTable = 'S',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@c_ExposureType = 'Y',@c_ShowRiskType = 'A',@b_ShowRiskDecomposed = True,@b_DiscountPositions = False

Execute dbo.sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables @vc_StatementGrouping = 'LoadFinalResults',@c_OnlyShowSQL = 'N',@vc_InventoryTypeCode = 'I',@vc_AdditionalColumns = 'Risk Deal Link.DealHeader.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.GeneralConfiguration.HedgeMonth,Risk Deal Link.DealDetail.DlDtlTmplteID,{Calculated Columns}.AttachedInHouse,Risk.IsInventory,Risk Deal Link.RiskPlannedTransfer.SchdlngPrdID,Risk Curve.RawPriceLocale.IsBasisCurve,Select	Top 1 ''Y''
From	RiskDealIdentifier(NOLOCK) OtherDealSide
	inner Join Risk(NOLOCK) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK)	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like ''%inventory%''
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID),Risk Deal Detail.DealDetail.DlDtlSpplyDmnd,Select	Top 1 ''Y''
From	[RiskPlannedTransfer](NOLOCK) OtherTransfer
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID
And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> [Risk Transfer].StrtgyID),Select	Top 1 ''Y''

From	[RiskPlannedTransfer](NOLOCK) OtherTransfer

	Inner Join [RiskDealIdentifier](NOLOCK) OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk](NOLOCK) OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	Risk.IsInventory = 0
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID

And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate),Risk.DlDtlTmplteID,Risk.DeliveryPeriodStartDate,Risk.InventoryAccountingPeriodStartDate,Risk Deal Detail.DlDtlRvsnDte,{Calculated Columns}.Snapshot,Risk Deal Link.DealDetail.DlDtlCrtnDte,Risk Deal Link.DealDetail.DlDtlRvsnDte,Risk Deal Link.DealDetail.DlDtlStat,Risk Deal Link.DealDetail.DlDtlDsplyUOM,Risk Deal Link.DealHeader.DlHdrIntrnlUserID,Risk Deal Link.PlnndTrnsfrID,Risk Deal Detail.NegotiatedDate,Risk.IsPrimaryCost',@i_TradePeriodFromID = @StartedFromVETradePeriodID,@dt_maximumtradeperiodstartdate = '2076-05-31 00:00:00',@c_Beg_Inv_SourceTable = 'S',@i_id = 53,@vc_type = 'Portfolio',@i_P_EODSnpShtID = @SnapshotId,@c_ExposureType = 'Y',@c_ShowRiskType = 'A',@b_ShowRiskDecomposed = True,@b_DiscountPositions = False

Select	[Risk].[RiskID]
	,[#RiskExposureFinalResults].[Description]
	,[#RiskExposureFinalResults].[DlDtlID]
	,[Risk].[InternalBAID]
	,IsNull([Risk Deal Price].[ExternalBAID], [Risk]. [ExternalBAID]) [ExternalBAID]
	,[#RiskExposureFinalResults].[RiskType]
	,IsNull([{Calculated Columns}].[PrdctID], [Risk]. [PrdctID]) [PrdctID]
	,IsNull([{Calculated Columns}].[LcleID], [Risk]. [LcleID]) [LcleID]
	,[{Calculated Columns}].[CurveServiceID]
	,[{Calculated Columns}].[CurveProductID]
	,[{Calculated Columns}].[CurveLcleID]
	,[#RiskExposureFinalResults].[PeriodStartDate]
	,[#RiskExposureFinalResults].[PeriodEndDate]
	,[#RiskExposureFinalResults].[StrtgyID]
	,[#RiskExposureFinalResults].[Position]
	,[#RiskExposureFinalResults].[PricedInPercentage]
	,[#RiskExposureFinalResults].[PortfolioOrPositionGroup]
	,IsNull([{Calculated Columns}].[ChmclID], [Risk]. [ChmclID]) [ChmclID]
	,[{Calculated Columns}].[CurveChemProductID]
	,[#RiskExposureFinalResults].[PeriodGroupStartDate]
	,[#RiskExposureFinalResults].[PeriodGroupEndDate]
	,[{Calculated Columns}].[EndOfDay]
	,[#RiskExposureFinalResults].[ExposureQuoteDate]
	,[Risk].[SourceTable]
	,[{Calculated Columns}].[SpecificGravity]
	,[{Calculated Columns}].[Energy]
	,[GC19_Dyn].[GnrlCnfgMulti] [HedgeMonth_Dyn29]
	,[GC21_Dyn].[GnrlCnfgMulti] [HedgeMonth_Dyn30]
	,[DD20_Dyn].[DlDtlTmplteID] [DlDtlTmplteID_Dyn31]
	,[{Calculated Columns}].[AttachedInHouse] [AttachedInHouse_Dyn32]
	,[Risk].[IsInventory] [IsInventory_Dyn33]
	,[RPT22_Dyn].[SchdlngPrdID] [SchdlngPrdID_Dyn34]
	,[RPL23_Dyn].[IsBasisCurve] [IsBasisCurve_Dyn35]
	,(Select	Top 1 'Y'
From	RiskDealIdentifier(NOLOCK) OtherDealSide
	inner Join Risk(NOLOCK) OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader(NOLOCK) 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like '%inventory%'
Where	[Risk].DlDtlTmplteID in (30000,30001)
And	OtherDealSide.DlHdrID = [Risk Deal Link].DlHdrID) [Subselect_Dyn36]
	,[DD24_Dyn].[DlDtlSpplyDmnd] [DlDtlSpplyDmnd_Dyn39]
	,(Select	Top 1 'Y'
From	[RiskPlannedTransfer](NOLOCK) OtherTransfer
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID
And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> [Risk Transfer].StrtgyID) [Subselect_Dyn38]
	,(Select	Top 1 'Y'

From	[RiskPlannedTransfer](NOLOCK) OtherTransfer

	Inner Join [RiskDealIdentifier](NOLOCK) OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk](NOLOCK) OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	Risk.IsInventory = 0
Where	OtherTransfer.PlnndMvtID = [Risk Transfer].PlnndMvtID

And	[{Calculated Columns}].InstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate) [Subselect_Dyn40]
	,[Risk].[DlDtlTmplteID] [DlDtlTmplteID_Dyn40]
	,[Risk].[DeliveryPeriodStartDate] [DeliveryPeriodStartDate_Dyn41]
	,[Risk].[InventoryAccountingPeriodStartDate] [InventoryAccountingPeriodStartDate_Dyn42]
	,[Risk Deal Detail].[DlDtlRvsnDte] [DlDtlRvsnDte_Dyn43]
	,[{Calculated Columns}].[Snapshot] [Snapshot_Dyn44]
	,[DD20_Dyn].[DlDtlCrtnDte] [DlDtlCrtnDte_Dyn45]
	,[DD20_Dyn].[DlDtlRvsnDte] [DlDtlRvsnDte_Dyn46]
	,[DD20_Dyn].[DlDtlStat] [DlDtlStat_Dyn47]
	,[DD20_Dyn].[DlDtlDsplyUOM] [DlDtlDsplyUOM_Dyn48]
	,[DH18_Dyn].[DlHdrIntrnlUserID] [DlHdrIntrnlUserID_Dyn49]
	,[Risk Deal Link].[PlnndTrnsfrID] [PlnndTrnsfrID_Dyn49]
	,[Risk Deal Detail].[NegotiatedDate] [NegotiatedDate_Dyn50]
	,[Risk].[IsPrimaryCost] [IsPrimaryCost_Dyn51]
	,Cast(3 AS SmallInt) [AutoGeneratedBaseUOM]
	,Cast(19 AS Int) [AutoGeneratedBaseCurrency]
	,[{Calculated Columns}].InstanceDateTime AS CCInstanceDateTime
	,[Risk Transfer].PlnndMvtID
	,[Risk Transfer].StrtgyID AS RTStrtgyID
INTO #temp_RER
From	[#RiskExposureFinalResults] (NoLock)
	Join [#RiskExposureResults] [{Calculated Columns}] (NoLock) On
			[#RiskExposureFinalResults].[RiskExposureResultsIdnty] = [{Calculated Columns}].[Idnty]
	Join [Risk] (NoLock) On
			[{Calculated Columns}].[RiskID] = [Risk].[RiskID]
	Left Join [#RiskExposureResultsOptions] [{Option Columns}] (NoLock) On
			[#RiskExposureFinalResults].[RiskExposureResultsIdnty] = [{Option Columns}].[RiskResultsTableIdnty]
	Left Join [#RiskExposureResultsHedge] [{Hedging Information}] (NoLock) On
			[#RiskExposureFinalResults].[RiskExposureResultsIdnty] = [{Hedging Information}].[RiskResultsTableIdnty]
	Left Join [#RiskResultsSnapshot] [{Snapshot Information Columns}] (NoLock) On
		1 = 1
	Left Join [RiskCurve] [Risk Curve] (NoLock) On
			[{Calculated Columns}].[RiskCurveID] = [Risk Curve].[RiskCurveID]
	Left Join [RiskDealIdentifier] [Risk Deal Link] (NoLock) On
		[Risk].RiskDealIdentifierID = [Risk Deal Link].RiskDealIdentifierID
	Left Join [LeaseDealDetail] [Lease Deal Detail] (NoLock) On
		[{Calculated Columns}].[LeaseDealDetailID] = [Lease Deal Detail].[LeaseDealDetailID]
	Left Join [RiskPhysicalExposure] [Risk Physical Exposure] (NoLock) On
		[{Calculated Columns}].[RiskExposureTableIdnty] = [Risk Physical Exposure].[RiskPhysicalExposureID] And [{Calculated Columns}].[RiskType] <> 'Q'
	Left Join [RiskQuotationalExposure] [Risk Quotational Exposure] (NoLock) On
		[{Calculated Columns}].[RiskExposureTableIdnty] = [Risk Quotational Exposure].[RiskQuotationalExposureID] And [{Calculated Columns}].[RiskType] = 'Q'
	Left Join [RiskDealDetailProvisionRow] [Risk Deal Price Row Formula] (NoLock) On
		[Risk Deal Price Row Formula].[DlDtlPrvsnRwID] = [{Calculated Columns}].[DlDtlPrvsnRwID] And [{Calculated Columns}].[InstanceDateTime] Between [Risk Deal Price Row Formula].StartDate And [Risk Deal Price Row Formula].EndDate
	Left Join [RiskDealDetailProvision] [Risk Deal Price] (NoLock) On
		[Risk Deal Price Row Formula].[DlDtlPrvsnID] = [Risk Deal Price].[DlDtlPrvsnID] And [{Calculated Columns}].[InstanceDateTime] Between [Risk Deal Price].StartDate And [Risk Deal Price].EndDate
	Left Join [RiskDealDetail] [Risk Deal Detail] (NoLock) On
		[Risk Deal Link].DlHdrID = [Risk Deal Detail].DlHdrID And [Risk Deal Link].DlDtlID = [Risk Deal Detail].DlDtlID And [{Calculated Columns}].[InstanceDateTime] Between [Risk Deal Detail].StartDate And [Risk Deal Detail].EndDate And [Risk Deal Link].ExternalType = [Risk Deal Detail].SrceSystmID
	Left Join [RawPriceLocale] [Price Curve] (NoLock) On
		[Risk Curve].RwPrceLcleID = [Price Curve].RwPrceLcleID
	Left Join [VETradePeriod] [Delivery Period] (NoLock) On
		[Risk Curve].VETradePeriodID = [Delivery Period].VETradePeriodID
	Left Join [RiskPlannedTransfer] [Risk Transfer] (NoLock) On
		[Risk Deal Link]. PlnndTrnsfrID = [Risk Transfer]. PlnndTrnsfrID and [{Calculated Columns}]. InstanceDateTime	Between [Risk Transfer].StartDate and [Risk Transfer].EndDate and [Risk]. ChmclID = [Risk Transfer]. ChmclChdPrdctID
	Left Join [DealHeader] [DH18_Dyn] (NoLock) On
		[Risk Deal Link].DlHdrID = [DH18_Dyn].DlHdrID and [Risk Deal Link].DealDetailID is not null
	Left Join [GeneralConfiguration] [GC19_Dyn] (NoLock) On
		[DH18_Dyn].DlHdrID = [GC19_Dyn].GnrlCnfgHdrID And [GC19_Dyn].GnrlCnfgTblNme = 'DealHeader' And [GC19_Dyn].GnrlCnfgQlfr = 'HedgeMonth' And [GC19_Dyn].GnrlCnfgHdrID <> 0
	Left Join [DealDetail] [DD20_Dyn] (NoLock) On
		[Risk Deal Link].DealDetailID = [DD20_Dyn].DealDetailID
	Left Join [GeneralConfiguration] [GC21_Dyn] (NoLock) On
		[DD20_Dyn].DlDtlDlHdrID = [GC21_Dyn].GnrlCnfgHdrID And [DD20_Dyn].DlDtlID = [GC21_Dyn].GnrlCnfgDtlID And [GC21_Dyn].GnrlCnfgTblNme = 'DealDetail' And [GC21_Dyn].GnrlCnfgQlfr = 'HedgeMonth' And [GC21_Dyn].GnrlCnfgHdrID <> 0
	Left Join [RiskPlannedTransfer] [RPT22_Dyn] (NoLock) On
		[Risk Deal Link].PlnndTrnsfrID = [RPT22_Dyn].PlnndTrnsfrID and @SnapshotInstanceDateTime between [RPT22_Dyn].StartDate and [RPT22_Dyn].EndDate
	Left Join [RawPriceLocale] [RPL23_Dyn] (NoLock) On
		[Risk Curve].RwPrceLcleID = [RPL23_Dyn].RwPrceLcleID
	Left Join [DealDetail] [DD24_Dyn] (NoLock) On
		[Risk Deal Detail].DealDetailID = [DD24_Dyn].DealDetailID
Where	(
	[Risk].[StrtgyID] Not In (Select Value From CreateTableList(@36@Risk@StrtgyID))
	)


---Join Respective tables to get respective columns values and computed columns

SET NOCOUNT ON; 
IF OBJECT_ID('tempdb..#temp_RER_Join') IS NOT NULL
    DROP TABLE #temp_RER_Join


SELECT 
CONVERT(Varchar(20), [Description]) AS deal  
,CONVERT(Varchar(20),DlDtlID) AS deal_detail_id 
,CASE WHEN [DlDtlStat_Dyn47] = 'A' THEN 'Active'
		WHEN [DlDtlStat_Dyn47] = 'C' THEN 'Canceled' END status  
,[NegotiatedDate_Dyn50] AS trade_date
,[EndOfDay] AS end_of_day
,[PeriodStartDate] AS period_start
,[PeriodEndDate] AS period_end
,[DlDtlRvsnDte_Dyn46] AS revision_date
, [DlDtlCrtnDte_Dyn45] AS creation_date
,[PeriodGroupStartDate] AS period_group_start
,[PeriodGroupEndDate] AS period_group_end
,Convert(smalldatetime, [HedgeMonth_Dyn29]) AS hedge_month
,Convert(smalldatetime, [HedgeMonth_Dyn30]) AS deal_detail_hedge_month
,(SELECT [FromDate] FROM [dbo].[SchedulingPeriod](NOLOCK) WHERE [SchdlngPrdID] = t.[SchdlngPrdID_Dyn34]) AS scheduling_period
,[InventoryAccountingPeriodStartDate_Dyn42] AS inventory_accounting_start_date
,[DeliveryPeriodStartDate_Dyn41] AS delivery_period_start
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.PrdctID) AS product
,CASE WHEN [RiskType] = 'M' THEN 'Market'
	WHEN [RiskType] = 'P' THEN 'Physical'
	WHEN [RiskType] = 'Q' THEN 'Quotational'
	WHEN [RiskType] = 'I' THEN 'Inventory'
	END AS risk_type
,(SELECT CntctFrstNme + ' ' +CntctLstNme FROM [dbo].Users(NOLOCK) U 
	INNER JOIN Contact(NOLOCK) C ON U.UserCntctID = C.CntCtID 
	WHERE U.UserID = t.[DlHdrIntrnlUserID_Dyn49]) AS trader
,(SELECT [Name] FROM [dbo].[StrategyHeader](NOLOCK) SH WHERE SH.StrtgyID = t.StrtgyID) AS strategy
,[PortfolioOrPositionGroup] AS portfolio_position_group
,(SELECT Abbreviation FROM [dbo].[BusinessAssociate](NOLOCK) BA WHERE BA.BAID = t.InternalBAID) AS our_company
,(SELECT Abbreviation FROM [dbo].[BusinessAssociate](NOLOCK) BA WHERE BA.BAID = t.ExternalBAID) AS their_company
,(SELECT LcleAbbrvtn FROM [dbo].[Locale](NOLOCK) Lcle WHERE Lcle.LcleID = t.LcleID) AS location
,(SELECT [RPHdrAbbv] FROM [RawPriceHeader](NOLOCK) WHERE [RPHdrID] = [CurveServiceID]) AS curve_service
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.[CurveProductID]) AS curve_product
,(SELECT LcleAbbrvtn FROM [dbo].[Locale](NOLOCK) Lcle WHERE Lcle.LcleID = [CurveLcleID]) AS curve_location
,[Position] AS position
,[ExposureQuoteDate] AS exposure_quote_date
,Convert(Varchar(20), (Round(PricedInPercentage*100,2))) + '%' AS priced_percentage
,(SELECT UOMAbbv FROM UnitOfMeasure(NOLOCK) UOM WHERE UOM.UOM = t.DlDtlDsplyUOM_Dyn48) AS uom 
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.[ChmclID]) AS child_product
,(SELECT PrdctAbbv FROM [dbo].[Product](NOLOCK) Prd WHERE Prd.PrdctID = t.[CurveChemProductID]) AS curve_child_product
,(SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.[DlDtlTmplteID_Dyn40]) AS detail_template
,CASE WHEN [AttachedInHouse_Dyn32] = 'N' THEN 'No'
	ELSE 'Yes' END AS attached_inhouse
,CASE WHEN [IsInventory_Dyn33] = 1 THEN 'Yes' 
		ELSE 'No' END inventory
,CASE WHEN [IsBasisCurve_Dyn35] = 1 THEN 'Yes'
	ELSE 'No' END AS is_basis_curve
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
,CASE WHEN (SELECT PTReceiptDelivery FROM PlannedTransfer(NOLOCK) WHERE PlnndTrnsfrID = t.PlnndTrnsfrID_Dyn49) = 'R' THEN 'Receipt'
	WHEN (SELECT PTReceiptDelivery FROM PlannedTransfer(NOLOCK) WHERE PlnndTrnsfrID = t.PlnndTrnsfrID_Dyn49) = 'D' THEN 'Delivery'
	END AS receipt_delivery
,(SELECT PTParcelNumber FROM PlannedTransfer(NOLOCK) WHERE PlnndTrnsfrID = t.PlnndTrnsfrID_Dyn49) AS [PlannedTransfer_PTParcelNumber_Dyn28]
,[RiskID] AS risk_id
,'' AS [Flat Price/Basis]
,CASE WHEN [IsPrimaryCost_Dyn51] = 0 THEN 'No'
	ELSE 'Yes' END AS primary_cost
,PlnndTrnsfrID_Dyn49 AS transfer_id
,(SELECT [Description] FROM [dbo].[DealDetailTemplate](NOLOCK) DDT WHERE DDT.[DlDtlTmplteID] = T.DlDtlTmplteID_Dyn31 ) AS deal_detail_template
,Iif([AttachedInHouse_Dyn32] = 'No' And [IsInventory_Dyn33] = 'Yes', 'True', 'False') AS calc_is_inventory
,'' AS [Build/Draw]
,[Snapshot_Dyn44] AS snapshot_id
,(Select	Top 1 'Y'
From	RiskDealIdentifier OtherDealSide
	inner Join Risk OtherRisk On OtherRisk.RiskDealIdentifierID = OtherDealSide.RiskDealIdentifierID
	Inner Join StrategyHeader 	On StrategyHeader.StrtgyID = OtherRisk.StrtgyID
					And StrategyHeader.Name like '%inventory%'
Where	t.[DlDtlTmplteID_Dyn40] in (30000,30001)
And	OtherDealSide.DlHdrID = (SELECT DlHdrID FROM DealHeader(NOLOCK) WHERE DlHdrIntrnlNbr = t.[Description]))
AS calc_involves_inventory_book
,'' AS [Risk Category]
,(Select	Top 1 'Y'
From	[RiskPlannedTransfer] OtherTransfer
Where	OtherTransfer.PlnndMvtID = t.PlnndMvtID
And	t.CCInstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
And	OtherTransfer.StrtgyID <> t.StrtgyID)
AS calc_order_crosses_strategy
,'' AS InventoryBuySalelBuildDraw
,(Select	Top 1 'Y'
From	[RiskPlannedTransfer] OtherTransfer

	Inner Join [RiskDealIdentifier] OtherDeal On  OtherDeal.PlnndTrnsfrID = OtherTransfer.PlnndTrnsfrID
	Inner Join [Risk] OtherRisk	On	OtherRisk.RiskDealIdentifierID = OtherDeal.RiskDealIdentifierID
					And	t.[IsInventory_Dyn33] = 0
Where	OtherTransfer.PlnndMvtID = t.PlnndMvtID
And	t.CCInstanceDateTime Between OtherTransfer.StartDate And OtherTransfer.EndDate
) AS calc_order_has_non_inventory
,'' AS [RiskType]
,[Position] AS calc_exposure
,'' [*Position]
INTO #temp_RER_Join
FROM #temp_RER t


---Final load into temp tables with computed columns

SET NOCOUNT ON; 
IF OBJECT_ID('tempdb..#temp_RER_Final') IS NOT NULL
    DROP TABLE #temp_RER_Final

SELECT 
deal
,deal_detail_id
,status
,trade_date
,end_of_day
,period_start
,period_end
,revision_date
,creation_date
,period_group_start
,period_group_end
,hedge_month
,deal_detail_hedge_month
,scheduling_period
,inventory_accounting_start_date
,delivery_period_start
,product
,risk_type
,trader
,strategy
,portfolio_position_group
,our_company
,their_company
,location
,curve_service
,curve_product
,curve_location
,position
,exposure_quote_date
,priced_percentage
,uom
,child_product
,curve_child_product
,detail_template
,attached_inhouse
,inventory
,is_basis_curve
,source
,receipt_delivery
,Iif([PlannedTransfer_PTParcelNumber_Dyn28] Is Null Or [PlannedTransfer_PTParcelNumber_Dyn28] = '(Empty)' Or [PlannedTransfer_PTParcelNumber_Dyn28] = '', 
 Iif(CONVERT(VARCHAR(10),deal_detail_hedge_month, 101) Is Null Or CONVERT(VARCHAR(10),deal_detail_hedge_month, 101) = '(Empty)' Or CONVERT(VARCHAR(10),deal_detail_hedge_month, 101) = '', 
  Iif(CONVERT(VARCHAR(10),inventory_accounting_start_date, 101) Is Null Or CONVERT(VARCHAR(10),inventory_accounting_start_date, 101) = '(Empty)' Or CONVERT(VARCHAR(10),inventory_accounting_start_date, 101) = '', 
   Iif(CONVERT(VARCHAR(10),hedge_month, 101) Is Null Or CONVERT(VARCHAR(10),hedge_month, 101) = '(Empty)' Or CONVERT(VARCHAR(10),hedge_month, 101) = '', inventory_accounting_start_date, hedge_month), inventory_accounting_start_date), deal_detail_hedge_month), [PlannedTransfer_PTParcelNumber_Dyn28])
AS calc_program_month
,risk_id
,Iif(is_basis_curve = 'No', 'Flat Price', 'Basis') AS calc_flat_price_basis
,primary_cost
,transfer_id
,deal_detail_template
,calc_is_inventory
,Iif((source = 'Planned Transfer' Or source = 'Movement Transaction') And calc_is_inventory = 'True', 'Build/Draw', '') AS calc_build_draw
,snapshot_id
,calc_involves_inventory_book
,Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
)In ('Inventory', 'Build', 'Draw'), '1-Beg Inv', '') + 
Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
) In ('Sale-Internal'), '3-Demand', '') + 
Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
) In ('3rd Party'), '4-3rd Party', '') + 
Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
) In ('Paper'), '5-Paper', '') + 
Iif((Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))
) In ('Buy-Internal'), '2-Supply', '') + Iif(deal = 'MOA17TP0003', '3-Demand', '') AS calc_risk_category
,calc_order_crosses_strategy
,Iif(source In ('Actual Balance', 'Actual Inventory Change', 'Estimated Balance', 'Estimated Inventory Change', 'Inventory Change') Or calc_involves_inventory_book = 'Y', 'Inventory', 
 Iif(deal_detail_template = 'Consumption Delivery', 'Sale-Internal', 
   Iif(attached_inhouse = 'Yes' And receipt_delivery = 'Delivery', 'Buy-Internal', 
     Iif(deal_detail_template = 'Inhouse Receipt', 'Buy-Internal', 
	   Iif(deal_detail_template = 'Inhouse Delivery', 'Sale-Internal', 
	     Iif(deal_detail_template In ('Sale Delivery', 'Purchase Receipt', 'EFP Physical Detail', 'Buy/Sell Delivery', 'Buy/Sell Receipt'), '3rd Party', 
		   Iif(receipt_delivery = 'Receipt' And calc_is_inventory = 'True', 'Draw', 
		     Iif(receipt_delivery = 'Delivery' And calc_is_inventory = 'True', 'Build', 
			   Iif(deal_detail_template In ('EFP Paper Detail', 'EFS Swap Detail', 'Future Inhouse Delivery Detail', 'Future Detail', 'Future Inhouse Receipt Detail', 'Swap Inhouse Delivery', 'Swap Inhouse Receipt'), 'Paper', 'UNKNOWN')))))))))

AS calc_inventory_buy_sale_build_draw
,calc_order_has_non_inventory
,RiskType
,calc_exposure
,[*Position]
INTO #temp_RER_Final
FROM #temp_RER_Join




--Load Data into Custom RER table


INSERT INTO [db_datareader].[MTVTempRiskExposure] with (tablockx)
([deal]
      ,[deal_detail_id]
      ,[status]
      ,[trade_date]
      ,[end_of_day]
      ,[period_start]
      ,[period_end]
      ,[revision_date]
      ,[creation_date]
      ,[period_group_start]
      ,[period_group_end]
      ,[hedge_month]
      ,[deal_detail_hedge_month]
      ,[scheduling_period]
      ,[inventory_accounting_start_date]
      ,[delivery_period_start]
      ,[product]
      ,[risk_type]
      ,[trader]
      ,[strategy]
      ,[portfolio_position_group]
      ,[our_company]
      ,[their_company]
      ,[location]
      ,[curve_service]
      ,[curve_product]
      ,[curve_location]
      ,[position]
      ,[exposure_quote_date]
      ,[priced_percentage]
      ,[uom]
      ,[child_product]
      ,[curve_child_product]
      ,[detail_template]
      ,[attached_inhouse]
      ,[inventory]
      ,[is_basis_curve]
      ,[source]
      ,[receipt_delivery]
      ,[calc_program_month]
      ,[risk_id]
      ,[calc_flat_price_basis]
      ,[primary_cost]
      ,[transfer_id]
      ,[deal_detail_template]
      ,[calc_is_inventory]
      ,[calc_build_draw]
      ,[snapshot_id]
      ,[calc_involves_inventory_book]
      ,[calc_risk_category]
      ,[calc_order_crosses_strategy]
      ,[calc_inventory_buy_sale_build_draw]
      ,[calc_order_has_non_inventory]
      ,[calc_risk_type]
      ,[calc_exposure]
      ,[calc_position]
	  )
SELECT 
deal
,deal_detail_id
,status
,trade_date
,end_of_day
,period_start
,period_end
,revision_date
,creation_date
,period_group_start
,period_group_end
,hedge_month
,deal_detail_hedge_month
,scheduling_period
,inventory_accounting_start_date
,delivery_period_start
,product
,risk_type
,trader
,strategy
,portfolio_position_group
,our_company
,REPLACE(their_company, ',', '') AS their_company
,location
,curve_service
,curve_product
,curve_location
,position
,exposure_quote_date
,priced_percentage
,uom
,child_product
,curve_child_product
,CONVERT(Varchar(50), detail_template) AS detail_template
,attached_inhouse
,inventory
,is_basis_curve
,source
,receipt_delivery
,calc_program_month
,CONVERT(Varchar(20), risk_id) AS risk_id
,calc_flat_price_basis
,primary_cost
,CONVERT(Varchar(20),transfer_id) AS transfer_id
,CONVERT(Varchar(50), deal_detail_template) AS deal_detail_template
,calc_is_inventory
,calc_build_draw
,CONVERT(Varchar(20),snapshot_id) AS snapshot_id
,calc_involves_inventory_book
,calc_risk_category
,calc_order_crosses_strategy
,calc_inventory_buy_sale_build_draw
,calc_order_has_non_inventory
,Iif(calc_risk_category Like '%Paper%', 'Quotational', Iif(risk_type = 'Inventory', 'Physical', risk_type)) calc_risk_type
,calc_exposure
,Iif((Iif(calc_risk_category Like '%Paper%', 'Quotational', Iif(risk_type = 'Inventory', 'Physical', risk_type))) = 'Physical', position, 0) calc_position
FROM #temp_RER_Final

END

END

END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[MTV_GetTempRiskExposure]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_GetTempRiskExposure.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_GetTempRiskExposure >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_GetTempRiskExposure >>>'
	  END

