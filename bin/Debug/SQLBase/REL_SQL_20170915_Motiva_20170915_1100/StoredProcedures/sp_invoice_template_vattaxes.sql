/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_vattaxes WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_vattaxes]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_vattaxes.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_vattaxes]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_vattaxes] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_vattaxes >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter Procedure [dbo].[sp_invoice_template_vattaxes] @i_slsinvcehdrid int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_vattaxes  1000         Copyright 2003 SolArc
-- Overview:	Retrieve the internal and external BA license information and any applicable VAT tax messages
--		for a particular sales invoice
--		For each tax account detail, figure out which BA license info is applicable based upon the 
--		transaction date being between the BA license dates and the tax rule set license order
-- Arguments:	@i_slsinvcehdrid - The sales invoice for which we are retrieving VAT tax descriptions
-- SPs:
-- Temp Tables:
-- Created by:	Heather Donnelly
-- History:	08/22/2003 - First Created 29801
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
set Quoted_Identifier OFF

Create Table #VAT
(

	InternalBALicense 		varchar(300) null,
	ExternalBALicense 		varchar(300) null,
	VATTaxDescription 		varchar(400) null,
	CurrencyConversionDescription 	varchar(400) null
	
)

Declare @i_usd int, @i_salesinvoiceheader_currency int, @i_DefaultCurrency int
Declare	@dt_invoicedate datetime
Declare @vc_conversion_rate varchar(30)

----------------------------------------------------------------------------------------------------------------------
-- Get the currency ID for USD and the currency of the invoice
----------------------------------------------------------------------------------------------------------------------
-- Select 	@i_usd = PrdctID 
-- From 	Product (NoLock) 
-- Where 	PrdctNme like '%United States Dollars%'


Select 	@i_DefaultCurrency = Coalesce(BusinessAssociateCurrency.BACrrncyCrrncyID,dbo.GetConfigurationValue('DefaultCurrency'))
From	SalesInvoiceHeader (NoLock)
	Left Outer Join BusinessAssociateCurrency  (NoLock)
		on	BusinessAssociateCurrency.BACrrncyBAID	= 	SalesInvoiceHeader.SlsInvceHdrIntrnlBAID
		And	BusinessAssociateCurrency.BACrrncyDflt	= 	"Y"	
Where	SalesInvoiceHeader.SlsInvceHdrID = @i_slsinvcehdrid



Select 	@i_salesinvoiceheader_currency = SlsInvceHdrCrrncyID,
	@dt_invoicedate =  SlsInvceHdrCrtnDte
From 	SalesInvoiceHeader (NoLock) 
Where 	SlsInvceHdrID = @i_slsinvcehdrid

----------------------------------------------------------------------------------------------------------------------
-- If the invoice is not in USD, get the conversion rate
----------------------------------------------------------------------------------------------------------------------
If @i_salesinvoiceheader_currency = @i_DefaultCurrency
	BEGIN
		Select @vc_conversion_rate = ''
	END
Else
	BEGIN
		Select 	@vc_conversion_rate = rtrim(ltrim(convert(varchar(30),RawPrice.RPVle)))
		From	RawPriceHeader (NoLock)
			Inner Join RawPriceLocale (NoLock) 	on  RawPriceLocale.RPLcleRPHdrID 		= RPHdrID	
								and RawPriceLocale.RPLcleChmclParPrdctID 	= @i_salesinvoiceheader_currency
			
			Inner Join RawPriceDetail (NoLock)	on  RawPriceDetail.RPDtlRPLcleChmclParPrdctID 	= @i_DefaultCurrency
								and RawPriceDetail.RPDtlRPLcleRPHdrID 		= RawPriceLocale.RPLcleRPHdrID
								and RawPriceDetail.RPDtlQteFrmDte 		<= @dt_invoicedate
								and RawPriceDetail.RPDtlQteToDte 		>= @dt_invoicedate
								and RawPriceDetail.RPDtlCrrncyID 		= @i_salesinvoiceheader_currency
								and RawPriceDetail.RPDtlTpe 			= 'A' -- added TSB 06/02/04 for issue number 45139 
								and RawPriceDetail.RPDtlstts			= 'A' 			
			Inner Join RawPrice (NoLock)		on  RawPrice.RPRPDtlIdnty			= RawPriceDetail.Idnty
		Where 	RawPriceHeader.RPHdrID = (Select Min(RPH.RPHdrID) From RawPriceHeader RPH (NoLock) Where RPH.RPHdrTpe = 'C')
		
	END

----------------------------------------------------------------------------------------------------------------------
-- Return the applicable internal and external BA license numbers, VAT tax descriptions and convserion rate
----------------------------------------------------------------------------------------------------------------------
Insert  #VAT
	(
	InternalBALicense,
	ExternalBALicense,
	VATTaxDescription,
	CurrencyConversionDescription
	)
Select 	Distinct
	Case 
            	When AltBANameAbbv.GnrlCnfgMulti is null then InternalBA.BAAbbrvtn + IsNull(InternalBA.BaAbbrvtnExtended,'') + ' VAT Tax Number:  ' + IsNull(LicenseInternal.AnnualLicenseNumber,'')
		Else AltBANameAbbv.GnrlCnfgMulti + ' VAT Tax Number:  ' + IsNull(LicenseInternal.AnnualLicenseNumber,'')
        End 'InternalBALicense', 
	ExternalBA. BAAbbrvtn + IsNull(ExternalBA. BaAbbrvtnExtended,'') + ' VAT Tax Number:  ' + IsNull(LicenseExternal.AnnualLicenseNumber,'') 'ExternalBALicense',
        IsNull(SalesInvoiceDetail.SlsInvceDtlMvtDcmntExtrnlDcmnt,'') + ' ' + 
		IsNull(Convert(varchar(11),SalesInvoiceDetail.SlsInvceDtlMvtHdrDte), '') + '   ' + 
		IsNull(VATDescription.Description,'') 'VATTaxDescription',
	Case
		When SalesInvoiceHeader.SlsInvceHdrCrrncyID = @i_DefaultCurrency then ''
		Else 'Conversion rate between ' +  DefaultCrrncy.PrdctNme  + ' and ' + Product.PrdctNme + ' is ' + IsNull(@vc_conversion_rate, '') + ' on ' +  Convert(varchar(11),SalesInvoiceHeader.SlsInvceHdrCrtnDte)
	End 'CurrencyConversionDescription'	 					
From	SalesInvoiceHeader		(NoLock)
	Inner Join SalesInvoiceDetail 	(NoLock) on SalesInvoiceHeader.SlsInvceHdrID = SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID
	Inner Join AccountDetail 	(NoLock) on SalesInvoiceDetail.SlsInvceDtlAcctDtlID = AccountDetail.AcctDtlID
						and AccountDetail.AcctDtlSrceTble = 'T'
	Inner Join BusinessAssociate 	 InternalBA 	 (NoLock) on AccountDetail.InternalBAID = InternalBA.BAID
	Inner Join BusinessAssociate	 ExternalBA	 (NoLock) on AccountDetail.ExternalBAID = ExternalBA.BAID
	Inner Join Product		(NoLock) on SalesInvoiceHeader.SlsInvceHdrCrrncyID = Product.PrdctID
	Inner Join Product DefaultCrrncy (noLock) On DefaultCrrncy.PrdctID = @i_DefaultCurrency
	Inner Join MovementHeader 	(NoLock) on AccountDetail.AcctDtlMvtHdrID = MovementHeader.MvtHdrID
	Inner Join VATDescription	(NoLock) on MovementHeader.VATDscrptnID = VATDescription.VATDscrptnID
	Inner Join TaxDetailLog 	(NoLock) on AccountDetail.AcctDtlSrceID = TaxDetailLog.TxDtlLgID
	Inner Join TaxDetail 		(NoLock) on TaxDetailLog.TxDtlLgTxDtlID = TaxDetail.TxDtlID
	Inner Join TaxRuleSet 		(NoLock) on TaxDetail.TxRleStID = TaxRuleSet.TxRleStID	
						and TaxRuleSet.IsVATTax = 'Y'
	Left Outer Join TaxRuleSetLicense TRSLExternal	(NoLock) On 	TRSLExternal. TxRleStID = TaxRuleSet. TxRleStID
								And	TRSLExternal. EvaluationOrder = (
													Select 	Min(TaxRuleSetLicense. EvaluationOrder) 
													From 	BusinessAssociateLicense,
														TaxRuleSetLicense
													Where  	BusinessAssociateLicense. LcnseID 	=  TaxRuleSetLicense. LcnseID
													And 	BusinessAssociateLicense. BAID 		=  AccountDetail. ExternalBAID
													And 	TaxRuleSetLicense. TxRleStID 		=  TaxRuleSet. TxRleStID
													And	BusinessAssociateLicense. FromDate 	<= AccountDetail. AcctDtlTrnsctnDte
													And	BusinessAssociateLicense. ToDate 	>= AccountDetail. AcctDtlTrnsctnDte
													)
	Left Outer Join TaxRuleSetLicense TRSLInternal	(NoLock) On	TRSLInternal. TxRleStID = TaxRuleSet. TxRleStID
								And	TRSLInternal. EvaluationOrder = (
													Select 	Min(TaxRuleSetLicense. EvaluationOrder) 
													From 	BusinessAssociateLicense,
														TaxRuleSetLicense
													Where  	BusinessAssociateLicense. LcnseID 	=  TaxRuleSetLicense. LcnseID
													And 	BusinessAssociateLicense. BAID 		=  AccountDetail. InternalBAID
													And 	TaxRuleSetLicense. TxRleStID 		=  TaxRuleSet. TxRleStID
													And	BusinessAssociateLicense. FromDate 	<= AccountDetail. AcctDtlTrnsctnDte
													And	BusinessAssociateLicense. ToDate 	>= AccountDetail. AcctDtlTrnsctnDte
													)
	Left Outer Join BusinessAssociateLicense LicenseExternal (NoLock) on  	LicenseExternal. LcnseID = TRSLExternal. LcnseID
									 And	LicenseExternal. BAID = AccountDetail. ExternalBAID
									 And 	LicenseExternal. FromDate <= AccountDetail. AcctDtlTrnsctnDte
									 And	LicenseExternal. ToDate >= AccountDetail. AcctDtlTrnsctnDte
	Left Outer Join BusinessAssociateLicense LicenseInternal (NoLock) on  	LicenseInternal. LcnseID = TRSLInternal. LcnseID
									 And	LicenseInternal. BAID = AccountDetail. InternalBAID
									 And 	LicenseInternal. FromDate <= AccountDetail. AcctDtlTrnsctnDte
									 And	LicenseInternal. ToDate >= AccountDetail. AcctDtlTrnsctnDte
	Left Outer Join GeneralConfiguration  	 AltBANameAbbv 	 (NoLock) on AccountDetail.InternalBAID = AltBANameAbbv.GnrlCnfgHdrID
                                                        		 and AltBANameAbbv.GnrlCnfgQlfr = 'InvoiceDisplayAbbvNm'	
Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID = @i_slsinvcehdrid

Select	Convert(text,InternalBALicense),
	Convert(text,ExternalBALicense),
	Convert(text,VATTaxDescription),
	Convert(text,CurrencyConversionDescription)
From 	#VAT

Drop Table #VAT

GO

if OBJECT_ID('sp_invoice_template_vattaxes')is not null begin
   --print "<<< Procedure sp_invoice_template_vattaxes created >>>"
   grant execute on sp_invoice_template_vattaxes to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure sp_invoice_template_vattaxes failed >>>"

GO

