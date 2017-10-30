/****** Object:  StoredProcedure [dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVApplyStagingTableUpdatesToDealDetailShipToTable.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTVApplyStagingTableUpdatesToDealDetailShipToTable >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]
	@DlHdrID INT,
	@StagedUserID INT,
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

--Make sure there are staging rows to apply changes using
IF NOT EXISTS(	SELECT 1
				FROM dbo.MTVDealDetailShipToStaging (NOLOCK)
				WHERE DlHdrID = @DlHdrID AND StagedUserID = @StagedUserID AND StagedFromDealOrReport = @StagedFromDealOrReport )
BEGIN
	SELECT 0
	RETURN 
END

SET XACT_ABORT ON


BEGIN
	BEGIN TRANSACTION [Transac]
		BEGIN TRY
			--Delete all RealRows that existed where there was a Staging row with Delete action
			DELETE realDDST FROM dbo.MTVDealDetailShipTo realDDST
			INNER JOIN dbo.MTVDealDetailShipToStaging stagingDDST
				ON stagingDDST.DlHdrID = realDDST.DlHdrID 
				AND stagingDDST.DlDtlID = realDDST.DlDtlID
				AND stagingDDST.SoldToShipToID = realDDST.SoldToShipToID
			WHERE realDDST.DlHdrID = @DlHdrID 
			AND stagingDDST.Action = 'D'
			AND stagingDDST.StagedUserID = @StagedUserID
			AND stagingDDST.StagedFromDealOrReport = @StagedFromDealOrReport

			--Update all RealRows that existed where there was also a Staging row with an Add action
			UPDATE dbo.MTVDealDetailShipTo 
				SET MTVDealDetailShipTo.FromDate = stagingDDST.FromDate,
				MTVDealDetailShipTo.ToDate = stagingDDST.ToDate,
				MTVDealDetailShipTo.LastUpdateDate = GETDATE(),
				MTVDealDetailShipTo.LastUpdateUserID = stagingDDST.LastUpdateUserID,
				MTVDealDetailShipTo.Status = stagingDDST.Status
			FROM dbo.MTVDealDetailShipTo realDDST (NOLOCK)
			INNER JOIN dbo.MTVDealDetailShipToStaging stagingDDST (NOLOCK)
				ON realDDST.DlHdrID = stagingDDST.DlHdrID
				AND realDDST.DlDtlID = stagingDDST.DlDtlID
				AND realDDST.SoldToShipToID = stagingDDST.SoldToShipToID
			WHERE stagingDDST.DlHdrID = @DlHdrID
			AND stagingDDST.Action = 'A'
			AND stagingDDST.StagedUserID = @StagedUserID
			AND stagingDDST.StagedFromDealOrReport = @StagedFromDealOrReport

			--Create all RealRows that did not previously exist where there was a Staging row with an Add action
			INSERT INTO dbo.MTVDealDetailShipTo
			(DlHdrID,DlDtlID,DealDetailID,SoldToShipToID,FromDate,ToDate,LastUpdateDate,LastUpdateUserID,Status)
			SELECT stagingDDST.DlHdrID
				,stagingDDST.DlDtlID
				,stagingDDST.DealDetailID
				,stagingDDST.SoldToShipToID
				,stagingDDST.FromDate
				,stagingDDST.ToDate
				,stagingDDST.LastUpdateDate
				,stagingDDST.LastUpdateUserID
				,stagingDDST.Status
				FROM dbo.MTVDealDetailShipToStaging stagingDDST (NOLOCK)
				LEFT OUTER JOIN dbo.MTVDealDetailShipTo realDDST (NOLOCK)
					ON realDDST.DlHdrID = stagingDDST.DlHdrID
					AND realDDST.DlDtlID = stagingDDST.DlDtlID
					AND realDDST.SoldToShipToID = stagingDDST.SoldToShipToID
				WHERE realDDST.ID IS NULL
				AND stagingDDST.DlHdrID = @DlHdrID
				AND stagingDDST.Action = 'A'
				AND stagingDDST.StagedUserID = @StagedUserID
				AND stagingDDST.StagedFromDealOrReport = @StagedFromDealOrReport

			--Delete all StagingRows that existed since all associated RealRows were deleted/modified/added above
			DELETE FROM dbo.MTVDealDetailShipToStaging
			WHERE DlHdrID = @DlHdrID 
			AND StagedUserID = @StagedUserID
			AND StagedFromDealOrReport = @StagedFromDealOrReport

			COMMIT TRANSACTION [Transac]

		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION [Transac]
			SELECT -1
			RETURN
		END CATCH
	
	SELECT 1
	RETURN 
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVApplyStagingTableUpdatesToDealDetailShipToTable]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVApplyStagingTableUpdatesToDealDetailShipToTable.sql'
	PRINT '<<< ALTERED StoredProcedure MTVApplyStagingTableUpdatesToDealDetailShipToTable >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVApplyStagingTableUpdatesToDealDetailShipToTable >>>'
END
 
