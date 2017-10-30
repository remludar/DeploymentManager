/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MPC_Statement_Detail_Mtv_TA WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MPC_Statement_Detail_Mtv_TA]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MPC_Statement_Detail_Mtv_TA.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_Detail_Mtv_TA]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MPC_Statement_Detail_Mtv_TA] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>'
	  END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--exec sp_invoice_template_header_mtv_ta 154362
ALTER Procedure [dbo].[sp_invoice_template_header_mtv_ta] @i_SlsInvceHdrID Int
As

Set NoCount ON

DECLARE @OpenAcctngPrd varchar(100)
DECLARE @i_AccntngPrdID int

SELECT @i_AccntngPrdID = StatementBalance.SttmntBlnceAccntngPrdID
, @OpenAcctngPrd = convert(varchar,datename(mm,AccountingPeriod.AccntngPrdBgnDte)) + ' ' + convert(varchar,datepart(yyyy,AccountingPeriod.AccntngPrdBgnDte))
FROM dbo.SalesInvoiceHeader (NoLock) 
Inner Join dbo.StatementBalance (NoLock)  
on SalesInvoiceHeader.SlsInvceHdrID   = StatementBalance.SttmntBlnceSlsInvceHdrID
Inner JOin AccountingPeriod on AccountingPeriod.AccntngPrdID = StatementBalance.SttmntBlnceAccntngPrdID
WHERE SalesInvoiceHeader.SlsInvceHdrID = @i_SlsInvceHdrID




Select  distinct Original.SlsInvceHdrID,
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
		Case 
	   When InternalInvoiceAddress. AddressLine1 is null then Case 	When Isnull(InternalMailingAddress. AddressLine1, '') = '' then ''
							             Else InternalMailingAddress. AddressLine1
								End + 
							        Case When Isnull(InternalMailingAddress. AddressLine2, '') = '' then ''
							             Else Char(13) + InternalMailingAddress. AddressLine2
								End + 
							        Case When Isnull(InternalMailingAddress. CityStateZip,'') = '' then ''
							             Else Char(13) + InternalMailingAddress. CityStateZip
								End + 
							        Case When Isnull(InternalMailingAddress. Country,'') = '' then ''
							             Else Char(13) + InternalMailingAddress. Country
								End
           Else Case 	When Isnull(InternalInvoiceAddress. AddressLine1,'') = '' then ''
		             Else InternalInvoiceAddress. AddressLine1
			End + 
		        Case When Isnull(InternalInvoiceAddress. AddressLine2,'') = '' then ''
		             Else Char(13) + InternalInvoiceAddress. AddressLine2
			End + 
		        Case When Isnull(InternalInvoiceAddress. CityStateZip,'') = '' then ''
		             Else Char(13) + InternalInvoiceAddress. CityStateZip
			End + 
		        Case When Isnull(InternalInvoiceAddress. Country, '') = '' then ''
		             Else Char(13) + InternalInvoiceAddress. Country
			End
	End 'InternalAddress',
        Original. SlsInvceHdrDueDte 'DueDate',
        Original. SlsInvceHdrDscntDte 'DiscountDate', 
        Original. SlsInvceHdrDscntVle 'DiscountAmount',
        Original. SlsInvceHdrCmmnts ,
        Original. SlsInvceHdrPrntID,
        Case Original. SlsInvceHdrStpTble
           When 'S' Then SalesInvoiceSetup.SlsInvceStpARRfrnce
           When 'O' Then SlsInvceOvrrdeARRfrnce
        End 'ARRfrnce',
        Correcting. SlsInvceHdrNmbr 'CorrectingInvoice',
        GeneralConfiguration. GnrlCnfgMulti 'FederalTaxID',
	SlsInvceTpePrntVrbge 'HeaderVerbiage', 
	Isnull(Original. SlsInvceHdrPstdDte,getdate()) 'PostedDate',
    ExternalContact.CntctID 'CntctID',
	ExternalContact.CntctFrstNme + ' ' + ExternalContact.CntctLstNme 'ContactName',
	Phone. AddressLine1 'ContactPhone',
	Fax. AddressLine1 'ContactFax',
        Case Original. SlsInvceHdrStpTble
           When 'S' Then SalesInvoiceSetup.SlsInvceStpDfltDlvryMthd
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
	Internal.CntctEMlAddrss Internalemail,
	Internal.CntctFrstNme + ' ' + Internal.CntctLstNme 'InternalContactName',
	@OpenAcctngPrd OpenAcctngPrd,
	Term.TrmVrbge,
	DealHeader.DlHdrIntrnlNbr,
	OriginLocale.LcleAbbrvtn + ISNULL(OriginLocale.LcleAbbrvtnExtension, '') 'OriginLocation'
From  dbo.SalesInvoiceHeader Original
      Inner Join StatementBalance(NoLock)  on StatementBalance.SttmntBlnceSlsInvceHdrID = Original.SlsInvceHdrID
      Inner Join dbo.SalesInvoiceHeader		Correcting	on (Original. SlsInvceHdrPrntID		= Correcting. SlsInvceHdrID)
      Inner Join dbo.BusinessAssociate		InternalBA	on (Original. SlsInvceHdrIntrnlBAID	= InternalBA. BAID)
      Inner Join dbo.BusinessAssociate		ExternalBA	on (Original. SlsInvceHdrBARltnBAID	= ExternalBA. BAID)
      Inner Join dbo.Term					on (Original.SlsInvceHdrTrmID = Term.TrmID)
      Inner Join dbo.SalesInvoiceType 			on (Original.SlsInvceHdrSlsInvceTpeID = SalesInvoiceType.SlsInvceTpeID)
      Inner Join dbo.SalesInvoiceInternalBASetup		on (Original. SlsInvceHdrIntrnlBAID = SlsInvceIntrnlBAStpBAID)
      Left Outer Join dbo.DocumentType				on SalesInvoiceType.DcmntTypID = DocumentType.DcmntTypID
      Left Outer Join dbo.SalesInvoiceSetup			on  (Original. SlsInvceHdrStpID = SlsInvceStpID
								and  Original. SlsInvceHdrStpTble = 'S')
      Left Outer Join dbo.SalesInvoiceOverride			on  (Original. SlsInvceHdrStpID = SlsInvceOvrrdeID
			                                        and  Original. SlsInvceHdrStpTble = 'O')
      Left Outer Join dbo.MasterAgreementInvoiceSetup (NoLock) On (Original. SlsInvceHdrStpID = MasterAgreementInvoiceSetup.MasterAgreementID
								 and  Original. SlsInvceHdrStpTble = 'M')
      Left Outer Join dbo.GeneralConfiguration			on  (Original.SlsInvceHdrIntrnlBAID = GeneralConfiguration.GnrlCnfgHdrID
								and  GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
								and  GeneralConfiguration.GnrlCnfgQlfr = 'FederalTaxID' )
      Left Outer Join dbo.GeneralConfiguration as AltBAName	on  (Original.SlsInvceHdrIntrnlBAID = AltBAName. GnrlCnfgHdrID
	                                                       and  AltBAName. GnrlCnfgQlfr = 'InvoiceDisplayName')
      Left Outer Join dbo.GeneralConfiguration as AltBANameAbbv on  (Original.SlsInvceHdrIntrnlBAID = AltBANameAbbv. GnrlCnfgHdrID
                                                        and  AltBANameAbbv. GnrlCnfgQlfr = 'InvoiceDisplayAbbvNm')
	  LEFT OUTER JOIN dbo.SalesInvoiceSetup sisi (NOLOCK) ON sisi.SlsInvceStpBARltnBAID = Original.SlsInvceHdrIntrnlBAID
      Left Outer Join dbo.Contact as Internal on ( Internal.CntctID = ISNULL(Original.InternalCntctID,sisi.SlsInvceStpDfltCntctID))
	  LEFT OUTER JOIN dbo.SalesInvoiceSetup sise (NOLOCK) ON sise.SlsInvceStpID = Original.SlsInvceHdrStpID AND Original.SlsInvceHdrStpTble = 'S'
      Left Outer Join dbo.Contact as ExternalContact on (ExternalContact.CntctID = ISNULL(Original.ExternalCntctID,sise.SlsInvceStpDfltCntctID))
      Left Outer Join dbo.SalesInvoiceVerbiage on (Original.RemitSlsInvceVrbgeID = SalesInvoiceVerbiage.SlsInvceVrbgeID)
      Left Outer Join v_AddressInformation as InvoiceAddress  on ExternalContact.CntctID		= InvoiceAddress.CntctID
							      and InvoiceAddress. DeliveryMethod	= 'P'
							        and  InvoiceAddress.Type = 'M'
      Left Outer Join v_AddressInformation as MailingAddress	on (ExternalContact.CntctID = MailingAddress.CntctID
							        and  MailingAddress. DeliveryMethod = 'P'
							        and  MailingAddress.Type = 'M') 
      Left Outer Join v_AddressInformation as Fax	on (ExternalContact.CntctID = Fax.CntctID
							and  Fax. DeliveryMethod = 'F'
							and  Fax. Type is null) 
      Left Outer Join v_AddressInformation as Phone	on (ExternalContact.CntctID = Phone.CntctID
		                                        and  Phone. DeliveryMethod = 'H'
						        and  Phone. Type is null) 
	  Left Outer Join v_AddressInformation as InternalInvoiceAddress	on (Internal.CntctID = InternalInvoiceAddress.CntctID
		                                      and InternalInvoiceAddress. DeliveryMethod	= 'P'
                					      and InternalInvoiceAddress. Type = (Select Case (Case Original. SlsInvceHdrStpTble
					        		  			 		  When 'S' Then SalesInvoiceSetup.SlsInvceStpDfltDlvryMthd
						          						  When 'O' Then SalesInvoiceSetup.SlsInvceStpDfltDlvryMthd
													  When 'M' Then MasterAgreementInvoiceSetup.InvoiceDeliveryMethod
								 					End)
												     When 'O' Then 'S'
												     Else 'I' 
												 End)) 
	   Left Outer Join v_AddressInformation as InternalMailingAddress	on (Internal.CntctID = InternalMailingAddress.CntctID
							        and  InternalMailingAddress.DeliveryMethod = 'P'
							        and  InternalMailingAddress.Type = 'M') 
		left outer join Locale OriginLocale on OriginLocale.LcleID = (select top(1) SlsInvDtl.SlsInvceDtlOrgnLcleID from SalesInvoiceDetail SlsInvDtl where SlsInvDtl.SlsInvceDtlSlsInvceHdrID = Original.SlsInvceHdrID)
		INNER JOIN dbo.DealHeader (NOLOCK) ON DealHeader.DlHdrID = (SELECT TOP 1 SttmntBlnceDlHdrID FROM dbo.StatementBalance (NOLOCK) WHERE SttmntBlnceSlsInvceHdrID = Original.SlsInvceHdrID)
Where Original. SlsInvceHdrID = @i_slsinvcehdrid


GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_Detail_Mtv_TA]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MPC_Statement_Detail_Mtv_TA.sql'
	PRINT '<<< ALTERED StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>'
END
 


GO


