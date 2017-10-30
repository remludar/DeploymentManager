-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomInvoiceLog       Copyright 2003 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     28/01/2013 - First Created 
--
-- Date         Modified By  Issue#  Modification
-- -----------  -----------  ------  -----------------------------------------------------------------------------
-- 
------------------------------------------------------------------------------------------------------------------
If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceLog') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomInvoiceLog
	End

Go

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceLog') And OBJECTPROPERTY(id, N'IsUserTable') = 1)

	Begin   
	
		Create Table	dbo.CustomInvoiceLog
						(ID					int				Identity
						,InvoiceID			int				Null
						,InvoiceType		char(2)			Null
						,UserID				int				Null
						,CreationDate		smalldatetime	Null)  On 'Default'

		Execute SRA_Index_Check		@s_table 		= 'CustomInvoiceLog', 
									@s_index		= 'PK_CustomInvoiceLog',
									@s_keys			= 'ID',
									@c_unique		= 'Y',
									@c_clustered	= 'Y',
									@c_primarykey	= 'Y',
									@c_uniquekey	= 'Y',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'
									
		Execute SRA_Index_Check		@s_table 		= 'CustomInvoiceLog', 
									@s_index		= 'AK1_CustomInvoiceLog',
									@s_keys			= 'InvoiceID, InvoiceType',
									@c_unique		= 'N',
									@c_clustered	= 'N',
									@c_primarykey	= 'N',
									@c_uniquekey	= 'N',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'	
									
		Execute SRA_Index_Check		@s_table 		= 'CustomInvoiceLog', 
									@s_index		= 'AK2_CustomInvoiceLog',
									@s_keys			= 'UserID',
									@c_unique		= 'N',
									@c_clustered	= 'N',
									@c_primarykey	= 'N',
									@c_uniquekey	= 'N',
									@c_build_index	= 'Y',
									@vc_domain		= 'BusinessData'											
																			

	End
GO
IF	EXISTS(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceLog') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		Grant Select On dbo.CustomInvoiceLog To RightAngleAccess
		Grant Insert On dbo.CustomInvoiceLog To RightAngleAccess
		Grant Update On dbo.CustomInvoiceLog To RightAngleAccess
		Grant Delete On dbo.CustomInvoiceLog To RightAngleAccess
	END
Go	

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	@i_SlsInvceHdrID	int

----------------------------------------------------------------------------------------------------------------------
-- Loop through the payables in the buffer
----------------------------------------------------------------------------------------------------------------------
Select	@i_SlsInvceHdrID	= Min(SlsInvceHdrID)
From	SalesInvoiceHeader	(NoLock)

While	@i_SlsInvceHdrID	Is Not Null
		Begin
			
			----------------------------------------------------------------------------------------------------------------------
			-- Insert a record into the creation log
			----------------------------------------------------------------------------------------------------------------------				
			Insert	CustomInvoiceLog
					(InvoiceID
					,InvoiceType
					,UserID
					,CreationDate)
			Select	SalesInvoiceHeader. SlsInvceHdrID
					,'SH'
					,1
					,SalesInvoiceHeader. SlsInvceHdrCrtnDte	
			From	SalesInvoiceHeader	(NoLock)
			Where	SalesInvoiceHeader. SlsInvceHdrID	= @i_SlsInvceHdrID			
			
			----------------------------------------------------------------------------------------------------------------------
			-- Loop to the next payable
			----------------------------------------------------------------------------------------------------------------------																			
			Select	@i_SlsInvceHdrID	= Min(SlsInvceHdrID)
			From	SalesInvoiceHeader	(NoLock)
			Where	SlsInvceHdrID		> @i_SlsInvceHdrID								
							
		End
		
Go

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	@i_PybleHdrID		int

----------------------------------------------------------------------------------------------------------------------
-- Loop through the payables in the buffer
----------------------------------------------------------------------------------------------------------------------
Select	@i_PybleHdrID	= Min(PybleHdrID)
From	PayableHeader	(NoLock)

While	@i_PybleHdrID	Is Not Null
		Begin
		
			----------------------------------------------------------------------------------------------------------------------
			-- Insert an entry into the log table
			----------------------------------------------------------------------------------------------------------------------
			Insert	CustomInvoiceLog
					(InvoiceID
					,InvoiceType
					,UserID
					,CreationDate)
			Select	 PayableHeader. PybleHdrID
					,'PH'
					,PayableHeader. CreatedUserID
					,PayableHeader. CreatedDate					
			From	PayableHeader	(NoLock)
			Where	PayableHeader. PybleHdrID	= @i_PybleHdrID		
																							
			----------------------------------------------------------------------------------------------------------------------
			-- Loop to the next payable
			----------------------------------------------------------------------------------------------------------------------																			
			Select	@i_PybleHdrID	= Min(PybleHdrID)
			From	PayableHeader	(NoLock)
			Where	PybleHdrID		> @i_PybleHdrID								
							
		End				