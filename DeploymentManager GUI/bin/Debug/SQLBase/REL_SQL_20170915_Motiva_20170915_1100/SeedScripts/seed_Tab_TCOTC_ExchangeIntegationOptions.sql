
-- Seed script to insert the necessary row for the "Exchange Integration Options" screen.
-- "Exchange Integration Options" screen is located:
--     RA.NET > Control Panel > System Control Panel > Integration > Exchange Integration Options
-- This record is a pre-requisite for the new "TCOTC" tab created for MPC.
IF NOT EXISTS (SELECT 1 FROM ConfigIntegrationExchange WHERE ExchangeName = 'TCOTC')
BEGIN
	INSERT INTO ConfigIntegrationExchange (ConfigIntegrationID, LastUpdateTime, Username, Password, ExchangeName)
	VALUES (1, CURRENT_TIMESTAMP, '', 'OgOouOsFMCA=', 'TCOTC')
END
