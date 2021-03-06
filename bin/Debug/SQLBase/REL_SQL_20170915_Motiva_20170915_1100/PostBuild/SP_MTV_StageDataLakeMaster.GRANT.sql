/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_StageDataLakeMaster WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_StageDataLakeMaster]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_StageDataLakeMaster.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_StageDataLakeMaster]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_StageDataLakeMaster TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_StageDataLakeMaster >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_StageDataLakeMaster >>>'
GO
