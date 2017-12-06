IF OBJECT_ID('dbo.td_CustomAccountDetail') IS NOT NULL 
BEGIN
    DROP Trigger dbo.td_CustomAccountDetail
    PRINT '<<< DROPPED TRIGGER dbo.td_CustomAccountDetail >>>'
END
GO

Create trigger dbo.td_CustomAccountDetail on dbo.CustomAccountDetail for DELETE 
As

---------------------------------------------------------------------------------------------------------------------
-- Trigger:		td_CustomAccountDetail	
-- Overview:    
-- SPs:		
-- Created by:	Jeremy von Hoff
-- History:		28/01/2013
--
-- Date         Modified By  Issue#     Modification
-- -----------  -----------  ---------  --------------------------------------------------------------------------
-- 	
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- If we're deleting a CustomAccountDetail (for reprocessing) then clear out the CustomAccountDetailAttributes
----------------------------------------------------------------------------------------------------------------------
Delete	CustomAccountDetailAttribute
From	Deleted
		Inner Join CustomAccountDetailAttribute
			on	Deleted.ID		= CustomAccountDetailAttribute.CADID

GO

IF OBJECT_ID('dbo.td_CustomAccountDetail') IS NOT NULL
BEGIN
    PRINT '<<< CREATED TRIGGER dbo.td_CustomAccountDetail >>>'
END
GO