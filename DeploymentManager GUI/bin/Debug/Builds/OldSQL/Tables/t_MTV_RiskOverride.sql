/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTV_RiskOverride WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_RiskOverride]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_RiskOverride.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTV_RiskOverride]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTV_RiskOverride]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTV_RiskOverride]
    PRINT '<<< DROPPED TABLE MTV_RiskOverride >>>'
END


/****** Object:  Table [dbo].[MTV_RiskOverride]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTV_RiskOverride](
	[EndOfDay] [smalldatetime] NOT NULL,
	[P_EODEstmtedAccntDtlID] [int] NOT NULL,
	[MarketUOM] [int] NOT NULL,
	[MarketValue] [decimal](19, 6) NOT NULL,
	[MarketCrrncyID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[CreationDate] [smalldatetime] NOT NULL,
	[Comments] [varchar](2000) NULL
)

GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTV_RiskOverride]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTV_RiskOverride.sql'
    PRINT '<<< CREATED TABLE MTV_RiskOverride >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTV_RiskOverride >>>'

