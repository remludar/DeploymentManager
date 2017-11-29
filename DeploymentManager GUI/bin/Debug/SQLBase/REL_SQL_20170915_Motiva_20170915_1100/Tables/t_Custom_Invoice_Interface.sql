-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomInvoiceInterface       Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     22/03/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomInvoiceInterface
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomInvoiceInterface
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
						,DealType						varchar(20)		Null				
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
						,InterfaceStatus				char(1)			Null
						,InterfaceMessage				varchar(2000)	Null
						,ApprovalUserID					int				Null
						,ApprovalDate					smalldatetime	Null
						,CreationDate					smalldatetime	Null
						,MessageBusProcessed			bit				Null		default 0
						,MessageBusProcessedDate		smalldatetime	Null	
						,MessageBusConfirmed			bit				Not Null	Default 0
						,InterfaceFile					varchar(80)		Null
						)  On 'Default'															

		Execute SRA_Index_Check		@s_table 		= 'CustomInvoiceInterface', 
									@s_index		= 'PK_CustomInvoiceInterface',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
									
		Execute SRA_Index_Check		@s_table		  = 'CustomInvoiceInterface', 
									@s_index          = 'AK1_CustomInvoiceInterface',
									@s_keys           = 'MessageQueueID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'  								
																																													
		Execute SRA_Index_Check		@s_table          = 'CustomInvoiceInterface', 
									@s_index          = 'AK2_CustomInvoiceInterface',
									@s_keys           = 'InterfaceSource, InvoiceID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'  									
									
		Execute SRA_Index_Check		@s_table          = 'CustomInvoiceInterface', 
									@s_index          = 'AK3_CustomInvoiceInterface',
									@s_keys           = 'InterfaceSource, InvoiceID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'  
									
		Execute SRA_Index_Check		@s_table          = 'CustomInvoiceInterface', 
									@s_index          = 'AK4_CustomInvoiceInterface',
									@s_keys           = 'ExtBAID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'  
						
		Execute SRA_Index_Check		@s_table          = 'CustomInvoiceInterface', 
									@s_index          = 'AK5_CustomInvoiceInterface',
									@s_keys           = 'AcctDtlID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'  
																								
		Execute SRA_Index_Check		@s_table          = 'CustomInvoiceInterface', 
									@s_index          = 'AK6_CustomInvoiceInterface',
									@s_keys           = 'InterfaceSource',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'	
									
		Execute SRA_Index_Check		@s_table          = 'CustomInvoiceInterface', 
									@s_index          = 'AK7_CustomInvoiceInterface',
									@s_keys           = 'IntBAID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'
									
		Execute SRA_Index_Check		@s_table          = 'CustomInvoiceInterface', 
									@s_index          = 'AK8_CustomInvoiceInterface',
									@s_keys           = 'InterfaceStatus',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'																																			

	End

Go

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Grant Select On dbo.CustomInvoiceInterface To RightAngleAccess
		Grant Insert On dbo.CustomInvoiceInterface To RightAngleAccess
		Grant Update On dbo.CustomInvoiceInterface To RightAngleAccess
		Grant Delete On dbo.CustomInvoiceInterface To RightAngleAccess
	End
	
Go		

--sp_RENAME 'CustomInvoiceInterface.Credit', 'Chart' , 'COLUMN'