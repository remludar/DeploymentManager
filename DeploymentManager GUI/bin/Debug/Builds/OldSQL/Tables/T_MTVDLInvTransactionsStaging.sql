/*
*****************************************************************************************************
--USE FIND AND REPLACE ON CompanyNameTABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDLInvTransactionsStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDLInvTransactionsStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDLInvTransactionsStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDLInvTransactionsStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDLInvTransactionsStaging]
    PRINT '<<< DROPPED TABLE MTVDLInvTransactionsStaging >>>'
END


/****** Object:  Table [dbo].[MTVDLInvTransactionsStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create table MTVDLInvTransactionsStaging
			(
			ID												Int	IDENTITY,
			AccountingMonth									Varchar(20),
			CompanyCode										Varchar(255),
			MaterialNumber									Varchar(255),
			ProductGroup									Varchar(150),
			Subgroup										Varchar(150),
			Product											Varchar(20),
			Location										Varchar(120),
			MaterialDesc									Varchar(150),
			FTAProductCode									Varchar(255),
			PlantNumber										Varchar(255),
			RATaxCommodity									Varchar(255),
			DealNumber										Varchar(20),
			DetailNumber									Int,
			Strategy										Varchar(120),
			MaterialDocument								Varchar(80),
			PostingDateInDoc								Smalldatetime,
			ReceiptQuantity									Float,
			DisbursementQuantity							Float,
			ThirdPartyFlag									Char(1),
			PositionHolderName								Varchar(70),
			PositionHolderFEIN								Varchar(255),
			PositionHolderNameControl						Varchar(255),
			PositionHolderID								Varchar(255),
			Value											Float,
			UOM												Varchar(20),
			TransactionType									Varchar(80),
			MovementDocumentDate							Smalldatetime,
			MovementType									Varchar(40),
			VendorNumber									Varchar(255),
			OriginLocale									Varchar(150),
			OriginCity										Varchar(255),
			OriginState										Varchar(255),
			OriginTCN										Varchar(255),
			DestinationLocale								Varchar(150),
			DestinationCity									Varchar(255),
			DestinationState								Varchar(255),
			DestinationTCN									Varchar(255),
			TitleTransferLocale								Varchar(150),
			CostType										Char(1),
			DealType										Varchar(80),
			StagingTableLoadDate							Smalldatetime,
			Status											Char(1)

CONSTRAINT [PK_MTVDLInvTransactionsStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDLInvTransactionsStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDLInvTransactionsStaging.sql'
    PRINT '<<< CREATED TABLE MTVDLInvTransactionsStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDLInvTransactionsStaging >>>'

