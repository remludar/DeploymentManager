PRINT 'Start Script=MTV_ClearPendingSAP.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ClearPendingSAP]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ClearPendingSAP TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ClearPendingSAP >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ClearPendingSAP >>>'
GO
