/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_reset_last_accountcoded_accountdetail WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_reset_last_accountcoded_accountdetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_reset_last_accountcoded_accountdetail.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_reset_last_accountcoded_accountdetail]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_reset_last_accountcoded_accountdetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_reset_last_accountcoded_accountdetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_reset_last_accountcoded_accountdetail >>>'

