/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_BaseOilsOrderConfirmation 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_BaseOilsOrderConfirmation]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_BaseOilsOrderConfirmation.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_BaseOilsOrderConfirmation]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_BaseOilsOrderConfirmation TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_BaseOilsOrderConfirmation >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_BaseOilsOrderConfirmation >>>'
GO
