/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVFPSFuelSalesVolStaging WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVFPSFuelSalesVolStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVFPSFuelSalesVolStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSFuelSalesVolStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSFuelSalesVolStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSFuelSalesVolStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSFuelSalesVolStaging >>>'


