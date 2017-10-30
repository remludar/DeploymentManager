/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVTruncateMTVRetailerInvoicePreStage WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTruncateMTVRetailerInvoicePreStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVTruncateMTVRetailerInvoicePreStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTruncateMTVRetailerInvoicePreStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVTruncateMTVRetailerInvoicePreStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVTruncateMTVRetailerInvoicePreStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVTruncateMTVRetailerInvoicePreStage >>>'

