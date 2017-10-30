/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTaxAccountingTransactions WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_IncrementalTaxAccountingTransactions]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTaxAccountingTransactions.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTaxAccountingTransactions]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[MTV_IncrementalTaxAccountingTransactions](@In smalldatetime) AS SELECT 1'
			PRINT '<<< CREATED Procedure MTV_IncrementalTaxAccountingTransactions >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[MTV_IncrementalTaxAccountingTransactions]    Script Date: 6/2/2016 8:20:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER Procedure [dbo].[MTV_IncrementalTaxAccountingTransactions] @transactionsFromDate smalldatetime, @userId int
As
select * into #TaxLocaleStructure from v_MTV_TaxLocaleCountyCityState
select * into #TaxRates from v_MTV_TaxRates
Select	TaxLocale.LocaleState as MVT_TitleTransfer
		,cast(AccountDetail.Volume as decimal(15,2)) As MVT_BilledUnits
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As MVT_BillOfLading
		,MovementDocument.MvtDcmntDte As MVT_BillOfLadingDate
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrGrssQty else TaxTransactionHeader.XHdrGrssQty end as MVT_GrossUnits
		,case when (PayableHeader.CreatedDate is not null) then PayableHeader.CreatedDate else SalesInvoiceHeader.SlsInvceHdrCrtnDte end as MVT_InvoiceDate
		,case when (PayableHeader.InvoiceNumber is not null) then PayableHeader.InvoiceNumber else SalesInvoiceHeader.SlsInvceHdrNmbr end as MVT_PurchaseInvoiceNumber
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrQty else TaxTransactionHeader.XHdrQty end as MVT_NetUnits
		,ProductCode.GnrlCnfgMulti As MVT_ProductCode
		,case when (AccountDetail.Volume != 0) then ABS(convert(DECIMAL(15,6), AccountDetail.Value/AccountDetail.Volume)) else 0 end as MVT_UnitPrice
				
		,'FEIN' as MVT_BuyerIdType
		,BuyerFEIN.GnrlCnfgMulti As MVT_BuyerIdCode
		,convert(int, Buyer.BAID) as MVT_BuyerCustomId
		,Buyer.Abbreviation As MVT_BuyerTradeName
		,Buyer.Name As MVT_BuyerLegalName
		,BuyerControlName.GnrlCnfgMulti As MVT_BuyerNameControl
		
		,'FEIN' As MVT_CarrierIdType
		,CarrierFEIN.GnrlCnfgMulti As MVT_CarrierIdCode
		,convert(int, Carrier.BAID) As MVT_CarrierCustomId
		,Carrier.Abbreviation As MVT_CarrierTradeName
		,Carrier.Name As MVT_CarrierLegalName
		,CarrierControlName.GnrlCnfgMulti As MVT_CarrierNameControl

		,'FEIN' as MVT_ConsignorIdType
		,ConsignorFEIN.GnrlCnfgMulti As MVT_ConsignorIdCode
		,convert(int, Consignor.BAID) As MVT_ConsignorCustomId
		,Consignor.Abbreviation As MVT_ConsignorTradeName
		,Consignor.Name As MVT_ConsignorLegalName
		,ConsignorControlName.GnrlCnfgMulti As MVT_ConsignorNameControl

		,'FEIN' as MVT_PositionHolderIdType
		,PositionHolderFEIN.GnrlCnfgMulti As MVT_PositionHolderIdCode
		,convert(int, PositionHolder.BAID) As MVT_PositionHolderCustomId
		,PositionHolder.Abbreviation As MVT_PositionHolderTradeName
		,PositionHolder.Name As MVT_PositionHolderLegalName
		,PositionHolderControlName.GnrlCnfgMulti As MVT_PositionHolderNameControl

		,'FEIN' as MVT_Exch_PositionHolderIdType
		,ExchPositionHolderFEIN.GnrlCnfgMulti As MVT_Exch_PositionHolderIdCode
		,convert(int, ExchPositionHolder.BAID) As MVT_Exch_PositionHolderCustomId
		,ExchPositionHolder.Abbreviation As MVT_Exch_PositionHolderTradeName
		,ExchPositionHolder.Name As MVT_Exch_PositionHolderLegalName
		,ExchPositionHolderControlName.GnrlCnfgMulti As MVT_Exch_PositionHolderNameControl

		,'FEIN' as MVT_SellerIdType
		,SellerFEIN.GnrlCnfgMulti As MVT_SellerIdCode
		,convert(int, Seller.BAID) As MVT_SellerCustomId
		,Seller.Abbreviation As MVT_SellerTradeName
		,Seller.Name As MVT_SellerLegalName
		,SellerControlName.GnrlCnfgMulti As MVT_SellerNameControl
		
		,OriginTerminalCode.GnrlCnfgMulti As MVT_OriginTerminalCode
		,convert(int, OriginLocale.LcleID) as MVT_OriginCustomId
		,OriginLocale.LcleAbbrvtn As MVT_OriginDescription
		,OriginTaxLocale.LocaleCity As MVT_OriginCity
		,OriginTaxLocale.LocaleState As MVT_OriginJurisdiction
		,OriginZipCode.GnrlCnfgMulti As MVT_OriginPostalCode
		,OriginCountryCode.GnrlCnfgMulti As MVT_OriginCountryCode
		,OriginTaxLocale.LocaleCounty As MVT_OriginCounty
		,OriginCountyCode.GnrlCnfgMulti As MVT_OriginCountyCode
		,OriginLocaleType.LcleTpeDscrptn As MVT_OriginLocationType

		,DestinationTerminalCode.GnrlCnfgMulti As MVT_DestinationTerminalCode
		,convert(int, DestinationLocale.LcleID) as MVT_DestinationCustomId
		,DestinationLocale.LcleAbbrvtn As MVT_DestinationDescription
		,DestinationAddress1.GnrlCnfgMulti As MVT_DestinationAddress1
		,DestinationAddress2.GnrlCnfgMulti As MVT_DestinationAddress2
		,DestinationTaxLocale.LocaleCity As MVT_DestinationCity
		,DestinationTaxLocale.LocaleState As MVT_DestinationJurisdiction
		,DestinationZipCode.GnrlCnfgMulti As MVT_DestinationPostalCode
		,DestinationCountryCode.GnrlCnfgMulti As MVT_DestinationCountryCode
		,DestinationTaxLocale.LocaleCounty As MVT_DestinationCounty
		,DestinationCountyCode.GnrlCnfgMulti As MVT_DestinationCountyCode
		,DestinationLocaleType.LcleTpeDscrptn As MVT_DestinationLocationType

		,'' As MVT_DivTerminalCode -- Will be empty
		,'' As MVT_DivDestination -- Will be empty
		,'' As MVT_DivJurisdiction -- Will be empty

		,'' As MVT_Alt_Document_Number -- Not External Batch ??
		,case when (DealHeader.DlHdrTyp = 20) then 'Y' else 'N' end as MVT_exchange_ind
		,case when (MovementHeaderType.MvtHdrTyp = 'A') then MovementHeader.ExternalBatch else null end As MVT_Pipeline_Batch_Number
		,Vehicle.VhcleNme As MVT_Vessel_Name
		,case when(Vehicle.VhcleTpe = 'V') then VehicleVessel.USCGID else VehicleBarge.USCGID end As MVT_Vessel_Number
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then cast(TransactionHeader.XHdrDte as date) else cast(TaxTransactionHeader.XHdrDte as date) end as MVT_Movement_Posted_Date

		,case when (AccountDetail.AcctDtlSrceTble = 'X') then DATEPART(year, TransactionHeader.XHdrDte) else DATEPART(year, TaxTransactionHeader.XHdrDte) end as MVT_Transaction_Year
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then DATEPART(month, TransactionHeader.XHdrDte) else DATEPART(month, TaxTransactionHeader.XHdrDte) end as MVT_Transaction_Month
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then convert(int, TransactionHeader.XHdrID) else convert(int, TaxTransactionHeader.XHdrID) end As MVT_Transaction_ID
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then convert(int, TransactionHeader.XHdrChldXHdrID) else convert(int, TaxTransactionHeader.XHdrChldXHdrID) end as MVT_Transaction_Child_Id

		,DATEPART(year, AccountDetail.AcctDtlTrnsctnDte) As MVT_Accounting_Year
		,DATEPART(month, AccountDetail.AcctDtlTrnsctnDte) As MVT_Accounting_Month
		
		,TransactionDetail.XDtlID As MVT_BOL_Item_Number
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end as MVT_RD_Type
		,DealType.Description As MVT_Deal_Type
		,CommoditySubGroup.Name As MVT_Tax_Commodity_Code
		,MovementHeaderType.Name As MVT_Movement_Type
		,DealHeader.DlHdrIntrnlNbr As MVT_Deal
		,case when (TaxRALocaleType.LcleTpeID = 115) then 'Yes' else 'No' end as MVT_Equity_Terminal -- check to see if the Location type is TERMINAL-EQUITY
		,case when (DealType.Description like '%3rd Party%') then 'Yes' else 'No' end as MVT_Is_Third_Party

		,PayableHeader.InvoiceNumber As MVT_Purchase_Order_Number
		,AccountDetail.AcctDtlID As MVT_Account_DetailID
		,ExternalBA.BANme As MVT_ExternalBA
		,SAPSoldTo.SoldTo As MVT_GSAP_CustomerNumber
		,SAPSoldTo.VendorNumber As MVT_GSAP_VendorNumber
		,ExtBASCAC.GnrlCnfgMulti As MVT_SCAC
		,ProductMaterialCode.GnrlCnfgMulti As MVT_SAP_Material_Code
		,case when (VehicleVessel.USCGID is not null OR VehicleBarge.USCGID is not null) then 'No' else 'Yes' end as MVT_Foreign_Vessel_Identifier
		,case when (AccountDetail.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'C') then 'Complete' when (AccountDetail.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'R') then 'Reversed' 
		 when (AccountDetail.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'C') then 'Complete' when (AccountDetail.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'R') then 'Reversed' end as MVT_Transaction_Status
		,ProductGrade.GnrlCnfgMulti As MVT_Product_Grade
		,convert(int, MovementHeader.MvtHdrLcleID) as MVT_Location_ID
		,Product.PrdctNme As MVT_Product_Name
		,TransactionType.TrnsctnTypDesc As MVT_Transaction_Type
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then convert(int, TransactionHeader.XHdrID) else convert(int, TaxTransactionHeader.XHdrID) end as Acct_MVT_Transaction_Unique_Identifier
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then convert(int, TransactionHeader.XHdrChldXHdrID) else convert(int, TaxTransactionHeader.XHdrChldXHdrID) end as Acct_MVT_Transaction_Child_Id
		,convert(int, AccountDetail.AcctDtlID) As Acct_DtlID
		,ExternalBA.BANme As Acct_ExtBA
		,DealHeader.DlHdrIntrnlNbr As Acct_Deal
		,AccountDetail.AcctDtlTrnsctnDte As Acct_TktDate
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As Acct_BOL
		,MovementDocument.MvtDcmntDte As Acct_BOL_Date

		,AccountDetailLocation.LcleAbbrvtn As Acct_AcctDtlLoc
		,Product.PrdctNme As Acct_Product
		,ProductCode.GnrlCnfgMulti As Acct_ProductCode
		,CommoditySubGroup.Name As Acct_Tax_Commodity
		,TransactionType.TrnsctnTypDesc As Acct_TransactionType
		,case when (AccountDetail.Volume = AccountDetail.NetQuantity) then 'N' else 'G' end as Acct_NG
		,convert(DECIMAL(20, 10), #TaxRates.TaxRate) as Acct_Rate
		,convert(DECIMAL(15,3), AccountDetail.Value) As Acct_Tran_Amt

		,OriginLocale.LcleAbbrvtn As Acct_Origin
		,DestinationLocale.LcleAbbrvtn As Acct_Destination
		,SalesInvoiceHeader.SlsInvceHdrNmbr as Acct_SlsInv
		,AccountDetail.NetQuantity as Acct_Net
		,AccountDetail.GrossQuantity as Acct_Gross
		,convert(varchar(20), AccountingPeriod.AccntngPrdPrd) + "/" + AccountingPeriod.AccntngPrdYr as Acct_AcctPeriod
		,Currency.CrrncyNme as Acct_Curr
		,AccountDetail.Reversed as Acct_Rev
		,case when (AccountDetail.AcctDtlTxStts = 'R') then 'Evaluated' else 'Not Evaluated' end as Acct_Taxed
		,AccountDetail.AcctDtlSrceTble as Acct_Source
		,InternalBA.BANme as Acct_IntBA
		,SalesInvoiceType.SlsInvceTpeDscrptn as Acct_Invoice_Description
		,Term.TrmVrbge as Acct_Billing_Term
		,SalesInvoiceHeader.SlsInvceHdrNmbr as Acct_SalesInvoiceNumber
		,PayableHeader.InvoiceNumber as Acct_PurchaseInvoiceNumber
		,cast(SalesInvoiceHeader.SlsInvceHdrCrtnDte as date) as Acct_InvoiceDate
		,AccountDetail.PayableMatchingStatus as Acct_Payable_Matching_Status
		,MovementHeaderType.Name as Acct_MovementType
		,DealType.Description as Acct_DealType
		,OriginTaxLocale.LocaleState as Acct_OriginState
		,DestinationTaxLocale.LocaleState as Acct_DestinationState
		,AccountDetail.AcctDtlAcctCdeStts as Acct_AcctCodeStatus
		,OriginTaxLocale.LocaleCity as Acct_OriginCity
		,OriginTaxLocale.LocaleCounty as Acct_OriginCounty
		,DestinationTaxLocale.LocaleCity as Acct_DestinationCity
		,DestinationTaxLocale.LocaleCounty as Acct_DestinationCounty
		,TaxLocale.LocaleState as Acct_Title_Transfer
		,AccountDetail.Volume as Acct_BilledGallons
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end as Acct_R_D
		,AccountDetail.Reversed as Acct_Reversed
		,convert(varchar(50), DATEPART(month, MovementHeader.MvtHdrDte)) + "/" + convert(varchar(50),DATEPART(year, MovementHeader.MvtHdrDte)) as Acct_Movement_Year_Month
		,AccountDetail.AcctDtlTrnsctnDte as Acct_Movement_Posting_Date
		,AccountDetail.CreatedDate as Acct_GL_Posting_Date
		,convert(int, Buyer.BAID) as Acct_Buyer_CustomID
		,convert(int, Seller.BAID) as Acct_Seller_CustomID
		,ExternalBA.Name as Acct_External_BA
		,convert(int, ExternalBA.BAID) as Acct_External_BAID
		,Buyer.Name as Acct_Buyer_LegalName
		,BuyerFEIN.GnrlCnfgMulti as Acct_Buyer_ID
		,Seller.Name as Acct_Seller_LegalName
		,SellerFEIN.GnrlCnfgMulti as Acct_Seller_ID
		,TransactionDetail.XDtlLstInChn as MVT_Last_In_Chain
		,AccountDetail.AcctDtlTxStts as Acct_Detail_Status
		,AccountDetail.AcctDtlPrntID as Account_Detail_ParentID
		,Users.UserDBMnkr as MVT_Changed_By
		,getdate() as CreatedDate
		,@userId as UserID
		,'N' as ProcessedStatus
		,NULL as PublishedDate
		,0 as InterfaceID
		into #AccountingTransactions
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
		Left Join #TaxLocaleStructure As OriginTaxLocale (NoLock) On
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
		Left Join #TaxLocaleStructure As DestinationTaxLocale (NoLock) On
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
		Left Join #TaxLocaleStructure As TaxLocale (NoLock) On
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

		Left Join #TaxRates (NoLock) On
				AccountDetail.AcctDtlID = #TaxRates.AcctDtlID
		Left Join Users (NoLock) On
				MovementHeader.UserID = Users.UserID

		Left Join MovementHeader As DocMovementHeader (NoLock) On
				DocMovementHeader.MvtHdrID = case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrMvtDtlMvtHdrID 
													else TaxTransactionHeader.XHdrMvtDtlMvtHdrID end
		Left Join MovementDocument (NoLock) On
				DocMovementHeader.MvtHdrMvtDcmntID = MovementDocument.[MvtDcmntID]
						
	where AccountDetail.CreatedDate > @transactionsFromDate

	select * from #AccountingTransactions

	union all

	Select	TaxLocale.LocaleState as MVT_TitleTransfer
		,cast(AccountDetail.Volume as decimal(15,2)) As MVT_BilledUnits
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As MVT_BillOfLading
		,MovementDocument.MvtDcmntDte As MVT_BillOfLadingDate
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrGrssQty else TaxTransactionHeader.XHdrGrssQty end as MVT_GrossUnits
		,case when (PayableHeader.CreatedDate is not null) then PayableHeader.CreatedDate else SalesInvoiceHeader.SlsInvceHdrCrtnDte end as MVT_InvoiceDate
		,case when (PayableHeader.InvoiceNumber is not null) then PayableHeader.InvoiceNumber else SalesInvoiceHeader.SlsInvceHdrNmbr end as MVT_PurchaseInvoiceNumber
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrQty else TaxTransactionHeader.XHdrQty end as MVT_NetUnits
		,ProductCode.GnrlCnfgMulti As MVT_ProductCode
		,case when (AccountDetail.Volume != 0) then ABS(convert(DECIMAL(15,6), AccountDetail.Value/AccountDetail.Volume)) else 0 end as MVT_UnitPrice
				
		,'FEIN' as MVT_BuyerIdType
		,BuyerFEIN.GnrlCnfgMulti As MVT_BuyerIdCode
		,Buyer.BAID as MVT_BuyerCustomId
		,Buyer.Abbreviation As MVT_BuyerTradeName
		,Buyer.Name As MVT_BuyerLegalName
		,BuyerControlName.GnrlCnfgMulti As MVT_BuyerNameControl
		
		,'FEIN' As MVT_CarrierIdType
		,CarrierFEIN.GnrlCnfgMulti As MVT_CarrierIdCode
		,Carrier.BAID As MVT_CarrierCustomId
		,Carrier.Abbreviation As MVT_CarrierTradeName
		,Carrier.Name As MVT_CarrierLegalName
		,CarrierControlName.GnrlCnfgMulti As MVT_CarrierNameControl

		,'FEIN' as MVT_ConsignorIdType
		,ConsignorFEIN.GnrlCnfgMulti As MVT_ConsignorIdCode
		,Consignor.BAID As MVT_ConsignorCustomId
		,Consignor.Abbreviation As MVT_ConsignorTradeName
		,Consignor.Name As MVT_ConsignorLegalName
		,ConsignorControlName.GnrlCnfgMulti As MVT_ConsignorNameControl

		,'FEIN' as MVT_PositionHolderIdType
		,PositionHolderFEIN.GnrlCnfgMulti As MVT_PositionHolderIdCode
		,PositionHolder.BAID As MVT_PositionHolderCustomId
		,PositionHolder.Abbreviation As MVT_PositionHolderTradeName
		,PositionHolder.Name As MVT_PositionHolderLegalName
		,PositionHolderControlName.GnrlCnfgMulti As MVT_PositionHolderNameControl

		,'FEIN' as MVT_Exch_PositionHolderIdType
		,ExchPositionHolderFEIN.GnrlCnfgMulti As MVT_Exch_PositionHolderIdCode
		,ExchPositionHolder.BAID As MVT_Exch_PositionHolderCustomId
		,ExchPositionHolder.Abbreviation As MVT_Exch_PositionHolderTradeName
		,ExchPositionHolder.Name As MVT_Exch_PositionHolderLegalName
		,ExchPositionHolderControlName.GnrlCnfgMulti As MVT_Exch_PositionHolderNameControl

		,'FEIN' as MVT_SellerIdType
		,SellerFEIN.GnrlCnfgMulti As MVT_SellerIdCode
		,Seller.BAID As MVT_SellerCustomId
		,Seller.Abbreviation As MVT_SellerTradeName
		,Seller.Name As MVT_SellerLegalName
		,SellerControlName.GnrlCnfgMulti As MVT_SellerNameControl
		
		,OriginTerminalCode.GnrlCnfgMulti As MVT_OriginTerminalCode
		,OriginLocale.LcleID as MVT_OriginCustomId
		,OriginLocale.LcleAbbrvtn As MVT_OriginDescription
		,OriginTaxLocale.LocaleCity As MVT_OriginCity
		,OriginTaxLocale.LocaleState As MVT_OriginJurisdiction
		,OriginZipCode.GnrlCnfgMulti As MVT_OriginPostalCode
		,OriginCountryCode.GnrlCnfgMulti As MVT_OriginCountryCode
		,OriginTaxLocale.LocaleCounty As MVT_OriginCounty
		,OriginCountyCode.GnrlCnfgMulti As MVT_OriginCountyCode
		,OriginLocaleType.LcleTpeDscrptn As MVT_OriginLocationType

		,DestinationTerminalCode.GnrlCnfgMulti As MVT_DestinationTerminalCode
		,DestinationLocale.LcleID as MVT_DestinationCustomId
		,DestinationLocale.LcleAbbrvtn As MVT_DestinationDescription
		,DestinationAddress1.GnrlCnfgMulti As MVT_DestinationAddress1
		,DestinationAddress2.GnrlCnfgMulti As MVT_DestinationAddress2
		,DestinationTaxLocale.LocaleCity As MVT_DestinationCity
		,DestinationTaxLocale.LocaleState As MVT_DestinationJurisdiction
		,DestinationZipCode.GnrlCnfgMulti As MVT_DestinationPostalCode
		,DestinationCountryCode.GnrlCnfgMulti As MVT_DestinationCountryCode
		,DestinationTaxLocale.LocaleCounty As MVT_DestinationCounty
		,DestinationCountyCode.GnrlCnfgMulti As MVT_DestinationCountyCode
		,DestinationLocaleType.LcleTpeDscrptn As MVT_DestinationLocationType

		,'' As MVT_DivTerminalCode -- Will be empty
		,'' As MVT_DivDestination -- Will be empty
		,'' As MVT_DivJurisdiction -- Will be empty

		,'' As MVT_Alt_Document_Number -- Not External Batch ??
		,case when (DealHeader.DlHdrTyp = 20) then 'Y' else 'N' end as MVT_exchange_ind
		,case when (MovementHeaderType.MvtHdrTyp = 'A') then MovementHeader.ExternalBatch else null end As MVT_Pipeline_Batch_Number
		,Vehicle.VhcleNme As MVT_Vessel_Name
		,case when(Vehicle.VhcleTpe = 'V') then VehicleVessel.USCGID else VehicleBarge.USCGID end As MVT_Vessel_Number
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then cast(TransactionHeader.XHdrDte as date) else cast(TaxTransactionHeader.XHdrDte as date) end as MVT_Movement_Posted_Date

		,case when (AccountDetail.AcctDtlSrceTble = 'X') then DATEPART(year, TransactionHeader.XHdrDte) else DATEPART(year, TaxTransactionHeader.XHdrDte) end as MVT_Transaction_Year
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then DATEPART(month, TransactionHeader.XHdrDte) else DATEPART(month, TaxTransactionHeader.XHdrDte) end as MVT_Transaction_Month
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrID else TaxTransactionHeader.XHdrID end As MVT_Transaction_ID
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrChldXHdrID else TaxTransactionHeader.XHdrChldXHdrID end as MVT_Transaction_Child_Id

		,DATEPART(year, AccountDetail.AcctDtlTrnsctnDte) As MVT_Accounting_Year
		,DATEPART(month, AccountDetail.AcctDtlTrnsctnDte) As MVT_Accounting_Month
		
		,TransactionDetail.XDtlID As MVT_BOL_Item_Number
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end as MVT_RD_Type
		,DealType.Description As MVT_Deal_Type
		,CommoditySubGroup.Name As MVT_Tax_Commodity_Code
		,MovementHeaderType.Name As MVT_Movement_Type
		,DealHeader.DlHdrIntrnlNbr As MVT_Deal
		,case when (TaxRALocaleType.LcleTpeID = 115) then 'Yes' else 'No' end as MVT_Equity_Terminal -- check to see if the Location type is TERMINAL-EQUITY
		,case when (DealType.Description like '%3rd Party%') then 'Yes' else 'No' end as MVT_Is_Third_Party

		,PayableHeader.InvoiceNumber As MVT_Purchase_Order_Number
		,AccountDetail.AcctDtlID As MVT_Account_DetailID
		,ExternalBA.BANme As MVT_ExternalBA
		,SAPSoldTo.SoldTo As MVT_GSAP_CustomerNumber
		,SAPSoldTo.VendorNumber As MVT_GSAP_VendorNumber
		,ExtBASCAC.GnrlCnfgMulti As MVT_SCAC
		,ProductMaterialCode.GnrlCnfgMulti As MVT_SAP_Material_Code
		,case when (VehicleVessel.USCGID is not null OR VehicleBarge.USCGID is not null) then 'No' else 'Yes' end as MVT_Foreign_Vessel_Identifier
		,case when (AccountDetail.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'C') then 'Complete' when (AccountDetail.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'R') then 'Reversed' 
		 when (AccountDetail.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'C') then 'Complete' when (AccountDetail.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'R') then 'Reversed' end as MVT_Transaction_Status
		,ProductGrade.GnrlCnfgMulti As MVT_Product_Grade
		,MovementHeader.MvtHdrLcleID as MVT_Location_ID
		,Product.PrdctNme As MVT_Product_Name
		,TransactionType.TrnsctnTypDesc As MVT_Transaction_Type
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrID else TaxTransactionHeader.XHdrID end as Acct_MVT_Transaction_Unique_Identifier
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrChldXHdrID else TaxTransactionHeader.XHdrChldXHdrID end as Acct_MVT_Transaction_Child_Id
		,AccountDetail.AcctDtlID As Acct_DtlID
		,ExternalBA.BANme As Acct_ExtBA
		,DealHeader.DlHdrIntrnlNbr As Acct_Deal
		,AccountDetail.AcctDtlTrnsctnDte As Acct_TktDate
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As Acct_BOL
		,MovementDocument.MvtDcmntDte As Acct_BOL_Date

		,AccountDetailLocation.LcleAbbrvtn As Acct_AcctDtlLoc
		,Product.PrdctNme As Acct_Product
		,ProductCode.GnrlCnfgMulti As Acct_ProductCode
		,CommoditySubGroup.Name As Acct_Tax_Commodity
		,TransactionType.TrnsctnTypDesc As Acct_TransactionType
		,case when (AccountDetail.Volume = AccountDetail.NetQuantity) then 'N' else 'G' end as Acct_NG
		,convert(DECIMAL(20, 10), #TaxRates.TaxRate) as Acct_Rate
		,convert(DECIMAL(15,3), AccountDetail.Value) As Acct_Tran_Amt

		,OriginLocale.LcleAbbrvtn As Acct_Origin
		,DestinationLocale.LcleAbbrvtn As Acct_Destination
		,SalesInvoiceHeader.SlsInvceHdrNmbr as Acct_SlsInv
		,AccountDetail.NetQuantity as Acct_Net
		,AccountDetail.GrossQuantity as Acct_Gross
		,convert(varchar(20), AccountingPeriod.AccntngPrdPrd) + "/" + AccountingPeriod.AccntngPrdYr as Acct_AcctPeriod
		,Currency.CrrncyNme as Acct_Curr
		,AccountDetail.Reversed as Acct_Rev
		,case when (AccountDetail.AcctDtlTxStts = 'R') then 'Evaluated' else 'Not Evaluated' end as Acct_Taxed
		,AccountDetail.AcctDtlSrceTble as Acct_Source
		,InternalBA.BANme as Acct_IntBA
		,SalesInvoiceType.SlsInvceTpeDscrptn as Acct_Invoice_Description
		,Term.TrmVrbge as Acct_Billing_Term
		,SalesInvoiceHeader.SlsInvceHdrNmbr as Acct_SalesInvoiceNumber
		,PayableHeader.InvoiceNumber as Acct_PurchaseInvoiceNumber
		,cast(SalesInvoiceHeader.SlsInvceHdrCrtnDte as date) as Acct_InvoiceDate
		,AccountDetail.PayableMatchingStatus as Acct_Payable_Matching_Status
		,MovementHeaderType.Name as Acct_MovementType
		,DealType.Description as Acct_DealType
		,OriginTaxLocale.LocaleState as Acct_OriginState
		,DestinationTaxLocale.LocaleState as Acct_DestinationState
		,AccountDetail.AcctDtlAcctCdeStts as Acct_AcctCodeStatus
		,OriginTaxLocale.LocaleCity as Acct_OriginCity
		,OriginTaxLocale.LocaleCounty as Acct_OriginCounty
		,DestinationTaxLocale.LocaleCity as Acct_DestinationCity
		,DestinationTaxLocale.LocaleCounty as Acct_DestinationCounty
		,TaxLocale.LocaleState as Acct_Title_Transfer
		,AccountDetail.Volume as Acct_BilledGallons
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end as Acct_R_D
		,AccountDetail.Reversed as Acct_Reversed
		,convert(varchar(50), DATEPART(month, MovementHeader.MvtHdrDte)) + "/" + convert(varchar(50),DATEPART(year, MovementHeader.MvtHdrDte)) as Acct_Movement_Year_Month
		,AccountDetail.AcctDtlTrnsctnDte as Acct_Movement_Posting_Date
		,AccountDetail.CreatedDate as Acct_GL_Posting_Date
		,Buyer.BAID as Acct_Buyer_CustomID
		,Seller.BAID as Acct_Seller_CustomID
		,ExternalBA.Name as Acct_External_BA
		,ExternalBA.BAID as Acct_External_BAID
		,Buyer.Name as Acct_Buyer_LegalName
		,BuyerFEIN.GnrlCnfgMulti as Acct_Buyer_ID
		,Seller.Name as Acct_Seller_LegalName
		,SellerFEIN.GnrlCnfgMulti as Acct_Seller_ID
		,TransactionDetail.XDtlLstInChn as MVT_Last_In_Chain
		,AccountDetail.AcctDtlTxStts as Acct_Detail_Status
		,AccountDetail.AcctDtlPrntID as Account_Detail_ParentID
		,Users.UserDBMnkr as MVT_Changed_By
		,getdate() as CreatedDate
		,@userId as UserID
		,'N'
		,NULL
		,0
	From	CustomMessageQueue (NoLock)
		Left Join AccountDetail (NoLock) On
			CustomMessageQueue.EntityID = case when (CustomMessageQueue.Entity = 'SH') then AccountDetail.AcctDtlSlsInvceHdrID
												else AccountDetail.AcctDtlPrchseInvceHdrID end
		Left Outer Join #AccountingTransactions (NoLock) On
			#AccountingTransactions.Acct_DtlID = AccountDetail.AcctDtlID
		Left Join [TransactionDetailLog] (NoLock) On
			AccountDetail.AcctDtlSrceID = TransactionDetailLog.XDtlLgID And AccountDetail.AcctDtlSrceTble = 'X'
		Left Join [TransactionHeader] (NoLock) On
			TransactionDetailLog.XDtlLgXDtlXHdrID = TransactionHeader.XHdrID
		Left Join TaxDetailLog (NoLock) On
			AccountDetail.AcctDtlSrceID = [TaxDetailLog].TxDtlLgID And AccountDetail.AcctDtlSrceTble = 'T'
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
				DealDetail.DealDetailID = case	when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.DealDetailID
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
		Left Join #TaxLocaleStructure As OriginTaxLocale (NoLock) On
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
		Left Join #TaxLocaleStructure As DestinationTaxLocale (NoLock) On
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
		Left Join #TaxLocaleStructure As TaxLocale (NoLock) On
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

		Left Join #TaxRates (NoLock) On
				AccountDetail.AcctDtlID = #TaxRates.AcctDtlID
		Left Join Users (NoLock) On
				MovementHeader.UserID = Users.UserID

		Left Join MovementHeader As DocMovementHeader (NoLock) On
				DocMovementHeader.MvtHdrID = case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrMvtDtlMvtHdrID 
													else TaxTransactionHeader.XHdrMvtDtlMvtHdrID end
		Left Join MovementDocument (NoLock) On
				DocMovementHeader.MvtHdrMvtDcmntID = MovementDocument.[MvtDcmntID]
						
	where CustomMessageQueue.CreationDate > @transactionsFromDate
	and #AccountingTransactions.Acct_DtlID is null


	union all

	Select	TaxLocale.LocaleState as MVT_TitleTransfer
		,cast(AccountDetail.Volume as decimal(15,2)) As MVT_BilledUnits
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As MVT_BillOfLading
		,MovementDocument.MvtDcmntDte As MVT_BillOfLadingDate
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrGrssQty else TaxTransactionHeader.XHdrGrssQty end as MVT_GrossUnits
		,case when (PayableHeader.CreatedDate is not null) then PayableHeader.CreatedDate else SalesInvoiceHeader.SlsInvceHdrCrtnDte end as MVT_InvoiceDate
		,case when (PayableHeader.InvoiceNumber is not null) then PayableHeader.InvoiceNumber else SalesInvoiceHeader.SlsInvceHdrNmbr end as MVT_PurchaseInvoiceNumber
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrQty else TaxTransactionHeader.XHdrQty end as MVT_NetUnits
		,ProductCode.GnrlCnfgMulti As MVT_ProductCode
		,case when (AccountDetail.Volume != 0) then ABS(convert(DECIMAL(15,6), AccountDetail.Value/AccountDetail.Volume)) else 0 end as MVT_UnitPrice
				
		,'FEIN' as MVT_BuyerIdType
		,BuyerFEIN.GnrlCnfgMulti As MVT_BuyerIdCode
		,Buyer.BAID as MVT_BuyerCustomId
		,Buyer.Abbreviation As MVT_BuyerTradeName
		,Buyer.Name As MVT_BuyerLegalName
		,BuyerControlName.GnrlCnfgMulti As MVT_BuyerNameControl
		
		,'FEIN' As MVT_CarrierIdType
		,CarrierFEIN.GnrlCnfgMulti As MVT_CarrierIdCode
		,Carrier.BAID As MVT_CarrierCustomId
		,Carrier.Abbreviation As MVT_CarrierTradeName
		,Carrier.Name As MVT_CarrierLegalName
		,CarrierControlName.GnrlCnfgMulti As MVT_CarrierNameControl

		,'FEIN' as MVT_ConsignorIdType
		,ConsignorFEIN.GnrlCnfgMulti As MVT_ConsignorIdCode
		,Consignor.BAID As MVT_ConsignorCustomId
		,Consignor.Abbreviation As MVT_ConsignorTradeName
		,Consignor.Name As MVT_ConsignorLegalName
		,ConsignorControlName.GnrlCnfgMulti As MVT_ConsignorNameControl

		,'FEIN' as MVT_PositionHolderIdType
		,PositionHolderFEIN.GnrlCnfgMulti As MVT_PositionHolderIdCode
		,PositionHolder.BAID As MVT_PositionHolderCustomId
		,PositionHolder.Abbreviation As MVT_PositionHolderTradeName
		,PositionHolder.Name As MVT_PositionHolderLegalName
		,PositionHolderControlName.GnrlCnfgMulti As MVT_PositionHolderNameControl

		,'FEIN' as MVT_Exch_PositionHolderIdType
		,ExchPositionHolderFEIN.GnrlCnfgMulti As MVT_Exch_PositionHolderIdCode
		,ExchPositionHolder.BAID As MVT_Exch_PositionHolderCustomId
		,ExchPositionHolder.Abbreviation As MVT_Exch_PositionHolderTradeName
		,ExchPositionHolder.Name As MVT_Exch_PositionHolderLegalName
		,ExchPositionHolderControlName.GnrlCnfgMulti As MVT_Exch_PositionHolderNameControl

		,'FEIN' as MVT_SellerIdType
		,SellerFEIN.GnrlCnfgMulti As MVT_SellerIdCode
		,Seller.BAID As MVT_SellerCustomId
		,Seller.Abbreviation As MVT_SellerTradeName
		,Seller.Name As MVT_SellerLegalName
		,SellerControlName.GnrlCnfgMulti As MVT_SellerNameControl
		
		,OriginTerminalCode.GnrlCnfgMulti As MVT_OriginTerminalCode
		,OriginLocale.LcleID as MVT_OriginCustomId
		,OriginLocale.LcleAbbrvtn As MVT_OriginDescription
		,OriginTaxLocale.LocaleCity As MVT_OriginCity
		,OriginTaxLocale.LocaleState As MVT_OriginJurisdiction
		,OriginZipCode.GnrlCnfgMulti As MVT_OriginPostalCode
		,OriginCountryCode.GnrlCnfgMulti As MVT_OriginCountryCode
		,OriginTaxLocale.LocaleCounty As MVT_OriginCounty
		,OriginCountyCode.GnrlCnfgMulti As MVT_OriginCountyCode
		,OriginLocaleType.LcleTpeDscrptn As MVT_OriginLocationType

		,DestinationTerminalCode.GnrlCnfgMulti As MVT_DestinationTerminalCode
		,DestinationLocale.LcleID as MVT_DestinationCustomId
		,DestinationLocale.LcleAbbrvtn As MVT_DestinationDescription
		,DestinationAddress1.GnrlCnfgMulti As MVT_DestinationAddress1
		,DestinationAddress2.GnrlCnfgMulti As MVT_DestinationAddress2
		,DestinationTaxLocale.LocaleCity As MVT_DestinationCity
		,DestinationTaxLocale.LocaleState As MVT_DestinationJurisdiction
		,DestinationZipCode.GnrlCnfgMulti As MVT_DestinationPostalCode
		,DestinationCountryCode.GnrlCnfgMulti As MVT_DestinationCountryCode
		,DestinationTaxLocale.LocaleCounty As MVT_DestinationCounty
		,DestinationCountyCode.GnrlCnfgMulti As MVT_DestinationCountyCode
		,DestinationLocaleType.LcleTpeDscrptn As MVT_DestinationLocationType

		,'' As MVT_DivTerminalCode -- Will be empty
		,'' As MVT_DivDestination -- Will be empty
		,'' As MVT_DivJurisdiction -- Will be empty

		,'' As MVT_Alt_Document_Number -- Not External Batch ??
		,case when (DealHeader.DlHdrTyp = 20) then 'Y' else 'N' end as MVT_exchange_ind
		,case when (MovementHeaderType.MvtHdrTyp = 'A') then MovementHeader.ExternalBatch else null end As MVT_Pipeline_Batch_Number
		,Vehicle.VhcleNme As MVT_Vessel_Name
		,case when(Vehicle.VhcleTpe = 'V') then VehicleVessel.USCGID else VehicleBarge.USCGID end As MVT_Vessel_Number
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then cast(TransactionHeader.XHdrDte as date) else cast(TaxTransactionHeader.XHdrDte as date) end as MVT_Movement_Posted_Date

		,case when (AccountDetail.AcctDtlSrceTble = 'X') then DATEPART(year, TransactionHeader.XHdrDte) else DATEPART(year, TaxTransactionHeader.XHdrDte) end as MVT_Transaction_Year
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then DATEPART(month, TransactionHeader.XHdrDte) else DATEPART(month, TaxTransactionHeader.XHdrDte) end as MVT_Transaction_Month
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrID else TaxTransactionHeader.XHdrID end As MVT_Transaction_ID
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrChldXHdrID else TaxTransactionHeader.XHdrChldXHdrID end as MVT_Transaction_Child_Id

		,DATEPART(year, AccountDetail.AcctDtlTrnsctnDte) As MVT_Accounting_Year
		,DATEPART(month, AccountDetail.AcctDtlTrnsctnDte) As MVT_Accounting_Month
		
		,TransactionDetail.XDtlID As MVT_BOL_Item_Number
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end as MVT_RD_Type
		,DealType.Description As MVT_Deal_Type
		,CommoditySubGroup.Name As MVT_Tax_Commodity_Code
		,MovementHeaderType.Name As MVT_Movement_Type
		,DealHeader.DlHdrIntrnlNbr As MVT_Deal
		,case when (TaxRALocaleType.LcleTpeID = 115) then 'Yes' else 'No' end as MVT_Equity_Terminal -- check to see if the Location type is TERMINAL-EQUITY
		,case when (DealType.Description like '%3rd Party%') then 'Yes' else 'No' end as MVT_Is_Third_Party

		,PayableHeader.InvoiceNumber As MVT_Purchase_Order_Number
		,AccountDetail.AcctDtlID As MVT_Account_DetailID
		,ExternalBA.BANme As MVT_ExternalBA
		,SAPSoldTo.SoldTo As MVT_GSAP_CustomerNumber
		,SAPSoldTo.VendorNumber As MVT_GSAP_VendorNumber
		,ExtBASCAC.GnrlCnfgMulti As MVT_SCAC
		,ProductMaterialCode.GnrlCnfgMulti As MVT_SAP_Material_Code
		,case when (VehicleVessel.USCGID is not null OR VehicleBarge.USCGID is not null) then 'No' else 'Yes' end as MVT_Foreign_Vessel_Identifier
		,case when (AccountDetail.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'C') then 'Complete' when (AccountDetail.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'R') then 'Reversed' 
		 when (AccountDetail.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'C') then 'Complete' when (AccountDetail.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'R') then 'Reversed' end as MVT_Transaction_Status
		,ProductGrade.GnrlCnfgMulti As MVT_Product_Grade
		,MovementHeader.MvtHdrLcleID as MVT_Location_ID
		,Product.PrdctNme As MVT_Product_Name
		,TransactionType.TrnsctnTypDesc As MVT_Transaction_Type
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrID else TaxTransactionHeader.XHdrID end as Acct_MVT_Transaction_Unique_Identifier
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrChldXHdrID else TaxTransactionHeader.XHdrChldXHdrID end as Acct_MVT_Transaction_Child_Id
		,AccountDetail.AcctDtlID As Acct_DtlID
		,ExternalBA.BANme As Acct_ExtBA
		,DealHeader.DlHdrIntrnlNbr As Acct_Deal
		,AccountDetail.AcctDtlTrnsctnDte As Acct_TktDate
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As Acct_BOL
		,MovementDocument.MvtDcmntDte As Acct_BOL_Date

		,AccountDetailLocation.LcleAbbrvtn As Acct_AcctDtlLoc
		,Product.PrdctNme As Acct_Product
		,ProductCode.GnrlCnfgMulti As Acct_ProductCode
		,CommoditySubGroup.Name As Acct_Tax_Commodity
		,TransactionType.TrnsctnTypDesc As Acct_TransactionType
		,case when (AccountDetail.Volume = AccountDetail.NetQuantity) then 'N' else 'G' end as Acct_NG
		,convert(DECIMAL(20, 10), #TaxRates.TaxRate) as Acct_Rate
		,convert(DECIMAL(15,3), AccountDetail.Value) As Acct_Tran_Amt

		,OriginLocale.LcleAbbrvtn As Acct_Origin
		,DestinationLocale.LcleAbbrvtn As Acct_Destination
		,SalesInvoiceHeader.SlsInvceHdrNmbr as Acct_SlsInv
		,AccountDetail.NetQuantity as Acct_Net
		,AccountDetail.GrossQuantity as Acct_Gross
		,convert(varchar(20), AccountingPeriod.AccntngPrdPrd) + "/" + AccountingPeriod.AccntngPrdYr as Acct_AcctPeriod
		,Currency.CrrncyNme as Acct_Curr
		,AccountDetail.Reversed as Acct_Rev
		,case when (AccountDetail.AcctDtlTxStts = 'R') then 'Evaluated' else 'Not Evaluated' end as Acct_Taxed
		,AccountDetail.AcctDtlSrceTble as Acct_Source
		,InternalBA.BANme as Acct_IntBA
		,SalesInvoiceType.SlsInvceTpeDscrptn as Acct_Invoice_Description
		,Term.TrmVrbge as Acct_Billing_Term
		,SalesInvoiceHeader.SlsInvceHdrNmbr as Acct_SalesInvoiceNumber
		,PayableHeader.InvoiceNumber as Acct_PurchaseInvoiceNumber
		,cast(SalesInvoiceHeader.SlsInvceHdrCrtnDte as date) as Acct_InvoiceDate
		,AccountDetail.PayableMatchingStatus as Acct_Payable_Matching_Status
		,MovementHeaderType.Name as Acct_MovementType
		,DealType.Description as Acct_DealType
		,OriginTaxLocale.LocaleState as Acct_OriginState
		,DestinationTaxLocale.LocaleState as Acct_DestinationState
		,AccountDetail.AcctDtlAcctCdeStts as Acct_AcctCodeStatus
		,OriginTaxLocale.LocaleCity as Acct_OriginCity
		,OriginTaxLocale.LocaleCounty as Acct_OriginCounty
		,DestinationTaxLocale.LocaleCity as Acct_DestinationCity
		,DestinationTaxLocale.LocaleCounty as Acct_DestinationCounty
		,TaxLocale.LocaleState as Acct_Title_Transfer
		,AccountDetail.Volume as Acct_BilledGallons
		,case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end as Acct_R_D
		,AccountDetail.Reversed as Acct_Reversed
		,convert(varchar(50), DATEPART(month, MovementHeader.MvtHdrDte)) + "/" + convert(varchar(50),DATEPART(year, MovementHeader.MvtHdrDte)) as Acct_Movement_Year_Month
		,AccountDetail.AcctDtlTrnsctnDte as Acct_Movement_Posting_Date
		,AccountDetail.CreatedDate as Acct_GL_Posting_Date
		,Buyer.BAID as Acct_Buyer_CustomID
		,Seller.BAID as Acct_Seller_CustomID
		,ExternalBA.Name as Acct_External_BA
		,ExternalBA.BAID as Acct_External_BAID
		,Buyer.Name as Acct_Buyer_LegalName
		,BuyerFEIN.GnrlCnfgMulti as Acct_Buyer_ID
		,Seller.Name as Acct_Seller_LegalName
		,SellerFEIN.GnrlCnfgMulti as Acct_Seller_ID
		,TransactionDetail.XDtlLstInChn as MVT_Last_In_Chain
		,AccountDetail.AcctDtlTxStts as Acct_Detail_Status
		,AccountDetail.AcctDtlPrntID as Account_Detail_ParentID
		,Users.UserDBMnkr as MVT_Changed_By
		,getdate() as CreatedDate
		,@userId as UserID
		,'N'
		,NULL
		,0
	From	MTV_InvoiceDetail_AccountDetail_DeleteLog DLog (NoLock)
		Left Join AccountDetail (NoLock) On
			DLog.AccountDetailID = AccountDetail.AcctDtlId
		Left Outer Join #AccountingTransactions (NoLock) On
			#AccountingTransactions.Acct_DtlID = AccountDetail.AcctDtlID
		Left Join [TransactionDetailLog] (NoLock) On
			AccountDetail.AcctDtlSrceID = TransactionDetailLog.XDtlLgID And AccountDetail.AcctDtlSrceTble = 'X'
		Left Join [TransactionHeader] (NoLock) On
			TransactionDetailLog.XDtlLgXDtlXHdrID = TransactionHeader.XHdrID
		Left Join TaxDetailLog (NoLock) On
			AccountDetail.AcctDtlSrceID = [TaxDetailLog].TxDtlLgID And AccountDetail.AcctDtlSrceTble = 'T'
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
				DealDetail.DealDetailID = case	when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.DealDetailID
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
		Left Join #TaxLocaleStructure As OriginTaxLocale (NoLock) On
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
		Left Join #TaxLocaleStructure As DestinationTaxLocale (NoLock) On
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
		Left Join #TaxLocaleStructure As TaxLocale (NoLock) On
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

		Left Join #TaxRates (NoLock) On
				AccountDetail.AcctDtlID = #TaxRates.AcctDtlID
		Left Join Users (NoLock) On
				MovementHeader.UserID = Users.UserID

		Left Join MovementHeader As DocMovementHeader (NoLock) On
				DocMovementHeader.MvtHdrID = case when (AccountDetail.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrMvtDtlMvtHdrID 
													else TaxTransactionHeader.XHdrMvtDtlMvtHdrID end
		Left Join MovementDocument (NoLock) On
				DocMovementHeader.MvtHdrMvtDcmntID = MovementDocument.[MvtDcmntID]
						
	where DLog.CreatedDate > @transactionsFromDate
	and #AccountingTransactions.Acct_DtlID is null

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTaxAccountingTransactions]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_IncrementalTaxAccountingTransactions.sql'
			PRINT '<<< ALTERED Procedure MTV_IncrementalTaxAccountingTransactions >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Procedure MTV_IncrementalTaxAccountingTransactions >>>'
	  END


----------------------------------------------------------------------------------------------------------------------
-- Drop the temp table
----------------------------------------------------------------------------------------------------------------------	
If	Object_ID('TempDB..#AccountingTransactions') Is Not Null
BEGIN
	Drop Table #AccountingTransactions	
	PRINT 'Dropped Temp Table #AccountingTransactions'
END

If	Object_ID('TempDB..#TaxLocaleStructure') Is Not Null
BEGIN
	Drop Table #TaxLocaleStructure	
	PRINT 'Dropped Temp Table #TaxLocaleStructure'
END

If	Object_ID('TempDB..#TaxRates') Is Not Null
BEGIN
	Drop Table #TaxRates
	PRINT 'Dropped Temp Table #TaxRates'
END

--End of Script: sp_MTV_IncrementalTaxAccountingTransactions.sql
