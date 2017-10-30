

---------------------------------------------------------------------------------------
-- To configure entries for ExchangeToolsICE exchange source with all the source elements
---------------------------------------------------------------------------------------


DECLARE		@Key					INT
DECLARE		@SrcSystemId			INT
DECLARE		@ExchangeToolsICE		VARCHAR(30)		= 'ExchangeToolsICE'

DECLARE		@ConfigIntegrationExchangeID_ICE		INT
SELECT		@ConfigIntegrationExchangeID_ICE		= ConfigIntegrationExchangeID
FROM		ConfigIntegrationExchange
WHERE		ExchangeName							= 'ICE'


---------------------------------------------------------------------------------------
-- Insert SourceSystem record for ExchangeToolsICE
---------------------------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM SourceSystem WHERE Name = @ExchangeToolsICE)
BEGIN
	SELECT @SrcSystemId = SrceSystmID FROM SourceSystem WHERE Name = @ExchangeToolsICE
END
ELSE
BEGIN
	INSERT INTO SourceSystem (Name, SrceSystmObjct)
	VALUES(@ExchangeToolsICE, NULL);

	SET @SrcSystemId = SCOPE_IDENTITY()
END


---------------------------------------------------------------------------------------
-- Insert ConfigIntegrationExchangeSource
-- Used by display style ExchangeSourceSystemComboxBox (datalist ExchangeSourceSystem) to show Source
-- drop down values on Exchange Trades Staging and Exchange Trades Errors Maintenance reports.
---------------------------------------------------------------------------------------
IF	@ConfigIntegrationExchangeID_ICE IS NOT NULL AND
	NOT EXISTS (SELECT	1
				FROM	ConfigIntegrationExchangeSource
				WHERE	ConfigIntegrationExchangeID			= @ConfigIntegrationExchangeID_ICE
				AND		SrceSystmID							= @SrcSystemId)
BEGIN
	INSERT INTO ConfigIntegrationExchangeSource (ConfigIntegrationExchangeID, SrceSystmID)
	VALUES (@ConfigIntegrationExchangeID_ICE, @SrcSystemId)
END


---------------------------------------------------------------------------------------
-- Source System Elements
---------------------------------------------------------------------------------------
IF NOT EXISTS(SELECT 1 FROM SourceSystemElement WHERE ElementName = 'Exchange' AND SrceSystmID = @SrcSystemId)
BEGIN
	EXEC sp_getkey 'SourceSystemElement', @Key OUTPUT
	INSERT INTO SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
	VALUES (@Key, @SrcSystemId, 'Exchange', 'dddw.dddw_deal_rawpriceheaderlist.rawpriceheader_rphdrnme.rphdrid');
END


IF NOT EXISTS(SELECT 1 FROM SourceSystemElement WHERE ElementName = 'ClearingBroker' AND SrceSystmID = @SrcSystemId)
BEGIN
	EXEC sp_getkey 'SourceSystemElement', @Key OUTPUT
	INSERT INTO SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
	VALUES (@Key, @SrcSystemId, 'ClearingBroker', 'dddw.dddw_deal_data_ba_financial.banme.baid');
END


IF NOT EXISTS(SELECT 1 FROM SourceSystemElement WHERE ElementName = 'ProductInstrument' AND SrceSystmID = @SrcSystemId)
BEGIN
	EXEC sp_getkey 'SourceSystemElement', @Key OUTPUT
	INSERT INTO SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
	VALUES (@Key, @SrcSystemId, 'ProductInstrument', 'dddw.dddw_productinstrument.description.productinstrumentid');
END


IF NOT EXISTS(SELECT 1 FROM SourceSystemElement WHERE ElementName = 'Trader' AND SrceSystmID = @SrcSystemId)
BEGIN
	EXEC sp_getkey 'SourceSystemElement', @Key OUTPUT
	INSERT INTO SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
	VALUES (@Key, @SrcSystemId, 'Trader', 'dddw.dddw_users.compute_0002.users_userid');
END


IF NOT EXISTS(SELECT 1 FROM SourceSystemElement WHERE ElementName = 'FloorBroker' AND SrceSystmID = @SrcSystemId)
BEGIN
	EXEC sp_getkey 'SourceSystemElement', @Key OUTPUT
	INSERT INTO SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
	VALUES (@Key, @SrcSystemId, 'FloorBroker', 'dddw.dddw_deal_data_ba_financial.banme.baid');
END


IF NOT EXISTS(SELECT 1 FROM SourceSystemElement WHERE ElementName = 'BrokerAccount' AND SrceSystmID = @SrcSystemId)
BEGIN
	EXEC sp_getkey 'SourceSystemElement', @Key OUTPUT
	INSERT INTO SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
	VALUES (@Key, @SrcSystemId, 'BrokerAccount', 'dddw.dddw_broker_brokeraccount.accountnumber.brokeraccount_brokeraccountid');
END


IF NOT EXISTS(SELECT 1 FROM SourceSystemElement WHERE ElementName = 'InternalBusinessAssociate' AND SrceSystmID = @SrcSystemId)
BEGIN
	EXEC sp_getkey 'SourceSystemElement', @Key OUTPUT
	INSERT INTO SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
	VALUES (@Key, @SrcSystemId, 'InternalBusinessAssociate', 'dddw.dddw_deal_data_internalbanme.banme.baid');
END
