/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_UpdatePlannedTransferArchiveEntries WITH YOUR view (NOTE:  GN_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_UpdatePlannedTransferArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdatePlannedTransferArchiveEntries.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdatePlannedTransferArchiveEntries]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_UpdatePlannedTransferArchiveEntries] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_UpdatePlannedTransferArchiveEntries >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_UpdatePlannedTransferArchiveEntries] WITH EXECUTE AS 'dbo'
AS

-- =============================================
-- Author:        Alec Aquino
-- Create date:	  1/27/2016
-- Description:   Update Deal Detail IO GSAP Attributes from Maintenance Report
-- =============================================
-- Date         Modified By     Issue#  Modification
-- 10/19/2016	Craig Albright	2730	remove underscores from the column names, as they break report framework
-- 11/03/2016	Joseph McClean	3705 	added AliasPrdctId to the list of columns to be reported on. (Enhancement)
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_UpdatePlannedTransferArchiveEntries 18
-----------------------------------------------------------------------------
Declare @ChangedColumns	VarChar(500)

Set NoCount ON

Truncate Table MTVPlannedTransferArchiveEntries

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

Insert Into	 [#MTVTransferArchiveEntries] (
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

(SELECT DISTINCT	A.PlnndTrnsfrID,
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
 (select A.ID
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdatePlannedTransferArchiveEntries]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_UpdatePlannedTransferArchiveEntries.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_UpdatePlannedTransferArchiveEntries >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_UpdatePlannedTransferArchiveEntries >>>'
	  END