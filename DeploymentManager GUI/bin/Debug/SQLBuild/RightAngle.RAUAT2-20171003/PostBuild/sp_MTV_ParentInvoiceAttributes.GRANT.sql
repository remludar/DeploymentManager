PRINT 'Start Script=MTV_ParentInvoiceAttributes.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ParentInvoiceAttributes]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ParentInvoiceAttributes TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ParentInvoiceAttributes >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ParentInvoiceAttributes >>>'
GO
