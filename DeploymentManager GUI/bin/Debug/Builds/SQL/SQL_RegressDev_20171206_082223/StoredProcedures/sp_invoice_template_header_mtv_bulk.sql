/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_header_mtv WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_header_mtv_bulk]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_header_mtv_bulk.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_header_mtv_bulk]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_header_mtv_bulk] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_header_mtv_bulk >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON

GO

ALTER  Procedure [dbo].sp_invoice_template_header_mtv_bulk @i_slsinvcehdrid Int
As

--exec dbo.sp_invoice_template_header_mtv_bulk 5
--select * from salesinvoiceheader where slsinvcehdrid = 33 
--select * from contact where cntctlstnme like '%floyd%'
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	dbo.sp_invoice_template_header_mtv  285810         Copyright 1997,1998,1999,2000,2001 SolArc
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
--  10/15/2015  SK				Changed the FederalTaxID field to return an EPA number from the GeneralConfiguration table.
--  04/05/2016  SSK             Added the Movement type to returning dataset.
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @STL varchar(250)
Declare @STLBaid int
EXECUTE SP_get_Registry_Value 'MotivaSTLIntrnlBAName',@STL out

Select @STLBaid = ( Select BAID from businessassociate where baabbrvtn = @STL )

Select  top 1 Original. SlsInvceHdrID,
        Original. SlsInvceHdrNmbr 'InvoiceNumber', 
        Original. SlsInvceHdrBARltnBAID 'ExternalBAID',
        ExternalBA. BAAbbrvtn + ExternalBA. BaAbbrvtnExtended 'ExternalBAAbbrvtn', 
        ExternalBA.BANme + ExternalBA. BANmeExtended 'ExternalBA',
        Original. SlsInvceHdrBARltnRltn 'RelationShip',
        Original. SlsInvceHdrIntrnlBAID 'InternalBAID', 
        Case 
            When AltBANameAbbv. GnrlCnfgMulti is null then InternalBA. BAAbbrvtn + InternalBA. BaAbbrvtnExtended 
            Else AltBANameAbbv. GnrlCnfgMulti
        End 'InternalBAAbbrvtn', 
        Case 
            When AltBAName. GnrlCnfgMulti is null then InternalBA.BANme + InternalBA. BANmeExtended 
            Else AltBAName. GnrlCnfgMulti
        End 'InternalBA',
        Original. SlsInvceHdrDueDte 'DueDate',
        Original. SlsInvceHdrDscntDte 'DiscountDate', 
        Original. SlsInvceHdrDscntVle 'DiscountAmount',
        Original. SlsInvceHdrCmmnts ,
        Original. SlsInvceHdrPrntID,
        Case Original. SlsInvceHdrStpTble
           When 'S' Then SlsInvceStpARRfrnce
           When 'O' Then SlsInvceOvrrdeARRfrnce
        End 'ARRfrnce',
        Correcting. SlsInvceHdrNmbr 'CorrectingInvoice',
        GeneralConfiguration. GnrlCnfgMulti 'FederalTaxID',
        
	--SlsInvceTpePrntVrbge 'HeaderVerbiage', 
	Case 
		When Original.SlsInvceHdrTtlVle < 0 then 'Credit Memo'
		when PrepayInvoice.IsPrepay is not null then 'Prepay'
		when Original.deferredInvoice = 'Y' then 'Deferred Tax Invoice'
		Else 'Invoice'
	End 'HeaderVerbiage',
	Isnull(Original. SlsInvceHdrPstdDte,getdate()) 'PostedDate',
        Original. ExternalCntctID 'CntctID',
	ExternalContact.CntctFrstNme + ' ' + ExternalContact.CntctLstNme 'ContactName',
	case  rtrim(Phone. AddressLine1) when 'Contact Phone and Office Phone Unknown' then '' else Phone.AddressLine1 end 'ContactPhone',
	case rtrim(Fax. AddressLine1) when 'Contact Fax and Office Fax Unknown' then '' else Fax.AddressLine1 end 'ContactFax',
        Case Original. SlsInvceHdrStpTble
           When 'S' Then SlsInvceStpDfltDlvryMthd
           When 'O' Then SlsInvceOvrrdeDlvryMthd
	End 'DeliveryMethod',

        Case TrmPymntMthd
           When 'E' then 'See EFT Instructions Below'
           When 'W' then 'See Wire Instructions Below'
           Else Case SlsInvceVrbgeLne1 when null then '' else SlsInvceVrbgeLne1 + char(13) end + 
                Case SlsInvceVrbgeLne2 when null then '' else SlsInvceVrbgeLne2 + char(13) end +
                Case SlsInvceVrbgeLne3 when null then '' else SlsInvceVrbgeLne3 + char(13) end +
                Case SlsInvceVrbgeLne4 when null then '' else SlsInvceVrbgeLne4 + char(13) end +
                Case SlsInvceVrbgeLne5 when null then '' else SlsInvceVrbgeLne5 + char(13) end +
                Case SlsInvceVrbgeLne6 when null then '' else SlsInvceVrbgeLne6 + char(13) end + 
                Case SlsInvceVrbgeLne7 when null then '' else SlsInvceVrbgeLne7 + char(13) end + 
                Case SlsInvceVrbgeLne8 when null then '' else SlsInvceVrbgeLne8 end
	End 'RemitInstruction', 
	SalesInvoiceType.SlsInvceTpeID,
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
	DocumentType.DocumentName 'DocumentType',
	ExternalContact.CntctEMlAddrss Externalemail,
	case when isnull(Internal.CntctEMlAddrss,'') = '' then ProfileInternal.CntctEMLAddrss else Internal.CntctEMlAddrss end Internalemail,
	isnull(ProfileInternal.CntctFrstNme,Internal.CntctFrstNme) + ' ' + isnull(ProfileInternal.CntctLstNme,Internal.CntctLstNme) 'InternalContactName',
	SCACCode.GnrlCnfgMulti 'SCAC',
    isnull(Internal.CntctVcePhne,ProfileInternal.CntctVcePhne),
    isnull(Internal.CntctFxPhne,ProfileInternal.CntctFxPhne),
    CASE InternalBA.BAID when @STLBaid then ProfileInternal.CntctVcePhne else isnull(Internal.CntctVcePhne,ProfileInternal.CntctVcePhne) end,
    CASE InternalBA.BAID when @STLBaid then ProfileInternal.CntctFxPhne else isnull(Internal.CntctFxPhne,ProfileInternal.CntctFxPhne) end,
	soldtonumber  soldtonumber,
	substring(customerpo.gnrlcnfgmulti, 1,20) customerpo,
	inco incoterms,
	firstdealheader.dlhdrintrnlnbr,
	epa.gnrlcnfgmulti epanumber
	
	
From  dbo.SalesInvoiceHeader Original
      Inner Join dbo.SalesInvoiceHeader		Correcting	on (Original. SlsInvceHdrPrntID		= Correcting. SlsInvceHdrID)
      Inner Join dbo.BusinessAssociate		InternalBA	on (Original. SlsInvceHdrIntrnlBAID	= InternalBA. BAID)
      Inner Join dbo.BusinessAssociate		ExternalBA	on (Original. SlsInvceHdrBARltnBAID	= ExternalBA. BAID)
      Inner Join dbo.Term					on (Original.SlsInvceHdrTrmID = Term.TrmID)
      Inner Join dbo.SalesInvoiceType				on (Original. SlsInvceHdrSlsInvceTpeID = SalesInvoiceType.SlsInvceTpeID)
      left outer Join dbo.SalesInvoiceInternalBASetup		on (Original. SlsInvceHdrIntrnlBAID = SlsInvceIntrnlBAStpBAID)
      left outer join dbo.AccountingProfile on AccntngPrfleSlsInvceTpeID = Original.SlsInvceHdrSlsInvceTpeID 
                                             and  AccntngPrfleInvceTpe = 'S'
                                             and accountingProfile.InternalBAID = Original.SlsInvceHdrIntrnlBAID
      left outer join ( select top 1 SlsInvceDtlDlHdrIntrnlNbr as dlhdrintrnlnbr, sd2.slsinvcedtlslsinvcehdrid
                      from  salesinvoicedetail sd2 where sd2.slsinvcedtlslsinvcehdrid = @i_slsinvcehdrid
					  union
					  Select top 1 dh2.DlHdrIntrnlnbr , MnlSlsInvceDtlSlsInvceHdrID 
					   from ManualSalesInvoiceDetail inner join dealheader dh2 on dh2.dlhdrid = MnlSlsInvceDtlDlHdrID 
					   where MnlSlsInvceDtlSlsInvceHdrID = @i_SlsInvceHdrID 
                      ) firstdealheader on firstdealheader.slsinvcedtlslsinvcehdrid = original.slsinvcehdrid 
      left outer join ( select top 1 plnndmvtid orderid,  acctdtlslsinvcehdrid    ,  Dynlstbxdesc as inco, substring(MTVSapBASoldTo.soldto,1,10) soldtonumber
                            from accountdetail
                                 left outer join plannedtransfer on PlnndTrnsfrID = AcctDtlPlnndTrnsfrID
                                 left outer join plannedmovement on plnndmvtid = PlnndTrnsfrPlnndStPlnndMvtID
                                 left outer join dealdetail on dealdetail.dldtldlhdrid = AcctDtlDlDtlDlHdrID
                                                           and dealdetail.dldtlid = AcctDtlDlDtlID
                                 left outer join Dynamiclistbox on DynlstBxtyp  = dealdetail.DeliveryTermID
                                                              and Dynlstbxqlfr = 'DealDeliveryTerm'
                                 left outer join generalconfiguration soldtoba on soldtoba.gnrlcnfghdrid = AcctDtlDlDtlDlHdrID
                                                                              and soldtoba.gnrlcnfgtblnme = 'dealheader'
                                                                              and soldtoba.gnrlcnfgqlfr = 'SAPSoldTo'
                                 left outer join MTVSapBASoldTo on convert(varchar,MTVSapBASoldTo.ID) = Soldtoba.gnrlcnfgmulti
                            where acctdtlslsinvcehdrid = @i_slsinvcehdrid
                                          ) firstplannedmovement on firstplannedmovement.acctdtlslsinvcehdrid = @i_slsinvcehdrid
       left outer join generalconfiguration customerpo on customerpo.gnrlcnfghdrid = firstplannedmovement.orderid
                                                     and customerpo.gnrlcnfgtblnme = 'plannedmovement'
                                                     and customerpo.gnrlcnfgqlfr = 'CounterpartyPONumber'
      left outer join ( select slsinvcedtlslsinvcehdrid hdrid, 'Prepay' isprepay 
        from salesinvoicedetail 
         inner join accountdetail on acctdtlid = slsinvcedtlacctdtlid 
         inner join transactiontype on acctdtltrnsctntypid = trnsctntypid 
                                and TrnsctnTypDesc like '%prepay%'
        where slsinvcedtlslsinvcehdrid = @i_slsinvcehdrid )  PrepayInvoice on PrepayInvoice.hdrid = original.SlsInvceHdrID
      Left Outer Join dbo.DocumentType				on SalesInvoiceType.DcmntTypID = DocumentType.DcmntTypID
      Left Outer Join dbo.SalesInvoiceSetup			on  (Original. SlsInvceHdrStpID = SlsInvceStpID
								and  Original. SlsInvceHdrStpTble = 'S')
      Left Outer Join dbo.SalesInvoiceOverride			on  (Original. SlsInvceHdrStpID = SlsInvceOvrrdeID
			                                        and  Original. SlsInvceHdrStpTble = 'O')
      Left Outer Join dbo.MasterAgreementInvoiceSetup (NoLock) On (Original. SlsInvceHdrStpID = MasterAgreementInvoiceSetup.MasterAgreementID
								 and  Original. SlsInvceHdrStpTble = 'M')
      Left Outer Join dbo.GeneralConfiguration			on  (Original.SlsInvceHdrIntrnlBAID = GeneralConfiguration.GnrlCnfgHdrID
								and  GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
								and  GeneralConfiguration.GnrlCnfgQlfr = 'EPANumber'
								and  GeneralConfiguration.GnrlCnfgHdrID = 1 )
	  Left Outer Join dbo.GeneralConfiguration	as SCACCode	on (Original.SlsInvceHdrIntrnlBAID = GeneralConfiguration.GnrlCnfgHdrID
								and  SCACCode.GnrlCnfgTblNme = 'BusinessAssociate'
								and  SCACCode.GnrlCnfgQlfr = 'SCAC'
								and  SCACCode.GnrlCnfgHdrID = 1)
      Left Outer Join dbo.GeneralConfiguration as AltBAName	on  (Original.SlsInvceHdrIntrnlBAID = AltBAName. GnrlCnfgHdrID
	                                                       and  AltBAName. GnrlCnfgQlfr = 'InvoiceDisplayName')
      Left Outer Join dbo.GeneralConfiguration as AltBANameAbbv on  (Original.SlsInvceHdrIntrnlBAID = AltBANameAbbv. GnrlCnfgHdrID
                                                        and  AltBANameAbbv. GnrlCnfgQlfr = 'InvoiceDisplayAbbvNm')

      Left Outer Join dbo.Contact as Internal on ( Internal.CntctID = Original. InternalCntctID )
      
      left outer join dbo.Contact as ProfileInternal on ProfileInternal.CntctID = AccountingProfile.AccntngPrfleCntctID

      Left Outer Join dbo.Contact as ExternalContact on (  ExternalContact.CntctID = Original. ExternalCntctID )

      Left Outer Join dbo.SalesInvoiceVerbiage on (Original.RemitSlsInvceVrbgeID = SalesInvoiceVerbiage. SlsInvceVrbgeID)


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

      Left Outer Join v_AddressInformation as Fax	on (ExternalContact.CntctID = Fax.CntctID
							and  Fax. DeliveryMethod = 'F'
							and  Fax. Type is null) 

      Left Outer Join v_AddressInformation as Phone	on (ExternalContact.CntctID = Phone.CntctID
		                                        and  Phone. DeliveryMethod = 'H'
	      					        and  Phone. Type is null)
	  left outer join Office on Offcebaid = original.slsinvcehdrintrnlbaid
      left outer join generalconfiguration epa on epa.Gnrlcnfghdrid = original.slsinvcehdrintrnlbaid
                                                  and epa.gnrlcnfgtblnme = 'businessassociate'
                                                  and epa.Gnrlcnfgqlfr = 'epanumber'
Where Original. SlsInvceHdrID = @i_slsinvcehdrid

Option (MaxDOP 1)

go 

if OBJECT_ID('sp_invoice_template_header_mtv_bulk')is not null begin
   --print "<<< Procedure sp_invoice_template_header_mtv created >>>"
   grant execute on sp_invoice_template_header_mtv_bulk to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure sp_invoice_template_header_mtv_bulk failed >>>"


GO
