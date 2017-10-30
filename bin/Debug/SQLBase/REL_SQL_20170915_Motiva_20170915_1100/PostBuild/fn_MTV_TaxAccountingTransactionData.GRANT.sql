/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxAccountingTransactionData WITH YOUR function (NOTE:  CompanyName_FN_ is already set*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_TaxAccountingTransactionData]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TaxAccountingTransactionData.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxAccountingTransactionData]') IS NOT NULL
  BEGIN
    GRANT  SELECT   ON dbo.MTV_TaxAccountingTransactionData TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function MTV_TaxAccountingTransactionData >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function MTV_TaxAccountingTransactionData >>>'
