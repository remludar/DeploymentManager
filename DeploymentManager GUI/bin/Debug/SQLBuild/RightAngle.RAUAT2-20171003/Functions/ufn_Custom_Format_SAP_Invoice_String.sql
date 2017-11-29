If OBJECT_ID('Custom_Format_SAP_Invoice_String') Is Not NULL
Begin 
    DROP Function Custom_Format_SAP_Invoice_String
    PRINT '<<< DROPPED Function Custom_Format_SAP_Invoice_String >>>'
End
GO

Set Quoted_Identifier OFF 
GO
Set ANSI_NULLS ON 
GO

Create Function dbo.Custom_Format_SAP_Invoice_String(@i_InvoiceID int) Returns varchar(25) As

Begin
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		select dbo.Custom_Format_SAP_Invoice_String (GetDate())         Copyright 2004 SolArc
-- Overview:	
-- Arguments:	
-- Created by:	Joshua Weber
-- History:		13/04/2013
------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare	@vc_InvoiceNumber	varchar(25)
		,@i_StringLength	int

Select	@i_StringLength	= Len('RA' + convert(varchar,@i_InvoiceID))

----------------------------------------------------------------------------------------------------------------------
-- Build the SAP String
----------------------------------------------------------------------------------------------------------------------
Select	@vc_InvoiceNumber	= 'RA' + replicate('0',(12-@i_StringLength)) + convert(varchar,@i_InvoiceID)	

----------------------------------------------------------------------------------------------------------------------
-- Return whether or not the message is valid
----------------------------------------------------------------------------------------------------------------------
Return	@vc_InvoiceNumber

End

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('Custom_Format_SAP_Invoice_String') Is NOT Null
BEGIN
	PRINT '<<< CREATED Function Custom_Format_SAP_Invoice_String >>>'
	Grant Execute On Custom_Format_SAP_Invoice_String to RightAngleAccess
	Grant Execute On Custom_Format_SAP_Invoice_String to sysuser
END
ELSE
	Print '<<<Failed Creating Function Custom_Format_SAP_Invoice_String >>>'
GO

