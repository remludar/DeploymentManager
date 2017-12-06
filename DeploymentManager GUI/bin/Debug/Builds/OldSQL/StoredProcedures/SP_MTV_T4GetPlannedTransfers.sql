/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_T4GetPlannedTransfers]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_T4GetPlannedTransfers.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_T4GetPlannedTransfers]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_T4GetPlannedTransfers] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_T4GetPlannedTransfers >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTV_T4GetPlannedTransfers] 
		@PrdctID INT = NULL
	,	@LcleID int = NULL
	,	@InternalBAID int = NULL
	,	@ExtrnlBAID int = NULL
	,	@ReceiptDelivery char(1) = NULL
	,	@ScheduleDateTime DateTime
	,   @CarrierReferenceBatchID  varchar(50) 
	,   @IsPipeLine char(1) = 'N'
	,   @NominationType char(1)= 'C'
	,   @T4TankageCode varchar(3) = NULL
AS

-- =============================================
-- Author:        Isaac Jacob
-- Create date:	  10/06/2015
-- Description:   
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_T4GetPlannedTransfers 18
-----------------------------------------------------------------------------

/*
--------------------------------------------
--DETERMINE ROWS TO PROCESS
--------------------------------------------
*/
--Declare @PrdctID		int
--		,@LcleID		int
--		,@InternalBAID	int
--		,@ExtrnlBAID	int
--		,@ReceiptDelivery char(1)
--		,@ScheduleDateTime DateTime
--		,@CarrierReferenceBatchID  varchar(50) 
--		,@SchdlngPrdID char(1)

--set @PrdctID	= 628
--set @LcleID		=  2460
--set @InternalBAID = 1
--set @ExtrnlBAID = 240
--set @ReceiptDelivery = 'D'
--set @ScheduleDateTime = '2015-01-23 00:00:00'
--set @CarrierReferenceBatchID = 'MTV-F4-711'
--set @SchdlngPrdID = 'N'

DECLARE @PlnndMvtBtchID INT
--DECLARE @SchdlngPrdID INT

--SELECT @SchdlngPrdID = SP.SchdlngPrdID FROM dbo.SchedulingPeriod SP (NOLOCK) WHERE  @ScheduleDateTime between SP.FROMDate and SP.ToDate

DECLARE @Transfers TABLE (
	PlnndTrnsfrID INT,
	DlDtlFrmDte DATETIME,
	DlDtlDlHdrID INT,
	DLDtlID INT,
	DealDetailID INT,
	PlnndMvtID INT,
	PlnndMvtBtchID INT,
	DlHdrTyp INT,
	DlHdrExtrnlBAID INT
)

IF (@IsPipeLine = 'N')
BEGIN
	SELECT	@PlnndMvtBtchID = P.PlnndMvtBtchID 
	FROM	dbo.PlannedMovementBatch P (NOLOCK)
	WHERE	Name = @CarrierReferenceBatchID
	AND		status = 'A'

    If (@NominationType = 'C')
	BEGIN
		INSERT INTO @Transfers
		SELECT	pt.PlnndTrnsfrID
				,	DD.DlDtlFrmDte
				,	DD.DlDtlDlHdrID
				,	DD.DLDtlID
				,   DD.DealDetailID      
				,   PlnndTrnsfrPlnndStPlnndMvtID as PlnndMvtID
				,	@PlnndMvtBtchID PlnndMvtBtchID
				,	DH.DlHdrTyp
				,	DH.DlHdrExtrnlBAID
		FROM	dbo.PlannedTransfer PT (NOLOCK)
		INNER JOIN dbo.DealHeader DH (NOLOCK)
		ON PT.PlnndTrnsfrObDlDtlDlHdrID = DH.DlHdrID
		INNER JOIN dbo.DealDetail DD (NOLOCK)
		ON	DD.DlDtlID = PT.PlnndTrnsfrObDlDtlID
		AND DD.DlDtlDlHdrID =  DH.DlHdrID
		AND DD.DlDtlPrdctID = @PrdctID
		AND DD.DlDtlLcleID  = @LcleID
		AND DH.DlHdrIntrnlBAID = @InternalBAID --xref(MTV)
		AND DH.DlHdrExtrnlBAID  = @ExtrnlBAID --xref(MTV)
		AND DD.DlDtlSpplyDmnd = @ReceiptDelivery 
		AND @ScheduleDateTime BETWEEN DD.DlDtlFrmDte AND DD.DlDtlToDte
		AND @ScheduleDateTime BETWEEN pt.EstimatedMovementDate AND pt.EstimatedMovementToDate
		--AND pt.EstimatedMovementDate <= DATEADD(DAY,5,@ScheduleDateTime)
		--AND pt.EstimatedMovementToDate >= DATEADD(DAY,-5,@ScheduleDateTime)
		--AND ISNULL(PT.SchdlngPrdID ,@SchdlngPrdID ) = @SchdlngPrdID
		AND PT.Status in ('A','P')			
	END
	ELSE IF (@NominationType = 'M')
	BEGIN
		INSERT INTO @Transfers
		SELECT	pt.PlnndTrnsfrID
				,	DD.DlDtlFrmDte
				,	DD.DlDtlDlHdrID
				,	DD.DLDtlID
				,   DD.DealDetailID      
				,   PlnndTrnsfrPlnndStPlnndMvtID as PlnndMvtID
				,	@PlnndMvtBtchID as PlnndMvtBtchID
				,	DH.DlHdrTyp
				,	DH.DlHdrExtrnlBAID
		FROM	dbo.PlannedTransfer PT (NOLOCK)
		INNER JOIN dbo.DealHeader DH (NOLOCK)
			ON PT.PlnndTrnsfrObDlDtlDlHdrID = DH.DlHdrID				
		INNER JOIN dbo.GeneralConfiguration GCEB (NOLOCK)
		ON  GCEB.GnrlCnfgTblNme = 'PlannedMovement'
		And  GCEB.GnrlCnfgQlfr = 'ExternalBatch'
		And GCEB.GnrlCnfgMulti =  @CarrierReferenceBatchID
		And GCEB.GnrlCnfgHdrID  =  PlnndTrnsfrPlnndStPlnndMvtID
		INNER JOIN dbo.DealDetail DD (NOLOCK)
		ON	DD.DlDtlID = PT.PlnndTrnsfrObDlDtlID
		AND DD.DlDtlDlHdrID =  DH.DlHdrID
		AND DD.DlDtlPrdctID = @PrdctID
		AND DD.DlDtlLcleID  = @LcleID
		AND DH.DlHdrIntrnlBAID = @InternalBAID --xref(MTV)
		AND DH.DlHdrExtrnlBAID  = @ExtrnlBAID --xref(MTV)
		AND DD.DlDtlSpplyDmnd = @ReceiptDelivery 
		AND @ScheduleDateTime BETWEEN DD.DlDtlFrmDte AND DD.DlDtlToDte
		--AND @ScheduleDateTime BETWEEN pt.EstimatedMovementDate AND pt.EstimatedMovementToDate
		AND pt.EstimatedMovementDate <= DATEADD(DAY,5,@ScheduleDateTime)
		AND pt.EstimatedMovementToDate >= DATEADD(DAY,-5,@ScheduleDateTime)
		--AND isNull(PT.SchdlngPrdID ,@SchdlngPrdID ) = @SchdlngPrdID
		AND PT.Status = 'S'
	END
END
ELSE IF (@IsPipeLine = 'Y')
BEGIN
	INSERT INTO @Transfers
	SELECT	PlnndTrnsfrID
		,	DD.DlDtlFrmDte
		,	DD.DlDtlDlHdrID
		,	DD.DLDtlID
		,   DD.DealDetailID      
		,   PlnndTrnsfrPlnndStPlnndMvtID PlnndMvtID
		,	@PlnndMvtBtchID PlnndMvtBtchID
		,	DH.DlHdrTyp
		,	DH.DlHdrExtrnlBAID
	FROM	dbo.PlannedTransfer PT (NOLOCK)
	INNER JOIN dbo.DealHeader DH (NOLOCK)
		ON PT.PlnndTrnsfrObDlDtlDlHdrID = DH.DlHdrID
	INNER JOIN dbo.DealDetail DD (NOLOCK)
	ON	DD.DlDtlID = PT.PlnndTrnsfrObDlDtlID
	AND DD.DlDtlDlHdrID =  DH.DlHdrID
	AND DD.DlDtlPrdctID = @PrdctID
	AND DD.DlDtlLcleID  = @LcleID
	AND DH.DlHdrIntrnlBAID = @InternalBAID --xref(MTV)
	AND DH.DlHdrExtrnlBAID  = @ExtrnlBAID --xref(MTV)
	AND DD.DlDtlSpplyDmnd = @ReceiptDelivery 		
	AND @ScheduleDateTime BETWEEN DD.DlDtlFrmDte AND DD.DlDtlToDte
	--AND @ScheduleDateTime BETWEEN pt.EstimatedMovementDate AND pt.EstimatedMovementToDate
	AND pt.EstimatedMovementDate <= DATEADD(DAY,5,@ScheduleDateTime)
		AND pt.EstimatedMovementToDate >= DATEADD(DAY,-5,@ScheduleDateTime)
	AND PT.SchdlngPrdID is NULL
	AND PT.Status = 'A'
END

IF (@@ROWCOUNT < 2)
	SELECT * FROM @Transfers
ELSE
BEGIN
	--Delete transfer types where the external ba is internal for deal types of Pipeline.
	DELETE t
	FROM @Transfers t
	INNER JOIN dbo.BusinessAssociate ba (NOLOCK)
	ON ba.BAID = t.DlHdrExtrnlBAID
	AND ba.BATpe = 'D'
	INNER JOIN dbo.DealType dt (NOLOCK)
	ON dt.DlTypID = t.DlHdrTyp
	AND dt.Description = 'Pipeline Deal'

	SELECT t.*
	FROM @Transfers t
	LEFT OUTER JOIN dbo.GeneralConfiguration gc
	ON gc.GnrlCnfgHdrID = t.PlnndMvtID
	AND gc.GnrlCnfgTblNme = 'PlannedMovement'
	AND gc.GnrlCnfgQlfr = 'T4TankageCode'
	WHERE ISNULL(gc.GnrlCnfgMulti,@T4TankageCode) = @T4TankageCode
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_T4GetPlannedTransfers]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_T4GetPlannedTransfers.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_T4GetPlannedTransfers >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_T4GetPlannedTransfers >>>'
	  END


	 