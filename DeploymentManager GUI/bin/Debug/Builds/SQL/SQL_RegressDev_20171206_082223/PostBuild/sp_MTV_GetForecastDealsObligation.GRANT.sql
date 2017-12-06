PRINT 'Start Script=MTV_GetForecastDealsObligation.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetForecastDealsObligation]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetForecastDealsObligation TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetForecastDealsObligation >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetForecastDealsObligation >>>'
GO
