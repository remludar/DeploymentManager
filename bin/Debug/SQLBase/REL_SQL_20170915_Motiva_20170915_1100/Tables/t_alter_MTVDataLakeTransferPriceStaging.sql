
If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVDataLakeTransferPriceStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'PrvsnNme' AND id = object_id(N'MTVDataLakeTransferPriceStaging'))
	ALTER TABLE dbo.MTVDataLakeTransferPriceStaging ADD PrvsnNme VARCHAR(30) NULL
	
END