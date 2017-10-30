PRINT 'Start Script=MTV_CIRReportDetailSearch.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportDetailSearch]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CIRReportDetailSearch TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CIRReportDetailSearch >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CIRReportDetailSearch >>>'
GO
