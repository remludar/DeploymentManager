If OBJECT_ID('dbo.Custom_Interface_GL_Staging') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_GL_Staging
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_GL_Staging >>>'
End
Go

Create Procedure dbo.Custom_Interface_GL_Staging	 @i_ID				int			= NULL
													,@c_OnlyShowSQL  	char(1) 	= 'N' 

As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_GL_Staging @i_ID = 8, @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
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

If	Not Exists (Select 'X' From CustomGLInterface (NoLock) Where BatchID = @i_ID And InterfaceStatus In ('E','A')) 
	Begin 
		Select	@vc_DynamicSQL	= '
		Select	PostingDate
				,DocumentDate
				,Chart
				,LocalCurrency
				,LTrim(Str(LocalDebitValue,19,2))
				,LTrim(Str(LocalCreditValue,19,2))
				,dbo.Custom_Format_SAP_Invoice_String(BatchID)
				,InvoiceID
				,ExtBACustomerCode
				,dbo.Custom_Format_SAP_Invoice_String(BatchID)
				,Comments
				,TransactionDate
				,LTrim(Str(Quantity,19,6))
				,LTrim(Str(PerUnitPrice,19,6))
				,''''
				,ProductCode
				,LTrim(Str(FXConversionRate,28,10))
				,DocumentCurrency
				,LTrim(Str(DocumentDebitValue,19,2))
				,LTrim(Str(DocumentCreditValue,19,2))
				,IntBACode
				,InvoiceNumber
				,AccountIndicator
				,TitleTransfer
				,Destination
				,TransactionType
				,TransactionType
				,Vehicle
				,CarrierMode
				,dbo.Custom_Format_SAP_Date_String(GetDate())
				,''''
				,DocumentType
				,ExtBAVendorCode
				,BL
				,PaymentTermCode
				,''''
				,UOM
				,LTrim(Str(AbsLocalValue,19,2))
				,LineType
				,ProfitCenter
				,CostCenter
				,''''
				,AcctDtlID
				,DealType
				,DealNumber
				,DealDetailID
				,TransferID
				,OrderID
				,OrderBatchID
		From	CustomGLInterface	(NoLock)
		Where	BatchID	= ' + convert(varchar,@i_ID) + '
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End		

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_GL_Staging') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_GL_Staging >>>'
	Grant Execute on dbo.Custom_Interface_GL_Staging to SYSUSER
	Grant Execute on dbo.Custom_Interface_GL_Staging to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_GL_Staging >>>'
GO