/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVDataLakeTaxTransaction WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTVDataLakeTaxTransaction]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVDataLakeTaxTransaction.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVDataLakeTaxTransaction]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTVDataLakeTaxTransaction] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTVDataLakeTaxTransaction >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTVDataLakeTaxTransaction]
AS

Select ROW_NUMBER() OVER (ORDER BY CAST(GETDATE() AS TIMESTAMP)) AS ID
	, ROW_NUMBER() OVER (ORDER BY CAST(GETDATE() AS TIMESTAMP)) AS  XHrdID						
	, ROW_NUMBER() OVER (ORDER BY CAST(GETDATE() AS TIMESTAMP)) AS AcctDtlID				
	,'T4' as Source
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

IF  OBJECT_ID(N'[dbo].[v_MTVDataLakeTaxTransaction]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTVDataLakeTaxTransaction.sql'
			PRINT '<<< ALTERED View v_MTVDataLakeTaxTransaction >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTVDataLakeTaxTransaction >>>'
	  END
