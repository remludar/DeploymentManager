PRINT 'Start Script=MTV_GetTempRiskExposure.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetTempRiskExposure]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetTempRiskExposure TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetTempRiskExposure >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetTempRiskExposure >>>'
GO
