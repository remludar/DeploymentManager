/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVRetailerInvoicePreStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVRetailerInvoicePreStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailerInvoicePreStage]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVRetailerInvoicePreStage] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVRetailerInvoicePreStage >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVRetailerInvoicePreStage >>>'


