If OBJECT_ID('dbo.Custom_Interface_Payment_Inbound') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_Payment_Inbound
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_Payment_Inbound >>>'
End
Go

Create Procedure dbo.Custom_Interface_Payment_Inbound	 @vc_Source					varchar(2)	= Null
														,@vc_FileName				varchar(80)	= Null
														,@vc_PostingDate			varchar(25)	= Null 
														,@vc_LedgerAccount			varchar(80)	= Null
														,@vc_Assignment				varchar(25)	= Null
														,@vc_DocumentDate			varchar(25)	= Null
														,@vc_LocalCurrency			varchar(10)	= Null
														,@vc_LocalDebitAmount		varchar(20)	= Null
														,@vc_LocalCreditAmount		varchar(20)	= Null
														,@vc_CustomerNumber			varchar(25)	= Null
														,@vc_VendorNumber			varchar(25)	= Null
														,@vc_ExchangeRate			varchar(20)	= Null
														,@vc_DocumentCurrency		varchar(10)	= Null
														,@vc_DocumentDebitAmount	varchar(20)	= Null
														,@vc_DocumentCreditAmount	varchar(20)	= Null
														,@vc_CompanyCode			varchar(25)	= Null
														,@vc_PaymentMethod			varchar(10)	= Null
														,@vc_CheckNumber			varchar(50)	= Null
														,@vc_PaymentDate			varchar(25)	= Null
														,@vc_ReversePostingDate		varchar(25)	= Null
														,@vc_ReverseOriginalInvoice	varchar(25)	= Null
														,@vc_ExportDate				varchar(25)	= Null
														,@vc_DocumentNumber			varchar(20)	= Null
														,@vc_LineNumber				varchar(10)	= Null
														,@vc_FiscalYear				varchar(4)	= Null
														,@c_OnlyShowSQL				char(1) 	= 'N' 
As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_Payment_Inbound @i_ID = 6, @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
-- Overview:	
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Joshua Weber
-- History:		13/04/2013 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set ANSI_NULLS ON
Set ANSI_PADDING ON
Set ANSI_Warnings ON
Set Quoted_Identifier OFF
Set Concat_Null_Yields_Null ON

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	 @vc_Error				varchar(255)
		,@sdt_Date				smalldatetime
		,@i_ID					int
		,@i_ValidCount			int
		,@i_InvoiceID			int
		,@i_InterfaceInvoiceID	int
		,@d_PaymentAmount		decimal(17,6)
		,@sdt_PaymentDate		smalldatetime
		,@i_CurrencyID			int
		,@vc_PaymentStatus		varchar(2)	
		,@d_InvoiceTotal		decimal(19,6)

----------------------------------------------------------------------------------------------------------------------
-- Set the error checking variables
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_Date	= GetDate()	

----------------------------------------------------------------------------------------------------------------------------------
-- Validation check - make sure the file hasn't already been sent over   SAP Accounting Document number + Company Code + Fiscal Year.
----------------------------------------------------------------------------------------------------------------------------------
Select	@i_ValidCount	= Count(*)
From	CustomPaymentInterface	(NoLock)
Where	DocumentNumber		= LTrim(RTrim(@vc_DocumentNumber)) 
And		IntBACode			= LTrim(RTrim(@vc_CompanyCode))
And		FiscalYear			= LTrim(RTrim(@vc_FiscalYear))
And		InterfaceFileName	<> @vc_FileName	

----------------------------------------------------------------------------------------------------------------------
-- Block 10: Stage the interface table
----------------------------------------------------------------------------------------------------------------------
Begin Transaction InsertMessage

	----------------------------------------------------------------------------------------------------------------------
	-- Get the next key
	----------------------------------------------------------------------------------------------------------------------			
	Execute dbo.sp_getkey 'CustomPaymentInterface', @i_ID out

	----------------------------------------------------------------------------------------------------------------------
	-- If one could not be determined raise an error
	----------------------------------------------------------------------------------------------------------------------			
	If	@i_ID Is Null
		Begin
			Rollback Transaction InsertMessage			
			Select	@vc_Error			= 'The Payment Interface encountered an error generating a key for the CustomPaymentInterface table.' 
			Goto	NoError						
		End					 

	----------------------------------------------------------------------------------------------------------------------
	-- Stage the record into the CustomInboundMessage table  sp_columnlist CustomPaymentInterface
	----------------------------------------------------------------------------------------------------------------------	
	Insert	CustomPaymentInterface
			(ID
			,InterfaceFileName
			,InterfaceFileSource
			,DocumentPostingDate
			,PostingDate
			,LedgerAccount
			,Assignment
			,DocumentDate
			,LocalCurrency
			,LocalDebitValue
			,LocalCreditValue
			,ExtBAID
			,CustomerNumber
			,VendorNumber
			,FXConversionRate
			,DocumentCurrency
			,DocumentDebitValue
			,DocumentCreditValue
			,IntBAID
			,IntBACode
			,PaymentMethod
			,CheckNumber
			,DocumentPaymentDate
			,PaymentDate
			,ReversalPostingDate
			,ReversalOriginalInvoice
			,ExportDate
			,DocumentNumber
			,LineNumber
			,FiscalYear
			,InterfaceStatus
			,InterfaceMessage
			,InterfaceInvoiceID
			,CreationDate)	
	Select	 @i_ID										-- ID
			,@vc_FileName								-- InterfaceFileName
			,@vc_Source									-- InterfaceFileSource
			,LTrim(RTrim(@vc_PostingDate))				-- DocumentPostingDate
			,Null										-- PostingDate
			,LTrim(RTrim(@vc_LedgerAccount))			-- LedgerAccount
			,LTrim(RTrim(@vc_Assignment))				-- Assignment
			,LTrim(RTrim(@vc_DocumentDate))				-- DocumentDate
			,LTrim(RTrim(@vc_LocalCurrency))			-- LocalCurrency
			,LTrim(RTrim(@vc_LocalDebitAmount))			-- LocalDebitValue
			,LTrim(RTrim(@vc_LocalCreditAmount))		-- LocalCreditValue
			,Null										-- ExtBAID
			,LTrim(RTrim(@vc_CustomerNumber))			-- CustomerNumber
			,LTrim(RTrim(@vc_VendorNumber))				-- VendorNumber
			,LTrim(RTrim(@vc_ExchangeRate))				-- FXConversionRate
			,LTrim(RTrim(@vc_DocumentCurrency))			-- DocumentCurrency
			,LTrim(RTrim(@vc_DocumentDebitAmount))		-- DocumentDebitValue
			,LTrim(RTrim(@vc_DocumentCreditAmount))		-- DocumentCreditValue
			,Null										-- IntBAID
			,LTrim(RTrim(@vc_CompanyCode))				-- IntBACode
			,LTrim(RTrim(@vc_PaymentMethod))			-- PaymentMethod
			,LTrim(RTrim(@vc_CheckNumber))				-- CheckNumber
			,LTrim(RTrim(@vc_PaymentDate))				-- DocumentPaymentDate
			,Null										-- PaymentDate
			,LTrim(RTrim(@vc_ReversePostingDate))		-- ReversalPostingDate
			,LTrim(RTrim(@vc_ReverseOriginalInvoice))	-- ReversalOriginalInvoice
			,LTrim(RTrim(@vc_ExportDate))				-- ExportDate
			,LTrim(RTrim(@vc_DocumentNumber))			-- DocumentNumber
			,LTrim(RTrim(@vc_LineNumber))				-- LineNumber
			,LTrim(RTrim(@vc_FiscalYear))				-- FiscalYear
			,'R'										-- InterfaceStatus
			,''											-- InterfaceMessage
			,Null										-- InterfaceInvoiceID
			,@sdt_Date									-- CreationDate

	----------------------------------------------------------------------------------------------------------------------
	-- Check for Errors on the Insert
	----------------------------------------------------------------------------------------------------------------------
	If	@@error <> 0 
		Begin
			Rollback Transaction InsertMessage			
			Select	@vc_Error			= 'The Payment Interface encountered an error inserting a record into the CustomPaymentInterface table.' 
			Goto	NoError						
		End	
	
----------------------------------------------------------------------------------------------------------------------------------
-- Commit the Transaction
----------------------------------------------------------------------------------------------------------------------------------
Commit Transaction InsertMessage

----------------------------------------------------------------------------------------------------------------------------------
-- Format the PostingDate data type
----------------------------------------------------------------------------------------------------------------------------------
Begin Try													
	Update	CustomPaymentInterface
	Set		PostingDate	= convert(smalldatetime,DocumentPostingDate)
	Where	ID	= @i_ID											 														
End Try
Begin Catch
		Select	@vc_Error	= 'The Payment Interface encountered an error converting the PostingDate value. '
		
		Update	CustomPaymentInterface
		Set		InterfaceMessage	= InterfaceMessage + @vc_Error
		Where	ID	= @i_ID				
End Catch

----------------------------------------------------------------------------------------------------------------------------------
-- Set the ExtBAID value   
----------------------------------------------------------------------------------------------------------------------------------
Begin Try
	----------------------------------------------------------------------------------------------------------------------------------
	-- Check receivables
	----------------------------------------------------------------------------------------------------------------------------------
	If	@vc_Source	= 'CR'
		Begin
			If	IsNull(LTrim(RTrim(@vc_CustomerNumber)),'0')	<> '0'
				Begin
					Update	CustomPaymentInterface
					Set		ExtBAID	= GeneralConfiguration. GnrlCnfgHdrID
					From	CustomPaymentInterface				(NoLock)
							Inner Join	GeneralConfiguration	(NoLock)	On	CustomPaymentInterface. CustomerNumber	= GeneralConfiguration. GnrlCnfgMulti
																			And	GeneralConfiguration. GnrlCnfgTblNme	= 'BusinessAssociate'
																			And	GeneralConfiguration. GnrlCnfgQlfr		= 'SAPCustomerNumber'
																			And	GeneralConfiguration. GnrlCnfgHdrID		<> 0
					Where	CustomPaymentInterface. ID	= @i_ID																																																													
				End
		End
		
	----------------------------------------------------------------------------------------------------------------------------------
	-- Check payables
	----------------------------------------------------------------------------------------------------------------------------------		
	If	@vc_Source	= 'CD'
		Begin
			If	IsNull(LTrim(RTrim(@vc_VendorNumber)),'0')	<> '0'
				Begin
					Update	CustomPaymentInterface
					Set		ExtBAID	= GeneralConfiguration. GnrlCnfgHdrID
					From	CustomPaymentInterface				(NoLock)
							Inner Join	GeneralConfiguration	(NoLock)	On	CustomPaymentInterface. VendorNumber	= GeneralConfiguration. GnrlCnfgMulti
																			And	GeneralConfiguration. GnrlCnfgTblNme	= 'BusinessAssociate'
																			And	GeneralConfiguration. GnrlCnfgQlfr		= 'SAPVendorNumber'
																			And	GeneralConfiguration. GnrlCnfgHdrID		<> 0
					Where	CustomPaymentInterface. ID	= @i_ID																																																													
				End
		End		 																			
End Try
Begin Catch
		Select	@vc_Error	= 'The Payment Interface encountered an error setting the External BA ID. '
		
		Update	CustomPaymentInterface
		Set		InterfaceMessage	= InterfaceMessage + @vc_Error
		Where	ID	= @i_ID				
End Catch

----------------------------------------------------------------------------------------------------------------------------------
-- Format the PaymentDate data type
----------------------------------------------------------------------------------------------------------------------------------
Begin Try													
	Update	CustomPaymentInterface
	Set		PaymentDate	= convert(smalldatetime,DocumentPaymentDate)
	Where	ID	= @i_ID											 														
End Try
Begin Catch
		Select	@vc_Error	= 'The Payment Interface encountered an error converting the PaymentDate value. '
		
		Update	CustomPaymentInterface
		Set		 InterfaceStatus	= 'E'
				,InterfaceMessage	= InterfaceMessage + @vc_Error
		Where	ID	= @i_ID				
End Catch

----------------------------------------------------------------------------------------------------------------------------------
-- Set the InterfaceInvoiceID value   
----------------------------------------------------------------------------------------------------------------------------------
Begin Try
	If	IsNull(LTrim(RTrim(@vc_Assignment)),'')	<> ''
		Begin
			Update	CustomPaymentInterface
			Set		 InterfaceInvoiceID	= CustomInvoiceInterface. InterfaceInvoiceID 
					,IntBAID			= CustomInvoiceInterface. IntBAID
			From	CustomPaymentInterface				(NoLock)
					Inner Join	CustomInvoiceInterface	(NoLock)	On	CustomPaymentInterface. Assignment		= dbo.Custom_Format_SAP_Invoice_String(CustomInvoiceInterface. InterfaceInvoiceID)
																	And	CustomInvoiceInterface. InvoiceLevel	= 'H'
			Where	CustomPaymentInterface. ID	= @i_ID																																																													
		End	 																			
End Try
Begin Catch
		Select	@vc_Error	= 'The Payment Interface encountered an error setting the Invoice ID. '
		
		Update	CustomPaymentInterface
		Set		 InterfaceStatus	= 'E'
				,InterfaceMessage	= InterfaceMessage + @vc_Error
		Where	ID	= @i_ID				
End Catch

----------------------------------------------------------------------------------------------------------------------
-- Block 20: Validation Checks
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Make sure the file hasn't already been sent over   SAP Accounting Document number + Company Code + Fiscal Year.
----------------------------------------------------------------------------------------------------------------------------------
 If	IsNull(@i_ValidCount,0) > 0
	Begin
		Select	@vc_Error	= 'The Payment Interface has identifed this file as a duplicate (SAP Accounting Document number + Company Code + Fiscal Year). '
		
		Update	CustomPaymentInterface
		Set		 InterfaceStatus	= 'E'
				,InterfaceMessage	= InterfaceMessage + @vc_Error
		Where	ID	= @i_ID			
	End
	
----------------------------------------------------------------------------------------------------------------------------------
-- Make sure the invoice id exists
----------------------------------------------------------------------------------------------------------------------------------	
Update	CustomPaymentInterface
Set		 InterfaceStatus	= 'E'
		,InterfaceMessage	= InterfaceMessage + 'The Payment Interface cannot determine the Invoice ID for the Assignment Number. '
Where	ID	= @i_ID		
And		InterfaceInvoiceID		Is Null	
And		IsNull(Assignment,'')	<> ''

----------------------------------------------------------------------------------------------------------------------------------
-- Make sure the currency id exists
----------------------------------------------------------------------------------------------------------------------------------
If	Not Exists (Select 'X' From Currency (NoLock) Where CrrncySmbl = LTrim(RTrim(@vc_DocumentCurrency)))
	Begin
		Select	@vc_Error	= 'The Payment Interface cannot map the Document Currency to a Currency ID. '
		
		Update	CustomPaymentInterface
		Set		 InterfaceStatus	= 'E'
				,InterfaceMessage	= InterfaceMessage + @vc_Error
		Where	ID	= @i_ID			
	End

----------------------------------------------------------------------------------------------------------------------------------
-- Insert the payments 
----------------------------------------------------------------------------------------------------------------------------------
If	Exists (Select 'X' From CustomPaymentInterface (NoLock) Where InterfaceStatus = 'R' And ID	= @i_ID And IsNull(Assignment,'') <> '' And InterfaceInvoiceID Is Not Null)		
	Begin
	
		----------------------------------------------------------------------------------------------------------------------------------
		-- Set the values that apply to both invoice types
		----------------------------------------------------------------------------------------------------------------------------------		
		Select	@i_InterfaceInvoiceID	= InterfaceInvoiceID
				,@d_PaymentAmount		= (convert(decimal(17,6), DocumentDebitValue) + convert(decimal(17,6), DocumentCreditValue))
				,@sdt_PaymentDate		= PaymentDate				
				,@i_CurrencyID			= (Select CrrncyID From Currency (NoLock) Where CrrncySmbl = DocumentCurrency)
		From	CustomPaymentInterface	(NoLock)
		Where	ID	= @i_ID	
		
		----------------------------------------------------------------------------------------------------------------------------------
		-- Set RA's Invoice ID
		----------------------------------------------------------------------------------------------------------------------------------		
		Select	@i_InvoiceID	= InvoiceID
		From	CustomInvoiceInterface	(NoLock)
		Where	InterfaceInvoiceID	= @i_InterfaceInvoiceID
		And		InvoiceLevel		= 'H'
		
		----------------------------------------------------------------------------------------------------------------------------------
		-- Receivables
		----------------------------------------------------------------------------------------------------------------------------------	
		If	@vc_Source	= 'CR'
			Begin
			
				----------------------------------------------------------------------------------------------------------------------------------
				-- Set the invoice total
				----------------------------------------------------------------------------------------------------------------------------------				
				Select	@d_InvoiceTotal	= SlsInvceHdrTtlVle
				From	SalesInvoiceHeader	(NoLock)
				Where	SlsInvceHdrID	= @i_InvoiceID
				
				----------------------------------------------------------------------------------------------------------------------------------
				-- Compare the invoice value to the payment value to determine the payment status
				----------------------------------------------------------------------------------------------------------------------------------					
				If	(Select @d_InvoiceTotal - @d_PaymentAmount) = 0
					Select	@vc_PaymentStatus	= 'FP'
				Else
					Select	@vc_PaymentStatus	= 'PP'		
			
				----------------------------------------------------------------------------------------------------------------------------------
				-- Open a new transaction - if one insert fails we need to rollback both
				----------------------------------------------------------------------------------------------------------------------------------				
				Begin Transaction	PaymentInsert
		
					Insert	SalesInvoiceHeaderPayment	
							(SlsInvceHdrID
							,ExternalPaymentAmount
							,ExternalPaymentDate
							,ExternalPaymentStatus
							,CrrncyID
							,ModifiedDate)
					Select	@i_InvoiceID
							,@d_PaymentAmount
							,@sdt_PaymentDate
							,@vc_PaymentStatus
							,@i_CurrencyID
							,GetDate()
							
					If	@@error <> 0 
						Begin
							Rollback Transaction PaymentInsert
							
							Select	@vc_Error	= 'The Payment Interface encountered an error inserting a record into the SalesInvoiceHeaderPayment table.' 
							
							Update	CustomPaymentInterface
							Set		 InterfaceStatus	= 'E'
									,InterfaceMessage	= InterfaceMessage + @vc_Error
							Where	ID	= @i_ID	
												
							Goto	NoError	
						End								
		
					----------------------------------------------------------------------------------------------------------------------
					-- Update the sales invoice header status
					----------------------------------------------------------------------------------------------------------------------
					Update	SalesInvoiceHeader
					Set		SlsInvceHdrPd		= 'Y'
					Where	SlsInvceHdrID		= @i_InvoiceID						
															
					If	@@error <> 0 
						Begin
							Rollback Transaction PaymentInsert
							
							Select	@vc_Error	= 'The Payment Interface encountered an error updating the SalesInvoiceHeader table.' 	
							
							Update	CustomPaymentInterface
							Set		 InterfaceStatus	= 'E'
									,InterfaceMessage	= InterfaceMessage + @vc_Error
							Where	ID	= @i_ID	
											
							Goto	NoError	
						End
						
					----------------------------------------------------------------------------------------------------------------------
					-- Update the payment record status
					----------------------------------------------------------------------------------------------------------------------						
					Update	CustomPaymentInterface
					Set		InterfaceStatus	= 'C'
					Where	ID	= @i_ID	
					
					If	@@error <> 0 
						Begin
							Rollback Transaction PaymentInsert
							
							Select	@vc_Error	= 'The Payment Interface encountered an error updating the CustomPaymentInterface table.' 					
							
							Update	CustomPaymentInterface
							Set		 InterfaceStatus	= 'E'
									,InterfaceMessage	= InterfaceMessage + @vc_Error
							Where	ID	= @i_ID	
							
							Goto	NoError	
						End																
						
				----------------------------------------------------------------------------------------------------------------------
				-- Commit the transaction and return out
				----------------------------------------------------------------------------------------------------------------------	
				Commit Transaction PaymentInsert								
		
			End

		----------------------------------------------------------------------------------------------------------------------------------
		-- Payables
		----------------------------------------------------------------------------------------------------------------------------------	
		If	@vc_Source	= 'CD'
			Begin
			
				----------------------------------------------------------------------------------------------------------------------------------
				-- Set the invoice total
				----------------------------------------------------------------------------------------------------------------------------------				
				Select	@d_InvoiceTotal	= InvoiceAmount
				From	PayableHeader	(NoLock)
				Where	PybleHdrID		= @i_InvoiceID
				
				----------------------------------------------------------------------------------------------------------------------------------
				-- Compare the invoice value to the payment value to determine the payment status
				----------------------------------------------------------------------------------------------------------------------------------					
				If	(Select @d_InvoiceTotal - @d_PaymentAmount) = 0
					Select	@vc_PaymentStatus	= 'FP'
				Else
					Select	@vc_PaymentStatus	= 'PP'		
			
				----------------------------------------------------------------------------------------------------------------------------------
				-- Open a new transaction - if one insert fails we need to rollback both
				----------------------------------------------------------------------------------------------------------------------------------				
				Begin Transaction	PaymentInsert
		
					Insert	PayableHeaderPayment	
							(PybleHdrID
							,ExternalPaymentAmount
							,ExternalPaymentDate
							,ExternalPaymentStatus)
					Select	@i_InvoiceID
							,@d_PaymentAmount
							,@sdt_PaymentDate
							,@vc_PaymentStatus
							
					If	@@error <> 0 
						Begin
							Rollback Transaction PaymentInsert
							
							Select	@vc_Error	= 'The Payment Interface encountered an error inserting a record into the PayableHeaderPayment table.' 					
							
							Update	CustomPaymentInterface
							Set		 InterfaceStatus	= 'E'
									,InterfaceMessage	= InterfaceMessage + @vc_Error
							Where	ID	= @i_ID	
							
							Goto	NoError	
						End								
		
					----------------------------------------------------------------------------------------------------------------------
					-- Update the payable header status
					----------------------------------------------------------------------------------------------------------------------										
					Update	PayableHeader
					Set		Status			= 'P'
							,PaymentDate	= @sdt_PaymentDate	
					Where	PybleHdrID		= @i_InvoiceID						
															
					If	@@error <> 0 
						Begin
							Rollback Transaction PaymentInsert
							
							Select	@vc_Error	= 'The Payment Interface encountered an error updating the PayableHeader table.' 					
							
							Update	CustomPaymentInterface
							Set		 InterfaceStatus	= 'E'
									,InterfaceMessage	= InterfaceMessage + @vc_Error
							Where	ID	= @i_ID	
							
							Goto	NoError	
						End	
						
					----------------------------------------------------------------------------------------------------------------------
					-- Update the payment record status
					----------------------------------------------------------------------------------------------------------------------						
					Update	CustomPaymentInterface
					Set		InterfaceStatus	= 'C'
					Where	ID	= @i_ID	
					
					If	@@error <> 0 
						Begin
							Rollback Transaction PaymentInsert
							Select	@vc_Error	= 'The Payment Interface encountered an error updating the CustomPaymentInterface table.' 					
							Goto	NoError	
						End							
						
				----------------------------------------------------------------------------------------------------------------------
				-- Commit the transaction and return out
				----------------------------------------------------------------------------------------------------------------------	
				Commit Transaction PaymentInsert				
				
			End
	End

----------------------------------------------------------------------------------------------------------------------
-- Return out
----------------------------------------------------------------------------------------------------------------------
NoError:
	Return	

----------------------------------------------------------------------------------------------------------------------
-- Error Handler:
----------------------------------------------------------------------------------------------------------------------
Error:  
	Raiserror (60010,-1,-1, @vc_Error	)


GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_Payment_Inbound') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_Payment_Inbound >>>'
	Grant Execute on dbo.Custom_Interface_Payment_Inbound to SYSUSER
	Grant Execute on dbo.Custom_Interface_Payment_Inbound to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_Payment_Inbound >>>'
GO

 