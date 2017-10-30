/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxMovementTransactionData WITH YOUR function (NOTE:  CompanyName_FN_ is already set*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_TaxMovementTransactionData]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TaxMovementTransactionData.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxMovementTransactionData]') IS NOT NULL
  BEGIN
    GRANT  SELECT   ON dbo.MTV_TaxMovementTransactionData TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function MTV_TaxMovementTransactionData >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function MTV_TaxMovementTransactionData >>>'
