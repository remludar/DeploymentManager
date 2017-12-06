/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_GetFPSFuelSalesVol WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_GetFPSFuelSalesVol]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_GetFPSFuelSalesVol.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetFPSFuelSalesVol]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_GetFPSFuelSalesVol] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_GetFPSFuelSalesVol >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_GetFPSFuelSalesVol] 
--@RowId INT = NULL, @BOL VARCHAR(9)
AS

-- =============================================
-- Author:        Isaac Jacob
-- Create date:	  11/06/2015
-- Description:   To get the FPS FuelSales Volume information from CustomInvoiceInterface
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  --------------------------------------
--10/31/2016	Isaac			3773	Change Join on TransactionDetailLog with AcctDtlID
--7/17/2017		MV				7892	Improved performance
-----------------------------------------------------------------------------
Declare		@vc_Error					varchar(255)

Begin Try

CREATE TABLE #TransactionGroupTypeIDs
(
	XTpeGrpTrnsctnTypID int NOT NULL,
	TrnsctnTypDesc varchar(80) NOT NULL
)

INSERT INTO #TransactionGroupTypeIDs
SELECT	TransactionTypeGroup.XTpeGrpTrnsctnTypID, TransactionType.TrnsctnTypDesc
from	TransactionGroup
INNER JOIN	TransactionTypeGroup (NoLock)
ON	TransactionGroup.XGrpID = TransactionTypeGroup.XTpeGrpXGrpID
INNER JOIN TransactionType 
ON XTpeGrpTrnsctnTypID = TrnsctnTypID
WHERE	TransactionGroup.XGrpName =  dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\transactiongroup')

DECLARE @CreateDate SMALLDATETIME = GETDATE()
DECLARE @Prefix varchar(1000) = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\Prefix')
DECLARE @SeqNum varchar(1000) = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\seqnum')
DECLARE @RecType varchar(1000) = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\rectype')
DECLARE @SavCouCode varchar(1000) = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\SavCouCode')
DECLARE @SitRefFlag varchar(1000) = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\sitrefflag')
DECLARE @ProRefFlag varchar(1000) = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\prorefflag')  
DECLARE @RangeFlag varchar(1000) = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\rangeflag')   
DECLARE @Type varchar(1000) = dbo.GetRegistryValue('Motiva\FPS\OutBound\FuelSales\type') 

INSERT INTO MTVFPSFuelSalesVolStaging
           (CIIMssgQID
           ,Prefix
           ,SequenceNumber
           ,SavRecType
           ,SavCouCode
           ,RABAID           
		   ,SavSoldToCode	 --Attribute  
		   ,RATaxLocaleId
		   ,SavSitCode		--Attribute 
		   ,SavSitRefFlag 		  
		   ,RALocaleId 
		   ,SavPlantCodeID
		   ,SavPlantCode    --Attribute 
		   ,RAProductId 
		   ,SavProCodeId
		   ,SavProCode      --Attribute 
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
		   ,MvtHdrDte
		   ,AcctDtlID
		   ,DlHdrID 
		   ,DtlDlDtlID
		   ,DealDetailID
		   ,MvtHdrID
		    )
	SELECT	CII.MessageQueueID	           
           , @Prefix
           , @SeqNum
           , @RecType
           , @SavCouCode
           , SIH.SlsInvceHdrIntrnlBAID	--RABAID	
		   , SAPSoldTo.GnrlCnfgMulti	--SavSoldToCode
           , MH.MvtHdrDstntnLcleID			   
		   , SAPShipTo.GnrlCnfgMulti	--SavSitCode
           , @SitRefFlag		   
           , MH.MvtHdrLcleID			--Location on Movement Header
		   , MH.MvtHdrLcleID	           
		   , SAPPlantCode.GnrlCnfgMulti	--SAPPlantCode
		   , MH.MvtHdrPrdctID			--product based on Movement Header Product	
		   , MH.MvtHdrPrdctID	
		   , SavProCode.GnrlCnfgMulti	--SavProCode
           , @ProRefFlag         
           , AD.GrossQuantity			--SavVolume
           , AD.NetQuantity 			--SavNetVolume
           , Convert(Varchar(8),MH.MvtHdrDte,112)
           , 0
           , Convert(Varchar(8),MH.MvtHdrDte,112)
           , 235959
           , @RangeFlag
           , @Type
           , CII.InvoiceNumber
           , CII.RunningNumber -1
		   , 'N'
           , @CreateDate
           , null
		   , null
           , null  
           , 'N'
		   , MH.MvtHdrDte
		   , CII.AcctDtlID 
		   , AD.AcctDtlDlDtlDlHdrID 
		   , AD.AcctDtlDlDtlID
		   , DD.DealDetailID 
		   , MH.MvtHdrID 
	FROM		CustomInvoiceInterface  CII	(NOLOCK)
	INNER JOIN	MTVInvoiceInterfaceStatus IIS (NOLOCK)
	ON			CII.MessageQueueID = IIS.CIIMssgQID
	INNER JOIN	SalesInvoiceHeader SIH	(NOLOCK)
	ON			CII.invoiceID = SIH.SlsInvceHdrID
	INNER JOIN	SalesInvoiceDetail SLSID	(NOLOCK)
	ON			SLSID.SlsInvceDtlSlsInvceHdrID  = SIH.SlsInvceHdrID	
	AND			SLSID.SlsInvceDtlAcctDtlID = CII.AcctDtlID 
	INNER JOIN #TransactionGroupTypeIDs
	ON			SLSID.SlsInvceDtlTrnsctnTypID = #TransactionGroupTypeIDs.XTpeGrpTrnsctnTypID
	--Note: This is because we need to exclude some duplicate records in CII whose transaction type is hardcoded to discounts
	AND			CII.TransactionType = #TransactionGroupTypeIDs.TrnsctnTypDesc	
	INNER JOIN	MovementHeader MH (NOLOCK)
	ON			MH.MvtHdrMvtDcmntID = SlsID.SlsInvceDtlMvtDcmntID 	
	AND			MH.MvtHdrPrdctID = SLSID.SlsInvceDtlChldPrdctID
	INNER JOIN	AccountDetail  AD (NOLOCK)
	ON			AD.AcctDtlID  = CII.AcctDtlID 
	INNER JOIN	DealDetail   DD (NOLOCK)
	ON			DD.DlDtlDlHdrID   = AD.AcctDtlDlDtlDlHdrID 
	AND			DD.DlDtlID = AD.AcctDtlDlDtlID 
	INNER JOIN	TransactionDetailLog  TDL (NOLOCK)
	ON			TDL.XDtlLgAcctDtlID   = AD.AcctDtlID
	INNER JOIN	DealDetailProvision  DDP (NOLOCK)
	ON			DDP.DlDtlPrvsnID   = TDL.XDtlLgXDtlDlDtlPrvsnID
	AND			DDP.CostType = 'P'	
	Left Outer Join  Generalconfiguration SAPShipTo (NoLock) 
	ON			SAPShipTo.GnrlCnfgHdrID = MH.MvtHdrID 
    And			SAPShipTo.GnrlCnfgHdrID <> 0  
    And			SAPShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo' 
	Left Outer Join  Generalconfiguration SAPSoldTo (NoLock) 
	ON			SAPSoldTo.GnrlCnfgHdrID = MH.MvtHdrID 
	And			SAPSoldTo.GnrlCnfgHdrID <> 0  
	And			SAPSoldTo.GnrlCnfgQlfr = 'SAPMvtSoldToNumber'
	Left Outer Join  Generalconfiguration SAPPlantCode (NoLock) 
	ON			SAPPlantCode.GnrlCnfgHdrID = MH.MvtHdrLcleID
	And			SAPPlantCode.GnrlCnfgHdrID <> 0  
	And			SAPPlantCode.GnrlCnfgQlfr = 'SAPPlantCode'  
	Left Outer Join  Generalconfiguration SavProCode (NoLock) 
	ON			SavProCode.GnrlCnfgHdrID = MH.MvtHdrPrdctID 
	And			SavProCode.GnrlCnfgHdrID <> 0  
	And			SavProCode.GnrlCnfgQlfr = 'SAPMaterialCode'  
	--This would be an improved version of the NOT EXISTS clause in the WHERE below which is also commented out
	--Left Outer Join	 GeneralConfiguration DiscountGLAccount
	--ON			DiscountGLAccount.GnrlCnfgTblNme = 'BusinessAssociate'
	--And			DiscountGLAccount.GnrlCnfgQlfr = 'DiscountGLAccount'
	--And			DiscountGLAccount.GnrlCnfgHdrID = CII.IntBAID
	--And			DiscountGLAccount.GnrlCnfgMulti = CII.Chart
	WHERE		isnull(IIS.FPSFuelSalesVolStaged,0) <> 1 
	AND			CII.InvoiceLevel = 'D'
	AND			CII.InterfaceStatus = 'A'
	AND			CII.InterfaceSource  = 'SH'
	--AND			DiscountGLAccount.GnrlCnfgHdrID IS NULL		--This would be an improved version of the NOT EXISTS clause in the WHERE below which is also commented out

	--We are not sure why this was added. It doesn't actually exist in any of the databases stored procedures, but it does exist in the code base. 
	--Possibly the SQL deployment failed, so it never actually got out into the databases?
	--They haven't complained that this wasn't deployed and is causing issues or anything, so I will leave this out. 
	--AND			NOT EXISTS		(
	--							Select      1
	--							From  
	--							Where GnrlCnfgTblNme	= 'BusinessAssociate'
	--							and	GnrlCnfgQlfr		= 'DiscountGLAccount'
	--							and	GnrlCnfgHdrID		= CII.IntBAID
	--							AND	CII.Chart			= GeneralConfiguration.GnrlCnfgMulti
	--							)

	UPDATE MTVInvoiceInterfaceStatus SET FPSFuelSalesVolStaged = 1
	FROM MTVFPSFuelSalesVolStaging FSV
	INNER JOIN MTVInvoiceInterfaceStatus IIS
	ON FSV.CIIMssgQID = IIS.CIIMssgQID
	AND FSV.CreatedDate = @CreateDate

	SELECT * FROM MTVFPSFuelSalesVolStaging (NOLOCK)
	WHERE CreatedDate = @CreateDate

----------------------------------------------------------------------------------------------------------------------  
-- Drop the temp table  (not really necessary, system should take care of this)
----------------------------------------------------------------------------------------------------------------------    
--If Object_ID('TempDB..#TransactionGroupTypeIDs') Is Not Null Drop Table #TransactionGroupTypeIDs   

End Try
Begin Catch						
		Select	@vc_Error	=  ERROR_MESSAGE()	
		Raiserror (60010,-1,-1, @vc_Error	)	
End Catch	


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetFPSFuelSalesVol]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_GetFPSFuelSalesVol.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_GetFPSFuelSalesVol >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_GetFPSFuelSalesVol >>>'
	  END



	