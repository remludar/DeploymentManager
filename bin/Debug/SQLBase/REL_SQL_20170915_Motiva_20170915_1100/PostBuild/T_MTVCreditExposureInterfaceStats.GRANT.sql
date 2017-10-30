/*
*****************************************************************************************************
--USE FIND AND REPLACE ON [MTVCreditExposureInterfaceStats] 
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVCreditExposureInterfaceStats]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVCreditExposureInterfaceStats.GRANT.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditExposureInterfaceStats]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCreditExposureInterfaceStats] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table [MTVCreditExposureInterfaceStats] >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table [MTVCreditExposureInterfaceStats] >>>'
GO
