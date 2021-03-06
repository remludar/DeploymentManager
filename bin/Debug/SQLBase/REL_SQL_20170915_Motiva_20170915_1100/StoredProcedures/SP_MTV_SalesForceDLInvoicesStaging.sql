/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVSalesforceDLInvoicesStaging WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[SP_MTVSalesforceDLInvoicesStaging.sql]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_MTVSalesforceDLInvoicesStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDLInvoicesStaging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVSalesforceDLInvoicesStaging] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVSalesforceDLInvoicesStaging >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVSalesforceDLInvoicesStaging]
		@n_NumRecordsToBeStaged int,
		@c_OnlyShowSQL char(1) = 'N'
AS

-- =========================================================================
-- Author:        Sanjay Kumar
-- Create date:	  9MAY2016
-- Description:   This SP pulls data from the CustomInvoiceInterface table,
--				  pushes it into MTVSalesforceDLInvoicesStaging, ready for 
--				  the user to run the SalesforceDLInvoicesExtract job
-- =========================================================================
-- Date         Modified By     Issue#  Modification
-- 12/12/2016   Sanjay Kumar            Added the TaxRate type to be populated in the Staging table.
-- -----------  --------------  ------  -------------------------------------
-- exec MTVSalesforceDLInvoicesStaging 100, 'y'
-----------------------------------------------------------------------------

DECLARE @vc_DynamicSQL	varchar(max)

set @vc_DynamicSQL = 'MTVTruncateMTVRetailerInvoicePreStage'
exec(@vc_DynamicSQL)

-- Create a temp table to hold our data
if (@c_OnlyShowSQL <> 'N')
	print '
	create table #Stage
	(
		Id								int,
		TagIdentifier					char(1),
		MsgQID							int,
		MotivaFEIN						Varchar(255),
		CompanyName						Varchar(255),
		MotivaARContactName				Varchar(40),
		ARContactEmail					Varchar(50),
		ARContactPhone					Varchar(25),
		BillToSoldToName				Varchar(100),
		BillToAddress					Varchar(255),
		BillToContact					Varchar(40),
		BillToSoldToNumber				Varchar(255),
		InvoiceNumber					Varchar(20),
		InvoiceDateTime					SmallDateTime,
		PaymentTerms					Varchar(255),
		DealNumber						Varchar(20),
		RemitTo							Varchar(1000),
		ShipFromTerminalAddress			Varchar(255),
		ShipToNumber					Varchar(255),
		ShipToAddress					Varchar(255),
		CustomerCharges					Varchar(80),
		ProductNumber					Varchar(255),
		ProductName						Varchar(50),
		OriginTerminal					Varchar(50),
		TerminalCode					Varchar(255),
		StandardCarrier					Varchar(255),
		CarrierName						Varchar(100),
		BOLNumber						Varchar(80),
		LoadDateTime					SmallDateTime,
		MovementType					Varchar(50),
		NetVolume						Decimal(19,6),
		GrossVolume						Decimal(19,6),
		BillingBasisIndicator			Varchar(10),
		UOM								Varchar(20),
		PerGallonBillingRate			Decimal(19,6),
		TotalProductCost				Decimal(19,6),
		TaxName							Varchar(80),
		TaxCode							Varchar(255),
		RelatedSalesInvoiceNumber		Varchar(240),
		InvoiceDueDate					SmallDateTime,
		DiscountedTotalAmount			Decimal(19,6),
		InvoiceType						Varchar(20),
		CorrectingInvoiceNumber			Varchar(20),
		DeferredTaxInvoiceNumber		Varchar(4000),
		DeferredTaxInvoiceDueDate		SmallDateTime,
		IsDeferred						char(1),
		RegulatoryText					Varchar(8000),
		EPAID							Varchar(255),
		DistributionChannel				Varchar(255),
		Division						Varchar(255),
		SalesOrg						Varchar(255),
		InvoiceTotalAmount				Float,
		TotalTax						Float,
		NetAmount						Float,
		CreationDate                    SmallDateTime,
		PaymentMethod					Varchar(100),
		InvoiceId						INT,
		MvtHdrId						INT,
		AcctDtlId						INT,
		TransactionType					Varchar(80)
		)'
else
	create table #tempMessageQueueIds (MessageQueueId int)
	insert #tempMessageQueueIds
	select distinct top (@n_NumRecordsToBeStaged) CII.MessageQueueID from CustomInvoiceInterface CII 
								Inner Join MTVInvoiceInterfaceStatus MTVIIS (NoLock) on 
								MTVIIS.CIIMssgQID = CII.MessageQueueID 
								where CII.IntBAID = 22 and MTVIIS.SalesForceDataLakeStaged	<> convert(bit, 1)
								order by CII.MessageQueueID asc

	create table #Stage
	(
		Id								int,
		TagIdentifier					char(1),
		MsgQID							int,
		MotivaFEIN						Varchar(255),
		CompanyName						Varchar(255),
		MotivaARContactName				Varchar(40),
		ARContactEmail					Varchar(50),
		ARContactPhone					Varchar(25),
		BillToSoldToName				Varchar(100),
		BillToAddress					Varchar(255),
		BillToContact					Varchar(40),
		BillToSoldToNumber				Varchar(255),
		InvoiceNumber					Varchar(20),
		InvoiceDateTime					SmallDateTime,
		PaymentTerms					Varchar(255),
		DealNumber						Varchar(20),
		RemitTo							Varchar(1000),
		ShipFromTerminalAddress			Varchar(255),
		ShipToNumber					Varchar(255),
		ShipToAddress					Varchar(255),
		CustomerCharges					Varchar(80),
		ProductNumber					Varchar(255),
		ProductName						Varchar(50),
		OriginTerminal					Varchar(50),
		TerminalCode					Varchar(255),
		StandardCarrier					Varchar(255),
		CarrierName						Varchar(100),
		BOLNumber						Varchar(80),
		LoadDateTime					SmallDateTime,
		MovementType					Varchar(50),
		NetVolume						Decimal(19,6),
		GrossVolume						Decimal(19,6),
		BillingBasisIndicator			Varchar(10),
		UOM								Varchar(20),
		PerGallonBillingRate			Decimal(19,6),
		TotalProductCost				Decimal(19,6),
		TaxName							Varchar(80),
		TaxCode							Varchar(255),
		RelatedSalesInvoiceNumber		Varchar(240),
		InvoiceDueDate					SmallDateTime,
		DiscountedTotalAmount			Decimal(19,6),
		InvoiceType						Varchar(20),
		CorrectingInvoiceNumber			Varchar(20),
		DeferredTaxInvoiceNumber		Varchar(4000),
		DeferredTaxInvoiceDueDate		SmallDateTime,
		IsDeferred						char(1),
		RegulatoryText					Varchar(8000),
		EPAID							Varchar(255),
		DistributionChannel				Varchar(255),
		Division						Varchar(255),
		SalesOrg						Varchar(255),
		InvoiceTotalAmount				Float,
		TotalTax						Float,
		NetAmount						Float,
		CreationDate                    SmallDateTime,
		PaymentMethod					Varchar(100),
		InvoiceId						INT,
		MvtHdrId						INT,
		AcctDtlId						INT,
		TransactionType					Varchar(80)
		)

--	Grab all records from the CustomInvoiceInterface table where the SalesForceDataLakeStaged column is not 1
if (@c_OnlyShowSQL <> 'N')
	print N'Insert	
	#Stage ( 	Id,
				TagIdentifier, 
				MsgQID , 
				MotivaFEIN, 
				CompanyName, 
				MotivaARContactName, 
				ARContactEmail, 
				ARContactPhone, 
				BillToSoldToName, 
				BillToAddress, 
				BillToContact, 
				BillToSoldToNumber, 
				InvoiceNumber, 
				InvoiceDateTime,
				PaymentTerms, 
				DealNumber, 
				RemitTo, 
				ShipFromTerminalAddress, 
				ShipToNumber, 
				ShipToAddress, 
				CustomerCharges, 
				ProductNumber, 
				ProductName, 
				OriginTerminal, 
				TerminalCode, 
				StandardCarrier, 
				CarrierName,
				BOLNumber, 
				LoadDateTime, 
				MovementType, 
				NetVolume, 
				GrossVolume, 
				BillingBasisIndicator, 
				UOM, 
				PerGallonBillingRate, 
				TotalProductCost, 
				TaxName, 
				TaxCode, 
				RelatedSalesInvoiceNumber,
				InvoiceDueDate, 
				DiscountedTotalAmount,
				InvoiceType,
				CorrectingInvoiceNumber, 
				DeferredTaxInvoiceNumber, 
				DeferredTaxInvoiceDueDate, 
				IsDeferred, 
				RegulatoryText, 
				EPAID, 
				DistributionChannel, 
				Division, 
				SalesOrg, 
				InvoiceTotalAmount, 
				TotalTax,
				NetAmount,
				CreationDate,
				PaymentMethod,
				InvoiceId,
				MvtHdrId,
				AcctDtlId,
				TransactionType)
Select	CII.Id,
		case when (CII.InvoiceLevel != ''H'' and CAD.DlDtlPrvsnCostType = ''S'') then ''F'' else CII.InvoiceLevel end, 
		CII.MessageQueueID, 
		MotivaFEIN.GnrlCnfgMulti,	
		MotivaCompanyName.GnrlCnfgMulti, 
		ARContact.CntctFrstNme + ARContact.CntctLstNme,
		ARContact.CntctEMlAddrss, 
		ARContact.CntctVcePhne, 
		BillToBusAssoc.BANme, 
		CONCAT(SAPSoldToAddr.AddrssLne1,SPACE(1), SAPSoldToAddr.AddrssLne2, SPACE(1), SAPSoldToAddr.AddrssCty, SPACE(1), SAPSoldToAddr.AddrssStte, SPACE(1), SAPSoldToAddr.AddrssCntry, SPACE(1), SAPSoldToAddr.AddrssPstlCde),
		BTC.CntctFrstNme + BTC.CntctLstNme,	
		CADA.SAPSoldToCode, 
		CII.InvoiceNumber, 
		CII.InvoiceDate, 
		Term.TrmVrbge, 
		DH.DlHdrIntrnlNbr,	
		CONCAT(RemitTo.SlsInvceVrbgeLne1, SPACE(1), RemitTo.SlsInvceVrbgeLne2,SPACE(1), RemitTo.SlsInvceVrbgeLne3, SPACE(1), RemitTo.SlsInvceVrbgeLne4, SPACE(1), RemitTo.SlsInvceVrbgeLne5 ,SPACE(1), RemitTo.SlsInvceVrbgeLne6 ,SPACE(1), RemitTo.SlsInvceVrbgeLne7 ,SPACE(1), RemitTo.SlsInvceVrbgeLne8),
		CONCAT(SFTA1.GnrlCnfgMulti,SPACE(1), SFTCity.GnrlCnfgMulti,SPACE(1), SFTCode.GnrlCnfgMulti,SPACE(1), SFTSA.GnrlCnfgMulti),	
		CADA.SAPShipToCode,	
		CONCAT(ShipToAddress.ShipToAddress1, SPACE(1), ShipToAddress.ShipToCity, SPACE(1), ShipToAddress.ShipToState, SPACE(1), ShipToAddress.ShipToZip), 
		CAD.TrnsctnTypDesc, 
		SAPMC.GnrlCnfgMulti, 
		Product.PrdctNme, 
		CAD.MvtHdrOrigin, 
		CADA.SAPPlantCode, 
		CADA.ShipperSCAC, 
		Carrier.BANme, 
		case when (CII.BL = '''') then BillOfLading.MvtDcmntExtrnlDcmntNbr else CII.BL end,
		MH.MvtHdrDte, 
		MHT.Name, 
		ISNULL(AD.NetQuantity, 0.0), 
		ISNULL(AD.GrossQuantity, 0.0), 
		case when (CII.InvoiceLevel != ''H'') then 
			case when (abs(AD.Volume) = ISNULL(AD.NetQuantity, 0.0)) then ''Net'' else ''Gross'' end
		else '''' end,
		CII.UOM, 
		case when (TransactionDetail.XDtlPrUntVal is null) then CII.PerUnitPrice else TransactionDetail.XDtlPrUntVal end,
		case when (CII.AbsInvoiceValue = Abs(CII.LocalCreditValue)) then CII.LocalCreditValue
			 when (CII.AbsInvoiceValue = Abs(CII.LocalDebitValue)) then CII.LocalDebitValue end,
		TRS.InvoicingDescription, 
		TJC.GnrlCnfgMulti,
		(select stuff((select ''~ '' + RelatedInvoices.SlsInvceHdrNmbr from SalesInvoiceHeader SIH1
			Left Join SalesInvoiceHeaderRelation As RSIHR (NoLock) On
				SIH.SlsInvceHdrID = RSIHR.RltdSlsInvceHdrID
			Left Join SalesInvoiceHeader As RelatedInvoices  (NoLock) On
				RSIHR.SlsInvceHdrID = RelatedInvoices.SlsInvceHdrID
		where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID for xml path('')),1,1,'')),
		CII.DueDate,	
		CADA.DiscountAmount, 
		case when (SIH.DeferredInvoice = ''Y'' ) then ''Deferred''
			 when (SIH.SlsinvceHdrId = SIH.SlsInvceHdrPrntID) then ''Original'' 
			 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle < 0) then ''Cancellation'' 
			 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle > 0) then ''Rebill'' end,
		case when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID) then CIH.SlsInvceHdrNmbr else NULL end,
		(select stuff((
					select ''~'' + RDI.SlsInvceHdrNmbr
						from SalesInvoiceHeader SIH1
						Left Join SalesInvoiceHeaderRelation SIHR on 
							SIHR.SlsInvceHdrID = SIH1.SlsInvceHdrID
						Left Join SalesInvoiceHeader RDI On
							SIHR.RltdSlsInvceHdrID = RDI.SlsInvceHdrID and RDI.DeferredInvoice = ''Y'' 
						where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
							order by SIH1.SlsInvceHdrID
							for xml path('')),1,1,'')),
		case when (SIH.DeferredInvoice = ''Y'') then ISNULL(SIH.SlsInvceHdrDueDte, CII.DueDate) else convert(DATETIME, null) end, 
		SIH.DeferredInvoice, 
		(select stuff((
					select ''~ '' + SIA1.Mssge from SalesInvoiceHeader SIH1
							inner join SalesInvoiceAddendum SIA1 
							on SIH1.SlsInvceHdrID = SIA1.SlsInvceHdrID
							where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
							order by SIH1.SlsInvceHdrID
							for xml path('')),1,1,'')),
		EPANumber.GnrlCnfgMulti, 
		CADA.DistChannel, 
		Division.GnrlCnfgMulti, 
		CADA.SalesOrg, 
		SIH.SlsInvceHdrTtlVle,
		0,
		SIH.SlsInvceHdrTtlVle - CADA.DiscountAmount,
		getdate(),
		DLB.DynLstBxAbbv As PaymentMethod,
		CII.InvoiceId,
		CAD.MvtHdrID,
		CAD.AcctDtlID,
		CII.TransactionType
From	CustomInvoiceInterface CII with (NoLock)
		inner join #tempMessageQueueIds
				ON	CII.MessageQueueID = #tempMessageQueueIds.MessageQueueId
		Left Outer Join SalesInvoiceHeader SIH (NoLock) on CII.InvoiceID = SIH.SlsInvceHdrID
		Left Join GeneralConfiguration As MotivaFEIN (NoLock) On 
				MotivaFEIN.GnrlCnfgQlfr = ''FederalTaxID''
				And MotivaFEIN.GnrlCnfgTblNme = ''BusinessAssociate''
				And MotivaFEIN.GnrlCnfgHdrID = CII.IntBAID
		Left Join GeneralConfiguration As MotivaCompanyName (NoLock) On
				MotivaCompanyName.GnrlCnfgQlfr = ''InvoiceDisplayName''
				And MotivaCompanyName.GnrlCnfgTblNme = ''BusinessAssociate''
				And MotivaCompanyName.GnrlCnfgHdrID = CII.IntBAID
		Left Join DealHeader As DH (NoLock) On 
				DH.DlHdrIntrnlNbr = CASE ISNULL(CII.DealNumber,'''') WHEN '''' 
									THEN (select top 1 SIDtl.SlsInvceDtlDlHdrIntrnlNbr from SalesInvoiceDetail SIDtl where SIDtl.SlsInvceDtlSlsInvceHdrID = CII.InvoiceId) 
									ELSE CII.DealNumber END
		Left Outer Join Term with (NoLock) on 
				Term.TrmID = SIH.SlsInvceHdrTrmID
		Left Join DynamicListBox DLB (NoLock) on
						Term.TrmPymntMthd = DLB.DynLstBxTyp
						And DLB.DynLstBxQlfr = ''PayType''
		Left Join GeneralConfiguration As EPANumber (NoLock) On
				MotivaCompanyName.GnrlCnfgQlfr = ''ExtEPAOrgID''
				And MotivaCompanyName.GnrlCnfgTblNme = ''DealHeader''
				And MotivaCompanyName.GnrlCnfgHdrID = DH.DlHdrID
		Left Join StrategyHeader SH (NoLock) on
				SH.StrtgyID = (select top 1 StrtgyID from DealDetailStrategy DDS where DDS.DlHdrID = DH.DlHdrID)
		Left Join GeneralConfiguration As Division (NoLock) On
				Division.GnrlCnfgQlfr = ''Division''
				And Division.GnrlCnfgTblNme = ''StrategyHeader''
				And Division.GnrlCnfgHdrID = SH.StrtgyID
		Left Join BusinessAssociate As ARBusAssoc (NoLock) On 
				ARBusAssoc.BAID = CII.IntBAID
		Left Join Contact As ARContact (NoLock) On 
				ARContact.CntctID = ARBusAssoc.PrimaryContactID
		Left Join BusinessAssociate As BillToBusAssoc (NoLock) On 
				BillToBusAssoc.BAID = CII.ExtBAID
		Left Join Contact As BTC (NoLock) On 
				BTC.CntctID = BillToBusAssoc.PrimaryContactID
		Left Join CustomAccountDetail CAD (NoLock) On 
				CAD.InterfaceMessageID = CII.MessageQueueID and CAD.AcctDtlID = CII.AcctDtlID
		Left Join MovementHeader MH (NoLock) On	
				MH.MvtHdrID = CASE ISNULL(CAD.MvtHdrID ,'''') WHEN '''' 
									THEN (select top 1 MvtHdrID from MovementHeader where MvtHdrMvtDcmntID in 
									(select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId)) ELSE CAD.MvtHdrID END
		Left Join Address As SAPSoldToAddr (NoLock) On
				SAPSoldToAddr.AddrssOffceLcleID = (select top 1 CntctOffceLcleId from Contact where CntctBAID = CII.ExtBAID)
		Left Join SalesInvoiceVerbiage As RemitTo (NoLock) On 
				SIH.RemitSlsInvceVrbgeID = RemitTo.SlsInvceVrbgeID
		Left Join AccountDetail As AD (NoLock) On 
				AD.AcctDtlID = CII.AcctDtlID
		Left Join TransactionDetailLog (NoLock) On
				TransactionDetailLog.XDtlLgAcctDtlID = AD.AcctDtlId
		Left Join TransactionDetail (NoLock) On
				TransactionDetail.XdtlXHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
				and TransactionDetail.XdtlDlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
		Left Join CustomAccountDetailAttribute CADA (NoLock) On	
				CADA.CADID = CAD.ID
		Left Join Product (NoLock) On 
				Product.PrdctID = AD.ChildPrdctID
		Left Join BusinessAssociate Carrier (NoLock) On	
				Carrier.BAID = MH.MvtHdrCrrrBAID
		Left Join SalesInvoiceHeader CIH (NoLock) On 
				CIH.SlsInvceHdrID = SIH.SlsInvceHdrPrntID
		Left Join MovementHeaderType MHT (NoLock) On 
				MH.MvtHdrTyp = MHT.MvtHdrTyp
		Left Join TaxDetailLog (NoLock) On
				AD.AcctDtlSrceID = [TaxDetailLog].TxDtlLgID And AD.AcctDtlSrceTble = ''T''
		Left Join TaxDetail (NoLock) On
				TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
		Left Join TaxRuleSet TRS (NoLock) On 
				TRS.TxRleStID = TaxDetail.TxRleStID
		Left Join GeneralConfiguration As TJC (NoLock) On
				TJC.GnrlCnfgQlfr = ''TaxJursidictionCode''
				And TJC.GnrlCnfgTblNme = ''Locale''
				And TJC.GnrlCnfgHdrID = MH.MvtHdrLcleID
		Left Join MTVSAPSoldToShipTo As ShipToAddress (NoLock) On 
				ShipToAddress.ShipTo = CADA.SAPShipToCode
				and getdate() between ShipToAddress.FromDate and ShipToAddress.ToDate
		Left Join GeneralConfiguration As SFTA1 (NoLock) On
				SFTA1.GnrlCnfgQlfr = ''AddrLine1''
				And SFTA1.GnrlCnfgTblNme = ''Locale''
				And SFTA1.GnrlCnfgHdrID = MH.MvtHdrLcleID
		Left Join GeneralConfiguration As SFTCity (NoLock) On
				SFTCity.GnrlCnfgQlfr = ''CityName''
				And SFTCity.GnrlCnfgTblNme = ''Locale''
				And SFTCity.GnrlCnfgHdrID = MH.MvtHdrLcleID
		Left Join GeneralConfiguration As SFTCode (NoLock) On
				SFTCode.GnrlCnfgQlfr = ''PostalCode''
				And SFTCode.GnrlCnfgTblNme = ''Locale''
				And SFTCode.GnrlCnfgHdrID = MH.MvtHdrLcleID
		Left Join GeneralConfiguration As SFTSA (NoLock) On
				SFTSA.GnrlCnfgQlfr = ''StateAbbreviation''
				And SFTSA.GnrlCnfgTblNme = ''Locale''
				And SFTSA.GnrlCnfgHdrID = MH.MvtHdrLcleID
		Left Join GeneralConfiguration As SAPMC (NoLock) On
				SAPMC.GnrlCnfgQlfr = ''SAPMaterialCode''
				And SAPMC.GnrlCnfgTblNme = ''Product''
				And SAPMC.GnrlCnfgHdrID = Product.PrdctID'
else
		Insert #Stage (	Id,
						TagIdentifier, 
						MsgQID, 
						MotivaFEIN, 
						CompanyName, 
						MotivaARContactName, 
						ARContactEmail, 
						ARContactPhone, 
						BillToSoldToName, 
						BillToAddress, 
						BillToContact, 
						BillToSoldToNumber, 
						InvoiceNumber, 
						InvoiceDateTime,
						PaymentTerms, 
						DealNumber, 
						RemitTo, 
						ShipFromTerminalAddress, 
						ShipToNumber, 
						ShipToAddress, 
						CustomerCharges, 
						ProductNumber, 
						ProductName, 
						OriginTerminal, 
						TerminalCode, 
						StandardCarrier, 
						CarrierName,
						BOLNumber, 
						LoadDateTime, 
						MovementType, 
						NetVolume, 
						GrossVolume, 
						BillingBasisIndicator, 
						UOM, 
						PerGallonBillingRate, 
						TotalProductCost, 
						TaxName, 
						TaxCode, 
						RelatedSalesInvoiceNumber,
						InvoiceDueDate, 
						DiscountedTotalAmount,
						InvoiceType,
						CorrectingInvoiceNumber, 
						DeferredTaxInvoiceNumber, 
						DeferredTaxInvoiceDueDate, 
						IsDeferred, 
						RegulatoryText, 
						EPAID, 
						DistributionChannel, 
						Division, 
						SalesOrg, 
						InvoiceTotalAmount, 
						TotalTax,
						NetAmount,
						CreationDate,
						PaymentMethod,
						InvoiceId,
						MvtHdrId,
						AcctDtlId,
						TransactionType)
				Select	CII.Id,
						case when (CII.InvoiceLevel != 'H' and CAD.DlDtlPrvsnCostType = 'S') then 'F' else CII.InvoiceLevel end, 
						CII.MessageQueueID, 
						MotivaFEIN.GnrlCnfgMulti,	
						MotivaCompanyName.GnrlCnfgMulti, 
						ARContact.CntctFrstNme + ARContact.CntctLstNme,
						ARContact.CntctEMlAddrss, 
						ARContact.CntctVcePhne, 
						BillToBusAssoc.BANme, 
						CONCAT(SAPSoldToAddr.AddrssLne1,SPACE(1), SAPSoldToAddr.AddrssLne2, SPACE(1), SAPSoldToAddr.AddrssCty, SPACE(1), SAPSoldToAddr.AddrssStte, SPACE(1), SAPSoldToAddr.AddrssCntry, SPACE(1), SAPSoldToAddr.AddrssPstlCde),
						BTC.CntctFrstNme + BTC.CntctLstNme,	
						CADA.SAPSoldToCode, 
						CII.InvoiceNumber, 
						CII.InvoiceDate, 
						Term.TrmVrbge, 
						DH.DlHdrIntrnlNbr,	
						CONCAT(RemitTo.SlsInvceVrbgeLne1, SPACE(1), RemitTo.SlsInvceVrbgeLne2,SPACE(1), RemitTo.SlsInvceVrbgeLne3, SPACE(1), RemitTo.SlsInvceVrbgeLne4, SPACE(1), RemitTo.SlsInvceVrbgeLne5 ,SPACE(1), RemitTo.SlsInvceVrbgeLne6 ,SPACE(1), RemitTo.SlsInvceVrbgeLne7 ,SPACE(1), RemitTo.SlsInvceVrbgeLne8),
						CONCAT(SFTA1.GnrlCnfgMulti,SPACE(1), SFTCity.GnrlCnfgMulti,SPACE(1), SFTCode.GnrlCnfgMulti,SPACE(1), SFTSA.GnrlCnfgMulti),
						CADA.SAPShipToCode,
						CONCAT(ShipToAddress.ShipToAddress1, SPACE(1), ShipToAddress.ShipToCity, SPACE(1), ShipToAddress.ShipToState, SPACE(1), ShipToAddress.ShipToZip), 
						CAD.TrnsctnTypDesc, 
						SAPMC.GnrlCnfgMulti, 
						Product.PrdctNme, 
						CAD.MvtHdrOrigin, 
						CADA.SAPPlantCode, 
						CADA.ShipperSCAC, 
						Carrier.BANme, 
						case when (CII.BL = '') then BillOfLading.MvtDcmntExtrnlDcmntNbr else CII.BL end,
						MH.MvtHdrDte, 
						MHT.Name, 
						ISNULL(AD.NetQuantity, 0.0), 
						ISNULL(AD.GrossQuantity, 0.0),  
						case when (CII.InvoiceLevel != 'H') then 
							case when (abs(AD.Volume) = ISNULL(AD.NetQuantity, 0.0)) then 'Net' else 'Gross' end
						else '' end, 
						CII.UOM, 
						case when (TransactionDetail.XDtlPrUntVal is null) then CII.PerUnitPrice else TransactionDetail.XDtlPrUntVal end,
						case when (CII.AbsInvoiceValue = Abs(CII.LocalCreditValue)) then CII.LocalCreditValue
							 when (CII.AbsInvoiceValue = Abs(CII.LocalDebitValue)) then CII.LocalDebitValue end,
						TRS.InvoicingDescription, 
						TJC.GnrlCnfgMulti, 
						(select stuff((select '~ ' + RelatedInvoices.SlsInvceHdrNmbr from SalesInvoiceHeader SIH1
							Left Join SalesInvoiceHeaderRelation As RSIHR (NoLock) On
							SIH.SlsInvceHdrID = RSIHR.RltdSlsInvceHdrID
							Left Join SalesInvoiceHeader As RelatedInvoices  (NoLock) On
							RSIHR.SlsInvceHdrID = RelatedInvoices.SlsInvceHdrID
						where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID for xml path('')),1,1,'')),
						CII.DueDate,	
						CADA.DiscountAmount, 
						case when (SIH.DeferredInvoice = 'Y' ) then 'Deferred' 
							 when (SIH.SlsinvceHdrId = SIH.SlsInvceHdrPrntID) then 'Original' 
							 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle < 0) then 'Cancellation' 
							 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle > 0) then 'Rebill' end,
						case when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID) then CIH.SlsInvceHdrNmbr else NULL end,
						(select stuff((
							select '~' + RDI.SlsInvceHdrNmbr
								from SalesInvoiceHeader SIH1
								Left Join SalesInvoiceHeaderRelation SIHR on 
									SIHR.SlsInvceHdrID = SIH1.SlsInvceHdrID
								Left Join SalesInvoiceHeader RDI On
									SIHR.RltdSlsInvceHdrID = RDI.SlsInvceHdrID and RDI.DeferredInvoice = 'Y' 
								where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
									order by SIH1.SlsInvceHdrID
									for xml path('')),1,1,'')),
						case when (SIH.DeferredInvoice = 'Y') then ISNULL(SIH.SlsInvceHdrDueDte, CII.DueDate) else convert(DATETIME, null) end, 
						SIH.DeferredInvoice, 
						(select stuff((
							select '~ ' + SIA1.Mssge from SalesInvoiceHeader SIH1
								inner join SalesInvoiceAddendum SIA1 
									on SIH1.SlsInvceHdrID = SIA1.SlsInvceHdrID
								where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
									order by SIH1.SlsInvceHdrID
									for xml path('')),1,1,'')),	
						EPANumber.GnrlCnfgMulti, 
						CADA.DistChannel, 
						Division.GnrlCnfgMulti, 
						CADA.SalesOrg, 
						SIH.SlsInvceHdrTtlVle,
						0,
						SIH.SlsInvceHdrTtlVle - CADA.DiscountAmount,
						getdate(),
						DLB.DynLstBxAbbv As PaymentMethod,
						CII.InvoiceId,
						CAD.MvtHdrID,
						CAD.AcctDtlID,
						CII.TransactionType
				From	CustomInvoiceInterface CII with (NoLock)
				inner join #tempMessageQueueIds
				ON	CII.MessageQueueID = #tempMessageQueueIds.MessageQueueId
						Left Outer Join SalesInvoiceHeader SIH (NoLock) on	
								CII.InvoiceID = SIH.SlsInvceHdrID
						Left Join DealHeader As DH (NoLock) On 
								DH.DlHdrIntrnlNbr = CASE ISNULL(CII.DealNumber,'') WHEN '' 
									THEN (select top 1 SIDtl.SlsInvceDtlDlHdrIntrnlNbr from SalesInvoiceDetail SIDtl where SIDtl.SlsInvceDtlSlsInvceHdrID = CII.InvoiceId) 
									ELSE CII.DealNumber END
						Left Outer Join Term with (NoLock) on 
								Term.TrmID = SIH.SlsInvceHdrTrmID
						Left Join DynamicListBox DLB (NoLock) on
								Term.TrmPymntMthd = DLB.DynLstBxTyp
								And DLB.DynLstBxQlfr = 'PayType'
						Left Join StrategyHeader SH (NoLock) on
								SH.StrtgyID = (select top 1 StrtgyID from DealDetailStrategy DDS where DDS.DlHdrID = DH.DlHdrID)
						Left Join BusinessAssociate As ARBusAssoc (NoLock) On 
								ARBusAssoc.BAID = CII.IntBAID
						Left Join Contact As ARContact (NoLock) On 
								ARContact.CntctID = ARBusAssoc.PrimaryContactID
						Left Join BusinessAssociate As BillToBusAssoc (NoLock) On 
								BillToBusAssoc.BAID = CII.ExtBAID
						Left Join Contact As BTC (NoLock) On 
								BTC.CntctID = BillToBusAssoc.PrimaryContactID
						Left Join Address As SAPSoldToAddr (NoLock) On
								SAPSoldToAddr.AddrssOffceLcleID = (select top 1 CntctOffceLcleId from Contact where CntctBAID = CII.ExtBAID)
						Left Join SalesInvoiceVerbiage As RemitTo (NoLock) On 
								SIH.RemitSlsInvceVrbgeID = RemitTo.SlsInvceVrbgeID
						Left Join AccountDetail As AD (NoLock) On 
								AD.AcctDtlID = CII.AcctDtlID
						Left Join TransactionDetailLog (NoLock) On
								TransactionDetailLog.XDtlLgAcctDtlID = AD.AcctDtlId
						Left Join TransactionDetail (NoLock) On
								TransactionDetail.XdtlXHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
								and TransactionDetail.XdtlDlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
								and TransactionDetailLog.XDtlLgXDtlID = TransactionDetail. XDtlID
						Left Join CustomAccountDetail CAD (NoLock) On 
								CAD.InterfaceMessageID = CII.MessageQueueID and CAD.AcctDtlID = CII.AcctDtlID
						Left Join CustomAccountDetailAttribute CADA (NoLock) On	
								CADA.CADID = CAD.ID
						Left Join Product (NoLock) On 
								Product.PrdctID = AD.ChildPrdctID
						Left Join SalesInvoiceHeader CIH (NoLock) On 
								CIH.SlsInvceHdrID = SIH.SlsInvceHdrPrntID
						Left Join TaxDetailLog (NoLock) On
							AD.AcctDtlSrceID = [TaxDetailLog].TxDtlLgID And AD.AcctDtlSrceTble = 'T'
						Left Join TaxDetail (NoLock) On
							TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
						Left Join TaxRuleSet TRS (NoLock) On 
								TRS.TxRleStID = TaxDetail.TxRleStID
						Left Join MovementDocument As BillOfLading (NoLock) On
								BillOfLading.MvtDcmntID =  (select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId)
						Left Join GeneralConfiguration As MotivaFEIN (NoLock) On 
								MotivaFEIN.GnrlCnfgQlfr = 'FederalTaxID'
								And MotivaFEIN.GnrlCnfgTblNme = 'BusinessAssociate'
								And MotivaFEIN.GnrlCnfgHdrID = CII.IntBAID
						Left Join GeneralConfiguration As MotivaCompanyName (NoLock) On
								MotivaCompanyName.GnrlCnfgQlfr = 'InvoiceDisplayName'
								And MotivaCompanyName.GnrlCnfgTblNme = 'BusinessAssociate'
								And MotivaCompanyName.GnrlCnfgHdrID = CII.IntBAID
						Left Join GeneralConfiguration As EPANumber (NoLock) On
								EPANumber.GnrlCnfgQlfr = 'EPANumber'
								And EPANumber.GnrlCnfgTblNme = 'BusinessAssociate'
								And EPANumber.GnrlCnfgHdrID = CII.ExtBAID
						Left Join GeneralConfiguration As Division (NoLock) On
								Division.GnrlCnfgQlfr = 'Division'
								And Division.GnrlCnfgTblNme = 'StrategyHeader'
								And Division.GnrlCnfgHdrID = SH.StrtgyID
						Left Join MovementHeader MH (NoLock) On	
								MH.MvtHdrID = CAD.MvtHdrID --ISNULL(CAD.MvtHdrID, (select top 1 MvtHdrID from MovementHeader where MvtHdrMvtDcmntID in 
						--			(select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId))) /*CASE ISNULL(CAD.MvtHdrID ,'') WHEN '' 
									--THEN (select top 1 MvtHdrID from MovementHeader where MvtHdrMvtDcmntID in 
									--(select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId)) ELSE CAD.MvtHdrID END*/
						Left Join BusinessAssociate Carrier (NoLock) On	
								Carrier.BAID = MH.MvtHdrCrrrBAID
						Left Join MovementHeaderType MHT (NoLock) On 
								MH.MvtHdrTyp = MHT.MvtHdrTyp
						--Left Join GeneralConfiguration As SoldTo (NoLock) On
						--		SoldTo.GnrlCnfgQlfr = 'SAPMvtSoldToNumber'
						--		And SoldTo.GnrlCnfgTblNme = 'MovementHeader'
						--		And SoldTo.GnrlCnfgHdrID =	(select top 1 AcctDtlMvtHdrID from AccountDetail where AcctDtlMvtHdrID is not null and AcctDtlId in 
						--									(select SlsInvceDtlAcctDtlID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId))
						--		And SoldTo.GnrlCnfgMulti != 'X'
						--Left Join GeneralConfiguration As ShipTo (NoLock) On
						--		ShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo'
						--		And ShipTo.GnrlCnfgTblNme = 'MovementHeader'
						--		And ShipTo.GnrlCnfgHdrID = (select AcctDtlMvtHdrID from AccountDetail where AcctDtlId = CII.AcctDtlId)
						--		And ShipTo.GnrlCnfgMulti != 'X'
						Left Join MTVSAPSoldToShipTo As ShipToAddress (NoLock) On 
								ShipToAddress.ShipTo = CADA.SAPShipToCode
								and getdate() between ShipToAddress.FromDate and ShipToAddress.ToDate
						Left Join GeneralConfiguration As TJC (NoLock) On
								TJC.GnrlCnfgQlfr = 'TaxJursidictionCode'
								And TJC.GnrlCnfgTblNme = 'Locale'
								And TJC.GnrlCnfgHdrID = MH.MvtHdrLcleID
						Left Join GeneralConfiguration As SFTA1 (NoLock) On
								SFTA1.GnrlCnfgQlfr = 'AddrLine1'
								And SFTA1.GnrlCnfgTblNme = 'Locale'
								And SFTA1.GnrlCnfgHdrID = MH.MvtHdrLcleID
						Left Join GeneralConfiguration As SFTCity (NoLock) On
								SFTCity.GnrlCnfgQlfr = 'CityName'
								And SFTCity.GnrlCnfgTblNme = 'Locale'
								And SFTCity.GnrlCnfgHdrID = MH.MvtHdrLcleID
						Left Join GeneralConfiguration As SFTCode (NoLock) On
								SFTCode.GnrlCnfgQlfr = 'PostalCode'
								And SFTCode.GnrlCnfgTblNme = 'Locale'
								And SFTCode.GnrlCnfgHdrID = MH.MvtHdrLcleID
						Left Join GeneralConfiguration As SFTSA (NoLock) On
								SFTSA.GnrlCnfgQlfr = 'StateAbbreviation'
								And SFTSA.GnrlCnfgTblNme = 'Locale'
								And SFTSA.GnrlCnfgHdrID = MH.MvtHdrLcleID
						Left Join GeneralConfiguration As SAPMC (NoLock) On
								SAPMC.GnrlCnfgQlfr = 'SAPMaterialCode'
								And SAPMC.GnrlCnfgTblNme = 'Product'
								And SAPMC.GnrlCnfgHdrID = Product.PrdctID
						/*RLB - Removed due to Headers that have transactionstype of Discount when only reversal due to highestvalue flag on CAD*/
						--Where CII.TransactionType != 'Discount'



/*RLB - Added to remove any discounts due to logic above being commented out*/
DELETE FROM #Stage WHERE #Stage.TransactionType = 'Discount' and #Stage.TagIdentifier <> 'H'

--New Logic to fill in missing Header level stuff
UPDATE	#Stage
SET		LoadDateTime = MH.MvtHdrDte
		,CarrierName = Carrier.BANme
		,MovementType = MHT.Name
		,TaxCode = TJC.GnrlCnfgMulti 
		,ShipFromTerminalAddress = CONCAT(SFTA1.GnrlCnfgMulti,SPACE(1), SFTCity.GnrlCnfgMulti,SPACE(1), SFTCode.GnrlCnfgMulti,SPACE(1), SFTSA.GnrlCnfgMulti)
--select CONCAT(SFTA1.GnrlCnfgMulti,SPACE(1), SFTCity.GnrlCnfgMulti,SPACE(1), SFTCode.GnrlCnfgMulti,SPACE(1), SFTSA.GnrlCnfgMulti)
FROM	#Stage
INNER JOIN	MovementHeader MH (NoLock) 
ON	(SELECT top 1 MvtHdrID from MovementHeader where MvtHdrMvtDcmntID in 
							(select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = #Stage.InvoiceId)) =  MH.MvtHdrID
Left Join BusinessAssociate Carrier (NoLock) On	
	Carrier.BAID = MH.MvtHdrCrrrBAID
Left Join MovementHeaderType MHT (NoLock) On 
	MH.MvtHdrTyp = MHT.MvtHdrTyp
Left Join GeneralConfiguration As TJC (NoLock) On
	TJC.GnrlCnfgQlfr = 'TaxJursidictionCode'
	And TJC.GnrlCnfgTblNme = 'Locale'
	And TJC.GnrlCnfgHdrID = MH.MvtHdrLcleID
Left Join GeneralConfiguration As SFTA1 (NoLock) On
	SFTA1.GnrlCnfgQlfr = 'AddrLine1'
	And SFTA1.GnrlCnfgTblNme = 'Locale'
	And SFTA1.GnrlCnfgHdrID = MH.MvtHdrLcleID
Left Join GeneralConfiguration As SFTCity (NoLock) On
	SFTCity.GnrlCnfgQlfr = 'CityName'
	And SFTCity.GnrlCnfgTblNme = 'Locale'
	And SFTCity.GnrlCnfgHdrID = MH.MvtHdrLcleID
Left Join GeneralConfiguration As SFTCode (NoLock) On
	SFTCode.GnrlCnfgQlfr = 'PostalCode'
	And SFTCode.GnrlCnfgTblNme = 'Locale'
	And SFTCode.GnrlCnfgHdrID = MH.MvtHdrLcleID
Left Join GeneralConfiguration As SFTSA (NoLock) On
	SFTSA.GnrlCnfgQlfr = 'StateAbbreviation'
	And SFTSA.GnrlCnfgTblNme = 'Locale'
	And SFTSA.GnrlCnfgHdrID = MH.MvtHdrLcleID
WHERE	#Stage.MvtHdrId IS NULL

;WITH GetSoldToForHeader AS
(
   SELECT *,
         ROW_NUMBER() OVER (PARTITION BY MsgQID ORDER BY MsgQID DESC) AS rn
   FROM #Stage
   where	#Stage.BillToSoldToNumber IS NOT NULL
)

UPDATE	#Stage
SET		#Stage.BillToSoldToNumber = GetSoldToForHeader.BillToSoldToNumber
--SELECT *
FROM #Stage
INNER JOIN	GetSoldToForHeader
ON	#Stage.MsgQID = GetSoldToForHeader.MsgQID
AND	GetSoldToForHeader.rn = 1
WHERE	#Stage.BillToSoldToNumber IS NULL


Select	@vc_DynamicSQL = '
Insert	MTVRetailerInvoicePreStage (
		TagIdentifier,
		CIIMssgQID,
		MotivaFEIN,
		CompanyName,
		MotivaARContactName,
		ARContactEmail,
		ARContactPhone,
		BillToSoldToName,
		BillToAddress,
		BillToContact,
		BillToSoldToNumber,
		InvoiceNumber,
		InvoiceDateTime,
		PaymentTerms,
		DealNumber,
		RemitTo,
		ShipFromTerminalAddress,
		ShipToNumber,
		ShipToAddress,
		CustomerCharges,
		ProductNumber,
		ProductName,
		OriginTerminal,
		TerminalCode,
		StandardCarrier,
		CarrierName,
		BOLNumber,
		LoadDateTime,
		MovementType,
		NetVolume,
		GrossVolume,
		BillingBasisIndicator,
		UOM,
		PerGallonBillingRate,
		TotalProductCost,
		TaxName,
		TaxCode,
		RelatedInvoiceNumber,
		InvoiceDueDate,
		CashDiscountAmount,
		InvoiceType,
		CorrectingInvoiceNumber,
		DeferredTaxInvoiceNumber,
		DeferredTaxInvoiceDueDate,
		IsDeferred,
		RegulatoryText,
		EPAID,
		DistributionChannel,
		Division,
		SalesOrg,
		InvoiceTotalAmount,
		TotalTax,
		TransactionType,
		TaxRate,
		TaxableQuantity,
		TaxAmount,
		PaymentMethod,
		ReportingGroups,
		NexusMessageId,
		NetAmount,
		AcctDtlId,
		CreationDate)
   select ST.TagIdentifier
		, ST.MsgQID
		, ST.MotivaFEIN
		, ST.CompanyName
		, ST.MotivaARContactName
		, ST.ARContactEmail
		, ST.ARContactPhone
		, ST.BillToSoldToName
		, ST.BillToAddress
		, ST.BillToContact
		, ST.BillToSoldToNumber
		, ST.InvoiceNumber
		, ST.InvoiceDateTime
		, ST.PaymentTerms
		, ST.DealNumber
		, ST.RemitTo
		, ST.ShipFromTerminalAddress
		, ST.ShipToNumber
		, ST.ShipToAddress
		, ST.CustomerCharges
		, ST.ProductNumber
		, ST.ProductName
		, ST.OriginTerminal					
		, ST.TerminalCode					
		, ST.StandardCarrier					
		, ST.CarrierName						
		, ST.BOLNumber						
		, ST.LoadDateTime					
		, ST.MovementType					
		, ST.NetVolume						
		, ST.GrossVolume						
		, ST.BillingBasisIndicator
		, ST.UOM								
		, ST.PerGallonBillingRate			
		, ST.TotalProductCost
		, ST.TaxName
		, ST.TaxCode
		, ST.RelatedSalesInvoiceNumber						
		, ST.InvoiceDueDate					
		, ST.DiscountedTotalAmount	
		, ST.InvoiceType			
		, ST.CorrectingInvoiceNumber			
		, ST.DeferredTaxInvoiceNumber		
		, ST.DeferredTaxInvoiceDueDate		
		, ST.IsDeferred						
		, ST.RegulatoryText					
		, ST.EPAID							
		, ST.DistributionChannel				
		, ST.Division						
		, ST.SalesOrg						
		, ST.InvoiceTotalAmount				
		, ST.TotalTax
		, ST.CustomerCharges
		, 0
		, 0
		, 0
		, ST.PaymentMethod
		, 0
		, 0
		, ST.NetAmount
		, ST.AcctDtlId
		, ST.CreationDate
		from #Stage ST'

		if (@c_OnlyShowSQL <> 'N')
			print @vc_DynamicSQL
		else
			exec(@vc_DynamicSQL)

if (@c_OnlyShowSQL <> 'N')
	print @vc_DynamicSQL
else
	UPDATE t SET t.BillingBasisIndicator = 'Net' FROM MTVRetailerInvoicePreStage t
	INNER JOIN (
		SELECT DISTINCT InvoiceNumber FROM MTVRetailerInvoicePreStage t
		WHERE BillingBasisIndicator = 'Net'
	) i
	ON t.InvoiceNumber = i.InvoiceNumber
	AND t.BillingBasisIndicator IS NULL

	UPDATE t SET t.BillingBasisIndicator = 'Gross' FROM MTVRetailerInvoicePreStage t
	INNER JOIN (
		SELECT DISTINCT InvoiceNumber FROM MTVRetailerInvoicePreStage t
		WHERE BillingBasisIndicator = 'Gross'
	) i
	ON t.InvoiceNumber = i.InvoiceNumber
	AND t.BillingBasisIndicator IS NULL