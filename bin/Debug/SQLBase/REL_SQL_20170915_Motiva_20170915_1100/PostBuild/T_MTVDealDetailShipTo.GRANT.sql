/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealDetailShipTo WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealDetailShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailShipTo.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealDetailShipTo]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVDealDetailShipTo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealDetailShipTo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealDetailShipTo >>>'
