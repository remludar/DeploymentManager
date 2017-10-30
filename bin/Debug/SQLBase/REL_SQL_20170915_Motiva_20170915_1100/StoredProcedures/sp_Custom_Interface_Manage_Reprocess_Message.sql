If OBJECT_ID('dbo.Custom_Interface_Manage_Reprocess_Message') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_Manage_Reprocess_Message
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_Manage_Reprocess_Message >>>'
End
Go

Create Procedure dbo.Custom_Interface_Manage_Reprocess_Message	 @i_MessageID	int				= 0
																,@i_ID			int				= 0			
																,@vc_Source		varchar(2)		= 'SH'
																,@b_HasErrored	bit				Output
																,@vc_Error		varchar(2000)	Output

As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_Manage_Reprocess_Message 'Y'	Copyright 2003 SolArc
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
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	 @sdt_FedDate	smalldatetime
		,@c_Paid		char(1)
		,@c_Approved	char(1)
		
----------------------------------------------------------------------------------------------------------------------
-- Default the Error Trapping variables
----------------------------------------------------------------------------------------------------------------------		
Select	@b_HasErrored	= 0
		,@vc_Error		= NULL	

----------------------------------------------------------------------------------------------------------------------
-- Set the Paid and Fed Date variables
----------------------------------------------------------------------------------------------------------------------	
If	@vc_Source	= 'PH'	
	Begin									
		Select	@sdt_FedDate	= FedDate 
				,@c_Paid		= Case
									When	PayableHeader. Status	= 'P'	Then	'Y'
									Else	'N'
								  End		
		From	PayableHeader	(NoLock)
		Where	PayableHeader. PybleHdrID	= IsNull(@i_ID,0) 
	End	
				
If	@vc_Source	= 'SH'	
	Begin
		Select	@sdt_FedDate	= SlsInvceHdrFdDte
				,@c_Paid		= Case
									When	SlsInvceHdrPd = 'Y'	Then 'Y'
									Else	'N'
								 End	
		From	SalesInvoiceHeader	(NoLock)								
		Where	SalesInvoiceHeader. SlsInvceHdrID	= IsNull(@i_ID,0)
	End	

----------------------------------------------------------------------------------------------------------------------
-- Set the Approval Status 
----------------------------------------------------------------------------------------------------------------------	
If	Exists (Select 'X' From CustomInvoiceInterface (NoLock) Where MessageQueueID = IsNull(@i_MessageID, 0) And InterfaceStatus = 'A') 
	Select	@c_Approved = 'Y'
Else
	Select	@c_Approved = 'N'

----------------------------------------------------------------------------------------------------------------------
-- Validation check on the Fed Date value
----------------------------------------------------------------------------------------------------------------------		
If	@sdt_FedDate Is Not Null 
	Begin
		Select	@b_HasErrored	= 1
				,@vc_Error		= 'The invoice cannot be reprocessed because it has already been Fed.'
	End
	
----------------------------------------------------------------------------------------------------------------------
--  Validation check on the Paid value
----------------------------------------------------------------------------------------------------------------------		
If	IsNull(@c_Paid, 'N') = 'Y'
	Begin
		Select	@b_HasErrored	= 1
				,@vc_Error		= 'The invoice cannot be reprocessed because it has already been Paid.'
	End	
	
----------------------------------------------------------------------------------------------------------------------
--  Validation check on the Approved value
----------------------------------------------------------------------------------------------------------------------	 	 		 
--If	@c_Approved	= 'Y'
--	Begin
--		Select	@b_HasErrored	= 1
--				,@vc_Error		= 'The invoice cannot be reprocessed because it has already been Approved.'	
--	End
	
----------------------------------------------------------------------------------------------------------------------
--  If we got through the validation checks go ahead and clear the staging tables
----------------------------------------------------------------------------------------------------------------------
If	@b_HasErrored	= 0
	Begin
	
		----------------------------------------------------------------------------------------------------------------------
		--  Insert into the Archival tables
		----------------------------------------------------------------------------------------------------------------------
		
		----------------------------------------------------------------------------------------------------------------------
		--  Delete the staging tables
		----------------------------------------------------------------------------------------------------------------------					
		Delete	CustomAccountDetail	
		Where	InterfaceMessageID	= IsNull(@i_MessageID, 0)
		
		Delete	CustomInvoiceInterface
		Where	MessageQueueID		= IsNull(@i_MessageID, 0)	
	
	End		

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_Manage_Reprocess_Message') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_Manage_Reprocess_Message >>>'
	Grant Execute on dbo.Custom_Interface_Manage_Reprocess_Message to SYSUSER
	Grant Execute on dbo.Custom_Interface_Manage_Reprocess_Message to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_Manage_Reprocess_Message >>>'
GO

 