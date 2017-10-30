/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVPlannedTransferArchiveEntries WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPlannedTransferArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPlannedTransferArchiveEntries.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVPlannedTransferArchiveEntries]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVPlannedTransferArchiveEntries]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVPlannedTransferArchiveEntries]
    PRINT '<<< DROPPED TABLE MTVPlannedTransferArchiveEntries >>>'
END


/****** Object:  Table [dbo].[MTVPlannedTransferArchiveEntries]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  OBJECT_ID('tempdb..#MTVTransferArchiveEntries') IS NOT NULL
BEGIN
    DROP TABLE #MTVTransferArchiveEntries
END

Create Table #MTVTransferArchiveEntries
(
	ID							Int IDENTITY(1,1) PRIMARY KEY,
	PlnndTrnsfrID 				Int,
	EstimatedMovementDate		DateTime,
	EstimatedMovementToDate		DateTime,
	SchdlngPrdID				Int,
	AliasPrdctID				Int,
	PlnndTrnsfrTtlQty			Float,
	PhysicalLcleID 				Int,
	CustomStatus				VarChar(3),
	Note						VarChar(255),
	CreationDate				SmallDateTime,
	ModificationDate			SmallDateTime,
	UserID 						Int
)

INSERT INTO  [#MTVTransferArchiveEntries] (
						 [PlnndTrnsfrID]
						,[EstimatedMovementDate]
						,[EstimatedMovementToDate]
						,[SchdlngPrdID]
						,[AliasPrdctID]
						,[PlnndTrnsfrTtlQty]
						,[PhysicalLcleID]
						,[CustomStatus]
						,[Note]
						,[CreationDate]
						,[ModificationDate]
						,[UserID])

(SELECT DISTINCT	 A.PlnndTrnsfrID,
					 A.EstimatedMovementDate,
					 A.EstimatedMovementToDate,
					 A.SchdlngPrdID,
					 A.AliasPrdctID,
					 A.PlnndTrnsfrTtlQty,
					 A.PhysicalLcleID,
					 A.UserDefinedStatus,
					 A.Note,
					 B.ChangeDate AS CreationDate,
					 A.ChangeDate AS ModificationDate,
					 A.UserID
FROM PlannedTransferArchive A
LEFT JOIN PlannedTransferArchive B
ON A.PlnndTrnsfrID = B.PlnndTrnsfrID and B.Price is null)
ORDER BY PlnndTrnsfrID,A.ChangeDate

Create Table MTVPlannedTransferArchiveEntries
(
	ID								Int,
	PlnndTrnsfrID 					Int,
	EstimatedMovementDate			DateTime,
	EstimatedMovementToDate			DateTime,
	SchdlngPrdID					Int,
	AliasPrdctID					Int,
	PlnndTrnsfrTtlQty				Float,
	PhysicalLcleID 					Int,
	CustomStatus					VarChar(3),
	Note							VarChar(255),
	CreationDate					SmallDateTime,
	ModificationDate				SmallDateTime,
	UserID 							Int,
	IDPrior							Int,
	PlnndTrnsfrIDPrior 				Int,
	EstimatedMovementDatePrior		DateTime,
	EstimatedMovementToDatePrior	DateTime,
	SchdlngPrdIDPrior				Int,
	AliasPrdctIDPrior				Int,
	PlnndTrnsfrTtlQtyPrior			Float,
	PhysicalLcleIDPrior 			Int,
	CustomStatusPrior				VarChar(3),
	NotePrior						VarChar(255),
	CreationDatePrior				SmallDateTime,
	ModificationDatePrior			SmallDateTime,
	UserIDPrior 					Int,
	TransferArchiveStatus 			VarChar(500),
	ModifiedColumn 					VarChar(500)
)

Insert Into  [MTVPlannedTransferArchiveEntries] (
			 [ID]
			,[PlnndTrnsfrID]
			,[EstimatedMovementDate]
			,[EstimatedMovementToDate]
			,[SchdlngPrdID]
			,[AliasPrdctID]
			,[PlnndTrnsfrTtlQty]
			,[PhysicalLcleID]
			,[CustomStatus]
			,[Note]
			,[CreationDate]
			,[ModificationDate]
			,[UserID]
			,[IDPrior]
			,[PlnndTrnsfrIDPrior]
			,[EstimatedMovementDatePrior]
			,[EstimatedMovementToDatePrior]
			,[SchdlngPrdIDPrior]
			,[AliasPrdctIDPrior]
			,[PlnndTrnsfrTtlQtyPrior]
			,[PhysicalLcleIDPrior]
			,[CustomStatusPrior]
			,[NotePrior]
			,[CreationDatePrior]
			,[ModificationDatePrior]
			,[UserIDPrior]
			,[TransferArchiveStatus]
			,[ModifiedColumn])

 (select	 A.ID
			,A.PlnndTrnsfrID
			,A.EstimatedMovementDate
			,A.EstimatedMovementToDate
			,A.SchdlngPrdID
			,A.AliasPrdctID
			,A.PlnndTrnsfrTtlQty
			,A.PhysicalLcleID
			,A.CustomStatus
			,A.Note
			,A.CreationDate
			,A.ModificationDate
			,A.UserID
			,B.ID
			,B.PlnndTrnsfrID
			,B.EstimatedMovementDate
			,B.EstimatedMovementToDate
			,B.SchdlngPrdID
			,B.AliasPrdctID
			,B.PlnndTrnsfrTtlQty
			,B.PhysicalLcleID
			,B.CustomStatus
			,B.Note
			,B.CreationDate
			,B.ModificationDate
			,B.UserID
			,CASE WHEN B.ID is null THEN 'New' 
					  WHEN B.ID is not null THEN 'Modified'
					  ELSE 'Unknown' END
			,CASE WHEN B.ID is null THEN 'Transfer Created'
					  --WHEN A.SchdlngPrdID <> B.SchdlngPrdID THEN 'Scheduling Period'
					  --WHEN A.EstimatedMovementDate <> B.EstimatedMovementDate THEN 'Estimated Movement From Date'
					  --WHEN A.EstimatedMovementToDate <> B.EstimatedMovementToDate THEN 'Estimated Movement To Date'
					  --WHEN A.CustomStatus <> B.CustomStatus THEN 'Custom Status'
					  --WHEN A.Note <> B.Note THEN 'Note'
					  --WHEN A.PlnndTrnsfrTtlQty <> B.PlnndTrnsfrTtlQty THEN 'Total Volume'
					  --WHEN A.PhysicalLcleID <> B.PhysicalLcleID THEN 'Location'
					  ELSE '' END
from #MTVTransferArchiveEntries A
LEFT JOIN #MTVTransferArchiveEntries B
ON A.PlnndTrnsfrID = B.PlnndTrnsfrID and A.ID = B.ID + 1)

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= ISNULL(ModifiedColumn,'') + 'Scheduling Period|| '
FROM	MTVPlannedTransferArchiveEntries
WHERE	MTVPlannedTransferArchiveEntries.SchdlngPrdID <> MTVPlannedTransferArchiveEntries.SchdlngPrdIDPrior

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= ISNULL(ModifiedColumn,'') + 'Estimated Movement From Date|| '
FROM	MTVPlannedTransferArchiveEntries
WHERE	MTVPlannedTransferArchiveEntries.EstimatedMovementDate <> MTVPlannedTransferArchiveEntries.EstimatedMovementDatePrior

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= ISNULL(ModifiedColumn,'') + 'Estimated Movement To Date|| '
FROM	MTVPlannedTransferArchiveEntries
WHERE	MTVPlannedTransferArchiveEntries.EstimatedMovementToDate <> MTVPlannedTransferArchiveEntries.EstimatedMovementToDatePrior

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= ISNULL(ModifiedColumn,'') + 'Custom Status|| '
FROM	MTVPlannedTransferArchiveEntries
WHERE	MTVPlannedTransferArchiveEntries.CustomStatus <> MTVPlannedTransferArchiveEntries.CustomStatusPrior

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= ISNULL(ModifiedColumn,'') + 'Note|| '
FROM	MTVPlannedTransferArchiveEntries
WHERE	MTVPlannedTransferArchiveEntries.Note <> MTVPlannedTransferArchiveEntries.NotePrior

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= ISNULL(ModifiedColumn,'') + 'Total Volume|| '
FROM	MTVPlannedTransferArchiveEntries
WHERE	MTVPlannedTransferArchiveEntries.PlnndTrnsfrTtlQty <> MTVPlannedTransferArchiveEntries.PlnndTrnsfrTtlQtyPrior

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= ISNULL(ModifiedColumn,'') + 'Location|| '
FROM	MTVPlannedTransferArchiveEntries
WHERE	MTVPlannedTransferArchiveEntries.PhysicalLcleID <> MTVPlannedTransferArchiveEntries.PhysicalLcleIDPrior

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= ISNULL(ModifiedColumn,'') + 'Product|| '
FROM	MTVPlannedTransferArchiveEntries
WHERE	MTVPlannedTransferArchiveEntries.AliasPrdctID <> MTVPlannedTransferArchiveEntries.AliasPrdctIDPrior

UPDATE	MTVPlannedTransferArchiveEntries
SET		ModifiedColumn	= SUBSTRING(ModifiedColumn, 0, LEN(ModifiedColumn) - 1)
FROM	MTVPlannedTransferArchiveEntries
WHERE	ModifiedColumn like '%||'

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVPlannedTransferArchiveEntries]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVPlannedTransferArchiveEntries.sql'
    PRINT '<<< CREATED TABLE MTVPlannedTransferArchiveEntries >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVPlannedTransferArchiveEntries >>>'

	 