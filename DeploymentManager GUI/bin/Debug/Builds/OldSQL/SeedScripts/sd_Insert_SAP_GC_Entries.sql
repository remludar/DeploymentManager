/*
select * from custominvoiceinterface

SELECT TOP 500 ID, Entity, Reprocess FROM CustomMessageQueue (NOLOCK) WHERE RAProcessed = 0 or Reprocess = 1

sp_find CustomMessageQueue 
MTV_StarMailStage

payableheader

select	ID as CIIMssgQID,
		CompanyCode,					-- Hard code to USK7
				DocumentDate,			-- RA – Invoice Date
				PostingDate,			-- ??
				Currency,				-- RA – Invoice Currency
				PostingPeriod,			-- No mapping
				DocumentType,			-- ??
				DocumentHeaderText,		-- RA – Invoice Number
				ReferenceDocument,		-- For Credit, Original invoice number for a reversal (correcting?)
				FiscalYear,				-- RA – Year from accounting period
				PostingKey,				-- 01-Invoice, 12-Reverse Invoice, 02-Credit Memo, 11-Reverse Credit Memo
				ReferenceKey1,			-- Sold To #
				ReferenceKey2,			-- RA – BOL number (if single) or “MultipleBOL”
				ReferenceKey3,			-- RA – Deal Number
				CalculateTax,			-- **AR ONLY**	No mapping
				TaxCode,				-- TBD
				TaxAmount,				-- ??
				DocumentAmount,			-- RA – Invoice amount
				LocalAmount,			-- RA – Invoice amount
				Account,				-- AR-SAP Customer # ; GL-Account Code
				LineItemText,			-- RA – Internal BA Abbreviation
				Assignment,				-- RA – Invoice Number
				CostCenter,				-- RA – CostCenter attribute on origin locale
				ProfitCenter,			-- RA – CostCenter attribute on origin locale
				PaymentTerm,			-- RA – Payment Term (4 chars?? TrmAbbrvtn is 20)
				PaymentReference,		-- RA – Payment Term (TrmVrbge is 255 char)
				PaymentMethod,			-- No mapping
				Material,				-- RA – SAP Material Code attribute on product
				Plant,					-- ?? should this be SAPPlantCode on Origin Locale?
				DistributionChannel,	-- **AR ONLY**	No mapping
				SalesOrg,				-- **AR ONLY**	No mapping
				Division,				-- **AR ONLY**	No mapping
				TaxJurisdiction,		-- No mapping
				Quantity,				-- RA – Sales Invoice Detail quantity?
				BaseUnit,				-- RA – Sales Invoice Detail UOM – always gallons
				ReversalReason,			-- **AR ONLY**	Reason from table in Biz Req doc (only P01?)
				CreditMemo,				-- **AR ONLY**	“If not credit memo, no mapping” what if it is?
				BaselineDate,			-- RA – Sales Invoice Header due date
				PaymentBlock,			-- No mapping
				RightAngleStatus,		-- No mapping
				MiddlewareStatus,		-- No mapping
				SAPStatus,				-- No mapping
				FileName,				-- No mapping
select *
from	CustomInvoiceInterface as CII with (NoLock)
where	

select * from v_mtv_xrefattributes

sp_find CustomAccountDetail

Custom_Interface_AR_Outbound

Custom_Interface_AD_Mapping

select * from GeneralConfiguration where gnrlcnfgtblnme = 'businessassociate' and GnrlCnfgQlfr like 'SAP%'
*/


IF NOT EXISTS(SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'Product' AND GnrlCnfgQlfr = 'SAPMaterialCode' AND GnrlCnfgHdrID = 0)
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Product', 'SAPMaterialCode', 0,0,'X'

IF NOT EXISTS(SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'Term' AND GnrlCnfgQlfr = 'SAPTermCode' AND GnrlCnfgHdrID = 0)
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Term', 'SAPTermCode', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'Term', 'SAPARCode', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'BusinessAssociate', 'InvoiceDisplayName', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'Office', 'Registration', 0,0,'X'

IF NOT EXISTS(SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'BusinessAssociate' AND GnrlCnfgQlfr = 'SAPVendorNumber' AND GnrlCnfgHdrID = 0)
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'BusinessAssociate', 'SAPVendorNumber', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'BusinessAssociate', 'SAPCustomerClass', 0,0,'X'

IF NOT EXISTS(SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'BusinessAssociate' AND GnrlCnfgQlfr = 'SAPCustomerNumber' AND GnrlCnfgHdrID = 0)
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'BusinessAssociate', 'SAPCustomerNumber', 0,0,'X'

IF NOT EXISTS(SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'BusinessAssociate' AND GnrlCnfgQlfr = 'SAPInternalNumber' AND GnrlCnfgHdrID = 0)
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'BusinessAssociate', 'SAPInternalNumber', 0,0,'X'

IF NOT EXISTS(SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'Locale' AND GnrlCnfgQlfr = 'SAPPlantCode' AND GnrlCnfgHdrID = 0)
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Locale', 'SAPPlantCode', 0,0,'X'

IF NOT EXISTS(SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'Locale' AND GnrlCnfgQlfr = 'SAPCostCenter' AND GnrlCnfgHdrID = 0)
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Locale', 'SAPCostCenter', 0,0,'X'

IF NOT EXISTS(SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'Locale' AND GnrlCnfgQlfr = 'SAPProfitCenter' AND GnrlCnfgHdrID = 0)
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Locale', 'SAPProfitCenter', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'Contact', 'SalesGroup', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'BusinessAssociate', 'SAPSalesOffice', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'DealHeader', 'ExchangeTraded', 0,0,'X'
----And    GeneralConfiguration. GnrlCnfgMulti      = 'Clearport'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'MovementHeader', 'StorageLocation', 0,0,'X'
                                                                                                       
--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'MovementHeader', 'Plant', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'Prvsn', 'Prvsn Adjustment', 0,0,'X'
----And    GeneralConfiguration. GnrlCnfgMulti      = 'Y'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'VATDescription', 'SAPAPCode', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'VATDescription', 'SAPARCode', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'DealHeader', 'Desk', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'DealDetail', 'Desk', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'DynamicListBox', 'CostCenterTrading', 0,0,'X'

--Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
--Select	'DynamicListBox', 'CostCenterOps', 0,0,'X'

declare @i_key int

IF NOT EXISTS (SELECT 1 FROM TransactionGroup WHERE XGrpName = 'Document Type DA' AND XGrpQlfr = 'SAP Document Types')
BEGIN
	exec sp_getkey 'TransactionGroup', @i_key out
	Insert	TransactionGroup (XGrpID, XGrpName, XGrpQlfr, XGrpLckd)
	Select	@i_key, 'Document Type DA', 'SAP Document Types', 'N'
END

IF NOT EXISTS (SELECT 1 FROM TransactionGroup WHERE XGrpName = 'Document Type KN' AND XGrpQlfr = 'SAP Document Types')
BEGIN
	exec sp_getkey 'TransactionGroup', @i_key out
	Insert	TransactionGroup (XGrpID, XGrpName, XGrpQlfr, XGrpLckd)
	Select	@i_key, 'Document Type KN', 'SAP Document Types', 'N'
END

IF NOT EXISTS (SELECT 1 FROM TransactionGroup WHERE XGrpName = 'Document Type SW' AND XGrpQlfr = 'SAP Document Types')
BEGIN
	exec sp_getkey 'TransactionGroup', @i_key out
	Insert	TransactionGroup (XGrpID, XGrpName, XGrpQlfr, XGrpLckd)
	Select	@i_key, 'Document Type SW', 'SAP Document Types', 'N'
END

IF NOT EXISTS (SELECT 1 FROM TransactionGroup WHERE XGrpName = 'Document Type DD' AND XGrpQlfr = 'SAP Document Types')
BEGIN
	exec sp_getkey 'TransactionGroup', @i_key out
	Insert	TransactionGroup (XGrpID, XGrpName, XGrpQlfr, XGrpLckd)
	Select	@i_key, 'Document Type DD', 'SAP Document Types', 'N'
END

IF NOT EXISTS (SELECT 1 FROM TransactionGroup WHERE XGrpName = 'Document Type DG' AND XGrpQlfr = 'SAP Document Types')
BEGIN
	exec sp_getkey 'TransactionGroup', @i_key out
	Insert	TransactionGroup (XGrpID, XGrpName, XGrpQlfr, XGrpLckd)
	Select	@i_key, 'Document Type DG', 'SAP Document Types', 'N'
END

IF NOT EXISTS (SELECT 1 FROM TransactionGroup WHERE XGrpName = 'Document Type DR' AND XGrpQlfr = 'SAP Document Types')
BEGIN
	exec sp_getkey 'TransactionGroup', @i_key out
	Insert	TransactionGroup (XGrpID, XGrpName, XGrpQlfr, XGrpLckd)
	Select	@i_key, 'Document Type DR', 'SAP Document Types', 'N'
END

IF NOT EXISTS (SELECT 1 FROM TransactionGroup WHERE XGrpName = 'Document Type RV' AND XGrpQlfr = 'SAP Document Types')
BEGIN
	exec sp_getkey 'TransactionGroup', @i_key out
	Insert	TransactionGroup (XGrpID, XGrpName, XGrpQlfr, XGrpLckd)
	Select	@i_key, 'Document Type RV', 'SAP Document Types', 'N'
END



/* -- this will seed some dummy values into General Config
Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Product', 'SAPMaterialCode', PrdctID,0,'MatlCode'+ Convert(varchar,PrdctID)
From	Product

Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Term', 'SAPTermCode', TrmID,0,'TrmCode'+ Convert(varchar,TrmID)
From	Term

Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'BusinessAssociate', 'SAPVendorNumber', BAID,0,'VndrNmbr'+ Convert(varchar,BAID)
From	BusinessAssociate

Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'BusinessAssociate', 'SAPCustomerNumber', BAID,0,'CstNmbr'+ Convert(varchar,BAID)
From	BusinessAssociate

Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'BusinessAssociate', 'SAPInternalNumber', BAID,0,'IntrnlNbr'+ Convert(varchar,BAID)
From	BusinessAssociate

Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Locale', 'SAPPlantCode', LcleID,0,'PlantCode'+ Convert(varchar,LcleID)
From	Locale

Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Locale', 'SAPCostCenter', LcleID,0,'CostCtr'+ Convert(varchar,LcleID)
From	Locale

Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Locale', 'SAPProfitCenter', LcleID,0,'ProfitCtr'+ Convert(varchar,LcleID)
From	Locale
*/
