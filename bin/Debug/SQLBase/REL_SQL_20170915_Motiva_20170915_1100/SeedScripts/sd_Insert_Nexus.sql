Print 'Start Script=sd_Insert_Nexus.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

INSERT INTO KeyController (KyCntrllrTble,KyCntrllrMxKy)
SELECT 'NexusMessage',0
WHERE NOT EXISTS (SELECT 1 FROM KeyController WHERE KyCntrllrTble = 'NexusMessage')

DECLARE @FileShareRoot VARCHAR(200)
IF (@@SERVERNAME = 'MOTDBSQA11001')
	SELECT @FileShareRoot = '\\10.17.2.43\rightangle\WebServiceData\'
ELSE
BEGIN
IF (@@SERVERNAME = 'MOTDBSPRDVIP3\RIGHTANGLE_PROD')
	SELECT @FileShareRoot = '\\Motappprd0134\RIGHTANGLE\WebServiceData\'
ELSE
	SELECT @FileShareRoot = 'C:\Motiva\Nexus\'
END
IF  OBJECT_ID(N'tempdb..#NexusRouterTypeTemp') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[#NexusRouterTypeTemp]
    PRINT '<<< DROPPED TABLE #NexusRouterTypeTemp >>>'
END

CREATE TABLE dbo.#NexusRouterTypeTemp(
RouterID	int
,RouterName	varchar(50)
,RouterDescription	varchar(200)
,WebAddress	varchar(max)
,CallBackClass	varchar(max)
,PostMethod	char(1)
,FilePath	varchar(255)
,ArchiveFilePath	varchar(255)
,FileExtension	char(3)
,ErrorMessage	varchar(max)
)

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'CreditBlockOutbound','Credit Block Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'CreditBlock\OutBound\',@FileShareRoot + 'CreditBlock\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'CreditBlockInbound','Credit Block Inbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Credit.Entities.CreditBlockMessageHandler','W',@FileShareRoot + 'CreditBlock\InBound\',@FileShareRoot + 'CreditBlock\InBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'OASTruckOutbound','OAS Truck Tickets Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'OAS\TruckTickets\OutBound\',@FileShareRoot + 'OAS\Truck\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'OASNominationOutbound','OAS Nomination Export Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'OAS\Nomination\OutBound\',@FileShareRoot + 'OAS\Nomination\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'OASActualInbound','OAS Actual Inbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Scheduling.Entities.Movements.OASActual.MTVOASActualMessageHandler','W',@FileShareRoot + 'OAS\Actual\InBound\',@FileShareRoot + 'OAS\Actual\InBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'OASInventoryInbound','OAS Inventory Inbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Scheduling.Entities.Movements.OASInventory.MTVOASInventoryMessageHandler','W',@FileShareRoot + 'OAS\Inventory\InBound\',@FileShareRoot + 'OAS\Inventory\InBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'OASProductionConsumptionInbound','OAS Production Consumption Inbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Scheduling.Entities.Movements.OASProductionConsumption.MTVOASProductionConsumptionMessageHandler','W',@FileShareRoot + 'OAS\ProductionConsumption\InBound\',@FileShareRoot + 'OAS\ProductionConsumption\InBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'SAPAROutbound','SAP AR Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Accounting.Entities.SAPInterface.MTVSAPMessageHandler','F',@FileShareRoot + 'SAP\AR\OutBound\',@FileShareRoot + 'SAP\AR\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'SAPAPOutbound','SAP AP Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Accounting.Entities.SAPInterface.MTVSAPMessageHandler','F',@FileShareRoot + 'SAP\AP\OutBound\',@FileShareRoot + 'SAP\AP\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'SAPGLOutbound','SAP GL Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Accounting.Entities.SAPInterface.MTVSAPMessageHandler','F',@FileShareRoot + 'SAP\GL\OutBound\',@FileShareRoot + 'SAP\GL\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeMasterOutbound','Data Lake Master Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'DataLake\TaxMaster\OutBound\','','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'PegaTaxMasterOutbound','Pega Tax Master Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'Pega\TaxMaster\Outbound\','','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'SalesForceToDataLakeOutbound','Sales Force To DataLake Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'SalesForce\RetailerInvoice\Outbound\',@FileShareRoot + 'SalesForce\RetailerInvoice\Outbound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakePricesOutbound','RA To DataLake Prices Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'DataLake\Prices\OutBound\',@FileShareRoot + 'DataLake\Prices\OutBound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'FPSPriceStageInbound','FPS Price Staging Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Pricing.Tasks.FPSStagingNexusMessageHandler','W',@FileShareRoot + 'FPS\Price\InBound\',@FileShareRoot + 'FPS\Price\InBound\Archive','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'FPSPriceLoadAuditOutbound','FPS Price Load Audit Message Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'FPS\PriceAudit\OutBound\',@FileShareRoot + 'FPS\PriceAudit\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'FPSFuelSalesVolumeOutbound','FPS Fuel sales volume Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'FPS\FuelSalesVolume\OutBound\',@FileShareRoot + 'FPS\FuelSalesVolume\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'T4NominationInbound','T4 Nomination Inbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Scheduling.Entities.Orders.T4.MTVT4MessageHandler','W',@FileShareRoot + 'T4Nomination\OutBound\',@FileShareRoot + 'T4Nomination\OutBound\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'OrionNominationOutbound','Orion Nomination Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Scheduling.Entities.Orion.OrionNominationService','F',@FileShareRoot + 'Orion\OutBound\',@FileShareRoot + 'Orion\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT '6To9Outbound','TMS 6 to SAP 9 Mat Code Cross Ref Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Trading.Entities.MTVTMSSAPMaterialCodeXRefWebService','W',@FileShareRoot + 'SixToNine\OutBound\',@FileShareRoot + 'SixToNine\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'RetailContractOutbound','Retail Contract Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Trading.Entities.RAToFPSInterface.MtvRaToFpsServiceMessageHandler','F',@FileShareRoot + 'FPS\RetailContract\OutBound\',@FileShareRoot + 'FPS\RetailContract\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'ElemicaInbound','Elemica Tickets Inbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','Motiva.RightAngle.Server.Scheduling.Entities.Elemica.ElemicaInboundMessageReceiver','W','','',''

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'TMSActualsInbound','TMS Actuals Inbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','Motiva.RightAngle.Server.Scheduling.Entities.TMS.TMSActualsMessageReceiver','F',@FileShareRoot + 'TMS\Actuals\InBound\',@FileShareRoot + 'TMS\Actuals\InBound\Archive\','dat'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'TMSGaugeReadingsInbound','TMS Close Gauge Readings Inbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','Motiva.RightAngle.Server.Scheduling.Entities.Gauge.TMS.TMSGaugeReadingMessageReceiver','F',@FileShareRoot + 'TMS\TankGauge\InBound\',@FileShareRoot + 'TMS\TankGauge\InBound\Archive\','dat'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'TMSGaugeFreezeReadingsInbound','TMS Freeze Gauge Readings Inbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','Motiva.RightAngle.Server.Scheduling.Entities.Gauge.TMS.TMSGaugeFreezeReadingMessageReceiver','F',@FileShareRoot + 'TMS\TankGaugeFreeze\InBound\',@FileShareRoot + 'TMS\TankGaugeFreeze\InBound\Archive\','dat'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'FPSTransferPriceOutbound','Publish Transfer Prices','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'FPS\TransferPrices\OutBound\',@FileShareRoot + 'FPS\TransferPrices\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'FPSTariffPriceOutbound','Publish Tariff Prices','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'FPS\TariffPrices\OutBound\',@FileShareRoot + 'FPS\TariffPrices\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'FPSReconPricesOutbound','Publish FPS Reconciled Prices','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'FPS\ReconPrices\OutBound\',@FileShareRoot + 'FPS\ReconPrices\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeInventoryInventoryTransactionsPegaOutbound','Data Lake Inventory Inventory Transactions Pega Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'Pega\TaxInventory\InventoryTransactions\OutBound\',@FileShareRoot + 'Pega\TaxInventory\OutBound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeInventoryInventoryTransactionsOutbound','Data Lake Inventory Inventory Transactions Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'DataLake\TaxInventory\InventoryTransactions\OutBound\',@FileShareRoot + 'DataLake\TaxInventory\OutBound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeInventoryTransactionsPegaOutbound','Data Lake Inventory Transactions Pega Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'Pega\TaxInventory\Transactions\Outbound\',@FileShareRoot + 'Pega\TaxInventory\Outbound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeInventoryTransactionsOutbound','Data Lake Inventory Transactions Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'DataLake\TaxInventory\Transactions\OutBound\',@FileShareRoot + 'DataLake\TaxInventory\OutBound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeInventoryBalancesPegaOutbound','Data Lake Inventory Balances Pega Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'Pega\TaxInventory\Balance\Outbound\',@FileShareRoot + 'Pega\TaxInventory\Outbound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeInventoryBalancesOutbound','Data Lake Inventory Balances Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'DataLake\TaxInventory\Balance\OutBound\',@FileShareRoot + 'DataLake\TaxInventory\OutBound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeInventoryPricesPegaOutbound','Data Lake Inventory Prices Pega Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'Pega\TaxInventory\Prices\Outbound\',@FileShareRoot + 'Pega\TaxInventory\Outbound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeInventoryPricesOutbound','Data Lake Inventory Prices Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'DataLake\TaxInventory\Prices\OutBound\',@FileShareRoot + 'DataLake\TaxInventory\OutBound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'CreditExposureInterfaceOutbound','Credit Exposure Interface Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'Credit\Exposure\OutBound\',@FileShareRoot + 'Credit\Exposure\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName, RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'TMSContractOutbound','TMS Contract Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'TMS\Contract\OutBound\',@FileShareRoot + 'TMS\Contract\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'CreditCurveInterfaceOutbound','Credit Curve Interface Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'Credit\Curve\OutBound\',@FileShareRoot + 'Credit\Curve\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'TMSNominationOutbound','TMS Nomination Outbound File','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot + 'TMS\Nomination\Outbound\',@FileShareRoot + 'TMS\Orders\Outbound\','dat'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'CreditCurveInterfaceInbound','Credit Curve Interface inbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Risk.Entities.MTVCreditCurve.MTVCreditCurveServiceMessageHandler','W',@FileShareRoot +'Credit\Curve\InBound\',@FileShareRoot +'Credit\Curve\InBound\Archive','xml'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'CreditExposureInterfaceInbound','Credit Exposure Interface inbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Risk.Entities.MTVCreditExposure.MTVCreditExposureService','W',@FileShareRoot+'Credit\Exposure\InBound\',@FileShareRoot +'Credit\Exposure\InBound\Archive','xml'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'EmptorisInterfaceOutbound','Emptoris Interface Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.Trading.Entities.CIR.MTVEmptorisMessageHandler','F',@FileShareRoot+'Emptoris\OutBound\',@FileShareRoot +'Emptoris\OutBound\Archive','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'LocationMasterDataInbound','Location Master Data Inbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','Motiva.RightAngle.Server.ReferenceData.Tasks.LocationMasterData.LocationMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\LocationMasterData\Inbound\' ,@FileShareRoot+'ReferenceData\LocationMasterData\Inbound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'ProductMasterDataInbound','Product Master Data Inbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','Motiva.RightAngle.Server.ReferenceData.Tasks.ProductMasterData.ProductMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\ProductMasterData\Inbound\' ,@FileShareRoot+'ReferenceData\ProductMasterData\Inbound\Archive','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeTransferPriceOutbound','DataLake Transfer Price Outbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','','F',@FileShareRoot+'DataLake\TransferPrices\Outbound\' ,@FileShareRoot+'DataLake\TransferPrices\Outbound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeTransferOutbound','DataLake Transfer Outbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','','F',@FileShareRoot+'DataLake\Transfer\Outbound\' ,@FileShareRoot+'DataLake\Transfer\Outbound\Archive\','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'DataLakeTariffPriceOutbound','DataLake Tariff Price Outbound','http://localhost/RightAngle.15.0/MotivaServices/NexusInterface.svc','','F',@FileShareRoot+'DataLake\TariffPrices\OutBound\' ,@FileShareRoot+'DataLake\TariffPrices\OutBound\Archive\','xml'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'LocationMasterDataOutbound','Location Master Data Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\LocationMasterData\Outbound\' ,@FileShareRoot+'ReferenceData\LocationMasterData\Outbound\Archive\','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'CustomerMasterDataInbound','Customer Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.CustomerMasterData.CustomerDataMessageHandler','F',@FileShareRoot+'ReferenceData\CustomerMasterData\Inbound',@FileShareRoot +'ReferenceData\CustomerMasterData\Inbound\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'CustomerMasterDataOutbound','Customer Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\CustomerMasterData\Outbound',@FileShareRoot +'ReferenceData\CustomerMasterData\Outbound\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'ContactMasterDataInbound','Contact Master Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.ContactMasterData.ContactMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\ContactMasterData\Inbound',@FileShareRoot +'ReferenceData\ContactMasterData\Inbound\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'ContactMasterDataOutbound','Contact Master Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\ContactMasterData\Outbound',@FileShareRoot +'ReferenceData\ContactMasterData\Outbound\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'VendorMasterDataInbound','Vendor Master Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.VendorMasterData.VendorMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\VendorMasterData\Inbound',@FileShareRoot +'ReferenceData\VendorMasterData\Inbound\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'VendorMasterDataOutbound','Vendor Master Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\VendorMasterData\Outbound',@FileShareRoot +'ReferenceData\VendorMasterData\Outbound\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'SoldToShipToMasterDataInbound','Customer SoldToShipTo Master Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.CustomerSoldToShipToMasterData.CustomerSoldToShipToMessageHandler','F',@FileShareRoot+'ReferenceData\SoldToShipToMasterData\Inbound',@FileShareRoot +'ReferenceData\SoldToShipToMasterData\Inbound\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'SoldToShipToMasterDataOutbound','Customer SoldToShipTo Master Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\SoldToShipToMasterData\Outbound',@FileShareRoot +'ReferenceData\SoldToShipToMasterData\Outbound\Archive','csv'

INSERT INTO #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
SELECT 'ProductMasterDataOutbound','Product Master Data Outbound','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\ProductMasterData\Outbound\' ,@FileShareRoot+'ReferenceData\ProductMasterData\Outbound\Archive\','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'SoldToMasterDataInbound','SoldTo Master Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.CustomerSoldToMasterData.CustomerSoldToMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\SoldToMasterData\Inbound',@FileShareRoot +'ReferenceData\SoldToMasterData\Inbound\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'SoldToMasterDataOutbound','SoldTo Master Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\SoldToMasterData\Outbound',@FileShareRoot +'ReferenceData\SoldToMasterData\Outbound\Archive','csv'


----- Vendor Contact Router
insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'VendorContactMasterDataInbound','Vendor Contact Master Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.ContactMasterData.ContactMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\ContactMasterData\Inbound\VendorContacts',@FileShareRoot +'ReferenceData\ContactMasterData\Inbound\VendorContacts\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'VendorContactMasterDataOutbound','Vendor Contact Master Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\ContactMasterData\Outbound\VendorContacts',@FileShareRoot +'ReferenceData\ContactMasterData\Outbound\VendorContacts\Archive','csv'

-- Customer Contact Router
insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'CustomerContactMasterDataInbound','Customer Contact Master Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.ContactMasterData.ContactMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\ContactMasterData\Inbound\CustomerContacts',@FileShareRoot +'ReferenceData\ContactMasterData\Inbound\CustomerContacts\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'CustomerContactMasterDataOutbound','Customer Contact Master Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\ContactMasterData\Outbound\CustomerContacts',@FileShareRoot +'ReferenceData\ContactMasterData\Outbound\CustomerContacts\Archive','csv'

--- Customer SoldTo Router
insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'CustomerSoldToMasterDataInbound','Customer SoldTo Master Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.CustomerSoldToMasterData.CustomerSoldToMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\SoldToMasterData\Inbound\CustomerSoldTo',@FileShareRoot +'ReferenceData\SoldToMasterData\Inbound\CustomerSoldTo\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'CustomerSoldToMasterDataOutbound','Customer SoldTo Master Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\SoldToMasterData\Outbound\CustomerSoldTo',@FileShareRoot +'ReferenceData\SoldToMasterData\Outbound\CustomerSoldTo\Archive','csv'


--- Vendor SoldTo Router
insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'VendorSoldToMasterDataInbound','Vendor SoldTo Master Data Inbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','Motiva.RightAngle.Server.ReferenceData.Entities.CustomerSoldToMasterData.CustomerSoldToMasterDataMessageHandler','F',@FileShareRoot+'ReferenceData\SoldToMasterData\Inbound\VendorSoldTo',@FileShareRoot +'ReferenceData\SoldToMasterData\Inbound\VendorSoldTo\Archive','csv'

insert into #NexusRouterTypeTemp (RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension)
Select 'VendorSoldToMasterDataOutbound','Vendor SoldTo Master Data Outbound Router','http://10.17.2.97/RightAngleToBiztalk/RightAngleToBiztalk.svc','','F',@FileShareRoot+'ReferenceData\SoldToMasterData\Outbound\VendorSoldTo',@FileShareRoot +'ReferenceData\SoldToMasterData\Outbound\VendorSoldTo\Archive','csv'



--Find all IDs for RouterNames that already exist
UPDATE #NexusRouterTypeTemp
SET RouterID = (SELECT TOP 1 RouterID from NexusRouterType NRTReal WHERE #NexusRouterTypeTemp.RouterName = NRTReal.RouterName)


--Update the values in the Real NexusRouterType table
UPDATE NRTReal
SET
NRTReal.RouterName = NRTTemp.RouterName
,NRTReal.RouterDescription = NRTTemp.RouterDescription
,NRTReal.WebAddress = NRTTemp.WebAddress
,NRTReal.CallBackClass = NRTTemp.CallBackClass
,NRTReal.PostMethod = NRTTemp.PostMethod
,NRTReal.FilePath = NRTTemp.FilePath
,NRTReal.ArchiveFilePath = NRTTemp.ArchiveFilePath
,NRTReal.FileExtension = NRTTemp.FileExtension
FROM NexusRouterType as NRTReal
INNER JOIN #NexusRouterTypeTemp NRTTemp
ON NRTTemp.RouterID IS NOT NULL and NRTReal.RouterID = NRTTemp.RouterID 

--Update Temp table to Success for records whose values were updated correctly
UPDATE NRTTemp
SET NRTTemp.ErrorMessage = 'Success'
FROM #NexusRouterTypeTemp NRTTemp
INNER JOIN NexusRouterType NRTReal
ON NRTTemp.RouterID IS NOT NULL AND NRTTemp.RouterID = NRTReal.RouterID
AND (NRTReal.RouterName = NRTTemp.RouterName
AND NRTReal.RouterDescription = NRTTemp.RouterDescription
AND NRTReal.WebAddress = NRTTemp.WebAddress
AND NRTReal.CallBackClass = NRTTemp.CallBackClass
AND NRTReal.PostMethod = NRTTemp.PostMethod
AND NRTReal.FilePath = NRTTemp.FilePath
AND NRTReal.ArchiveFilePath = NRTTemp.ArchiveFilePath
AND NRTReal.FileExtension = NRTTemp.FileExtension)

--Update Temp table to Error for records whose values were not updated correctly
UPDATE NRTTemp
SET NRTTemp.ErrorMessage = 'Error, Router Found but Not Updated'
FROM #NexusRouterTypeTemp NRTTemp
INNER JOIN NexusRouterType NRTReal
ON NRTTemp.RouterID IS NOT NULL AND NRTTemp.RouterID = NRTReal.RouterID
AND (NRTReal.RouterName <> NRTTemp.RouterName
AND NRTReal.RouterDescription <> NRTTemp.RouterDescription
AND NRTReal.WebAddress <> NRTTemp.WebAddress
AND NRTReal.CallBackClass <> NRTTemp.CallBackClass
AND NRTReal.PostMethod <> NRTTemp.PostMethod
AND NRTReal.FilePath <> NRTTemp.FilePath
AND NRTReal.ArchiveFilePath <> NRTTemp.ArchiveFilePath
AND NRTReal.FileExtension <> NRTTemp.FileExtension)

--Insert new records that did not already exist
INSERT INTO NexusRouterType
(RouterName
,RouterDescription
,WebAddress
,CallBackClass
,PostMethod
,FilePath
,ArchiveFilePath
,FileExtension)
SELECT RouterName,RouterDescription,WebAddress,CallBackClass,PostMethod,FilePath,ArchiveFilePath,FileExtension
FROM #NexusRouterTypeTemp AS NRTTemp
WHERE NRTTemp.RouterID IS NULL AND ErrorMessage IS NULL


--Update Temp table with new IDs and success/error
UPDATE NRTTemp
SET NRTTemp.RouterID = NRTReal.RouterID, NRTTemp.ErrorMessage = 'Success'
FROM NexusRouterType NRTReal
INNER JOIN #NexusRouterTypeTemp NRTTemp
ON NRTTemp.RouterID IS NULL 
AND NRTReal.RouterName = NRTTemp.RouterName
AND NRTReal.RouterDescription = NRTTemp.RouterDescription
AND NRTReal.WebAddress = NRTTemp.WebAddress
AND NRTReal.CallBackClass = NRTTemp.CallBackClass
AND NRTReal.PostMethod = NRTTemp.PostMethod
AND NRTReal.FilePath = NRTTemp.FilePath
AND NRTReal.ArchiveFilePath = NRTTemp.ArchiveFilePath
AND NRTReal.FileExtension = NRTTemp.FileExtension
AND NRTReal.PostMethod = NRTTemp.PostMethod
AND NRTReal.FilePath = NRTTemp.FilePath

--Update Temp table with Error for any that were no successful
UPDATE #NexusRouterTypeTemp
SET ErrorMessage = 'Error, unknown'
where RouterID IS NULL

--SELECT * FROM #NexusRouterTypeTemp
--ORDER BY RouterID

Print 'End Script=sd_Insert_Nexus.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO