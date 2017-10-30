IF OBJECT_ID('dbo.ti_MTV_ManualSalesInvoiceDetail') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.ti_MTV_ManualSalesInvoiceDetail
    IF OBJECT_ID('dbo.ti_MTV_ManualSalesInvoiceDetail') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.ti_MTV_ManualSalesInvoiceDetail >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.ti_MTV_ManualSalesInvoiceDetail >>>'
  END
go

CREATE trigger [dbo].[ti_MTV_ManualSalesInvoiceDetail] on [dbo].[ManualSalesInvoiceDetail] for INSERT as
BEGIN

		Insert	MTVManualInvoiceCustomerNumber
					(
					SlsInvceHdrID
					)
		Select	DISTINCT Inserted.MnlSlsInvceDtlSlsInvceHdrID
		From	Inserted
		Where	not exists (
							Select 1
							From	MTVManualInvoiceCustomerNumber
							Where	Inserted.MnlSlsInvceDtlSlsInvceHdrID = MTVManualInvoiceCustomerNumber.SlsInvceHdrID
							)

		Update	MTVManualInvoiceCustomerNumber
		Set		SAPCustomerNumber = MTVSAPBASoldTo.SoldTo
		From	Inserted
				Inner Join MTVManualInvoiceCustomerNumber (NoLock)
					on	MTVManualInvoiceCustomerNumber.SlsInvceHdrID	= Inserted.MnlSlsInvceDtlSlsInvceHdrID
				Inner Join SalesInvoiceHeader (NoLock)
					on	Inserted.MnlSlsInvceDtlSlsInvceHdrID			= SalesInvoiceHeader.SlsInvceHdrID
				Inner Join MTVSAPBASoldTo (NoLock)
					on	MTVSAPBASoldTo.BAID								= SalesInvoiceHeader.SlsInvceHdrBARltnBAID
		Where	not exists (
							Select	1
							From	MTVSAPBASoldTo Sub (NoLock)
							Where	Sub.BAID	= MTVSAPBASoldTo.BAID
							And		Sub.SoldTo	<> MTVSAPBASoldTo.SoldTo
							)
END
GO
