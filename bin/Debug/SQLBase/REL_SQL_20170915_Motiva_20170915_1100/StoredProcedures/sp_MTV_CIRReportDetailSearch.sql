PRINT 'Start Script=SP_MTV_CIRReportDetailSearch.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportDetailSearch]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_CIRReportDetailSearch] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_CIRReportDetailSearch >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_CIRReportDetailSearch] @ArchiveID INT
AS

-- =============================================
-- Author:        Alan Oldfield
-- Create date:	  06/13/2016
-- Description:   This SP pulls data Contract Change Report (CIR Search Report)
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
	
	--SELECT	--h.ChangedCriticalColumns,d.ChangedCriticalColumns,
	--		h.DlHdrArchveID,h.DlHdrID
	--		,h.DlHdrIntrnlNbr,
	--		d.DlDtlID,h.DlHdrRvsnLvl,
	--		h.DlHdrDsplyDte,h.DlHdrIntrnlBAID,h.DlHdrExtrnlCntctID,h.Term,h.DlHdrIntrnlUserID,
	--		h.MasterAgreement,d.PaymentTermDescription--,d.PricingText1
	--FROM dbo.DealHeaderArchive h (NOLOCK)
	--LEFT OUTER JOIN dbo.DealDetailArchive d (NOLOCK)
	--ON h.DlHdrArchveID = d.ParentDlHdrArchveID 
	--WHERE h.DlHdrArchveID = @ArchiveID
	
	--SELECT	a.DlHdrArchveID,a.DlHdrID,a.DlHdrRvsnLvl,
	--		a.ApprovalDate,a.DlHdrRvsnDte,a.TotalValue
	--FROM dbo.DealHeaderArchive a (NOLOCK)
	--WHERE a.DlHdrArchveID = @DlHdrArchveID

	SELECT a.ArchiveID,a.DlHdrID,h.DlHdrIntrnlNbr,a.DlDtlID,a.RevisionLevel,h.DlHdrDsplyDte,h.DlHdrIntrnlBAID,h.DlHdrExtrnlCntctID,h.DlHdrIntrnlUserID,h.MasterAgreement
	FROM dbo.MTVArchiveRevisionLevels a (NOLOCK)
	INNER JOIN dbo.MTVArchiveRevisionLevels d (NOLOCK)
	ON a.DlHdrID = d.DlHdrID
	AND a.RevisionLevel = d.RevisionLevel
	AND d.PrvsnIsPrimary = 1
	AND a.ArchiveID = @ArchiveID
	INNER JOIN dbo.MTVDealHeaderArchive h (NOLOCK)
	ON d.DlHdrID = h.DlHdrID
	AND d.DlHdrRevisionID = h.RevisionID

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportDetailSearch]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_CIRReportDetailSearch.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_CIRReportDetailSearch >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_CIRReportDetailSearch >>>'
	  END