if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVDLInvInventoryTransactionsStaging' and sc.name = 'OriginMaterialNumber')
begin
	print 'Adding Column'
	alter table MTVDLInvInventoryTransactionsStaging add OriginMaterialNumber Varchar(255)
end
else
	print 'Column Exists'
	
if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVDLInvInventoryTransactionsStaging' and sc.name = 'OriginPlantCode')
begin
	print 'Adding Column'
	alter table MTVDLInvInventoryTransactionsStaging add OriginPlantCode Varchar(255)
end
else
	print 'Column Exists'
