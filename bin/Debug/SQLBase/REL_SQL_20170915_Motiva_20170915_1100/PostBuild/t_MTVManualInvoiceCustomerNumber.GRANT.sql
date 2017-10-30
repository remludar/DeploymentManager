PRINT 'Start Script=t_MTVManualInvoiceCustomerNumber.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVManualInvoiceCustomerNumber]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVManualInvoiceCustomerNumber] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVManualInvoiceCustomerNumber >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVManualInvoiceCustomerNumber >>>'
GO

