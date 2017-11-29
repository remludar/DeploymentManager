

IF  OBJECT_ID(N'[dbo].[MTVCreditInterfaceStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVCreditInterfaceStaging]
    PRINT '<<< DROPPED TABLE MTVCreditInterfaceStaging >>>'
END

/****** Object:  Table [dbo].[MTVCreditInterfaceStaging]    Script Date: 5/16/2016 1:10:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[MTVCreditInterfaceStaging](
	[AccountingPeriodStartDate] [datetime] NULL,
	[AggregationGroupName] [varchar](300) NULL,
	[Agreement] [varchar](25) NULL,
	[AgreementType] [varchar](40) NULL,
	[AttachedInHouse] [varchar](2) NULL,
	[BaseUOM] [varchar](20) NULL,
	[BestAvailableQuantity] [float] NULL,
	[BuySell] [varchar](10) NULL,
	[ChargeType] [varchar](128) NULL,
	[ChmclID] [int] NULL,
	[ClassOfTrade] [varchar](50) NULL,
	[CloseOfBusiness] [datetime] NULL,
	[CommDeal] [varchar](200) NULL,
	[ConversionCrrncyID] [int] NULL,
	[ConversionCurrency] [varchar](20) NULL,
	[ConversionDeliveryPeriodID] [int] NULL,
	[ConversionFactor] [int] NULL,
	[CreationDate] [datetime] NULL,
	[CurFxRate] [int] NULL,
	[CurveName] [varchar](128) NULL,
	[CustomStatus] [varchar](80) NULL,
	[DealCoveredByLoC] [varchar](1) NULL,
	[DealCurrency] [char](3) NULL,
	[DealDetailId] [int] NULL,
	[DealHeaderId] [int] NULL,
	[DealNotionalValue] [float] NULL,
	[DealPriceSource] [varchar](50) NULL,
	[DealValueFXConversionDate] [datetime] NULL,
	[DealValueIsMissing] [bit] NULL,
	[DefaultCurrency] [varchar](20) NULL,
	[DefaultCurrencyID] [int] NULL,
	[DeliveryPeriod] [varchar](50) NULL,
	[DeliveryPeriodEndDate] [datetime] NULL,
	[DeliveryPeriodStartDate] [datetime] NULL,
	[Description] [varchar](128) NULL,
	[DlDtlPrvsnID] [int] NULL,
	[DlDtlPrvsnRwID] [int] NULL,
	[DlDtlPrvsnRwID2] [int] NULL,
	[DlDtlPrvsnRwID3] [int] NULL,
	[DlDtlTmplteID] [int] NULL,
	[DlvyProductA] [varchar](500) NULL,
	[Ele] [varchar](50) NULL,
	[Energy] [float] NULL,
	[EstimatedMovementDate] [datetime] NULL,
	[EstPmtDate] [datetime] NULL,
	[ExposureID] [int] IDENTITY(1,1) NOT NULL,
	[ExposureType] [varchar](1) NULL,
	[ExternalBAID] [int] NULL,
	[FlatPriceOrBasis] [varchar](12) NULL,
	[FloatPnl] [float] NULL,
	[FloatPosition] [float] NULL,
	[FwdAmountA] [float] NULL,
	[Ile] [varchar](50) NULL,
	[InitDealPrice] [float] NULL,
	[InitialDealVolume] [float] NULL,
	[InitSysPrice] [int] NULL,
	[InitSysVolume] [int] NULL,
	[InternalBAID] [int] NULL,
	[InvoiceNumber] [varchar](20) NULL,
	[LocaleID] [int] NULL,
	[MarketCrrncyID] [int] NULL,
	[MarketCurrency] [varchar](20) NULL,
	[MarketPerUnitValue] [float] NULL,
	[MarketValue] [float] NULL,
	[MarketValueFXConversionDate] [datetime] NULL,
	[MarketValueIsMissing] [bit] NULL,
	[MaxPeriodStartDate] [datetime] NULL,
	[MethodofTransportation] [varchar](20) NULL,
	[MovementStatus] [varchar](20) NULL,
	[MTMRunType] [varchar](2) NULL,
	[PaymentCrrncyID] [int] NULL,
	[PaymentCurrency] [varchar](20) NULL,
	[PerUnitValue] [float] NULL,
	[Portfolio] [varchar](50) NULL,
	[Position] [float] NULL,
	[PriceDescription] [varchar](128) NULL,
	[PricedInPercentage] [float] NULL,
	[PricedInPerUnitValue] [float] NULL,
	[PricedPnL] [float] NULL,
	[PricedValueFXRate] [float] NULL,
	[PriceProductA] [varchar](1024) NULL
	,[PriceType] [varchar](100) NULL
	,[PricingSeq] [int] NULL
	,[Product] [varchar](40) NULL
	,[ProductID] [int] NULL
	,[Provision] [varchar](80) NULL
	,[RD] [varchar](1) NULL
	,[RiskAdjustmentID] [int] NULL
	,[RiskID] [int] NULL
	,[RiskPriceIdentifierID] [int] NULL
	,[RunDate] [datetime] NULL
	,[SalesInvoiceNumber] [varchar](20) NULL
	,[SentToMSAP] [bit] NULL
	,[SentToParagon] [bit] NULL
	,[SettledAmountA] [float] NULL
	,[SettledVolumeA] [float] NULL
	,[SnapshotID] [int] NULL
	,[SnapshotInstanceDateTime] [datetime] NULL
	,[SnapshotIsArchived] [bit] NULL
	,[SoldTo] [varchar](20) NULL
	,[Source] [varchar](50) NULL
	,[SourceSystem] [varchar](20) NULL
	,[SourceTable] [varchar](2) NULL
	,[SpecificGravity] [float] NULL
	,[StrategyID] [int] NULL
	,[TemplateName] [varchar](100) NULL
	,[TimeBasedDlDtlPrvsnRwID] [int] NULL
	,[TmplteSrceTpe] [varchar](20) NULL
	,[TotalPnL] [float] NULL
	,[TotalQuantity] [float] NULL
	,[TotalValueFXRate] [float] NULL
	,[Trader] [varchar](42) NULL
	,[TradeTag] [varchar](120) NULL
	,[TradeType] [varchar](100) NULL
	,[TransDate] [datetime] NULL
	,[UserID] [int] NULL
	,[VolumeUOM] [varchar](20) NULL

	 CONSTRAINT [ExposureID] PRIMARY KEY CLUSTERED 
	(
		[ExposureID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
 ) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO
IF  OBJECT_ID(N'[dbo].[MTVCreditInterfaceStagingArchive]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVCreditInterfaceStagingArchive]
    PRINT '<<< DROPPED TABLE MTVCreditInterfaceStagingArchive >>>'
END
CREATE TABLE [dbo].[MTVCreditInterfaceStagingArchive](
AccountingPeriodStartDate	[datetime]	NULL
,AggregationGroupName	[varchar](300)	NULL
,Agreement	[varchar](20)	NULL
,AgreementType	varchar(40)	NULL
,AttachedInHouse	[varchar](2)	NULL
,BaseUOM	[varchar](20)	NULL
,BestAvailableQuantity	float	NULL
,BuySell	[varchar](10)	NULL
,ChargeType	[varchar](128)	NULL
,ChmclID	[int]	NULL
,ClassOfTrade	[varchar](50)	null
,CloseOfBusiness	[datetime]	NULL
,CommDeal	varchar(200)	NULL
,ConversionCrrncyID	[int]	NULL
,ConversionCurrency	varchar(20)	NULL
,ConversionDeliveryPeriodID	[int]	NULL
,ConversionFactor	[int]	NULL
,CreationDate	datetime	NULL
,CurFxRate	[int]	NULL
,CurveName	[varchar](128)	NULL
,CustomStatus	varchar(80)	NULL
,DealCoveredByLoC	varchar(1)	null
,DealCurrency	[char](3)	NULL
,DealDetailId	[int]	NULL
,DealHeaderId   [int] NULL
,DealNotionalValue	[float]	NULL
,DealPriceSource	[varchar](50)	NULL
,DealValueFXConversionDate	[datetime]	NULL
,DealValueIsMissing	[bit]	NULL
,DefaultCurrency	varchar(20)	NULL
,DefaultCurrencyID	[int]	NULL
,DeliveryPeriod	varchar(50)	NULL
,DeliveryPeriodEndDate	[datetime]	NULL
,DeliveryPeriodStartDate	[datetime]	NULL
,Description	[varchar](128)	NULL
,DlDtlPrvsnID	[int]	NULL
,DlDtlPrvsnRwID	[int]	NULL
,DlDtlPrvsnRwID2	[int]	NULL
,DlDtlPrvsnRwID3	[int]	NULL
,DlDtlTmplteID	[int]	NULL
,DlvyProductA	[varchar](500)	NULL
,Ele	[varchar](50)	NULL
,Energy	[float]	NULL
,EstimatedMovementDate	datetime	null
,EstPmtDate	[datetime]	NULL
,ExposureID	[int]	IDENTITY(1,1)
,ExposureType	varchar(1)	null
,ExternalBAID	[int]	NULL
,FlatPriceOrBasis	varchar(12)	NULL
,FloatPnl	[float]	NULL
,FloatPosition	[float]	NULL
,FwdAmountA	[float]	NULL
,Ile	[varchar](50)	NULL
,InitDealPrice	float	NULL
,InitialDealVolume	[float]	NULL
,InitSysPrice	[int]	NULL
,InitSysVolume	[int]	NULL
,InternalBAID	[int]	NULL
,InvoiceNumber	[varchar](20)	NULL
,LocaleID	[int]	NULL
,MarketCrrncyID	[int]	NULL
,MarketCurrency	varchar(20)	NULL
,MarketPerUnitValue	[float]	NULL
,MarketValue	[float]	NULL
,MarketValueFXConversionDate	[datetime]	NULL
,MarketValueIsMissing	[bit]	NULL
,MaxPeriodStartDate	[datetime]	NULL
,MethodofTransportation	varchar(20)	NULL
,MovementStatus	varchar(20)	null
,MTMRunType	[varchar](2)	NULL
,PaymentCrrncyID	[int]	NULL
,PaymentCurrency	varchar(20)	NULL
,PerUnitValue	[float]	NULL
,Portfolio	[varchar](50)	NULL
,Position	[float]	null
,PriceDescription	[varchar](128)	NULL
,PricedInPercentage	[float]	NULL
,PricedInPerUnitValue	[float]	NULL
,PricedPnL	[float]	NULL
,PricedValueFXRate	[float]	NULL
,PriceProductA	[varchar] (1024)	NULL
,PriceType	varchar(100)	null
,PricingSeq	[int]	NULL
,Product	varchar(40)	NULL
,ProductID	[int]	NULL
,Provision	varchar(80)	NULL
,RD	varchar(1)	null
,RiskAdjustmentID	[int]	NULL
,RiskID	[int]	NULL
,RiskPriceIdentifierID	[int]	NULL
,RunDate	[datetime]	NULL
,SalesInvoiceNumber	[varchar](20)	NULL
,SentToMSAP	[bit]	NULL
,SentToParagon	[bit]	NULL
,SettledAmountA	[float]	NULL
,SettledVolumeA	[float]	NULL
,SnapshotID	[int]	NULL
,SnapshotInstanceDateTime	[datetime]	NULL
,SnapshotIsArchived	[bit]	NULL
,SoldTo	[varchar](20)	NULL
,Source	varchar(50)	null
,SourceSystem	[varchar](20)	NULL
,SourceTable	[varchar](2)	NULL
,SpecificGravity	[float]	NULL
,StrategyID	[int]	NULL
,TemplateName	varchar(100)	NULL
,TimeBasedDlDtlPrvsnRwID	[int]	NULL
,TmplteSrceTpe	[varchar](20)	NULL
,TotalPnL	[float]	NULL
,TotalQuantity	float	null
,TotalValueFXRate	[float]	NULL
,Trader	[varchar](42)	NULL
,TradeTag	[varchar](120)	NULL
,TradeType	[varchar](100)	NULL
,TransDate	[datetime]	NULL
,UserID	[int]	NULL
,VolumeUOM	[varchar](20)	NULL
	 CONSTRAINT [ExposureArchID] PRIMARY KEY CLUSTERED 
(
	[ExposureID] ASC
)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
