/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MTV_searchSATWithReportState]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_searchSATWithReportState.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_searchSATWithReportState]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTV_searchSATWithReportState TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTV_searchSATWithReportState >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTV_searchSATWithReportState >>>'
