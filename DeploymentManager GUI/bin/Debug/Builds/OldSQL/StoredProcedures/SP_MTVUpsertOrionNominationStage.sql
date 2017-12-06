/****** Object:  StoredProcedure [dbo].[MTVUpsertOrionNominationStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVUpsertOrionNominationStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUpsertOrionNominationStage]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVUpsertOrionNominationStage] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTVUpsertOrionNominationStage >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVUpsertOrionNominationStage]
	@TransferStatus CHAR(1),
	@PlnndMvtID INT,
	@PlnndTrnsfrID INT,
	@LocaleID INT,
	@PrdctID INT,
	@PUMP_DATE DATETIME,
	@VOLUME FLOAT,
	@DealHdrTripID INT = NULL,
	@RDIndicator CHAR(1),
	@MethodTransportation CHAR(2)
AS

-- =============================================
-- Author:        Alan Oldfield
-- Create date:	  12/20/2015
-- Description:   Adds\Deletes and updates nominations for orion to staging table.
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--  
-- ----------------------------------------------------------------------------------------------------------
DECLARE @Vessel NVARCHAR(100)

--Only process the records if they are setup as a refinary for Orion, 
--the Transfer is a Blending deal,
--and no Transfer on the Order is a Production/Consumption Deal
IF NOT EXISTS(	SELECT 1
				FROM dbo.GeneralConfiguration gc (NOLOCK)
				WHERE GnrlCnfgTblNme= 'locale'
				AND GnrlCnfgQlfr = 'CCTSite'
				AND GnrlCnfgHdrID = @LocaleID)
RETURN
IF NOT EXISTS(	SELECT 1 
				FROM dbo.PlannedTransfer (NOLOCK)
				INNER JOIN dbo.DealHeader (NOLOCK) 
					ON PlnndTrnsfrObDlDtlDlHdrID = DlHdrID
				WHERE PlnndTrnsfrID = @PlnndTrnsfrID AND DlHdrTyp = 59)
RETURN
IF EXISTS(		SELECT 1
				FROM dbo.PlannedMovement mvt (NOLOCK)
				INNER JOIN dbo.PlannedTransfer trans (NOLOCK)
				ON mvt.PlnndMvtID = trans.PlnndTrnsfrPlnndStPlnndMvtID
				INNER JOIN dbo.DealHeader dh (NOLOCK)
				ON trans.PlnndTrnsfrObDlDtlDlHdrID = dh.DlHdrID
				WHERE mvt.PlnndMvtID = @PlnndMvtID
				AND (dh.EntityTemplateID = 26 OR dh.EntityTemplateID = 27))
RETURN


IF (@TransferStatus = 'I')
	DELETE FROM dbo.MTVOrionNominationStaging WHERE PlnndTrnsfrID = @PlnndTrnsfrID 
ELSE
BEGIN

	--Get a list of all the vessels used in the trip. Or if empty, use the Order Vehicle ID
	IF (@DealHdrTripID IS NOT NULL)
	BEGIN
		IF EXISTS( 
			SELECT 1
			FROM dbo.DealHeaderTrip dht (NOLOCK)
			INNER JOIN dbo.Vehicle v (NOLOCK)
			ON v.VhcleID = dht.DlHdrTrpID
			WHERE dht.DlHdrTrpID = @DealHdrTripID)
		BEGIN
			SELECT @Vessel = SUBSTRING(ISNULL((SELECT(
				SELECT ', ' + RTRIM(v.VhcleNme)
				FROM dbo.DealHeaderTrip dht (NOLOCK)
				INNER JOIN dbo.Vehicle v (NOLOCK)
				ON v.VhcleID = dht.DlHdrTrpID
				WHERE dht.DlHdrTrpID = @DealHdrTripID
				FOR XML PATH('')) AS l), ''), 3, 100)
		END
		ELSE
		BEGIN
			SELECT @Vessel = v.VhcleNme FROM dbo.PlannedMovement pm (NOLOCK)
			INNER JOIN dbo.Vehicle v (NOLOCK)
			ON pm.VehicleID = v.VhcleID
			WHERE pm.PlnndMvtID = @PlnndMvtID
		END
	END
	ELSE
	BEGIN
		SELECT @Vessel = v.VhcleNme FROM dbo.PlannedMovement pm (NOLOCK)
		INNER JOIN dbo.Vehicle v (NOLOCK)
		ON pm.VehicleID = v.VhcleID
		WHERE pm.PlnndMvtID = @PlnndMvtID
	END

	IF EXISTS(SELECT 1 FROM dbo.MTVOrionNominationStaging WHERE PlnndTrnsfrID = @PlnndTrnsfrID)
	BEGIN
		--Update the staging table where changes occurred for the staging row.
		UPDATE dbo.MTVOrionNominationStaging SET
			PlnndMvtID = @PlnndMvtID,
			LocaleID = @LocaleID,
			PrdctID = @PrdctID,
			PUMP_DATE = @PUMP_DATE,
			VOLUME = @VOLUME,
			RDIndicator = @RDIndicator,
			MethodTransportation = @MethodTransportation,
			Vessel = @Vessel,
			ChangeDate = GETDATE()
		WHERE PlnndTrnsfrID = @PlnndTrnsfrID
		AND CHECKSUM(PlnndMvtID,LocaleID,PrdctID,PUMP_DATE,VOLUME,RDIndicator,MethodTransportation,Vessel) != 
			CHECKSUM(@PlnndMvtID,@LocaleID,@PrdctID,@PUMP_DATE,@VOLUME,@RDIndicator,@MethodTransportation,@Vessel)
	END
	ELSE
	BEGIN
		--Insert new records
		INSERT INTO dbo.MTVOrionNominationStaging (PlnndMvtID,PlnndTrnsfrID,LocaleID,PrdctID,PUMP_DATE,VOLUME,RDIndicator,MethodTransportation,Vessel,ChangeDate)
		SELECT @PlnndMvtID,@PlnndTrnsfrID,@LocaleID,@PrdctID,@PUMP_DATE,@VOLUME,@RDIndicator,@MethodTransportation,@Vessel,GETDATE()
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVUpsertOrionNominationStage]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVUpsertOrionNominationStage.sql'
	PRINT '<<< ALTERED StoredProcedure MTVUpsertOrionNominationStage >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVUpsertOrionNominationStage >>>'
END
 
