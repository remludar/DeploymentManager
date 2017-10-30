PRINT 'Start Script=MTV_SAPStaging_Purge.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAPStaging_Purge]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAPStaging_Purge TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAPStaging_Purge >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAPStaging_Purge >>>'
GO
