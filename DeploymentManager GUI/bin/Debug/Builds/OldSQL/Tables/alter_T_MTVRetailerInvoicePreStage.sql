if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVRetailerInvoicePreStage' and sc.name = 'InvoiceComments')
begin
	print 'Adding InvoiceComments Column'
	ALTER table MTVRetailerInvoicePreStage Add InvoiceComments varchar(255) null
end
else
	print 'InvoiceComments Column Exists'

if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVSalesforceDataLakeInvoicesStaging' and sc.name = 'InvoiceComments')
begin
	print 'Adding InvoiceComments Column'
	ALTER table MTVSalesforceDataLakeInvoicesStaging Add InvoiceComments varchar(255) null
end
else
	print 'InvoiceComments Column Exists'
