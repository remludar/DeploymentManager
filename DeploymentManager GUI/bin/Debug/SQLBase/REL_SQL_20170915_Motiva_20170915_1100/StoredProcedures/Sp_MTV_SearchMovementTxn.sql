/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchMovementTxn WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_SearchMovementTxn]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchMovementTxn.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchMovementTxn]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SearchMovementTxn] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SearchMovementTxn >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SearchMovementTxn]
AS

-- =============================================
-- Author:        Joseph McClean
-- Create date:	  4/20/2016
-- Description:   SHORT DESCRIPTION OF WHAT THIS THINGS DOES\
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

/***********  INSERT YOUR CODE HERE  ***********  */
declare @transactionStatus table
(
Id char(1) not null,
Value varchar(20) not null
)

insert into @transactionStatus values ('C', 'Complete'), ('R', 'Reversed')

Select [TransactionHeader].[XHdrID]										AS 'ID'
	   ,[xtnStatus].[Value]												as 'Status'
       ,[TransactionHeader].[XHdrTyp]									as 'Type'
       ,[DealHeader].[DlHdrIntrnlNbr]									as 'Deal'
       ,[MovementDocumentArchive].[MvtDcmntExtrnlDcmntNbr]				as 'External Document'
	   ,MvtSoldTo.GnrlCnfgMulti											as 'Mvt SoldTo'
	   ,MvtShipTo.GnrlCnfgMulti											as 'Mvt ShipTo'
       --,[MovementDocumentArchive].[MvtDcmntIntrnlDcmntNbr] 
       ,[MovementHeader].[LineNumber]									as 'Line #'
       ,MovementDocBA.BAAbbrvtn											as 'Issued By'
       ,[TransactionHeader].[MovementDate]								as 'Movement Date'
       ,[TransactionHeader].[XHdrQty]									as 'Net Volume'		
       ,case when (TransactionHeader.XHdrTyp = 'D') 
	     then (TransactionHeader.XHdrQty * -1) 
		Else TransactionHeader.XHdrQty
	    End																as 'NetSignedVolume'
	   ,sum(case when [TransactionHeader].[XHdrTyp]='R' then [TransactionHeader].XHdrQty  when [TransactionHeader].[XHdrTyp]='D' then [TransactionHeader].XHdrQty * -1 end) over (partition by [MovementDocumentArchive].MvtDcmntExtrnlDcmntNbr  order by [TransactionHeader].[XHdrID])[Net Cumulative Volume]
       ,[TransactionHeader].[NetWeight]
       ,case when (TransactionHeader.XHdrTyp = 'D') then (TransactionHeader.NetWeight * -1) Else TransactionHeader.NetWeight End [NetSignedWeight]
	   ,sum(case when [TransactionHeader].[XHdrTyp]='R' then [TransactionHeader].NetWeight  when [TransactionHeader].[XHdrTyp]='D' then [TransactionHeader].NetWeight * -1 end) over (partition by [MovementDocumentArchive].MvtDcmntExtrnlDcmntNbr  order by [TransactionHeader].[XHdrID])[Net Cumulative Weight]
       ,[TransactionHeader].[XHdrGrssQty]
       ,case when (TransactionHeader.XHdrTyp = 'D') then (TransactionHeader.XHdrGrssQty * -1) Else TransactionHeader.XHdrGrssQty End [GrossSignedVolume]
	   ,sum(case when [TransactionHeader].[XHdrTyp]='R' then [TransactionHeader].XHdrGrssQty  when [TransactionHeader].[XHdrTyp]='D' then [TransactionHeader].XHdrGrssQty * -1 end) over (partition by [MovementDocumentArchive].MvtDcmntExtrnlDcmntNbr  order by [TransactionHeader].[XHdrID])[Gross Cumlative Volume]
       ,[TransactionHeader].[XHdrSpcfcGrvty]							as 'Specific Gravity'
	   ,(141.5 / [TransactionHeader].[XHdrSpcfcGrvty]) - 131.5			as 'API Gravity'
       ,[TransactionHeader].[Energy]									as 'Energy'
       ,[TransactionHeader].[NetOutStatus]								as 'Net Out Status'
	   ,ParentProduct.PrdctNme											as 'Product Name'
	   ,ParentProduct.PrdctAbbv											as 'Product Abbvn'
       ,ChildProduct.PrdctNme											as 'Chemical'
	   ,MovementLocation.LcleAbbrvtn									as 'Movement Location'
       ,DestinationLocation.LcleAbbrvtn									as 'Destination Location'
       ,[TransactionHeader].[XHdrDte]									as 'Date'
       ,[TransactionHeader].[xhdrchldxhdrid]							as 'Child Id'
       ,[LeaseDealHeader].[LeaseName]									as 'Lease Name'
       ,LocationTTP.LcleAbbrvtn											as 'Location TTP'
	   ,SAPPlantCode.GnrlCnfgMulti										as 'Location TTP PlantCode'
       ,TaxDestination.LcleAbbrvtn										as 'Tax Destination'
       ,TaxOrigin.LcleAbbrvtn											as 'Tax Origin'
       ,[PROD7_Dyn].[TaxCmmdtySbGrpID]									as 'Tax Commodity Sub-Group'
       ,MovementHeaderType.Name 										as 'Type'	
       --,[DealHeader].[DlHdrTyp] 										as 'Deal Type'
	   ,DealType.[Description]											as 'Deal Type'
From   [TransactionHeader] (NoLock)
       Join [MovementDocumentArchive] (NoLock) On
              [TransactionHeader].MvtDcmntArchveID = [MovementDocumentArchive].MvtDcmntArchveID
       Join [PlannedTransfer] (NoLock) On
                     [TransactionHeader].[XHdrPlnndTrnsfrID] = [PlannedTransfer].[PlnndTrnsfrID]
       Join [DealHeader] (NoLock) On
                     [PlannedTransfer].[PlnndTrnsfrObDlDtlDlHdrID] = [DealHeader].[DlHdrID]
       Join [MovementHeader] (NoLock) On
                     [TransactionHeader].[XHdrMvtDtlMvtHdrID] = [MovementHeader].[MvtHdrID]
	   --Added by MattV for SoldTo/ShipTo attributes
	   LEFT JOIN GeneralConfiguration MvtSoldTo (NOLOCK)
			on MvtSoldTo.GnrlCnfgHdrID = [MovementHeader].MvtHdrID and MvtSoldTo.GnrlCnfgQlfr = 'SAPMvtSoldToNumber' and MvtSoldTo.GnrlCnfgTblNme = 'MovementHeader' and MvtSoldTo.GnrlCnfgHdrID <> 0
	   LEFT JOIN GeneralConfiguration MvtShipTo (NOLOCK)
			on MvtShipTo.GnrlCnfgHdrID = [MovementHeader].MvtHdrID and MvtShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo' and MvtShipTo.GnrlCnfgTblNme = 'MovementHeader' and MvtShipTo.GnrlCnfgHdrID <> 0

       Left Join [LeaseDealHeader] (NoLock) On
                     [TransactionHeader].[LeaseDlHdrID] = [LeaseDealHeader].[DlHdrID]
       Left Join [Product] [PROD7_Dyn] (NoLock) On
              [MovementHeader].MvtHdrPrdctID = [PROD7_Dyn].PrdctID

	  -- Formatting

	  -- MVt Doc BAID
	  Left Join BusinessAssociate MovementDocBA (NOLOCK) On 
				MovementDocumentArchive.MvtDcmntBAID = MovementDocBA.BAID
	   
	   -- Transaction Status
	   Left Join @transactionStatus xtnStatus On 
				[TransactionHeader].[XHdrStat] = xtnStatus.Id 

	  -- Chemical  
	  Left Join Chemical Chemical (NOLOCK) On 
			[TransactionHeader].XHdrMvtDtlChmclParPrdctID = Chemical.ChmclParPrdctID 
	   AND	[TransactionHeader].XHdrMvtDtlChmclChdPrdctID = Chemical.ChmclChdPrdctID

	   -- Parent Product  
	   Left Join Product ParentProduct (NOLOCK) On 
			Chemical.ChmclParPrdctID = ParentProduct.PrdctID

	   --- Child Product 
	   Left Join Product ChildProduct (NOLOCK) On
			Chemical.ChmclChdPrdctID = ChildProduct.PrdctID

	  -- Location Location
	  Left Join Locale MovementLocation (NOLOCK) On 
			TransactionHeader.MovementLcleID = MovementLocation.LcleID

	-- Tax Origin
	  Left Join Locale TaxOrigin (NOLOCK) On 
			MovementHeader.MvtHdrOrgnLcleID = TaxOrigin.LcleID
	
	-- Destination Location 
	 Left Join Locale DestinationLocation (NOLOCK) On 
		[TransactionHeader].[DestinationLcleID]	= DestinationLocation.LcleID

	-- -- Location TTP 
	Left Join Locale LocationTTP (NOLOCK) On 
		MovementHeader.[MvtHdrLcleID] = LocationTTP.LcleID

	--Added by MattV for SAPPlantCode
	LEFT JOIN GeneralConfiguration SAPPlantCode (NOLOCK)
		on SAPPlantCode.GnrlCnfgHdrID = LocationTTP.LcleID and SAPPlantCode.GnrlCnfgQlfr = 'SAPPlantCode' and SAPPlantCode.GnrlCnfgTblNme = 'Locale' and SAPPlantCode.GnrlCnfgHdrID <> 0

	--- Tax Destination 
	Left Join Locale TaxDestination (NOLOCK) On 
		MovementHeader.[MvtHdrDstntnLcleID] = TaxDestination.LcleID

	---- Tax Origin
	--Left Join Locale TaxOrigin On
	-- [MovementHeader].[MvtHdrOrgnLcleID] = TaxDestination.LcleID

	-- Movement Header Type 
	 Left Join MovementHeaderType (NOLOCK) On 
		MovementHeaderType.MvtHdrTyp = [MovementHeader].[MvtHdrTyp]
		
	Left Join [DealType] DealType (NOLOCK) ON
			DealType.DlTypID = DealHeader.DlHdrTyp

	Left Join CommoditySubGroup (NOLOCK) On 
				CommoditySubGroup.CmmdtySbGrpID = [PROD7_Dyn].TaxCmmdtySbGrpID

where 
(
  [TransactionHeader].[XHdrStat] = 'C'
)
order by ID


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchMovementTxn]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SearchMovementTxn.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SearchMovementTxn >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SearchMovementTxn >>>'
	  END