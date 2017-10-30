/*
*****************************************************************************************************
--USE FIND AND REPLACE ON T_MTVRaToFpsRetailContractInterface 
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVRetailContractRAToFPSStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVRaToFpsRetailContractInterface.GRANT.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailContractRAToFPSStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVRetailContractRAToFPSStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVRetailContractRAToFPSStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVRetailContractRAToFPSStaging >>>'
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailContractInterfaceResults]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVRetailContractInterfaceResults] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVRetailContractInterfaceResults >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVRetailContractInterfaceResults >>>'
