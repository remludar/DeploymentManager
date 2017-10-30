IF OBJECT_ID('dbo.tu_Custom_SalesInvoiceHeader') IS NOT NULL 
BEGIN
    DROP Trigger dbo.tu_Custom_SalesInvoiceHeader
    PRINT '<<< DROPPED TRIGGER dbo.tu_Custom_SalesInvoiceHeader >>>'
END
GO

Create trigger dbo.tu_Custom_SalesInvoiceHeader on dbo.SalesInvoiceHeader for UPDATE 
As

---------------------------------------------------------------------------------------------------------------------
-- Trigger:		tu_Custom_SalesInvoiceHeader	
-- Overview:    
-- SPs:		
-- Created by:	Joshua Weber
-- History:		28/01/2013
--
-- Date         Modified By  Issue#     Modification
-- -----------  -----------  ---------  --------------------------------------------------------------------------
-- 	
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Insert a Message Once the Invoice is Sent
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
		Inner Join	Deleted								On	Inserted. SlsInvceHdrID	= Deleted. SlsInvceHdrID
		Left Outer Join	CustomInvoiceLog	(NoLock)	On	Inserted. SlsInvceHdrID			= CustomInvoiceLog. InvoiceID	
														And	 CustomInvoiceLog. InvoiceType	= 'SH'	 			
Where	Inserted. SlsInvceHdrStts		= 'S'
And		Deleted. SlsInvceHdrStts		<> 'S'
And		Inserted. SlsInvceHdrFdDte		Is Null	
And		Not Exists	(	Select	'X'
						From	CustomMessageQueue
						Where	Entity			= 'SH'
						And		EntityId		= Inserted. SlsInvceHdrID)	
																				
Update	CustomMessageQueue
Set		EntityID2					= CustomInvoiceLog.ID
From	Inserted
		Inner Join CustomInvoiceLog
			on	Inserted.SlsInvceHdrID			= CustomInvoiceLog.InvoiceID
			and	CustomInvoiceLog.InvoiceType	= 'SH'
Where	CustomMessageQueue.EntityID		= Inserted.SlsInvceHdrID
and		CustomMessageQueue.EntityID2	is null

Update	CustomMessageQueue
Set		Reprocess					= 1
		,RAProcessed				= 0
		,RAProcessedDate			= NULL
		,MessageBusProcessed		= 0
		,MessageBusProcessedDate	= NULL
		,MessageBusConfirmed		= 0
		,HasErrored					= 0
		,Error						= NULL
From	Inserted
		Inner Join CustomInvoiceLog
			on	Inserted.SlsInvceHdrID			= CustomInvoiceLog.InvoiceID
			and	CustomInvoiceLog.InvoiceType	= 'SH'
Where	CustomMessageQueue.EntityID		= Inserted.SlsInvceHdrID
and		CustomMessageQueue.EntityID2	= CustomInvoiceLog.ID
and		CustomMessageQueue.RAProcessed	= 1

GO

IF OBJECT_ID('dbo.tu_Custom_SalesInvoiceHeader') IS NOT NULL
BEGIN
    PRINT '<<< CREATED TRIGGER dbo.tu_Custom_SalesInvoiceHeader >>>'
END
GO