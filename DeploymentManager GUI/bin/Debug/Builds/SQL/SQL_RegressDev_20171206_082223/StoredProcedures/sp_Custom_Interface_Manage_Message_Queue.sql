If OBJECT_ID('dbo.Custom_Interface_Manage_Message_Queue') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_Manage_Message_Queue
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_Manage_Message_Queue >>>'
End
Go

Create Procedure dbo.Custom_Interface_Manage_Message_Queue	 @i_ID			int				
															,@b_RAProcessed	bit				
															,@b_HasErrored	bit					
															,@vc_Error		varchar(2000)
As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_Manage_Message_Queue 'Y'	Copyright 2003 SolArc
-- Overview:	
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Joshua Weber
-- History:		13/04/2013 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set ANSI_NULLS ON
Set ANSI_PADDING ON
Set ANSI_Warnings ON
Set Quoted_Identifier OFF
Set Concat_Null_Yields_Null ON

----------------------------------------------------------------------------------------------------------------------
-- Update the CustomMessageQueue table
----------------------------------------------------------------------------------------------------------------------	
Update	CustomMessageQueue
Set		RAProcessed			= @b_RAProcessed
		,RAProcessedDate	= GetDate()
		,HasErrored			= @b_HasErrored
		,Error				= @vc_Error
		,Reprocess			= 0
Where	ID	= @i_ID	

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_Manage_Message_Queue') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_Manage_Message_Queue >>>'
	Grant Execute on dbo.Custom_Interface_Manage_Message_Queue to SYSUSER
	Grant Execute on dbo.Custom_Interface_Manage_Message_Queue to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_Manage_Message_Queue >>>'
GO

 