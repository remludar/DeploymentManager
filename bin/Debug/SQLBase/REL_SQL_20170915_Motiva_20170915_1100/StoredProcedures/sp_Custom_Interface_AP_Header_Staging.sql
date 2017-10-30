If OBJECT_ID('dbo.Custom_Interface_AP_Header_Staging') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_AP_Header_Staging
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_AP_Header_Staging >>>'
End
Go

Create Procedure dbo.Custom_Interface_AP_Header_Staging	 @i_ID				int			= NULL
														,@vc_FileName		varchar(80)	= 'C:\'
														,@c_OnlyShowSQL  	char(1) 	= 'N' 

As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_AP_Header_Staging @i_ID = 6, @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
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
Declare	 @vc_DynamicSQL			varchar(8000)

If	Exists (Select 'X' From CustomInvoiceInterface Where MessageQueueID = @i_ID And InterfaceStatus = 'R') 
	Begin
		Select	@vc_DynamicSQL	= '
		Select	''' + @vc_FileName + '''	
				,dbo.Custom_Format_SAP_Date_String(GetDate())
				,1
				,Max(RunningNumber)
				,Sum(LocalDebitValue)
				,Sum(LocalCreditValue)
		From	CustomInvoiceInterface	(NoLock)
		Where	MessageQueueID	= ' + convert(varchar,@i_ID) + '
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End		

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_AP_Header_Staging') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_AP_Header_Staging >>>'
	Grant Execute on dbo.Custom_Interface_AP_Header_Staging to SYSUSER
	Grant Execute on dbo.Custom_Interface_AP_Header_Staging to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_AP_Header_Staging >>>'
GO