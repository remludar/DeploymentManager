/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVArchiveDealDetails WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTVArchiveDealDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDealDetails.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealDetails]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVArchiveDealDetails] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVArchiveDealDetails >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVArchiveDealDetails] @DlHdrID INT,@DlDtlID INT
AS
SET NOCOUNT ON
-- ==========================================================================================
-- Author:		Alan Oldfield
-- Create date: July 7, 2016
-- Description:	Correct the billing term on erroneous FedTax invoices
-- ==========================================================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
DECLARE @MaxRevisionID INT,@CurrentChangeCheckSum INT,@SecondaryChangeCheckSum INT

DECLARE @ChangeRow TABLE (
	DlHdrID INT NOT NULL,
	DlDtlID INT NOT NULL,
	DlDtlTrmTrmID INT,
	DlDtlPrdctID INT,
	DlDtlQntty FLOAT,
	DlDtlVlmeTrmTpe CHAR(1),
	SchedulingQuantityTerm CHAR(1),
	DlDtlDsplyUOM SMALLINT,
	DlDtlApprxmteQntty CHAR(1),
	VolumeToleranceDirection CHAR(1),
	ToleranceWhoseOption CHAR(1),
	VolumeToleranceQuantity FLOAT,
	DlDtlLcleID INT,
	OriginLcleID INT,
	DestinationLcleID INT,
	DeliveryTermID INT,
	DlDtlMthdTrnsprttn CHAR(1),
	DlDtlFrmDte DATETIME,
	DlDtlToDte DATETIME,
	RevisionComment VARCHAR(MAX),
	SubType VARCHAR(4),
	DlDtlSpplyDmnd CHAR(1),
	PipeLineName VARCHAR(80),
	SAPSoldToShipTo VARCHAR(10),
	LoadingFromDate DATETIME,
	LoadingToDate DATETIME,
	PipelineCycle VARCHAR(2000),
	Ratio FLOAT,
	DemurrageAnalyst INT,
	Scheduler INT,
	RevisionDate DATETIME NOT NULL,
	RevisionUserID INT NOT NULL
)

INSERT INTO @ChangeRow
SELECT dd.DlDtlDlHdrID,
	dd.DlDtlID,
	dd.DlDtlTrmTrmID,
	dd.DlDtlPrdctID,
	dd.DlDtlQntty,
	dd.DlDtlVlmeTrmTpe,
	dd.SchedulingQuantityTerm,
	dd.DlDtlDsplyUOM,
	dd.DlDtlApprxmteQntty,
	dd.VolumeToleranceDirection,
	dd.ToleranceWhoseOption,
	dd.VolumeToleranceQuantity,
	dd.DlDtlLcleID,
	dd.OriginLcleID,
	dd.DestinationLcleID,
	dd.DeliveryTermID,
	dd.DlDtlMthdTrnsprttn,
	dd.DlDtlFrmDte,
	dd.DlDtlToDte,
	dd.RevisionComment,
	dd.SubType,
	dd.DlDtlSpplyDmnd,
	dd.PipeLineName,
	NULL, --st.ShipTo,
	dd.LoadingWindowFromDate,
	dd.LoadingWindowToDate,
	NULL,
	NULL,
	NULL,
	NULL,
	dd.DlDtlRvsnDte,
	dd.DlDtlRvsnUserID
FROM dbo.DealDetail dd (NOLOCK)
--LEFT OUTER JOIN dbo.MTVDealDetailShipTo ddst (NOLOCK)
--INNER JOIN dbo.MTVSAPSoldToShipTo st (NOLOCK)
--ON ddst.SoldToShipToID = st.ID
--ON ddst.DealDetailID = dd.DealDetailID
WHERE dd.DlDtlDlHdrID = @DlHdrID
AND dd.DlDtlID = @DlDtlID

UPDATE c SET c.Scheduler = g.GnrlCnfgMulti
FROM @ChangeRow c
INNER JOIN dbo.GeneralConfiguration g (NOLOCK)
ON g.GnrlCnfgHdrID = c.DlHdrID
AND g.GnrlCnfgDtlID = c.DlDtlID
AND g.GnrlCnfgTblNme = 'DealDetail'
AND g.GnrlCnfgQlfr = 'Scheduler'
AND g.GnrlCnfgMulti IS NOT NULL

UPDATE c SET c.Ratio = CAST(g.GnrlCnfgMulti AS FLOAT)
FROM @ChangeRow c
INNER JOIN dbo.GeneralConfiguration g (NOLOCK)
ON g.GnrlCnfgHdrID = c.DlHdrID
AND g.GnrlCnfgDtlID = c.DlDtlID
AND g.GnrlCnfgTblNme = 'DealDetail'
AND g.GnrlCnfgQlfr = 'Ratio'
AND g.GnrlCnfgMulti IS NOT NULL
AND ISNUMERIC(g.GnrlCnfgMulti) = 1

UPDATE c SET c.DemurrageAnalyst = g.GnrlCnfgMulti
FROM @ChangeRow c
INNER JOIN dbo.GeneralConfiguration g (NOLOCK)
ON g.GnrlCnfgHdrID = c.DlHdrID
AND g.GnrlCnfgDtlID = c.DlDtlID
AND g.GnrlCnfgTblNme = 'DealDetail'
AND g.GnrlCnfgQlfr = 'DemurrageAnalyst'
AND g.GnrlCnfgMulti IS NOT NULL

UPDATE @ChangeRow SET PipelineCycle = (	SELECT SUBSTRING(ISNULL((SELECT(
										SELECT DISTINCT ',' +  LTRIM(RTRIM(pc.CycleName))
										FROM dbo.ObligationDetail od (NOLOCK)
										INNER JOIN dbo.PipelineCycle pc
										ON pc.PipelineCycleID = od.PipelineCycleID
										WHERE DlHdrID = @DlHdrID
										AND DlDtlID = @DlDtlID
										FOR XML PATH('') ) As Details
										), ''), 2, 2000))

SELECT	@CurrentChangeCheckSum = CHECKSUM(DlDtlPrdctID,DlDtlQntty,DlDtlDsplyUOM,DlDtlApprxmteQntty,VolumeToleranceDirection,
									ToleranceWhoseOption,VolumeToleranceQuantity,DlDtlLcleID,OriginLcleID,DestinationLcleID,
									DeliveryTermID,DlDtlMthdTrnsprttn,DlDtlFrmDte,DlDtlToDte,PipeLineName,DlDtlTrmTrmID,
									LoadingFromDate,LoadingToDate,PipelineCycle,Ratio,DemurrageAnalyst,Scheduler),
		@SecondaryChangeCheckSum = CHECKSUM(RevisionComment,SubType,DlDtlSpplyDmnd,DlDtlVlmeTrmTpe,SchedulingQuantityTerm,SAPSoldToShipTo)
FROM @ChangeRow

SELECT @MaxRevisionID = MAX(RevisionID) FROM dbo.MTVDealDetailArchive (NOLOCK) WHERE DlHdrID = @DlHdrID AND DlDtlID = @DlDtlID
IF (@MaxRevisionID IS NULL)  --New Row
BEGIN
	INSERT INTO dbo.MTVDealDetailArchive
	SELECT	0,
			DlHdrID,
			DlDtlID,
			'A',
			DlDtlTrmTrmID,
			DlDtlPrdctID,
			DlDtlQntty,
			DlDtlVlmeTrmTpe,
			SchedulingQuantityTerm,
			DlDtlDsplyUOM,
			DlDtlApprxmteQntty,
			VolumeToleranceDirection,
			ToleranceWhoseOption,
			VolumeToleranceQuantity,
			DlDtlLcleID,
			OriginLcleID,
			DestinationLcleID,
			DeliveryTermID,
			DlDtlMthdTrnsprttn,
			DlDtlFrmDte,
			DlDtlToDte,
			RevisionComment,
			SubType,
			DlDtlSpplyDmnd,
			PipeLineName,
			SAPSoldToShipTo,
			LoadingFromDate,
			LoadingToDate,
			PipelineCycle,
			Ratio,
			DemurrageAnalyst,
			Scheduler,
			RevisionDate,
			RevisionUserID,
			@CurrentChangeCheckSum,
			@SecondaryChangeCheckSum
	FROM @ChangeRow
	SELECT 'D' RevisionType,0 RevisionID,'A',RevisionDate,RevisionUserID,@DlDtlID DlDtlID FROM @ChangeRow
END
ELSE
BEGIN --Modified Row
	DECLARE @CurrentCheckSum INT,@SecondaryCheckSum INT

	SELECT @CurrentCheckSum = ColumnCheckSum,@SecondaryCheckSum = SecondaryCheckSum
	FROM dbo.MTVDealDetailArchive (NOLOCK)
	WHERE DlHdrID = @DlHdrID
	AND DlDtlID = @DlDtlID
	AND RevisionID = @MaxRevisionID

	IF (@CurrentCheckSum = @CurrentChangeCheckSum)
	BEGIN
		IF (@SecondaryCheckSum != @SecondaryChangeCheckSum)
		BEGIN
			UPDATE a SET	a.SecondaryCheckSum = @SecondaryChangeCheckSum,
							a.RevisionComment = c.RevisionComment,
							a.SubType = c.SubType,
							a.DlDtlSpplyDmnd = c.DlDtlSpplyDmnd,
							a.DlDtlVlmeTrmTpe = c.DlDtlVlmeTrmTpe,
							a.SchedulingQuantityTerm = c.SchedulingQuantityTerm,
							a.SAPSoldToShipTo = c.SAPSoldToShipTo,
							a.RevisionDate = c.RevisionDate,
							a.RevisionUserID = c.RevisionUserID
			FROM dbo.MTVDealDetailArchive a
			INNER JOIN @ChangeRow c
			ON a.DlHdrID = c.DlHdrID
			AND a.DlDtlID = c.DlDtlID
			AND a.RevisionID = @MaxRevisionID
		END
		SELECT 'D' RevisionType,@MaxRevisionID RevisionID,'N',RevisionDate,RevisionUserID,@DlDtlID DlDtlID FROM @ChangeRow
	END
	ELSE
	BEGIN
		INSERT INTO dbo.MTVDealDetailArchive
		SELECT @MaxRevisionID + 1,
			DlHdrID,
			DlDtlID,
			'M',
			DlDtlTrmTrmID,
			DlDtlPrdctID,
			DlDtlQntty,
			DlDtlVlmeTrmTpe,
			SchedulingQuantityTerm,
			DlDtlDsplyUOM,
			DlDtlApprxmteQntty,
			VolumeToleranceDirection,
			ToleranceWhoseOption,
			VolumeToleranceQuantity,
			DlDtlLcleID,
			OriginLcleID,
			DestinationLcleID,
			DeliveryTermID,
			DlDtlMthdTrnsprttn,
			DlDtlFrmDte,
			DlDtlToDte,
			RevisionComment,
			SubType,
			DlDtlSpplyDmnd,
			PipeLineName,
			SAPSoldToShipTo,
			LoadingFromDate,
			LoadingToDate,
			PipelineCycle,
			Ratio,
			DemurrageAnalyst,
			Scheduler,
			RevisionDate,
			RevisionUserID,
			@CurrentChangeCheckSum,
			@SecondaryChangeCheckSum
		FROM @ChangeRow
		SELECT 'D' RevisionType,@MaxRevisionID+1 RevisionID,'M',RevisionDate,RevisionUserID,@DlDtlID DlDtlID FROM @ChangeRow
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealDetails]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVArchiveDealDetails.sql'
			PRINT '<<< ALTERED StoredProcedure MTVArchiveDealDetails >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVArchiveDealDetails >>>'
	  END