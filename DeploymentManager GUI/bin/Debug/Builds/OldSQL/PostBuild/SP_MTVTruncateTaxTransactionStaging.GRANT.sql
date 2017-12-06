/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVTruncateTaxTransactionStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTruncateTaxTransactionStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVTruncateTaxTransactionStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTruncateTaxTransactionStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVTruncateTaxTransactionStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVTruncateTaxTransactionStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVTruncateTaxTransactionStaging >>>'

