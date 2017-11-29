/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPSoldToShipTo WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPSoldToShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPSoldToShipTo.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPSoldToShipTo]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPSoldToShipTo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPSoldToShipTo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPSoldToShipTo >>>'
