-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomPaymentInterface       Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     28/01/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomPaymentInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomPaymentInterface
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomPaymentInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomPaymentInterface
						(ID							int				Not Null
						,InterfaceFileName			varchar(80)		Null
						,InterfaceFileSource		varchar(10)		Null
						,DocumentPostingDate		varchar(25)		Null
						,PostingDate				smalldatetime	Null	--
						,LedgerAccount				varchar(80)		Null
						,Assignment					varchar(25)		Null
						,DocumentDate				varchar(25)		Null
						,LocalCurrency				varchar(10)		Null
						,LocalDebitValue			varchar(20)		Null
						,LocalCreditValue			varchar(20)		Null						
						,ExtBAID					int				Null	--
						,CustomerNumber				varchar(25)		Null
						,VendorNumber				varchar(25)		Null			
						,FXConversionRate			varchar(20)		Null
						,DocumentCurrency			varchar(10)		Null
						,DocumentDebitValue			varchar(20)		Null
						,DocumentCreditValue		varchar(20)		Null
						,IntBAID					int				Null	--							
						,IntBACode					varchar(25)		Null
						,PaymentMethod				varchar(10)		Null
						,CheckNumber				varchar(50)		Null
						,DocumentPaymentDate		varchar(25)		Null
						,PaymentDate				smalldatetime	Null	--
						,ReversalPostingDate		varchar(25)		Null
						,ReversalOriginalInvoice	varchar(25)		Null
						,ExportDate					varchar(25)		Null
						,DocumentNumber				varchar(20)		Null
						,LineNumber					varchar(10)		Null
						,FiscalYear					varchar(4)		Null
						,InterfaceStatus			char(1)			Null
						,InterfaceMessage			varchar(255)	Null
						,InterfaceInvoiceID			int				Null
						,CreationDate				smalldatetime	Null)  On 'Default'

		Execute SRA_Index_Check		@s_table 		= 'CustomPaymentInterface', 
									@s_index		= 'PK_CustomPaymentInterface',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
																	
		Execute SRA_Index_Check		@s_table 		= 'CustomPaymentInterface', 
									@s_index		= 'AK1_CustomPaymentInterface',
									@s_keys			= 'InterfaceInvoiceID',
									@c_unique		= 'N',
									@c_clustered	= 'N',
									@c_primarykey	= 'N',
									@c_uniquekey	= 'N',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'	
																				
																			

	End
GO
IF	EXISTS(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomPaymentInterface') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		Grant Select On dbo.CustomPaymentInterface To RightAngleAccess
		Grant Insert On dbo.CustomPaymentInterface To RightAngleAccess
		Grant Update On dbo.CustomPaymentInterface To RightAngleAccess
		Grant Delete On dbo.CustomPaymentInterface To RightAngleAccess
	END
Go