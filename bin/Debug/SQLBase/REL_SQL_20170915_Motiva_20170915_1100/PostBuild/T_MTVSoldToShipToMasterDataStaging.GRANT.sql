/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSoldToMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSoldToShipToMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSoldToShipToMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].MTVSoldToShipToMasterDataStaging to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSoldToShipToMasterDataStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSoldToShipToMasterDataStaging >>>'
