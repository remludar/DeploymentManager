/*
*****************************************************************************************************
USE FIND AND REPLACE ON SP_Invoice_Template_Instructions WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[SP_Invoice_Template_Instructions_TA]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_Invoice_Template_Instructions_TA.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_Invoice_Template_Instructions_TA]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_Invoice_Template_Instructions_TA] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure SP_Invoice_Template_Instructions_TA >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter Procedure [dbo].SP_Invoice_Template_Instructions_TA @i_SlsInvceHdrID int
As
--SP_Invoice_Template_Instructions_ta 814
--select * from salesinvoiceheader where slsinvcehdrid = 814
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	SP_Invoice_Template_Instructions   298478        Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	Retrieves Electronic Instructions, Invoice Type Verbiage, and Internal contact Information
-- Created by:	Pat Newgent
-- History:	7/9/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	1/11/2008	Added Masteragreement join to get wire data
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Select  Case 
		When TrmPymntMthd in ('E', 'W') or Left(isnull(GnrlCnfgMulti,'n'),1) = 'y' then 
			Case 
				When MasterAgreementInvoiceSetup.MasterAgreementID is not null Then
					'Wire Transfer Information:' + char(13) + 
					MasterAgreementInvoiceSetup.WireTransferBank + char(13) +  
					MasterAgreementInvoiceSetup.WireTransferABA + char(13) +  
					MasterAgreementInvoiceSetup.WireTransferAccount + char(13) 
					
				Else		
					Case When wire.SlsInvceVrbgeLne1 is null or wire.SlsInvceVrbgeLne1 = '' then '' else wire.SlsInvceVrbgeLne1 + char(13) end + 
					Case When wire.SlsInvceVrbgeLne2 is null or wire.SlsInvceVrbgeLne2 = '' then '' else wire.SlsInvceVrbgeLne2 + char(13) end + 
					Case When wire.SlsInvceVrbgeLne3 is null or wire.SlsInvceVrbgeLne3 = '' then '' else wire.SlsInvceVrbgeLne3 + char(13) end + 
					Case When wire.SlsInvceVrbgeLne4 is null or wire.SlsInvceVrbgeLne4 = '' then '' else wire.SlsInvceVrbgeLne4 + char(13) end + 
					Case When wire.SlsInvceVrbgeLne5 is null or wire.SlsInvceVrbgeLne5 = '' then '' else wire.SlsInvceVrbgeLne5 + char(13) end + 
					Case When wire.SlsInvceVrbgeLne6 is null or wire.SlsInvceVrbgeLne6 = '' then '' else wire.SlsInvceVrbgeLne6 + char(13) end + 
					Case When wire.SlsInvceVrbgeLne7 is null or wire.SlsInvceVrbgeLne7 = '' then '' else wire.SlsInvceVrbgeLne7 + char(13) end + 
					Case When wire.SlsInvceVrbgeLne8 is null or wire.SlsInvceVrbgeLne8 = '' then '' else wire.SlsInvceVrbgeLne8 end
				End
		Else ''
		End 'Wire'
        , Isnull(CONVERT(varchar(255), GnrlCmntTxt),'') 'Comments'
--	, CntctFrstNme + ' ' + CntctLstNme 'InternalContactName'
    , case when isnull(contact.CntctEMlAddrss,'') = '' then ProfileInternal.CntctEMLAddrss else contact.CntctEMlAddrss end Internalemail    
    , office.OffceVcePhne 'InternalPhone'
	, office.OffceFxPhne 'InternalFax'
	, 
					Case When remit.SlsInvceVrbgeLne1 is null or remit.SlsInvceVrbgeLne1 = '' then '' else remit.SlsInvceVrbgeLne1 + char(13) end + 
					Case When remit.SlsInvceVrbgeLne2 is null or remit.SlsInvceVrbgeLne2 = '' then '' else remit.SlsInvceVrbgeLne2 + char(13) end + 
					Case When remit.SlsInvceVrbgeLne3 is null or remit.SlsInvceVrbgeLne3 = '' then '' else remit.SlsInvceVrbgeLne3 + char(13) end + 
					Case When remit.SlsInvceVrbgeLne4 is null or remit.SlsInvceVrbgeLne4 = '' then '' else remit.SlsInvceVrbgeLne4 + char(13) end + 
					Case When remit.SlsInvceVrbgeLne5 is null or remit.SlsInvceVrbgeLne5 = '' then '' else remit.SlsInvceVrbgeLne5 + char(13) end + 
					Case When remit.SlsInvceVrbgeLne6 is null or remit.SlsInvceVrbgeLne6 = '' then '' else remit.SlsInvceVrbgeLne6 + char(13) end + 
					Case When remit.SlsInvceVrbgeLne7 is null or remit.SlsInvceVrbgeLne7 = '' then '' else remit.SlsInvceVrbgeLne7 + char(13) end + 
					Case When remit.SlsInvceVrbgeLne8 is null or remit.SlsInvceVrbgeLne8 = '' then '' else remit.SlsInvceVrbgeLne8 end 'remit'
From	SalesInvoiceHeader
	Inner Join Term on (SlsInvceHdrTrmID = TrmID)
	Left Outer Join SalesInvoiceVerbiage wire on ( WireSlsInvceVrbgeID = wire.SlsInvceVrbgeID)
	Left Outer Join SalesInvoiceVerbiage remit on ( RemitSlsInvceVrbgeID = remit.SlsInvceVrbgeID)
	Left Outer Join GeneralConfiguration on (GnrlCnfgQlfr = 'AlwaysPrintWireInst' and GnrlCnfgTblNme = 'System')
        Left Outer Join GeneralComment on  (GnrlCmntQlfr = 'SalesInvoiceTypeComment' 
                                       and  GnrlCmntHdrID = SlsInvceHdrSlsInvceTpeID) --JLR SlsInvceHdrID)
	Left Outer Join Contact on (InternalCntctID = Contact.CntctID)
	Left Outer Join v_AddressInformation as Fax 	on (InternalCntctID = fax. CntctID
							and DeliveryMethod = 'F')
	Left Outer Join MasterAgreementInvoiceSetup	On MasterAgreementInvoiceSetup.MasterAgreementID	= SalesInvoiceHeader.SlsInvceHdrStpID
							And SalesInvoiceHeader.SlsInvceHdrStpTble		= 'M'
	
	  left outer join Office on Offcebaid = slsinvcehdrintrnlbaid
    left outer join dbo.AccountingProfile on AccntngPrfleSlsInvceTpeID = SlsInvceHdrSlsInvceTpeID and  AccntngPrfleInvceTpe = 'S'
    left outer join dbo.Contact as ProfileInternal on ProfileInternal.CntctID = AccountingProfile.AccntngPrfleCntctID
Where	SlsInvceHdrID = @i_SlsInvceHdrID





GO

if OBJECT_ID('SP_Invoice_Template_Instructions_TA')is not null begin
   --print "<<< Procedure SP_Invoice_Template_Instructions_fsm created >>>"
   grant execute on SP_Invoice_Template_Instructions_fsm to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure SP_Invoice_Template_Instructions_TA failed >>>"
