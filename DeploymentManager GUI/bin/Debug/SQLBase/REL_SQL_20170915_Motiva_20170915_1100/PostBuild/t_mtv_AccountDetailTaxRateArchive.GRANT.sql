/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[mtv_AccountDetailTaxRateArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_AccountDetailTaxRateArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_AccountDetailTaxRateArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].mtv_AccountDetailTaxRateArchive to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table mtv_AccountDetailTaxRateArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table mtv_AccountDetailTaxRateArchive >>>'


