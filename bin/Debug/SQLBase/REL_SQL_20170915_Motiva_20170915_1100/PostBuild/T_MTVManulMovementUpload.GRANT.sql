/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVManulMovementUpload]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVManulMovementUpload.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVManulMovementUpload]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVManulMovementUpload] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVManulMovementUpload >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVManulMovementUpload >>>'


