/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR view (NOTE:  Motiva_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId]  
@DlHdrId int  
AS  
  
-- =============================================  
-- Description:   Gets the Approval Date for the Latest DealHeader Archive  
 --               for a given DealHeaderId  
-- =============================================  
-- Date         Modified By     Issue#  Modification  
-- -----------  --------------  ------  ---------------------------------------------------------------------  
-----------------------------------------------------------------------------  

select ApprovalUserID  
from DealHeaderArchive DHA  
where DlHdrID = @DlHdrId  
and DlHdrArchveID = (select max(DlHdrArchveID)   
                     from DealHeaderArchive   
                     where DHA.DlHdrID = DlHdrID   
                     and PrintDate is null)  


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId.sql'
			PRINT '<<< ALTERED StoredProcedure sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_GetLatestDealHeaderArchiveApprovalDateforDlHdrId >>>'
	  END