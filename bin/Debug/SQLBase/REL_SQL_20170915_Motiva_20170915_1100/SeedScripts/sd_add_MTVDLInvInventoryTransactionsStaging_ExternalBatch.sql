if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVDLInvInventoryTransactionsStaging' and sc.name = 'ExternalBatch')
begin
	print 'adding column ExternalBatch'
	alter table MTVDLInvInventoryTransactionsStaging add ExternalBatch Varchar(30)
end