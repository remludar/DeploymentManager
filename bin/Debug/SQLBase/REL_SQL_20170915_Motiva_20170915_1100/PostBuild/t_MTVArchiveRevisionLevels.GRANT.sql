
/****** Object:  ViewName [dbo].[MTVArchiveRevisionLevels]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVArchiveRevisionLevels.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveRevisionLevels]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVArchiveRevisionLevels TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVArchiveRevisionLevels >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVArchiveRevisionLevels >>>'

