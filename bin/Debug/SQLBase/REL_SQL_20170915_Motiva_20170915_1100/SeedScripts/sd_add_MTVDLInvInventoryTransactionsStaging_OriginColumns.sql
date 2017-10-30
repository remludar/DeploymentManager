if not exists (Select 1 From sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVDLInvInventoryTransactionsStaging' and sc.name = 'OriginBaseProduct')
begin
	print 'adding columns'
	alter table MTVDLInvInventoryTransactionsStaging add OriginBaseProduct Varchar(20)
	alter table MTVDLInvInventoryTransactionsStaging add OriginBaseLocation Varchar(120)
	alter table MTVDLInvInventoryTransactionsStaging add SourceDealTemplate Varchar(80)
end
else
	print 'columns exist'