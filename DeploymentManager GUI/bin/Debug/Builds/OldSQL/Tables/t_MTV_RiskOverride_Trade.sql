/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTV_RiskOverride_Trade WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_RiskOverride_Trade]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_RiskOverride_Trade.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTV_RiskOverride_Trade]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTV_RiskOverride_Trade]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTV_RiskOverride_Trade]
    PRINT '<<< DROPPED TABLE MTV_RiskOverride_Trade >>>'
END


/****** Object:  Table [dbo].[MTV_RiskOverride_Trade]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTV_RiskOverride_Trade](
	[P_EODEstmtedAccntDtlVleID] [int] NOT NULL,
	[P_EODSnpShtID_From] [int] NOT NULL,
	[TradeUOM] [int] NULL,
	[TradeValue] [decimal](19, 6) NULL,
	[TradeCrrncyID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[CreationDate] [smalldatetime] NOT NULL,
	[Comments] [varchar](2000) NULL
)
GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTV_RiskOverride_Trade]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTV_RiskOverride_Trade.sql'
    PRINT '<<< CREATED TABLE MTV_RiskOverride_Trade >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTV_RiskOverride_Trade >>>'

