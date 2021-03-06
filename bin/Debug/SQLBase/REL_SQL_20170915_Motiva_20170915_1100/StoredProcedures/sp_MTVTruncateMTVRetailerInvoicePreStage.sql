/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVTruncateMTVRetailerInvoicePreStage WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTVTruncateMTVRetailerInvoicePreStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTruncateMTVRetailerInvoicePreStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTruncateMTVRetailerInvoicePreStage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVTruncateMTVRetailerInvoicePreStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVTruncateMTVRetailerInvoicePreStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTVTruncateMTVRetailerInvoicePreStage] WITH EXECUTE AS 'dbo'
AS
	TRUNCATE TABLE dbo.MTVRetailerInvoicePreStage

	SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVTruncateMTVRetailerInvoicePreStage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVTruncateMTVRetailerInvoicePreStage.sql'
			PRINT '<<< ALTERED StoredProcedure MTVTruncateMTVRetailerInvoicePreStage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVTruncateMTVRetailerInvoicePreStage >>>'
	  END