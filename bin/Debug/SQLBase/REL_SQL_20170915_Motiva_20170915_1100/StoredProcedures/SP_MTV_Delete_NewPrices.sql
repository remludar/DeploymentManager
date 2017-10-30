/****** Object:  StoredProcedure [dbo].[MTV_Delete_NewPrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Delete_NewPrices.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Delete_NewPrices]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Delete_NewPrices] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Delete_NewPrices >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Delete_NewPrices]
AS
------------------------------------------------------------------------------------------------------------------
--  Procedure:  MTV_Delete_NewPrices
--  Created By: Sanjay Kumar
--  Created:    3/28/2017
--  Purpose:    Delete the New Loaded Prices
------------------------------------------------------------------------------------------------------------------
delete from MTVPriceLoad where LoadStatus = 'N'

IF  OBJECT_ID(N'[dbo].[MTV_Delete_NewPrices]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Delete_NewPrices.sql'
	PRINT '<<< ALTERED StoredProcedure MTV_Delete_NewPrices >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Delete_NewPrices >>>'
END