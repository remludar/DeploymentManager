/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_UpdatePhysicalDealArchiveEntries WITH YOUR view (NOTE:  GN_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure dbo.MTV_UpdatePhysicalDealArchiveEntries    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdatePhysicalDealArchiveEntries.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'dbo.MTV_UpdatePhysicalDealArchiveEntries') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE dbo.MTV_UpdatePhysicalDealArchiveEntries AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_UpdatePhysicalDealArchiveEntries >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTV_UpdatePhysicalDealArchiveEntries] @DealRevisionDate DATE
AS
-- =============================================
-- Author:        Alec Aquino
-- Create date:	  1/27/2016
-- Description:   Update Deal Detail IO GSAP Attributes from Maintenance Report
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
-- 2016-09-19	DAO						Modifed procedure to store archive data in table for later retrieval so history would be retatained.
-----------------------------------------------------------------------------
-- 
SET NOCOUNT ON


--Only put deal changes in the deals if its a revision today or no records exist already.
--Cant guarantee data will be right for old deals if not previously archived, but better than nothing.  Only the task will run this by older dates.
IF (@DealRevisionDate != CAST(GETDATE() AS DATE))
	IF EXISTS(SELECT TOP 1 1 FROM dbo.MTVPhysicalDealArchiveEntries a (NOLOCK) WHERE CAST(a.DlHdrRvsnDte AS DATE) = @DealRevisionDate)
	BEGIN
		THROW 50000, 'Error, Archive records already exist for this revision date.' ,1
		RETURN
	END

DECLARE @PreviousRevisionDate DATE
--DECLARE @DealRevisionDate DATE
--SELECT @DealRevisionDate = '2017-06-15'
SELECT @PreviousRevisionDate = DATEADD(DAY,-1,@DealRevisionDate)

--drop table #deals
CREATE TABLE #deals (DlHdrID INT,RevisionDate DATE,DlHdrRvsnLvl INT)

INSERT INTO #deals
SELECT	DISTINCT dha.DlHdrID,
		CAST(dha.DlHdrRvsnDte AS DATE) RevisionDate,
		MAX(dha.DlHdrRvsnLvl) DlHdrRvsnLvl
FROM dbo.DealHeaderArchive dha (NOLOCK)
LEFT OUTER JOIN MTVPhysicalDealArchiveEntries a (NOLOCK)
ON a.DlHdrID = dha.DlHdrId
AND CAST(dha.DlHdrRvsnDte AS DATE) = @PreviousRevisionDate
WHERE CAST(dha.DlHdrRvsnDte AS DATE) BETWEEN @PreviousRevisionDate AND @DealRevisionDate
AND a.DlHdrRvsnDte IS NULL
GROUP BY CAST(dha.DlHdrRvsnDte AS DATE),dha.DlHdrID

--select * from #deals

BEGIN TRANSACTION
	DELETE a
	FROM dbo.MTVPhysicalDealArchiveEntries a
	INNER JOIN #deals d ON d.DlHdrID = a.DlHdrID
	WHERE CAST(a.DlHdrRvsnDte AS DATE) = @DealRevisionDate

	INSERT INTO MTVPhysicalDealArchiveEntries (
		DlHdrID,DlHdrArchveID,DlHdrIntrnlUserID,DlHdrExtrnlCntctID,DlHdrIntrnlNbr,DlHdrIntrnlBAID,DlHdrExtrnlBAID,DlHdrTyp,Term,DlHdrDsplyDte,DlHdrFrmDte,DlHdrToDte,
		DlHdrStat,DlHdrIntrnlPpr,DlHdrRvsnUserID,DlHdrCrtnDte,DlHdrRvsnDte,DlHdrRvsnLvl,DlDtlID,DlDtlSpplyDmnd,DlDtlFrmDte,DlDtlToDte,DlDtlQntty,
		DlDtlDsplyUOM,DlDtlPrdctID,DlDtlLcleID,DlDtlMthdTrnsprttn,DlDtlTrmTrmID,DetailStatus,DlDtlCrtnDte,DlDtlRvsnDte,DlDtlRvsnLvl,StrtgyID,
		DlDtlPrvsnID,PrvsnDscrptn,PricingText1,Actual,CostType,DlDtlPrvsnMntryDrctn,DeletedDetailStatus,DeletedDetailID,DlDtlIntrnlUserID,DeliveryTermID
		)
		SELECT	dha.DlHdrID,dha.DlHdrArchveID,dha.DlHdrIntrnlUserID,dha.DlHdrExtrnlCntctID,dha.DlHdrIntrnlNbr,dha.DlHdrIntrnlBAID,dha.DlHdrExtrnlBAID,dha.DlHdrTyp,dha.Term,
			dha.DlHdrDsplyDte,dha.DlHdrFrmDte,dha.DlHdrToDte,dha.DlHdrStat,dha.DlHdrIntrnlPpr,dha.DlHdrRvsnUserID,dha.DlHdrCrtnDte,dha.DlHdrRvsnDte,
			dha.DlHdrRvsnLvl,dda.DlDtlID,dda.DlDtlSpplyDmnd,dda.DlDtlFrmDte,dda.DlDtlToDte,dda.DlDtlQntty,dda.DlDtlDsplyUOM,dda.DlDtlPrdctID,dda.DlDtlLcleID,
			dda.DlDtlMthdTrnsprttn,dd.DlDtlTrmTrmID,dda.DlDtlStat,dda.DlDtlCrtnDte,dda.DlDtlRvsnDte,dda.DlDtlRvsnLvl,ds.StrtgyID
		,ddp.DlDtlPrvsnID
		,CASE WHEN (dha.DlHdrTyp in (70,71,72,73,76,77,78,79) or dda.DlDtlTmplteId in (26000,27000)) THEN 
			(CASE dda.DlDtlSpplyDmnd WHEN 'R' THEN 'Buy' WHEN 'D' THEN 'Sell' ELSE '' END)
			WHEN dha.DlHdrTyp in (51,52,53,59,61) THEN 
				(CASE dda.DlDtlSpplyDmnd WHEN 'R' THEN 'Output' WHEN 'D' THEN 'Input' ELSE '' END) 
			WHEN dha.DlHdrTyp in (54,55,56,57,58,60,63) THEN 
				(CASE dda.DlDtlSpplyDmnd WHEN 'R' THEN 'Destination' WHEN 'D' THEN 'Origin' ELSE '' END)
			ELSE (CASE dda.DlDtlSpplyDmnd WHEN 'R' THEN 'Receipt' WHEN 'D' THEN 'Delivery' ELSE '' END) END AS PrvsnDscrptn
		,Prvsn.PrvsnDscrptn + ': ' + rt.RowText,ddp.Actual,ddp.CostType,ddp.DlDtlPrvsnMntryDrctn,DDA1.DlDtlStat,DDA1.DlDtlID,dda.DlDtlIntrnlUserID,
		dda.DeliveryTermID
	FROM #Deals d
	INNER JOIN dbo.DealHeaderArchive dha (NOLOCK) ON d.DlHdrID = dha.DlHdrID AND dha.DlHdrRvsnLvl = d.DlHdrRvsnLvl AND d.RevisionDate = CAST(dha.DlHdrRvsnDte AS DATE)
	LEFT OUTER JOIN dbo.DealDetailArchive dda (NOLOCK)
	ON dha.DlHdrArchveID = dda.ParentDlHdrArchveID
	LEFT OUTER JOIN dbo.DealDetailArchive DDA1 (NOLOCK)
	ON dha.DlHdrID = DDA1.DlHdrID and DDA1.DlDtlStat = 'D' and dha.DlHdrArchveID = DDA1.ParentDlHdrArchveID
	LEFT OUTER JOIN dbo.DealDetail dd (NOLOCK)
	ON dda.DlHdrID = dd.DlDtlDlHdrID and dda.DlDtlID = dd.DlDtlID
	LEFT OUTER JOIN dbo.DealDetailStrategy ds (NOLOCK)
	ON dda.DlHdrID = ds.DlHdrID and dda.DlDtlID = ds.DlDtlID
	LEFT OUTER JOIN dbo.DealDetailProvision ddp (NOLOCK)
	ON dda.DlHdrID = ddp.DlDtlPrvsnDlDtlDlHdrID and dda.DlDtlID = ddp.DlDtlPrvsnDlDtlID
	LEFT OUTER JOIN  (
		SELECT r.DlDtlPrvsnID, MAX(ISNULL(r.RowText,'')) RowText
		FROM dbo.DealDetailProvisionRow r (NOLOCK)
		INNER JOIN dbo.DealDetailProvision p (NOLOCK)
		ON r.DlDtlPrvsnID = p.DlDtlPrvsnID
		INNER JOIN #deals d
		ON d.DlHdrID = p.DlDtlPrvsnDlDtlDlHdrID
		WHERE ISNULL(r.RowText,'') != '' 
		GROUP BY r.DlDtlPrvsnID
		UNION
		SELECT r.DlDtlPrvsnID,
		CASE 
			WHEN dd.DlDtlTmplteId in (20000,26000,340000,341000)
				THEN CASE WHEN dd.DlDtlTmplteId IN (340000,341000) AND p.CostType = 'S'
					THEN 'Secondary Fee'
					ELSE MAX(CASE ISNULL(r.PriceAttribute12,'FIX') WHEN 'TAS' THEN 'TAS' ELSE r.PriceAttribute2 END)
				END 
			WHEN dd.DlDtlTmplteId in (26001) 
				THEN MAX(ISNULL(r.PriceAttribute1,''))
			ELSE MAX(ISNULL(r.RowText,'')) 
		END RowText
		FROM dbo.DealDetailProvisionRow r (NOLOCK)
		INNER JOIN dbo.DealDetailProvision p (NOLOCK) ON r.DlDtlPrvsnID = p.DlDtlPrvsnID
		INNER JOIN #deals d
		ON d.DlHdrID = p.DlDtlPrvsnDlDtlDlHdrID
		INNER JOIN dbo.DealDetail dd (NOLOCK) ON p.DlDtlPrvsnDlDtlDlHdrID = dd.DlDtlDlHdrID AND p.DlDtlPrvsnDlDtlID = dd.DlDtlID
		GROUP BY r.DlDtlPrvsnID , dd.DlDtlTmplteId, p.CostType
		HAVING SUM(LEN(ISNULL(r.RowText,''))) = 0
	) rt
	ON ddp.DlDtlPrvsnID = rt.DlDtlPrvsnID
	LEFT OUTER JOIN dbo.Prvsn (NOLOCK)
	ON ddp.DlDtlPrvsnPrvsnID = Prvsn.PrvsnID
	WHERE (
			(	
				dda.DlDtlStat = 'D' 
				AND DATEDIFF(DAY, dda.ApprovalDate, dha.DlHdrRvsnDte) < 1
			)
			OR
			(
				DATEDIFF(DAY, dda.DlDtlRvsnDte, dha.DlHdrRvsnDte) < 1
				AND ddp.Status <> 'I'
				AND ((dha.DlHdrTyp in (1,2,20,70,72,74,76,77,80,100) AND rt.RowText IS NOT NULL) )--OR (dha.DlHdrTyp in (74,76,77,78) AND dda.DlDtlID < 100))
			)
		)
	IF (@@error = 0)
		COMMIT TRANSACTION
	ELSE
		ROLLBACK TRANSACTION
GO
		
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'dbo.MTV_UpdatePhysicalDealArchiveEntries') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_UpdatePhysicalDealArchiveEntries.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_UpdatePhysicalDealArchiveEntries >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_UpdatePhysicalDealArchiveEntries >>>'
	  END
