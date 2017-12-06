PRINT 'Start Script=MTV_GetTempMarkToMarket.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetTempMarkToMarket]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetTempMarkToMarket TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetTempMarkToMarket >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetTempMarkToMarket >>>'
GO
