/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVCheckDealDetailShipTosForOutOfSyncIssues WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVCheckDealDetailShipTosForOutOfSyncIssues.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVCheckDealDetailShipTosForOutOfSyncIssues TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVCheckDealDetailShipTosForOutOfSyncIssues >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVCheckDealDetailShipTosForOutOfSyncIssues >>>'
GO
