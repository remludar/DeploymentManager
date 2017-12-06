If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVDataLakeTaxTransactionStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Acct_ARAPFedDate' AND id = object_id(N'MTVDataLakeTaxTransactionStaging'))
	ALTER table MTVDataLakeTaxTransactionStaging Add Acct_ARAPFedDate smalldatetime null

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Acct_ARAPMSAPStatus' AND id = object_id(N'MTVDataLakeTaxTransactionStaging'))
	ALTER table MTVDataLakeTaxTransactionStaging Add Acct_ARAPMSAPStatus varchar(50) null

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Acct_LastCloseDate' AND id = object_id(N'MTVDataLakeTaxTransactionStaging'))
	ALTER table MTVDataLakeTaxTransactionStaging Add Acct_LastCloseDate smalldatetime null

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Acct_Strategy' AND id = object_id(N'MTVDataLakeTaxTransactionStaging'))
	ALTER table MTVDataLakeTaxTransactionStaging Add Acct_Strategy VARCHAR(12) null

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Acct_ShipTo' AND id = object_id(N'MTVDataLakeTaxTransactionStaging'))
	ALTER table MTVDataLakeTaxTransactionStaging Add Acct_ShipTo VARCHAR(255) null

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Acct_NetSignedVolume' AND id = object_id(N'MTVDataLakeTaxTransactionStaging'))
	ALTER table MTVDataLakeTaxTransactionStaging Add Acct_NetSignedVolume FLOAT null
		
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Acct_GrossSignedVolume' AND id = object_id(N'MTVDataLakeTaxTransactionStaging'))
	ALTER table MTVDataLakeTaxTransactionStaging Add Acct_GrossSignedVolume FLOAT null

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Acct_BilledUOM' AND id = object_id(N'MTVDataLakeTaxTransactionStaging'))
	ALTER table MTVDataLakeTaxTransactionStaging Add Acct_BilledUOM VARCHAR(20) null
END