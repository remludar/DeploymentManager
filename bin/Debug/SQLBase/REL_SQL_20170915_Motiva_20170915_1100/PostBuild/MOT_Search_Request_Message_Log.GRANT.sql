/*
*****************************************************************************************************
USE FIND AND REPLACE ON MOT_Search_Request_Message_Log WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MOT_Search_Request_Message_Log]    Script Date: DATECREATED ******/
PRINT 'Start Script=MOT_Search_Request_Message_Log.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_Search_Request_Message_Log]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MOT_Search_Request_Message_Log TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_Search_Request_Message_Log >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_Search_Request_Message_Log >>>'

