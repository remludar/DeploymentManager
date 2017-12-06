/*
*****************************************************************************************************
--USE FIND AND REPLACE ON CompanyNameTABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDLInvInventoryTransactionsStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDLInvInventoryTransactionsStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDLInvInventoryTransactionsStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDLInvInventoryTransactionsStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDLInvInventoryTransactionsStaging]
    PRINT '<<< DROPPED TABLE MTVDLInvInventoryTransactionsStaging >>>'
END


/****** Object:  Table [dbo].[MTVDLInvInventoryTransactionsStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create table MTVDLInvInventoryTransactionsStaging
			(
			ID												Int	IDENTITY,
			AccountingPeriod								Varchar(20),
			LogicalAccountingPeriod							Varchar(20),
			Location										Varchar(120),
			OriginLocale									Varchar(120),
			DestinationLocation								Varchar(120),
			Product											Varchar(20),
			MaterialNumber									Varchar(255),
			PlantCode										Varchar(255),
			Quantity										Float,
			UOM												Varchar(3),
			MovementDate									Smalldatetime,
			MovementDocumentExternalNumber					Varchar(80),
			DealNumber										Varchar(20),
			OurCompany										Varchar(45),
			TheirCompany									Varchar(45),
			SourceTable										Varchar(40),
			ReasonCode										Varchar(40),
			Direction										Char(1),
			Reversal										Char(1),
			StagingTableLoadDate							Smalldatetime,
			Status											Char(1)

CONSTRAINT [PK_MTVDLInvInventoryTransactionsStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDLInvInventoryTransactionsStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDLInvInventoryTransactionsStaging.sql'
    PRINT '<<< CREATED TABLE MTVDLInvInventoryTransactionsStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDLInvInventoryTransactionsStaging >>>'

