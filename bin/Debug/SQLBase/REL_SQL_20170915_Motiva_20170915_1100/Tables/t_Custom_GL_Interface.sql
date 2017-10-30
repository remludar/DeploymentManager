-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomGLInterface       Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     22/03/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomGLInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomGLInterface
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomGLInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomGLInterface
						(ID								int				Identity 
						
						,BatchID						int				Not Null
						,AccntngPrdID					int				Null
						,P_EODSnpShtID					int				Null
						,GLType							char(2)			Null
						,PostingDate					varchar(25)		Null
						,DocumentDate					varchar(25)		Null
						,Chart							varchar(80)		Null
						,LocalCurrency					char(3)			Null
						,LocalDebitValue				decimal(19,2)	Null	Default 0	
						,LocalCreditValue				decimal(19,2)	Null	Default 0
						,InvoiceID						int				Null
						,ExtBAID						int				Null
						,ExtBACustomerCode				varchar(25)		Null
						,Comments						varchar(2000)	Null
						,TransactionDate				varchar(25)		Null
						,Quantity						decimal(19,6)	Null
						,PerUnitPrice					decimal(19,6)	Null	Default 0	
						,TaxCode						varchar(15)		Null
						,ProductCode					varchar(50)		Null	
						,FXConversionRate				decimal(28,13)	Null	Default 1.0	
						,DocumentCurrency				char(3)			Null
						,DocumentDebitValue				decimal(19,2)	Null	Default 0
						,DocumentCreditValue			decimal(19,2)	Null	Default 0
						,IntBAID						int				Null
						,IntBACode						varchar(25)		Null
						,InvoiceNumber					varchar(20)		Null 
						,AccountIndicator				varchar(15)		Null
						,TitleTransfer					varchar(150)	Null
						,Destination					varchar(150)	Null
						,TransactionType				varchar(80)		Null
						,Vehicle						varchar(50)		Null
						,CarrierMode					varchar(50)		Null
						,DocumentType					varchar(25)		Null
						,ExtBAVendorCode				varchar(25)		Null
						,BL								varchar(80)		Null
						,PaymentTermCode				varchar(20)		Null
						,UnitPrice						decimal(19,6)	Null	Default 0
						,UOM							varchar(20)		Null
						,AbsLocalValue					decimal(19,2)	Null	Default 0
						,LineType						varchar(3)		Null
						,ProfitCenter					varchar(80)		Null
						,CostCenter						varchar(80)		Null
						,AcctDtlID						int				Null
						,DealType						varchar(20)		Null
						,DealNumber						varchar(20)		Null
						,DealDetailID					smallint		Null
						,TransferID						int				Null
						,OrderID						int				Null
						,OrderBatchID					int				Null
						,AccrualReversed				char(1)			Null
						,PostingType					char(2)			Null
						,RiskID							int				Null
						,P_EODEstmtedAccntDtlID			int				Null
						,InterfaceStatus				char(1)			Null
						,InterfaceMessage				varchar(2000)	Null												
						,ApprovalUserID					int				Null
						,ApprovalDate					smalldatetime	Null
						,CreationDate					smalldatetime	Null
						,MessageBusProcessed			bit				Null	Default 0
						,MessageBusProcessedDate		smalldatetime	Null	
						,MessageBusConfirmed			bit				Null	Default 0
						,InterfaceFile					varchar(80)		Null)  On 'Default'															

		Execute SRA_Index_Check		@s_table 		= 'CustomGLInterface', 
									@s_index		= 'PK_CustomGLInterface',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
									
		Execute SRA_Index_Check		@s_table		  = 'CustomGLInterface', 
									@s_index          = 'AK1_CustomGLInterface',
									@s_keys           = 'BatchID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'  								
																																																						
		Execute SRA_Index_Check		@s_table          = 'CustomGLInterface', 
									@s_index          = 'AK2_CustomGLInterface',
									@s_keys           = 'ExtBAID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData' 
									
		Execute SRA_Index_Check		@s_table          = 'CustomGLInterface', 
									@s_index          = 'AK3_CustomGLInterface',
									@s_keys           = 'IntBAID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'									 
						
		Execute SRA_Index_Check		@s_table          = 'CustomGLInterface', 
									@s_index          = 'AK4_CustomGLInterface',
									@s_keys           = 'AcctDtlID',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'  
																																	
		Execute SRA_Index_Check		@s_table          = 'CustomGLInterface', 
									@s_index          = 'AK5_CustomGLInterface',
									@s_keys           = 'InterfaceStatus',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'	
									
		Execute SRA_Index_Check		@s_table          = 'CustomGLInterface', 
									@s_index          = 'AK5_CustomGLInterface',
									@s_keys           = 'PostingType',
									@c_unique         = 'N',
									@c_clustered      = 'N',
									@c_primarykey     = 'N',
									@c_uniquekey      = 'N',
									@c_build_index    = 'Y',
									@vc_domain        = 'BusinessData'									
									
	End

Go

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomGLInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Grant Select On dbo.CustomGLInterface To RightAngleAccess
		Grant Insert On dbo.CustomGLInterface To RightAngleAccess
		Grant Update On dbo.CustomGLInterface To RightAngleAccess
		Grant Delete On dbo.CustomGLInterface To RightAngleAccess
	End
	
Go		


