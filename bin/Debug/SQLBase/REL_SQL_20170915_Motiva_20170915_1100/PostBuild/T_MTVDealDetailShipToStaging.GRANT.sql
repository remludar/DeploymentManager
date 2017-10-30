/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealDetailShipToStaging WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealDetailShipToStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailShipToStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealDetailShipToStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDealDetailShipToStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealDetailShipToStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealDetailShipToStaging >>>'
