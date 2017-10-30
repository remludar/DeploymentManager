/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_EventDate_Or_MovementDate WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Get_EventDate_Or_MovementDate]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_EventDate_Or_MovementDate.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_EventDate_Or_MovementDate]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Get_EventDate_Or_MovementDate TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Get_EventDate_Or_MovementDate >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Get_EventDate_Or_MovementDate >>>'

