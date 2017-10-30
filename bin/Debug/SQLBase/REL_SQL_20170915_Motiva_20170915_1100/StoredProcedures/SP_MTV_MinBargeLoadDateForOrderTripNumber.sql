/****** Object:  StoredProcedure [dbo].[MTV_MinBargeLoadDateForOrderTripNumber]    Script Date: 6/17/2016 10:12:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_MinBargeLoadDateForOrderTripNumber]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_MinBargeLoadDateForOrderTripNumber] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_MinBargeLoadDateForOrderTripNumber >>>'
	  END
GO
-- =======================================================================================================================================
-- Author:		Isaac
-- Create date: 11/08/2016
-- Description:	MTV_MinBargeLoadDateForOrderTripNumber

-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  --------------------------------------
--11/08/2016	Isaac			2734	 Rename the SP MinBargeLoadDateInBatch to MTV_MinBargeLoadDateForOrderTripNumber
--										 Change the logic to use TripNumber instead of Batch Number

-- =======================================================================================================================================

--execute [dbo].[MTV_MinBargeLoadDateForOrderTripNumber] @i_PlnndTrnsfrID = null, @i_DlDtlPrvsnID = 39457, @i_XHdrID = 281162 
ALTER PROCEDURE [dbo].[MTV_MinBargeLoadDateForOrderTripNumber]
	(
	@i_DlDtlPrvsnID			Int,
	@i_PlnndTrnsfrID		Int,
	@i_XHdrID				Int
	)

AS

Declare @i_PlnndMvtID Int
Declare @sdt_Date SmallDateTime

Select	@i_PlnndMvtID = PlnndMvtID
	From			PlannedTransfer PT (Nolock)
	Inner Join		dbo.PlannedMovement PM (Nolock)
		On			PT.PlnndTrnsfrPlnndStPlnndMvtID = PM.PlnndMvtID 
		And			PT.PlnndTrnsfrID = @i_PlnndTrnsfrID		
	Inner Join		dbo.GeneralConfiguration TripNumber (nolock)
		On			TripNumber.GnrlCnfgTblNme = 'PlannedMovement' 
		And			TripNumber.GnrlCnfgQlfr = 'TripNumber'
		And			TripNumber.GnrlCnfgHdrID = PM.PlnndMvtID
		And			isNull(TripNumber.GnrlCnfgMulti,'') <> ''

If @i_PlnndMvtID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find an order  with trip number.',61000)
	Select GetDate()
	Return
End

Select	@sdt_Date = Min( Coalesce(	TransactionHeader.MovementDate,
						PlannedTransfer.EstimatedMovementDate,
						PlannedSet.PlnndStFrmDte,
						PlannedMovement.PlnndMvtFrmDte
					)
		)
		From	PlannedMovement	
		Inner Join PlannedTransfer	
			On	PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID = @i_PlnndMvtID
			And	PlannedTransfer.PTReceiptDelivery = 'D'
			And	Exists
				(
				Select	1
				From	DealHeader
				Where	DealHeader.DlHdrID = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
				And		DealHeader.DlHdrTyp = 56 --Barge Deal
				)
		Left Outer Join PlannedSet	
			On	PlannedSet.PlnndStPlnndMvtID = PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID
			And	PlannedSet.PlnndStSqnceNmbr = PlannedTransfer.PlnndTrnsfrPlnndStSqnceNmbr
		Left Outer Join TransactionHeader
			On	TransactionHeader.XHdrPlnndTrnsfrID = PlannedTransfer.PlnndTrnsfrID
			And	TransactionHeader.XHdrStat = 'C'
			
If @sdt_Date is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find any barge load date for the order .',61000)
	Select GetDate()
	Return
End

Select	@sdt_Date




GO
