/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Market_Insert WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Override_Market_Insert]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Market_Insert.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Market_Insert]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Override_Market_Insert TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Override_Market_Insert >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Override_Market_Insert >>>'

