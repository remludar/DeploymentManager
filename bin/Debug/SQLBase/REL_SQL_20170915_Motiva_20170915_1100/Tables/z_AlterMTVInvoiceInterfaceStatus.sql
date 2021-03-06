If Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVInvoiceInterfaceStatus') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'SalesForceDataLakeStaged' AND id = object_id(N'MTVInvoiceInterfaceStatus'))
	ALTER TABLE [dbo].[MTVInvoiceInterfaceStatus] ADD  SalesForceDataLakeStaged Bit	Default(0) 

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'SalesForceDataLakeExtracted' AND id = object_id(N'MTVInvoiceInterfaceStatus'))
	ALTER TABLE [dbo].[MTVInvoiceInterfaceStatus] ADD  SalesForceDataLakeExtracted Bit	Default(0) 

	DECLARE @FPSColAdded BIT = 0

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'FPSFuelSalesVolStaged' AND id = object_id(N'MTVInvoiceInterfaceStatus'))
	BEGIN
		SELECT @FPSColAdded = 1
		ALTER TABLE [dbo].[MTVInvoiceInterfaceStatus] ADD  FPSFuelSalesVolStaged Bit	Default(0) 
	END

	IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'FPSFuelSalesVolExtracted' AND id = object_id(N'MTVInvoiceInterfaceStatus'))
	BEGIN
		SELECT @FPSColAdded = 1
		ALTER TABLE [dbo].[MTVInvoiceInterfaceStatus] ADD  FPSFuelSalesVolExtracted Bit	Default(0) 
	END

	IF @FPSColAdded = 1 
	BEGIN
		/****** Object:  Index [IX_MTVInvoiceInterfaceStatus]    Script Date: 7/18/2017 4:21:34 PM ******/
		CREATE NONCLUSTERED INDEX [IX_MTVInvoiceInterfaceStatus] ON [dbo].[MTVInvoiceInterfaceStatus]
		(
			[CIIMssgQID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		DECLARE @Sql VARCHAR(8000)
		SELECT @Sql = '
		UPDATE MTVInvoiceInterfaceStatus SET FPSFuelSalesVolStaged = 1
		FROM MTVInvoiceInterfaceStatus IIS
		INNER JOIN MTVFPSFuelSalesVolStaging FSV
		ON IIS.CIIMssgQID = FSV.CIIMssgQID

		UPDATE MTVInvoiceInterfaceStatus SET FPSFuelSalesVolExtracted = 1
		FROM MTVInvoiceInterfaceStatus IIS
		INNER JOIN MTVFPSFuelSalesVolStaging FSV
		ON IIS.CIIMssgQID = FSV.CIIMssgQID
		AND FSV.Status = ''C''

		UPDATE MTVInvoiceInterfaceStatus SET FPSFuelSalesVolStaged = 0
		WHERE MTVInvoiceInterfaceStatus.FPSFuelSalesVolStaged IS NULL

		UPDATE MTVInvoiceInterfaceStatus SET FPSFuelSalesVolExtracted = 0
		WHERE MTVInvoiceInterfaceStatus.FPSFuelSalesVolExtracted IS NULL
		' 
		EXECUTE (@Sql)
	END
END