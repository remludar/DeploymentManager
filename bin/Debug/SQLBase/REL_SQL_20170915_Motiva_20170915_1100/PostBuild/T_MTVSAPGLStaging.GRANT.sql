/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPGLStaging WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPGLStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPGLStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPGLStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPGLStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPGLStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPGLStaging >>>'
