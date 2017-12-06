IF OBJECT_ID('dbo.tu_Custom_PayableHeader') IS NOT NULL
BEGIN
    DROP Trigger dbo.tu_Custom_PayableHeader
    PRINT '<<< DROPPED TRIGGER dbo.tu_Custom_PayableHeader >>>'
END
GO

Create trigger dbo.tu_Custom_PayableHeader on dbo.PayableHeader for UPDATE 
As
---------------------------------------------------------------------------------------------------------------------
-- Trigger:		tu_Custom_PayableHeader	
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
-- If we're setting the invoice back to Held then get rid of our CustomAccountDetails & CustomInvoiceInterface records
----------------------------------------------------------------------------------------------------------------------
if exists (select 1 from Inserted, Deleted where Inserted.PybleHdrID = Deleted.PybleHdrID and Deleted.Status = 'F' and Inserted.Status <> 'F')
begin

	Delete	CustomAccountDetail
	From	Deleted
			Inner Join CustomAccountDetail
				on	CustomAccountDetail.InterfaceSource	= 'PH'
				And	CustomAccountDetail.RAInvoiceID = Deleted.PybleHdrID

	Delete	CustomInvoiceInterface
	From	Deleted
			Inner Join CustomInvoiceInterface
				on	CustomInvoiceInterface.InterfaceSource	= 'PH'
				And	CustomInvoiceInterface.InvoiceID = Deleted.PybleHdrID

	Delete	CustomMessageQueue
	From	Deleted
			Inner Join CustomMessageQueue
				on	CustomMessageQueue.Entity	= 'PH'
				and	CustomMessageQueue.EntityID	= Deleted.PybleHdrID

end

----------------------------------------------------------------------------------------------------------------------
-- If we have not fed the invoice before insert a new Queue message, else just update the message to reprocess
----------------------------------------------------------------------------------------------------------------------	
If	Not Exists	(Select 'X' From CustomMessageQueue Inner Join Inserted On CustomMessageQueue. EntityId = Inserted. PybleHdrID And CustomMessageQueue. Entity = 'PH')
	Begin
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
				Inner Join	Deleted								On	Inserted. PybleHdrID				= Deleted. PybleHdrID	
				Left Outer Join	CustomInvoiceLog	(NoLock)	On	Inserted. PybleHdrID				= CustomInvoiceLog. InvoiceID	
																	And	CustomInvoiceLog. InvoiceType	= 'PH'					
		Where	Inserted. Status		= 'F'
		And		Deleted. Status			<> 'F'
		And		Inserted. FedDate		Is Null
		And		Not Exists	(	Select	'X'
								From	CustomMessageQueue
								Where	Entity			= 'PH'
								And		EntityId		= Inserted. PybleHdrID)
	End
Else
	Begin
		Update	CustomMessageQueue
		Set		 EntityID2					= CustomInvoiceLog.ID
				,Reprocess					= 1
				,RAProcessed				= 0
				,RAProcessedDate			= NULL
				,MessageBusProcessed		= 0
				,MessageBusProcessedDate	= NULL
				,MessageBusConfirmed		= 0
				,HasErrored					= 0
				,Error						= NULL
		From	CustomMessageQueue
				Inner Join	Inserted				On	CustomMessageQueue. EntityId	= Inserted. PybleHdrID
													And	CustomMessageQueue. Entity		= 'PH'	
				Inner Join	Deleted					On	Inserted. PybleHdrID			= Deleted. PybleHdrID
				Left Outer Join CustomInvoiceLog
						on	Inserted.PybleHdrID				= CustomInvoiceLog.InvoiceID
						and	CustomInvoiceLog.InvoiceType	= 'PH'
		Where	Inserted. Status			= 'F'
		And		Deleted. Status				<> 'F'
		And		Inserted. FedDate			Is Null		
	End									
						
----------------------------------------------------------------------------------------------------------------------
-- If the user updated the invoice number update the Message Queue
----------------------------------------------------------------------------------------------------------------------							
If	Update(InvoiceNumber)
	Update	CustomMessageQueue
	Set		EntityDescription	= Inserted. InvoiceNumber
	From	CustomMessageQueue		(NoLock)	
			Inner Join	Inserted	(NoLock)	On	CustomMessageQueue. EntityId	= Inserted. PybleHdrID
												And	CustomMessageQueue. Entity	= 'PH'	 
	Where	IsNull(Inserted. InvoiceNumber,'')	<> IsNull(CustomMessageQueue. EntityDescription,'')
	
GO

IF OBJECT_ID('dbo.tu_Custom_PayableHeader') IS NOT NULL
BEGIN
    PRINT '<<< CREATED TRIGGER dbo.tu_Custom_PayableHeader >>>'
END
GO


