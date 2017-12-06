if exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVSalesforceDataLakeInvoicesStaging' and sc.name = 'RelatedInvoiceNumber')
begin
	alter table MTVSalesforceDataLakeInvoicesStaging alter column RelatedInvoiceNumber varchar(240)
end

if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVSalesforceDataLakeInvoicesStaging' and sc.name = 'NetAmount')
begin
	alter table MTVSalesforceDataLakeInvoicesStaging add NetAmount Decimal(19,6)
end

if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVSalesforceDataLakeInvoicesStaging' and sc.name = 'NexusMessageId')
begin
	alter table MTVSalesforceDataLakeInvoicesStaging add NexusMessageId int
end

if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVSalesforceDataLakeInvoicesStaging' and sc.name = 'CreationDate')
begin
	alter table MTVSalesforceDataLakeInvoicesStaging add CreationDate Datetime
end



