PRINT 'Start Script=SP_MTV_CirDetailStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CirDetailStage]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_CirDetailStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_CirDetailStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_CirDetailStage]
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
DECLARE @DlDtlID INT,@RowText VARCHAR(MAX)
CREATE TABLE #RowText (ID INT IDENTITY(1,1),PrvsnRwID INT,DlDtlID INT,RowText VARCHAR(MAX),IsMax BIT)

INSERT INTO #RowText (PrvsnRwID,DlDtlID,RowText,IsMax)
SELECT p.PrvsnRwID,a.DlDtlID,CASE p.Actual WHEN 'I' THEN 'Interim Billing: ' + ISNULL(p.RowText,'') ELSE ISNULL(p.RowText,'') END,0
FROM dbo.MTVArchiveRevisionLevels a (NOLOCK)
INNER JOIN dbo.MTVDealPriceRowArchive p (NOLOCK)
ON a.PrvsnRowID = p.PrvsnRwID
AND a.PrvsnRowRevisionID = p.RevisionID
WHERE a.DlHdrID = @DlHdrID
AND a.RevisionLevel = @RevisionLevel
AND a.PrvsnIsPrimary = 1
AND p.Actual != 'E'
ORDER BY a.DlDtlID ASC,p.Actual ASC,p.PrvsnRwID ASC

UPDATE p SET p.IsMax = 1
FROM #RowText p
INNER JOIN (SELECT DlDtlID,MIN(ID) ID FROM #RowText GROUP BY DlDtlID) m
ON m.ID = p.ID

DECLARE cursor_prvtxt CURSOR FOR  
SELECT DlDtlID,RowText FROM #RowText WHERE IsMax = 0 ORDER BY DlDtlID ASC,ID ASC

OPEN cursor_prvtxt  
FETCH NEXT FROM cursor_prvtxt INTO @DlDtlID,@RowText

WHILE @@FETCH_STATUS = 0  
BEGIN
	UPDATE #RowText SET RowText = RowText + CASE WHEN LEN(RowText) > 0 THEN ' ' ELSE '' END + @RowText WHERE DlDtlID = @DlDtlID AND IsMax = 1
	FETCH NEXT FROM cursor_prvtxt INTO @DlDtlID,@RowText  
END  

CLOSE cursor_prvtxt  
DEALLOCATE cursor_prvtxt

DELETE FROM #RowText WHERE IsMax = 0

SELECT	c.DlHdrID,c.RevisionLevel,
		c.DlDtlSpplyDmnd,
		c.Ratio,
		c.DlDtlID parcel_number,
		--c.DlHdrDsplyDte negotiated_date,
		ISNULL(rt.RowText,'') price,
		c.HolidayOptionName mw_holopt,
		c.SaturdayOptionName mw_satopt,
		c.SundayOptionName mw_sunopt,
		p.PrdctAbbv grade_and_quality,
		c.DlDtlQntty quantity,
		uom.UOMDesc quanity_type,
		AprxQty.Value mw_apprxqty,
		c.VolumeToleranceDirection mw_voltoldir,
		c.ToleranceWhoseOption mw_tolwhoseopt,
		c.VolumeToleranceQuantity mw_voltolqty,
		dl.LcleNme delivery_location,
		do.LcleNme origin_location,
		dd.LcleNme destination_location,
		dtrm.DynLstBxDesc inco_terms,
		mot.DynSnglLstBxDesc mode_of_transportation,
		c.LoadingFrmDte mw_lfd,
		c.LoadingToDte mw_ltd,
		c.PipeLineName pipeline, 
		c.DlDtlFrmDte mw_ddfd,
		c.DlDtlToDte mw_ddtd,
		c.PipelineCycle cycle_name,
		trm.TrmVrbge payment,
		c.Scheduler conf_scheduler_name,
		c.DemurrageAnalyst conf_demurrage_name
FROM dbo.MTVCirDetail c (NOLOCK)
INNER JOIN #RowText rt
ON rt.PrvsnRwID = c.PrvsnRowID
INNER JOIN dbo.Product p (NOLOCK)
ON p.PrdctID = c.DlDtlPrdctID
INNER JOIN dbo.UnitOfMeasure uom (NOLOCK)
ON uom.UOM = c.DlDtlDsplyUOM
INNER JOIN dbo.Term trm (NOLOCK)
ON trm.TrmID = c.DlDtlTrmTrmID
LEFT OUTER JOIN dbo.locale dl (NOLOCK)
ON dl.LcleID = c.DlDtlLcleID
LEFT OUTER JOIN dbo.locale do (NOLOCK)
ON do.LcleID = c.OriginLcleID
LEFT OUTER JOIN dbo.locale dd (NOLOCK)
ON dd.LcleID = c.DestinationLcleID
LEFT OUTER JOIN dbo.DynamicSingleListBox mot (NOLOCK)
ON mot.DynSnglLstBxSnglChrTyp = c.DlDtlMthdTrnsprttn
AND mot.DynSnglLstBxQlfr = 'TransportationMethod'
LEFT OUTER JOIN dbo.DynamicListBox dtrm (NOLOCK)
ON CONVERT(int, dtrm.DynLstBxTyp) = c.DeliveryTermID
AND DynLstBxQlfr = 'DealDeliveryTerm'
LEFT OUTER JOIN (
	SELECT 'Y' DlDtlApprxmteQntty ,'Approximate Quantity' Value
	UNION ALL
	SELECT 'N','Fixed Quantity'
	UNION ALL
	SELECT 'F','Fixed Range'
	UNION ALL
	SELECT 'P','Percent Range'
) AprxQty
ON AprxQty.DlDtlApprxmteQntty = c.DlDtlApprxmteQntty
WHERE c.DlHdrID = @DlHdrID
AND c.RevisionLevel = @RevisionLevel
ORDER BY c.DlDtlSpplyDmnd DESC,c.DlDtlID ASC

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_CirDetailStage]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_CirDetailStage.sql'
	PRINT '<<< ALTERED StoredProcedure MTV_CirDetailStage >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_CirDetailStage >>>'
END