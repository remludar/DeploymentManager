/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Credit_Interface_Extract]    Script Date: DATECREATED ******/
PRINT 'Start Script=[MTV_Credit_Interface_Extract].sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Credit_Interface_Extract]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.[MTV_Credit_Interface_Extract] TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure [MTV_Credit_Interface_Extract] >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure [MTV_Credit_Interface_Extract] >>>'