/*
*****************************************************************************************************
--USE FIND AND REPLACE ON Sequence WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSContractXRef_SupplierNo]    Script Date: DATECREATED ******/
PRINT 'Start Script=s_MTVTMSContractXRef_SupplierNo.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef_SupplierNo]') IS NOT NULL
  BEGIN
    GRANT  UPDATE ON [dbo].[MTVTMSContractXRef_SupplierNo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSContractXRef_SupplierNo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSContractXRef_SupplierNo >>>'

