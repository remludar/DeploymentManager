If OBJECT_ID('dbo.Custom_Interface_AR_Staging') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_AR_Staging
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_AR_Staging >>>'
End
Go

Create Procedure dbo.Custom_Interface_AR_Staging	 @i_ID				int			= NULL
													,@c_OnlyShowSQL  	char(1) 	= 'N' 

As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_AR_Staging @i_ID = 6, @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
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
		Select	InvoiceGLDate
				,InvoiceDate
				,Chart
				,LocalCurrency
				,LocalDebitValue
				,LocalCreditValue
				,dbo.Custom_Format_SAP_Invoice_String(InterfaceInvoiceID)
				,InvoiceID
				,ExtBACode
				,PaymentMethod
				,dbo.Custom_Format_SAP_Invoice_String(InterfaceInvoiceID)
				,AcctDtlID
				,TransactionDate
				,DueDate
				,Quantity
				,PerUnitPrice
				,TaxCode
				,ProductCode
				,FXConversionRate
				,InvoiceCurrency
				,InvoiceDebitValue
				,InvoiceCreditValue
				,IntBACode
				,InvoiceNumber
				,RunningNumber
				,TitleTransfer
				,Destination
				,TransactionType
				,TransactionDescription
				,Vehicle
				,LTrim(RTrim(CarrierMode))
				,ParentInvoiceDate
				,dbo.Custom_Format_SAP_Date_String(GetDate())	
				,ParentInvoiceNumber
				,ReceiptRefundFlag
				,BL
				,PaymentTermCode
				,UnitPrice
				,UOM
				,AbsLocalValue
				,AbsInvoiceValue
				,LineType
				,ProfitCenter
				,CostCenter
				,SalesOffice
				,MaterialGroup
				,DealType
				,DealNumber
				,DealDetailID
				,TransferID
				,OrderID
				,OrderBatchID
				,Plant
				,StorageLocation
				,DocumentType
				,CustomerClassification
				,SaleGroup
		From	CustomInvoiceInterface	(NoLock)
		Where	MessageQueueID	= ' + convert(varchar,@i_ID) + '
		Order By RunningNumber Asc
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End
GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_AR_Staging') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_AR_Staging >>>'
	Grant Execute on dbo.Custom_Interface_AR_Staging to SYSUSER
	Grant Execute on dbo.Custom_Interface_AR_Staging to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_AR_Staging >>>'
GO