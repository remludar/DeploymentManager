PRINT 'Start Script=sp_MTVNonDuplicateBOLsForMovementLifeCycle.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVNonDuplicateBOLsForMovementLifeCycle]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVNonDuplicateBOLsForMovementLifeCycle TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVNonDuplicateBOLsForMovementLifeCycle >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVNonDuplicateBOLsForMovementLifeCycle >>>'
GO
