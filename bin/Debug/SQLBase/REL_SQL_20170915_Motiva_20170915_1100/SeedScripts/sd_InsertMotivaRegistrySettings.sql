--Manual
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\10.17.2.43\rightangle\WebServiceData\DataLake\TaxTransaction\OutBound\'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\DataLake\Export\TaxTransaction\Path',@RegEntry

GO

--Manual
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\10.17.2.43\rightangle\WebServiceData\Pega\TaxTransaction\Outbound\'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\Pega\Export\TaxTransaction\Path',@RegEntry

GO

--Manual
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\10.17.2.43\rightangle\WebServiceData\DataLake\TaxTransferPrices\Outbound\'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\DataLake\Export\TaxTransaction\TransferPrices\Path',@RegEntry

GO

--Manual
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\10.17.2.43\rightangle\WebServiceData\DataLake\Transfers\Outbound\'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\DataLake\Export\Transfers\Path',@RegEntry

GO


DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'web.services'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\CIR\User\Name\',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '456Poly'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\CIR\User\Password\',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Prices\Manual'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\Prices\Import\Manual\Path',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\Manual'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\Manual\Movements\ImportPath',@RegEntry

GO

--PetroEx
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\PetroEx'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\PetroEx\Movements\ImportPath',@RegEntry

GO

--OSPOAS
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\OSP'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\OSP\Movements\ImportPath',@RegEntry

GO

--Elemica
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\Elemica'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\Elemica\Movements\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET @RegEntry = 'Movement Document Refined Product'

EXECUTE SP_Set_Registry_Value 'Motiva\Elemica\Movements\RATemplate',@RegEntry

GO

--TMS
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\TMS'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\Movements\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry = 'Movement Document Refined Product|FSM Truck'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\Movements\FSMTruckTemplate',@RegEntry

GO


DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry = 'Movement Document Refined Product|Movement Document Refined Product'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\Movements\RATemplate',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\GaugeData\TMS'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\GaugeReadings\ImportPath',@RegEntry

GO


DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Contracts\TMS\'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\Trading\ExportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'TMSContract_'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\Trading\FileName',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Orders\TMS\'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\Orders\ExportPath',@RegEntry

GO


DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'TMSOrder_'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\orders\FileName',@RegEntry

go


--FPS
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US_AUD_RA_FPS '  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Prices\Audit\Prefix',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'YP02 '  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Prices\Rack\ConditionType',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'YPCP '  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Prices\ContractDate\ConditionType',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'YP06'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Prices\Contract\ConditionType',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Posting '  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Prices\Rack\PriceType',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Posting '  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Prices\ContractDate\PriceType',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Posting '  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Prices\Contract\PriceType',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\FPS\Prices\ImportPrices'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Prices\ImportPath',@RegEntry

GO

--OAS
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\OASActual'  

EXECUTE SP_Set_Registry_Value 'Motiva\OAS\Actual\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\OASStockUpload'  

EXECUTE SP_Set_Registry_Value 'Motiva\OAS\Inventory\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\OASIntakeProd'  

EXECUTE SP_Set_Registry_Value 'Motiva\OAS\IntakeProd\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\OASNominationProd'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\OAS\Nominations\ExportPath',@RegEntry

GO

--IES
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\IES\'  -- Example: '/Outbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\IES\Movements\ExportPath',@RegEntry

GO

--GSE
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\GSE\'  -- Example: '/Inbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\GSE\DemandForcast\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\GSE\Export\'  -- Example: '/Outbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\GSE\ActualSales\ExportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Movements\OASTruckTickets\'  -- Example: '/Outbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\OAS\TruckTickets\ExportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Manual Truck Tickets to OAS'

EXECUTE SP_Set_Registry_Value 'Motiva\OAS\TruckTickets\MovementDocumentTemplateName',@RegEntry



GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Tax\DataLakeTax'  

EXECUTE SP_Set_Registry_Value 'Motiva\DataLakeTax\ExportPath',@RegEntry

GO

DECLARE @RegEntry   VARCHAR(255)
SET     @RegEntry   = '8004249300'

Execute SP_Set_Registry_Value 'Motiva\TMS\Trading\EmergencyNumber',@RegEntry

GO

DECLARE @RegEntry   VARCHAR(255)
SET     @RegEntry   = 'CHEMTREC'

Execute SP_Set_Registry_Value 'Motiva\TMS\Trading\EmergencyCompany',@RegEntry

GO


DECLARE @RegEntry   VARCHAR(255)
SET     @RegEntry   = '12/31/2049'

Execute SP_Set_Registry_Value 'Motiva\TMS\Trading\ContractEndDate',@RegEntry

GO

DECLARE @RegEntry   VARCHAR(255)
SET     @RegEntry   = '1'

Execute SP_Set_Registry_Value 'Motiva\TMS\Trading\route_cd_type',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US_SAV_RA_FPS'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\Prefix',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\FPS\Audit\Exports'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\Audit\ExportPath',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '0'  

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\seqnum',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '602' 

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\rectype',@RegEntry




GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '2'  

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\sitrefflag',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '0'  

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\prorefflag',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '0'  

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\rangeflag',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '0'  

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\type',@RegEntry


GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'FPS Retail Reports'  

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\transactiongroup',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'CT Gross Receipts'  

EXECUTE SP_Set_Registry_Value 'Motiva\Tax\CTGrossReceipts\transactiongroup',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Federal Oil Spill Tax'  

EXECUTE SP_Set_Registry_Value 'Motiva\Tax\CTGrossReceipts\taxdescription',@RegEntry


GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\FPS\SalesInvoiceFiles\'  

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\SalesInvoiceFiles\ExportPath',@RegEntry
GO

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '70,71,72,73,74,75,76,77,78,79,272,273,274,275'  

EXECUTE SP_Set_Registry_Value 'Motiva\Tax\DataLakeMaster\ExcludeFinancialDealIDS\',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'CashSettledFuturePrice'

EXECUTE SP_Set_Registry_Value 'Motiva\FutureProvision\FutureProvisionName\',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '83'

EXECUTE SP_Set_Registry_Value 'Motiva\FutureProvision\FutureDateRuleID\',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Y' 

EXECUTE SP_Set_Registry_Value 'Motiva\FutureProvision\EnableRule\',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US' 

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\SavCouCode',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\FPS\TransferPrices\Export'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\TransferPrices\ExportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '2'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\prorefflag',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '2'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\sitrefflag',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\countrycode',@RegEntry

GO


DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US_LVP_RA_FPS'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\TransferPrices\headerprefix',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US_TRF_RA_FPS'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\TarrifPrices\headerprefix',@RegEntry

GO


DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '800'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\TransferPrices\condtab',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '611'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\TransferPrices\rectype',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\BaseOils\SaleOrders' 

EXECUTE SP_Set_Registry_Value 'Motiva\BaseOils\DocGen\ConfirmationPath',@RegEntry

GO

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'N'  

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FuelSales\OneByOne',@RegEntry

GO
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Tax\DataLakeTransaction\TaxTransactionExportFields.xml'

EXECUTE SP_Set_Registry_Value 'Motiva\Tax\DataLakeTaxTransaction\DataLakeSelectionColumn\',@RegEntry

GO

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Tax\TaxTransaction'  

EXECUTE SP_Set_Registry_Value 'Motiva\Tax\DataLakeTaxTransaction\ExportPath\',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'BKPFF'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\Idoc\Obj_Type',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'BMODALL'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\Idoc\Username',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '121'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\Idoc\MANDT',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'DEV0000023'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\Idoc\SNDPOR',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'DEV0000025'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\Idoc\RCVPOR',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'DEVCLNT120'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\Idoc\RCVPRN',@RegEntry

GO
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'T1'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\Idoc\DefaultTaxCode',@RegEntry

GO
--RKC Added on 04/26/2016
--Elemica 
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'N'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\Elemica\Movements\ActualizeOnLoad',@RegEntry

GO
--RKC Added on 04/27/2016
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'USG6'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\TransferPrices\UOM',@RegEntry

Go

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'BEN-Bengal Pipeline|CPL-Colonial Pipeline'  

EXECUTE SP_Set_Registry_Value 'Motiva\Orders\T4\PipelineCycleCarrierCode',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Orders\T4Nomination' 

EXECUTE SP_Set_Registry_Value 'Motiva\Orders\T4\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\CreditBlock\Inbound' 

EXECUTE SP_Set_Registry_Value 'Motiva\CreditBlock\Inbound\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\CreditBlock\Outbound' 

EXECUTE SP_Set_Registry_Value 'Motiva\CreditBlock\Outbound\ExportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'N'

EXECUTE SP_Set_Registry_Value 'Motiva\CreditBlock\Outbound\UseService',@RegEntry

GO

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '2' 

EXECUTE SP_Set_Registry_Value 'Motiva\Orders\T4\AddEndDays',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\Accounting\SalesforceDataLakeInvoices\RAInvoicestoSalesforceDataLake'  

EXECUTE SP_Set_Registry_Value 'Motiva\Accounting\SalesforceDataLakeInvoices\ExportPath\',@RegEntry

GO

--- Modified by JACM 1/27/2017: Changed PortfolioId from 18 to 1 
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '1'  

EXECUTE SP_Set_Registry_Value 'Motiva\Credit\Exposure\PortfolioId\',@RegEntry

GO

--- Modified by JACM 1/27/2017: Changed BAIDs from 1,363,361
DECLARE	@RegEntry	VARCHAR(255)
DECLARE @lstIntraBaIds VARCHAR(MAX)
SELECT @lstIntraBaIds = COALESCE(@lstIntraBaIds+ ',' ,'') + CAST(BAID as varchar)
FROM BusinessAssociate where BATpe In ('C', 'D')

SET		@RegEntry = @lstIntraBaIds
EXECUTE SP_Set_Registry_Value 'Motiva\Credit\Exposure\BaIds\',@RegEntry

GO

--Added by RKC on 06/02/2016
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US_REC_RA_FPS' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\prefix',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\cou_code',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '623' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\i_gpr_rec_type',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\i_gpr_cou_code',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '604' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\i_gpr_condition_table\YP06',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '622' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\i_gpr_condition_table\YP02',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '1' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\i_gpr_quantity',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'A' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\i_gpr_cond_tab_usage',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'C' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\i_gpr_calculation_type',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'GAL' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\i_gpr_UOM',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'C:\Motiva\FPS\FPSPriceRecon\Export' 
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\OutBound\FPSRecon\ExportPath',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Sales - Accrual'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\GLXctnTypes\SalesAccrual',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Purchase - Accrual'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\GLXctnTypes\PurchaseAccrual',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Incomplete Price - Accrual'

EXECUTE SP_Set_Registry_Value 'Motiva\SAP\GLXctnTypes\IncompletePricingAccrual',@RegEntry

GO



--Added by MattV, we need these rows so that SoldTo/ShipTo logic is not hardcoded by IntrnlBAID
DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'MOTIVA-FSM'

EXECUTE SP_Set_Registry_Value 'MotivaFSMIntrnlBAName',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'MOTIVA-BASE OILS'

EXECUTE SP_Set_Registry_Value 'MotivaBaseOilsIntrnlBAName',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'MOTIVA-STL'

EXECUTE SP_Set_Registry_Value 'MotivaSTLIntrnlBAName',@RegEntry

GO


DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'MOTIVA-PT ARTHUR'

EXECUTE SP_Set_Registry_Value 'MotivaPTArthrIntrnlBAName',@RegEntry

GO



DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'US Bank Calendar'

EXECUTE SP_Set_Registry_Value 'MotivaUSCalendarName',@RegEntry

GO

DECLARE @RegEntry VARCHAR(255)
SET		@RegEntry = '2'

EXECUTE SP_Set_Registry_Value 'MotivaFPSAllowedDealType', @RegEntry

GO
DECLARE       @RegEntry     VARCHAR(255)
SET           @RegEntry     = ( select Locale.lcleabbrvtn from locale where lcleabbrvtn like '%BOMP%' )
EXECUTE SP_Set_Registry_Value 'Motiva\TMS\Scheduling\BaseOilPlantAbbrvtn',@RegEntry

GO


DECLARE       @RegEntry     VARCHAR(255)
SET           @RegEntry     = '0000000002' 
EXECUTE SP_Set_Registry_Value 'Motiva\TMS\Trading\MotivaAccountNo',@RegEntry

GO

--invoices
Declare @RegEntry   varchar(255)
Select @RegEntry = ( Select  BusinessAssociate.BaAbbrvtn  From BusinessAssociate where Baabbrvtn like '%motiva%STL%' )
Execute SP_Set_Registry_Value 'System\SalesInvoicing\UseDeliveryLocationShipTo',@RegEntry
GO

Declare @RegEntry   varchar(255)
Select @RegEntry = '3rd Party Deferred Tax Invoice'
Execute SP_Set_Registry_Value 'System\SalesInvoicing\DeferredTaxInvoiceTypeName',@RegEntry
GO

Declare @RegEntry   varchar(20)
Select @RegEntry = 'UQZ4EDMHL4ZESPZY3752'
Execute SP_Set_Registry_Value 'Motiva\Trading\LegalEntityIdentifier',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\GaugeFreezeData\TMS'  -- Example: '/PayableInbound/'

EXECUTE SP_Set_Registry_Value 'Motiva\TMS\GaugeFreezeReadings\ImportPath',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= 'Transfer Price'

EXECUTE SP_Set_Registry_Value 'STLFSM_TransferPriceServiceName',@RegEntry

GO


--DECLARE	@RegEntry	VARCHAR(255)
--SET		@RegEntry	= '\\MOTAPPQA14001\WebServiceData\ReferenceData\Customers'  -- Example: '/Customers/'

--EXECUTE SP_Set_Registry_Value 'Motiva\ReferenceData\Customers\ImportPath',@RegEntry
--GO


DECLARE       @RegEntry     VARCHAR(255)
SET           @RegEntry     = '59'  
EXECUTE SP_Set_Registry_Value 'Motiva\OAS\Inventory\BlendingDeals\',@RegEntry
GO

DECLARE       @RegEntry     VARCHAR(255)
SET           @RegEntry     = 'USK7'  
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Defaults\CountryCode\',@RegEntry
GO

DECLARE       @RegEntry     VARCHAR(255)
SET           @RegEntry     = 'US'  
EXECUTE SP_Set_Registry_Value 'Motiva\FPS\Defaults\Country\',@RegEntry
GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '2016-08-01'  

EXECUTE SP_Set_Registry_Value 'Motiva\Tax\DataLakeTaxTransaction\FirstTimePublishDate\',@RegEntry

GO

DECLARE	@RegEntry	VARCHAR(255)
SET		@RegEntry	= '00:04:00'  --Specify the next refresh interval in HH:mm:ss

EXECUTE SP_Set_Registry_Value 'Motiva\RefreshCustomCacheInterval\',@RegEntry

GO