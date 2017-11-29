if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'ShipperSCAC')
	alter table CustomAccountDetailAttribute add ShipperSCAC Varchar(4)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'MovementDate')
alter table CustomAccountDetailAttribute add MovementDate smalldatetime
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'DiscountDueDate')
alter table CustomAccountDetailAttribute add DiscountDueDate smalldatetime
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'DiscountAmount')
alter table CustomAccountDetailAttribute add DiscountAmount decimal(19,2)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPMaterialCode')
alter table CustomAccountDetailAttribute add SAPMaterialCode Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPCostCenter')
alter table CustomAccountDetailAttribute add SAPCostCenter Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPProfitCenter')
alter table CustomAccountDetailAttribute add SAPProfitCenter Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPPaymentTerm')
alter table CustomAccountDetailAttribute add SAPPaymentTerm Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPPlantCode')
alter table CustomAccountDetailAttribute add SAPPlantCode Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPCompanyCode')
alter table CustomAccountDetailAttribute add SAPCompanyCode Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPInternalCode')
alter table CustomAccountDetailAttribute add SAPInternalCode Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPShipToCode')
alter table CustomAccountDetailAttribute add SAPShipToCode Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPSoldToCode')
alter table CustomAccountDetailAttribute add SAPSoldToCode Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPVendorNumber')
alter table CustomAccountDetailAttribute add SAPVendorNumber Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPCustomerNumber')
alter table CustomAccountDetailAttribute add SAPCustomerNumber Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'RegionCode')
alter table CustomAccountDetailAttribute add RegionCode Char(2)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SalesOrg')
alter table CustomAccountDetailAttribute add SalesOrg Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'DistChannel')
alter table CustomAccountDetailAttribute add DistChannel Varchar(255)
go

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.type = 'u' and so.name = 'CustomAccountDetailAttribute' and sc.name = 'SAPStrategy')
alter table CustomAccountDetailAttribute add SAPStrategy Varchar(12)
go
