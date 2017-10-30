/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPSoldToShipToClassification WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPSoldToShipToClassification]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPSoldToShipToClassification.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPSoldToShipToClassification]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPSoldToShipToClassification] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPSoldToShipToClassification >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPSoldToShipToClassification >>>'
