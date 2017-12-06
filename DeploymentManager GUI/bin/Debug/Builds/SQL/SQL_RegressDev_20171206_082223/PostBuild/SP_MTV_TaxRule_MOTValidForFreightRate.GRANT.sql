/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxRule_MOTValidForFreightRate WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_TaxRule_MOTValidForFreightRate]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TaxRule_MOTValidForFreightRate.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxRule_MOTValidForFreightRate]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_TaxRule_MOTValidForFreightRate TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_TaxRule_MOTValidForFreightRate >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_TaxRule_MOTValidForFreightRate >>>'

