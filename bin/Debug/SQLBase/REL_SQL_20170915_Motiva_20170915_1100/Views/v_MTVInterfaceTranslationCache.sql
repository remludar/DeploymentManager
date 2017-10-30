/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVInterfaceTranslationCache WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTVInterfaceTranslationCache]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVInterfaceTranslationCache.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVInterfaceTranslationCache]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTVInterfaceTranslationCache] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTVInterfaceTranslationCache >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTVInterfaceTranslationCache]
AS

SELECT CONVERT(VARCHAR(80),Product.PrdctID) AS RAValue
			  ,GeneralConfiguration.GnrlCnfgDtlID as RADetailValue
              ,CASE WHEN GnrlCnfgQlfr LIKE 'SAP%' THEN 'SAP' ELSE GnrlCnfgTblNme END AS Source
              ,GeneralConfiguration.GnrlCnfgTblNme AS TableSource
              ,GeneralConfiguration.GnrlCnfgQlfr AS Qualifier
              ,GeneralConfiguration.GnrlCnfgMulti AS ExtValue
              ,'01/01/1990' AS StartDate
              ,'12/31/2049' AS EndDate
FROM          dbo.GeneralConfiguration (NOLOCK)
INNER JOIN    dbo.Product (NOLOCK)
ON     GeneralConfiguration.GnrlCnfgHdrID = Product.PrdctID
AND GeneralConfiguration.GnrlCnfgTblNme = 'Product'
AND    GeneralConfiguration.GnrlCnfgHdrID <> 0
--AND GeneralConfiguration.GnrlCnfgQlfr LIKE 'SAP%'
UNION ALL
SELECT CONVERT(VARCHAR(80), GnrlCnfgHdrID)
			,0
			,'SAP'
			,'Product'
			,'SAPBaseOilProducts'
			,GnrlCnfgMulti
			,'01/01/1990'
			,'12/31/2049'
FROM GeneralConfiguration gc (NOLOCK)
WHERE GnrlCnfgTblNme = 'Product'
AND GnrlCnfgQlfr = 'PriceCommodityGroup'
AND GnrlCnfgMulti = 'Base Oils'
UNION ALL
SELECT CONVERT(VARCHAR(80),Locale.LcleID)  AS RAValue
			  ,GeneralConfiguration.GnrlCnfgDtlID as RADetailValue
              ,CASE WHEN GnrlCnfgQlfr LIKE 'SAP%' THEN 'SAP' ELSE GnrlCnfgTblNme END AS Source
              ,GeneralConfiguration.GnrlCnfgTblNme AS TableSource
              ,GeneralConfiguration.GnrlCnfgQlfr AS Qualifier
              ,GeneralConfiguration.GnrlCnfgMulti AS ExtValue
              ,'01/01/1990' AS StartDate
              ,'12/31/2049' AS EndDate
FROM          dbo.GeneralConfiguration (NOLOCK)
INNER JOIN    dbo.Locale (NOLOCK)
ON     GeneralConfiguration.GnrlCnfgHdrID = Locale.LcleID
AND GeneralConfiguration.GnrlCnfgTblNme = 'Locale'
AND    GeneralConfiguration.GnrlCnfgHdrID <> 0
--AND GeneralConfiguration.GnrlCnfgQlfr LIKE 'SAP%'
UNION ALL
SELECT CONVERT(VARCHAR(80),BusinessAssociate.BAID)  AS RAValue
			  ,GeneralConfiguration.GnrlCnfgDtlID as RADetailValue
              ,CASE WHEN GnrlCnfgQlfr LIKE 'SAP%' THEN 'SAP' ELSE GnrlCnfgTblNme END AS Source
              ,GeneralConfiguration.GnrlCnfgTblNme AS TableSource
              ,GeneralConfiguration.GnrlCnfgQlfr AS Qualifier
              ,GeneralConfiguration.GnrlCnfgMulti AS ExtValue
              ,'01/01/1990' AS StartDate
              ,'12/31/2049' AS EndDate
FROM          dbo.GeneralConfiguration (NOLOCK)
INNER JOIN    dbo.BusinessAssociate (NOLOCK)
ON     GeneralConfiguration.GnrlCnfgHdrID = BusinessAssociate.BAID
AND GeneralConfiguration.GnrlCnfgTblNme = 'BusinessAssociate'
AND    GeneralConfiguration.GnrlCnfgHdrID <> 0
--AND GeneralConfiguration.GnrlCnfgQlfr LIKE 'SAP%'
UNION ALL
SELECT CONVERT(VARCHAR(80),Office.OffceLcleID) AS RAValue
			  ,GeneralConfiguration.GnrlCnfgDtlID as RADetailValue
			  ,CASE WHEN GnrlCnfgQlfr LIKE 'SAP%' THEN 'SAP' ELSE GnrlCnfgTblNme END AS Source
              ,GeneralConfiguration.GnrlCnfgTblNme AS TableSource
              ,GeneralConfiguration.GnrlCnfgQlfr AS Qualifier
              ,GeneralConfiguration.GnrlCnfgMulti AS ExtValue
              ,'01/01/1990' AS StartDate
              ,'12/31/2049' AS EndDate
FROM          dbo.GeneralConfiguration (NOLOCK)
INNER JOIN    dbo.Office (NOLOCK)
ON     GeneralConfiguration.GnrlCnfgHdrID = Office.OffceLcleID
AND GeneralConfiguration.GnrlCnfgTblNme = 'Office'
AND    GeneralConfiguration.GnrlCnfgHdrID <> 0
--AND GeneralConfiguration.GnrlCnfgQlfr LIKE 'SAP%'
UNION ALL
SELECT CONVERT(VARCHAR(80),RawPriceHeader.RPHdrID) AS RAValue
			  ,GeneralConfiguration.GnrlCnfgDtlID as RADetailValue
			  ,CASE WHEN GnrlCnfgQlfr LIKE 'SAP%' THEN 'SAP' ELSE GnrlCnfgTblNme END AS Source
              ,GeneralConfiguration.GnrlCnfgTblNme AS TableSource
              ,GeneralConfiguration.GnrlCnfgQlfr AS Qualifier
              ,GeneralConfiguration.GnrlCnfgMulti AS ExtValue
              ,'01/01/1990' AS StartDate
              ,'12/31/2049' AS EndDate
FROM          dbo.GeneralConfiguration (NOLOCK)
INNER JOIN    dbo.RawPriceHeader (NOLOCK)
ON     GeneralConfiguration.GnrlCnfgHdrID = RawPriceHeader.RPHdrID
AND GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceHeader'
AND    GeneralConfiguration.GnrlCnfgHdrID <> 0
--AND GeneralConfiguration.GnrlCnfgQlfr LIKE 'SAP%'
UNION ALL
SELECT CONVERT(VARCHAR(80),RawPriceLocale.RwPrceLcleID) AS RAValue
			  ,GeneralConfiguration.GnrlCnfgDtlID as RADetailValue
			  ,CASE WHEN GnrlCnfgQlfr LIKE 'SAP%' THEN 'SAP' ELSE GnrlCnfgTblNme END AS Source
              ,GeneralConfiguration.GnrlCnfgTblNme AS TableSource
              ,GeneralConfiguration.GnrlCnfgQlfr AS Qualifier
              ,GeneralConfiguration.GnrlCnfgMulti AS ExtValue
              ,'01/01/1990' AS StartDate
              ,'12/31/2049' AS EndDate
FROM          dbo.GeneralConfiguration (NOLOCK)
INNER JOIN    dbo.RawPriceLocale (NOLOCK)
ON     GeneralConfiguration.GnrlCnfgHdrID = RawPriceLocale.RwPrceLcleID
AND GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
AND    GeneralConfiguration.GnrlCnfgHdrID <> 0
--AND GeneralConfiguration.GnrlCnfgQlfr LIKE 'SAP%'
UNION ALL
SELECT CONVERT(VARCHAR(80),DealHeader.DlHdrID) AS RAValue
			  ,GeneralConfiguration.GnrlCnfgDtlID as RADetailValue
			  ,CASE WHEN GnrlCnfgQlfr LIKE 'SAP%' THEN 'SAP' ELSE GnrlCnfgTblNme END AS Source
              ,GeneralConfiguration.GnrlCnfgTblNme AS TableSource
              ,GeneralConfiguration.GnrlCnfgQlfr AS Qualifier
              ,GeneralConfiguration.GnrlCnfgMulti AS ExtValue
              ,'01/01/1990' AS StartDate
              ,'12/31/2049' AS EndDate
FROM          dbo.GeneralConfiguration (NOLOCK)
INNER JOIN    dbo.DealHeader (NOLOCK)
ON     GeneralConfiguration.GnrlCnfgHdrID = DealHeader.DlHdrID
AND GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
AND    GeneralConfiguration.GnrlCnfgHdrID <> 0
--AND GeneralConfiguration.GnrlCnfgQlfr LIKE 'SAP%'
UNION ALL
SELECT CONVERT(VARCHAR(80),PlannedMovement.PlnndMvtID) AS RAValue
			  ,GeneralConfiguration.GnrlCnfgDtlID as RADetailValue
			  ,CASE WHEN GnrlCnfgQlfr LIKE 'SAP%' THEN 'SAP' ELSE GnrlCnfgTblNme END AS Source
              ,GeneralConfiguration.GnrlCnfgTblNme AS TableSource
              ,GeneralConfiguration.GnrlCnfgQlfr AS Qualifier
              ,GeneralConfiguration.GnrlCnfgMulti AS ExtValue
              ,'01/01/1990' AS StartDate
              ,'12/31/2049' AS EndDate
FROM          dbo.GeneralConfiguration (NOLOCK)
INNER JOIN    dbo.PlannedMovement (NOLOCK)
ON     GeneralConfiguration.GnrlCnfgHdrID = PlannedMovement.PlnndMvtID
AND GeneralConfiguration.GnrlCnfgTblNme = 'PlannedMovement'
AND    GeneralConfiguration.GnrlCnfgHdrID <> 0
--AND GeneralConfiguration.GnrlCnfgQlfr LIKE 'SAP%'
UNION ALL
select SourceSystemElementXref.InternalValue AS RAValue
			  ,Null As RADetailValue
              ,SourceSystem.Name AS Source
              --,CASE  WHEN DisplayStyle LIKE '%PrdctId' THEN 'Product'
              --             WHEN DisplayStyle LIKE '%LcleId' THEN 'Locale'
              --             WHEN DisplayStyle LIKE '%Baid' THEN 'BusinessAssociate'
              --             WHEN DisplayStyle LIKE '%crrncyid' THEN 'Currency'
              --             WHEN DisplayStyle LIKE '%uom' THEN 'UnitOfMeasure'
              --             WHEN DisplayStyle LIKE '%RPHdrID' THEN 'RawPriceHeader'
              --             ELSE 'CrossReference' END AS TableSource
			  ,'CrossReference' AS TableSource
              ,isnull(SourceSystem.Name, '') + SourceSystemElement.ElementName AS Qualifier
              ,ElementValue AS ExtValue
              ,SourceSystemElementXref.StartDate AS StartDate
              ,SourceSystemElementXref.EndDate AS EndDate
              --select *
FROM   SourceSystem (NOLOCK)
INNER JOIN    SourceSystemElement (NOLOCK)
ON     SourceSystem.SrceSystmID   = SourceSystemElement.SrceSystmID
INNER JOIN  SourceSystemElementXref (NOLOCK)
ON  SourceSystemElementXref.SrceSystmElmntID    = SourceSystemElement.SrceSystmElmntID
WHERE  SourceSystem.SrceSystmID NOT IN (1,3,4,5)--EXCLUDE OUT OF BOX UNUSED

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTVInterfaceTranslationCache]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTVInterfaceTranslationCache.sql'
			PRINT '<<< ALTERED View v_MTVInterfaceTranslationCache >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTVInterfaceTranslationCache >>>'
	  END
