/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_T4ProcessOrderSaved]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_T4ProcessOrderSaved.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_T4ProcessOrderSaved]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_T4ProcessOrderSaved] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_T4ProcessOrderSaved >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_T4ProcessOrderSaved] 
		@PlnndTrnsfrID int = Null
		,@PlnndMvtId  int = Null
AS
-- =============================================
-- Author:        Isaac Jacob
-- Create date:	  12/21/2015
-- Description:   To update the Planned Movement and Planned Movement Batch ID
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare @LineItemNumber int
Declare @CarrrierReferenceBatchID varchar(50)
Declare @Quantity Float
Declare @QuantityScheduled Float
Declare @T4DHRID int

IF Exists (Select *  from dbo.MTVT4StagingRAWorkBench MSWB (NOLOCK)
					 inner Join dbo.PlannedTransfer PT (NOLOCK) 
						on MSWB.PlnndTrnsfrID = PT.PlnndTrnsfrID 
						where PT.PlnndTrnsfrPlnndStPlnndMvtID = @PlnndMvtId)
BEGIN
		Select	Top 1 @LineItemNumber = LineItemNumber
					, @CarrrierReferenceBatchID = CarrierReferenceBatchID
		From	dbo.MTVT4StagingRAWorkBench (NOLOCK)		
		Where	PlnndTrnsfrID = @PlnndTrnsfrID 

		Select	@T4DHRID = T4HdrID
		From	dbo.MTVT4NominationHeaderStaging (NOLOCK)	
		Where	CarrierReferenceBatchID = @CarrrierReferenceBatchID

		Select	@QuantityScheduled =sum(PlnndTrnsfrTtlQty)	
		From	dbo.PlannedTransfer PT (NOLOCK)
		Where	PT.PlnndTrnsfrPlnndStPlnndMvtID =  @PlnndMvtID
																		
		Select  @Quantity = Quantity					
		From	dbo.MTVT4LineItemsStaging  (NOLOCK)
		Where	T4HdrID = @T4DHRID  
		And		LineItemNumber = @LineItemNumber	
		
		Update	dbo.MTVT4StagingRAWorkBench
		set		PlnndMvtId = @PlnndMvtId
		where  	PlnndTrnsfrID = @PlnndTrnsfrID 
 
	    IF (@Quantity = @QuantityScheduled)
		Begin
			Update	dbo.MTVT4LineItemsStaging 
			set		RecordStatus = 'C'
					,QuantityScheduled = @QuantityScheduled				
			Where	T4HdrID = @T4DHRID  
				And LineItemNumber = @LineItemNumber	

			Update	dbo.MTVT4NominationHeaderStaging
			set		RecordStatus   = 'C'			
			Where	T4HdrID = @T4DHRID  
				
			Delete From  dbo.MTVT4StagingRAWorkBench
			Where	LineItemNumber = @LineItemNumber 
			And CarrierReferenceBatchID = @CarrrierReferenceBatchID
			And PlnndMvtID is null  
		End
		Else
		Begin
			Update	dbo.MTVT4LineItemsStaging
			set		QuantityScheduled  = @QuantityScheduled	
			Where	T4HdrID = @T4DHRID  
			And		LineItemNumber = @LineItemNumber		
		End
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_T4ProcessOrderSaved]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_T4ProcessOrderSaved.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_T4ProcessOrderSaved >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_T4ProcessOrderSaved >>>'
	  END


	 
	 