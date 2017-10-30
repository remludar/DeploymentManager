IF OBJECT_ID('dbo.tu_CustomInvoiceInterface') IS NOT NULL 
BEGIN
    DROP Trigger dbo.tu_CustomInvoiceInterface
    PRINT '<<< DROPPED TRIGGER dbo.tu_CustomInvoiceInterface >>>'
END
GO

Create trigger dbo.tu_CustomInvoiceInterface on dbo.CustomInvoiceInterface for UPDATE 
As

---------------------------------------------------------------------------------------------------------------------
-- Trigger:		tu_CustomInvoiceInterface	
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
-- Mark the Sales Invoices to Fed when they are approved
----------------------------------------------------------------------------------------------------------------------
Update	SalesInvoiceHeader
Set		SlsInvceHdrFdDte	= GetDate()
From	SalesInvoiceHeader	(NoLock)
		Inner Join	Inserted	On	SalesInvoiceHeader. SlsInvceHdrID	= Inserted. InvoiceID
								And	Inserted. InterfaceSource			= 'SH'
								And	Inserted. InvoiceLevel				= 'H'
		Inner Join	Deleted		On	Inserted. ID						= Deleted. ID
Where	SalesInvoiceHeader. SlsInvceHdrFdDte	Is Null
And		SalesInvoiceHeader. SlsInvceHdrStts		= 'S'
And		Inserted. InterfaceStatus				= 'A'
And		Deleted. InterfaceStatus	 			<> 'A'

----------------------------------------------------------------------------------------------------------------------
-- Mark the Payable to Fed when they are approved
----------------------------------------------------------------------------------------------------------------------
Update	PayableHeader
Set		FedDate	= GetDate()
From	PayableHeader	(NoLock)
		Inner Join	Inserted	On	PayableHeader. PybleHdrID	= Inserted. InvoiceID
								And	Inserted. InterfaceSource	= 'PH'
								And	Inserted. InvoiceLevel		= 'H'
		Inner Join	Deleted		On	Inserted. ID				= Deleted. ID
Where	PayableHeader. FedDate		Is Null
And		PayableHeader. Status		= 'F'
And		Inserted. InterfaceStatus	= 'A'
And		Deleted. InterfaceStatus	 <> 'A'
																				

----------------------------------------------------------------------------------------------------------------------
-- Create the entry in the MTV Interface Tracking table
----------------------------------------------------------------------------------------------------------------------
Insert	MTVInvoiceInterfaceStatus (CIIMssgQID, InterfaceSource, InvoiceNumber)
Select	Inserted.MessageQueueID,
		Inserted.InterfaceSource,
		Inserted.InvoiceNumber
From	Inserted
		Inner Join	Deleted		On	Inserted. ID				= Deleted. ID
Where	Inserted.InvoiceLevel		= 'H'
And		Inserted. InterfaceStatus	= 'A'
And		Deleted. InterfaceStatus	 <> 'A'
And		Not Exists (Select 1 From MTVInvoiceInterfaceStatus sub Where sub.CIIMssgQID = Inserted.MessageQueueID)

GO

IF OBJECT_ID('dbo.tu_CustomInvoiceInterface') IS NOT NULL
BEGIN
    PRINT '<<< CREATED TRIGGER dbo.tu_CustomInvoiceInterface >>>'
END
GO