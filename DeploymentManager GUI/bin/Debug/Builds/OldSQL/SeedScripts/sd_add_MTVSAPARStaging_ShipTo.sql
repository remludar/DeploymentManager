if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVSAPARStaging' and sc.name = 'ShipTo')
begin
	alter table MTVSAPARStaging add ShipTo varchar(10)
end