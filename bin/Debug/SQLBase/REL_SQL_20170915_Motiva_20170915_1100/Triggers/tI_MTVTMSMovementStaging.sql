IF EXISTS (SELECT OBJECT_ID('tI_MTVTMSMovementStaging'))
	DROP TRIGGER tI_MTVTMSMovementStaging

/****** Object:  Trigger [dbo].[tI_MTVMovementLifeCycle]    Script Date: 4/14/2017 11:00:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE TRIGGER [dbo].[tI_MTVTMSMovementStaging] ON [dbo].[MTVTMSMovementStaging] FOR INSERT AS
BEGIN
-----------------------------------------------------------------------------------------------------
-- Copyright OpenLink Financial LLC 2013
--
-- Disabling, Deleting, or Modifying any portion of the following 
-- code without the expressed written consent of OpenLink Financial LLC is strictly
-- prohibited, such acts are in violation of the Client Support Contract.
--
-----------------------------------------------------------------------------------------------------
INSERT MTVMovementLifeCycle (MESID,MovementProcessComplete,BOLNumber,TMSLoadStartDateTime,TMSSoldTo,TMSProdID,TMSTerminal,TMSIntefaceStatus,TMSInterfaceImportDate)
SELECT MESID,0,doc_no,load_start_date,cust_no,prod_id,term_id,TicketStatus,ImportDate FROM inserted

END
GO


