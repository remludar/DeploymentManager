/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_LoadFPSFuelSalesVolStaging WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_LoadFPSFuelSalesVolStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_LoadFPSFuelSalesVolStaging.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_LoadFPSFuelSalesVolStaging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_LoadFPSFuelSalesVolStaging] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_LoadFPSFuelSalesVolStaging >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_LoadFPSFuelSalesVolStaging] 
--@RowId INT = NULL, @BOL VARCHAR(9)
AS

-- =============================================
-- Author:        Isaac Jacob
-- Create date:	  09/09/2015
-- Description:   To load the staging table MTV_LoadFPSFuelSalesVolStaging from CustomInvoiceInterface
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_LoadFPSFuelSalesVolStaging 18 
--THIS IS DEPRECATED, MOTIVA CODEBASE NO LONGER USES THIS SP
-----------------------------------------------------------------------------
Declare		@vc_Error					varchar(255)

Begin Try

CREATE TABLE #MTVFPSFuelSalesVolStaging
(
	FFSVSID int IDENTITY(1,1) NOT NULL,
	CIIMssgQID int NULL,
	Prefix varchar(80) NULL,
	SequenceNumber int NULL,
	SavRecType varchar(20) NULL,
	SavCouCode varchar(20) NULL,
	RABAID int NULL,
	SavSoldToCode varchar(20) NULL,
	RATaxLocaleId		INT,
	SavSitCode varchar(20) NULL,
	SavSitRefFlag varchar(1) NULL,
	RALocaleId int NULL,
	SavPlantCode varchar(20) NULL,
	RAProductId int NULL,
	SavProCode varchar(20) NULL,
	SavProRefFlag varchar(1) NULL,
	SavVolume float NULL,
	SavNetVolume float NULL,
	SavDateFrom varchar(8) NULL,
	SavTimeFrom varchar(6) NULL,
	SavDateTo varchar(8) NULL,
	SavTimeTo varchar(7) NULL,
	SavRangeFlag varchar(1) NULL,
	SavType varchar(1) NULL,
	SavInvNo varchar(20) NULL,
	SavInvItem varchar(20) NULL,
	FPSStatus varchar(1) NULL,
	CreatedDate smalldatetime NULL,
	UserId int NULL,
	ModifiedDate smalldatetime NULL,
	PublishedDate smalldatetime NULL,
	Status varchar(1) NULL,
	Message varchar(max) NULL
	)

INSERT INTO #MTVFPSFuelSalesVolStaging
           (CIIMssgQID
           ,Prefix
           ,SequenceNumber
           ,SavRecType
           ,SavCouCode
           ,RABAID
           ,SavSoldToCode
		   ,RATaxLocaleId
           ,SavSitCode
           ,SavSitRefFlag
           ,RALocaleId
           ,SavPlantCode
           ,RAProductId
           ,SavProCode
           ,SavProRefFlag
           ,SavVolume
           ,SavNetVolume
           ,SavDateFrom
           ,SavTimeFrom
           ,SavDateTo
           ,SavTimeTo
           ,SavRangeFlag
           ,SavType
           ,SavInvNo
           ,SavInvItem
		   ,FPSStatus
           ,CreatedDate
           ,UserId
		   ,ModifiedDate
           ,PublishedDate
           ,Status
           ,Message)
	SELECT	CII.MessageQueueID	--           
           , dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\Prefix')
           , dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\seqnum')
           , dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\rectype')
           , dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\SavCouCode')
           , SIH.SlsInvceHdrIntrnlBAID	--RABAID
		   , '1' --SAPCustomerNo.GnrlCnfgMulti  --SavSoldToCode  ( for below There will be a Ship To Atrribute on the Location with the Ship To Code
           , MH.MvtHdrDstntnLcleID	
		   , '1'  --SAPShipTo.GnrlCnfgMulti		--i_sav_sit_code (This will be pulled from Movement Header Tax Destination Location. 								      
           , dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\sitrefflag')
           , MH.MvtHdrLcleID		--Attribute on Location based on Movement Header	
           , '1'  --SAPPlantCode.GnrlCnfgMulti	--null i_sav_plant_code  
		   , MH.MvtHdrPrdctID		--Attribute on product based on Movement Header Product		
           , '1'  --SAPMaterialCode.GnrlCnfgMulti		--null i_sav_pro_code
           , dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\prorefflag')           
           , MH.GrossDisplayQuantity    --savVolume
           , MH.DisplayQuantity			--savNetVolume
           , Convert(Varchar(8),MH.MvtHdrDte,112)
           , 0
           , Convert(Varchar(8),MH.MvtHdrDte,112)
           , 235959
           , dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\rangeflag')     
           , dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\type') 
           , CII.InvoiceNumber
           , CII.RunningNumber
		   , 'N'
           , getDate()
           , null
		   , null
           , null -- 
           , 'N'
           , null
	FROM		CustomInvoiceInterface  CII	(NOLOCK)
	INNER JOIN	SalesInvoiceHeader SIH	(NOLOCK)
	ON			CII.invoiceID = SIH.SlsInvceHdrID
	INNER JOIN	SalesInvoiceDetail SLSID	(NOLOCK)
	ON			SLSID.SlsInvceDtlSlsInvceHdrID  = SIH.SlsInvceHdrID
	INNER JOIN	transactiongroup TG (NOLOCK)
	--ON			TG.XGrpName = 'Sales'
	ON			TG.XGrpName = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\transactiongroup')     
	INNER JOIN	TransactionTypeGroup TTG (NOLOCK)
	ON			TG.XGrpID = TTG.XTpeGrpXGrpID
	INNER JOIN	TransactionType TT (NOLOCK)
	ON			TT.TrnsctnTypID = TTG.XTpeGrpTrnsctnTypID
	AND			SlsID.SlsInvceDtlTrnsctnTypID = TT.TrnsctnTypID
	INNER JOIN	MovementHeader MH (NOLOCK)
	ON			MH.MvtHdrMvtDcmntID = SlsID.SlsInvceDtlMvtDcmntID 
	LEFT JOIN	GeneralConfiguration SAPCustomerNo	(NOLOCK)
	ON			SAPCustomerNo.GnrlCnfgHdrID = SIH.SlsInvceHdrIntrnlBAID 
	AND			SAPCustomerNo.GnrlCnfgQlfr = 'BusinessAssociate'
	AND			SAPCustomerNo.GnrlCnfgTblNme = 'SAPCustomerNo'
	LEFT JOIN	GeneralConfiguration SAPShipTo	(NOLOCK)
	ON			SAPShipTo.GnrlCnfgHdrID = MH.MvtHdrDstntnLcleID
	AND			SAPShipTo.GnrlCnfgQlfr = 'SAPShipTo'
	AND			SAPShipTo.GnrlCnfgTblNme = 'Locale'
	LEFT JOIN	GeneralConfiguration SAPPlantCode	(NOLOCK)
	ON			SAPPlantCode.GnrlCnfgHdrID =MH.MvtHdrLcleID
	AND			SAPPlantCode.GnrlCnfgQlfr = 'SAPPlantCode'
	AND			SAPPlantCode.GnrlCnfgTblNme = 'Locale'
	LEFT JOIN	GeneralConfiguration SAPMaterialCode	(NOLOCK)
	ON			SAPMaterialCode.GnrlCnfgHdrID =MH.MvtHdrPrdctID
	AND			SAPMaterialCode.GnrlCnfgQlfr = 'SAPMaterialCode'
	AND			SAPMaterialCode.GnrlCnfgTblNme = 'Product'
	WHERE 1= 1
		AND isnull(CII.FPSProcessedStatus,'N') <> 'Y'
	--AND CII.InvoiceLevel = 'D'
	--AND CII.InterfaceStatus = 'A'

	-- For Validation	
	--NULL Prefix
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status		= 'E'
			,Message	= 'Can not find Prefix|| '
	WHERE	Prefix is null 

	--NULL SequenceNumber
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SequenceNumber|| '
	WHERE	SequenceNumber is null 
	
	--NULL SavRecType
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavRecType|| '
	WHERE	SavRecType is null 

	--NULL SavCouCode
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavCouCode|| '
	WHERE	SavCouCode is null 

	--NULL SavSitCode
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavSitCode|| '
	WHERE	SavSitCode is null 

	--NULL SavPlantCode
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavPlantCode|| '
	WHERE	SavPlantCode is null 

	--NULL SavProCode
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavProCode|| '
	WHERE	SavProCode is null 
	
	--NULL SavProRefFlag
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavProRefFlag|| '
	WHERE	SavProRefFlag is null 

	--NULL SavRecType
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavRecType|| '
	WHERE	SavRecType is null 

	--NULL SavVolume  -- For testing
	--UPDATE	#MTVFPSFuelSalesVolStaging
	--SET		Status	= 'E'
	--		,Message	= ISNULL(Message,'') + 'Can not find SavVolume|| '
	--WHERE	SavVolume is null 


	--UPDATE	#MTVFPSFuelSalesVolStaging 
	--SET		Status = 'E'
	--WHERE	Prefix is null 
	--	or	SequenceNumber is null
	--	or	SavRecType is null
	--	or	SavCouCode is null
	--	or	SavSitCode is null
	--	or	SavPlantCode is null
	--	or	SavProCode is null
	--	or	SavProRefFlag is null
	--	or	SavRecType is null
	--	--or	SavVolume is null
	--	or	SavDateFrom is null
	--	or	SavTimeFrom is null
	--	or	SavDateTo is null
	--	or	SavRangeFlag is null
	--	or	SavType is null

	--NULL SavDateFrom
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavDateFrom|| '
	WHERE	SavDateFrom is null 

	--NULL SavTimeFrom
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavTimeFrom|| '
	WHERE	SavTimeFrom is null 
	
	--NULL SavDateTo
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavDateTo|| '
	WHERE	SavDateTo is null 

	--NULL SavRangeFlag
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavRangeFlag|| '
	WHERE	SavRangeFlag is null 

	--NULL SavType
	UPDATE	#MTVFPSFuelSalesVolStaging
	SET		Status	= 'E'
			,Message	= ISNULL(Message,'') + 'Can not find SavType|| '
	WHERE	SavType is null 


	INSERT INTO MTVFPSFuelSalesVolStaging
	SELECT CIIMssgQID
			,Prefix
			,SequenceNumber
			,SavRecType
			,SavCouCode
			,RABAID
			,SavSoldToCode
			,RATaxLocaleId
			,SavSitCode
			,SavSitRefFlag
			,RALocaleId
			,SavPlantCode
			,RAProductId
			,SavProCode
			,SavProRefFlag
			,SavVolume
			,SavNetVolume
			,SavDateFrom
			,SavTimeFrom
			,SavDateTo
			,SavTimeTo
			,SavRangeFlag
			,SavType
			,SavInvNo
			,SavInvItem
			,FPSStatus
			,CreatedDate
			,UserId
			,ModifiedDate
			,PublishedDate
			,Status
			,Message
	FROM	#MTVFPSFuelSalesVolStaging 

	UPDATE	CII
			SET CII.FPSProcessedStatus = 'Y'
	FROM	CustomInvoiceInterface CII
	INNER JOIN #MTVFPSFuelSalesVolStaging 
		ON #MTVFPSFuelSalesVolStaging.CIIMssgQID = CII.MessageQueueID
		
----------------------------------------------------------------------------------------------------------------------  
-- Drop the temp table  
----------------------------------------------------------------------------------------------------------------------   
If Object_ID('TempDB..#MTVFPSFuelSalesVolStaging') Is Not Null  
 Drop Table #MTVFPSFuelSalesVolStaging   
  
End Try
Begin Catch						
		Select	@vc_Error	=  ERROR_MESSAGE()	
		GoTo	Error	
End Catch	

----------------------------------------------------------------------------------------------------------------------
-- Return out
----------------------------------------------------------------------------------------------------------------------
NoError:
	Return	
		
----------------------------------------------------------------------------------------------------------------------
-- Error Handler:
----------------------------------------------------------------------------------------------------------------------
Error:  
Raiserror (60010,-1,-1, @vc_Error	)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_LoadFPSFuelSalesVolStaging]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_LoadFPSFuelSalesVolStaging.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_LoadFPSFuelSalesVolStaging >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_LoadFPSFuelSalesVolStaging >>>'
	  END