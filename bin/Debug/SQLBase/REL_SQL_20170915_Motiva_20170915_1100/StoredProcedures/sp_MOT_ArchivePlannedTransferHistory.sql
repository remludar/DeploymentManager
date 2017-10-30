PRINT 'Start Script=SP_MOT_ArchivePlannedTransferHistory.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_ArchivePlannedTransferHistory]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MOT_ArchivePlannedTransferHistory] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MOT_ArchivePlannedTransferHistory >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE dbo.MOT_ArchivePlannedTransferHistory @PlnndTrnsfrID INT,@DlHdrID INT,@UpdateUserID INT
AS
SET NOCOUNT ON

DECLARE @DlHdrIntrnlBAID INT,@DlHdrTyp INT

--Include the following deal types for archiving:
--Buy/Sell Deal 100
--Purchase Deal 1
--Sale Deal 2
--EFP Deal (physical) 74
--Exchange Deal 20
--EFP (Financial) 
--Future Deal 70
--Future Inhouse Deal 76
--Swap Deal 72
--Swap Inhouse Deal 77

--If deal is not STL do not archive.
IF ((SELECT COUNT(1)
	FROM dbo.Registry r WITH (NOLOCK)
	INNER JOIN dbo.BusinessAssociate ba WITH (NOLOCK)
	ON ba.BANme = r.RgstryDtaVle
	AND r.RgstryKyNme = 'MotivaSTLIntrnlBAName'
	INNER JOIN dbo.DealHeader dh WITH (NOLOCK)
	ON (dh.DlHdrIntrnlBAID = ba.BAID OR dh.DlHdrExtrnlBAID = ba.BAID)
	AND dh.DlHdrID = @DlHdrID
	AND dh.DlHdrTyp IN (1,2,20,74,100)
								) < 1) RETURN

--EXEC MOT_ArchivePlannedTransferHistory @PlnndTrnsfrID = 232843
DECLARE		@DlDtlID INT,@PrdctID INT,@LcleID INT,@EstimatedMovementDate DATETIME,@EstimatedMovementToDate DATETIME,
			@SchdlngPrdID INT,@ObligationQuantity FLOAT,@TotalQuantity FLOAT,@ActualQuantity FLOAT,@BestAvailableQuantity FLOAT,
			@StrtgyName VARCHAR(300),@CustomStatus VARCHAR(1),@CreationDate DATETIME,@ChangeDate DATETIME,@UserID INT,@CompareCheckSum INT,
			@ModifiedColumns VARCHAR(300),@PrevID INT

DECLARE @PrevPrdctID INT,@PrevLcleID INT,@PrevEstimatedMovementDate DATETIME,@PrevEstimatedMovementToDate DATETIME,@PrevSchdlngPrdID INT,
		@PrevObligationQuantity FLOAT,@PrevTotalQuantity FLOAT,@PrevActualQuantity FLOAT,@PrevBestAvailableQuantity FLOAT,@PrevStrtgyName VARCHAR(300),
		@PrevCustomStatus VARCHAR(1),@PrevCreationDate DATETIME,@PrevChangeDate DATETIME,@PrevUserID INT,@PrevCompareCheckSum INT

SELECT	@DlDtlID = PlannedTransfer.PlnndTrnsfrObDlDtlID,
		@PrdctID = PlannedTransfer.AliasPrdctID,
		@LcleID = PlannedTransfer.PhysicalLcleID,
		@EstimatedMovementDate = PlannedTransfer.EstimatedMovementDate,
		@EstimatedMovementToDate = PlannedTransfer.EstimatedMovementToDate,
		@SchdlngPrdID = PlannedTransfer.SchdlngPrdID,
		@ObligationQuantity = SchedulingObligation.Quantity,
		@TotalQuantity = PlannedTransfer.PlnndTrnsfrTtlQty,
		@ActualQuantity = PlannedTransfer.PlnndTrnsfrActlQty,
		@BestAvailableQuantity = (SELECT CASE WHEN PlannedTransfer.Status = 'C' THEN PlannedTransfer.PlnndTrnsfrActlQty ELSE PlannedTransfer.PlnndTrnsfrTtlQty END),
		@StrtgyName = ISNULL ((	SELECT MAX(StrategySubset.CustomName)
					FROM (
						SELECT DISTINCT PlannedTransferChemical.PlnndTrnsfrID,StrategyHeader.Name CustomName
						FROM PlannedTransferChemical WITH (NOLOCK)
						INNER JOIN StrategyHeader WITH (NOLOCK)
						ON PlannedTransferChemical.StrtgyID = StrategyHeader.StrtgyID
						WHERE PlannedTransferChemical.PlnndTrnsfrID = PlannedTransfer.PlnndTrnsfrID) StrategySubset
						GROUP BY StrategySubset.PlnndTrnsfrID
						HAVING COUNT(StrategySubset.PlnndTrnsfrID) = 1), '(Multiple)'),
		@CustomStatus = PlannedTransfer.UserDefinedStatus,
		@ChangeDate = PlannedTransfer.ChangeDate,
		@UserID = PlannedTransfer.UserID,
		@CreationDate = PlannedTransfer.ChangeDate,
		@ModifiedColumns = ''
FROM dbo.PlannedTransfer WITH (NOLOCK)
LEFT JOIN dbo.SchedulingObligation WITH (NOLOCK)
ON PlannedTransfer.SchdlngOblgtnID = SchedulingObligation.SchdlngOblgtnID
WHERE PlannedTransfer.PlnndTrnsfrID = @PlnndTrnsfrID

SELECT @CompareCheckSum = CHECKSUM(@PrdctID,@LcleID,@EstimatedMovementDate,@EstimatedMovementToDate,@SchdlngPrdID,@ObligationQuantity,@TotalQuantity,@ActualQuantity,@BestAvailableQuantity,@StrtgyName,@CustomStatus)

SELECT @PrevID = MAX(ID) FROM dbo.MOT_PlannedTransferHistory WITH (NOLOCK) WHERE @PlnndTrnsfrID = PlnndTrnsfrID
IF (@PrevID IS NULL)
BEGIN
	INSERT INTO dbo.MOT_PlannedTransferHistory (PlnndTrnsfrID,DlHdrID,DlDtlID,PrdctID,LcleID,EstimatedMovementDate,EstimatedMovementToDate,SchdlngPrdID,ObligationQuantity,
				TotalQuantity,ActualQuantity,BestAvailableQuantity,StrtgyName,CustomStatus,CreationDate,ChangeDate,UserID,CompareCheckSum,ModifiedColumns)
	SELECT	@PlnndTrnsfrID,@DlHdrID,@DlDtlID,@PrdctID,@LcleID,@EstimatedMovementDate,@EstimatedMovementToDate,@SchdlngPrdID,@ObligationQuantity,@TotalQuantity,
			@ActualQuantity,@BestAvailableQuantity,@StrtgyName,@CustomStatus,@CreationDate,@ChangeDate,@UserID,@CompareCheckSum,'New'
END
ELSE
BEGIN
	SELECT	@PrevPrdctID = PrdctID,
			@PrevLcleID = LcleID,
			@PrevEstimatedMovementDate = EstimatedMovementDate,
			@PrevEstimatedMovementToDate = EstimatedMovementToDate,
			@PrevSchdlngPrdID = SchdlngPrdID,
			@PrevObligationQuantity = ObligationQuantity,
			@PrevTotalQuantity = TotalQuantity,
			@PrevActualQuantity = ActualQuantity,
			@PrevBestAvailableQuantity = BestAvailableQuantity,
			@PrevStrtgyName = StrtgyName,
			@PrevCustomStatus = CustomStatus,
			@PrevCreationDate = CreationDate,
			@PrevChangeDate = ChangeDate,
			@PrevUserID = UserID,
			@PrevCompareCheckSum = CompareCheckSum
	FROM dbo.MOT_PlannedTransferHistory WITH (NOLOCK)
	WHERE ID = @PrevID

	IF (@PrevCompareCheckSum != @CompareCheckSum)
	BEGIN
		IF (CHECKSUM(@PrdctID) != CHECKSUM(@PrevPrdctID)) SELECT @ModifiedColumns = 'PrdctID,'
		IF (CHECKSUM(@LcleID) != CHECKSUM(@PrevLcleID))	SELECT @ModifiedColumns = @ModifiedColumns + 'LcleID,'
		IF (CHECKSUM(@EstimatedMovementDate) != CHECKSUM(@PrevEstimatedMovementDate)) SELECT @ModifiedColumns = @ModifiedColumns + 'EstimatedMovementDate,'
		IF (CHECKSUM(@EstimatedMovementToDate) != CHECKSUM(@PrevEstimatedMovementToDate)) SELECT @ModifiedColumns = @ModifiedColumns + 'EstimatedMovementToDate2,'
		IF (CHECKSUM(@SchdlngPrdID) != CHECKSUM(@PrevSchdlngPrdID)) SELECT @ModifiedColumns = @ModifiedColumns + 'SchdlngPrdID,'
		IF (CHECKSUM(@ObligationQuantity) != CHECKSUM(@PrevObligationQuantity)) SELECT @UserID = @UpdateUserID,@ChangeDate = GETDATE(),@ModifiedColumns = @ModifiedColumns + 'ObligationQuantity,'
		IF (CHECKSUM(@TotalQuantity) != CHECKSUM(@PrevTotalQuantity)) SELECT @ModifiedColumns = @ModifiedColumns + 'TotalQuantity,'
		IF (CHECKSUM(@ActualQuantity) != CHECKSUM(@PrevActualQuantity)) SELECT @ModifiedColumns = @ModifiedColumns + 'ActualQuantity,'
		IF (CHECKSUM(@BestAvailableQuantity) != CHECKSUM(@PrevBestAvailableQuantity)) SELECT @ModifiedColumns = @ModifiedColumns + 'BestAvailableQuantity,'
		IF (CHECKSUM(@StrtgyName) != CHECKSUM(@PrevStrtgyName)) SELECT @UserID = @UpdateUserID,@ChangeDate = GETDATE(),@ModifiedColumns = @ModifiedColumns + 'StrtgyName,'
		IF (CHECKSUM(@CustomStatus) != CHECKSUM(@PrevCustomStatus)) SELECT @ModifiedColumns = @ModifiedColumns + 'CustomStatus,'
		IF (ISNULL(@ModifiedColumns,'') != '') SELECT @ModifiedColumns = SUBSTRING(@ModifiedColumns,1,LEN(@ModifiedColumns) - 1)

		INSERT INTO dbo.MOT_PlannedTransferHistory (PlnndTrnsfrID,DlHdrID,DlDtlID,PrdctID,LcleID,EstimatedMovementDate,EstimatedMovementToDate,SchdlngPrdID,ObligationQuantity,
					TotalQuantity,ActualQuantity,BestAvailableQuantity,StrtgyName,CustomStatus,CreationDate,ChangeDate,UserID,CompareCheckSum,ModifiedColumns,PrevID)
		SELECT	@PlnndTrnsfrID,@DlHdrID,@DlDtlID,@PrdctID,@LcleID,@EstimatedMovementDate,@EstimatedMovementToDate,@SchdlngPrdID,@ObligationQuantity,@TotalQuantity,@ActualQuantity,
				@BestAvailableQuantity,@StrtgyName,@CustomStatus,@PrevCreationDate,@ChangeDate,@UserID,@CompareCheckSum,@ModifiedColumns,@PrevID
	END
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MOT_ArchivePlannedTransferHistory]') IS NOT NULL
BEGIN
EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MOT_ArchivePlannedTransferHistory.sql'
PRINT '<<< ALTERED StoredProcedure MOT_ArchivePlannedTransferHistory >>>'
END
ELSE
BEGIN
PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MOT_ArchivePlannedTransferHistory >>>'
END