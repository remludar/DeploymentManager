If OBJECT_ID('dbo.Custom_Interface_AR_Outbound') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_AR_Outbound
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_AR_Outbound >>>'
End
Go

Create Procedure dbo.Custom_Interface_AR_Outbound	 @i_ID				int			= NULL
													,@b_Reprocess		bit			= 0
													,@c_OnlyShowSQL  	char(1) 	= 'N' 

As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_AR_Outbound @i_ID = 181, @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
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
Declare	 @vc_DynamicSQL			varchar(8000)
		,@vc_Error				varchar(255)
		,@b_HasErrored			bit
		,@sdt_Date				smalldatetime
		,@b_ValidMessage		bit
		,@i_SlsInvceHdrID		int
		,@i_InvoiceID			int
		,@d_InvoicAmount		decimal(19,6)	
		,@i_InternalBAID		int
		,@i_LineID				int	
		,@i_Counter				int	

----------------------------------------------------------------------------------------------------------------------
-- Block 10: Message Validation
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL	= 'N'
	Begin	
		----------------------------------------------------------------------------------------------------------------------
		-- If the Message ID is null set its value to 0
		----------------------------------------------------------------------------------------------------------------------
		If	IsNull(@i_ID,0)	= 0
			Select	@i_ID	= 0

		----------------------------------------------------------------------------------------------------------------------
		-- Validate that the Message ID is valid
		----------------------------------------------------------------------------------------------------------------------
		Select	@b_ValidMessage	= dbo.Custom_Validate_Message(@i_ID,'SH')	

		----------------------------------------------------------------------------------------------------------------------
		-- If the Message ID is not valid return out
		----------------------------------------------------------------------------------------------------------------------
		If	@b_ValidMessage = 0
			Begin
				Select	@vc_Error	= 'The Invoice Interface cannot process Message ID: ' + convert(varchar,@i_ID) + '. '
				
				Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																	,@b_RAProcessed	= 1
																	,@b_HasErrored	= 1	
																	,@vc_Error		= @vc_Error			
				Goto	NoError	
			End
	End		

----------------------------------------------------------------------------------------------------------------------
-- Set the variables from CustomMessageQueue
----------------------------------------------------------------------------------------------------------------------		
Select	@i_SlsInvceHdrID	= EntityID	
		, @i_InvoiceID		= EntityID2
From	CustomMessageQueue	(NoLock)	
Where	ID	= @i_ID	

----------------------------------------------------------------------------------------------------------------------
-- If we are reprocessing an invoice fire the management proc
----------------------------------------------------------------------------------------------------------------------		
If	@c_OnlyShowSQL	= 'N' 
	Begin
		If	IsNull(@b_Reprocess,0) = 1
			Begin
				Begin Try													
						Execute dbo.Custom_Interface_Manage_Reprocess_Message	@i_ID				= @i_SlsInvceHdrID
																				,@i_MessageID		= @i_ID
																				,@vc_Source			= 'SH'	
																				,@b_HasErrored		= @b_HasErrored	Output
																				,@vc_Error			= @vc_Error		Output												 														
				End Try
				Begin Catch
						Select	@vc_Error	= 'The Invoice Interface encountered an error executing Custom_Interface_Manage_Reprocess_Message: ' + ERROR_MESSAGE()	
						
						If	@c_OnlyShowSQL	= 'N'
							Begin
								Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																					,@b_RAProcessed	= 1
																					,@b_HasErrored	= 1	
																					,@vc_Error		= @vc_Error	
																				
								Goto	NoError
							End						
				End Catch
				
				----------------------------------------------------------------------------------------------------------------------
				-- If we encountered an error log it and return out
				----------------------------------------------------------------------------------------------------------------------				
				If	@b_HasErrored = 1
					Begin
						Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																			,@b_RAProcessed	= 1
																			,@b_HasErrored	= 0	
																			,@vc_Error		= @vc_Error	
																		
						Goto	NoError					
					End				
			End
	End

----------------------------------------------------------------------------------------------------------------------
-- Set the error checking variables
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_Date	= GetDate()	

----------------------------------------------------------------------------------------------------------------------
-- Check the Feed to AR flag - if we don't feed this invoice type to the AR then just return out
----------------------------------------------------------------------------------------------------------------------
If	IsNull((	Select	SalesInvoiceType. SlsInvceTpeARFd 
				From	SalesInvoiceHeader			(NoLock)
						Inner Join SalesInvoiceType (NoLock)	On SalesInvoiceHeader. SlsInvceHdrSlsInvceTpeID = SalesInvoiceType. SlsInvceTpeID
				Where	SalesInvoiceHeader. SlsInvceHdrID		= @i_SlsInvceHdrID), 'N')	= 'N'
	Begin
				Select	@vc_Error	= 'The Invoice Interface has excluded SlsInvceHdrID: ' + convert(varchar,@i_SlsInvceHdrID) + ' because its invoice type is not marked Feed to A/R. '
	
				Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																	,@b_RAProcessed	= 1
																	,@b_HasErrored	= 0	
																	,@vc_Error		= @vc_Error	
																
				Goto	NoError
	End				

----------------------------------------------------------------------------------------------------------------------
-- Block 20: Determine if we have proceseed this invoice before and build out the Account Detail mapping
----------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------
-- Make the call to Custom_Interface_AD_Mapping for Sales Invoices
----------------------------------------------------------------------------------------------------------------------		
If	Not Exists (Select 'X' From CustomAccountDetail (NoLock) Where RAInvoiceID = @i_SlsInvceHdrID And InterfaceSource = 'SH') And Exists (Select 'X' From SalesInvoiceHeader (NoLock) Where SlsInvceHdrStts = 'S' And SlsInvceHdrFdDte Is Null And SlsInvceHdrID = @i_SlsInvceHdrID)
	Begin 
		Begin Try													
				Execute dbo.Custom_Interface_AD_Mapping  @i_ID				= @i_SlsInvceHdrID
														,@i_MessageID		= @i_ID
														,@vc_Source			= 'SH'
														,@c_ReturnToInvoice	= 'N'
														,@c_OnlyShowSQL		= 'N'													
														 														
		End Try
		Begin Catch
				Select	@vc_Error	= 'The Invoice Interface encountered an error executing Custom_Interface_AD_Mapping: ' + ERROR_MESSAGE()	
				
				If	@c_OnlyShowSQL	= 'N'
					Begin
						Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																			,@b_RAProcessed	= 1
																			,@b_HasErrored	= 1	
																			,@vc_Error		= @vc_Error	
																		
						Goto	NoError
					End						
		End Catch				 
	End
Else
	Begin
		If	@c_OnlyShowSQL	= 'N'
			Begin			
				If Exists (Select 'X' From CustomAccountDetail (NoLock) Where RAInvoiceID = @i_SlsInvceHdrID And InterfaceSource = 'SH')
					Select	@vc_Error	= 'The Invoice Interface has already processed SlsInvceHdrID: ' + convert(varchar,@i_SlsInvceHdrID) + '. (Does CAD Exist?) '
				If not Exists (Select 'X' From SalesInvoiceHeader (NoLock) Where SlsInvceHdrStts = 'S' And SlsInvceHdrFdDte Is Null And SlsInvceHdrID = @i_SlsInvceHdrID)
					Select	@vc_Error	= 'The Invoice Interface cannot process SlsInvceHdrID: ' + convert(varchar,@i_SlsInvceHdrID) + '. (Is it in SENT Status? Has it already FED?) '
				
				Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																	,@b_RAProcessed	= 1
																	,@b_HasErrored	= 0	 
																	,@vc_Error		= @vc_Error	
																			
				Goto	NoError		
			End
		/*	
		Else						
			Begin
				Select	@i_InvoiceID	= InterfaceInvoiceID From CustomAccountDetail (NoLock) Where RAInvoiceID = @i_SlsInvceHdrID And InterfaceSource = 'SH'	
			End	
		*/											
	End	
	
----------------------------------------------------------------------------------------------------------------------------------
-- Set the total value variables
----------------------------------------------------------------------------------------------------------------------------------	
Select	@d_InvoicAmount		= CustomAccountDetail. InvoiceAmount
		,@i_InternalBAID	= CustomAccountDetail. InvoiceIntBAID
From	CustomAccountDetail	(NoLock)
Where	CustomAccountDetail. InterfaceInvoiceID	= @i_InvoiceID	

----------------------------------------------------------------------------------------------------------------------
-- Create #AR_Interface
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'Y'
	Begin
		Select	'
		Create Table	#AR_Interface
						(ID								int				Identity 
						,InvoiceLevel					char(1)			Not Null
						,MessageQueueID					int				Not Null
						,InterfaceSource				char(2)			Null
						,InvoiceGLDate					varchar(25)		Null
						,InvoiceDate					varchar(25)		Null
						,Chart							varchar(80)		Null
						,LocalCurrency					char(3)			Null				
						,LocalDebitValue				decimal(19,2)	Null	Default 0	
						,LocalCreditValue				decimal(19,2)	Null	Default 0	
						,InterfaceInvoiceID				int				Null
						,InvoiceID						int				Null
						,ExtBAID						int				Null
						,ExtBACode						varchar(25)		Null
						,PaymentMethod					varchar(25)		Null				
						,AcctDtlID						int				Null
						,TransactionDate				varchar(25)		Null
						,DueDate						varchar(25)		Null
						,Quantity						decimal(19,6)	Null
						,PerUnitPrice					decimal(19,6)	Null	Default 0	
						,TaxCode						varchar(15)		Null
						,ProductCode					varchar(50)		Null	
						,FXConversionRate				decimal(28,13)	Null	Default 1.0	
						,InvoiceCurrency				varchar(3)		Null
						,InvoiceDebitValue				decimal(19,2)	Null	Default 0	
						,InvoiceCreditValue				decimal(19,2)	Null	Default 0	
						,IntBAID						int				Null							
						,IntBACode						varchar(25)		Null
						,InvoiceNumber					varchar(20)		Null 
						,RunningNumber					int				Null					
						,TitleTransfer					varchar(150)	Null
						,Destination					varchar(150)	Null
						,TransactionType				varchar(80)		Null
						,TransactionDescription			varchar(50)		Null										
						,Vehicle						varchar(50)		Null
						,CarrierMode					varchar(50)		Null			
						,ParentInvoiceDate				varchar(25)		Null
						,ParentInvoiceNumber			varchar(20)		Null	
						,ReceiptRefundFlag				varchar(5)		Null
						,BL								varchar(80)		Null
						,PaymentTermCode				varchar(20)		Null
						,UnitPrice						decimal(19,6)	Null	Default 0
						,UOM							varchar(20)		Null
						,AbsLocalValue					decimal(19,2)	Null	Default 0	
						,AbsInvoiceValue				decimal(19,2)	Null	Default 0	
						,LineType						varchar(3)		Null				
						,ProfitCenter					varchar(80)		Null
						,CostCenter						varchar(80)		Null
						,SalesOffice					varchar(25)		Null				
						,MaterialGroup					varchar(5)		Null				
						,DealType						varchar(60)		Null				
						,DealNumber						varchar(20)		Null		
						,DealDetailID					smallint		Null
						,TransferID						int				Null					
						,OrderID						int				Null
						,OrderBatchID					int				Null
						,Plant							varchar(5)		Null				
						,StorageLocation				varchar(5)		Null				
						,DocumentType					varchar(50)		Null				
						,CustomerClassification			varchar(2)		Null				
						,SaleGroup						varchar(4)		Null
						,HighestValue					char(1)			Null
						,IsTax							tinyint			Null
						,InterfaceStatus				char(1)			Null
						,InterfaceMessage				varchar(2000)	Null
						,Reversed						char(1)			Null
						,Currency						char(3)			Null)
'
	End
Else
	Begin
		Create Table	#AR_Interface
						(ID								int				Identity 
						,InvoiceLevel					char(1)			Not Null
						,MessageQueueID					int				Not Null
						,InterfaceSource				char(2)			Null
						,InvoiceGLDate					varchar(25)		Null
						,InvoiceDate					varchar(25)		Null
						,Chart							varchar(80)		Null
						,LocalCurrency					char(3)			Null				
						,LocalDebitValue				decimal(19,2)	Null	Default 0	
						,LocalCreditValue				decimal(19,2)	Null	Default 0	
						,InterfaceInvoiceID				int				Null
						,InvoiceID						int				Null
						,ExtBAID						int				Null
						,ExtBACode						varchar(25)		Null
						,PaymentMethod					varchar(25)		Null				
						,AcctDtlID						int				Null
						,TransactionDate				varchar(25)		Null
						,DueDate						varchar(25)		Null
						,Quantity						decimal(19,6)	Null
						,PerUnitPrice					decimal(19,6)	Null	Default 0	
						,TaxCode						varchar(15)		Null
						,ProductCode					varchar(50)		Null	
						,FXConversionRate				decimal(28,13)	Null	Default 1.0	
						,InvoiceCurrency				varchar(3)		Null
						,InvoiceDebitValue				decimal(19,2)	Null	Default 0	
						,InvoiceCreditValue				decimal(19,2)	Null	Default 0	
						,IntBAID						int				Null							
						,IntBACode						varchar(25)		Null
						,InvoiceNumber					varchar(20)		Null 
						,RunningNumber					int				Null					
						,TitleTransfer					varchar(150)	Null
						,Destination					varchar(150)	Null
						,TransactionType				varchar(80)		Null
						,TransactionDescription			varchar(50)		Null										
						,Vehicle						varchar(50)		Null
						,CarrierMode					varchar(50)		Null			
						,ParentInvoiceDate				varchar(25)		Null
						,ParentInvoiceNumber			varchar(20)		Null	
						,ReceiptRefundFlag				varchar(5)		Null
						,BL								varchar(80)		Null
						,PaymentTermCode				varchar(20)		Null
						,UnitPrice						decimal(19,6)	Null	Default 0
						,UOM							varchar(20)		Null
						,AbsLocalValue					decimal(19,2)	Null	Default 0	
						,AbsInvoiceValue				decimal(19,2)	Null	Default 0	
						,LineType						varchar(3)		Null				
						,ProfitCenter					varchar(80)		Null
						,CostCenter						varchar(80)		Null
						,SalesOffice					varchar(25)		Null				
						,MaterialGroup					varchar(5)		Null				
						,DealType						varchar(60)		Null				
						,DealNumber						varchar(20)		Null		
						,DealDetailID					smallint		Null
						,TransferID						int				Null					
						,OrderID						int				Null
						,OrderBatchID					int				Null
						,Plant							varchar(5)		Null				
						,StorageLocation				varchar(5)		Null				
						,DocumentType					varchar(50)		Null				
						,CustomerClassification			varchar(2)		Null				
						,SaleGroup						varchar(4)		Null
						,HighestValue					char(1)			Null
						,IsTax							tinyint			Null				
						,InterfaceStatus				char(1)			Null
						,InterfaceMessage				varchar(2000)	Null
						,Reversed						char(1)			Null
						,Currency						char(3)			Null)
	End

----------------------------------------------------------------------------------------------------------------------
-- Block 30: Load the Invoice Data - Lines
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '
Insert	#AR_Interface
		(InvoiceLevel
		,MessageQueueID
		,InterfaceSource
		,InvoiceGLDate
		,InvoiceDate
		,Chart
		,LocalCurrency
		,LocalDebitValue
		,LocalCreditValue
		,InterfaceInvoiceID
		,InvoiceID
		,ExtBAID
		,ExtBACode
		,PaymentMethod
		,AcctDtlID
		,TransactionDate
		,DueDate
		,Quantity
		,PerUnitPrice
		,TaxCode
		,ProductCode
		,FXConversionRate
		,InvoiceCurrency
		,InvoiceDebitValue
		,InvoiceCreditValue
		,IntBAID
		,IntBACode
		,InvoiceNumber		
		,TitleTransfer
		,Destination
		,TransactionType
		,TransactionDescription										
		,Vehicle
		,CarrierMode			
		,ParentInvoiceDate
		,ParentInvoiceNumber	
		,ReceiptRefundFlag
		,BL
		,PaymentTermCode
		,UnitPrice
		,UOM
		,AbsLocalValue
		,AbsInvoiceValue
		,LineType			
		,ProfitCenter
		,CostCenter
		,SalesOffice				
		,MaterialGroup				
		,DealType			
		,DealNumber		
		,DealDetailID
		,TransferID					
		,OrderID
		,OrderBatchID
		,Plant				
		,StorageLocation				
		,DocumentType			
		,CustomerClassification				
		,SaleGroup
		,HighestValue
		,IsTax
		,InterfaceStatus
		,InterfaceMessage
		,Reversed
		,Currency)	
Select	Case When IsTax = 1 then ''T'' else ''D'' end
		,' + convert(varchar,@i_ID) + '													-- MessageQueueID
		,InterfaceSource																-- InterfaceSource
		,dbo.Custom_Format_SAP_Date_String(InterfaceBookingDate)						-- InvoiceGLDate
		,dbo.Custom_Format_SAP_Date_String(InvoiceDate)									-- InvoiceDate
		,AcctDtlAcctCdeCde																-- Chart
		,LocalCurrency																	-- LocalCurrency			
		,Round(LocalDebitValue, 2)														-- LocalDebitValue	
		,Round(LocalCreditValue, 2)														-- LocalCreditValue
		,InterfaceInvoiceID																-- InterfaceInvoiceID
		,RAInvoiceID																	-- InvoiceID
		,InvoiceExtBAID																	-- ExtBAID
		,XRefExtBACode																	-- ExtBACode
		,Case When IsNull(FinanceSecurity,'''') <> '''' Then ''L'' Else ''N'' End		-- PaymentMethod			JPW - Double Check this Value
		,AcctDtlID																		-- AcctDtlID
		,dbo.Custom_Format_SAP_Date_String(TransactionDate)								-- TransactionDate
		,dbo.Custom_Format_SAP_Date_String(InvoiceDueDate)								-- DueDate
		,Round(InvoiceQuantity, Coalesce(InvoiceQuantityDecimal, DefaultQtyDecimals, 3))-- Quantity
		,0																				-- PerUnitPrice				NA
		,TaxCode																		-- TaxCode
		,XRefChildPrdctCode																-- ProductCode
		,LocalFXRate 																	-- FXConversionRate			//TaxFXConversionRate
		,InvoiceCurrency																-- InvoiceCurrency
		,Round(DebitValue, 2)															-- InvoiceDebitValue		
		,Round(CreditValue, 2)															-- InvoiceCreditValue		
		,InvoiceIntBAID																	-- IntBAID
		,XRefIntBACode																	-- IntBACode
		,InvoiceNumber																	-- InvoiceNumber		
		,MvtHdrOrigin																	-- TitleTransfer
		,MvtHdrDestination																-- Destination
		,TrnsctnTypDesc																	-- TransactionType
		,TrnsctnTypDesc																	-- TransactionDescription										
		,Vhcle																			-- Vehicle
		,MvtHdrTypName																	-- CarrierMode			
		,NULL																			-- ParentInvoiceDate		NA
		,InvoiceParentInvoiceNumber														-- ParentInvoiceNumber	
		,ReceiptRefundFlag																-- ReceiptRefundFlag		NA
		,Case When AcctDtlSrceTble in (''TT'', ''I'') Then ''NA'' Else MvtDcmntExtrnlDcmntNbr end	-- BL 
		,XRefTrmCode																	-- PaymentTermCode
		,0																				-- UnitPrice				NA
		,InvoiceUOM																		-- UOM
		,Round(Abs(LocalValue),2)														-- AbsLocalValue
		,Round(Abs(NetValue),2)															-- AbsInvoiceValue
		,GLLineType																		-- LineType								
		,ProfitCenter																	-- ProfitCenter
		,''''																			-- CostCenter
		,SalesOffice																	-- SalesOffice				
		,MaterialGroup																	-- MaterialGroup							
		,DlDtlTpe																		-- DealType							
		,DlHdrIntrnlNbr																	-- DealNumber		
		,DlDtlID																		-- DealDetailID
		,PlnndTrnsfrID																	-- TransferID					
		,PlnndMvtID																		-- OrderID
		,PlnndMvtBtchID																	-- OrderBatchID
		,Plant																			-- Plant									
		,StorageLocation																-- StorageLocation							
		,XRefDocumentType																-- DocumentType			
		,ExtBAClass																		-- CustomerClassification				
		,XRefIntUserCode																-- SaleGroup
		,HighestValue																	-- HighestValue	
		,IsTax																			-- IsTax	
		,''A''																			-- InterfaceStatus
		,''''																			-- InterfaceMessage	
		,Reversed
		,Currency					
From	CustomAccountDetail	(NoLock)
		Left Outer Join AccountDetailAccountCode (NoLock)
			on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
Where	CustomAccountDetail. InterfaceInvoiceID	= ' + convert(varchar,@i_InvoiceID) + '
And		Exists (
				Select	1
				From	AccountCode (NoLock)
				Where	AccountCode.AcctCdeID	= IsNull(AcctDtlAcctCdeAcctCdeID, AccountCode.AcctCdeID)
				and		AccountCode.AcctCdeTpe	= ''P''
				)
--And		CustomAccountDetail. IsTax				<> 1
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Block 30: Load the Invoice Data - Tax Lines
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '
Insert	#AR_Interface
		(InvoiceLevel
		,MessageQueueID
		,InterfaceSource
		,InvoiceGLDate
		,InvoiceDate
		,Chart
		,LocalCurrency
		,LocalDebitValue
		,LocalCreditValue
		,InterfaceInvoiceID
		,InvoiceID
		,ExtBAID
		,ExtBACode
		,PaymentMethod
		,DueDate
		,Quantity
		,PerUnitPrice
		,TaxCode
		,FXConversionRate
		,InvoiceCurrency
		,InvoiceDebitValue
		,InvoiceCreditValue
		,IntBAID
		,IntBACode
		,InvoiceNumber
		,TransactionType
		,TransactionDescription
		,ParentInvoiceDate
		,ParentInvoiceNumber
		,ReceiptRefundFlag
		,PaymentTermCode
		,UnitPrice
		,UOM		
		,LineType
		,ProfitCenter
		,CostCenter
		,DocumentType
		,IsTax
		,InterfaceStatus
		,InterfaceMessage
		,Reversed
		,Currency)	
Select	''T''
		,' + convert(varchar,@i_ID) + '													-- MessageQueueID
		,InterfaceSource																-- InterfaceSource
		,dbo.Custom_Format_SAP_Date_String(InterfaceBookingDate)						-- InvoiceGLDate
		,dbo.Custom_Format_SAP_Date_String(InvoiceDate)									-- InvoiceDate
		,CreditAccount																	-- Chart
		,LocalCurrency																	-- LocalCurrency			
		,Sum(Round(LocalDebitValue, 2))													-- LocalDebitValue	
		,Sum(Round(LocalCreditValue, 2))												-- LocalCreditValue
		,InterfaceInvoiceID																-- InterfaceInvoiceID
		,RAInvoiceID																	-- InvoiceID
		,InvoiceExtBAID																	-- ExtBAID
		,XRefExtBACode																	-- ExtBACode
		,Case When IsNull(FinanceSecurity,'''') <> '''' Then ''L'' Else ''N'' End		-- PaymentMethod			JPW - Double Check this Value
		,dbo.Custom_Format_SAP_Date_String(InvoiceDueDate)								-- DueDate
		,Sum(Round(InvoiceQuantity, Coalesce(InvoiceQuantityDecimal, DefaultQtyDecimals, 3)))-- Quantity
		,0																				-- PerUnitPrice				NA
		,TaxCode																		-- TaxCode
		,LocalFXRate 																	-- FXConversionRate			//TaxFXConversionRate
		,InvoiceCurrency																-- InvoiceCurrency
		,Sum(Round(DebitValue, 2))														-- InvoiceDebitValue		
		,Sum(Round(CreditValue, 2))														-- InvoiceCreditValue		
		,InvoiceIntBAID																	-- IntBAID
		,XRefIntBACode																	-- IntBACode
		,InvoiceNumber																	-- InvoiceNumber		
		,TrnsctnTypDesc																	-- TransactionType
		,TrnsctnTypDesc																	-- TransactionDescription											
		,NULL																			-- ParentInvoiceDate		NA
		,InvoiceParentInvoiceNumber														-- ParentInvoiceNumber	
		,ReceiptRefundFlag																-- ReceiptRefundFlag		NA
		,XRefTrmCode																	-- PaymentTermCode
		,0																				-- UnitPrice				NA
		,InvoiceUOM																		-- UOM
		,GLLineType																		-- LineType								
		,''''																			-- ProfitCenter
		,''''																			-- CostCenter
		,XRefDocumentType
		,IsTax																			-- IsTax		
		,''A''																			-- InterfaceStatus
		,''''																			-- InterfaceMessage
		,Reversed																		-- Reversed	
		,Currency		
From	CustomAccountDetail	(NoLock)
Where	CustomAccountDetail. InterfaceInvoiceID	= ' + convert(varchar,@i_InvoiceID) + '
And		CustomAccountDetail. IsTax				= 1
Group By	InterfaceSource
			,dbo.Custom_Format_SAP_Date_String(InterfaceBookingDate)
			,dbo.Custom_Format_SAP_Date_String(InvoiceDate)		
			,CreditAccount
			,LocalCurrency
			,InterfaceInvoiceID
			,RAInvoiceID
			,InvoiceExtBAID
			,XRefExtBACode
			,Case When IsNull(FinanceSecurity,'''') <> '''' Then ''L'' Else ''N'' End
			,dbo.Custom_Format_SAP_Date_String(InvoiceDueDate)
			,TaxCode
			,LocalFXRate
			,InvoiceCurrency
			,InvoiceIntBAID
			,XRefIntBACode
			,InvoiceNumber
			,TrnsctnTypDesc
			,TrnsctnTypDesc
			,InvoiceParentInvoiceNumber
			,ReceiptRefundFlag
			,XRefTrmCode
			,InvoiceUOM
			,GLLineType
			,XRefDocumentType
			,IsTax
			,Reversed
			,Currency
'

--If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Add in a Detail row to represent the Discount amount
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '
Insert	#AR_Interface
		(InvoiceLevel
		,MessageQueueID
		,InterfaceSource
		,InvoiceGLDate
		,InvoiceDate
		,LocalCurrency
		,LocalDebitValue
		,LocalCreditValue
		,InterfaceInvoiceID
		,InvoiceID
		,ExtBAID
		,ExtBACode
		,PaymentMethod
		,DueDate
		,Quantity
		,AcctDtlID
		,FXConversionRate
		,InvoiceCurrency
		,InvoiceDebitValue
		,InvoiceCreditValue
		,IntBAID
		,IntBACode
		,InvoiceNumber
		,Chart
		,RunningNumber		
		,PaymentTermCode
		,UOM
		,DocumentType
		,InterfaceStatus
		,InterfaceMessage
		
		,TransactionDate
		,ProductCode
		,TitleTransfer
		,Destination
		,TransactionType
		,TransactionDescription
		,CarrierMode
		,ParentInvoiceNumber
		,ReceiptRefundFlag
		,BL
		,LineType
		,DealNumber
		,DealDetailID
		,AbsLocalValue
		,AbsInvoiceValue
		)	
Select	''D''					-- InvoiceLevel	
		,MessageQueueID			-- MessageQueueID	
		,InterfaceSource		-- InterfaceSource
		,InvoiceGLDate			-- InvoiceGLDate
		,InvoiceDate			-- InvoiceDate
		,LocalCurrency			-- LocalCurrency
		,Case When EstimatedDiscountValue > 0 Then 0 Else EstimatedDiscountValue end	-- LocalDebitValue
		,Case When EstimatedDiscountValue < 0 Then 0 Else EstimatedDiscountValue end	-- LocalCreditValue
		,#AR_Interface.InterfaceInvoiceID		-- InterfaceInvoiceID
		,InvoiceID				-- InvoiceID
		,ExtBAID				-- ExtBAID
		,ExtBACode				-- ExtBACode
		,PaymentMethod			-- PaymentMethod
		,DueDate				-- DueDate
		,Quantity				-- Quantity
		,#AR_Interface.AcctDtlID		-- AcctDtlID
		,FXConversionRate		-- FXConversionRate
		,InvoiceCurrency		-- InvoiceCurrency
		,Case When EstimatedDiscountValue > 0 Then 0 Else EstimatedDiscountValue end	-- InvoiceDebitValue  
		,Case When EstimatedDiscountValue < 0 Then 0 Else EstimatedDiscountValue end	-- InvoiceCreditValue
		,IntBAID				-- IntBAID
		,IntBACode				-- IntBACode
		,InvoiceNumber			-- InvoiceNumber
		,GnrlCnfgMulti			-- Chart
		,999					-- RunningNumber
		,PaymentTermCode		-- PaymentTermCode	
		,UOM					-- UOM
		,DocumentType			-- DocumentType
		,InterfaceStatus		-- InterfaceStatus
		,InterfaceMessage		-- InterfaceMessage

		,TransactionDate		-- TransactionDate
		,ProductCode			-- ProductCode
		,TitleTransfer			-- TitleTransfer
		,Destination			-- Destination
		,''Discount''			-- TransactionType
		,''Discount''			-- TransactionDescription
		,CarrierMode			-- CarrierMode
		,ParentInvoiceNumber	-- ParentInvoiceNumber
		,Case	When #AR_Interface.ReceiptRefundFlag = ''AP''
				Then ''AR'' Else ''AP'' End					-- ReceiptRefundFlag
		,BL						-- BL
		,Case	When #AR_Interface.LineType = 40
				Then 50 Else 40 End							-- LineType
		,DealNumber				-- DealNumber
		,DealDetailID			-- DealDetailID

		,Abs(EstimatedDiscountValue)	-- AbsLocalValue
		,Abs(EstimatedDiscountValue)	-- AbsInvoiceValue

-- select *
From	#AR_Interface	(NoLock)
		Left Outer Join GeneralConfiguration (NoLock)
			on	GnrlCnfgTblNme		= ''BusinessAssociate''
			and	GnrlCnfgQlfr		= ''DiscountGLAccount''
			and	GnrlCnfgHdrID		= #AR_Interface.IntBAID
		Inner Join AccountDetailEstimatedDate (NoLock)
			on	AccountDetailEstimatedDate.AcctDtlID					= #AR_Interface.AcctDtlID
			and	AccountDetailEstimatedDate.EstimatedDiscountValue		<> 0.0
Where	#AR_Interface.InvoiceLevel			= ''D''

'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Load the Invoice Data - Header
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '
Insert	#AR_Interface
		(InvoiceLevel
		,MessageQueueID
		,InterfaceSource
		,InvoiceGLDate
		,InvoiceDate
		,LocalCurrency
		,LocalDebitValue
		,LocalCreditValue
		,InterfaceInvoiceID
		,InvoiceID
		,ExtBAID
		,ExtBACode
		,PaymentMethod
		,DueDate
		,Quantity
		,FXConversionRate
		,InvoiceCurrency
		,InvoiceDebitValue
		,InvoiceCreditValue
		,IntBAID
		,IntBACode
		,InvoiceNumber
		,RunningNumber		
		,PaymentTermCode
		,UOM
		,DocumentType
		,InterfaceStatus
		,InterfaceMessage)	
Select	''H''					-- InvoiceLevel	
		,MessageQueueID			-- MessageQueueID	
		,InterfaceSource		-- InterfaceSource
		,InvoiceGLDate			-- InvoiceGLDate
		,InvoiceDate			-- InvoiceDate
		,LocalCurrency			-- LocalCurrency
		,Sum(LocalCreditValue)	-- LocalDebitValue
		,Sum(LocalDebitValue)	-- LocalCreditValue
		,InterfaceInvoiceID		-- InterfaceInvoiceID
		,InvoiceID				-- InvoiceID
		,ExtBAID				-- ExtBAID
		,ExtBACode				-- ExtBACode
		,PaymentMethod			-- PaymentMethod
		,DueDate				-- DueDate
		,Sum(Quantity)			-- Quantity
		,FXConversionRate		-- FXConversionRate
		,InvoiceCurrency		-- InvoiceCurrency
		,Sum(InvoiceCreditValue)-- InvoiceDebitValue  
		,Sum(InvoiceDebitValue)	-- InvoiceCreditValue
		,IntBAID				-- IntBAID
		,IntBACode				-- IntBACode
		,InvoiceNumber			-- InvoiceNumber
		,1						-- RunningNumber
		,PaymentTermCode		-- PaymentTermCode	
		,UOM					-- UOM
		,DocumentType			-- DocumentType
		,InterfaceStatus		-- InterfaceStatus
		,InterfaceMessage		-- InterfaceMessage
From	#AR_Interface	(NoLock)
Group By	 MessageQueueID			
			,InterfaceSource		
			,InvoiceGLDate			
			,InvoiceDate			
			,LocalCurrency			
			,InterfaceInvoiceID		
			,InvoiceID				
			,ExtBAID				
			,ExtBACode				
			,PaymentMethod			
			,DueDate				
			,FXConversionRate		
			,InvoiceCurrency		
			,IntBAID				
			,IntBACode				
			,InvoiceNumber			
			,PaymentTermCode			
			,UOM	
			,DocumentType				
			,InterfaceStatus		
			,InterfaceMessage		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Line Type and AR/AP flag from CustomAccountDetail
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '
Update	#AR_Interface
Set		LineType			=	CustomAccountDetail. InvoiceLineType
		,ReceiptRefundFlag	=	Case
									When	CustomAccountDetail. InvoiceAmount	>= 0	Then ''AR''	
									Else	''AP''
								End
From	#AR_Interface					(NoLock)
		Inner Join	CustomAccountDetail	(NoLock)	On	#AR_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID 	
Where	CustomAccountDetail. InterfaceInvoiceID	= ' + convert(varchar,@i_InvoiceID) + '
And		#AR_Interface. InvoiceLevel				= ''H''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Header row's Chart as the offset for the Detail rows
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '
Update	#AR_Interface
Set		Chart = AcctDtlAcctCdeCde
From	#AR_Interface (NoLock)
		Inner Join	CustomAccountDetail	(NoLock)
			On	#AR_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID
		Inner Join AccountDetailAccountCode (NoLock)
			on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
Where	CustomAccountDetail. InterfaceInvoiceID	= ' + convert(varchar,@i_InvoiceID) + '
And		Exists (
				Select	1
				From	AccountCode (NoLock)
				Where	AccountCode.AcctCdeID	= AcctDtlAcctCdeAcctCdeID
				and		AccountCode.AcctCdeTpe	= ''O''
				)
And		#AR_Interface. InvoiceLevel				= ''H''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the ancillary header values from the highest value transaction
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '
Update	Header
Set		 Header. TransactionDate		= Detail. TransactionDate
		,Header. ProductCode			= Detail. ProductCode
		,Header. TitleTransfer			= Detail. TitleTransfer	
		,Header. Destination			= Detail. Destination
		,Header. TransactionType		= Detail. TransactionType
		,Header. Vehicle				= Detail. Vehicle		
		,Header. CarrierMode			= Detail. CarrierMode
		,Header. BL						= Detail. BL
		,Header. ProfitCenter			= Detail. ProfitCenter
		,Header. CostCenter				= Detail. CostCenter
		,Header. SalesOffice			= Detail. SalesOffice
		,Header. MaterialGroup			= Detail. MaterialGroup
		,Header. DealType				= Detail. DealType
		,Header. DealNumber				= Detail. DealNumber
		,Header. DealDetailID			= Detail. DealDetailID
		,Header. TransferID				= Detail. TransferID
		,Header. OrderID				= Detail. OrderID
		,Header. OrderBatchID			= Detail. OrderBatchID
		,Header. Plant					= Detail. Plant
		,Header. StorageLocation		= Detail. StorageLocation
		,Header. CustomerClassification	= Detail. CustomerClassification
		,Header. SaleGroup				= Detail. SaleGroup
From	#AR_Interface				Header	(NoLock)
		Inner Join	#AR_Interface	Detail	(NoLock)	On	Header. InterfaceInvoiceID	= Detail. InterfaceInvoiceID
Where	Header. InvoiceLevel	= ''H''
And		Detail. InvoiceLevel	= ''D''
And		Detail. HighestValue	= ''Y''			 	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the ancillary tax values from the header value transaction
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '
Update	Tax
Set		 Tax. TransactionDate		= Header. TransactionDate
		,Tax. ProductCode			= Header. ProductCode
		,Tax. TitleTransfer			= Header. TitleTransfer	
		,Tax. Destination			= Header. Destination
		--,Tax. TransactionType		= Header. TransactionType
		,Tax. Vehicle				= Header. Vehicle		
		,Tax. CarrierMode			= Header. CarrierMode
		-- ,Tax. BL					= Header. BL
		-- ,Tax. ProfitCenter		= Header. ProfitCenter
		-- ,Tax. CostCenter			= Header. CostCenter
		,Tax. SalesOffice			= Header. SalesOffice
		,Tax. MaterialGroup			= Header. MaterialGroup
		,Tax. DealType				= Header. DealType
		-- ,Tax. DealNumber			= Header. DealNumber
		,Tax. DealDetailID			= Header. DealDetailID
		,Tax. TransferID			= Header. TransferID
		,Tax. OrderID				= Header. OrderID
		,Tax. OrderBatchID			= Header. OrderBatchID
		,Tax. Plant					= Header. Plant
		,Tax. StorageLocation		= Header. StorageLocation
		,Tax. DocumentType			= Header. DocumentType
		,Tax. CustomerClassification	= Header. CustomerClassification		
		,Tax. SaleGroup				= Header. SaleGroup		
From	#AR_Interface				Header	(NoLock)
		Inner Join	#AR_Interface	Tax		(NoLock)	On	Header. InterfaceInvoiceID	= Tax. InterfaceInvoiceID
Where	Header. InvoiceLevel	= ''H''
And		Tax. InvoiceLevel		= ''T''		 	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the per unit price value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Update	#AR_Interface
Set		PerUnitPrice	=	Abs(Case
								When	Quantity	<> 0 Then ( (IsNull(InvoiceDebitValue,0) + IsNull(InvoiceCreditValue,0)) / Quantity )
								Else	0.0
							End) 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)							

----------------------------------------------------------------------------------------------------------------------
-- Set the Abs values on the header
----------------------------------------------------------------------------------------------------------------------							
Select	@vc_DynamicSQL	= '
Update	#AR_Interface							
Set		AbsLocalValue		= Abs(LocalDebitValue + LocalCreditValue)
		,AbsInvoiceValue	= Abs(InvoiceDebitValue + InvoiceCreditValue)								
Where	#AR_Interface. InvoiceLevel	In (''H'',''T'')
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the TransactionDescription value on the header
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Update	#AR_Interface							
Set		TransactionDescription	= Substring(IsNull((Select	(	Select	Distinct ''; '' +  CustomAccountDetail. TrnsctnTypDesc
															From	CustomAccountDetail	(NoLock)
															Where	CustomAccountDetail. InterfaceInvoiceID				=  ' + convert(varchar,@i_InvoiceID) + '
															And		IsNull(CustomAccountDetail. TrnsctnTypDesc, '''')	<> ''''
															FOR XML PATH('''') ) As Details), ''''), 3, 50) 						
Where	#AR_Interface. InvoiceLevel	= ''H''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Running Number Value
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL <> 'Y'
	Begin
		Select	@i_LineID	= Min(ID)
		From	#AR_Interface	(NoLock)
		Where	#AR_Interface. InvoiceLevel	In ('D','T')
		
		While	@i_LineID Is Not Null
				Begin
					Select	@i_Counter	= IsNull(@i_Counter,1) + 1
				
					Update	#AR_Interface
					Set		RunningNumber		= @i_Counter
					Where	#AR_Interface. ID	= @i_LineID	
					
					Select	@i_LineID	= Min(ID)
					From	#AR_Interface	(NoLock)
					Where	#AR_Interface. InvoiceLevel	In ('D','T')
					And		#AR_Interface. ID			> @i_LineID					
																		
				End
	End




/***********************************************

COMMENTING OUT FOR MOTIVA -- WE WILL DO XREF ERRORS IN EACH INTERFACE

----------------------------------------------------------------------------------------------------------------------
-- Block 40: Data Validation
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Validate a InvoiceGLDate value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Invoice GL Date could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. InvoiceGLDate, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a InvoiceDate value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Invoice Date could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. InvoiceDate, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Credit value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Chart could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. Chart, '''')))	= ''''
And		#AR_Interface. InvoiceLevel	In (''D'',''T'')		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a LocalCurrency value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Local Currency could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. LocalCurrency, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a InterfaceInvoiceID value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Interface Invoice ID could not be determined. ''
		,InterfaceStatus	= ''E''
Where	IsNull(#AR_Interface. InterfaceInvoiceID, 0)	= 0
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a InvoiceID value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Invoice ID could not be determined. ''
		,InterfaceStatus	= ''E''
Where	IsNull(#AR_Interface. InvoiceID, 0)	= 0
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a ExtBACode value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Ext BA Code could not be determined [SAPCustomerNumber Attribute - BA Maint]. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. ExtBACode, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a TransactionDate value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Transaction Date could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. TransactionDate, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a DueDate value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Due Date could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. DueDate, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a TaxCode value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Tax Code could not be determined [SAPARCode Attribute - VAT Description Maint]. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. TaxCode, '''')))	= ''''
And		#AR_Interface. InvoiceLevel		= ''T''	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a InvoiceCurrency value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Invoice Currency could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. InvoiceCurrency, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a IntBACode value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Int BA Code could not be determined [SAPInternalNumber Attribute - BA Maint]. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. IntBACode, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a TransactionType value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Transaction Type could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. TransactionType, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a ReceiptRefundFlag value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Receipt Refund could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. ReceiptRefundFlag, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a LineType value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Line Type could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. LineType, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a ProfitCenter value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Profit Center could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. ProfitCenter, '''')))	= ''''
And		#AR_Interface. InvoiceLevel		<> ''T''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a SalesOffice value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Sales Office could not be determined [SAPSalesOffice Attribute - BA Maint]. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. SalesOffice, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a MaterialGroup value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Material Group could not be determined [SAPMaterialGroup Attribute - Product Maint]. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. MaterialGroup, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Plant value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Plant could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. Plant, '''')))	= ''''
'

--If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a StorageLocation value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Storage Location could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. StorageLocation, '''')))	= ''''
'

--If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a DocumentType value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Document Type could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. DocumentType, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a CustomerClassification value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Customer Classification could not be determined [SAPCustomerClass Attribute - BA Maint]. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. CustomerClassification, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a SaleGroup value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#AR_Interface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Sale Group could not be determined [SalesGroup Attribute - Contact Maint]. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#AR_Interface. SaleGroup, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Check for multiple H records - should not happen
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- Check that the sum of the details equals the sum of the header
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- If we have one Error row - mark them all to error
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
If	Exists	(Select ''X'' From #AR_Interface (NoLock) Where InterfaceStatus = ''E'')
	Update	#AR_Interface
	Set		InterfaceStatus		= ''E''
			,InterfaceMessage	= InterfaceMessage + '' One or more lines has an error. ''
	Where	InterfaceStatus		<> ''E''		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Reset records to 'R' if we are ignoring errors
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
If	(Select GenerateFileWithErrors From CustomConfigAccounting (NoLock) Where ConfigurationName = ''Default'') = ''Y''
	Update	#AR_Interface
	Set		InterfaceStatus		= ''R''
	Where	InterfaceStatus		= ''E''		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
*/


----------------------------------------------------------------------------------------------------------------------
-- Block 60: Stage the interface tables
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'N'
	Begin
	
		Begin Transaction InsertAR

			----------------------------------------------------------------------------------------------------------------------
			-- Stage the record into the CustomInvoiceInterface table
			----------------------------------------------------------------------------------------------------------------------	
			Insert	CustomInvoiceInterface
					(InvoiceLevel
					,MessageQueueID
					,InterfaceSource
					,InvoiceGLDate
					,InvoiceDate
					,Chart
					,LocalCurrency				
					,LocalDebitValue	
					,LocalCreditValue
					,InterfaceInvoiceID
					,InvoiceID
					,ExtBAID
					,ExtBACode
					,PaymentMethod				
					,AcctDtlID
					,TransactionDate
					,DueDate
					,Quantity
					,PerUnitPrice
					,TaxCode
					,ProductCode	
					,FXConversionRate
					,InvoiceCurrency
					,InvoiceDebitValue
					,InvoiceCreditValue
					,IntBAID						
					,IntBACode
					,InvoiceNumber
					,RunningNumber					
					,TitleTransfer
					,Destination
					,TransactionType
					,TransactionDescription										
					,Vehicle
					,CarrierMode			
					,ParentInvoiceDate
					,ParentInvoiceNumber	
					,ReceiptRefundFlag
					,BL	
					,PaymentTermCode
					,UnitPrice
					,UOM
					,AbsLocalValue
					,AbsInvoiceValue	
					,LineType			
					,ProfitCenter
					,CostCenter
					,SalesOffice				
					,MaterialGroup			
					,DealType			
					,DealNumber		
					,DealDetailID
					,TransferID					
					,OrderID
					,OrderBatchID
					,Plant				
					,StorageLocation				
					,DocumentType				
					,CustomerClassification				
					,SaleGroup				
					,InterfaceStatus
					,InterfaceMessage
					,ApprovalUserID
					,ApprovalDate
					,CreationDate
					,MessageBusConfirmed)	
			Select	InvoiceLevel								-- InvoiceLevel
					,MessageQueueID								-- MessageQueueID
					,InterfaceSource							-- InterfaceSource
					,IsNull(InvoiceGLDate,'')					-- InvoiceGLDate
					,IsNull(InvoiceDate,'')						-- InvoiceDate
					,IsNull(Chart,'')							-- Chart
					,IsNull(LocalCurrency,'')					-- LocalCurrency				
					,LocalDebitValue							-- LocalDebitValue	
					,LocalCreditValue							-- LocalCreditValue
					,InterfaceInvoiceID							-- InterfaceInvoiceID
					,InvoiceID									-- InvoiceID
					,ExtBAID									-- ExtBAID
					,IsNull(ExtBACode,'')						-- ExtBACode
					,IsNull(PaymentMethod,'')					-- PaymentMethod				
					,AcctDtlID									-- AcctDtlID
					,IsNull(TransactionDate,'')					-- TransactionDate
					,IsNull(DueDate,'')							-- DueDate
					,Quantity									-- Quantity
					,PerUnitPrice								-- PerUnitPrice
					,IsNull(TaxCode,'')							-- TaxCode
					,IsNull(ProductCode,'')						-- ProductCode	
					,FXConversionRate							-- FXConversionRate
					,IsNull(InvoiceCurrency,'')					-- InvoiceCurrency
					,InvoiceDebitValue							-- InvoiceDebitValue
					,InvoiceCreditValue							-- InvoiceCreditValue
					,IntBAID									-- IntBAID						
					,IsNull(IntBACode,'')						-- IntBACode
					,IsNull(InvoiceNumber,'')					-- InvoiceNumber
					,RunningNumber								-- RunningNumber					
					,IsNull(TitleTransfer,'')					-- TitleTransfer
					,IsNull(Destination,'')						-- Destination
					,IsNull(TransactionType,'')					-- TransactionType
					,IsNull(TransactionDescription,'')			-- TransactionDescription										
					,IsNull(Vehicle,'')							-- Vehicle
					,IsNull(CarrierMode,'')						-- CarrierMode			
					,IsNull(ParentInvoiceDate,'')				-- ParentInvoiceDate
					,IsNull(ParentInvoiceNumber,'')				-- ParentInvoiceNumber	
					,IsNull(ReceiptRefundFlag,'')				-- ReceiptRefundFlag
					,IsNull(BL,'')								-- BL	
					,IsNull(PaymentTermCode,'')					-- PaymentTermCode
					,UnitPrice									-- UnitPrice
					,IsNull(UOM,'')								-- UOM
					,AbsLocalValue								-- AbsLocalValue
					,AbsInvoiceValue							-- AbsInvoiceValue	
					,IsNull(LineType,'')						-- LineType			
					,IsNull(ProfitCenter,'')					-- ProfitCenter
					,IsNull(CostCenter,'')						-- CostCenter
					,IsNull(SalesOffice,'')						-- SalesOffice				
					,IsNull(MaterialGroup,'')					-- MaterialGroup			
					,IsNull(DealType,'')						-- DealType			
					,IsNull(DealNumber,'')						-- DealNumber		
					,DealDetailID								-- DealDetailID
					,TransferID									-- TransferID					
					,OrderID									-- OrderID
					,OrderBatchID								-- OrderBatchID
					,IsNull(Plant,'')							-- Plant				
					,IsNull(StorageLocation,'')					-- StorageLocation				
					,IsNull(DocumentType,'')					-- DocumentType				
					,IsNull(CustomerClassification,'')			-- CustomerClassification				
					,IsNull(SaleGroup,'')						-- SaleGroup				
					,InterfaceStatus							-- InterfaceStatus
					,RTrim(LTrim(IsNull(InterfaceMessage,'')))	-- InterfaceMessage
					,NULL										-- ApprovalUserID
					,NULL										-- ApprovalDate
					,@sdt_Date									-- CreationDate
					,0											-- MessageBusConfirmed	 
			From	#AR_Interface	(NoLock)
			Order By RunningNumber Asc
			
			---------------------------------------------------------------------------------------------------------------------
			-- Check for Errors on the Insert
			----------------------------------------------------------------------------------------------------------------------
			If	@@error <> 0 
				Begin
					Rollback Transaction InsertAR
					
					Select	@vc_Error			= 'The AR Interface encountered an error inserting a record into the CustomInvoiceInterface table.' 
					
					Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																		,@b_RAProcessed	= 1
																		,@b_HasErrored	= 1	
																		,@vc_Error		= @vc_Error	
																
					Goto	NoError						
				End						

			----------------------------------------------------------------------------------------------------------------------------------
			-- Commit the Transaction
			----------------------------------------------------------------------------------------------------------------------------------
			Commit Transaction InsertAR
			
			----------------------------------------------------------------------------------------------------------------------
			-- If we are not auto approving and there was an error send it back to the message
			----------------------------------------------------------------------------------------------------------------------
			If	Exists (Select 'X' From CustomInvoiceInterface (NoLock) Where MessageQueueID = @i_ID And InterfaceStatus = 'E')
				Begin
					Select	@vc_Error	= 'Sales Invoice ID: ' + convert(varchar,@i_SlsInvceHdrID) + ' has incomplete invoice data.'
				
					Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																		,@b_RAProcessed	= 1
																		,@b_HasErrored	= 1	
																		,@vc_Error		= @vc_Error						
				End
			Else
				Begin
					Execute dbo.Custom_Interface_Manage_Message_Queue	@i_ID			= @i_ID
																		,@b_RAProcessed	= 1
																		,@b_HasErrored	= 0	
																		,@vc_Error		= NULL
				End
					
	End
	
----------------------------------------------------------------------------------------------------------------------
-- Drop the temp table
----------------------------------------------------------------------------------------------------------------------	
If	Object_ID('TempDB..#AR_Interface') Is Not Null
	Drop Table #AR_Interface	

----------------------------------------------------------------------------------------------------------------------
-- Return out
----------------------------------------------------------------------------------------------------------------------
NoError:
	Return	

----------------------------------------------------------------------------------------------------------------------
-- Error Handler:
----------------------------------------------------------------------------------------------------------------------
Error:  
	Raiserror (60010,-1,-1,@vc_Error)


GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_AR_Outbound') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_AR_Outbound >>>'
	Grant Execute on dbo.Custom_Interface_AR_Outbound to SYSUSER
	Grant Execute on dbo.Custom_Interface_AR_Outbound to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_AR_Outbound >>>'
GO

 