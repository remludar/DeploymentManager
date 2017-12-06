/*
*****************************************************************************************************
--USE FIND AND REPLACE ON CompanyNameTABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDLInvPricesStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDLInvPricesStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDLInvPricesStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDLInvPricesStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDLInvPricesStaging]
    PRINT '<<< DROPPED TABLE MTVDLInvPricesStaging >>>'
END


/****** Object:  Table [dbo].[MTVDLInvPricesStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create table MTVDLInvPricesStaging
			(
			ID						Int	IDENTITY,
			AccountingMonth			Varchar(20),
			Product					Varchar(20),
			Location				Varchar(120),
			ProductGroup			Varchar(150),
			PriceService			Varchar(20),
			Subgroup				Varchar(150),
			Currency				Char(3),
			QuoteFromDate			Smalldatetime,
			QuoteToDate				Smalldatetime,
			DeliveryPeriod			Int,
			Price					Decimal(19,6),
			UOM						Varchar(20),
			StagingTableLoadDate	Smalldatetime,
			Status					Char(1)

CONSTRAINT [PK_MTVDLInvPricesStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDLInvPricesStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDLInvPricesStaging.sql'
    PRINT '<<< CREATED TABLE MTVDLInvPricesStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDLInvPricesStaging >>>'

