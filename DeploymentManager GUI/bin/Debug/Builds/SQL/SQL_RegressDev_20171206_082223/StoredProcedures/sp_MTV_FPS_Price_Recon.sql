PRINT 'Start Script=sp_MTV_FPS_Price_Recon.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPS_Price_Recon]') IS NULL
      BEGIN
                     EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_FPS_Price_Recon] AS SELECT 1'
                     PRINT '<<< CREATED StoredProcedure MTV_FPS_Price_Recon >>>'
         END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].MTV_FPS_Price_Recon
AS

-- =============================================
-- Author:        Ravi Chenna
-- Create date:        06JUN2016
-- Description:   This SP compiles FPS Rack/Surcharges/Discount prices
--            MTVFPSRackPriceStaging,RawPriceDetail, MTVFPSContractPriceDates and MTVFPSDiscountSurcharge
--      that RA is currently using and sends them back to FPS
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
set nocount on
set Quoted_Identifier OFF  

--DROP TABLE #FPSReconLastStaged
IF OBJECT_ID('tempdb..#FPSReconLastStaged') IS NOT NULL
    DROP TABLE #FPSReconLastStaged
    
CREATE Table #FPSReconLastStaged
(
       i_gpr_PriceCurveId  INT NOT NULL,
       i_gpr_condition_type VARCHAR(10) NOT NULL,
       CurrentValue FLOAT NOT NULL,
       CreatedOrModifiedDate SMALLDATETIME NOT NULL,
       RALocaleID INT  NULL,
       RAProductID INT NULL,
       RABAID INT  NULL,
       RAUOMID smallint  NULL,
       RACurrencyID INT NULL,
       ValidFromDate SMALLDATETIME NULL,
       ValidToDate   SMALLDATETIME NULL,
       i_gpr_rec_type varchar(10) NULL,
       i_gpr_cou_code varchar(10) NULL,
       i_gpr_condition_table varchar(10) NULL,
       i_gpr_sold_to_code varchar(20) NULL,
       i_gpr_ship_to_code VARCHAR(20) NULL,
       i_gpr_product varchar(20) NULL,
       i_gpr_plant_code varchar(10) NULL,
       i_gpr_UOM varchar(10) NULL,
       i_gpr_currency varchar(10) NULL,
       i_gpr_calculation_type varchar(5) NULL,
       i_gpr_rate FLOAT NULL,
       i_gpr_rate_unit varchar(10) NULL,
       i_gpr_kosrt varchar(20) NULL,
       i_gpr_validfrom varchar(10) NULL,
       i_gpr_validto varchar(10) NULL,
       i_gpr_start_time varchar(10) NULL,
       i_gpr_end_time varchar(10) NULL,
       i_gpr_quantity varchar(20) NULL,
       i_gpr_cond_tab_usage varchar(5) NULL,
       RawPriceDtlIdnty varchar(20) NULL
)

DECLARE @lastProcessedDate DATETIME
SELECT @lastProcessedDate = DATEADD(dd,0,DATEDIFF(dd,0,IsNull(MAX(mps.ExportDate), '01/01/1900'))) FROM MTVFPSReconPriceStaging AS mps
--SELECT @lastProcessedDate


INSERT INTO #FPSReconLastStaged
(
      i_gpr_PriceCurveId,
      i_gpr_condition_type,
      CurrentValue,
      CreatedOrModifiedDate,
      ValidFromDate,
      ValidToDate,
      RABAID,
      RawPriceDtlIdnty
)
SELECT  NewPrices.i_gpr_PriceCurveId,
	NewPrices.FPSConditionType,
	NewPrices.CurrentValue,
	NewPrices.CreatedOrModifiedDate,
	NewPrices.ValidFromDate,
	NewPrices.ValidToDate, 
	NewPrices.RABAID, 
	NewPrices.StageCurveID
FROM (

--Get the latest updates on rack/contract prices from core tables. The FPS staging tables values for these rows will be added in update statements further below
--DECLARE @lastProcessedDate DATETIME = '2016-06-17 00:00:00.000'
SELECT distinct 
	rpl.RwPrceLcleID AS i_gpr_PriceCurveId,  
	gc.GnrlCnfgMulti FPSConditionType, 
	rp.RPVle CurrentValue,
	case when rpd.RPDtlEntryDte > rpd.CreationDate THEN rpd.RPDtlEntryDte ELSE rpd.CreationDate end CreatedOrModifiedDate,
    rpd.RPDtlQteFrmDte ValidFromDate, 
	rpd.RPDtlQteToDte ValidToDate,
	NULL RABAID, 
	rpd.Idnty StageCurveID
FROM RawPriceLocale rpl (NOLOCK)
INNER JOIN GeneralConfiguration AS gc (NOLOCK) 
ON rpl.RPLcleRPHdrID = gc.GnrlCnfgHdrID 
	AND gc.GnrlCnfgHdrID <> 0 
	AND gc.GnrlCnfgTblNme = 'RawPriceHeader' 
	AND gc.GnrlCnfgQlfr = 'FPSConditionType' 
	AND gc.GnrlCnfgMulti IN ('YP02','YP06')    
INNER JOIN RawPriceDetail AS rpd (NOLOCK) 
ON rpd.RwPrceLcleID = rpl.RwPrceLcleID 
INNER JOIN RawPrice rp (NOLOCK) 
ON rp.RPRPDtlIdnty = rpd.Idnty 
WHERE ((rpd.RPDtlQteToDte >= @lastProcessedDate AND rpl.Status = 'A' AND rpd.RPDtlStts = 'A' AND rp.Status = 'A')
	OR rpd.CreationDate >= @lastProcessedDate 
	OR rpd.RPDtlEntryDte >= @lastProcessedDate)
	OR EXISTS (SELECT TOP 1 1 FROM
						(SELECT TOP 1 CreatedDate, ModifiedDate, RAQuoteEnd FROM MTVFPSRackPriceStaging staging
						WHERE rpd.Idnty = staging.RawPriceDtlIdnty
						AND gc.GnrlCnfgQlfr = staging.i_ogs_condition_type
						AND staging.RecordStatus = 'C'
					ORDER BY MFRPID DESC) 
					AS mostRecentCompleteStaging
				WHERE (mostRecentCompleteStaging.CreatedDate IS NOT NULL AND mostRecentCompleteStaging.CreatedDate >= @lastProcessedDate)
					OR (mostRecentCompleteStaging.ModifiedDate IS NOT NULL AND mostRecentCompleteStaging.ModifiedDate >= @lastProcessedDate)
					OR (mostRecentCompleteStaging.RAQuoteEnd IS NOT NULL AND mostRecentCompleteStaging.RAQuoteEnd >= @lastProcessedDate)
				)
--ORDER BY rpd.RwPrceLcleID


UNION --Get the latest contract price dates
SELECT 
	fcp.MFCPDID AS i_gpr_PriceCurveId, 
	fcp.FPSconditiontype, 
	fcp.FPSvalue CurrentValue, 
	IsNull(fcp.ModifiedDate,fcp.CreatedDate) CreatedOrModifiedDate,
    fcp.ContractStartDate ValidFromDate, 
	fcp.ContractEndDate ValidToDate,
	fcp.RABAID, 
	fcp.MFCPDID StageCurveID
FROM MTVFPSContractPriceDates AS fcp (NOLOCK) 
WHERE fcp.MFCPDID IS NOT NULL
AND ((fcp.ContractEndDate >= @lastProcessedDate AND fcp.Status = 'A')
	OR fcp.CreatedDate >= @lastProcessedDate 
	OR fcp.ModifiedDate >= @lastProcessedDate)
AND fcp.FPSconditiontype = 'YPCP'
       
	           
UNION --Get the latest discounts/surcharges
SELECT 
	ds.MFDSID AS i_gpr_PriceCurveId, 
	ds.FPSconditiontype, 
	ds.[Value] CurrentValue, 
	IsNull(ds.ModifiedDate,ds.CreatedDate) CreatedOrModifiedDate,
    ds.StartDate ValidFromDate, 
	ds.EndDate ValidToDate,
	ds.RABAID, 
	ds.MFDSID StageCurveID 
FROM MTVFPSDiscountSurcharge AS ds (NOLOCK)  
where ds.MFDSID IS NOT NULL 
AND ((ds.EndDate >= @lastProcessedDate AND ds.Status = 'A')
	OR ds.CreatedDate >=  @lastProcessedDate 
	OR ds.ModifiedDate >= @lastProcessedDate)


) AS NewPrices




UPDATE #FPSReconLastStaged	--Update rack/contract from core price tables with their FPS staging table values
SET RALocaleID     = mps.RALocaleID
    ,RAProductID    = mps.RAProductID
    ,RAUOMID        = mps.RAUOMID
    ,RACurrencyID   = mps.RACurrencyID
    ,i_gpr_rec_type = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_rec_type')
    ,i_gpr_cou_code = mps.cou_code
    ,i_gpr_condition_table = mps.i_ogs_condition_table
    ,i_gpr_sold_to_code = mps.i_ogs_sold_to_code
    ,i_gpr_ship_to_code = mps.i_ogs_ship_to_code
    ,i_gpr_product = mps.i_ogs_product
    ,i_gpr_plant_code = mps.i_ogs_plant_code
    ,i_gpr_UOM = mps.i_ogs_uom
    ,i_gpr_currency = mps.i_ogs_currency
    ,i_gpr_calculation_type = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_calculation_type')
    ,i_gpr_rate = CAST(#FPSReconLastStaged.CurrentValue AS varchar(10))
    ,i_gpr_rate_unit = mps.i_ogs_currency
    ,i_gpr_kosrt = mps.i_ogs_id
    ,i_gpr_validfrom = FORMAT ( #FPSReconLastStaged.ValidFromDate, 'yyyyMMdd', 'en-US' )
    ,i_gpr_validto = FORMAT (#FPSReconLastStaged.ValidToDate, 'yyyyMMdd', 'en-US' )
    ,i_gpr_start_time = FORMAT (#FPSReconLastStaged.ValidFromDate, 'HHmmss', 'en-US' )
    ,i_gpr_end_time = FORMAT (#FPSReconLastStaged.ValidToDate, 'HHmmss', 'en-US' )
    ,i_gpr_quantity = mps.i_ogs_quantity
    ,i_gpr_cond_tab_usage = mps.i_ogs_cond_tab_usage
FROM  #FPSReconLastStaged 
INNER JOIN MTVFPSRackPriceStaging AS mps (NOLOCK) 
ON #FPSReconLastStaged.RawPriceDtlIdnty = mps.RawPriceDtlIdnty
AND mps.i_ogs_condition_type = #FPSReconLastStaged.i_gpr_condition_type
AND #FPSReconLastStaged.i_gpr_condition_type IN ('YP02', 'YP06')


--Update staging table-like data for any core prices manually created under YP02/YP06 curves
--Manually created prices won't actually have a MTVFPSRackPriceStaging row, so we must use the attributes on the core entities themselves for this data
--YPCP, YD, and YS don't exist in the core tables (have no curve, service, or raw price records) and thus don't need to be included
DECLARE @TableName VARCHAR(20) = 'RawPriceLocale'
UPDATE #FPSReconLastStaged
SET RALocaleID     =  IsNull(RALocaleID,rpd.RPDtlRPLcleLcleID)
    ,RAProductID    = IsNull(RAProductID,rpd.RPDtlRPLcleChmclParPrdctID)
    ,RAUOMID        = IsNull(RAUOMID,rpd.RPDtlUOM)
    ,RACurrencyID   = IsNull(RACurrencyID,rpd.RPDtlCrrncyID)
    ,i_gpr_rate = CAST(#FPSReconLastStaged.CurrentValue AS varchar(10))
    ,i_gpr_validfrom = FORMAT ( #FPSReconLastStaged.ValidFromDate, 'yyyyMMdd', 'en-US' )
    ,i_gpr_validto = FORMAT (#FPSReconLastStaged.ValidToDate, 'yyyyMMdd', 'en-US' )
    ,i_gpr_start_time = FORMAT (#FPSReconLastStaged.ValidFromDate, 'HHmmss', 'en-US' )
    ,i_gpr_end_time = FORMAT (#FPSReconLastStaged.ValidToDate, 'HHmmss', 'en-US' )
    ,i_gpr_kosrt = ''
    ,i_gpr_quantity = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_quantity')
    ,i_gpr_rec_type = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_rec_type')
    ,i_gpr_cou_code = dbo.MTV_GetGeneralConfigValue(@TableName,'i_gpr_cou_code',rpl.RwPrceLcleID, null)
    ,i_gpr_condition_table = dbo.MTV_GetGeneralConfigValue(@TableName,'i_gpr_cond_table',rpl.RwPrceLcleID, null)
    ,i_gpr_sold_to_code = REPLACE(LTRIM(REPLACE(gcSoldTo.GnrlCnfgMulti, '0', ' ')), ' ', '0')
    ,i_gpr_ship_to_code = REPLACE(LTRIM(REPLACE(gcShipTo.GnrlCnfgMulti, '0', ' ')), ' ', '0')
    ,i_gpr_product = REPLACE(LTRIM(REPLACE(gcProd.GnrlCnfgMulti, '0', ' ')), ' ', '0')
    ,i_gpr_plant_code = REPLACE(LTRIM(REPLACE(gcLle.GnrlCnfgMulti, '0', ' ')), ' ', '0')
    ,i_gpr_UOM = dbo.MTV_GetGeneralConfigValue(@TableName,'i_gpr_UOM',rpl.RwPrceLcleID, null)
    ,i_gpr_currency = dbo.MTV_GetGeneralConfigValue(@TableName,'i_gpr_currency',rpl.RwPrceLcleID, null)
    ,i_gpr_calculation_type = dbo.MTV_GetGeneralConfigValue(@TableName,'i_gpr_calc_type',rpl.RwPrceLcleID, null)
    ,i_gpr_rate_unit = dbo.MTV_GetGeneralConfigValue(@TableName,'i_gpr_rate_unit', rpl.RwPrceLcleID, null)
    ,i_gpr_cond_tab_usage = dbo.MTV_GetGeneralConfigValue(@TableName,'i_gpr_cond_tab_usage',rpl.RwPrceLcleID, null)    
FROM  #FPSReconLastStaged 
INNER JOIN RawPriceDetail AS rpd (NOLOCK) 
ON #FPSReconLastStaged.RawPriceDtlIdnty = rpd.Idnty 
AND #FPSReconLastStaged.i_gpr_condition_type in ('YP02', 'YP06')
AND NOT EXISTS (SELECT 1 FROM MTVFPSRackPriceStaging AS mps (NOLOCK) 
				where mps.RawPriceDtlIdnty = #FPSReconLastStaged.RawPriceDtlIdnty
                AND mps.i_ogs_condition_type = #FPSReconLastStaged.i_gpr_condition_type)
INNER JOIN RawPriceLocale AS rpl (NOLOCK) 
ON rpl.RwPrceLcleID = rpd.RwPrceLcleID
LEFT JOIN GeneralConfiguration gcLle (NOLOCK) 
ON rpl.RwPrceLcleID = gcLle.GnrlCnfgHdrID 
AND gcLle.GnrlCnfgTblNme = 'RawPriceLocale' 
AND gcLle.GnrlCnfgQlfr = 'i_gpr_plant_code'
LEFT JOIN GeneralConfiguration gcProd (NOLOCK) 
ON rpl.RwPrceLcleID = gcProd.GnrlCnfgHdrID 
AND gcProd.GnrlCnfgTblNme = 'RawPriceLocale' 
AND gcProd.GnrlCnfgQlfr = 'i_gpr_product'
LEFT JOIN GeneralConfiguration gcSoldTo (NOLOCK) --Only YP06 has SoldTo
ON rpl.RwPrceLcleID = gcSoldTo.GnrlCnfgHdrID 
AND gcSoldTo.GnrlCnfgTblNme = 'RawPriceLocale' 
AND gcSoldTo.GnrlCnfgQlfr = 'i_gpr_sold_to_code' 
AND #FPSReconLastStaged.i_gpr_condition_type = 'YP06'
LEFT JOIN GeneralConfiguration gcShipTo (NOLOCK) --Only YP06 has ShipTo
ON rpl.RwPrceLcleID = gcShipTo.GnrlCnfgHdrID 
AND gcSoldTo.GnrlCnfgTblNme = 'RawPriceLocale' 
AND gcShipTo.GnrlCnfgQlfr = 'i_gpr_ship_to_code' 
AND #FPSReconLastStaged.i_gpr_condition_type = 'YP06'

 
 --Update Discounts/Surcharges both new or updates
UPDATE #FPSReconLastStaged
SET RALocaleID     =  IsNull(#FPSReconLastStaged.RALocaleID,ds.RALocaleID)
    ,RAProductID    = IsNull(#FPSReconLastStaged.RAProductID,ds.RAProductId)
    ,RAUOMID        = IsNull(#FPSReconLastStaged.RAUOMID,ds.RAUOMID)
    ,RACurrencyID   = IsNull(#FPSReconLastStaged.RACurrencyID,ds.RACurrencyID)
    ,RABAID         = IsNull(#FPSReconLastStaged.RABAID, ds.RABAID)
    ,i_gpr_rate = CAST(#FPSReconLastStaged.CurrentValue AS varchar(10))
    ,i_gpr_rate_unit = c.CrrncySmbl
    ,i_gpr_condition_table = ds.FPSconditiontable
    ,i_gpr_UOM = NULL
    ,i_gpr_plant_code = ds.FPSplantcode 
    ,i_gpr_product = ds.FPSproduct
    ,i_gpr_sold_to_code =  ds.FPSsoldtocode
    ,i_gpr_ship_to_code = ds.FPSshiptocode
    ,i_gpr_currency = c.CrrncySmbl
    ,i_gpr_validfrom = FORMAT ( #FPSReconLastStaged.ValidFromDate, 'yyyyMMdd', 'en-US' )
    ,i_gpr_validto = FORMAT (#FPSReconLastStaged.ValidToDate, 'yyyyMMdd', 'en-US' )
    ,i_gpr_start_time = FORMAT (#FPSReconLastStaged.ValidFromDate, 'HHmmss', 'en-US' )
    ,i_gpr_end_time = FORMAT (#FPSReconLastStaged.ValidToDate, 'HHmmss', 'en-US' )
    ,i_gpr_calculation_type = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_calculation_type')
    ,i_gpr_kosrt = mps.i_ogs_id
    ,i_gpr_quantity = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_quantity')
    ,i_gpr_cond_tab_usage = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_cond_tab_usage')
    ,i_gpr_cou_code =   dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_cou_code')  
    ,i_gpr_rec_type = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_rec_type')
FROM  #FPSReconLastStaged 
INNER JOIN MTVFPSDiscountSurcharge AS ds (NOLOCK) 
ON #FPSReconLastStaged.RawPriceDtlIdnty = ds.MFDSID 
AND #FPSReconLastStaged.i_gpr_condition_type = ds.FPSconditiontype 
LEFT JOIN MTVFPSRackPriceStaging as mps (NOLOCK) 
ON mps.RawPriceDtlIdnty = #FPSReconLastStaged.RawPriceDtlIdnty
AND mps.i_ogs_condition_type = #FPSReconLastStaged.i_gpr_condition_type
LEFT JOIN Currency AS c (NOLOCK) 
ON c.CrrncyID = ds.RACurrencyID

  
 --Update Contract Prices both new or updates
UPDATE #FPSReconLastStaged
SET RALocaleID     =  IsNull(#FPSReconLastStaged.RALocaleID,ds.RALocaleID)
    ,RAProductID    = IsNull(#FPSReconLastStaged.RAProductID,ds.RAProductId)
    ,RAUOMID        = IsNull(#FPSReconLastStaged.RAUOMID,ds.RAUOMID)
    ,RABAID = IsNull(#FPSReconLastStaged.RABAID, ds.RABAID)
    ,RACurrencyID   = IsNull(#FPSReconLastStaged.RACurrencyID,ds.RACurrencyID)
    ,i_gpr_rate = CAST(#FPSReconLastStaged.CurrentValue AS varchar(10))
    ,i_gpr_rate_unit = c.CrrncySmbl
    ,i_gpr_condition_table = ds.FPSconditiontable
    ,i_gpr_UOM = NULL
    ,i_gpr_plant_code = ds.FPSplantcode 
    ,i_gpr_product = ds.FPSproduct
    ,i_gpr_sold_to_code =  ds.FPSsoldtocode
    ,i_gpr_ship_to_code = ds.FPSshiptocode
    ,i_gpr_currency = c.CrrncySmbl
    ,i_gpr_validfrom = FORMAT ( #FPSReconLastStaged.ValidFromDate, 'yyyyMMdd', 'en-US' )
    ,i_gpr_validto = FORMAT (#FPSReconLastStaged.ValidToDate, 'yyyyMMdd', 'en-US' )
    ,i_gpr_start_time = FORMAT (#FPSReconLastStaged.ValidFromDate, 'HHmmss', 'en-US' )
    ,i_gpr_end_time = FORMAT (#FPSReconLastStaged.ValidToDate, 'HHmmss', 'en-US' )
    ,i_gpr_calculation_type = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_calculation_type')
    ,i_gpr_kosrt = mps.i_ogs_id
    ,i_gpr_quantity = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_quantity')
    ,i_gpr_cond_tab_usage = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_cond_tab_usage')
    ,i_gpr_cou_code =   dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_cou_code')  
    ,i_gpr_rec_type = dbo.GetRegistryValue('Motiva\FPS\OutBound\FPSRecon\i_gpr_rec_type')
FROM  #FPSReconLastStaged 
INNER JOIN MTVFPSContractPriceDates AS ds (NOLOCK) 
ON #FPSReconLastStaged.RawPriceDtlIdnty = ds.MFCPDID 
AND #FPSReconLastStaged.i_gpr_condition_type = ds.FPSconditiontype 
LEFT JOIN MTVFPSRackPriceStaging as mps (NOLOCK) 
ON mps.RawPriceDtlIdnty = #FPSReconLastStaged.RawPriceDtlIdnty
AND mps.i_ogs_condition_type = #FPSReconLastStaged.i_gpr_condition_type
LEFT JOIN Currency AS c (NOLOCK) 
ON c.CrrncyID = ds.RACurrencyID

SELECT * FROM #FPSReconLastStaged AS fls

GO 

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPS_Price_Recon]') IS NOT NULL
      BEGIN
                     EXECUTE       sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_FPS_Price_Recon.sql'
                     PRINT '<<< ALTERED StoredProcedure MTV_FPS_Price_Recon >>>'
         END
         ELSE
         BEGIN
                     PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_FPS_Price_Recon >>>'
         END    


