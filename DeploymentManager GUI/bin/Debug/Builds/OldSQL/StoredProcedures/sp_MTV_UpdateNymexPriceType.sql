/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_UpdateNymexPriceType WITH YOUR view (NOTE:  GN_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_UpdateNymexPriceType]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdateNymexPriceType.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateNymexPriceType]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_UpdateNymexPriceType] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_UpdateNymexPriceType >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_UpdateNymexPriceType]
AS

-- =============================================
-- Author:        Ryan Borgman
-- Create date:	  10/16/2014
-- Description:   Cross-reference pricing data for interfacing into RA
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_UpdateNymexPriceType 18
-----------------------------------------------------------------------------

INSERT INTO MTVPriceLoad (ServiceType
, PriceServiceName
, RPHdrID
, LocationAbbreviation
, RPLcleLcleID
, ToLocationAbbreviation
, ToLcleID
, ProductAbbreviation
, RPDtlRPLcleChmclParPrdctID
, CurrencyAbbreviation
, RPDtlCrrncyID
, UOMAbbreviation
, RPDtlUOM
, CurveName
, InterfaceCode
, RwPrceLcleID
, QuoteFromDate
, QuoteToDate
, TradeFromDate
, TradeToDate
, TradePeriod
, VETradePeriod
, Actual_Estimate
, RPDtlTpe
, RequestingUserName
, RPDtlRqstngUserID
, EntryUserName
, RPDtlEntryUserID
, EntryDate
, ApprovingUserName
, RPDtlApprvngUserID
, ApprovalDate
, Note
, GravityTableName
, GrvtyTbleID
, QuotedGravity
, PublicationDate
, Source
, IsMissingPrice
, PriceType
, PriceTypeIdnty
, Value
, PriceExists
, InterfaceDate
, LoadStatus
, LoadDate
, Message
)
select ServiceType
, PriceServiceName
, RPHdrID
, LocationAbbreviation
, RPLcleLcleID
, ToLocationAbbreviation
, ToLcleID
, ProductAbbreviation
, RPDtlRPLcleChmclParPrdctID
, CurrencyAbbreviation
, RPDtlCrrncyID
, UOMAbbreviation
, RPDtlUOM
, CurveName
, InterfaceCode
, RwPrceLcleID
, QuoteFromDate
, QuoteToDate
, TradeFromDate
, TradeToDate
, TradePeriod
, VETradePeriod
, Actual_Estimate
, RPDtlTpe
, RequestingUserName
, RPDtlRqstngUserID
, EntryUserName
, RPDtlEntryUserID
, EntryDate
, ApprovingUserName
, RPDtlApprvngUserID
, ApprovalDate
, Note
, GravityTableName
, GrvtyTbleID
, QuotedGravity
, PublicationDate
, Source
, IsMissingPrice
, 'SettleDRVD'
, PriceTypeIdnty
, Value
, PriceExists
, InterfaceDate
, LoadStatus
, LoadDate
, Message
FROM MTVPriceLoad
WHERE PriceServiceName = 'NYMEX'
AND PriceType = 'settle'
AND LoadStatus is NULL

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateNymexPriceType]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_UpdateNymexPriceType.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_UpdateNymexPriceType >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_UpdateNymexPriceType >>>'
	  END