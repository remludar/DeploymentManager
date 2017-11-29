/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVT4Nominations WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTVT4Nominations]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVT4Nominations.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVT4Nominations]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTVT4Nominations] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTVT4Nominations >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTVT4Nominations]
AS

Select  'T4' as Source
	,	MTVT4NominationHeaderStaging.CarrierReferenceBatchID + '-' + cast(MTVT4LineItemsStaging.LineItemNumber as varchar(3)) T4BatchId
	,	PlannedTransfer.PlnndTrnsfrID
	,	PlannedTransfer.Status
	,	MTVT4LineItemsStaging.Quantity
	,	MTVT4LineItemsStaging.QuantityScheduled
	,	MTVT4LineItemsStaging.Quantity - MTVT4LineItemsStaging.QuantityScheduled RemainingToSchedule
From MTVT4StagingRAWorkBench SWB
           Inner Join	MTVT4LineItemsStaging 
				ON		MTVT4LineItemsStaging.LineItemNumber = SWB.LineItemNumber
           Inner Join	MTVT4NominationHeaderStaging 
				ON		MTVT4NominationHeaderStaging.CarrierReferenceBatchID = SWB.CarrierReferenceBatchID 
				And		MTVT4LineItemsStaging.T4HdrID = MTVT4NominationHeaderStaging.T4HdrID 
           Inner Join	PlannedTransfer 
				ON		PlannedTransfer.PlnndTrnsfrID = SWB. PlnndTrnsfrID
    --       Inner Join	PlannedMovement 
				--ON		PlannedMovement.PlnndMvtID =SWB.PlnndMvtID

  

GO




SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTVT4Nominations]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTVT4Nominations.sql'
			PRINT '<<< ALTERED View v_MTVT4Nominations >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTVT4Nominations >>>'
	  END
