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
	@ShowValues INT = 3,
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
    @DestinationLocation VARCHAR(2000) = NULL,
	@IsEmptorisDeal BIT = NULL
AS

-- =============================================
-- Author:        Alan Oldfield
-- Create date:	  06/13/2016
-- Description:   This SP pulls data Contract Change Report (CIR Search Report)
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
DECLARE @sql VARCHAR(MAX)
CREATE TABLE #Deals (DlHdrID INT,RevisionLevel INT,AllowSendEmptoris BIT,TemplateName VARCHAR(181))

CREATE TABLE #DealHeaderArchive (
	IsLogistics BIT,
	HasSentRecord BIT,
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
	ConfirmationDueDate DATETIME,
	DlHdrExtrnlBAID INT,
	IsEmptorisDeal BIT,
	TemplateName VARCHAR(181)
)

SELECT @sql = 'INSERT INTO #Deals
SELECT MTVArchiveRevisionLevels.DlHdrID,
	MAX(MTVArchiveRevisionLevels.RevisionLevel) RevisionLevel,
	ISNULL(t.AllowSendEmptoris,0) AllowSendEmptoris,
	EntityTemplate.TemplateName + '':'' + ISNULL(UserInterfaceTemplate.TemplateName,''None'')
FROM dbo.MTVArchiveRevisionLevels (NOLOCK)
INNER JOIN dbo.DealHeader (NOLOCK)ON MTVArchiveRevisionLevels.DlHdrID = DealHeader.DlHdrID
INNER JOIN dbo.DealDetail (NOLOCK) ON MTVArchiveRevisionLevels.DlHdrID = DealDetail.DlDtlDlHdrID
INNER JOIN dbo.EntityTemplate (NOLOCK) ON DealHeader.EntityTemplateID = EntityTemplate.EntityTemplateID
LEFT OUTER JOIN dbo.UserInterfaceTemplate (NOLOCK)
ON DealHeader.UserInterfaceTemplateID = UserInterfaceTemplate.UserInterfaceTemplateID
LEFT OUTER JOIN (
	SELECT	x.ElementValue TemplateName,
			CAST(CASE ISNULL(x.InternalValue,0) WHEN ''Y'' THEN 1 ELSE 0 END AS BIT) AllowSendEmptoris
	FROM dbo.SourceSystem (NOLOCK) ss
	INNER JOIN dbo.SourceSystemElement se (NOLOCK)
	ON ss.SrceSystmID = se.SrceSystmID
	AND ss.Name = ''EMPTORIS''
	AND se.ElementName = ''ArchiveSendTemplates''
	INNER JOIN dbo.SourceSystemElementXref x (NOLOCK)
	ON x.SrceSystmElmntID = se.SrceSystmElmntID
) t
ON t.TemplateName = EntityTemplate.TemplateName + '':'' + ISNULL(UserInterfaceTemplate.TemplateName,''None'')
WHERE MTVArchiveRevisionLevels.PrvsnIsPrimary = 1
'
IF (@DealFromDate IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlToDte >= ''' + CAST(@DealFromDate AS VARCHAR) + ''''
IF (@DealToDate IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlFrmDte <= ''' + CAST(@DealToDate AS VARCHAR) + ''''
IF (@DealCreatedFromDate IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlCrtnDte >= ''' + CAST(@DealCreatedFromDate AS VARCHAR) + ''''
IF (@DealCreatedToDate IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlCrtnDte <= ''' + CAST(@DealCreatedToDate AS VARCHAR) + ''''
IF (@Status IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlStat IN (''' + REPLACE(@Status,',',''',''') + ''')'
IF (@ContractNumber IS NOT NULL) SELECT @sql = @sql + ' AND DealHeader.DlHdrIntrnlNbr LIKE ''' + CAST(@ContractNumber AS VARCHAR) + ''''
IF (@DealHeaderTemplateID IS NOT NULL) SELECT @sql = @sql + ' AND EntityTemplate.EntityTemplateID IN (' + @DealHeaderTemplateID + ')'
IF (@InternalContactID IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlIntrnlUserID IN (' + @InternalContactID + ')'
IF (@ExternalBAID IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.ExternalBAID IN (' + @ExternalBAID + ')'
IF (@InternalBAID IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.InternalBAID IN (' + @InternalBAID + ')'
IF (@OriginLocation IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.OriginLcleID IN (' + @OriginLocation + ')'
IF (@DestinationLocation IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DestinationLcleID IN (' + @DestinationLocation + ')'
IF (@DetailReceiptDeliveryType IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlSpplyDmnd IN (' + @DetailReceiptDeliveryType + ')'
IF (@Location IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlLcleID IN (' + @Location + ')'
IF (@Product IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.DlDtlPrdctID IN (' + @Product + ')'
IF (@SubType IS NOT NULL) SELECT @sql = @sql + ' AND DealDetail.SubType IN (''' + REPLACE(@SubType,',',''',''') + ''')'
IF (@IsEmptorisDeal IS NOT NULL) SELECT @sql = @sql + ' AND ISNULL(t.AllowSendEmptoris,0) = ' + CAST(@IsEmptorisDeal AS VARCHAR)

SELECT @sql = @sql + ' GROUP BY MTVArchiveRevisionLevels.DlHdrID,ISNULL(t.AllowSendEmptoris,0),EntityTemplate.TemplateName + '':'' + ISNULL(UserInterfaceTemplate.TemplateName,''None'')'
EXECUTE (@sql)

INSERT INTO #DealHeaderArchive (HasSentRecord,IsLogistics,UnLocked,IsMax,DocumentStatus,RevisionStatus,DlHdrID,RevisionLevel,DlHdrStat,DlHdrIntrnlNbr,
		DlHdrTyp,TraderUserID,DlHdrFrmDte,DlHdrToDte,DlHdrDsplyDte,ConfirmationDueDate,DlHdrExtrnlBAID,IsEmptorisDeal,TemplateName)
SELECT DISTINCT 0,0,1,
		CASE r.RevisionLevel WHEN ar.RevisionLevel THEN 1 ELSE 0 END,
		1 DocumentStatus,
		CASE h.DlHdrStat WHEN 'C' THEN 'C' ELSE CASE ar.RevisionLevel WHEN 0 THEN 'N' ELSE 'M' END END RevisionStatus,
		h.DlHdrID,
		ar.RevisionLevel,
		h.DlHdrStat,
		h.DlHdrIntrnlNbr,
		h.DlHdrTyp,
		h.DlHdrIntrnlUserID,
		h.DlHdrFrmDte,
		h.DlHdrToDte,
		h.DlHdrDsplyDte,
		h.DlHdrDsplyDte + CASE dt.Description WHEN 'Purchase Deal' THEN 3 ELSE 2 END,
		h.DlHdrExtrnlBAID,
		r.AllowSendEmptoris,
		r.TemplateName
FROM dbo.MTVArchiveRevisionLevels ar (NOLOCK)
INNER JOIN #Deals r
ON ar.DlHdrID = r.DlHdrID
AND ar.RevisionLevel = CASE @ShowValues WHEN 0 THEN r.RevisionLevel ELSE ar.RevisionLevel END
AND ar.PrvsnIsPrimary = 1
INNER JOIN dbo.MTVDealHeaderArchive h (NOLOCK)
ON ar.DlHdrID = h.DlHdrID
AND ar.DlHdrRevisionID = h.RevisionID
INNER JOIN dbo.DealType dt (NOLOCK)
ON dt.DlTypID = h.DlHdrTyp

--If any deal is cancelled then all rows are cancelled.
DELETE a
FROM #DealHeaderArchive c
INNER JOIN #DealHeaderArchive a
ON c.DlHdrID = a.DlHdrID
AND c.RevisionLevel = a.RevisionLevel
AND c.DlHdrStat = 'C'
AND a.DlHdrStat = 'A'

UPDATE a SET	a.HasSentRecord = CASE ISNULL(c.InterfaceStatus,'X') WHEN 'S' THEN 1 WHEN 'C' THEN 1 ELSE 0 END,
				a.DocumentStatus = ISNULL(c.DocumentStatus,a.DocumentStatus)
FROM #DealHeaderArchive a
INNER JOIN dbo.MTVContractChangeStage c (NOLOCK)
ON c.DlHdrID = a.DlHdrID
AND c.RevisionLevel = a.RevisionLevel

IF (@ShowValues = 1)  --Sent and Latest Versions
	DELETE FROM #DealHeaderArchive WHERE IsMax = 0 AND HasSentRecord != 1
ELSE IF (@ShowValues = 2)  --Sent and Later Versions
BEGIN
	DELETE a FROM #DealHeaderArchive a
	INNER JOIN (SELECT DlHdrID,MAX(RevisionLevel) RevisionLevel FROM #DealHeaderArchive WHERE HasSentRecord = 1 GROUP BY DlHdrID) d
	ON a.DlHdrID = d.DlHdrID
	AND a.RevisionLevel < d.RevisionLevel
	WHERE d.DlHdrID IS NOT NULL
END

UPDATE d SET	d.DlHdrRvsnUserID = r.RevisionUserID,
				d.DlHdrRvsnDte = r.RevisionDate
FROM #DealHeaderArchive d
INNER JOIN dbo.MTVArchiveRevisionLevels r (NOLOCK)
ON r.DlHdrID = d.DlHdrID 
AND r.RevisionLevel = d.RevisionLevel

UPDATE a SET IsLogistics = 1
FROM #DealHeaderArchive a
INNER JOIN dbo.DealType d (NOLOCK)
ON d.DlTypID = a.DlHdrTyp
AND (d.IsLogistics = 'Y'
OR d.DlTypID = 20)  --Make exchange deals act like logistics deals.

UPDATE #DealHeaderArchive SET UnLocked = 0 WHERE DATEDIFF(DAY,DlHdrDsplyDte,GETDATE()) > 15

UPDATE c SET c.InterfaceStatus = NULL,c.InterfaceMessage = NULL
FROM MTVContractChangeStage c
INNER JOIN #DealHeaderArchive a
ON c.DlHdrID = a.DlHdrID
AND c.RevisionLevel = a.RevisionLevel
WHERE c.InterfaceStatus = 'E'
AND a.IsMax = 0

SELECT	a.DlHdrID,
		a.IsMax,
		CASE WHEN c.UnLocked IS NULL THEN a.Unlocked ELSE CASE c.UnLocked WHEN 1 THEN 1 ELSE CASE c.DocumentStatus WHEN 12 THEN c.UnLocked WHEN 7 THEN c.UnLocked WHEN 8 THEN c.UnLocked ELSE a.Unlocked END END END UnLocked,
		a.IsLogistics,
		a.DocumentStatus,
		c.EmptorisID,
		c.DealActionEvent,
		a.RevisionStatus,
		a.RevisionLevel,
		a.DlHdrStat,
		CASE a.DlHdrStat WHEN 'C' THEN 'I' ELSE CASE a.IsEmptorisDeal WHEN 1 THEN CASE a.IsMax WHEN 1 THEN ISNULL(c.InterfaceStatus,'R') ELSE ISNULL(c.InterfaceStatus,'I') END ELSE 'I' END END InterfaceStatus,
		c.InterfaceMessage,
		c.InterfaceSent,
		c.IntefaceRecievedSuccess,
		c.InterfaceUserID,
		c.AnalystComments,
		c.AnalystCommentsText,
		a.DlHdrIntrnlNbr,
		a.DlHdrTyp,
		a.TraderUserID,
		a.DlHdrFrmDte,a.DlHdrToDte,
		a.ConfirmationDueDate,
		a.DlHdrRvsnDte,
		a.DlHdrRvsnUserID,
		ISNULL(c.SecondaryReviewRequired,0) SecondaryReviewRequired,
		c.SecondaryReviewer,
		ISNULL(c.AnalystInputError,0) AnalystInputError,
		ISNULL(c.TraderInputError,0) TraderInputError,
		ISNULL(c.DealDisputed,0) DealDisputed,
		c.DisputeResolution,
		c.AuditAnalyst,
		c.AuditingNotes,
		CASE WHEN c.DlHdrID IS NULL THEN 0 ELSE c.LogisticsReconciliation END LogisticsReconciliation,
		a.DlHdrDsplyDte,
		ns.CurrentStatus NexusStatus,
		ns.CurrentMessage NexusMessage,
		c.NexusMessageID,
		a.DlHdrExtrnlBAID,
		a.IsEmptorisDeal,
		c.ContractAnalyst,
		c.LastUpdateUserID,
		c.LastUpdateDateTime,
		a.TemplateName
FROM #DealHeaderArchive a
LEFT OUTER JOIN dbo.MTVContractChangeStage c WITH (NOLOCK)
ON c.DlHdrID = a.DlHdrID
AND c.RevisionLevel = a.RevisionLevel
LEFT OUTER JOIN dbo.CurrentNexusStatus ns WITH (NOLOCK)
ON c.NexusMessageID = ns.MessageID

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