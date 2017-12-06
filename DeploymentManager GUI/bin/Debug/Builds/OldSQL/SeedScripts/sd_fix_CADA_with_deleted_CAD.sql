delete dbo.customaccountdetailattribute where not exists (select 1 from dbo.customaccountdetail where id = cadid)

Update	CustomAccountDetail
Set		InterfaceInvoiceID		= CustomInvoiceLog.ID
from	CustomAccountDetail
		Inner Join CustomInvoiceLog
			on	CustomInvoiceLog.InvoiceType		= CustomAccountDetail.InterfaceSource
			and	CustomInvoiceLog.InvoiceID			= CustomAccountDetail.RAInvoiceID
Where	CustomAccountDetail.InterfaceSource in ('SH', 'PH')
And		CustomAccountDetail.InterfaceInvoiceID <> CustomInvoiceLog.ID


Update	CustomInvoiceInterface
Set		CustomInvoiceInterface.InterfaceInvoiceID = CustomAccountDetail.InterfaceInvoiceID
From	CustomInvoiceInterface
		Inner Join CustomAccountDetail
			on	CustomAccountDetail.AcctDtlID		= CustomInvoiceInterface.AcctDtlID
Where	CustomAccountDetail.InterfaceSource in ('SH', 'PH')
And		CustomAccountDetail.InterfaceInvoiceID <> CustomInvoiceInterface.InterfaceInvoiceID
