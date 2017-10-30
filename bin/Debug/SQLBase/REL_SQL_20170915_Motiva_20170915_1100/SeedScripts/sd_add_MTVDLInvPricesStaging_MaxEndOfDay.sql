if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVDLInvPricesStaging' and sc.name = 'MinEndOfDay')
begin
	print 'Creating columns'
	alter table dbo.MTVDLInvPricesStaging add MinEndOfDay Smalldatetime
	alter table dbo.MTVDLInvPricesStaging add MaxEndOfDay Smalldatetime
end
else
	print 'Columns already exist'