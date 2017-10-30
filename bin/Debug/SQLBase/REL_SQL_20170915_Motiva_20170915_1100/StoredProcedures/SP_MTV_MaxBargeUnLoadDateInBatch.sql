/****** Object:  StoredProcedure [dbo].[MTV_MaxBargeUnLoadDateInBatch]    Script Date: 6/17/2016 10:12:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_MaxBargeUnLoadDateInBatch]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_MaxBargeUnLoadDateInBatch] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_MaxBargeUnLoadDateInBatch >>>'
	  END
GO
-- =======================================================================================================================================
-- Author:		Matt Perry	
-- Create date: 09/19/2016
-- Description:	MTV_MaxBargeUnLoadDateInBatch
-- =======================================================================================================================================


--execute [dbo].[MTV_MaxBargeUnLoadDateInBatch] @i_PlnndTrnsfrID = null, @i_DlDtlPrvsnID = 39457, @i_XHdrID = 281162 , @b_UseCarrierOnMoveDoc = 1, @b_IncludeSurcharge = 1
Alter PROCEDURE [dbo].[MTV_MaxBargeUnLoadDateInBatch]
	(
	@i_DlDtlPrvsnID			Int,
	@i_PlnndTrnsfrID		Int,
	@i_XHdrID				Int
	)

AS

Declare @i_PlnndMvtBtchID Int
Declare @sdt_Date SmallDateTime

Select	@i_PlnndMvtBtchID = PlannedMovementInPlannedMovementBatch.PlnndMvtBtchID
From	PlannedTransfer
		Inner Join PlannedMovementInPlannedMovementBatch on PlannedMovementInPlannedMovementBatch.PlnndMvtID = PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID
Where	PlannedTransfer.PlnndTrnsfrID = @i_PlnndTrnsfrID

If @i_PlnndMvtBtchID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find an order batch.',61000)
	Select GetDate()
	Return
End


Select	@sdt_Date = Max( Coalesce(	TransactionHeader.MovementDate,
						PlannedTransfer.EstimatedMovementToDate,
						PlannedSet.PlnndStToDte,
						PlannedMovement.PlnndMvtToDte
					)
		)
From	PlannedMovementInPlannedMovementBatch
		Inner Join PlannedMovement	On	PlannedMovement.PlnndMvtID = PlannedMovementInPlannedMovementBatch.PlnndMvtID
		Inner Join PlannedTransfer	On	PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID = PlannedMovementInPlannedMovementBatch.PlnndMvtID
									And	PlannedTransfer.PTReceiptDelivery = 'R'
									And	Exists
										(
										Select	1
										From	DealHeader
										Where	DealHeader.DlHdrID = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
										And		DealHeader.DlHdrTyp = 56 --Barge Deal
										)
		Left Outer Join PlannedSet	On	PlannedSet.PlnndStPlnndMvtID = PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID
									And	PlannedSet.PlnndStSqnceNmbr = PlannedTransfer.PlnndTrnsfrPlnndStSqnceNmbr
		Left Outer Join TransactionHeader
									On TransactionHeader.XHdrPlnndTrnsfrID = PlannedTransfer.PlnndTrnsfrID
									And	TransactionHeader.XHdrStat = 'C'
Where	PlannedMovementInPlannedMovementBatch.PlnndMvtBtchID = @i_PlnndMvtBtchID

If @sdt_Date is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find any barge discharge date in batch.',61000)
	Select GetDate()
	Return
End

Select	@sdt_Date




GO

