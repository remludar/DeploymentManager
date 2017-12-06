
/****** Object:  ViewName [dbo].[MTVSalesforceDLInvoicesStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVSalesforceDLInvoicesStaging.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDLInvoicesStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSalesforceDLInvoicesStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSalesforceDLInvoicesStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSalesforceDLInvoicesStaging >>>'
GO
