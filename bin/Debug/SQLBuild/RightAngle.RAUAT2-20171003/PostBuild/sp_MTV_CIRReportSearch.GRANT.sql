PRINT 'Start Script=MTV_CIRReportSearch.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportSearch]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CIRReportSearch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CIRReportSearch >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CIRReportSearch >>>'
GO
