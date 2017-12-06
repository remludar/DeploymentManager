
If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSMovementStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'sign' AND id = object_id(N'MTVTMSMovementStaging'))
	ALTER TABLE dbo.MTVTMSMovementStaging ADD sign CHAR(1) NULL
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'isosp' AND id = object_id(N'MTVTMSMovementStaging'))
	ALTER TABLE dbo.MTVTMSMovementStaging ADD isosp CHAR(1) DEFAULT ('N')
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'release_no' AND id = object_id(N'MTVTMSMovementStaging'))
	ALTER TABLE dbo.MTVTMSMovementStaging ADD release_no varchar(10) NULL
	
END