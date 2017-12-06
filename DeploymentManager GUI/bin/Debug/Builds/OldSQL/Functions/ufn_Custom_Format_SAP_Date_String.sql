If OBJECT_ID('Custom_Format_SAP_Date_String') Is Not NULL
Begin 
    DROP Function Custom_Format_SAP_Date_String
    PRINT '<<< DROPPED Function Custom_Format_SAP_Date_String >>>'
End
GO

Set Quoted_Identifier OFF 
GO
Set ANSI_NULLS ON 
GO

Create Function dbo.Custom_Format_SAP_Date_String(@sdt_Date smalldatetime) Returns varchar(25) As

Begin
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		select dbo.Custom_Format_SAP_Date_String (GetDate())         Copyright 2004 SolArc
-- Overview:	
-- Arguments:	
-- Created by:	Joshua Weber
-- History:		13/04/2013
------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	@vc_Date	varchar(25)

----------------------------------------------------------------------------------------------------------------------
-- Build the SAP String
----------------------------------------------------------------------------------------------------------------------
Select	@vc_Date		=	right('0' + convert(varchar(2), month(@sdt_Date)), 2) + '/' +
							right('0' + convert(varchar(2), day(@sdt_Date)), 2) + '/' +
							convert(varchar(4), year(@sdt_Date)) + ' ' +
							Case 
								When	datepart(hour, @sdt_Date) > 12	Then right('0' + convert(varchar(2), datepart(hour, @sdt_Date)), 2)
								When	datepart(hour, @sdt_Date) = 0	Then '12'
								Else	right('0' + convert(varchar(2), datepart(hour, @sdt_Date)), 2)
							End + ':' +
							right('0' + convert(varchar(4), datepart(minute, @sdt_Date)), 2) + ':' +
							right('0' + convert(varchar(4), datepart(second, @sdt_Date)), 2) + ' ' +
							Case 
								When	datepart(hour, @sdt_Date) > 11		Then 'PM'
								Else	'AM'
							End 

----------------------------------------------------------------------------------------------------------------------
-- Return whether or not the message is valid
----------------------------------------------------------------------------------------------------------------------
Return	@vc_Date

End

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('Custom_Format_SAP_Date_String') Is NOT Null
BEGIN
	PRINT '<<< CREATED Function Custom_Format_SAP_Date_String >>>'
	Grant Execute On Custom_Format_SAP_Date_String to RightAngleAccess
	Grant Execute On Custom_Format_SAP_Date_String to sysuser
END
ELSE
	Print '<<<Failed Creating Function Custom_Format_SAP_Date_String >>>'
GO