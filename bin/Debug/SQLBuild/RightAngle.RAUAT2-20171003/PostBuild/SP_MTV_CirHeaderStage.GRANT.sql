/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_CirHeaderStage WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_CirHeaderStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_CirHeaderStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CirHeaderStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CirHeaderStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CirHeaderStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CirHeaderStage >>>'

