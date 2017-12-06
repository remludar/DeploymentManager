if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVDLInvBalancesStaging' and sc.name = 'ProfitCenter')
	alter table MTVDLInvBalancesStaging add ProfitCenter varchar(255)

if not exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.type = 'u' and so.name = 'MTVDLInvBalancesStaging' and sc.name = 'LocationType')
	alter table MTVDLInvBalancesStaging add LocationType varchar(80)
