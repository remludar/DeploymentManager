/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Trade_Delete WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Override_Trade_Delete]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Trade_Delete.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Trade_Delete]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Override_Trade_Delete TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Override_Trade_Delete >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Override_Trade_Delete >>>'

