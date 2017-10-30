/****** Object:  StoredProcedure [dbo].[MTV_AllOrdersWithTripNumberComplete]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_AllOrdersWithTripNumberComplete]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_AllOrdersWithTripNumberComplete] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_AllOrdersWithTripNumberComplete >>>'
	  END
GO
-- =======================================================================================================================================
-- Author:		Isaac
-- Create date: 11/08/2016
-- Description:	MTV_AllOrdersWithTripNumberComplete
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  --------------------------------------
--11/08/2016	Isaac			2734	 Rename the SP MTV_AllOrdersInBatchComplete to MTV_AllOrdersWithTripNumberComplete 
--										 Change the logic to use TripNumber instead of Batch Number	
-----------------------------------------------------------------------------

--execute [dbo].[MTV_AllOrdersWithTripNumberComplete] @i_PlnndTrnsfrID = null, @i_DlDtlPrvsnID = 39457, @i_XHdrID = 281162 
Alter PROCEDURE [dbo].[MTV_AllOrdersWithTripNumberComplete]
	(
	@i_DlDtlPrvsnID			Int,
	@i_PlnndTrnsfrID		Int,
	@i_XHdrID				Int
	)

AS


If Exists
	( Select	PM.PlnndMvtID
	From		PlannedTransfer PT	 (Nolock)	 		
	Inner Join	dbo.PlannedMovement PM (Nolock)
		On		PT.PlnndTrnsfrPlnndStPlnndMvtID = PM.PlnndMvtID 
		And		PT.PlnndTrnsfrID = @i_PlnndTrnsfrID
		And		PM.PlnndMvtStts <> 'C'
	Inner Join  dbo.GeneralConfiguration TripNumber (nolock)
		On		TripNumber.GnrlCnfgTblNme = 'PlannedMovement' 
		And		TripNumber.GnrlCnfgQlfr = 'TripNumber'
		And		TripNumber.GnrlCnfgHdrID = PM.PlnndMvtID
		And		isNull(TripNumber.GnrlCnfgMulti,'') <> '' 	
		)
Begin
	Select 'N'
	Return
End

Select	'Y'

GO

