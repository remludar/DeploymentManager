/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTaxAccountingTransactions WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_IncrementalTaxAccountingTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTaxAccountingTransactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTaxAccountingTransactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_IncrementalTaxAccountingTransactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_IncrementalTaxAccountingTransactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_IncrementalTaxAccountingTransactions >>>'
GO
