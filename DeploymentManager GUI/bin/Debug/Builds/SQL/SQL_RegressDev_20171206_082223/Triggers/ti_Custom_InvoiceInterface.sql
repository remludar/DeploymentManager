IF OBJECT_ID('dbo.ti_CustomInvoiceInterface') IS NOT NULL 
BEGIN
    DROP Trigger dbo.ti_CustomInvoiceInterface
    PRINT '<<< DROPPED TRIGGER dbo.ti_CustomInvoiceInterface >>>'
END
GO

Create trigger dbo.ti_CustomInvoiceInterface on dbo.CustomInvoiceInterface for INSERT
As

---------------------------------------------------------------------------------------------------------------------
-- Trigger:		ti_CustomInvoiceInterface	
-- Overview:    
-- SPs:		
-- Created by:	Jeremy von Hoff
-- History:		02NOV2015
--
-- Date         Modified By  Issue#     Modification
-- -----------  -----------  ---------  --------------------------------------------------------------------------
-- 	
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Create the entry in the MTV Interface Tracking table
----------------------------------------------------------------------------------------------------------------------
Insert	MTVInvoiceInterfaceStatus (CIIMssgQID, InterfaceSource, InvoiceNumber)
Select	Inserted.MessageQueueID,
		Inserted.InterfaceSource,
		Inserted.InvoiceNumber
From	Inserted
Where	Inserted.InvoiceLevel		= 'H'
And		Inserted.InterfaceStatus	= 'A'
And		Not Exists (Select 1 From MTVInvoiceInterfaceStatus sub Where sub.CIIMssgQID = Inserted.MessageQueueID)

GO

IF OBJECT_ID('dbo.ti_CustomInvoiceInterface') IS NOT NULL
BEGIN
    PRINT '<<< CREATED TRIGGER dbo.ti_CustomInvoiceInterface >>>'
END
GO