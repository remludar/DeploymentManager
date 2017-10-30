/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_T4ProcessOrderSaved]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_T4ProcessOrderSaved.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_T4ProcessOrderSaved]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_T4ProcessOrderSaved TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_T4ProcessOrderSaved >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_T4ProcessOrderSaved >>>'
GO
