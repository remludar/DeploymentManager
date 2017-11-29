

---------------------------------------------------------------------------------------
-- To configure entries for NYMEX exchange source with all the source elements
---------------------------------------------------------------------------------------


DECLARE		@Key					INT
DECLARE		@SrcSystemId			INT
DECLARE		@NYMEX					VARCHAR(30)		= 'NYMEX'

DECLARE		@ConfigIntegrationExchangeID_NYMEX		INT
SELECT		@ConfigIntegrationExchangeID_NYMEX		= ConfigIntegrationExchangeID
FROM		ConfigIntegrationExchange
WHERE		ExchangeName							= 'NYMEX'


---------------------------------------------------------------------------------------
-- Insert SourceSystem record for NYMEX
---------------------------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM SourceSystem WHERE Name = @NYMEX)
BEGIN
	SELECT @SrcSystemId = SrceSystmID FROM SourceSystem WHERE Name = @NYMEX
END
ELSE
BEGIN
	INSERT INTO SourceSystem (Name, SrceSystmObjct)
	VALUES(@NYMEX, NULL);

	SET @SrcSystemId = SCOPE_IDENTITY()
END


---------------------------------------------------------------------------------------
-- Insert ConfigIntegrationExchangeSource
-- Used by display style ExchangeSourceSystemComboxBox (datalist ExchangeSourceSystem) to show Source
-- drop down values on Exchange Trades Staging and Exchange Trades Errors Maintenance reports.
---------------------------------------------------------------------------------------
IF	@ConfigIntegrationExchangeID_NYMEX IS NOT NULL AND
	NOT EXISTS (SELECT	1
				FROM	ConfigIntegrationExchangeSource
				WHERE	ConfigIntegrationExchangeID			= @ConfigIntegrationExchangeID_NYMEX
				AND		SrceSystmID							= @SrcSystemId)
BEGIN
	INSERT INTO ConfigIntegrationExchangeSource (ConfigIntegrationExchangeID, SrceSystmID)
	VALUES (@ConfigIntegrationExchangeID_NYMEX, @SrcSystemId)
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
