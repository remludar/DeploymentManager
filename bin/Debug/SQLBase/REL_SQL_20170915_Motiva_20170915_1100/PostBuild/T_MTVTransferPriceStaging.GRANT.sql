/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTransferPriceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTransferPriceStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTransferPriceStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTransferPriceStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTransferPriceStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTransferPriceStaging >>>'

