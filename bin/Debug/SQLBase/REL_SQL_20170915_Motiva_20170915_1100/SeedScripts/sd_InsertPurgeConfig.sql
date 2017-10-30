IF (Select 'x' from PurgeConfig where TableName = 'MTVElemicaStaging') IS NULL
BEGIN
declare @i_purgeid int
exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVElemicaStaging',  NULL, NULL, NULL, 'DELETE FROM MTVElemicaStaging WHERE ImportDate < dateadd(dd, -90, getdate())', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVTMSGaugeStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVTMSGaugeStaging',  NULL, NULL, NULL, 'DELETE FROM MTVTMSGaugeStaging WHERE ImportDate < dateadd(dd, -90, getdate())', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVTMSGaugeFreezeStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVTMSGaugeFreezeStaging',  NULL, NULL, NULL, 'DELETE FROM MTVTMSGaugeFreezeStaging WHERE ImportDate < dateadd(dd, -90, getdate())', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVTransferPriceStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVTransferPriceStaging',  NULL, NULL, NULL, 'DELETE FROM MTVTransferPriceStaging WHERE CreatedDate < dateadd(dd, -90, getdate())', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVFPSReconPriceStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVFPSReconPriceStaging',  NULL, NULL, NULL, 'DELETE FROM MTVFPSReconPriceStaging WHERE CreatedDate < dateadd(dd, -90, getdate())', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVTMSCommentRawData') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVTMSCommentRawData',  NULL, NULL, NULL, 'BEGIN TRANSACTION
DELETE from MTVTMSCommentRawData WHERE CreatedDate < dateadd(dd, -90, getdate());
DELETE FROM MTVTMSProductRawData WHERE CreatedDate < dateadd(dd, -90, getdate());
DELETE FROM MTVTMSMovementStaging WHERE ImportDate < dateadd(dd, -90, getdate());
DELETE FROM MTVTMSHeaderRawData WHERE CreatedDate < dateadd(dd, -90, getdate());
COMMIT TRANSACTION', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVFPSRackPriceStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVFPSRackPriceStaging',  NULL, NULL, NULL, 'DELETE FROM MTVFPSRackPriceStaging
WHERE ImportDate <= DATEADD(dd, -30, GETDATE())
AND RecordStatus IN (''C'', ''I'')', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVDealDetailShipToStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVDealDetailShipToStaging',  NULL, NULL, NULL, 'DELETE FROM MTVDealDetailShipToStaging
WHERE LastUpdateDate <= DATEADD(dd, -30, GETDATE())', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVOASActualStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVOASActualStaging',  NULL, NULL, NULL, 'DELETE FROM MTVOASActualStaging
WHERE ImportDate <= DATEADD(dd, -30, GETDATE())
AND TicketStatus IN (''C'', ''A'', ''I'')', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVOASNominationStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVOASNominationStaging',  NULL, NULL, NULL, 'DELETE FROM MTVOASNominationStaging
WHERE ID NOT IN 
       (SELECT MAX(ID) from MTVOASNominationStaging OAS2
              GROUP BY OAS2.PlnndMvtID, OAS2.PlnndTrnsfrID)
AND CreateDate <= DATEADD(dd, -30, GETDATE())', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVOrionNominationStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVOrionNominationStaging',  NULL, NULL, NULL, 'DELETE FROM MTVOrionNominationStaging
WHERE ChangeDate <= DATEADD(dd, -30, GETDATE())', @i_purgeid, 'Y', 'A')
END

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVCustomerMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVCustomerMasterDataStaging',  NULL, NULL, NULL, 'delete from  MTVCustomerMasterDataStaging 
where MTVCustomerMasterDataStaging.ProcessedDate <= DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVContactMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVContactMasterDataStaging',  NULL, NULL, NULL, 'delete from  MTVContactMasterDataStaging  
where MTVContactMasterDataStaging.ProcessedDate <= DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVSoldToShipToMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVSoldToShipToMasterDataStaging',  NULL, NULL, NULL, 'delete from MTVSoldToShipToMasterDataStaging  
where MTVSoldToShipToMasterDataStaging.ProcessedDate <= DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVSoldToShipToMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVSoldToShipToMasterDataStaging',  NULL, NULL, NULL, 'delete MTVSoldToShipToMasterDataStaging  
where MTVSoldToShipToMasterDataStaging.ProcessedDate <= DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTV_VendorMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTV_VendorMasterDataStaging',  NULL, NULL, NULL, 'delete from MTV_VendorMasterDataStaging
where MTV_VendorMasterDataStaging.ProcessedDate <=  DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVCustomerMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVCustomerMasterDataStaging',  NULL, NULL, NULL, 'delete from  MTVCustomerMasterDataStaging 
where MTVCustomerMasterDataStaging.ProcessedDate <= DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 

GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVContactMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVContactMasterDataStaging',  NULL, NULL, NULL, 'delete from  MTVContactMasterDataStaging  
where MTVContactMasterDataStaging.ProcessedDate <= DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 
 
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVSoldToShipToMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVSoldToShipToMasterDataStaging',  NULL, NULL, NULL, 'delete from MTVSoldToShipToMasterDataStaging  
where MTVSoldToShipToMasterDataStaging.ProcessedDate <= DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 
 
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVSoldToShipToMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVSoldToShipToMasterDataStaging',  NULL, NULL, NULL, 'delete MTVSoldToShipToMasterDataStaging  
where MTVSoldToShipToMasterDataStaging.ProcessedDate <= DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 
 
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTV_VendorMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTV_VendorMasterDataStaging',  NULL, NULL, NULL, 'delete from MTV_VendorMasterDataStaging
where MTV_VendorMasterDataStaging.ProcessedDate <=  DATEADD(DD,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END 


GO

IF (Select 'x' from PurgeConfig where TableName = 'mtvtmsacctprodstaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('mtvtmsacctprodstaging',  NULL, NULL, NULL, 'mtv_Purge_TMSContracts', @i_purgeid, 'Y', 'A')
END 

GO

IF (Select 'x' from PurgeConfig where TableName = 'mtvtmsnominationstaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('mtvtmsnominationstaging',  NULL, NULL, NULL, 'mtv_Purge_TMSNominations', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVCreditBlock') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVCreditBlock',  NULL, NULL, NULL, 'DELETE FROM dbo.MTVOutboundCreditBlockStaging WHERE ProcessedDate < DATEADD(DAY, -90, GETDATE()); DELETE FROM dbo.MTVInboundCreditBlockStaging WHERE ProcessedDate < DATEADD(DAY, -90, GETDATE())', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVSoldToMasterDataStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVSoldToMasterDataStaging',  NULL, NULL, NULL, 'DELETE FROM dbo.MTVSoldToMasterDataStaging WHERE MTVSoldToMasterDataStaging.ProcessedDate <= DATEADD(DAY, -90, GETDATE())', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVIESExchangeStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVIESExchangeStaging',  NULL, NULL, NULL, 'DELETE FROM MTVIESExchangeStaging WHERE ImportDate <= DATEADD(dd, -30, GETDATE()) AND Action IN (''C'', ''I'')', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVSalesforceDataLakeInvoicesStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVSalesforceDataLakeInvoicesStaging',  NULL, NULL, NULL, 'DELETE FROM MTVSalesforceDataLakeInvoicesStaging WHERE LoadDateTime <= DATEADD(dd, -30, GETDATE())', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVDataLakeTransferPriceStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVDataLakeTransferPriceStaging',  NULL, NULL, NULL, 'DELETE FROM MTVDataLakeTransferPriceStaging WHERE CreatedDate <= DATEADD(dd, -30, GETDATE()) and ProcessedStatus in (''C'', ''I'')', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVOASTruckTicketStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVOASTruckTicketStaging',  NULL, NULL, NULL, 'DELETE FROM MTVOASTruckTicketStaging WHERE CreateDate <= DATEADD(dd, -30, GETDATE()) and InterfaceStatus in (''C'', ''I'')', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVDataLakeMTDTaxTransactionStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVDataLakeMTDTaxTransactionStaging',  NULL, NULL, NULL, 'DELETE FROM MTVDataLakeMTDTaxTransactionStaging WHERE CreatedDate <= DATEADD(dd, -30, GETDATE()) and ProcessedStatus in (''C'', ''I'')', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVDataLakeTaxTransactionStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVDataLakeTaxTransactionStaging',  NULL, NULL, NULL, 'DELETE FROM MTVDataLakeTaxTransactionStaging WHERE CreatedDate <= DATEADD(dd, -30, GETDATE()) and ProcessedStatus in (''C'', ''I'')', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVDataLakeMasterTaxStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVDataLakeMasterTaxStaging',  NULL, NULL, NULL, 'DELETE FROM MTVDataLakeMasterTaxStaging WHERE CreatedDate <= DATEADD(dd, -30, GETDATE()) and ProcessedStatus in (''C'', ''I'')', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVTransferToDataLakeStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVTransferToDataLakeStaging',  NULL, NULL, NULL, 'Delete from MTVTransferToDataLakeStaging where SentDate < DATEADD(DAY,-90,GetDate())', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVOASProductionConsumptionStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVOASProductionConsumptionStaging',  NULL, NULL, NULL, 'DELETE FROM dbo.MTVOASProductionConsumptionStaging WHERE ImportDate < DATEADD(DAY,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVOASInventoryStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVOASInventoryStaging',  NULL, NULL, NULL, 'DELETE FROM dbo.MTVOASInventoryStaging WHERE ImportDate < DATEADD(DAY,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END
GO

IF (Select 'x' from PurgeConfig where TableName = 'MTVFPSFuelSalesVolStaging') IS NULL
BEGIN
declare @i_purgeid int

exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVFPSFuelSalesVolStaging',  NULL, NULL, NULL, 'DELETE FROM dbo.MTVFPSFuelSalesVolStaging WHERE CreatedDate < DATEADD(DAY,-90,GETDATE())', @i_purgeid, 'Y', 'A')
END
GO

BEGIN
declare @i_purgeid int
exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVT4LineItemsStaging',  NULL, NULL, NULL, 'DELETE MTVT4LineItemsStaging FROM MTVT4NominationHeaderStaging Hdr INNER JOIN MTVT4LineItemsStaging LI ON Hdr.T4HdrID = LI.T4HdrID WHERE Hdr.ImportDate <= DATEADD(dd, -30, GETDATE()) AND Hdr.RecordStatus IN (''C'', ''I'')', @i_purgeid, 'Y', 'A')
END
GO

BEGIN
declare @i_purgeid int
exec sp_getkey 'PurgeConfig', @i_purgeid output
insert PurgeConfig values ('MTVT4NominationHeaderStaging',  NULL, NULL, NULL, 'DELETE FROM MTVT4NominationHeaderStaging WHERE ImportDate <= DATEADD(dd, -30, GETDATE()) AND RecordStatus IN (''C'', ''I'') AND (PipelineNominationVersionNumber = null Or PipelineNominationVersionNumber <=  (select isnull(Max(PipelineNominationVersionNumber),0) -1 From dbo.MTVT4NominationHeaderStaging SHdr (NOLOCK) where T4NominationNumber = SHdr.T4NominationNumber))', @i_purgeid, 'Y', 'A')
END
GO







