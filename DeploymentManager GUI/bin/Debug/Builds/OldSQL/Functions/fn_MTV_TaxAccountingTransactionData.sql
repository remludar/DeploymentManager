/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxAccountingTransactionData WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[MTV_TaxAccountingTransactionData]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_TaxAccountingTransactionData.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TaxAccountingTransactionData]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[MTV_TaxAccountingTransactionData](@In VARCHAR(1)) RETURNS @TEST TABLE (TEST VARCHAR(1)) AS BEGIN INSERT @TEST SELECT 1 RETURN END'
			PRINT '<<< CREATED Function MTV_TaxAccountingTransactionData >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER Function dbo.MTV_TaxAccountingTransactionData ( @TransactionFromDate smalldatetime )
RETURNS @taxMovementTransactionData TABLE
(	MVT_TitleTransfer varchar(50),
	MVT_BilledUnits decimal(15,2),
	MVT_BillOfLading varchar(80),
	MVT_BillOfLadingDate smalldatetime,
	MVT_GrossUnits float,
	MVT_InvoiceDate smalldatetime,
	MVT_PurchaseInvoiceNumber varchar(20),
	MVT_NetUnits float,
	MVT_ProductCode varchar(255),
	MVT_UnitPrice decimal(15,6),

	MVT_BuyerIdType varchar(10),
	MVT_BuyerIdCode varchar(255),
	MVT_BuyerCustomId int,
	MVT_BuyerTradeName varchar(45),
	MVT_BuyerLegalName varchar(100),
	MVT_BuyerNameControl varchar(255),

	MVT_CarrierIdType varchar(10),
	MVT_CarrierIdCode varchar(255),
	MVT_CarrierCustomId int,
	MVT_CarrierTradeName varchar(45),
	MVT_CarrierLegalName varchar(100),
	MVT_CarrierNameControl varchar(255),

	MVT_ConsignorIdType varchar(10),
	MVT_ConsignorIdCode varchar(255),
	MVT_ConsignorCustomId int,
	MVT_ConsignorTradeName varchar(45),
	MVT_ConsignorLegalName varchar(100),
	MVT_ConsignorNameControl varchar(255),
	
	MVT_PositionHolderIdType varchar(10),
	MVT_PositionHolderIdCode varchar(255),
	MVT_PositionHolderCustomId int,
	MVT_PositionHolderTradeName varchar(45),
	MVT_PositionHolderLegalName varchar(100),
	MVT_PositionHolderNameControl varchar(255),

	MVT_Exch_PositionHolderIdType varchar(10),
	MVT_Exch_PositionHolderIdCode varchar(255),
	MVT_Exch_PositionHolderCustomId int,
	MVT_Exch_PositionHolderTradeName varchar(45),
	MVT_Exch_PositionHolderLegalName varchar(100),
	MVT_Exch_PositionHolderNameControl varchar(255),
	
	MVT_SellerIdType varchar(10),
	MVT_SellerIdCode varchar(255),
	MVT_SellerCustomId int,
	MVT_SellerTradeName varchar(45),
	MVT_SellerLegalName varchar(100),
	MVT_SellerNameControl varchar(255),

	MVT_OriginTerminalCode varchar(255),
	MVT_OriginCustomId int,
	MVT_OriginDescription varchar(100),
	MVT_OriginCity varchar(50),
	MVT_OriginJurisdiction varchar(50),
	MVT_OriginPostalCode varchar(20),
	MVT_OriginCountryCode varchar(50),
	MVT_OriginCounty varchar(120),
	MVT_OriginCountyCode varchar(120),
	MVT_OriginLocationType varchar(80),

	MVT_DestinationTerminalCode varchar(255),
	MVT_DestinationCustomId int,
	MVT_DestinationDescription varchar(100),
	MVT_DestinationAddress1 varchar(50),
	MVT_DestinationAddress2 varchar(50),
	MVT_DestinationCity varchar(50),
	MVT_DestinationJurisdiction varchar(50),
	MVT_DestinationPostalCode varchar(20),
	MVT_DestinationCountryCode varchar(50),
	MVT_DestinationCounty varchar(120),
	MVT_DestinationCountyCode varchar(120),
	MVT_DestinationLocationType varchar(80),
	
	MVT_DivTerminalCode varchar(100),
	MVT_DivDestination varchar(100),
	MVT_DivJurisdiction varchar(100),

	MVT_Alt_Document_Number varchar(30),
	MVT_exchange_ind char(1),
	MVT_Pipeline_Batch_Number varchar(30),
	MVT_Vessel_Name varchar(50),
	MVT_Vessel_Number varchar(10),
	MVT_Movement_Posted_Date date,

	MVT_Transaction_Year float,
	MVT_Transaction_Month float,
	MVT_Transaction_ID float,
	MVT_Transaction_Child_Id int,

	MVT_Accounting_Year float,
	MVT_Accounting_Month float,
	MVT_BOL_Item_Number float,
	MVT_RD_Type char(1),

	MVT_Deal_Type varchar(128),
	MVT_Tax_Commodity_Code varchar(128),
	MVT_Movement_Type varchar(128),
	MVT_Deal varchar(128),
	MVT_Equity_Terminal char(5),
	MVT_Is_Third_Party char(5),
	
	MVT_Purchase_Order_Number varchar(128),
	MVT_Account_DetailID varchar(128),
	MVT_ExternalBA varchar(128),
	MVT_GSAP_CustomerNumber varchar(128),
	MVT_GSAP_VendorNumber varchar(128),
	MVT_SCAC varchar(128),
	MVT_SAP_Material_Code varchar(128),
	MVT_Foreign_Vessel_Identifier char(5),
	MVT_Transaction_Status char(20),
	MVT_Product_Grade varchar(20),
	MVT_Location_ID int,
	
	MVT_Product_Name varchar(128),
	MVT_Transaction_Type varchar(128),
	
	Acct_MVT_Transaction_Unique_Identifier int,
	Acct_MVT_Transaction_Child_Id int,

	Acct_DtlID int,
	Acct_ExtBA varchar(50),
	Acct_Deal varchar(20),
	Acct_TktDate smalldatetime,
	Acct_BOL varchar(80),
	Acct_BOL_Date smalldatetime,
	Acct_AcctDtlLoc varchar(50),
	Acct_Product varchar(50),
	Acct_ProductCode varchar(255),
	Acct_Tax_Commodity varchar(128),
	Acct_TransactionType varchar(128),
	Acct_NG char(1),
	Acct_Rate decimal(20,10),
	Acct_Tran_Amt decimal(15,3),
	Acct_Origin varchar(50),
	Acct_Destination varchar(50),
	Acct_SlsInv varchar(20),
	Acct_Net float,
	Acct_Gross float,
	Acct_AcctPeriod varchar(128),
	Acct_Curr varchar(50),
	Acct_Rev char(1),
	Acct_Taxed char(50),
	Acct_Source char(2),
	Acct_IntBA varchar(50),
	Acct_Invoice_Description varchar(80),
	Acct_Billing_Term varchar(255),
	Acct_SalesInvoiceNumber varchar(20),
	Acct_PurchaseInvoiceNumber varchar(20),
	Acct_InvoiceDate date,
	Acct_Payable_Matching_Status char(1),
	Acct_MovementType varchar(128),
	Acct_DealType varchar(128),

	Acct_OriginState varchar(50),
	Acct_DestinationState varchar(50),
	Acct_AcctCodeStatus varchar(1),
	Acct_OriginCity varchar(50),
	Acct_OriginCounty varchar(50),
	Acct_DestinationCity varchar(50),
	Acct_DestinationCounty varchar(50),
	Acct_Title_Transfer varchar(50),
	
	Acct_BilledGallons float,
	Acct_R_D varchar(128),
	Acct_Reversed char(1),
	Acct_Movement_Year_Month varchar(128),
	Acct_Movement_Posting_Date smalldatetime,
	Acct_GL_Posting_Date smalldatetime,
	Acct_Buyer_CustomID int,
	Acct_Seller_CustomID int,
	Acct_External_BA varchar(128),
	Acct_External_BAID int,
	Acct_Buyer_LegalName varchar(128),
	Acct_Buyer_ID varchar(255),
	Acct_Seller_LegalName varchar(128),
	Acct_Seller_ID varchar(255),
	MVT_Last_In_Chain char(1),
	Acct_Detail_Status char(1),
	Account_Detail_ParentID int,
	MVT_Changed_By varchar(80)
)
AS 

-- =================================================
-- Author:        Sanjay Kumar
-- Create date:	  4/26/2016
-- Description:   function to extract all Tax Accounting Transactions
-- =================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------

BEGIN

INSERT @taxMovementTransactionData
Select	TaxLocale.LocaleState
		,cast(AccountDetail.Volume as decimal(15,2)) As DLBilledUnits
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As DLBillOfLadding
		,MovementDocument.MvtDcmntDte As DLBillOfLadingDate
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrGrssQty else TaxTransactionHeader.XHdrGrssQty end
		,case when (PayableHeader.CreatedDate is not null) then PayableHeader.CreatedDate else SalesInvoiceHeader.SlsInvceHdrCrtnDte end 
		,case when (PayableHeader.InvoiceNumber is not null) then PayableHeader.InvoiceNumber else SalesInvoiceHeader.SlsInvceHdrNmbr end
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrQty else TaxTransactionHeader.XHdrQty end
		,ProductCode.GnrlCnfgMulti As DLFTAProductCode
		,case when (AccountDetail.Volume != 0) then ABS(convert(DECIMAL(15,6), AccountDetail.Value/AccountDetail.Volume)) else 0 end as MVT_UnitPrice
				
		,'FEIN'
		,BuyerFEIN.GnrlCnfgMulti As DLBuyerIdCode
		,Buyer.BAID as DLBuyerCustomId
		,Buyer.Abbreviation As DLBuyerTradeName
		,Buyer.Name As DLBuyerLegalName
		,BuyerControlName.GnrlCnfgMulti As DLBuyerNameControl
		
		,'FEIN'
		,CarrierFEIN.GnrlCnfgMulti As DLCarrierIdCode
		,Carrier.BAID As DLCarrierCustomId
		,Carrier.Abbreviation As DLCarrierTradeName
		,Carrier.Name As DLCarrierLegalName
		,CarrierControlName.GnrlCnfgMulti As CarrierNameControl

		,'FEIN'
		,ConsignorFEIN.GnrlCnfgMulti As DLConsignorIdCode
		,Consignor.BAID As DLConsignorCustomId
		,Consignor.Abbreviation As DLConsignorTradeName
		,Consignor.Name As DLConsignorLegalName
		,ConsignorControlName.GnrlCnfgMulti As DLConsignorNameControl

		,'FEIN'
		,PositionHolderFEIN.GnrlCnfgMulti As DLPositionHolderIdCode
		,PositionHolder.BAID As DLPositionHolderCustomId
		,PositionHolder.Abbreviation As DLPositionHolderTradeName
		,PositionHolder.Name As DLPositionHolderLegalName
		,PositionHolderControlName.GnrlCnfgMulti As DLPositionHolderNameControl

		,'FEIN'
		,ExchPositionHolderFEIN.GnrlCnfgMulti As DLExchPositionHolderIdCode
		,ExchPositionHolder.BAID As DLExchPositionHolderCustomId
		,ExchPositionHolder.Abbreviation As DLExchPositionHolderTradeName
		,ExchPositionHolder.Name As DLExchPositionHolderLegalName
		,ExchPositionHolderControlName.GnrlCnfgMulti As DLExchPositionHolderNameControl

		,'FEIN'
		,SellerFEIN.GnrlCnfgMulti As DLSellerIdCode
		,Seller.BAID As DLSellerCustomId
		,Seller.Abbreviation As DLSellerTradeName
		,Seller.Name As DLSellerLegalName
		,SellerControlName.GnrlCnfgMulti As DLSellerNameControl
		
		,OriginTerminalCode.GnrlCnfgMulti As DLOriginTerminalCode
		,OriginLocale.LcleID
		,OriginLocale.LcleAbbrvtn As DLOriginDescription
		,OriginTaxLocale.LocaleCity As DLOriginCity
		,OriginTaxLocale.LocaleState As DLOriginJurisdiction
		,OriginZipCode.GnrlCnfgMulti As DLOriginPostalCode
		,OriginCountryCode.GnrlCnfgMulti As DLOriginCountryCode
		,OriginTaxLocale.LocaleCounty As DLOriginCounty
		,OriginCountyCode.GnrlCnfgMulti As DLOriginCountyCode
		,OriginLocaleType.LcleTpeDscrptn As DLOriginLocationType

		,DestinationTerminalCode.GnrlCnfgMulti As DLDestinationTerminalCode
		,DestinationLocale.LcleID
		,DestinationLocale.LcleAbbrvtn As DLDestinationLegalName
		,DestinationAddress1.GnrlCnfgMulti As DLDestinationAddress1
		,DestinationAddress2.GnrlCnfgMulti As DLDestinationAddress2
		,DestinationTaxLocale.LocaleCity As DLDestinationCity
		,DestinationTaxLocale.LocaleState As DLDestinationJurisdiction
		,DestinationZipCode.GnrlCnfgMulti As DLDestinationPostalCode
		,DestinationCountryCode.GnrlCnfgMulti As DLDestinationCountryCode
		,DestinationTaxLocale.LocaleCounty As DLDestinationCounty
		,DestinationCountyCode.GnrlCnfgMulti As DLDestinationCountyCode
		,DestinationLocaleType.LcleTpeDscrptn As DLDestinationLocationType

		,'' As DLDiv_Dest_TerminalCode -- Will be empty
		,'' As DLDiv_Dest_Description -- Will be empty
		,'' As DLDiv_DestJurisdiction -- Will be empty

		,'' As DL_Alt_Document_Number -- Not External Batch ??
		,case when (DealHeader.DlHdrTyp = 20) then 'Y' else 'N' end [DLexchange_ind]
		,case when (MovementHeaderType.MvtHdrTyp = 'A') then MovementHeader.ExternalBatch else null end As DL_Pipeline_Batch_Number
		,Vehicle.VhcleNme As DL_VesselName
		,case when(Vehicle.VhcleTpe = 'V') then VehicleVessel.USCGID else VehicleBarge.USCGID end As DL_Vessel_Number
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then cast(TransactionHeader.XHdrDte as date) else cast(TaxTransactionHeader.XHdrDte as date) end 

		,case when (AccountDetail.AcctDtlSrceTble = 'X') then DATEPART(year, TransactionHeader.XHdrDte) else DATEPART(year, TaxTransactionHeader.XHdrDte) end
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then DATEPART(month, TransactionHeader.XHdrDte) else DATEPART(month, TaxTransactionHeader.XHdrDte) end
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrID else TaxTransactionHeader.XHdrID end As DL_Fcustom_numeric_03
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrChldXHdrID else TaxTransactionHeader.XHdrChldXHdrID end

		,DATEPART(year, AccountDetail.AcctDtlTrnsctnDte) As DL_custom_numeric_04
		,DATEPART(month, AccountDetail.AcctDtlTrnsctnDte) As DL_custom_numeric_05
		
		,TransactionDetail.XDtlID As DL_custom_numeric_06
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end
		,DealType.Description As DL_custom_string_01
		,CommoditySubGroup.Name As DL_custom_string_02
		,MovementHeaderType.Name As DL_custom_string_03
		,DealHeader.DlHdrIntrnlNbr As DL_custom_string_04
		,case when (TaxRALocaleType.LcleTpeID = 115) then 'Yes' else 'No' end -- check to see if the Location type is TERMINAL-EQUITY
		,case when (DealType.Description like '%3rd Party%') then 'Yes' else 'No' end

		,PayableHeader.InvoiceNumber As DL_custom_string_06
		,AccountDetail.AcctDtlID As DL_custom_string_07
		,ExternalBA.BANme As DL_ExternalBA
		,SAPSoldTo.SoldTo As DL_SAP_Cust_No
		,SAPSoldTo.VendorNumber As DL_SAP_Vendor_No
		,ExtBASCAC.GnrlCnfgMulti As DL_ExternalBASCAC
		,ProductMaterialCode.GnrlCnfgMulti As DL_custom_string_13
		,case when (VehicleVessel.USCGID is not null OR VehicleBarge.USCGID is not null) then 'No' else 'Yes' end DL_FV_Identifier
		,case when (AccountDetail.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'C') then 'Complete' when (AccountDetail.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'R') then 'Reversed' 
		 when (AccountDetail.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'C') then 'Complete' when (AccountDetail.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'R') then 'Reversed' end
		,ProductGrade.GnrlCnfgMulti As ProductGrade
		,MovementHeader.MvtHdrLcleID
		,Product.PrdctNme As DL_custom_string_19
		,TransactionType.TrnsctnTypDesc As DL_custom_string_20
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrID else TaxTransactionHeader.XHdrID end
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrChldXHdrID else TaxTransactionHeader.XHdrChldXHdrID end
		,AccountDetail.AcctDtlID As DL_AcctID
		,ExternalBA.BANme As DL_AcctExtBA
		,DealHeader.DlHdrIntrnlNbr As DL_AcctDeal
		,AccountDetail.AcctDtlTrnsctnDte As DL_Acct_TktDate
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As DL_Acct_BOL
		,MovementDocument.MvtDcmntDte As DL_Acct_BOL_Date

		,AccountDetailLocation.LcleAbbrvtn As DL_AcctDtlLoc
		,Product.PrdctNme As DL_Acct_PrdName
		,ProductCode.GnrlCnfgMulti As DL_Acct_FTAProductCode
		,CommoditySubGroup.Name As DL_Acct_Tax_Commodity
		,TransactionType.TrnsctnTypDesc As DL_Acct_Tax_TransactionType
		,case when (AccountDetail.Volume = AccountDetail.NetQuantity) then 'N' else 'G' end
		,convert(DECIMAL(20, 10), v_MTV_TaxRates.TaxRate)
		,convert(DECIMAL(15,3), AccountDetail.Value) As DL_Acct_Tran_Amt

		,OriginLocale.LcleAbbrvtn As DL_Acct_Origin
		,DestinationLocale.LcleAbbrvtn As DL_Acct_Destination
		,SalesInvoiceHeader.SlsInvceHdrNmbr
		,AccountDetail.NetQuantity
		,AccountDetail.GrossQuantity
		,convert(varchar(20), AccountingPeriod.AccntngPrdPrd) + "/" + AccountingPeriod.AccntngPrdYr
		,Currency.CrrncyNme
		,AccountDetail.Reversed
		,case when (AccountDetail.AcctDtlTxStts = 'R') then 'Evaluated' else 'Not Evaluated' end 
		,AccountDetail.AcctDtlSrceTble
		,InternalBA.BANme
		,SalesInvoiceType.SlsInvceTpeDscrptn
		,Term.TrmVrbge
		,SalesInvoiceHeader.SlsInvceHdrNmbr
		,PayableHeader.InvoiceNumber
		,cast(SalesInvoiceHeader.SlsInvceHdrCrtnDte as date)
		,AccountDetail.PayableMatchingStatus
		,MovementHeaderType.Name
		,DealType.Description
		,OriginTaxLocale.LocaleState
		,DestinationTaxLocale.LocaleState
		,AccountDetail.AcctDtlAcctCdeStts
		,OriginTaxLocale.LocaleCity
		,OriginTaxLocale.LocaleCounty
		,DestinationTaxLocale.LocaleCity
		,DestinationTaxLocale.LocaleCounty
		,TaxLocale.LocaleState
		,AccountDetail.Volume
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end
		,AccountDetail.Reversed
		,convert(varchar(50), DATEPART(month, MovementHeader.MvtHdrDte)) + "/" + convert(varchar(50),DATEPART(year, MovementHeader.MvtHdrDte))
		,AccountDetail.AcctDtlTrnsctnDte
		,AccountDetail.CreatedDate
		,Buyer.BAID
		,Seller.BAID
		,ExternalBA.Name
		,ExternalBA.BAID
		,Buyer.Name 
		,BuyerFEIN.GnrlCnfgMulti
		,Seller.Name
		,SellerFEIN.GnrlCnfgMulti
		,TransactionDetail.XDtlLstInChn
		,AccountDetail.AcctDtlTxStts
		,AccountDetail.AcctDtlPrntID
		,Users.UserDBMnkr
	From	[AccountDetail] (NoLock)
		Left Join [TransactionDetailLog] (NoLock) On
			[AccountDetail].AcctDtlSrceID = [TransactionDetailLog].XDtlLgID And [AccountDetail].AcctDtlSrceTble = 'X'
		Left Join [TransactionHeader] (NoLock) On
			TransactionDetailLog.XDtlLgXDtlXHdrID = TransactionHeader.XHdrID
		Left Join TaxDetailLog (NoLock) On
			[AccountDetail].AcctDtlSrceID = [TaxDetailLog].TxDtlLgID And AccountDetail.AcctDtlSrceTble = 'T'
		Left Join TaxDetail (NoLock) On
			TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
		Left Join [TransactionHeader] As TaxTransactionHeader (NoLock) On
			[TaxDetail].txdtlsrceid = [TaxTransactionHeader].XHdrID
			and TaxDetail.TxDtlSrceTble = 'X'
		Left Join [MovementDocumentArchive] (NoLock) On
			[TransactionHeader].MvtDcmntArchveID = [MovementDocumentArchive].MvtDcmntArchveID
		Left Join [PlannedTransfer] (NoLock) On
			[PlannedTransfer].[PlnndTrnsfrID] = case 
													when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrPlnndTrnsfrID
													else TaxTransactionHeader.XHdrPlnndTrnsfrID end
		Left Join DealHeader (NoLock) On
			[PlannedTransfer].[PlnndTrnsfrObDlDtlDlHdrID] = [DealHeader].[DlHdrID]
		Left Join [MovementHeader] (NoLock) On
			AccountDetail.AcctDtlMvtHdrID = [MovementHeader].[MvtHdrID]
		Left Join [LeaseDealHeader] (NoLock) On
			[TransactionHeader].[LeaseDlHdrID] = [LeaseDealHeader].[DlHdrID]
		
		Left join [DealDetail] (NoLock) On
				DealDetail.DealDetailID = case 
													when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.DealDetailID
													else TaxTransactionHeader.DealDetailID end
		Left Join UnitOfMeasure (NoLock) On
				DealHeader.UOM = UnitOfMeasure.UOM

		Left Join [BusinessAssociate] As Buyer (NoLock) On
				Buyer.BAID = Case	When TransactionHeader.XHdrTyp = 'R' Then  DealHeader.DlHdrIntrnlBAID
									When TransactionHeader.XHdrTyp = 'D' Then  DealHeader.DlHdrExtrnlBAID 
							Else	MovementHeader.MvtHdrSrchBAID 	End
		Left Join GeneralConfiguration As BuyerFEIN (NoLock) On
				BuyerFEIN.GnrlCnfgQlfr = 'FederalTaxID'
				And BuyerFEIN.GnrlCnfgTblNme = 'BusinessAssociate'
				And BuyerFEIN.GnrlCnfgHdrID = Buyer.BAID
		Left Join [GeneralConfiguration] As BuyerControlName (NoLock) On
				BuyerControlName.[GnrlCnfgQlfr] = 'SCAC'
				And BuyerControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And BuyerControlName.[GnrlCnfgHdrID] = Buyer.BAID
							
		Left Join [GeneralConfiguration] As CarrierFEIN (NoLock) On
				[CarrierFEIN].[GnrlCnfgQlfr] = 'FederalTaxID'
				And [CarrierFEIN].[GnrlCnfgTblNme] = 'BusinessAssociate'
				And [CarrierFEIN].[GnrlCnfgHdrID] = [MovementHeader].[MvtHdrCrrrBAID]
		Left Join [GeneralConfiguration] As CarrierControlName (NoLock) On
				CarrierControlName.[GnrlCnfgQlfr] = 'SCAC'
				And CarrierControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And CarrierControlName.[GnrlCnfgHdrID] = [MovementHeader].[MvtHdrCrrrBAID]
		Left Join [BusinessAssociate] As Carrier (NoLock) On
				Carrier.BAID = [MovementHeader].[MvtHdrCrrrBAID]
				
		Left Join [BusinessAssociate] As PositionHolder (NoLock) On
				PositionHolder.BAID = Case	When DealHeader.DlHdrTyp = 171 Or DealHeader.DlHdrTyp = 173 Then DealHeader.DlHdrExtrnlBAID 
											Else  DealHeader.DlHdrIntrnlBAID End
		Left Join [GeneralConfiguration] As PositionHolderFEIN (NoLock) On
				PositionHolderFEIN.[GnrlCnfgQlfr] = 'FederalTaxID'
				And PositionHolderFEIN.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And PositionHolderFEIN.[GnrlCnfgHdrID] = PositionHolder.BAID
		Left Join [GeneralConfiguration] As PositionHolderControlName (NoLock) On
				PositionHolderControlName.[GnrlCnfgQlfr] = 'SCAC'
				And PositionHolderControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And PositionHolderControlName.[GnrlCnfgHdrID] = PositionHolder.BAID

		Left Join BusinessAssociate As ExchPositionHolder (NoLock) On
				ExchPositionHolder.BAID = Case When DealHeader.DlHdrTyp = 20 Then DealHeader.DlHdrExtrnlBAID Else 0 End
		Left Join [GeneralConfiguration] As ExchPositionHolderFEIN (NoLock) On
				ExchPositionHolderFEIN.[GnrlCnfgQlfr] = 'FederalTaxID'
				And ExchPositionHolderFEIN.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And ExchPositionHolderFEIN.[GnrlCnfgHdrID] = ExchPositionHolder.BAID
		Left Join [GeneralConfiguration] As ExchPositionHolderControlName (NoLock) On
				ExchPositionHolderControlName.[GnrlCnfgQlfr] = 'SCAC'
				And ExchPositionHolderControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And ExchPositionHolderControlName.[GnrlCnfgHdrID] = ExchPositionHolder.BAID
				
		Left Join [BusinessAssociate] As Seller (NoLock) On
				Seller.BAID = Case	When TransactionHeader.XHdrTyp = 'D' Then  DealHeader.DlHdrIntrnlBAID
									When TransactionHeader.XHdrTyp = 'R' Then  DealHeader.DlHdrExtrnlBAID 
							  Else MovementHeader.MvtHdrSrchBAID End
		Left Join [GeneralConfiguration] As SellerFEIN (NoLock) On
				SellerFEIN.[GnrlCnfgQlfr] = 'FederalTaxID'
				And SellerFEIN.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And SellerFEIN.[GnrlCnfgHdrID] = Seller.BAID
		Left Join [GeneralConfiguration] As SellerControlName (NoLock) On
				SellerControlName.[GnrlCnfgQlfr] = 'SCAC'
				And SellerControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And SellerControlName.[GnrlCnfgHdrID] = Seller.BAID
		
		Left Join BusinessAssociate As Consignor (NoLock) On
				   Consignor.BAID = Case When DealDetail.DlDtlLcleID = Isnull(IsNull(MovementHeader.MvtHdrOrgnLcleID, MovementHeader.MvtHdrLcleID),0)	Then Buyer.BAID
										 When DealDetail.DlDtlLcleID = Isnull(IsNull(TransactionHeader.DestinationLcleID,TransactionHeader.MovementLcleID),0)	Then Seller.BAID
									Else Buyer.BAID  End
		Left Join [GeneralConfiguration] As ConsignorFEIN (NoLock) On
				[ConsignorFEIN].[GnrlCnfgQlfr] = 'FederalTaxID'
				And [ConsignorFEIN].[GnrlCnfgTblNme] = 'BusinessAssociate'
				And [ConsignorFEIN].[GnrlCnfgHdrID] = Consignor.BAID
		Left Join [GeneralConfiguration] As ConsignorControlName (NoLock) On
				ConsignorControlName.[GnrlCnfgQlfr] = 'SCAC'
				And ConsignorControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And ConsignorControlName.[GnrlCnfgHdrID] = Consignor.BAID
		
		--IsNull(MovementHeader.MvtHdrLcleID, MovementHeader.MvtHdrOrgnLcleID)
		Left Join Locale As OriginLocale (NoLock) On
				Accountdetail.AcctDtlLcleID = OriginLocale.LcleID
		Left Join LocaleType As OriginLocaleType (NoLock) On
				OriginLocale.LcleTpeID = OriginLocaleType.LcleTpeID
		Left Join v_MTV_TaxLocaleCountyCityState As OriginTaxLocale (NoLock) On
				OriginTaxLocale.LcleID = Accountdetail.AcctDtlLcleID
		Left Join GeneralConfiguration As OriginTerminalCode (NoLock) On
				OriginTerminalCode.GnrlCnfgQlfr = 'TCN'
				And OriginTerminalCode.GnrlCnfgTblNme = 'Locale'
				And OriginTerminalCode.GnrlCnfgHdrID = Accountdetail.AcctDtlLcleID
		Left Join [GeneralConfiguration] As OriginCountyCode (NoLock) On
				OriginCountyCode.[GnrlCnfgQlfr] = 'USFedCountyCode'
				And OriginCountyCode.[GnrlCnfgTblNme] = 'Locale'
				And OriginCountyCode.[GnrlCnfgHdrID] = Accountdetail.AcctDtlLcleID
		Left Join [GeneralConfiguration] As OriginCountryCode (NoLock) On
				OriginCountryCode.[GnrlCnfgQlfr] = 'CountryCode'
				And OriginCountryCode.[GnrlCnfgTblNme] = 'Locale'
				And OriginCountryCode.[GnrlCnfgHdrID] =  Accountdetail.AcctDtlLcleID
		Left Join [GeneralConfiguration] As OriginZipCode (NoLock) On
				OriginZipCode.[GnrlCnfgQlfr] = 'PostalCode'
				And OriginZipCode.[GnrlCnfgTblNme] = 'Locale'
				And OriginZipCode.[GnrlCnfgHdrID] =  Accountdetail.AcctDtlLcleID

		--IsNull(MovementHeader.MvtHdrDstntnLcleID, TransactionHeader.DestinationLcleID)
		Left Join Locale As DestinationLocale (NoLock) On
				AccountDetail.AcctDtlDestinationLcleID = DestinationLocale.LcleID
		Left Join LocaleType As DestinationLocaleType (NoLock) On
				DestinationLocale.LcleTpeID = DestinationLocaleType.LcleTpeID
		Left Join v_MTV_TaxLocaleCountyCityState As DestinationTaxLocale (NoLock) On
				DestinationTaxLocale.LcleID = AccountDetail.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationTerminalCode (NoLock) On
				DestinationTerminalCode.[GnrlCnfgQlfr] = 'TCN'
				And DestinationTerminalCode.[GnrlCnfgTblNme] = 'Locale'
				And DestinationTerminalCode.[GnrlCnfgHdrID] = AccountDetail.AcctDtlDestinationLcleID
		Left Join GeneralConfiguration As DestinationAddress1 (NoLock) On
				DestinationAddress1.[GnrlCnfgQlfr] = 'AddrLine1'
				And DestinationAddress1.[GnrlCnfgTblNme] = 'Locale'
				And DestinationAddress1.[GnrlCnfgHdrID] = AccountDetail.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationAddress2 (NoLock) On
				DestinationAddress2.[GnrlCnfgQlfr] = 'AddrLine2'
				And DestinationAddress2.[GnrlCnfgTblNme] = 'Locale'
				And DestinationAddress2.[GnrlCnfgHdrID] = AccountDetail.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationCountyCode (NoLock) On
				DestinationCountyCode.[GnrlCnfgQlfr] = 'USFedCountyCode'
				And DestinationCountyCode.[GnrlCnfgTblNme] = 'Locale'
				And DestinationCountyCode.[GnrlCnfgHdrID] = AccountDetail.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationCountryCode (NoLock) On
				DestinationCountryCode.[GnrlCnfgQlfr] = 'CountryCode'
				And DestinationCountryCode.[GnrlCnfgTblNme] = 'Locale'
				And DestinationCountryCode.[GnrlCnfgHdrID] = AccountDetail.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationZipCode (NoLock) On
				DestinationZipCode.[GnrlCnfgQlfr] = 'PostalCode'
				And DestinationZipCode.[GnrlCnfgTblNme] = 'Locale'
				And DestinationZipCode.[GnrlCnfgHdrID] = AccountDetail.AcctDtlDestinationLcleID

		Left Join [DealType] (NoLock) On
				DealType.DlTypID = DealHeader.DlHdrTyp
		Left Join [Product] (NoLock) On
				MovementHeader.MvtHdrPrdctID = Product.PrdctID
		Left Join [GeneralConfiguration] As ProductCode (NoLock) On
				[ProductCode].[GnrlCnfgQlfr] = 'FTAProductCode'
				And [ProductCode].[GnrlCnfgTblNme] = 'Product'
				And [ProductCode].[GnrlCnfgHdrID] = [MovementHeader].[MvtHdrPrdctID]
		Left Join [GeneralConfiguration] As ProductMaterialCode (NoLock) On
				ProductMaterialCode.GnrlCnfgQlfr = 'SAPMaterialCode'
				And ProductMaterialCode.GnrlCnfgTblNme = 'Product'
				And ProductMaterialCode.GnrlCnfgHdrID = [MovementHeader].[MvtHdrPrdctID]
		Left Join [GeneralConfiguration] As ProductGrade (NoLock) On
				ProductGrade.GnrlCnfgQlfr = 'ProductGrade'
				And ProductGrade.GnrlCnfgTblNme = 'Product'
				And ProductGrade.GnrlCnfgHdrID = [MovementHeader].[MvtHdrPrdctID]
		Left Join CommoditySubGroup (NoLock) On
				CommoditySubGroup.CmmdtySbGrpID = Product.TaxCmmdtySbGrpID
		Left Join MovementHeaderType (NoLock) On
				MovementHeader.MvtHdrTyp = MovementHeaderType.MvtHdrTyp
				
-- Start the joins with the Accounting tables this will result in pulling all the Accounting txns for each Transaction Header ... Transaction Detail (all provisions) 1... 1. Account Detail
		Left Join TransactionDetail (NoLock) On
				TransactionDetail.TransactionDetailID = case 
															when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionDetailLog.XDtlLgXDtlID
															else TaxDetailLog.TxDtlLgTxDtlID end
		Left Join SalesInvoiceHeader (NoLock) On	
				SalesInvoiceHeader.SlsInvceHdrID = AccountDetail.AcctDtlSlsInvceHdrID
		Left Join SalesInvoiceType (NoLock) On	
				SalesInvoiceHeader.SlsInvceHdrSlsInvceTpeID = SalesInvoiceType.SlsInvceTpeID
		Left Join PayableHeader (NoLock) On
				PayableHeader.PybleHdrID = AccountDetail.AcctDtlPrchseInvceHdrID
		Left Join TransactionType (NoLock) On
				AccountDetail.AcctDtlTrnsctnTypID = TransactionType.TrnsctnTypID
		Left Join Locale As AccountDetailLocation (NoLock) On
				AccountDetailLocation.LcleID = AccountDetail.AcctDtlLcleID
		Left Join AccountingPeriod (NoLock) On
				AccountDetail.AcctDtlAccntngPrdID = AccountingPeriod.AccntngPrdID
		Left Join Currency (NoLock) On
				Currency.CrrncyID = AccountDetail.CrrncyID
		Left Join BusinessAssociate As ExternalBA (NoLock) On
				AccountDetail.ExternalBAID = ExternalBA.BAID
		Left Join GeneralConfiguration As ExtBASAPCustomerNumber (NoLock) On
				ExtBASAPCustomerNumber.GnrlCnfgQlfr = 'SAPSoldTo'
				And ExtBASAPCustomerNumber.GnrlCnfgTblNme = 'DealHeader'
				And ExtBASAPCustomerNumber.GnrlCnfgHdrID = AccountDetail.AcctDtlDlDtlDlHdrID
				And ExtBASAPCustomerNumber.GnrlCnfgMulti != 'X'
		Left Join MTVSAPBASoldTo As SAPSoldTo (NoLock) On
				SAPSoldTo.ID = ExtBASAPCustomerNumber.GnrlCnfgMulti
		Left Join [GeneralConfiguration] As ExtBASCAC (NoLock) On
				ExtBASCAC.[GnrlCnfgQlfr] = 'SCAC'
				And ExtBASCAC.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And ExtBASCAC.[GnrlCnfgHdrID] = ExternalBA.BAID
		Left Join BusinessAssociate As InternalBA (NoLock) On
				AccountDetail.InternalBAID = InternalBA.BAID
		Left Join v_MTV_TaxLocaleCountyCityState As TaxLocale (NoLock) On
				TaxLocale.LcleID = MovementHeader.MvtHdrLcleID
		Left Join Locale As TaxRALocale (NoLock) On
				TaxRALocale.LcleID = TaxLocale.LcleID
		Left Join LocaleType As TaxRALocaleType (NoLock) On
				TaxRALocaleType.LcleTpeID = TaxRALocale.LcleTpeID
		Left Join Vehicle (NoLock) On
				MovementHeader.MvtHdrVhcleID = Vehicle.VhcleID
		Left Join VehicleVessel (NoLock) On
				Vehicle.VhcleID = VehicleVessel.VhcleVsslVhcleID
		Left Join VehicleBarge (NoLock) On
				Vehicle.VhcleID = VehicleBarge.VhcleBrgeVhcleID
		Left Join Term (NoLock) On
				Term.TrmID = SalesInvoiceHeader.SlsInvceHdrTrmID

		Left Join v_MTV_TaxRates (NoLock) On
				AccountDetail.AcctDtlID = v_MTV_TaxRates.AcctDtlID
		Left Join Users (NoLock) On
				MovementHeader.UserID = Users.UserID

		Left Join MovementHeader As DocMovementHeader (NoLock) On
				DocMovementHeader.MvtHdrID = case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrMvtDtlMvtHdrID 
													else TaxTransactionHeader.XHdrMvtDtlMvtHdrID end
		Left Join MovementDocument (NoLock) On
				DocMovementHeader.MvtHdrMvtDcmntID = MovementDocument.[MvtDcmntID]
						
	where AccountDetail.CreatedDate > @TransactionFromDate

	RETURN;
	END

GO

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[MTV_TaxAccountingTransactionData]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'fn_MTV_TaxAccountingTransactionData.sql'
			PRINT '<<< ALTERED Function MTV_TaxAccountingTransactionData >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function MTV_TaxAccountingTransactionData >>>'
	  END

--End of Script: MTV_TaxAccountingTransactionData.sql
