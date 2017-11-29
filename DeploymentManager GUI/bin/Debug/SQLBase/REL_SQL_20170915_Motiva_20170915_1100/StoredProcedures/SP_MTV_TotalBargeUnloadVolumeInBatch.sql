/****** Object:  StoredProcedure [dbo].[MTV_TotalBargeUnloadVolumeInBatch]    Script Date: 6/17/2016 10:12:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_TotalBargeUnloadVolumeInBatch]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_TotalBargeUnloadVolumeInBatch] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_TotalBargeUnloadVolumeInBatch >>>'
	  END
GO
-- =======================================================================================================================================
-- Author:		Matt Perry	
-- Create date: 10/03/2016
-- Description:	MTV_TotalBargeUnloadVolumeInBatch
-- =======================================================================================================================================

--execute [dbo].[MTV_TotalBargeUnloadVolumeInBatch] @i_PlnndTrnsfrID = null, @i_DlDtlPrvsnID = 39457, @i_XHdrID = 281162 , @b_UseCarrierOnMoveDoc = 1, @b_IncludeSurcharge = 1
ALTER PROCEDURE [dbo].[MTV_TotalBargeUnloadVolumeInBatch]
	(
	@i_DlDtlPrvsnID			Int,
	@i_PlnndTrnsfrID		Int,
	@i_XHdrID				Int
	)

AS

Declare @i_PlnndMvtBtchID Int
Declare @flt_Volume Float

Select	@i_PlnndMvtBtchID = PlannedMovementInPlannedMovementBatch.PlnndMvtBtchID
From	PlannedTransfer
		Inner Join PlannedMovementInPlannedMovementBatch on PlannedMovementInPlannedMovementBatch.PlnndMvtID = PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID
Where	PlannedTransfer.PlnndTrnsfrID = @i_PlnndTrnsfrID

If @i_PlnndMvtBtchID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find an order batch.',61000)
	Select null
	Return
End


Select	@flt_Volume = Sum(Case When PlannedTransfer.[Status] = 'C' Then PlannedTransfer.PlnndTrnsfrActlQty Else PlannedTransfer.PlnndTrnsfrTtlQty End)
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
Where	PlannedMovementInPlannedMovementBatch.PlnndMvtBtchID = @i_PlnndMvtBtchID

If @flt_Volume is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find any barge discharge volume in batch.',61000)
	Select 0.0
	Return
End

Select	@flt_Volume




GO
