/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSCTExchangeReportExternalColumn WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSCTExchangeReportExternalColumn]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSCTExchangeReportExternalColumn.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSCTExchangeReportExternalColumn]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVSCTExchangeReportExternalColumn]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVSCTExchangeReportExternalColumn]
    PRINT '<<< DROPPED TABLE [MTVSCTExchangeReportExternalColumn >>>'
END


/****** Object:  Table [dbo].[MTVSCTExchangeReportExternalColumn]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVSCTExchangeReportExternalColumn
	(
	 ID					INT	IDENTITY
	 ,DlDtlDlHdrID      INT
	 ,DlDtlID			SMAllint
	 ,ChemicalID		INT
	 ,InventoryDt		datetime
	 ,PlnndTrnsfrID		INT
	 ,Planned			float
	 ,BulkPayBack		float
CONSTRAINT [PK_MTVSCTExchangeReportExternalColumn] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVSCTExchangeReportExternalColumn]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVSCTExchangeReportExternalColumn.sql'
    PRINT '<<< CREATED TABLE MTVSCTExchangeReportExternalColumn >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVSCTExchangeReportExternalColumn >>>'


