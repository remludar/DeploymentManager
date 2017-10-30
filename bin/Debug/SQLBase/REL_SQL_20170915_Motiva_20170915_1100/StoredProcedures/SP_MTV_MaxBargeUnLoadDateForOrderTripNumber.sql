/****** Object:  StoredProcedure [dbo].[MTV_MaxBargeUnLoadDateForOrderTripNumber]    Script Date: 6/17/2016 10:12:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_MaxBargeUnLoadDateForOrderTripNumber]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_MaxBargeUnLoadDateForOrderTripNumber] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_MaxBargeUnLoadDateForOrderTripNumber >>>'
	  END
GO
-- =======================================================================================================================================
-- Author:		Isaac
-- Create date: 11/08/2016
-- Description:	MTV_MaxBargeUnLoadDateForOrderTripNumber

-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  --------------------------------------
--11/08/2016	Isaac			2734	 Rename the SP MTV_MaxBargeUnLoadDateInBatch to MTV_MaxBargeUnLoadDateForOrderTripNumber
--										 Change the logic to use TripNumber instead of Batch Number

-- =======================================================================================================================================


--execute [dbo].[MTV_MaxBargeUnLoadDateForOrderTripNumber] @i_PlnndTrnsfrID = null, @i_DlDtlPrvsnID = 39457, @i_XHdrID = 281162 
Alter PROCEDURE [dbo].[MTV_MaxBargeUnLoadDateForOrderTripNumber]
	(
	@i_DlDtlPrvsnID			Int,
	@i_PlnndTrnsfrID		Int,
	@i_XHdrID				Int
	)

AS

Declare @i_PlnndMvtID Int
Declare @sdt_Date SmallDateTime

Select			@i_PlnndMvtID = PM.PlnndMvtID 
	From		PlannedTransfer Pt
	Inner Join	dbo.PlannedMovement PM (Nolock)
		On		PT.PlnndTrnsfrPlnndStPlnndMvtID = PM.PlnndMvtID 
		AND		PT.PlnndTrnsfrID = @i_PlnndTrnsfrID		
	Inner Join  dbo.GeneralConfiguration TripNumber (nolock)
		On		TripNumber.GnrlCnfgTblNme = 'PlannedMovement' 
		And		TripNumber.GnrlCnfgQlfr = 'TripNumber'
		And		TripNumber.GnrlCnfgHdrID = PM.PlnndMvtID
		And		isNull(TripNumber.GnrlCnfgMulti,'') <> '' 	

If @i_PlnndMvtID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find an order with Trip Number.',61000)
	Select GetDate()
	Return
End


Select	@sdt_Date = Max( Coalesce(	TransactionHeader.MovementDate,
						PlannedTransfer.EstimatedMovementToDate,
						PlannedSet.PlnndStToDte,
						PlannedMovement.PlnndMvtToDte
					)
		)
		From	PlannedMovement	
		Inner Join	PlannedTransfer	
			On		PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID = @i_PlnndMvtID
			And		PlannedTransfer.PTReceiptDelivery = 'R'
			And		Exists(	Select	1
							From	DealHeader
							Where	DealHeader.DlHdrID = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
							And		DealHeader.DlHdrTyp = 56 --Barge Deal
							)
		Left Outer Join PlannedSet	
			On		PlannedSet.PlnndStPlnndMvtID = PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID
			And		PlannedSet.PlnndStSqnceNmbr = PlannedTransfer.PlnndTrnsfrPlnndStSqnceNmbr
		Left Outer Join TransactionHeader
			On		TransactionHeader.XHdrPlnndTrnsfrID = PlannedTransfer.PlnndTrnsfrID
			And		TransactionHeader.XHdrStat = 'C'
			
If @sdt_Date is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find any barge discharge date for the order.',61000)
	Select GetDate()
	Return
End

Select	@sdt_Date




GO

