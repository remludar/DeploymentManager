/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTaxProvision WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTaxProvision]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTaxProvision.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTaxProvision]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTaxProvision]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVTaxProvision]
    PRINT '<<< DROPPED TABLE MTVTaxProvision >>>'
END


/****** Object:  Table [dbo].[MTVTaxProvision]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*REPLACE WITH YOUR TABLE CREATION CODE*/

CREATE TABLE [dbo].[MTVTaxProvision](
	[TxID] [int] NOT NULL,
	[TxRleStID] [int] NOT NULL,
	[Description] varchar(255) NOT NULL,
	[DlDtlPrvsnID] [int] NOT NULL)

INSERT INTO [MTVTaxProvision]([TxID],[TxRleStID],[Description],[DlDtlPrvsnID])
SELECT TP.[TxID],TP.[TxRleStID],[Description],[DlDtlPrvsnID]
FROM [TaxProvision] TP INNER JOIN [TaxRuleSet] TR ON TR.[TxRleStID] = TP.[TxRleStID]

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVTaxProvision]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTaxProvision.sql'
    PRINT '<<< CREATED TABLE MTVTaxProvision >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTaxProvision >>>'

