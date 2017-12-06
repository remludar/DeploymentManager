/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FedTax_HoldErroneousInvoices WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FedTax_HoldErroneousInvoices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FedTax_HoldErroneousInvoices.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FedTax_HoldErroneousInvoices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FedTax_HoldErroneousInvoices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FedTax_HoldErroneousInvoices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FedTax_HoldErroneousInvoices >>>'

