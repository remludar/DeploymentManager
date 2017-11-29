PRINT 'Start Script=SP_MTV_CirHeaderStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CirHeaderStage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_CirHeaderStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_CirHeaderStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_CirHeaderStage]
	@DlHdrID INT,
	@RevisionLevel INT
AS

-- =============================================
-- Author:        Alan Oldfield
-- Create date:	  09/01/2016
-- Description:   This SP pulls the detail and pricing data for the emptoris interface.
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
SELECT	r.DlHdrID,r.RevisionLevel,h.DlHdrIntrnlNbr conf_contract_brief_2,
		h.DlHdrDsplyDte conf_negotiated_date,
		CASE ISNULL(nc.CntctLstNme,'') WHEN '' THEN '' ELSE nc.CntctFrstNme + ' ' + nc.CntctLstNme END conf_seller_deal_maker,
		CASE ISNULL(t.CntctLstNme,'') WHEN '' THEN '' ELSE t.CntctFrstNme + ' ' + t.CntctLstNme END conf_buyer_deal_maker,
		et.TemplateName + ':' + ISNULL(uit.TemplateName,'None') conf_deal_template,
		h.DlHdrFrmDte conf_effective_start_date,
		h.DlHdrToDte conf_effective_end_date,
		dt.Description conf_term,
		be.Name conf_external_primary_party,
		CASE ISNULL(i.CntctLstNme,'') WHEN '' THEN '' ELSE i.CntctFrstNme + ' ' + i.CntctLstNme END conf_contract_contact,
		CASE ISNULL(a.CntctLstNme,'') WHEN '' THEN '' ELSE a.CntctFrstNme + ' ' + a.CntctLstNme END conf_scheduler_name,
		CASE ISNULL(d.CntctLstNme,'') WHEN '' THEN '' ELSE d.CntctFrstNme + ' ' + d.CntctLstNme END conf_demurrage_name,
		rb.Name conf_rin_generator_id
FROM dbo.MTVContractChangeStage cs (NOLOCK)
INNER JOIN dbo.MTVArchiveRevisionLevels r (NOLOCK)
ON r.DlHdrID = cs.DlHdrID
AND r.RevisionLevel = cs.RevisionLevel
AND r.ArchiveID = (SELECT TOP 1 ArchiveID FROM dbo.MTVArchiveRevisionLevels (NOLOCK) WHERE DlHdrID = cs.DlHdrID AND RevisionLevel = cs.RevisionLevel)
INNER JOIN dbo.MTVDealHeaderArchive h (NOLOCK)
ON r.DlHdrID = h.DlHdrID
AND r.DlHdrRevisionID = h.RevisionID
LEFT OUTER JOIN dbo.Users ut
INNER JOIN dbo.Contact t (NOLOCK)
ON ut.UserCntctID = t.CntctID
ON ut.UserID = h.DlHdrIntrnlUserID
INNER JOIN dbo.Contact nc (NOLOCK)
ON nc.CntctID = h.DlHdrExtrnlCntctID
INNER JOIN dbo.DealHeader dh
ON dh.DlHdrID = h.DlHdrID
INNER JOIN dbo.EntityTemplate et (NOLOCK)
ON dh.EntityTemplateID = et.EntityTemplateID
LEFT OUTER JOIN dbo.UserInterfaceTemplate uit (NOLOCK)
ON dh.UserInterfaceTemplateID = uit.UserInterfaceTemplateID
LEFT OUTER JOIN dbo.BusinessAssociate be (NOLOCK)
ON be.BAID = h.DlHdrExtrnlBAID
LEFT OUTER JOIN dbo.Users ua
INNER JOIN dbo.Contact a (NOLOCK)
ON a.CntctID = ua.UserCntctID
ON ua.UserID = (SELECT TOP 1 Scheduler FROM MTVCirDetail WHERE DlHdrID = r.DlHdrID AND RevisionLevel = r.RevisionLevel AND Scheduler IS NOT NULL ORDER BY DlDtlID DESC)
LEFT OUTER JOIN dbo.Users ud
INNER JOIN dbo.Contact d (NOLOCK)
ON d.CntctID = ud.UserCntctID
ON ud.UserID = (SELECT TOP 1 DemurrageAnalyst FROM MTVCirDetail WHERE DlHdrID = r.DlHdrID AND RevisionLevel = r.RevisionLevel AND DemurrageAnalyst IS NOT NULL ORDER BY DlDtlID DESC)
LEFT OUTER JOIN dbo.Users ui
ON ui.UserID = cs.InterfaceUserID
LEFT OUTER JOIN dbo.Contact i (NOLOCK)
ON i.CntctID = ISNULL(cs.ContractAnalyst,ui.UserCntctID)
INNER JOIN DealType dt
ON dt.DlTypID = h.DlHdrTyp
LEFT OUTER JOIN dbo.BusinessAssociate rb (NOLOCK)
ON rb.BAID = h.RinsGenerator
WHERE r.DlHdrID = @DlHdrID
AND r.RevisionLevel = @RevisionLevel
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_CirHeaderStage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_CirHeaderStage.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_CirHeaderStage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_CirHeaderStage >>>'
	  END