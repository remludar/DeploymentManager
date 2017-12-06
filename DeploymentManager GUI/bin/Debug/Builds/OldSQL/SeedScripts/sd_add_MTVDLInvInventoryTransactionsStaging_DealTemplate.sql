if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVDLInvInventoryTransactionsStaging' and sc.name = 'DealTemplate')
begin
	print 'Adding Column'
	alter table MTVDLInvInventoryTransactionsStaging add DealTemplate varchar(80)
end
else
	print 'Column Exists'