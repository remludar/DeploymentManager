PRINT 'Start Script=SP_MOT_TransferAuditSearch.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_TransferAuditSearch]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MOT_TransferAuditSearch] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MOT_TransferAuditSearch >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MOT_TransferAuditSearch]
	@DealNumber VARCHAR(30) = '%',
	@DealDetailID INT = NULL,
	@FromChangeDate DATETIME = '1/1/1900',
	@ToChangeDate DATETIME = '12/31/3000'
AS
--EXEC MOT_TransferAuditSearch @DealNumber = 'NIS17TS0001',@DealDetailID = NULL,@FromChangeDate = '2017-07-12 00:00:00',@ToChangeDate = '2017-07-12 00:00:00'
--SELECT @DealNumber = 'REF17TS0003'
--SELECT @DealDetailID = 1
--SELECT @FromChangeDate = '2017-07-4 15:31:00',@ToChangeDate = '2018-07-05 15:51:00'

SELECT @FromChangeDate = CAST(@FromChangeDate AS DATE)
SELECT @ToChangeDate = CAST(DATEADD(DAY,1,@ToChangeDate) AS DATE)

IF (@DealNumber = '')
	SELECT @DealNumber = '%'
ELSE
	SELECT @DealNumber = ISNULL(REPLACE(@DealNumber,'*','%'),'%')

SELECT	dh.DlHdrIntrnlNbr DealNumber,t.PlnndTrnsfrID,t.DlHdrID,t.DlDtlID,t.PrdctID,t.LcleID,t.EstimatedMovementDate,t.EstimatedMovementToDate,t.SchdlngPrdID,
		CASE ISNULL(t.ObligationQuantity,0) WHEN 0 THEN t.ObligationQuantity ELSE t.ObligationQuantity/42.0 END ObligationQuantity,
		CASE ISNULL(t.TotalQuantity,0) WHEN 0 THEN t.TotalQuantity ELSE t.TotalQuantity/42.0 END TotalQuantity,
		CASE ISNULL(t.ActualQuantity,0) WHEN 0 THEN t.ActualQuantity ELSE t.ActualQuantity/42.0 END ActualQuantity,
		CASE ISNULL(t.BestAvailableQuantity,0) WHEN 0 THEN t.BestAvailableQuantity ELSE t.BestAvailableQuantity/42.0 END BestAvailableQuantity,
		t.CustomStatus,t.StrtgyName,t.ModifiedColumns,t.CreationDate,t.ChangeDate,t.UserID
FROM dbo.MOT_PlannedTransferHistory t
INNER JOIN dbo.DealHeader dh WITH (NOLOCK)
ON dh.DlHdrID = t.DlHdrID
WHERE dh.DlHdrIntrnlNbr LIKE @DealNumber
AND t.DlDtlID = ISNULL(@DealDetailID,t.DlDtlID)
AND t.ChangeDate >= @FromChangeDate
AND t.ChangeDate < @ToChangeDate

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MOT_TransferAuditSearch]') IS NOT NULL
BEGIN
EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MOT_TransferAuditSearch.sql'
PRINT '<<< ALTERED StoredProcedure MOT_TransferAuditSearch >>>'
END
ELSE
BEGIN
PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MOT_TransferAuditSearch >>>'
END