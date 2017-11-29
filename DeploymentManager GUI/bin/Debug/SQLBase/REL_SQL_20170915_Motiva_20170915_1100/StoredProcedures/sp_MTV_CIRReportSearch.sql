PRINT 'Start Script=SP_MTV_CIRReportSearch.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportSearch]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_CIRReportSearch] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_CIRReportSearch >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_CIRReportSearch]
	@ShowValues INT = 2,
	@DealHeaderTemplateID VARCHAR(2000) = NULL,
	@Status VARCHAR(2000) = NULL,
	@DealFromDate DATETIME = NULL,
	@DealToDate DATETIME = NULL,
	@ContractNumber VARCHAR(20) = NULL,
	@ExternalBAID VARCHAR(2000) = NULL,
	@InternalBAID VARCHAR(2000) = NULL,
	@DealCreatedFromDate DATETIME = NULL,
	@DealCreatedToDate DATETIME = NULL,
	@InternalContactID VARCHAR(2000) = NULL,
	@Product VARCHAR(2000) = NULL,
	@Location VARCHAR(2000) = NULL,
    @SubType VARCHAR(100) = NULL,
    @DetailReceiptDeliveryType CHAR(1) = NULL,
	@OriginLocation VARCHAR(2000) = NULL,
    @DestinationLocation VARCHAR(2000) = NULL
AS

-- =============================================
-- Author:        Alan Oldfield
-- Create date:	  06/13/2016
-- Description:   This SP pulls data Contract Change Report (CIR Search Report)
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
CREATE TABLE #DealHeaderArchive (
	ArchiveID INT,
	IsLogistics BIT,
	HasStagedRecord BIT,
	IsMax BIT,
	LastArchiveID INT,
	UnLocked BIT,
	DocumentStatus INT,
	RevisionStatus CHAR(1),
	DlHdrID INT,
	RevisionLevel INT,
	DlHdrStat CHAR(1),
	DlHdrIntrnlNbr VARCHAR(20),
	DlHdrTyp INT,
	TraderUserID INT,
	DlHdrFrmDte DATETIME,
	DlHdrToDte DATETIME,
	DlHdrDsplyDte DATETIME,
	DlHdrRvsnDte DATETIME,
	DlHdrRvsnUserID INT,
	ConfirmationDueDate DATETIME
)

INSERT INTO #DealHeaderArchive (HasStagedRecord,IsLogistics,UnLocked,IsMax,DocumentStatus,RevisionStatus,DlHdrID,ArchiveID,RevisionLevel,DlHdrStat,DlHdrIntrnlNbr,
		DlHdrTyp,TraderUserID,DlHdrFrmDte,DlHdrToDte,DlHdrDsplyDte,DlHdrRvsnDte,DlHdrRvsnUserID,ConfirmationDueDate)
SELECT DISTINCT 0,0,1,0,
		NULL DocumentStatus,
		'I' RevisionStatus,
		h.DlHdrID,
		ar.ArchiveID,
		ar.RevisionLevel,
		h.DlHdrStat,
		h.DlHdrIntrnlNbr,
		h.DlHdrTyp,
		h.DlHdrIntrnlUserID,
		h.DlHdrFrmDte,
		h.DlHdrToDte,
		h.DlHdrDsplyDte,
		ar.RevisionDate,
		CASE ar.RevisionDate 
			WHEN r.RevisionDate THEN ar.RevisionUserID 
			ELSE (	SELECT TOP 1 RevisionUserID
					FROM dbo.MTVArchiveRevisionLevels (NOLOCK)
					WHERE DlHdrID = ar.DlHdrID 
					AND RevisionLevel = ar.RevisionLevel
		) END RevisionUserID,
		h.DlHdrDsplyDte + CASE dt.Description WHEN 'Purchase Deal' THEN 3 ELSE 2 END
FROM dbo.MTVArchiveRevisionLevels ar (NOLOCK)
INNER JOIN (
	SELECT MIN(a.ArchiveID) ArchiveID,a.DlHdrID,a.RevisionLevel,MAX(a.RevisionDate) RevisionDate
	FROM dbo.MTVArchiveRevisionLevels a (NOLOCK)
	INNER JOIN (
		SELECT DISTINCT DlHdrID
		FROM DealDetail (NoLock)
		Join DealHeader (NoLock) On
			DealDetail.DlDtlDlHdrID = DealHeader.DlHdrID
		Left Join UnitOfMeasure (NoLock) On
			DealDetail.DlDtlDsplyUOM = UnitOfMeasure.UOM
		Join EntityTemplate (NoLock) On
			DealHeader.EntityTemplateID = EntityTemplate.EntityTemplateID
		Join DealType (NoLock) On
			DealHeader.DlHdrTyp = DealType.DlTypID
		Join EntityTemplate ElementTemplateTable (NoLock) On
				DealDetail.EntityTemplateID = ElementTemplateTable.EntityTemplateID
		Where DealHeader.DlHdrTyp not in (90,62)
		And	DealDetail.DlDtlFrmDte <= ISNULL(@DealToDate,DealDetail.DlDtlFrmDte)
		And	DealDetail.DlDtlToDte >= ISNULL(@DealFromDate,DealDetail.DlDtlToDte)
		And	DealDetail.DlDtlCrtnDte >= ISNULL(@DealCreatedFromDate,DealDetail.DlDtlCrtnDte)
		And	DealDetail.DlDtlCrtnDte <= ISNULL(@DealCreatedToDate,DealDetail.DlDtlCrtnDte)
		And	DealHeader.DlHdrIntrnlNbr Like ISNULL(@ContractNumber,DealHeader.DlHdrIntrnlNbr)
		And	EntityTemplate.EntityTemplateID In (Select Value From CreateTableList(ISNULL(@DealHeaderTemplateID,EntityTemplate.EntityTemplateID)))
		And	DealDetail.DlDtlIntrnlUserID In (Select Value From CreateTableList(ISNULL(@InternalContactID,DealDetail.DlDtlIntrnlUserID)))
		And	DealDetail.ExternalBAID In (Select Value From CreateTableList(ISNULL(@ExternalBAID,DealDetail.ExternalBAID)))
		And	DealDetail.InternalBAID In (Select Value From CreateTableList(ISNULL(@InternalBAID,DealDetail.InternalBAID)))
		And	DealDetail.DlDtlStat In (Select Value From CreateTableList(ISNULL(@Status,DealDetail.DlDtlStat)))
		And	DealDetail.OriginLcleID In (Select Value From CreateTableList(ISNULL(@OriginLocation,DealDetail.OriginLcleID)))
		And	DealDetail.DestinationLcleID In (Select Value From CreateTableList(ISNULL(@DestinationLocation,DealDetail.DestinationLcleID)))
		And	DealDetail.SubType In (Select Value From CreateTableList(ISNULL(@SubType,DealDetail.SubType)))
		And	DealDetail.DlDtlSpplyDmnd In (Select Value From CreateTableList(ISNULL(@DetailReceiptDeliveryType,DealDetail.DlDtlSpplyDmnd)))
		And	DealDetail.DlDtlLcleID In (Select Value From CreateTableList(ISNULL(@Location,DealDetail.DlDtlLcleID)))
		And	DealDetail.DlDtlPrdctID In (Select Value From CreateTableList(ISNULL(@Product,DealDetail.DlDtlPrdctID)))
		) d
	ON a.DlHdrID = d.DlHdrID
	AND a.PrvsnIsPrimary = 1
	GROUP BY a.DlHdrID,a.RevisionLevel
	) r
ON r.ArchiveID = ar.ArchiveID
INNER JOIN dbo.MTVDealHeaderArchive h (NOLOCK)
ON ar.DlHdrID = h.DlHdrID
AND ar.DlHdrRevisionID = h.RevisionID
INNER JOIN dbo.DealType dt (NOLOCK)
ON dt.DlTypID = h.DlHdrTyp

UPDATE d SET d.IsMax = 1,d.DocumentStatus = 1,d.RevisionStatus = 'N'
FROM #DealHeaderArchive d
INNER JOIN (
	SELECT	d.DlHdrID,MAX(d.RevisionLevel) MaxRevisionLevel
	FROM #DealHeaderArchive d
	GROUP BY d.DlHdrID
) a
ON a.DlHdrID = d.DlHdrID
AND d.RevisionLevel = a.MaxRevisionLevel

UPDATE a SET	a.HasStagedRecord = 1,
				a.DocumentStatus = c.DocumentStatus,
				a.RevisionStatus = 'N'
FROM #DealHeaderArchive a
INNER JOIN dbo.MTVContractChangeStage c (NOLOCK)
ON c.ArchiveID = a.ArchiveID

UPDATE a SET	a.RevisionStatus = 'M'
FROM #DealHeaderArchive a
INNER JOIN (
	SELECT DlHdrID,MIN(RevisionLevel) MinRevisionLevel
	FROM #DealHeaderArchive
	WHERE RevisionStatus = 'N'
	GROUP BY DlHdrID
) l
ON a.DlHdrID = l.DlHdrID
AND a.RevisionLevel > l.MinRevisionLevel
AND RevisionStatus = 'N'

IF (@ShowValues = 0)  --Latest Version Only
	DELETE FROM #DealHeaderArchive WHERE IsMax = 0
ELSE IF (@ShowValues = 1)  --Modified and Latest Versions
	DELETE FROM #DealHeaderArchive WHERE IsMax = 0 AND HasStagedRecord != 1

UPDATE #DealHeaderArchive SET RevisionStatus = 'C' WHERE DlHdrStat = 'C'

UPDATE a SET IsLogistics = 1
FROM #DealHeaderArchive a
INNER JOIN dbo.DealType d (NOLOCK)
ON d.DlTypID = a.DlHdrTyp
AND d.IsLogistics = 'Y'

UPDATE #DealHeaderArchive SET UnLocked = 0 WHERE DATEDIFF(DAY,DlHdrDsplyDte,GETDATE()) > 15

SELECT	a.ArchiveID,
		a.DlHdrID,
		a.IsMax,
		CASE a.UnLocked WHEN 0 THEN ISNULL(c.Unlocked,0) ELSE 1 END UnLocked,
		a.IsLogistics,
		a.DocumentStatus,
		c.EmptorisID,
		c.DealActionEvent,
		a.RevisionStatus,
		a.RevisionLevel,
		a.DlHdrStat,
		CASE a.IsMax WHEN 1 THEN ISNULL(c.InterfaceStatus,'R') ELSE c.InterfaceStatus END InterfaceStatus,
		c.InterfaceMessage,
		c.InterfaceSent,
		c.IntefaceRecievedSuccess,
		c.InterfaceUserID,
		c.AnalystComments,
		a.DlHdrIntrnlNbr,
		a.DlHdrTyp,
		a.TraderUserID,
		a.DlHdrFrmDte,a.DlHdrToDte,
		a.ConfirmationDueDate,
		a.DlHdrRvsnDte,
		a.DlHdrRvsnUserID,
		ISNULL(c.SecondaryReviewRequired,0) SecondaryReviewRequired,
		ISNULL(c.AnalystInputError,0) AnalystInputError,
		ISNULL(c.TraderInputError,0) TraderInputError,
		ISNULL(c.DealDisputed,0) DealDisputed,
		c.DisputeResolution,
		c.AuditAnalyst,
		c.AuditingNotes,
		ISNULL(c.LogisticsReconciliation,0) LogisticsReconciliation,
		a.DlHdrDsplyDte
FROM #DealHeaderArchive a
LEFT OUTER JOIN MTVContractChangeStage c
ON c.ArchiveID = a.ArchiveID
ORDER BY ConfirmationDueDate DESC,DlHdrIntrnlNbr ASC,RevisionLevel ASC

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_CIRReportSearch]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_CIRReportSearch.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_CIRReportSearch >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_CIRReportSearch >>>'
	  END