/****** Object:  StoredProcedure [dbo].[MTV_TotalBargeUnloadVolumeWithOrderTripNumber]    Script Date: 6/17/2016 10:12:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_TotalBargeUnloadVolumeWithOrderTripNumber]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_TotalBargeUnloadVolumeWithOrderTripNumber] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_TotalBargeUnloadVolumeWithOrderTripNumber >>>'
	  END
GO
-- =======================================================================================================================================
-- Author:		Isaac
-- Create date: 11/08/2016
-- Description:	MTV_TotalBargeUnloadVolumeWithOrderTripNumber


-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  --------------------------------------
--11/08/2016	Isaac			2734	 Rename the SP MTV_TotalBargeUnloadVolumeInBatch to MTV_TotalBargeUnloadVolumeWithOrderTripNumber
--										 Change the logic to use TripNumber instead of Batch Number

-- =======================================================================================================================================

--execute [dbo].[MTV_TotalBargeUnloadVolumeWithOrderTripNumber] @i_PlnndTrnsfrID = null, @i_DlDtlPrvsnID = 39457, @i_XHdrID = 281162 
ALTER PROCEDURE [dbo].[MTV_TotalBargeUnloadVolumeWithOrderTripNumber]
	(
	@i_DlDtlPrvsnID			Int,
	@i_PlnndTrnsfrID		Int,
	@i_XHdrID				Int
	)

AS

Declare @i_PlnndMvtID Int
Declare @flt_Volume Float

Select			@i_PlnndMvtID = PM.PlnndMvtID
	From		PlannedTransfer PT (Nolock)
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
	RAISERROR (N'%s %d',11,1,N'Unable to find an order with trip number .',61000)
	Select null
	Return
End


Select	@flt_Volume = Sum(Case When PlannedTransfer.[Status] = 'C' Then PlannedTransfer.PlnndTrnsfrActlQty Else PlannedTransfer.PlnndTrnsfrTtlQty End)
	From	PlannedMovement	PM
	Inner Join PlannedTransfer	
		On	PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID = @i_PlnndMvtID
		And	PlannedTransfer.PTReceiptDelivery = 'R'
		And	Exists
			(
			Select	1
			From	DealHeader
			Where	DealHeader.DlHdrID = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
			And		DealHeader.DlHdrTyp = 56 --Barge Deal
			)

If @flt_Volume is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find any barge discharge volume for the order .',61000)
	Select 0.0
	Return
End

Select	@flt_Volume



GO
