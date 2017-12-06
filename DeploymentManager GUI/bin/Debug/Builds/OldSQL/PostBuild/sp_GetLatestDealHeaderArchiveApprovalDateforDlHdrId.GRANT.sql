/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR stored procedure (NOTE:  Motiva_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId >>>'
GO
