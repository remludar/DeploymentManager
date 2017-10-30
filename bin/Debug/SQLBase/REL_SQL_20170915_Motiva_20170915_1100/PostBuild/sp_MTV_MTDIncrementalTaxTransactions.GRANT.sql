/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_MTDIncrementalTaxTransactions WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_MTDIncrementalTaxTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_MTDIncrementalTaxTransactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_MTDIncrementalTaxTransactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_MTDIncrementalTaxTransactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_MTDIncrementalTaxTransactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_MTDIncrementalTaxTransactions >>>'
GO



