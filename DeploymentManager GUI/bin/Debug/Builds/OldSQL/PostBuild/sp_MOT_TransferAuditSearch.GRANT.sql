PRINT 'Start Script=MOT_TransferAuditSearch.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_TransferAuditSearch]') IS NOT NULL
BEGIN
    GRANT  EXECUTE  ON dbo.MOT_TransferAuditSearch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_TransferAuditSearch >>>' 
END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_TransferAuditSearch >>>'
GO


