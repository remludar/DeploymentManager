/*
*****************************************************************************************************
USE FIND AND REPLACE ON ExcelPriceLoadXRef WITH YOUR view (NOTE:  GN_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_ExcelPriceLoadXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ExcelPriceLoadXRef.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ExcelPriceLoadXRef]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ExcelPriceLoadXRef] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ExcelPriceLoadXRef >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ExcelPriceLoadXRef] @RowId INT = NULL
AS

-- =============================================
-- Author:        Ryan Borgman
-- Create date:	  10/16/2014
-- Description:   Cross-reference pricing data for interfacing into RA
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--execute MTV_ExcelPriceLoadXRef 18
-----------------------------------------------------------------------------

/*
Find RA ID's
*/

SET NOCOUNT ON

--Find RawPriceHeaderId
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPHdrID	= RawPriceHeader.RPHdrID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	RawPriceHeader (NoLock)
ON	MTVPriceLoad.PriceServiceName	= RawPriceHeader.RPHdrNme
WHERE	MTVPriceLoad.RPHdrID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find RwPrceLcleId
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPLcleLcleID	= Locale.LcleID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Locale (NoLock)
ON	MTVPriceLoad.LocationAbbreviation	= REPLACE(Locale.LcleAbbrvtn + ISNULL(Locale.LcleAbbrvtnExtension,''),',','')
WHERE	RPLcleLcleID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find RwPrceLcleId
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPLcleLcleID	= Locale.LcleID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Locale (NoLock)
ON	MTVPriceLoad.LocationAbbreviation	= Locale.LcleAbbrvtn + ISNULL(Locale.LcleAbbrvtnExtension,'')
WHERE	RPLcleLcleID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.ToLcleID	= Locale.LcleID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Locale (NoLock)
ON	MTVPriceLoad.ToLocationAbbreviation	= REPLACE(Locale.LcleAbbrvtn + ISNULL(Locale.LcleAbbrvtnExtension,''),',','')
WHERE	ToLcleID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.ToLcleID	= Locale.LcleID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Locale (NoLock)
ON	MTVPriceLoad.ToLocationAbbreviation	= Locale.LcleAbbrvtn + ISNULL(Locale.LcleAbbrvtnExtension,'')
WHERE	ToLcleID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPDtlRPLcleChmclParPrdctID	= Product.PrdctID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Product (NoLock)
ON	MTVPriceLoad.ProductAbbreviation	= Product.PrdctAbbv
WHERE	MTVPriceLoad.RPDtlRPLcleChmclParPrdctID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPDtlCrrncyID	= Currency.CrrncyID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Currency (NoLock)
ON	MTVPriceLoad.CurrencyAbbreviation	= Currency.CrrncySmbl
WHERE	MTVPriceLoad.RPDtlCrrncyID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPDtlUOM	= UnitOfMeasure.UOM
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	unitofmeasure (NoLock)
ON	MTVPriceLoad.UOMAbbreviation	= UnitOfMeasure.UOMAbbv
WHERE	MTVPriceLoad.RPDtlUOM IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RwPrceLcleID		= RawPriceLocale.RwPrceLcleID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	RawPriceLocale (NoLock)
ON	MTVPriceLoad.CurveName		= REPLACE(RawPriceLocale.CurveName,',','')
WHERE	MTVPriceLoad.RwPrceLcleID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RwPrceLcleID		= RawPriceLocale.RwPrceLcleID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	RawPriceLocale (NoLock)
ON	MTVPriceLoad.CurveName		= RawPriceLocale.CurveName
WHERE	MTVPriceLoad.RwPrceLcleID IS NULL
AND	MTVPriceLoad.LoadStatus IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RwPrceLcleID		= RawPriceLocale.RwPrceLcleID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	RawPriceLocale (NoLock)
ON	MTVPriceLoad.Interfacecode		= RawPriceLocale.RPLcleIntrfceCde
WHERE	MTVPriceLoad.RwPrceLcleID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL
AND	MTVPriceLoad.InterfaceCode <> ''

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPDtlRqstngUserID = Users.UserID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Contact (NoLock)
ON	MTVPriceLoad.RequestingUserName = Contact.CntctFrstNme + Contact.CntctLstNme
INNER JOIN	Users (NoLock)
ON	Contact.CntctID	= Users.UserCntctID
WHERE	MTVPriceLoad.RPDtlRqstngUserID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPDtlEntryUserID = Users.UserID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Contact (NoLock)
ON	MTVPriceLoad.EntryUserName = Contact.CntctFrstNme + Contact.CntctLstNme
INNER JOIN	Users (NoLock)
ON	Contact.CntctID	= Users.UserCntctID
WHERE MTVPriceLoad.RPDtlEntryUserID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RPDtlApprvngUserID = Users.UserID
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	Contact (NoLock)
ON	MTVPriceLoad.ApprovingUserName = Contact.CntctFrstNme + Contact.CntctLstNme
INNER JOIN	Users (NoLock)
ON	Contact.CntctID	= Users.UserCntctID
WHERE	MTVPriceLoad.RPDtlApprvngUserID IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.PriceTypeIdnty = Pricetype.Idnty
--SELECT	*
FROM		MTVPriceLoad (NoLock)
INNER JOIN	pricetype (NoLock)
ON	MTVPriceLoad.PriceType	= Pricetype.PrceTpeNme
WHERE	MTVPriceLoad.PriceTypeIdnty IS NULL
AND	MTVPriceLoad.LoadStatus  IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.InterfaceDate		= GETDATE()
		,MTVPriceLoad.Source			= 'Excel Load'
		,MTVPriceLoad.LoadStatus		= 'N'
WHERE	LoadStatus IS NULL

--Find 
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.RpDtlTpe = CASE WHEN Actual_Estimate = 'Actual' THEN 'A' 
									WHEN Actual_Estimate = 'Estimate' THEN 'A' 
									ELSE NULL END
FROM	MTVPriceLoad
WHERE	MTVPriceLoad.RPDtlTpe	IS NULL
AND		MTVPriceLoad.LoadStatus		= 'N'

--Update abbreviated TraderPeriod to full Month name
UPDATE	MTVPriceLoad
SET TradePeriod = CASE WHEN CHARINDEX('-',TradePeriod,0) = 4 THEN
			CASE WHEN LEFT(TradePeriod,3) = 'JAN' THEN 'January ' + '20' + RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'FEB' THEN 'February ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'MAR' THEN 'March ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'APR' THEN 'April ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'MAY' THEN 'May ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'JUN' THEN 'June ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'JUL' THEN 'July ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'AUG' THEN 'August ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'SEP' THEN 'September ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'OCT' THEN 'October ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'NOV' THEN 'November ' + '20' +  RIGHT(TradePeriod,2)
			WHEN LEFT(TradePeriod,3) = 'DEC' THEN 'December ' + '20' +  RIGHT(TradePeriod,2)
			ELSE 'UNKNOWN' END
		ELSE TradePeriod END
		--SELECT *
from	MTVPriceLoad
WHERE	MTVPriceLoad.LoadStatus = 'N'

--This will mark any TradePeriod that comes in a format other then what was agreed
UPDATE	MTVPriceLoad
SET		MTVPriceLoad.LoadStatus = 'E'
		,MTVPriceLoad.Message = 'Invalid Trade Period date format:  Valid formats are:  MMM-YY (JAN-17) or MONTH YYYY (January 2017)'
FROM	MTVPriceLoad
WHERE	LEFT(MTVPriceLoad.TradePeriod,3) NOT IN ('JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC','')

/*
---------------------------------------------------------
Let's Do some Error Checking before we load the data
---------------------------------------------------------
*/
--COMMENTED OUT VIA DEFECT 5613, They never want to reprocess any errors as they will reload the file with correct data.
----RESET MESSAGES IN TABLE
--UPDATE	MTVPriceLoad
--SET		MTVPriceLoad.Message = NULL
--WHERE	MTVPriceLoad.Message IS NOT NULL
--AND		MTVPriceLoad.LoadStatus <> 'C'
--AND		MTVPriceLoad.MTVPLID	= CASE WHEN @RowId IS NULL THEN MTVPriceLoad.MTVPLID ELSE @RowId END

----RESET STATUS IN TABLE
--UPDATE	MTVPriceLoad
--SET		MTVPriceLoad.LoadStatus = 'N'
--WHERE	MTVPriceLoad.LoadStatus = 'E'
--AND		MTVPriceLoad.MTVPLID	= CASE WHEN @RowId IS NULL THEN MTVPriceLoad.MTVPLID ELSE @RowId END

----NULL LeaseNumber
UPDATE	MTVPriceLoad
SET		LoadStatus	= 'E'
		,Message	= 'Can not find Price Curve, please verify curve name in order to load price. || '
FROM	MTVPriceLoad (NOLOCK)
WHERE	MTVPriceLoad.RwPrceLcleID IS NULL
AND		MTVPriceLoad.MTVPLID	= CASE WHEN @RowId IS NULL THEN MTVPriceLoad.MTVPLID ELSE @RowId END

SET NOCOUNT OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ExcelPriceLoadXRef]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_ExcelPriceLoadXRef.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ExcelPriceLoadXRef >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ExcelPriceLoadXRef >>>'
	  END