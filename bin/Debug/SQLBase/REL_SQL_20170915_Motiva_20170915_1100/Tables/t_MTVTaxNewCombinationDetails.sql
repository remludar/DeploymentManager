/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTaxNewCombinations WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTaxNewCombinationDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTaxNewCombinationDetail.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTaxNewCombinationDetail]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTaxNewCombinationDetail]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].MTVTaxNewCombinationDetail
    PRINT '<<< DROPPED TABLE MTVTaxNewCombinationDetail >>>'
END




/****** Object:  Table [dbo].[MTVTaxNewCombinationDetail]    Script Date: 12/16/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



IF  OBJECT_ID(N'[dbo].[MTVTaxNewCombinationDetail]') IS NOT NULL
    DROP TABLE [dbo].MTVTaxNewCombinationDetail 
    --movementheaderarchive
create table dbo.MTVTaxNewCombinationDetail
( ID INT Identity(1,1) NOT NULL
, DealDetailID int null
, XhdrID int null
, SoldTo varchar(10) null
, ShipTo varchar(10) null
, OriginLcleID int null
, DestinationLcleID int null
, LastUpdateDate [DateTime]  NOT NULL
, IsNew [CHAR] (1)  NULL

CONSTRAINT [PK_MTVTaxNewCombinationDetail]	PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GO

SET ANSI_PADDING OFF
GO

IF  exists ( select 'x' from sysobjects where name = 'MTVTaxNewCombinationDetail')
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTaxNewCombinationDetail.sql'
    PRINT '<<< CREATED TABLES MTVTaxNewCombinationDetail >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLES MTVTaxNewCombinationDetail >>>'

GO

