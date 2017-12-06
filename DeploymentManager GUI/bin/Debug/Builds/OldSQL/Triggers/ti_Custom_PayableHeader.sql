IF OBJECT_ID('dbo.ti_Custom_PayableHeader') IS NOT NULL
BEGIN
    DROP Trigger dbo.ti_Custom_PayableHeader
    PRINT '<<< DROPPED TRIGGER dbo.ti_Custom_PayableHeader >>>'
END
GO

Create trigger dbo.ti_Custom_PayableHeader on dbo.PayableHeader for INSERT 
As
---------------------------------------------------------------------------------------------------------------------
-- Trigger:		ti_Custom_PayableHeader	
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
Declare	@i_PybleHdrID		int

----------------------------------------------------------------------------------------------------------------------
-- Loop through the payables in the buffer
----------------------------------------------------------------------------------------------------------------------
Select	@i_PybleHdrID	= Min(PybleHdrID)
From	Inserted	(NoLock)

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
			Select	 Inserted. PybleHdrID
					,'PH'
					,Inserted. CreatedUserID
					,Inserted. CreatedDate					
			From	Inserted
			Where	PybleHdrID	= @i_PybleHdrID		
			
			----------------------------------------------------------------------------------------------------------------------
			-- Insert an entry into the CustomPayableInvoiceHeader table
			----------------------------------------------------------------------------------------------------------------------			
			/*
			Insert	CustomPayableInvoiceHeader
					(PybleHdrID)
			Select	 @i_PybleHdrID
			*/
							
			----------------------------------------------------------------------------------------------------------------------
			-- If the record is inserted with a Fed status stage Custom_Message_Queue
			----------------------------------------------------------------------------------------------------------------------				
			Insert	CustomMessageQueue
					(Entity
					,EntityID
					,EntityID2
					,EntityDescription
					,EntityAction
					,CreationDate)
			Select	'PH'
					,Inserted. PybleHdrID
					,CustomInvoiceLog. ID 
					,Inserted. InvoiceNumber
					,'Insert'
					,GetDate()
			From	Inserted
					Left Outer Join	CustomInvoiceLog	(NoLock)	On	Inserted. PybleHdrID			= CustomInvoiceLog. InvoiceID	
																	And	CustomInvoiceLog. InvoiceType	= 'PH'	 
			Where	Inserted. PybleHdrID	= @i_PybleHdrID 
			And		Inserted. Status		= 'F'
			And		Not Exists	(	Select	'X'
									From	CustomMessageQueue
									Where	Entity			= 'PH'
									And		EntityId		= Inserted. PybleHdrID)
																							
			----------------------------------------------------------------------------------------------------------------------
			-- Loop to the next payable
			----------------------------------------------------------------------------------------------------------------------																			
			Select	@i_PybleHdrID	= Min(PybleHdrID)
			From	Inserted	(NoLock)
			Where	PybleHdrID		> @i_PybleHdrID								
							
		End
  
GO

IF OBJECT_ID('dbo.ti_Custom_PayableHeader') IS NOT NULL
BEGIN
    PRINT '<<< CREATED TRIGGER dbo.ti_Custom_PayableHeader >>>'
END
GO