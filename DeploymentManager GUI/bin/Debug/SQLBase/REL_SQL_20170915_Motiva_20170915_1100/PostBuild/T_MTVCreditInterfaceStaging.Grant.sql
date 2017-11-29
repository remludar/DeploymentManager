/*
*****************************************************************************************************
--USE FIND AND REPLACE ON T_MTVCreditInterfaceStaging 
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVCreditInterfaceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVCreditInterfaceStaging.GRANT.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditInterfaceStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCreditInterfaceStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVCreditInterfaceStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVCreditInterfaceStaging >>>'
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditInterfaceStagingArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCreditInterfaceStagingArchive] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVCreditInterfaceStagingArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVCreditInterfaceStagingArchive >>>'
