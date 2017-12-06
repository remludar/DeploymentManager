PRINT 'Start Script=sp_MTV_MTVProcessMovementLifeCycle.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVProcessMovementLifeCycle]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVProcessMovementLifeCycle TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVProcessMovementLifeCycle >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVProcessMovementLifeCycle >>>'
GO
