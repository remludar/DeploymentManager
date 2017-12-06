If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVSalesforceDataLakeInvoicesStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'AcctDtlId' AND id = object_id(N'MTVSalesforceDataLakeInvoicesStaging'))
	Alter table MTVSalesforceDataLakeInvoicesStaging Add [AcctDtlId] int null
END

If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVRetailerInvoicePreStage') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'AcctDtlId' AND id = object_id(N'MTVRetailerInvoicePreStage'))
	Alter table MTVRetailerInvoicePreStage Add [AcctDtlId] int null
END