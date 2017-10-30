/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchAccountingTxnDataExtract WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchAccountingTxnDataExtract]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchAccountingTxnDataExtract.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchAccountingTxnDataExtract]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SearchAccountingTxnDataExtract TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SearchAccountingTxnDataExtract >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SearchAccountingTxnDataExtract >>>'
GO
