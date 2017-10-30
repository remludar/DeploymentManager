/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_CorrectBillingTermOnInvoices WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FedTax_CorrectBillingTermOnInvoices]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FedTax_CorrectBillingTermOnInvoices.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_CorrectBillingTermOnInvoices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FedTax_CorrectBillingTermOnInvoices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FedTax_CorrectBillingTermOnInvoices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FedTax_CorrectBillingTermOnInvoices >>>'

