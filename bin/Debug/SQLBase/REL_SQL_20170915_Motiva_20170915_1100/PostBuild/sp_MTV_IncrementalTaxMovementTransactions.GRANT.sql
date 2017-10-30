/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTaxMovementTransactions WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_IncrementalTaxMovementTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTaxMovementTransactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTaxMovementTransactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_IncrementalTaxMovementTransactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_IncrementalTaxMovementTransactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_IncrementalTaxMovementTransactions >>>'
GO
