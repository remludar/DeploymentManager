/****** Object:  Table [dbo].[MOT_PlannedTransferHistory]    Script Date: 12/15/2015 9:40:03 AM ******/
PRINT 'Start Script=T_MOT_PlannedTransferHistory.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MOT_PlannedTransferHistory]    Script Date: 11/19/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MOT_PlannedTransferHistory]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].MOT_PlannedTransferHistory
	PRINT '<<< DROPPED TABLE MOT_PlannedTransferHistory >>>'
END

/****** Object:  Table [dbo].[MOT_PlannedTransferHistory]    Script Date: 12/15/2015 9:40:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE MOT_PlannedTransferHistory (
	ID INT IDENTITY(1,1),
	PlnndTrnsfrID INT NOT NULL,
	DlHdrID INT NOT NULL,
	DlDtlID INT NOT NULL,
	PrdctID INT NOT NULL,
	LcleID INT NOT NULL,
	EstimatedMovementDate DATETIME NOT NULL,
	EstimatedMovementToDate DATETIME NOT NULL,
	SchdlngPrdID INT,
	ObligationQuantity FLOAT NOT NULL,
	TotalQuantity FLOAT NOT NULL,
	ActualQuantity FLOAT NOT NULL,
	BestAvailableQuantity FLOAT NOT NULL,
	StrtgyName VARCHAR(300) NULL,
	CustomStatus VARCHAR(1) NULL,
	CreationDate DATETIME NOT NULL,
	ChangeDate DATETIME NOT NULL,
	UserID INT NOT NULL,
	CompareCheckSum INT NOT NULL,
	ModifiedColumns VARCHAR(300) NOT NULL,
	PrevID INT NULL,
	CONSTRAINT [PK_MOT_PlannedTransferHistory] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_MOT_PlannedTransferHistory] ON [dbo].[MOT_PlannedTransferHistory]
(
	[PlnndTrnsfrID] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

IF ((SELECT COUNT(1) FROM MOT_PlannedTransferHistory) < 1)
BEGIN
	DECLARE @BAID INT

	SELECT @BAID = ba.BAID
	FROM dbo.Registry r WITH (NOLOCK)
	INNER JOIN dbo.BusinessAssociate ba WITH (NOLOCK)
	ON r.RgstryDtaVle = ba.BANme
	AND r.RgstryKyNme = 'MotivaSTLIntrnlBAName'

	INSERT INTO dbo.MOT_PlannedTransferHistory (PlnndTrnsfrID,DlHdrID,DlDtlID,PrdctID,LcleID,EstimatedMovementDate,EstimatedMovementToDate,SchdlngPrdID,ObligationQuantity,
		TotalQuantity,ActualQuantity,BestAvailableQuantity,StrtgyName,CustomStatus,CreationDate,ChangeDate,UserID,CompareCheckSum,ModifiedColumns)
	SELECT	PlannedTransfer.PlnndTrnsfrID,
			PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID,
			PlannedTransfer.PlnndTrnsfrObDlDtlID,
			PlannedTransfer.AliasPrdctID,
			PlannedTransfer.PhysicalLcleID,
			PlannedTransfer.EstimatedMovementDate,
			PlannedTransfer.EstimatedMovementToDate,
			PlannedTransfer.SchdlngPrdID,
			SchedulingObligation.Quantity,
			PlannedTransfer.PlnndTrnsfrTtlQty,
				PlannedTransfer.PlnndTrnsfrActlQty,
			(SELECT CASE WHEN PlannedTransfer.Status = 'C' THEN PlannedTransfer.PlnndTrnsfrActlQty ELSE PlannedTransfer.PlnndTrnsfrTtlQty END),
			ISNULL ((	SELECT MAX(StrategySubset.CustomName)
						FROM (
							SELECT DISTINCT PlannedTransferChemical.PlnndTrnsfrID,StrategyHeader.Name CustomName
							FROM PlannedTransferChemical WITH (NOLOCK)
							INNER JOIN StrategyHeader WITH (NOLOCK)
							ON PlannedTransferChemical.StrtgyID = StrategyHeader.StrtgyID
							WHERE PlannedTransferChemical.PlnndTrnsfrID = PlannedTransfer.PlnndTrnsfrID) StrategySubset
							GROUP BY StrategySubset.PlnndTrnsfrID
							HAVING COUNT(StrategySubset.PlnndTrnsfrID) = 1), '(Multiple)'),
			PlannedTransfer.UserDefinedStatus,
			PlannedTransfer.ChangeDate,
			PlannedTransfer.ChangeDate,
			PlannedTransfer.UserID,
			1,
			'New'
	FROM dbo.PlannedTransfer WITH (NOLOCK)
	INNER JOIN dbo.DealHeader WITH (NOLOCK)
	ON DealHeader.DlHdrID = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
	AND (DealHeader.DlHdrIntrnlBAID = @BAID OR DealHeader.DlHdrExtrnlBAID = @BAID)
	AND DealHeader.DlHdrTyp IN (1,2,20,70,72,76,77,74,100)
	LEFT JOIN dbo.SchedulingObligation WITH (NOLOCK)
	ON PlannedTransfer.SchdlngOblgtnID = SchedulingObligation.SchdlngOblgtnID


	UPDATE MOT_PlannedTransferHistory SET CompareCheckSum = CHECKSUM(PrdctID,LcleID,EstimatedMovementDate,EstimatedMovementToDate,SchdlngPrdID,ObligationQuantity,TotalQuantity,ActualQuantity,BestAvailableQuantity,StrtgyName,CustomStatus)
END