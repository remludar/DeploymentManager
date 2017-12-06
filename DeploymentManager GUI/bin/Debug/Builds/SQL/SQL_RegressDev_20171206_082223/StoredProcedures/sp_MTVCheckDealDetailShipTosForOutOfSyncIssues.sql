/****** Object:  StoredProcedure [dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVCheckDealDetailShipTosForOutOfSyncIssues.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTVCheckDealDetailShipTosForOutOfSyncIssues >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues]
	@DlHdrID INT,
	@StagedUserID INT,
	@BASTID INT,
	@StagedFromDealOrReport CHAR(1)
AS

-- =============================================
-- Author:        Matthew Vorm
-- Create date:	  3/29/2016
-- Description:   
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--  
-- ----------------------------------------------------------------------------------------------------------

--If there are any rows that will be added for a BASoldToID that is not what the new DealHeader's value will be
--Then error out, because you will be trying to stage an invalid row
IF EXISTS (		SELECT 1 
				FROM dbo.MTVDealDetailShipToStaging stagingDDST (NOLOCK)
				INNER JOIN dbo.MTVSAPSoldToShipTo STST (NOLOCK)
					ON stagingDDST.SoldToShipToID = STST.ID
				INNER JOIN dbo.MTVSAPBASoldTo BAST (NOLOCK)
					ON STST.MTVSAPBASoldToID = BAST.ID
				WHERE stagingDDST.DlHdrID = @DlHdrID 
				AND stagingDDST.StagedUserID = @StagedUserID 
				AND BAST.ID <> @BASTID
				AND stagingDDST.Action = 'A'
				AND stagingDDST.StagedFromDealOrReport = @StagedFromDealOrReport )
	BEGIN
		SELECT -1
		RETURN
	END

DECLARE @OldBASTID INT
SELECT @OldBASTID = GC.GnrlCnfgMulti 
		FROM GeneralConfiguration GC (NOLOCK) 
		WHERE GC.GnrlCnfgQlfr = 'SAPSoldTo' 
		AND GC.GnrlCnfgHdrID = @DlHdrID 
		AND GC.GnrlCnfgTblNme = 'DealHeader' 
		AND GC.GnrlCnfgMulti <> 'X'

--If the value of the Deal's BASoldToID is changing, then make sure that there will be no rows
--Left undeleted if the staging table was applied to the real table(lingering un-syncd rows)
IF ( ISNULL(@BASTID, -1) <> ISNULL(@OldBASTID, -1) )
BEGIN
	IF EXISTS (		SELECT *
					FROM dbo.MTVDealDetailShipTo DDST (NOLOCK)
					LEFT OUTER JOIN dbo.MTVDealDetailShipToStaging stagingDDST (NOLOCK)
						ON DDST.DlHdrID = stagingDDST.DlHdrID AND DDST.DlDtlID = stagingDDST.DlDtlID 
						AND DDST.SoldToShipToID = stagingDDST.SoldToShipToID
						AND stagingDDST.Action = 'D' AND stagingDDST.StagedUserID = @StagedUserID
						AND stagingDDST.StagedFromDealOrReport = @StagedFromDealOrReport
					WHERE DDST.DlHdrID = @DlHdrID AND stagingDDST.ID IS NULL )
	BEGIN
		SELECT -2
		RETURN
	END
END

SELECT 1
RETURN

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVCheckDealDetailShipTosForOutOfSyncIssues]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVCheckDealDetailShipTosForOutOfSyncIssues.sql'
	PRINT '<<< ALTERED StoredProcedure MTVCheckDealDetailShipTosForOutOfSyncIssues >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVCheckDealDetailShipTosForOutOfSyncIssues >>>'
END
 
