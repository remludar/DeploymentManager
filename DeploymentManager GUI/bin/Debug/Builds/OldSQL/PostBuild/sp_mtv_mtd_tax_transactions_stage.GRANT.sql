/*
*****************************************************************************************************
USE FIND AND REPLACE ON tax_transactions_stage WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_mtd_tax_transactions_stage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_mtd_tax_transactions_stage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_mtd_tax_transactions_stage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_mtd_tax_transactions_stage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_mtd_tax_transactions_stage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_mtd_tax_transactions_stage >>>'
GO



