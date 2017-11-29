/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVExtractTaxRulesSP]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVExtractTaxRulesSP.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVExtractTaxRulesSP]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVExtractTaxRulesSP TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVExtractTaxRulesSP >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVExtractTaxRulesSP >>>'
