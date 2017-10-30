
If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVElemicaStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF EXISTS (SELECT 1 FROM syscolumns WHERE name = 'CustodyLocationIndentifier' AND id = object_id(N'MTVElemicaStaging'))
		ALTER TABLE dbo.MTVElemicaStaging ALTER COLUMN CustodyLocationIndentifier VARCHAR(255) NULL
	IF EXISTS (SELECT 1 FROM syscolumns WHERE name = 'TankagePartnerIdentifier' AND id = object_id(N'MTVElemicaStaging'))
		ALTER TABLE dbo.MTVElemicaStaging ALTER COLUMN TankagePartnerIdentifier VARCHAR(255) NULL
	IF EXISTS (SELECT 1 FROM syscolumns WHERE name = 'ConsigneePartnerIdentifier' AND id = object_id(N'MTVElemicaStaging'))
		ALTER TABLE dbo.MTVElemicaStaging ALTER COLUMN ConsigneePartnerIdentifier VARCHAR(255) NULL
	
END