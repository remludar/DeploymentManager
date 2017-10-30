/*
*****************************************************************************************************
USE FIND AND REPLACE ON ManualBOLXRef WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_ManualBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ManualBOLXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ManualBOLXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ManualBOLXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ManualBOLXRef >>>'
GO
