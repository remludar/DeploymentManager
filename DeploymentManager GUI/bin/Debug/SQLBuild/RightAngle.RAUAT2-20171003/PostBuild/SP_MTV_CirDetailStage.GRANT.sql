/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_CirDetailStage WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_CirDetailStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_CirDetailStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CirDetailStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CirDetailStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CirDetailStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CirDetailStage >>>'

