/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_header_mtv_rins WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_header_mtv_rins]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_header_mtv_rins.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_header_mtv_rins]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_header_mtv_rins] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_header_mtv_rins >>>'
	  END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER Procedure [dbo].[sp_invoice_template_header_mtv_rins] @i_slsinvcehdrid Int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	dbo.sp_invoice_template_header  285810         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	@i_slsinvcehdrid	Sales Invoice Header ID
-- SPs:
-- Temp Tables:
-- Created by:	Tracy Baird
-- History:	5/7/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
-- 	05/12/2003	HMD		33242	Add document type name so we can build the archive name
--						the same as it was previous to s1 doc gen archiving changes
--	02/25/2004	HMD		29614	Added table name in front of SalesInvoiceType.SlsInvceTpeID to fix ambiguity
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON




Select  
		Original.SlsInvceHdrID,
        Original. SlsInvceHdrNmbr 'InvoiceNumber', 
        ExternalBA. BAAbbrvtn + isnull(ExternalBA. BaAbbrvtnExtended,'') 'ExternalBAAbbrvtn', 
        ExternalBA.BANme + isnull(ExternalBA. BANmeExtended,'') 'ExternalBA',
        Case 
            When AltBANameAbbv. GnrlCnfgMulti is null then InternalBA. BAAbbrvtn + isnull(InternalBA. BaAbbrvtnExtended,'')
            Else AltBANameAbbv. GnrlCnfgMulti
        End 'InternalBAAbbrvtn', 
        Case 
            When AltBAName. GnrlCnfgMulti is null then InternalBA.BANme + isnull(InternalBA. BANmeExtended,'')
            Else AltBAName. GnrlCnfgMulti
        End 'InternalBA',
        Original. SlsInvceHdrCmmnts ,
		SlsInvceTpePrntVrbge 'HeaderVerbiage', 
   		Case 
		   When InvoiceAddress. AddressLine1 is null then Case 	When Isnull(MailingAddress. AddressLine1, '') = '' then ''
											 Else MailingAddress. AddressLine1
									End + 
										Case When Isnull(MailingAddress. AddressLine2, '') = '' then ''
											 Else Char(13) + MailingAddress. AddressLine2
									End + 
										Case When Isnull(MailingAddress. CityStateZip,'') = '' then ''
											 Else Char(13) + MailingAddress. CityStateZip
									End + 
										Case When Isnull(MailingAddress. Country,'') = '' then ''
											 Else Char(13) + MailingAddress. Country
									End
			   Else Case 	When Isnull(InvoiceAddress. AddressLine1,'') = '' then ''
						 Else InvoiceAddress. AddressLine1
				End + 
					Case When Isnull(InvoiceAddress. AddressLine2,'') = '' then ''
						 Else Char(13) + InvoiceAddress. AddressLine2
				End + 
					Case When Isnull(InvoiceAddress. CityStateZip,'') = '' then ''
						 Else Char(13) + InvoiceAddress. CityStateZip
				End + 
					Case When Isnull(InvoiceAddress. Country, '') = '' then ''
						 Else Char(13) + InvoiceAddress. Country
				End
		End 'ExternalAddress',
		Term.TrmVrbge,
		Original.SlsInvceHdrCrtnDte,
		SalesInvDtl.SlsInvceDtlTrnsctnQntty * dbo.GetUOMConversionFactorSQLAsValue(convert(int,GenCfgConvert.GnrlCnfgMulti), AD.AcctDtlUOMID, SalesInvDtl.SlsInvceDtlSpcfcGrvty, coalesce(TransactionHeader.Energy,prod.PrdctEnrgy)) as 'TotalQuantity',
		SalesInvDtl.SlsInvceDtlPrUntVle 'PerUnitValue',
		unit.UOMAbbv 'UOM',
		SalesInvDtl.SlsInvceDtlMvtHdrDte,
		prod.PrdctAbbv 'ProductAbbv',
		ddpr.RowText 'ProvisionText',
		Currency.PrdctAbbv 'CurrencyProductAbbv',
		FT.RuleDescription 'FormulaTabletRuleDesc',
		RPH.RPHdrAbbv 'RawPriceHeaderAbbv',
		PriceProduct.PrdctAbbv 'PriceingProductAbbv',
		PT.PrceTpeNme 'PriceTypeName'
From  dbo.SalesInvoiceHeader Original
      Left Outer Join dbo.BusinessAssociate		InternalBA	on (Original. SlsInvceHdrIntrnlBAID	= InternalBA. BAID)
      Left Outer Join dbo.BusinessAssociate		ExternalBA	on (Original. SlsInvceHdrBARltnBAID	= ExternalBA. BAID)
      Left Outer Join dbo.Term					on (Original.SlsInvceHdrTrmID = Term.TrmID)
      Left Outer Join dbo.SalesInvoiceType				on (Original. SlsInvceHdrSlsInvceTpeID = SalesInvoiceType.SlsInvceTpeID)
      Left Outer Join dbo.SalesInvoiceSetup			on  (Original. SlsInvceHdrStpID = SlsInvceStpID
								and  Original. SlsInvceHdrStpTble = 'S')
      Left Outer Join dbo.MasterAgreementInvoiceSetup (NoLock) On (Original. SlsInvceHdrStpID = MasterAgreementInvoiceSetup.MasterAgreementID
								 and  Original. SlsInvceHdrStpTble = 'M')
      Left Outer Join dbo.GeneralConfiguration as AltBAName	on  (Original.SlsInvceHdrIntrnlBAID = AltBAName. GnrlCnfgHdrID
	                                                       and  AltBAName. GnrlCnfgQlfr = 'InvoiceDisplayName')
      Left Outer Join dbo.GeneralConfiguration as AltBANameAbbv on  (Original.SlsInvceHdrIntrnlBAID = AltBANameAbbv. GnrlCnfgHdrID
                                                        and  AltBANameAbbv. GnrlCnfgQlfr = 'InvoiceDisplayAbbvNm')

	  Inner Join GeneralConfiguration	GenCfgConvert	On	GenCfgConvert.GnrlCnfgTblNme	= 'System'
							And	GenCfgConvert.GnrlCnfgQlfr = 'DBMSUOM'

      Left Outer Join dbo.Contact as Internal on ( Internal.CntctID = Original. InternalCntctID )

      Left Outer Join dbo.Contact as ExternalContact on (  ExternalContact.CntctID = Original. ExternalCntctID )

      Left Outer Join v_AddressInformation as InvoiceAddress  on (ExternalContact.CntctID		= InvoiceAddress.CntctID
							      and InvoiceAddress. DeliveryMethod	= 'P'
                					      and InvoiceAddress. Type = (Select Case (Case Original. SlsInvceHdrStpTble
					        		  			 		  When 'S' Then SlsInvceStpDfltDlvryMthd
						          						  When 'O' Then SlsInvceStpDfltDlvryMthd
													  When 'M' Then MasterAgreementInvoiceSetup.InvoiceDeliveryMethod
								 					End)
												     When 'O' Then 'S'
												     Else 'I' 
												 End)) 

      Left Outer Join v_AddressInformation as MailingAddress	on (ExternalContact.CntctID = MailingAddress.CntctID
							        and  MailingAddress. DeliveryMethod = 'P'
							        and  MailingAddress. Type = 'M') 

		left outer join SalesInvoiceDetail SalesInvDtl on Original.SlsInvceHdrID = SalesInvDtl.SlsInvceDtlSlsInvceHdrID --Fix here from SlsInvceDtlDlHdrID to SlsInvceDtlSlsInvceHdrID

		left outer join AccountDetail AD on AD.AcctDtlID = SalesInvDtl.SlsInvceDtlAcctDtlID

		Left Outer Join	TransactionDetailLog	(NoLock) On 	AD. AcctDtlSrceID 				= TransactionDetailLog. XDtlLgID
		Left Outer Join	TransactionDetail	(NoLock) On	TransactionDetail. XDtlXHdrID 				= TransactionDetailLog. XDtlLgXDtlXHdrID
								and	TransactionDetail. XDtlDlDtlPrvsnID 		= TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID
								and	TransactionDetail. XDtlID 			= TransactionDetailLog. XDtlLgXDtlID
		Left Outer Join	TransactionHeader	(NoLock) On	TransactionDetailLog. XDtlLgXDtlXHdrID			= TransactionHeader. XHdrID

		left outer join Product prod on prod.PrdctID = SalesInvDtl.SlsInvceDtlPrntPrdctID

		left outer join DealDetail dd on dd.DlDtlDlHdrID = ad.AcctDtlDlDtlDlHdrID
		    and dd.dldtlid = ad.AcctDtlDlDtlID

		left outer join DealDetailProvision ddp on ddp.DlDtlPrvsnDlDtlDlHdrID = dd.DlDtlDlHdrID and ddp.DlDtlPrvsnDlDtlID = dd.DlDtlID

		left outer join DealDetailProvisionRow ddpr on ddpr.DlDtlPrvsnID = ddp.DlDtlPrvsnID
		    and ddpr.DlDtlPRvsnRwTpe = 'F'

		left outer join UnitOfMeasure unit on unit.UOM = Original.SlsInvceHdrUOM

		left outer Join Product Currency On Original.SlsInvceHdrCrrncyID = Currency.PrdctID
	
		left outer join V_FormulaTablet FT on ddpr.DlDtlPrvsnRwID = FT.DlDtlPrvsnRwID

		left outer join RawPriceLocale RPL on FT.RwPrceLcleID = RPL.RwPrceLcleID

		left outer join Product PriceProduct on RPL.RPLcleChmclParPrdctID = PriceProduct.PrdctID

		left outer join RawPriceHeader RPH on RPL.RPLcleRPHdrID = RPH.RPHdrID
	
		left outer join Pricetype PT on FT.PrceTpeIdnty = PT.Idnty

Where Original. SlsInvceHdrID = @i_slsinvcehdrid
Option (MaxDOP 1)

GO


IF  OBJECT_ID(N'[dbo].[sp_invoice_template_header_mtv_rins]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_invoice_template_header_mtv_rins.sql'
	PRINT '<<< ALTERED StoredProcedure sp_invoice_template_header_mtv_rins >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_invoice_template_header_mtv_rins >>>'
END
 


GO


