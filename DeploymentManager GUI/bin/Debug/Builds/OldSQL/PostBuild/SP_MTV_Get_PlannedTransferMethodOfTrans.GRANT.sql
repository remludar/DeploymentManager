/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_PlannedTransferMethodOfTrans WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Get_PlannedTransferMethodOfTrans]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_PlannedTransferMethodOfTrans.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_PlannedTransferMethodOfTrans]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Get_PlannedTransferMethodOfTrans TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Get_PlannedTransferMethodOfTrans >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Get_PlannedTransferMethodOfTrans >>>'

