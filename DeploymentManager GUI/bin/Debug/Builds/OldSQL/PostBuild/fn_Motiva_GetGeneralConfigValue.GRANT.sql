/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  MTV_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_GetGeneralConfigValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_GetGeneralConfigValue.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetGeneralConfigValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetGeneralConfigValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function MTV_GetGeneralConfigValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function MTV_GetGeneralConfigValue >>>'

