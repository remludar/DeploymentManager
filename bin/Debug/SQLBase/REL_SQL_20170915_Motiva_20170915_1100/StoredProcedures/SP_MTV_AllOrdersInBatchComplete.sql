/****** Object:  StoredProcedure [dbo].[MTV_AllOrdersInBatchComplete]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_AllOrdersInBatchComplete]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_AllOrdersInBatchComplete] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_AllOrdersInBatchComplete >>>'
	  END
GO
-- =======================================================================================================================================
-- Author:		Matt Perry
-- Create date: 10/03/2016
-- Description:	MTV_AllOrdersInBatchComplete
-- =======================================================================================================================================


--execute [dbo].[MTV_AllOrdersInBatchComplete] @i_PlnndTrnsfrID = null, @i_DlDtlPrvsnID = 39457, @i_XHdrID = 281162 , @b_UseCarrierOnMoveDoc = 1, @b_IncludeSurcharge = 1
Alter PROCEDURE [dbo].[MTV_AllOrdersInBatchComplete]
	(
	@i_DlDtlPrvsnID			Int,
	@i_PlnndTrnsfrID		Int,
	@i_XHdrID				Int
	)

AS

Declare @i_PlnndMvtBtchID Int

Select	@i_PlnndMvtBtchID = PlannedMovementInPlannedMovementBatch.PlnndMvtBtchID
From	PlannedTransfer
		Inner Join PlannedMovementInPlannedMovementBatch on PlannedMovementInPlannedMovementBatch.PlnndMvtID = PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID
Where	PlannedTransfer.PlnndTrnsfrID = @i_PlnndTrnsfrID

If @i_PlnndMvtBtchID is Null
Begin
	Select 'N'
	Return
End

If Exists
	(
	Select	1
	From	PlannedMovementInPlannedMovementBatch
			Inner Join PlannedMovement	On	PlannedMovement.PlnndMvtID = PlannedMovementInPlannedMovementBatch.PlnndMvtID
										And	PlannedMovement.PlnndMvtStts <> 'C'
	Where	PlannedMovementInPlannedMovementBatch.PlnndMvtBtchID = @i_PlnndMvtBtchID
	)
Begin
	Select 'N'
	Return
End

Select	'Y'

GO

