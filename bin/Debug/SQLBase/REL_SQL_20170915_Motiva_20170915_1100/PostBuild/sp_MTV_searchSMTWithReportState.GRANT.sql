/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTV_searchSMTWithReportState 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MTV_searchSMTWithReportState]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_searchSMTWithReportState.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO


IF  OBJECT_ID(N'[dbo].[sp_MTV_searchSMTWithReportState]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_searchSMTWithReportState.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTV_searchSMTWithReportState >>>'
			Grant execute on dbo.sp_MTV_searchSMTWithReportState to  Sysuser
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTV_searchSMTWithReportState >>>'
	  END