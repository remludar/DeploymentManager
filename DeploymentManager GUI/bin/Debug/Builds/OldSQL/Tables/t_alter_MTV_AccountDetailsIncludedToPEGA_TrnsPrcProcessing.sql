
If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'PrvsnNme' AND id = object_id(N'MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing'))
	ALTER TABLE dbo.MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing ADD PrvsnNme VARCHAR(30) NULL
	
END