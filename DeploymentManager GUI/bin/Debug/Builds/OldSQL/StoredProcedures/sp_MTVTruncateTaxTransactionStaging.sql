/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVTruncateTaxTransactionStaging WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTVTruncateTaxTransactionStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTruncateTaxTransactionStaging.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTruncateTaxTransactionStaging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVTruncateTaxTransactionStaging] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVTruncateTaxTransactionStaging >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVTruncateTaxTransactionStaging] WITH EXECUTE AS 'dbo'
AS
	TRUNCATE TABLE dbo.MTVDataLakeTaxTransactionStaging
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVTruncateTaxTransactionStaging]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVTruncateTaxTransactionStaging.sql'
			PRINT '<<< ALTERED StoredProcedure MTVTruncateTaxTransactionStaging >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVTruncateTaxTransactionStaging >>>'
	  END