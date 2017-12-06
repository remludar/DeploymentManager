/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVUpdateDealDetailShipToDealDetailID WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVUpdateDealDetailShipToDealDetailID]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVUpdateDealDetailShipToDealDetailID.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUpdateDealDetailShipToDealDetailID]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVUpdateDealDetailShipToDealDetailID TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVUpdateDealDetailShipToDealDetailID >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVUpdateDealDetailShipToDealDetailID >>>'
GO
