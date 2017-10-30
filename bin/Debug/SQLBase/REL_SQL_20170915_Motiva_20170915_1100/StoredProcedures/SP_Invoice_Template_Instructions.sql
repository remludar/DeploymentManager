/*
*****************************************************************************************************
USE FIND AND REPLACE ON SP_Invoice_Template_Instructions WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[SP_Invoice_Template_Instructions]    Script Date: DATECREATED ******/
PRINT 'Start Script=SP_Invoice_Template_Instructions.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SP_Invoice_Template_Instructions]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SP_Invoice_Template_Instructions] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure SP_Invoice_Template_Instructions >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter Procedure [dbo].[SP_Invoice_Template_Instructions] @i_SlsInvceHdrID int
As
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
					Case When SlsInvceVrbgeLne1 is null or SlsInvceVrbgeLne1 = '' then '' else SlsInvceVrbgeLne1 + char(13) end + 
					Case When SlsInvceVrbgeLne2 is null or SlsInvceVrbgeLne2 = '' then '' else SlsInvceVrbgeLne2 + char(13) end + 
					Case When SlsInvceVrbgeLne3 is null or SlsInvceVrbgeLne3 = '' then '' else SlsInvceVrbgeLne3 + char(13) end + 
					Case When SlsInvceVrbgeLne4 is null or SlsInvceVrbgeLne4 = '' then '' else SlsInvceVrbgeLne4 + char(13) end + 
					Case When SlsInvceVrbgeLne5 is null or SlsInvceVrbgeLne5 = '' then '' else SlsInvceVrbgeLne5 + char(13) end + 
					Case When SlsInvceVrbgeLne6 is null or SlsInvceVrbgeLne6 = '' then '' else SlsInvceVrbgeLne6 + char(13) end + 
					Case When SlsInvceVrbgeLne7 is null or SlsInvceVrbgeLne7 = '' then '' else SlsInvceVrbgeLne7 + char(13) end + 
					Case When SlsInvceVrbgeLne8 is null or SlsInvceVrbgeLne8 = '' then '' else SlsInvceVrbgeLne8 end
				End
		Else ''
		End 'instructions'
        , Isnull(CONVERT(varchar(255), GnrlCmntTxt),'') 'Comments'
	, CntctFrstNme + ' ' + CntctLstNme 'InternalContactName'
	, CntctVcePhne 'InternalPhone'
	, Fax. AddressLine1 'InternalFax'
From	SalesInvoiceHeader
	Inner Join Term on (SlsInvceHdrTrmID = TrmID)
	Left Outer Join SalesInvoiceVerbiage on ( WireSlsInvceVrbgeID = SlsInvceVrbgeID)
	Left Outer Join GeneralConfiguration on (GnrlCnfgQlfr = 'AlwaysPrintWireInst' and GnrlCnfgTblNme = 'System')
        Left Outer Join GeneralComment on  (GnrlCmntQlfr = 'SalesInvoiceTypeComment' 
                                       and  GnrlCmntHdrID = SlsInvceHdrSlsInvceTpeID) --JLR SlsInvceHdrID)
	Left Outer Join Contact on (InternalCntctID = Contact.CntctID)
	Left Outer Join v_AddressInformation as Fax 	on (InternalCntctID = fax. CntctID
							and DeliveryMethod = 'F')
	Left Outer Join MasterAgreementInvoiceSetup	On MasterAgreementInvoiceSetup.MasterAgreementID	= SalesInvoiceHeader.SlsInvceHdrStpID
							And SalesInvoiceHeader.SlsInvceHdrStpTble		= 'M'
	
Where	SlsInvceHdrID = @i_SlsInvceHdrID




GO

if OBJECT_ID('SP_Invoice_Template_Instructions')is not null begin
   --print "<<< Procedure SP_Invoice_Template_Instructions created >>>"
   grant execute on SP_Invoice_Template_Instructions to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure SP_Invoice_Template_Instructions failed >>>"
