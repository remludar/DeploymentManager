
If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVSoldToMasterDataStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN

  -- Add modifications at the end of the previous statements.
  IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'MTVSoldToMasterDataStaging' AND column_name = 'MDMVendID')
	ALTER TABLE dbo.MTVSoldToMasterDataStaging ADD MDMVendID VARCHAR(256) NULL

  IF EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'MTVSoldToMasterDataStaging' AND column_name = 'MDMVendID')
	ALTER TABLE dbo.MTVSoldToMasterDataStaging DROP Column MDMVendID 

END