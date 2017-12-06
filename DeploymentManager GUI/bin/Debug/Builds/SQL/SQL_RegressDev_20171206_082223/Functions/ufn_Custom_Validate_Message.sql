If OBJECT_ID('Custom_Validate_Message') Is Not NULL
Begin 
    DROP Function Custom_Validate_Message
    PRINT '<<< DROPPED Function Custom_Validate_Message >>>'
End
GO

Set Quoted_Identifier OFF 
GO
Set ANSI_NULLS ON 
GO

Create Function dbo.Custom_Validate_Message(@i_ID int, @vc_Entity char(2)) Returns bit As

Begin
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		Custom_Validate_Message 1, 'SH'          Copyright 2004 SolArc
-- Overview:	
-- Arguments:	
-- Created by:	Joshua Weber
-- History:		13/04/2013
------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	@b_Valid	bit

----------------------------------------------------------------------------------------------------------------------
-- Initilize the variable - assume the id is valid
----------------------------------------------------------------------------------------------------------------------
Select	@b_Valid	= 1

----------------------------------------------------------------------------------------------------------------------
-- Is the Message ID Null
----------------------------------------------------------------------------------------------------------------------
If	IsNull(@i_ID,0)	= 0
	Begin
		Select	@b_Valid	= 0	
	End
	
----------------------------------------------------------------------------------------------------------------------
-- Does the ID/Entity combination exist in CustomMessageQueue
----------------------------------------------------------------------------------------------------------------------
If	Not Exists(Select 'X' From CustomMessageQueue (NoLock) Where Id = IsNull(@i_ID,0) And Entity = @vc_Entity)
	Begin
		Select	@b_Valid	= 0		
	End	
	
----------------------------------------------------------------------------------------------------------------------
-- Has the ID already been processed
----------------------------------------------------------------------------------------------------------------------
If	Exists(Select 'X' From CustomMessageQueue (NoLock) Where Id = IsNull(@i_ID,0) And RAProcessed = 1 And Reprocess = 0)
	Begin
		Select	@b_Valid	= 0			
	End

----------------------------------------------------------------------------------------------------------------------
-- Return whether or not the message is valid
----------------------------------------------------------------------------------------------------------------------
Return	@b_Valid

End

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('Custom_Validate_Message') Is NOT Null
BEGIN
	PRINT '<<< CREATED Function Custom_Validate_Message >>>'
	Grant Execute On Custom_Validate_Message to RightAngleAccess
	Grant Execute On Custom_Validate_Message to sysuser
END
ELSE
	Print '<<<Failed Creating Function Custom_Validate_Message >>>'
GO

