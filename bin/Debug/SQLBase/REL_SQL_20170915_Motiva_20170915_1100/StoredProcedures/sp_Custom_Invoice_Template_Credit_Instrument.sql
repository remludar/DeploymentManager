If OBJECT_ID('dbo.Custom_Invoice_Template_Credit_Instrument') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Invoice_Template_Credit_Instrument
    PRINT '<<< DROPPED PROC dbo.Custom_Invoice_Template_Credit_Instrument >>>'
End
Go  

Create Procedure dbo.Custom_Invoice_Template_Credit_Instrument	 @i_BAID			int				= Null
																,@c_Direction		char(1)			= 'I'		-- I for Sales Invoices / O For Purchase Invoices
																,@i_DlHdrID			int				= Null
																,@i_DlDtlID			int				= Null
																,@i_ObID			int				= Null
																,@i_PlnndTrnsfrID	int				= Null
																,@i_PlnndMvtID		int				= Null
																,@i_MvtHdrID		int				= Null
																,@vc_Instruments	varchar(500)	OUTPUT
																,@vc_Banks			varchar(500)	OUTPUT
													
As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		Custom_Invoice_Template_Credit_Instrument 			Copyright 2003 SolArc
-- Overview:	
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Joshua Weber
-- History:		30/08/2011 - First Created
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
Declare	@i_CreditCustomerID	int

----------------------------------------------------------------------------------------------------------------------
-- Create #CreditCustomerDetail
----------------------------------------------------------------------------------------------------------------------	
Create Table	#CreditCustomerDetail
				(CreditCustomerDetailID	int)	

----------------------------------------------------------------------------------------------------------------------
-- Set the CreditCustomerID	value
----------------------------------------------------------------------------------------------------------------------	
Select	@i_CreditCustomerID	= CreditCustomer. CreditCustomerID
From	CreditCustomer	(NoLock)
Where	CreditCustomer. BAID	= @i_BAID

----------------------------------------------------------------------------------------------------------------------
-- Collect the valid credit customer detail records
----------------------------------------------------------------------------------------------------------------------	
Insert	#CreditCustomerDetail
		(CreditCustomerDetailID)
Select	Distinct	CreditCustomerDetail. CreditCustomerDetailID 
From	CreditCustomerDetail						(NoLock)
		Inner Join	CreditSpecificInstrument		(NoLock)	On	CreditCustomerDetail. CreditCustomerDetailID	= CreditSpecificInstrument. CreditCustomerDetailID
																And	CreditCustomerDetail. CreditCustomerID			= @i_CreditCustomerID	
Where	CreditCustomerDetail. Status	= 'A'
And		CreditCustomerDetail. Direction	= @c_Direction	
And		((	CreditSpecificInstrument. SourceTable		= 'DH'
And			CreditSpecificInstrument. DlHdrID			= IsNull(@i_DlHdrID,0))
Or		(	CreditSpecificInstrument. SourceTable		= 'DD'
And			CreditSpecificInstrument. DlHdrID			= IsNull(@i_DlHdrID,0)
And			CreditSpecificInstrument. DlDtlId			= IsNull(@i_DlDtlID,0))
Or		(	CreditSpecificInstrument. SourceTable		= 'OB'
And			CreditSpecificInstrument. DlHdrID			= IsNull(@i_DlHdrID,0)
And			CreditSpecificInstrument. DlDtlId			= IsNull(@i_DlDtlID,0)
And			CreditSpecificInstrument. ObId				= IsNull(@i_ObID,0))
Or		(	CreditSpecificInstrument. SourceTable		= 'PT'
And			CreditSpecificInstrument. DlHdrID			= IsNull(@i_DlHdrID,0)
And			CreditSpecificInstrument. DlDtlId			= IsNull(@i_DlDtlID,0)
And			CreditSpecificInstrument. ObId				= IsNull(@i_ObID,0)
And			CreditSpecificInstrument. PlnndTrnsfrID		= IsNull(@i_PlnndTrnsfrID,0))
Or		(	CreditSpecificInstrument. SourceTable		= 'PM'
And			CreditSpecificInstrument. DlHdrID			= IsNull(@i_DlHdrID,0)
And			CreditSpecificInstrument. DlDtlId			= IsNull(@i_DlDtlID,0)
And			CreditSpecificInstrument. ObId				= IsNull(@i_ObID,0)
And			CreditSpecificInstrument. PlnndTrnsfrID		= IsNull(@i_PlnndTrnsfrID,0)
And			CreditSpecificInstrument. PlnndMvtID		= IsNull(@i_PlnndMvtID,0))
Or		(	CreditSpecificInstrument. SourceTable		= 'MH'
And			CreditSpecificInstrument. DlHdrID			= IsNull(@i_DlHdrID,0)
And			CreditSpecificInstrument. DlDtlId			= IsNull(@i_DlDtlID,0)
And			CreditSpecificInstrument. ObId				= IsNull(@i_ObID,0)
And			CreditSpecificInstrument. PlnndTrnsfrID		= IsNull(@i_PlnndTrnsfrID,0)
And			CreditSpecificInstrument. PlnndMvtID		= IsNull(@i_PlnndMvtID,0)
And			CreditSpecificInstrument. MvtHdrID			= IsNull(@i_MvtHdrID,0)))									

----------------------------------------------------------------------------------------------------------------------
-- Select out a comma delimited list of Instruments
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_Instruments	=	Substring(IsNull((Select	(	Select	Distinct ', ' + CreditCustomerDetail. LCNumber 
															From	CreditCustomerDetail			(NoLock)
																	Inner Join	#CreditCustomerDetail	(NoLock)	On	CreditCustomerDetail. CreditCustomerDetailID	= #CreditCustomerDetail. CreditCustomerDetailID
															Where	CreditCustomerDetail. LCNumber	Is Not Null																																																		
															FOR XML PATH('') ) As Details), ''), 3, 500)

----------------------------------------------------------------------------------------------------------------------
-- Select out a comma delimited list of Banks
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_Banks	=	Substring(IsNull((Select	(	Select	Distinct ', ' + IsNull(BusinessAssociate. BANme,'') + IsNull(BanmeExtended,'') 
														From	CreditCustomerDetail				(NoLock)
																Inner Join	#CreditCustomerDetail	(NoLock)	On	CreditCustomerDetail. CreditCustomerDetailID	= #CreditCustomerDetail. CreditCustomerDetailID
																Left Outer Join	BusinessAssociate		(NoLock)	On	convert(varchar,BusinessAssociate. BAID)	= CreditCustomerDetail. IssuingBank																																																	
														FOR XML PATH('') ) As Details), ''), 3, 500)
														
----------------------------------------------------------------------------------------------------------------------
-- Drop the Temp Table
----------------------------------------------------------------------------------------------------------------------		
Drop Table #CreditCustomerDetail
														
GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Invoice_Template_Credit_Instrument') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Invoice_Template_Credit_Instrument >>>'
	Grant Execute on dbo.Custom_Invoice_Template_Credit_Instrument to SYSUSER
	Grant Execute on dbo.Custom_Invoice_Template_Credit_Instrument to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Invoice_Template_Credit_Instrument >>>'
GO																										