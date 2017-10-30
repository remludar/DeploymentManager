/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_header_mtv_fsm WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_header_mtv_fsm]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_header_mtv_fsm.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_header_mtv_fsm]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_header_mtv_fsm] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_header_mtv_fsm >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER  Procedure [dbo].sp_invoice_template_header_mtv_fsm @i_slsinvcehdrid Int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	dbo.sp_invoice_template_header_mtv_fsm  285810         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	@i_slsinvcehdrid	Sales Invoice Header ID
-- SPs:
-- Temp Tables:
-- Created by:	
-- History:	
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON


Select  Original. SlsInvceHdrID,
        Original. SlsInvceHdrNmbr 'InvoiceNumber',  --used
        
        
        Original. SlsInvceHdrBARltnBAID 'ExternalBAID',
        ExternalBA. BAAbbrvtn + ExternalBA. BaAbbrvtnExtended 'ExternalBAAbbrvtn', 
        ExternalBA.BANme + ExternalBA. BANmeExtended 'ExternalBA', --used
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
		when Original.deferredInvoice = 'Y' then 'Deferred Tax Invoice'
		Else 'Invoice'
	End 'HeaderVerbiage',
	Isnull(Original. SlsInvceHdrPstdDte,getdate()) 'PostedDate',
        Original. ExternalCntctID 'CntctID',
	ExternalContact.CntctFrstNme + ' ' + ExternalContact.CntctLstNme 'ContactName',
	Phone. AddressLine1 'ContactPhone',
	Fax. AddressLine1 'ContactFax',
        Case Original. SlsInvceHdrStpTble
           When 'S' Then SlsInvceStpDfltDlvryMthd
           When 'O' Then SlsInvceOvrrdeDlvryMthd
	End 'DeliveryMethod',

        '' 'RemitInstruction', 
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
	End 'ExternalAddress',  --used
	DocumentType.DocumentName 'DocumentType',
	ExternalContact.CntctEMlAddrss Externalemail,
	Internal.CntctEMlAddrss Internalemail,
	Internal.CntctFrstNme + ' ' + Internal.CntctLstNme 'InternalContactName',
	SCACCode.GnrlCnfgMulti 'SCAC',
	MovementHeaderType.Name 'MovementType',
	'1-866-HI-SHELL(1-888-447-4355)' 'InternalPhone',  -- used  need to find where this is stored in gui
	'713-423-0577' 'InternalFax',  --used  need to find where this is stored in gui
	 MTVSAPBASoldTo.SoldTO,  --used
	 DealHeader.DlHdrIntrnlnbr  --used
From  dbo.SalesInvoiceHeader Original
      Inner Join dbo.SalesInvoiceHeader		Correcting	on (Original. SlsInvceHdrPrntID		= Correcting. SlsInvceHdrID)
      Inner Join dbo.BusinessAssociate		InternalBA	on (Original. SlsInvceHdrIntrnlBAID	= InternalBA. BAID)
      Inner Join dbo.BusinessAssociate		ExternalBA	on (Original. SlsInvceHdrBARltnBAID	= ExternalBA. BAID)
      Inner Join dbo.Term					on (Original.SlsInvceHdrTrmID = Term.TrmID)
      Inner Join dbo.SalesInvoiceType				on (Original. SlsInvceHdrSlsInvceTpeID = SalesInvoiceType.SlsInvceTpeID)
      Inner Join dbo.SalesInvoiceInternalBASetup		on (Original. SlsInvceHdrIntrnlBAID = SlsInvceIntrnlBAStpBAID)
	  Inner Join dbo.DealHeader                         on DealHeader.DlHDrID = (Select top 1 Sd.SlsInvceDtlDlHdrID from SalesInvoiceDetail sd where sd.SlsInvceDtlSlsInvceHdrID = Original.SlsInvceHdrID )
      Left Outer Join dbo.GeneralConfiguration Soldto on SoldTo.GnrlcnfgHdrID = DealHeader.DlHdrID
	                                                 and SoldTo.GnrlcnfgQlfr = 'SapSoldTo'
													 and SoldTo.GnrlcnfgTblNme = 'DealHeader'
	  left outer join dbo.MTVSAPBASoldTo              on convert(varchar,MTVSAPBASoldTo.ID) = SoldTo.GnrlCnfgMulti
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
	  LEFT OUTER JOIN dbo.MovementHeaderType
				ON MovementHeaderType.MvtHdrTyp = (
					SELECT TOP 1 mht.MvtHdrTyp
					FROM dbo.AccountDetail ad
					INNER JOIN  dbo.MovementHeader mh
					On mh.MvtHdrID = ad.AcctDtlMvtHdrID
					inner Join dbo.MovementHeaderType mht
						On mh.MvtHdrTyp = mht.MvtHdrTyp
					WHERE ad.AcctDtlSlsInvceHdrID = @i_slsinvcehdrid
				)
      
Where Original. SlsInvceHdrID = @i_slsinvcehdrid
Option (MaxDOP 1)

go 

if OBJECT_ID('sp_invoice_template_header_mtv_fsm')is not null begin
   --print "<<< Procedure sp_invoice_template_header_mtv_fsm created >>>"
   grant execute on sp_invoice_template_header_mtv_fsm to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure sp_invoice_template_header_mtv_fsm failed >>>"


GO
