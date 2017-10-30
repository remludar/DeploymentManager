--If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVSoldToShipToMasterDataStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
--BEGIN

--  IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'MTVSoldToShipToMasterDataStaging' AND column_name = 'BASoldTo')
--	 ALTER TABLE dbo.MTVSoldToShipToMasterDataStaging ADD BASoldTo VARCHAR(256) NULL

--   IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'MTVSoldToShipToMasterDataStaging' AND column_name = 'TheirCompany')
--	 ALTER TABLE dbo.MTVSoldToShipToMasterDataStaging ADD TheirCompany VARCHAR(256) NULL

--   IF  EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'MTVSoldToShipToMasterDataStaging' AND column_name = 'Status')
--	 ALTER TABLE dbo.MTVSoldToShipToMasterDataStaging ALTER COLUMN Status VARCHAR(256) NULL

--   IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'MTVSoldToShipToMasterDataStaging' AND column_name = 'Location')
--	 ALTER TABLE dbo.MTVSoldToShipToMasterDataStaging ADD Location VARCHAR(256) NULL

--END