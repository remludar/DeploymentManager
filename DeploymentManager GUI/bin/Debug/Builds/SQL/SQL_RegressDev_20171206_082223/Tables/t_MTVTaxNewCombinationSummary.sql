/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTaxNewCombinations WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTaxNewCombinationsSummary]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTaxNewCombinationSummary.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDealDetailShipToStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTaxNewCombinationSummary]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].MTVTaxNewCombinationSummary
    PRINT '<<< DROPPED TABLE MTVTaxNewCombinationSummary >>>'
END




/****** Object:  Table [dbo].[MTVTaxNewCombinationSummary]    Script Date: 12/16/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



IF  OBJECT_ID(N'[dbo].[MTVTaxNewCombinationSummary]') IS NOT NULL
    DROP TABLE [dbo].[MTVTaxNewCombinationSummary] 
    

create table dbo.MTVTaxNewCombinationSummary
( ID  [INT] IDENTITY(1,1) NOT NULL
, ExternalBaid [INT]   NULL
, SoldTo varchar(10)   NULL
, ShipTo varchar(10)  NULL
, PrdctID [INT]  NULL
, Originlcleid [INT]   NULL
, DestinationLcleid [INT]  NULL
, LastUpdateDate [DateTime]  NOT NULL

CONSTRAINT [PK_MTVTaxNewCombinationSummary]	PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF  OBJECT_ID(N'[dbo].[IX_MTVTaxNewCombinationSummary]') IS NOT NULL
    DROP INDEX [IX_MTVTaxNewCombinationSummary] on dbo.MTVTaxNewCombinationSummary
    
CREATE NONCLUSTERED INDEX [IX_MTVTaxNewCombinationSummary] ON [MTVTaxNewCombinationSummary] (ExternalBaid,SoldTo,ShipTo,PrdctID,OriginLcleID,DestinationLcleID)
GO

SET ANSI_PADDING OFF
GO

IF  exists ( select 'x' from sysobjects where name = 'MTVTaxNewCombinationSummary')
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTaxNewCombinationSummary.sql'
    PRINT '<<< CREATED TABLES MTVTaxNewCombinationsSummary >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLES MTVTaxNewCombinationsSummary >>>'

GO

