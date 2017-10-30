/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSMovementStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTMSMovementStaging.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSHeaderRawData]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSHeaderRawData] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSHeaderRawData >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSHeaderRawData >>>'

IF  OBJECT_ID(N'[dbo].[MTVTMSProductRawData]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSProductRawData] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSProductRawData >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSProductRawData >>>'


IF  OBJECT_ID(N'[dbo].[MTVTMSMovementStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSMovementStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSMovementStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSMovementStaging >>>'

