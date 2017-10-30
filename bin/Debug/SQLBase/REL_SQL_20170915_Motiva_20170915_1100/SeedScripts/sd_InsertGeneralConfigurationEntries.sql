INSERT	GeneralConfiguration
SELECT	'Office'
		,'InvoiceATTN'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'InvoiceATTN'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Office'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)

GO

INSERT	GeneralConfiguration
SELECT	'Office'
		,'MailingATTN'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'MailingATTN'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Office'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
					
GO

INSERT	GeneralConfiguration
SELECT	'Office'
		,'RemitToATTN'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'RemitToATTN'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Office'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
					
GO

INSERT	GeneralConfiguration
SELECT	'Office'
		,'ShippingATTN'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ShippingATTN'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Office'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	

GO

INSERT	GeneralConfiguration
SELECT	'Product'
		,'SAPMaterialCode'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPMaterialCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
GO

INSERT	GeneralConfiguration
SELECT	'Locale'
		,'SAPPlantCode'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPPlantCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
GO
INSERT	GeneralConfiguration
SELECT	'BusinessAssociate'
		,'SAPVendorNumber'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPVendorNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
GO
INSERT	GeneralConfiguration
SELECT	'DealHeader'
		,'SAPSoldTo'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
GO
INSERT	GeneralConfiguration
SELECT	'BusinessAssociate'
		,'SAPSalesOrganization'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSalesOrganization'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
GO

INSERT	GeneralConfiguration
SELECT	'BusinessAssociate'
		,'SAPCustomerNumber'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPCustomerNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
					GO

INSERT	GeneralConfiguration
SELECT	'Locale'
		,'TCN'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TCN'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
					GO

--REMOVE Existing OLD Attribute
DELETE FROM	generalconfiguration WHERE	generalconfiguration.GnrlCnfgQlfr = 'TerminalOperator' AND	GnrlCnfgHdrId = 0

INSERT	GeneralConfiguration
SELECT	'Locale'
		,'TerminalOperator'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TerminalOperator'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
GO

INSERT	GeneralConfiguration
SELECT	'Locale'
		,'RCN'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'RCN'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
GO

INSERT	GeneralConfiguration
SELECT	'Product'
		,'FTAProduct'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'FTAProduct'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	
GO
INSERT	GeneralConfiguration
SELECT	'Product'
		,'FTAProductCode'
		,0
		,0
		,'X'
WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'FTAProductCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)	


--Generated via script builder
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','SalesOrganization',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SalesOrganization'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','DistributionChannel',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'DistributionChannel'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','SupplierNumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SupplierNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','SAPIntCoID',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPIntCoID'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','PosHolderName',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PosHolderName'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','PosHolderFEIN',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PosHolderFEIN'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','PosHolderNmeCntrl',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PosHolderNmeCntrl'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','EPANumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'EPANumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'BusinessAssociate','TopTechID',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TopTechID'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','Ratio',0,0,'########0.00' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Ratio'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','QAPStatusCheckbox',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'QAPStatusCheckbox'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','QCACheckbox',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'QCACheckbox'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','Assignment',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Assignment'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','Scheduler',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Scheduler'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','Asset',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Asset'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','Measurement',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Measurement'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','SendToTMS',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SendToTMS'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','SAPDtlMaterialCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPDtlMaterialCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','HedgeMonth',0,0,'mm/dd/yyyy hh:mm' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'HedgeMonth'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealDetail','PricingDate',0,0,'mm/dd/yyyy hh:mm' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PricingDate'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealDetail'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','HedgeMonth',0,0,'mm/dd/yyyy hh:mm' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'HedgeMonth'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','Generator',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Generator'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','PhysXRef',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PhysXRef'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','ExtEPAOrgID',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ExtEPAOrgID'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','IntEPAOrgID',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'IntEPAOrgID'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','BrokerageFeeType',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'BrokerageFeeType'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','ExecutionTime',0,0,'mm/dd/yyyy hh:mm' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ExecutionTime'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','PhysicalXref',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PhysicalXref'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','AggregateFillQty',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'AggregateFillQty'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','CTO',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'CTO'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','MvtSumProductGroups',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'MvtSumProductGroups'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','MvtSumExcludeMoveTyp',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'MvtSumExcludeMoveTyp'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','TMSIntransit',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TMSIntransit'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'DealHeader','SAPVendorNo',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPVendorNo'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'ExchangeTradedDeal','HedgeMonth',0,0,'mm/dd/yyyy hh:mm' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'HedgeMonth'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'ExchangeTradedDeal'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'ExchangeTradedDeal','BrokerageFeeType',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'BrokerageFeeType'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'ExchangeTradedDeal'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'ExchangeTradedDeal','ExecutionTime',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ExecutionTime'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'ExchangeTradedDeal'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'ExchangeTradedDeal','PhysicalXref',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PhysicalXref'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'ExchangeTradedDeal'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','CCTSite',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'CCTSite'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','SendOASOrders',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SendOASOrders'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','SendOrionOrders',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SendOrionOrders'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','SendTMSHostOrders',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SendTMSHostOrders'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','CountryCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'CountryCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'StrategyHeader','CostCenter',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'CostCenter'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','TaxJursidictionCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TaxJursidictionCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','USFedCityCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'USFedCityCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','USFedCountyCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'USFedCountyCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','USFedStateCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'USFedStateCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','AddrLine1',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'AddrLine1'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','AddrLine2',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'AddrLine2'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','PostalCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PostalCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','FTZ',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'FTZ'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','CityName',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'CityName'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','StateAbbreviation',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'StateAbbreviation'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','EquityTerminal',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'EquityTerminal'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Locale','SPLCCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SPLCCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','DryGasEthaneWT',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'DryGasEthaneWT'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','DryGasEthyleneWT',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'DryGasEthyleneWT'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','DryGasPropyleneWT',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'DryGasPropyleneWT'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','DryGasBtuPerLb',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'DryGasBtuPerLb'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','H2ButaneMbtuPerScf',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'H2ButaneMbtuPerScf'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','H2EthaneMbtuPerScf',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'H2EthaneMbtuPerScf'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','H2HydrogenMbtuPerScf',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'H2HydrogenMbtuPerScf'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','H2MethaneMbtuPerScf',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'H2MethaneMbtuPerScf'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','H2PropaneMbtuPerScf',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'H2PropaneMbtuPerScf'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','TailGasFHVBtuPerSCF',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TailGasFHVBtuPerSCF'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','SAPMvtShipTo',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPMvtShipTo'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','SAPMvtSoldToNumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPMvtSoldToNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','SupplierConsignee',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SupplierConsignee'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','Tankage',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Tankage'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','Consignee',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Consignee'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','OrderNumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'OrderNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','RailcarNumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'RailcarNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','SCACCodeMVT',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SCACCodeMVT'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','CrudeWaterContentPer',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'CrudeWaterContentPer'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','BaseOilsPickup',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'BaseOilsPickup'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'MovementHeader','Inspector',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Inspector'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'MovementHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','DeliverByDate',0,0,'mm/dd/yyyy hh:mm' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'DeliverByDate'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','ExternalBatch',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ExternalBatch'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','TripNumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TripNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','Confirmed',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Confirmed'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','CounterpartyPONumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'CounterpartyPONumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','RailSampleID',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'RailSampleID'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','SupplierConsignee',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SupplierConsignee'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','T4TankageCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'T4TankageCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','VettingNumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'VettingNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'PlannedMovement','TruckTTNumber',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TruckTTNumber'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','CommodityGroup',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'CommodityGroup'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','GPCCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'GPCCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','BrandCatIndicator',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'BrandCatIndicator'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','ProductGrade',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ProductGrade'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','ProductGroup',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ProductGroup'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','ProductClass',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ProductClass'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','ProductOxyBioFuel',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ProductOxyBioFuel'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','ProductSubGrade',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ProductSubGrade'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','ProductRVPGroup',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ProductRVPGroup'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','ProductGlobalGroup',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ProductGlobalGroup'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Product','RetailProduct',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'RetailProduct'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Product'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Prvsn','InvoiceDisplay',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'InvoiceDisplay'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Prvsn'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceHeader','FPSConditionType',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'FPSConditionType'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','PriceQuotedInCents',0,0,'y/n' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'PriceQuotedInCents'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','TransferPriceType',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'TransferPriceType'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_rec_type',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_rec_type'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_cou_code',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_cou_code'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_cond_type',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_cond_type'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_cond_table',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_cond_table'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_sold_to_code',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_sold_to_code'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_ship_to_code',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_ship_to_code'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_product',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_product'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_plant_code',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_plant_code'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_UOM',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_UOM'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_currency',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_currency'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_calc_type',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_calc_type'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_rate_unit',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_rate_unit'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'RawPriceLocale','i_gpr_cond_tab_usage',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'i_gpr_cond_tab_usage'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'StrategyHeader','Division',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'Division'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'StrategyHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'StrategyHeader','ProfitCenter',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'ProfitCenter'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'StrategyHeader'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'Term','SAPTermCode',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPTermCode'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'Term'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)
INSERT	GeneralConfiguration SELECT	'UnitOfMeasure','SAPUOMAbbv',0,0,'X' WHERE NOT EXISTS (
					SELECT	'X'
					FROM	GeneralConfiguration
					WHERE	GeneralConfiguration.GnrlCnfgQlfr = 'SAPUOMAbbv'
					AND		GeneralConfiguration.GnrlCnfgTblNme = 'UnitOfMeasure'
					AND		GeneralConfiguration.GnrlCnfgHdrID = 0
					)