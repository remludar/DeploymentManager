/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTaxTransactions WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_IncrementalTaxTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTaxTransactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTaxTransactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_IncrementalTaxTransactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_IncrementalTaxTransactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_IncrementalTaxTransactions >>>'
GO



