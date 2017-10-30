PRINT 'Start Script=MTV_CalcMvtQtySum.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CalcMvtQtySum]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CalcMvtQtySum TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CalcMvtQtySum >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CalcMvtQtySum >>>'
GO
