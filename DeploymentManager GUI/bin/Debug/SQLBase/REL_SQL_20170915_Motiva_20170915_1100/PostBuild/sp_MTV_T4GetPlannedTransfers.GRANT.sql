/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_T4GetPlannedTransfers]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_T4GetPlannedTransfers.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_T4GetPlannedTransfers]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_T4GetPlannedTransfers TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_T4GetPlannedTransfers >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_T4GetPlannedTransfers >>>'
GO
