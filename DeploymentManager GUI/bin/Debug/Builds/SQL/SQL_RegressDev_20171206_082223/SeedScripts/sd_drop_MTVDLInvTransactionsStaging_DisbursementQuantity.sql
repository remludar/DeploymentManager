if exists (select 1 from sysobjects so, syscolumns sc where sc.id = so.id and so.type = 'u' and so.name = 'MTVDLInvTransactionsStaging' and sc.name = 'DisbursementQuantity')
begin
	Alter Table dbo.MTVDLInvTransactionsStaging Drop Column DisbursementQuantity
end