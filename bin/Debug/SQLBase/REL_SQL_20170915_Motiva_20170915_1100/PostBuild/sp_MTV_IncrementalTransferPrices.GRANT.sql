/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTransferPrices WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_IncrementalTransferPrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTransferPrices.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTransferPrices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_IncrementalTransferPrices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_IncrementalTransferPrices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_IncrementalTransferPrices >>>'
GO



