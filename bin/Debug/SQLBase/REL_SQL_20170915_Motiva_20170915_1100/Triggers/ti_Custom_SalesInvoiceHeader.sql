IF OBJECT_ID('dbo.ti_Custom_SalesInvoiceHeader') IS NOT NULL
BEGIN
    DROP Trigger dbo.ti_Custom_SalesInvoiceHeader
    PRINT '<<< DROPPED TRIGGER dbo.ti_Custom_SalesInvoiceHeader >>>'
END
GO

Create trigger dbo.ti_Custom_SalesInvoiceHeader on dbo.SalesInvoiceHeader for INSERT 
As
---------------------------------------------------------------------------------------------------------------------
-- Trigger:		ti_Custom_SalesInvoiceHeader	
-- Overview:    
-- SPs:		
-- Created by:	Joshua Weber
-- History:		
--
-- Date         Modified By  Issue#     Modification
-- -----------  -----------  ---------  --------------------------------------------------------------------------
-- 	
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	@i_SlsInvceHdrID	int
		,@i_UserID			int

----------------------------------------------------------------------------------------------------------------------
-- Identify the user from their session
----------------------------------------------------------------------------------------------------------------------							
Select	@i_UserID = UserID
From	Users	(NoLock)
Where	Users. UserDBMnkr	= host_name()

----------------------------------------------------------------------------------------------------------------------
-- Loop through the payables in the buffer
----------------------------------------------------------------------------------------------------------------------
Select	@i_SlsInvceHdrID	= Min(SlsInvceHdrID)
From	Inserted	(NoLock)

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
			Select	@i_SlsInvceHdrID
					,'SH'
					,IsNull(@i_UserID,1)
					,GetDate()	
					
			----------------------------------------------------------------------------------------------------------------------
			-- Default the Internal Contact ID
			----------------------------------------------------------------------------------------------------------------------						
			/*
			Update	SalesInvoiceHeader
			Set		InternalCntctID	= AccntngPrfleCntctID
			From	SalesInvoiceHeader				(NoLock)
					Inner Join	AccountingProfile	(NoLock)	On	SalesInvoiceHeader. SlsInvceHdrIntrnlBAID	= AccountingProfile. InternalBAID 		
																And	AccountingProfile. AccntngPrfleInvceTpe		= 'S'			
			Where	SalesInvoiceHeader. SlsInvceHdrID	= @i_SlsInvceHdrID	
			*/	
			
			----------------------------------------------------------------------------------------------------------------------
			-- Populate the custom invoice tables
			----------------------------------------------------------------------------------------------------------------------			
			/*
			Execute dbo.Custom_Retrieve_Invoice_Properties	@i_SlsInvceHdrID = @i_SlsInvceHdrID
															,@c_OnlyShowSQL	 = 'N'
			*/
			
			----------------------------------------------------------------------------------------------------------------------
			-- Insert a Message for the Sales Invoice Creation
			----------------------------------------------------------------------------------------------------------------------
			Insert	CustomMessageQueue
					(Entity
					,EntityId
					,EntityID2
					,EntityDescription
					,EntityAction
					,CreationDate)
			Select	'SH'
					,Inserted. SlsInvceHdrID
					,CustomInvoiceLog. ID 
					,Inserted. SlsInvceHdrNmbr
					,'Insert'
					,GetDate()
			From	Inserted
					Left Outer Join	CustomInvoiceLog	(NoLock)	On	Inserted. SlsInvceHdrID			= CustomInvoiceLog. InvoiceID	
																	And	 CustomInvoiceLog. InvoiceType	= 'SH'	 			
			Where	Not Exists	(	Select	'X'
									From	CustomMessageQueue
									Where	Entity			= 'SH'
									And		EntityId		= Inserted. SlsInvceHdrID)				
				
			----------------------------------------------------------------------------------------------------------------------
			-- Loop to the next payable
			----------------------------------------------------------------------------------------------------------------------																			
			Select	@i_SlsInvceHdrID	= Min(SlsInvceHdrID)
			From	Inserted	(NoLock)
			Where	SlsInvceHdrID		> @i_SlsInvceHdrID								
							
		End
  
GO

IF OBJECT_ID('dbo.ti_Custom_SalesInvoiceHeader') IS NOT NULL
BEGIN
    PRINT '<<< CREATED TRIGGER dbo.ti_Custom_SalesInvoiceHeader >>>'
END
GO

