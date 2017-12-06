/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVPriceLoad WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPriceLoad]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPriceLoad.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVPriceLoad]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVPriceLoad]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVPriceLoad]
    PRINT '<<< DROPPED TABLE MTVPriceLoad >>>'
END


/****** Object:  Table [dbo].[MTVPriceLoad]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE dbo.MTVPriceLoad
	(
	MTVPLID					INT	IDENTITY
	,ServiceType			VARCHAR(50)
	,PriceServiceName		VARCHAR(50)
	,RPHdrID				INT
	,LocationAbbreviation	VARCHAR(120)
	,RPLcleLcleID			INT
	,ToLocationAbbreviation	VARCHAR(120)
	,ToLcleID				INT
	,ProductAbbreviation	VARCHAR(80)
	,RPDtlRPLcleChmclParPrdctID INT
	,CurrencyAbbreviation	VARCHAR(20)
	,RPDtlCrrncyID			INT
	,UOMAbbreviation		VARCHAR(20)
	,RPDtlUOM				SMALLINT
	,CurveName				VARCHAR(500)
	,InterfaceCode			VARCHAR(100)
	,RwPrceLcleID			INT
	,QuoteFromDate			VARCHAR(50)
	,QuoteToDate			VARCHAR(50)
	,TradeFromDate			VARCHAR(50)
	,TradeToDate			VARCHAR(50)
	,TradePeriod			VARCHAR(50)
	,VETradePeriod			INT
	,Actual_Estimate		VARCHAR(12)
	,RPDtlTpe				VARCHAR(1)
	--,Status				VARCHAR(12)
	,RequestingUserName		VARCHAR(80)
	,RPDtlRqstngUserID		INT
	,EntryUserName			VARCHAR(80)
	,RPDtlEntryUserID		INT
	,EntryDate				VARCHAR(50)
	,ApprovingUserName		VARCHAR(80)
	,RPDtlApprvngUserID		INT
	,ApprovalDate			VARCHAR(50)
	,Note					VARCHAR(MAX)
	,GravityTableName		VARCHAR(50)
	,GrvtyTbleID			INT
	,QuotedGravity			VARCHAR(50)
	,PublicationDate		VARCHAR(50)
	,Source					VARCHAR(50)
	,IsMissingPrice			VARCHAR(3)
	,PriceType				VARCHAR(50)
	,PriceTypeIdnty			SMALLINT
	,Value					VARCHAR(20)
	,PriceExists			CHAR(1)
	,InterfaceDate			SMALLDATETIME
	,LoadStatus				CHAR(1)
	,LoadDate				SMALLDATETIME
	,Message				VARCHAR(MAX)
	
	
 CONSTRAINT [PK_MTVPriceLoad] PRIMARY KEY CLUSTERED 
(
	[MTVPLID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVPriceLoad]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVPriceLoad.sql'
    PRINT '<<< CREATED TABLE MTVPriceLoad >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVPriceLoad >>>'

