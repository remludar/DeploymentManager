PRINT 'Start Script=MTV_DLInvStaging_Purge.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStaging_Purge]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_DLInvStaging_Purge TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_DLInvStaging_Purge >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_DLInvStaging_Purge >>>'
GO
