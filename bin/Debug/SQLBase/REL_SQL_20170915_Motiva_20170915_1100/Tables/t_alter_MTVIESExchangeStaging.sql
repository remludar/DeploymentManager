
If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVIESExchangeStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'XHdrStat' AND id = object_id(N'MTVIESExchangeStaging'))
	ALTER TABLE dbo.MTVIESExchangeStaging ADD XHdrStat CHAR(1) NULL

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'IESRowType' AND id = object_id(N'MTVIESExchangeStaging'))
	ALTER TABLE dbo.MTVIESExchangeStaging ADD IESRowType smallint NULL
END