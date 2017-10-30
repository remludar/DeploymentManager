if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVDLInvPricesStaging' and sc.name = 'PricePerGallon')
begin
	alter table MTVDLInvPricesStaging add PricePerGallon decimal(19,6)
end