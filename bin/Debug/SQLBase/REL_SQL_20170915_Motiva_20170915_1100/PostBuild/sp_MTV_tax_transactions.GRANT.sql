/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVApplyStagingTableUpdatesToDealDetailShipToTable WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_tax_transactions.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_tax_transactions]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_tax_transactions TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_tax_transactions >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_tax_transactions >>>'
GO
