If OBJECT_ID('dbo.Custom_Message_Queue_BulkProcessor') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Message_Queue_BulkProcessor
    PRINT '<<< DROPPED PROC dbo.Custom_Message_Queue_BulkProcessor >>>'
End
Go  

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Custom_Message_Queue_BulkProcessor]
AS
set NOCOUNT on
-- =============================================
-- Author:        J. von Hoff
-- Create date:	  12DEC2016
-- Description:   Process items from the CustomMessageQueue table
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

---------------------------------------------
-- Check the process out
---------------------------------------------
Declare @i_checkoutStatus int
Exec @i_checkoutStatus = dbo.sra_checkout_process 'CustomMessageQueueProcessor'

if @i_checkoutStatus = 0
	return

---------------------------------------------
-- Grab the oldest records to process
---------------------------------------------
Select	TOP 10000 ID, Entity, EntityID, Reprocess, convert(varchar(1000), null) Message
into	#CMQtoProcess
From	dbo.CustomMessageQueue (NoLock)
Where	RAProcessed = 0 or Reprocess = 1
Order by ID

Update	#CMQtoProcess
Set		Message = 'The Invoice Interface cannot process Message ID: ' + convert(varchar,#CMQtoProcess.ID) + '. '
From	#CMQtoProcess
Where	Entity in ('SH', 'PH')
and		(
		Not Exists (Select 1 From dbo.CustomMessageQueue (NoLock) Where Id = IsNull(#CMQtoProcess.ID,0) And Entity = #CMQtoProcess.Entity)
or		Exists (Select 1 From dbo.CustomMessageQueue (NoLock) Where Id = IsNull(#CMQtoProcess.ID,0) And RAProcessed = 1 And Reprocess = 0)
		)


Update	CustomMessageQueue
Set		RAProcessed			= 1
		,RAProcessedDate	= GetDate()
		,HasErrored			= 1
		,Error				= Message
		,Reprocess			= 0
From	#CMQtoProcess
		Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #CMQtoProcess.ID
Where	Message like 'The Invoice Interface cannot process Message ID%'

Delete	#CMQtoProcess
Where	Message like 'The Invoice Interface cannot process Message ID%'

---------------------------------------------
-- Sorting hat!
---------------------------------------------
Select	*
Into	#AR_Bulk
From	#CMQtoProcess
Where	Entity = 'SH'

Select	*
Into	#AP_Bulk
From	#CMQtoProcess
Where	Entity = 'PH'

Select	*
Into	#GL_Bulk
From	#CMQtoProcess
Where	Entity = 'GL'

-- 		execute Custom_Interface_GL_Outbound @i_ID, @i_Reprocess
drop table #CMQtoProcess

---------------------------------------------
-- First, work on the AR stuff
---------------------------------------------
if exists (select 1 from #AR_Bulk)
begin

	-- First set any errors where we can't process an invoice
	Update	#AR_Bulk
	Set		Message = case when SlsInvceHdrFdDte is not null
						then 'The invoice cannot be reprocessed because it has already been Fed.'
						when SlsInvceHdrPd = 'Y'
						then 'The invoice cannot be reprocessed because it has already been Paid.'
						end
	From	#AR_Bulk
			Inner Join dbo.SalesInvoiceHeader (NoLock)
				on	#AR_Bulk.EntityID		= SalesInvoiceHeader.SlsInvceHdrID
	Where	#AR_Bulk.Reprocess = 1


	Update	CustomMessageQueue
	Set		RAProcessed			= 1
			,RAProcessedDate	= GetDate()
			,HasErrored			= 0
			,Error				= Message
			,Reprocess			= 0
	From	#AR_Bulk
			Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AR_Bulk.ID
	Where	Message is not null

	Delete	#AR_Bulk
	Where	Message is not null

	-- Get rid of any old data when we're going to reprocess
	Delete	dbo.CustomAccountDetail
	From	#AR_Bulk
			Inner Join dbo.CustomAccountDetail
				on	InterfaceMessageID = #AR_Bulk.ID
	Where	#AR_Bulk.Reprocess = 1
		
	Delete	dbo.CustomInvoiceInterface
	From	#AR_Bulk
			Inner Join dbo.CustomInvoiceInterface
				on	MessageQueueID = #AR_Bulk.ID
	Where	#AR_Bulk.Reprocess = 1

	Update	#AR_Bulk
	Set		Message = 'The Invoice Interface has excluded SlsInvceHdrID: ' + convert(varchar,EntityID) + ' because its invoice type is not marked Feed to A/R. '
	From	#AR_Bulk
	Where	Not Exists	(
						Select	1
						From	dbo.SalesInvoiceHeader (NoLock)
								Inner Join dbo.SalesInvoiceType (NoLock)
									on	SalesInvoiceType.SlsInvceTpeID	= SalesInvoiceHeader.SlsInvceHdrSlsInvceTpeID
						Where	#AR_Bulk.EntityID		= SalesInvoiceHeader.SlsInvceHdrID
						And		SalesInvoiceType.SlsInvceTpeARFd <> 'N'
						)

	Update	#AR_Bulk
	Set		Message = 'The Invoice Interface has already processed SlsInvceHdrID: ' + convert(varchar,EntityID) + '. (Does CAD Exist?) '
	From	#AR_Bulk
	Where	Exists	(
					Select	1
					From	dbo.CustomAccountDetail (NoLock)
					Where	RAInvoiceID = #AR_Bulk.EntityID
					And		InterfaceSource = 'SH'
					)

	Update	#AR_Bulk
	Set		Message = 'The Invoice Interface cannot process SlsInvceHdrID: ' + convert(varchar,EntityID) + '. (Is it in SENT Status? Has it already FED?) '
	From	#AR_Bulk
	Where	Not Exists	(
						Select	1
						From	dbo.SalesInvoiceHeader (NoLock)
						Where	SlsInvceHdrStts = 'S'
						And		SlsInvceHdrFdDte Is Null
						And		SlsInvceHdrID = #AR_Bulk.EntityID
						)


	Update	CustomMessageQueue
	Set		RAProcessed			= 1
			,RAProcessedDate	= GetDate()
			,HasErrored			= 0
			,Error				= Message
			,Reprocess			= 0
	From	#AR_Bulk
			Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AR_Bulk.ID
	Where	Message is not null

	Delete	#AR_Bulk
	Where	Message is not null

	-- Now, we call the Custom_Interface_AD_Mapping proc
	if exists (select 1 from #AR_Bulk)
	begin
		Exec dbo.Custom_Interface_AD_Mapping	@i_ID				= -1
												,@i_MessageID		= -1
												,@vc_Source			= 'SH'
												,@c_ReturnToInvoice	= 'N'
												,@c_OnlyShowSQL		= 'N'


	-- Finally, do the aggregation for the CustomInvoiceInterface table
			Create Table	#AR_Interface
					(
						ID								int				Identity 
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
						,Currency						char(3)			Null
					)


					
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
					Select	Case When IsTax = 1 then 'T' else 'D' end
							,InterfaceMessageID																-- MessageQueueID
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
							,Case When IsNull(FinanceSecurity,'') <> '' Then 'L' Else 'N' End				-- PaymentMethod			JPW - Double Check this Value
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
							,Left(TrnsctnTypDesc,50)														-- TransactionDescription										
							,Vhcle																			-- Vehicle
							,MvtHdrTypName																	-- CarrierMode			
							,NULL																			-- ParentInvoiceDate		NA
							,InvoiceParentInvoiceNumber														-- ParentInvoiceNumber	
							,ReceiptRefundFlag																-- ReceiptRefundFlag		NA
							,Case When AcctDtlSrceTble in ('TT', 'I') Then 'NA' Else MvtDcmntExtrnlDcmntNbr end		-- BL 
							,XRefTrmCode																	-- PaymentTermCode
							,0																				-- UnitPrice				NA
							,InvoiceUOM																		-- UOM
							,Round(Abs(LocalValue),2)														-- AbsLocalValue
							,Round(Abs(NetValue),2)															-- AbsInvoiceValue
							,GLLineType																		-- LineType								
							,ProfitCenter																	-- ProfitCenter
							,''																				-- CostCenter
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
							,'A'																			-- InterfaceStatus
							,''																				-- InterfaceMessage	
							,Reversed
							,Currency					
					From	#AR_Bulk
							Inner Join CustomAccountDetail	(NoLock)
								on	CustomAccountDetail.InterfaceMessageID		= #AR_Bulk.ID
							Left Outer Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= IsNull(AcctDtlAcctCdeAcctCdeID, AccountCode.AcctCdeID)
									and		AccountCode.AcctCdeTpe	= 'P'
									)
					And		Not Exists	(
										Select	1
										From	AccountDetailAccountCode dupe (NoLock)
										Where	dupe.AcctDtlAcctCdeAcctDtlID	= CustomAccountDetail.AcctDtlID
										And		dupe.AcctDtlAcctCdeBlnceTpe		= AccountDetailAccountCode.AcctDtlAcctCdeBlnceTpe
										And		dupe.AcctDtlAcctCdeID			> AccountDetailAccountCode.AcctDtlAcctCdeID
										)
					And		Not Exists	(
										Select	1
										From	TransactionTypeGroup (NoLock)
												Inner Join TransactionGroup (NoLock)
													on	XGrpID	= XTpeGrpXGrpID
										Where	XGrpQlfr = 'Invoice Discount'
										and		CustomAccountDetail.TrnsctnTypID		= XTpeGrpTrnsctnTypID
										)

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
							,RunningNumber
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
					Select	Case When IsTax = 1 then 'T' else 'D' end
							,InterfaceMessageID																-- MessageQueueID
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
							,Case When IsNull(FinanceSecurity,'') <> '' Then 'L' Else 'N' End				-- PaymentMethod			JPW - Double Check this Value
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
							,'Discount'				-- TransactionType
							,'Discount'				-- TransactionDescription
							,999					-- RunningNumber
							,Vhcle																			-- Vehicle
							,MvtHdrTypName																	-- CarrierMode			
							,NULL																			-- ParentInvoiceDate		NA
							,InvoiceParentInvoiceNumber														-- ParentInvoiceNumber	
							,ReceiptRefundFlag																-- ReceiptRefundFlag		NA
							,Case When AcctDtlSrceTble in ('TT', 'I') Then 'NA' Else MvtDcmntExtrnlDcmntNbr end		-- BL 
							,XRefTrmCode																	-- PaymentTermCode
							,0																				-- UnitPrice				NA
							,InvoiceUOM																		-- UOM
							,Round(Abs(LocalValue),2)														-- AbsLocalValue
							,Round(Abs(NetValue),2)															-- AbsInvoiceValue
							,GLLineType																		-- LineType								
							,ProfitCenter																	-- ProfitCenter
							,''																				-- CostCenter
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
							,'A'																			-- InterfaceStatus
							,''																				-- InterfaceMessage	
							,Reversed
							,Currency					
					From	#AR_Bulk
							Inner Join CustomAccountDetail	(NoLock)
								on	CustomAccountDetail.InterfaceMessageID		= #AR_Bulk.ID
							Left Outer Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= IsNull(AcctDtlAcctCdeAcctCdeID, AccountCode.AcctCdeID)
									and		AccountCode.AcctCdeTpe	= 'P'
									)
					And		Not Exists	(
										Select	1
										From	AccountDetailAccountCode dupe (NoLock)
										Where	dupe.AcctDtlAcctCdeAcctDtlID	= CustomAccountDetail.AcctDtlID
										And		dupe.AcctDtlAcctCdeBlnceTpe		= AccountDetailAccountCode.AcctDtlAcctCdeBlnceTpe
										And		dupe.AcctDtlAcctCdeID			> AccountDetailAccountCode.AcctDtlAcctCdeID
										)
					And		Exists	(
									Select	1
									From	TransactionTypeGroup (NoLock)
											Inner Join TransactionGroup (NoLock)
												on	XGrpID	= XTpeGrpXGrpID
									Where	XGrpQlfr = 'Invoice Discount'
									and		CustomAccountDetail.TrnsctnTypID		= XTpeGrpTrnsctnTypID
									)

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
							,AcctDtlID																		-- AcctDtlID
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
					Select	'D'						-- InvoiceLevel	
							,MessageQueueID			-- MessageQueueID	
							,InterfaceSource		-- InterfaceSource
							,InvoiceGLDate			-- InvoiceGLDate
							,Case	When IsNull(GCTerm.GnrlCnfgMulti, 'N') = 'Y'
									Then dbo.Custom_Format_SAP_Date_String(SalesInvoiceHeader.SlsInvceHdrDscntDte)
									Else InvoiceDate End		-- InvoiceDate
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
							,#AR_Interface.AcctDtlID				-- AcctDtlID
							,FXConversionRate		-- FXConversionRate
							,InvoiceCurrency		-- InvoiceCurrency
							,Case When EstimatedDiscountValue > 0 Then 0 Else EstimatedDiscountValue end	-- InvoiceDebitValue  
							,Case When EstimatedDiscountValue < 0 Then 0 Else EstimatedDiscountValue end	-- InvoiceCreditValue
							,IntBAID				-- IntBAID
							,IntBACode				-- IntBACode
							,InvoiceNumber			-- InvoiceNumber
							,GCDiscount.GnrlCnfgMulti			-- Chart
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
							,'Discount'				-- TransactionType
							,'Discount'				-- TransactionDescription
							,CarrierMode			-- CarrierMode
							,ParentInvoiceNumber	-- ParentInvoiceNumber
							,Case	When #AR_Interface.ReceiptRefundFlag = 'AP'
									Then 'AR' Else 'AP' End					-- ReceiptRefundFlag
							,BL						-- BL
							,Case	When #AR_Interface.LineType = 40
									Then 50 Else 40 End							-- LineType
							,DealNumber				-- DealNumber
							,DealDetailID			-- DealDetailID

							,Abs(EstimatedDiscountValue)	-- AbsLocalValue
							,Abs(EstimatedDiscountValue)	-- AbsInvoiceValue

					-- select *
					From	#AR_Interface	(NoLock)
							Inner Join AccountDetail (NoLock)
								on	AccountDetail.AcctDtlID		= #AR_Interface.AcctDtlID
							Inner Join SalesInvoiceHeader (NoLock)
								on	AccountDetail.AcctDtlSlsInvceHdrID	= SalesInvoiceHeader.SlsInvceHdrID
							Left Outer Join GeneralConfiguration GCTerm (NoLock)
								on	GCTerm.GnrlCnfgTblNme		= 'Term'
								and	GCTerm.GnrlCnfgQlfr			= 'BaseOilDirectDebit'
								and	GCTerm.GnrlCnfgHdrID		= SalesInvoiceHeader.SlsInvceHdrTrmID
							Left Outer Join GeneralConfiguration GCDiscount (NoLock)
								on	GCDiscount.GnrlCnfgTblNme	= 'BusinessAssociate'
								and	GCDiscount.GnrlCnfgQlfr		= 'DiscountGLAccount'
								and	GCDiscount.GnrlCnfgHdrID	= #AR_Interface.IntBAID
							Inner Join AccountDetailEstimatedDate (NoLock)
								on	AccountDetailEstimatedDate.AcctDtlID					= #AR_Interface.AcctDtlID
								and	AccountDetailEstimatedDate.EstimatedDiscountValue		<> 0.0
					Where	#AR_Interface.InvoiceLevel			= 'D'
					And		(
							IsNull(GCTerm.GnrlCnfgMulti, 'N') = 'Y'
							or
							not exists	( -- excluding these 2 invoice types per defect 7924, unless GCTerm="Y"
										Select	1
										From	SalesInvoiceType (NoLock)
										Where	SalesInvoiceType.SlsInvceTpeID		= SalesInvoiceHeader.SlsInvceHdrSlsInvceTpeID
										And		SalesInvoiceType.SlsInvceTpeDscrptn	in ('3rd Party Product Sales Invoice', '3rd Party Product Bulk  Email')
										)
							)


					Update	#AR_Interface
					Set		InvoiceDate = dbo.Custom_Format_SAP_Date_String(SalesInvoiceHeader.SlsInvceHdrDscntDte)
					From	#AR_Interface
							Inner Join SalesInvoiceHeader (NoLock)
								on	#AR_Interface.InvoiceID		= SalesInvoiceHeader.SlsInvceHdrID
					Where	Exists	(
									Select	1
									From	#AR_Interface Sub
											Inner Join SalesInvoiceHeader SIHSub (NoLock)
												on	Sub.InvoiceID											= SIHSub.SlsInvceHdrID
											Inner Join GeneralConfiguration GCTerm (NoLock)
												on	GCTerm.GnrlCnfgTblNme									= 'Term'
												and	GCTerm.GnrlCnfgQlfr										= 'BaseOilDirectDebit'
												and	GCTerm.GnrlCnfgHdrID									= SIHSub.SlsInvceHdrTrmID
											Inner Join AccountDetailEstimatedDate (NoLock)
												on	AccountDetailEstimatedDate.AcctDtlID					= Sub.AcctDtlID
												and	AccountDetailEstimatedDate.EstimatedDiscountValue		<> 0.0
									Where	Sub.MessageQueueID				= #AR_Interface.MessageQueueID
									And		(
											IsNull(GCTerm.GnrlCnfgMulti, 'N') = 'Y'
											or
											not exists	( -- excluding these 2 invoice types per defect 7924, unless GCTerm="Y"
														Select	1
														From	SalesInvoiceType (NoLock)
														Where	SalesInvoiceType.SlsInvceTpeID		= SIHSub.SlsInvceHdrSlsInvceTpeID
														And		SalesInvoiceType.SlsInvceTpeDscrptn	in ('3rd Party Product Sales Invoice', '3rd Party Product Bulk  Email')
														)
											)
									)



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
					Select	'H'						-- InvoiceLevel
							,MessageQueueID			-- MessageQueueID
							,InterfaceSource		-- InterfaceSource
							,InvoiceGLDate			-- InvoiceGLDate
							,min(InvoiceDate)		-- InvoiceDate
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


					Update	#AR_Interface
					Set		LineType			=	CustomAccountDetail. InvoiceLineType
							,ReceiptRefundFlag	=	Case
														When	CustomAccountDetail. InvoiceAmount	>= 0	Then 'AR'	
														Else	'AP'
													End
					From	#AR_Interface					(NoLock)
							Inner Join	CustomAccountDetail	(NoLock)
								On	#AR_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID
					Where	#AR_Interface. InvoiceLevel				= 'H'


					Update	#AR_Interface
					Set		Chart = AcctDtlAcctCdeCde
					From	#AR_Interface (NoLock)
							Inner Join	CustomAccountDetail	(NoLock)
								On	#AR_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID
							Inner Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= AcctDtlAcctCdeAcctCdeID
									and		AccountCode.AcctCdeTpe	= 'O'
									)
					And		#AR_Interface. InvoiceLevel				= 'H'


					
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
							Inner Join	#AR_Interface	Detail	(NoLock)
								On	Header. InterfaceInvoiceID	= Detail. InterfaceInvoiceID
					Where	Header. InvoiceLevel	= 'H'
					And		Detail. InvoiceLevel	= 'D'
					And		Detail. HighestValue	= 'Y'



					
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
							Inner Join	#AR_Interface	Tax		(NoLock)
								On	Header. InterfaceInvoiceID	= Tax. InterfaceInvoiceID
					Where	Header. InvoiceLevel	= 'H'
					And		Tax. InvoiceLevel		= 'T'

					Update	#AR_Interface
					Set		PerUnitPrice	=	Abs(Case When Quantity <> 0
												Then ( (IsNull(InvoiceDebitValue,0) + IsNull(InvoiceCreditValue,0)) / Quantity )
												Else	0.0
												End)



					Update	#AR_Interface							
					Set		AbsLocalValue		= Abs(LocalDebitValue + LocalCreditValue)
							,AbsInvoiceValue	= Abs(InvoiceDebitValue + InvoiceCreditValue)
					Where	#AR_Interface. InvoiceLevel	In ('H','T')


					Update	#AR_Interface
					Set		TransactionDescription	= Substring(IsNull((Select	(	Select	Distinct '; ' +  CustomAccountDetail. TrnsctnTypDesc
																				From	CustomAccountDetail	(NoLock)
																				Where	CustomAccountDetail. InterfaceInvoiceID	= #AR_Interface.InterfaceInvoiceID
																				And		IsNull(CustomAccountDetail. TrnsctnTypDesc, '')	<> ''
																				FOR XML PATH('') ) As Details), ''), 3, 50) 						
					Where	#AR_Interface. InvoiceLevel	= 'H'



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
								,getdate()									-- CreationDate
								,0											-- MessageBusConfirmed	 
						From	#AR_Interface	(NoLock)
						Order By MessageQueueID Asc, AbsInvoiceValue Desc
			
						---------------------------------------------------------------------------------------------------------------------
						-- Check for Errors on the Insert
						----------------------------------------------------------------------------------------------------------------------
						If	@@error <> 0
							Begin
								Rollback Transaction InsertAR

									Update	CustomMessageQueue
									Set		RAProcessed			= 1
											,RAProcessedDate	= GetDate()
											,HasErrored			= 1
											,Error				= 'The AR Interface encountered an error inserting a record into the CustomInvoiceInterface table.' 
											,Reprocess			= 0
									From	#AR_Bulk
											Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AR_Bulk.ID
							End						

						----------------------------------------------------------------------------------------------------------------------------------
						-- Commit the Transaction
						----------------------------------------------------------------------------------------------------------------------------------
						Commit Transaction InsertAR

						Update	CustomMessageQueue
						Set		RAProcessed			= 1
								,RAProcessedDate	= GetDate()
								,HasErrored			= 0
								,Error				= NULL
								,Reprocess			= 0
						From	#AR_Bulk
								Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AR_Bulk.ID

						If	Object_ID('TempDB..#AR_Interface') Is Not Null
							Drop Table #AR_Interface
						If	Object_ID('TempDB..#AR_Bulk') Is Not Null
							Drop Table #AR_Bulk
		end
END


---------------------------------------------
-- Now, do the same for AP invoices
---------------------------------------------
if exists (select 1 from #AP_Bulk)
begin

	-- First set any errors where we can't process an invoice
	Update	#AP_Bulk
	Set		Message = case when PayableHeader.FedDate is not null
						then 'The invoice cannot be reprocessed because it has already been Fed.'
						when PayableHeader.Status = 'P'
						then 'The invoice cannot be reprocessed because it has already been Paid.'
						end
	From	#AP_Bulk
			Inner Join dbo.PayableHeader (NoLock)
				on	#AP_Bulk.EntityID		= PayableHeader.PybleHdrID
	Where	#AP_Bulk.Reprocess = 1


	Update	CustomMessageQueue
	Set		RAProcessed			= 1
			,RAProcessedDate	= GetDate()
			,HasErrored			= 0
			,Error				= Message
			,Reprocess			= 0
	From	#AP_Bulk
			Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AP_Bulk.ID
	Where	Message is not null

	Delete	#AP_Bulk
	Where	Message is not null

	-- Get rid of any old data when we're going to reprocess
	Delete	dbo.CustomAccountDetail
	From	#AP_Bulk
			Inner Join dbo.CustomAccountDetail
				on	InterfaceMessageID = #AP_Bulk.ID
	Where	#AP_Bulk.Reprocess = 1
		
	Delete	dbo.CustomInvoiceInterface
	From	#AP_Bulk
			Inner Join dbo.CustomInvoiceInterface
				on	MessageQueueID = #AP_Bulk.ID
	Where	#AP_Bulk.Reprocess = 1


	Update	#AP_Bulk
	Set		Message = 'The Invoice Interface has already processed PybleHdrID: ' + convert(varchar,EntityID) + '. (Does CAD Exist?) '
	From	#AP_Bulk
	Where	Exists	(
					Select	1
					From	dbo.CustomAccountDetail (NoLock)
					Where	RAInvoiceID		= #AP_Bulk.EntityID
					And		InterfaceSource	= 'PH'
					)

	Update	#AP_Bulk
	Set		Message = 'The Invoice Interface cannot process PybleHdrID: ' + convert(varchar,EntityID) + '. (Is status FEED? Has FedDate already set?) '
	From	#AP_Bulk
	Where	Not Exists	(
						Select	1
						From	dbo.PayableHeader (NoLock)
						Where	Status		= 'F'
						And		FedDate		Is Null
						And		PybleHdrID	= #AP_Bulk.EntityID
						)


	Update	CustomMessageQueue
	Set		RAProcessed			= 1
			,RAProcessedDate	= GetDate()
			,HasErrored			= 0
			,Error				= Message
			,Reprocess			= 0
	From	#AP_Bulk
			Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AP_Bulk.ID
	Where	Message is not null

	Delete	#AP_Bulk
	Where	Message is not null


	if exists (select 1 from #AP_Bulk)
	begin
		-- Call out to the AD_Mapping proc (-2 for bulk AP)
		Exec dbo.Custom_Interface_AD_Mapping	@i_ID				= -2
												,@i_MessageID		= -2
												,@vc_Source			= 'PH'
												,@c_ReturnToInvoice	= 'N'
												,@c_OnlyShowSQL		= 'N'


		-- Finally, do the aggregation for the CustomInvoiceInterface table
			Create Table	#AP_Interface
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
							,HighestValue					char(1)			Null	
							,IsTax							tinyint			Null			
							,InterfaceStatus				char(1)			Null
							,InterfaceMessage				varchar(2000)	Null
							,Reversed						char(1)			Null
							,Currency						char(3)			Null)

							Insert	#AP_Interface
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
							,HighestValue
							,IsTax
							,InterfaceStatus
							,InterfaceMessage
							,Reversed
							,Currency)	
					Select	Case When IsTax = 1 then 'T' else 'D' end
							,InterfaceMessageID																-- MessageQueueID
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
							,Case When IsNull(FinanceSecurity,'') <> '' Then 'L' Else 'N' End				-- PaymentMethod			JPW - Double Check this Value
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
							,Left(TrnsctnTypDesc,50)														-- TransactionDescription										
							,Vhcle																			-- Vehicle
							,MvtHdrTypName																	-- CarrierMode			
							,NULL																			-- ParentInvoiceDate		NA
							,InvoiceParentInvoiceNumber														-- ParentInvoiceNumber	
							,ReceiptRefundFlag																-- ReceiptRefundFlag		NA
							,Case When AcctDtlSrceTble = 'TT' Then 'NA' Else MvtDcmntExtrnlDcmntNbr end		-- BL 
							,XRefTrmCode																	-- PaymentTermCode
							,0																				-- UnitPrice				NA
							,InvoiceUOM																		-- UOM
							,Round(Abs(LocalValue),2)														-- AbsLocalValue
							,Round(Abs(NetValue),2)															-- AbsInvoiceValue
							,GLLineType																		-- LineType								
							,''																				-- ProfitCenter
							,CostCenter																		-- CostCenter
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
							,HighestValue																	-- HighestValue
							,IsTax																			-- IsTax		
							,'A'																			-- InterfaceStatus
							,''																				-- InterfaceMessage
							,Reversed																		-- Reversed	
							,Currency		
					From	#AP_Bulk
							Inner Join CustomAccountDetail	(NoLock)
								on	CustomAccountDetail.InterfaceMessageID		= #AP_Bulk.ID
							Left Outer Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= IsNull(AcctDtlAcctCdeAcctCdeID, AccountCode.AcctCdeID)
									and		AccountCode.AcctCdeTpe	= 'P'
									)
					And		Not Exists	(
										Select	1
										From	AccountDetailAccountCode dupe (NoLock)
										Where	dupe.AcctDtlAcctCdeAcctDtlID	= CustomAccountDetail.AcctDtlID
										And		dupe.AcctDtlAcctCdeBlnceTpe		= AccountDetailAccountCode.AcctDtlAcctCdeBlnceTpe
										And		dupe.AcctDtlAcctCdeID			> AccountDetailAccountCode.AcctDtlAcctCdeID
										)




					Insert	#AP_Interface
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
							,InterfaceStatus
							,InterfaceMessage)	
					Select	'H'						-- InvoiceLevel	
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
							,min(UOM)				-- UOM
							,InterfaceStatus		-- InterfaceStatus
							,InterfaceMessage		-- InterfaceMessage
					From	#AP_Interface	(NoLock)
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
								,InterfaceStatus
								,InterfaceMessage


					Update	#AP_Interface
					Set		LineType			=	CustomAccountDetail. InvoiceLineType
							,ReceiptRefundFlag	=	Case
														When	CustomAccountDetail. InvoiceAmount	>= 0	Then 'AP'	
														Else	'AR'
													End
					From	#AP_Interface					(NoLock)
							Inner Join	CustomAccountDetail	(NoLock)
								On	#AP_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID 	
					Where	#AP_Interface. InvoiceLevel				= 'H'


					Update	#AP_Interface
					Set		Chart = AcctDtlAcctCdeCde
					From	#AP_Interface (NoLock)
							Inner Join	CustomAccountDetail	(NoLock)
								On	#AP_Interface. InterfaceInvoiceID	= CustomAccountDetail. InterfaceInvoiceID
							Inner Join AccountDetailAccountCode (NoLock)
								on	AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID = CustomAccountDetail.AcctDtlID
					Where	Exists (
									Select	1
									From	AccountCode (NoLock)
									Where	AccountCode.AcctCdeID	= AcctDtlAcctCdeAcctCdeID
									and		AccountCode.AcctCdeTpe	= 'O'
									)
					And		#AP_Interface. InvoiceLevel				= 'H'


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
					From	#AP_Interface				Header	(NoLock)
							Inner Join	#AP_Interface	Detail	(NoLock)
								On	Header. InterfaceInvoiceID	= Detail. InterfaceInvoiceID
					Where	Header. InvoiceLevel	= 'H'
					And		Detail. InvoiceLevel	= 'D'
					And		Detail. HighestValue	= 'Y'			 	


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
					From	#AP_Interface				Header	(NoLock)
							Inner Join	#AP_Interface	Tax		(NoLock)	On	Header. InterfaceInvoiceID	= Tax. InterfaceInvoiceID
					Where	Header. InvoiceLevel	= 'H'
					And		Tax. InvoiceLevel		= 'T'		 	



					Update	#AP_Interface
					Set		PerUnitPrice	=	Abs(Case When Quantity <> 0
													Then ( (IsNull(InvoiceDebitValue,0) + IsNull(InvoiceCreditValue,0)) / Quantity )
													Else	0.0
												End)


					Update	#AP_Interface							
					Set		AbsLocalValue		= Abs(LocalDebitValue + LocalCreditValue)
							,AbsInvoiceValue	= Abs(InvoiceDebitValue + InvoiceCreditValue)
					Where	#AP_Interface. InvoiceLevel	In ('H','T')


					Update	#AP_Interface							
					Set		TransactionDescription	= Substring(IsNull((Select	(	Select	Distinct '; ' +  CustomAccountDetail. TrnsctnTypDesc
																				From	CustomAccountDetail	(NoLock)
																				Where	CustomAccountDetail. InterfaceInvoiceID	=  #AP_Interface.InterfaceInvoiceID
																				And		IsNull(CustomAccountDetail. TrnsctnTypDesc, '')	<> ''
																				FOR XML PATH('') ) As Details), ''), 3, 50) 						
					Where	#AP_Interface. InvoiceLevel	= 'H'



			Begin Transaction InsertAP

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
						,MaterialGroup			
						,DealType			
						,DealNumber		
						,DealDetailID
						,TransferID					
						,OrderID
						,OrderBatchID
						,Plant				
						,StorageLocation								
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
						,IsNull(MaterialGroup,'')					-- MaterialGroup			
						,IsNull(DealType,'')						-- DealType			
						,IsNull(DealNumber,'')						-- DealNumber		
						,DealDetailID								-- DealDetailID
						,TransferID									-- TransferID					
						,OrderID									-- OrderID
						,OrderBatchID								-- OrderBatchID
						,IsNull(Plant,'')							-- Plant				
						,IsNull(StorageLocation,'')					-- StorageLocation							
						,InterfaceStatus							-- InterfaceStatus
						,RTrim(LTrim(IsNull(InterfaceMessage,'')))	-- InterfaceMessage
						,NULL										-- ApprovalUserID
						,NULL										-- ApprovalDate
						,getdate()									-- CreationDate
						,0											-- MessageBusConfirmed	 
				From	#AP_Interface	(NoLock)
				Order By MessageQueueID Asc, AbsInvoiceValue Desc
			
				---------------------------------------------------------------------------------------------------------------------
				-- Check for Errors on the Insert
				----------------------------------------------------------------------------------------------------------------------
				If	@@error <> 0 
					Begin
						Rollback Transaction InsertAP
					
						Update	CustomMessageQueue
						Set		RAProcessed			= 1
								,RAProcessedDate	= GetDate()
								,HasErrored			= 1
								,Error				= 'The AP Interface encountered an error inserting a record into the CustomInvoiceInterface table.' 
								,Reprocess			= 0
						From	#AP_Bulk
								Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AP_Bulk.ID
					End						

				----------------------------------------------------------------------------------------------------------------------------------
				-- Commit the Transaction
				----------------------------------------------------------------------------------------------------------------------------------
				Commit Transaction InsertAP

				Update	CustomMessageQueue
				Set		RAProcessed			= 1
						,RAProcessedDate	= GetDate()
						,HasErrored			= 0
						,Error				= NULL
						,Reprocess			= 0
				From	#AP_Bulk
						Inner Join dbo.CustomMessageQueue on CustomMessageQueue.ID = #AP_Bulk.ID


				If	Object_ID('TempDB..#AP_Interface') Is Not Null
					Drop Table #AP_Interface
				If	Object_ID('TempDB..#AP_Bulk') Is Not Null
					Drop Table #AP_Bulk

		end			
end													 														




if exists (select 1 from #GL_Bulk)
begin
	declare @i_ID int
	declare @i_Reprocess int
	select @i_ID = min(ID) From #GL_Bulk

	---------------------------------------------
	-- While you have one to process try looping
	---------------------------------------------
	While IsNull(@i_ID, 0) > 0
	begin
		select @i_Reprocess = Reprocess From #GL_Bulk Where ID = @i_ID
		execute Custom_Interface_GL_Outbound @i_ID, @i_Reprocess

		delete #GL_Bulk Where ID = @i_ID
		select @i_ID = min(ID) From #GL_Bulk
	end
end

---------------------------------------------
-- Check the process back in for next time
---------------------------------------------
if object_id('tempdb..#CMQtoProcess') is not null
	Drop Table #CMQtoProcess
if object_id('tempdb..#AR_Bulk') is not null
	Drop Table #AR_Bulk
if object_id('tempdb..#AP_Bulk') is not null
	Drop Table #AP_Bulk
if object_id('tempdb..#GL_Bulk') is not null
	Drop Table #GL_Bulk

exec dbo.sra_checkin_process 'CustomMessageQueueProcessor'

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Message_Queue_BulkProcessor') Is NOT Null
BEGIN
	PRINT '<<< Granted Rights on PROC dbo.Custom_Message_Queue_BulkProcessor >>>'
	Grant Execute on dbo.Custom_Message_Queue_BulkProcessor to SYSUSER
	Grant Execute on dbo.Custom_Message_Queue_BulkProcessor to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Message_Queue_BulkProcessor >>>'
GO