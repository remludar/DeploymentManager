/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDataLakeTaxTransactionStagingArchive WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeTaxTransactionStagingArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeTaxTransactionStagingArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDataLakeTaxTransactionStagingArchive]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTaxTransactionStagingArchive]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDataLakeTaxTransactionStagingArchive]
    PRINT '<<< DROPPED TABLE [MTVDataLakeTaxTransactionStagingArchive >>>'
END

/****** Object:  Table [dbo].[MTVDataLakeTaxTransactionStagingArchive]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVDataLakeTaxTransactionStagingArchive
	(
	 DataLakeTransID			INT	IDENTITY
	,XHrdID						INT	
	,AcctDtlID					INT		
	,UserID						INT
	,PublishedDate				SMALLDATETIME			
CONSTRAINT [PK_MTVDataLakeTaxTransactionStagingArchive] PRIMARY KEY CLUSTERED 
(
	[DataLakeTransID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Index [DataLakeID]    Script Date: 7/21/2015 8:46:37 AM ******/
CREATE NONCLUSTERED INDEX [DataLakeTransID] ON [dbo].[MTVDataLakeTaxTransactionStagingArchive]
(
	[DataLakeTransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTaxTransactionStagingArchive]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDataLakeTaxTransactionStagingArchive.sql'
    PRINT '<<< CREATED TABLE MTVDataLakeTaxTransactionStagingArchive >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDataLakeTaxTransactionStagingArchive >>>'


