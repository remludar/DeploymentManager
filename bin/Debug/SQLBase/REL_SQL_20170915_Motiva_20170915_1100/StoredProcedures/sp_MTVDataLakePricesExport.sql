/****** Object:  StoredProcedure [dbo].[MTVDataLakePricesExport]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVDataLakePricesExport.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakePricesExport]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVDataLakePricesExport] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTVDataLakePricesExport >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVDataLakePricesExport]
	@EffectiveDateOffset INT
AS

Declare @EffectiveStartDate DateTime = DATEADD(Day, DATEDIFF(DAY, '19000101', GETDATE()), '19000101')
Declare @EffectiveEndDate DateTime = DATEADD(Day, DATEDIFF(DAY, '19000101', GETDATE()), '23:59:59')

IF(ISNULL(@EffectiveDateOffset, '') <> '')
	Select @EffectiveStartDate = DATEADD(Day, @EffectiveDateOffset * -1, @EffectiveStartDate)

Select
	[RawPriceLocale].[RwPrceLcleID] AS PriceCurveID
	,[RawPriceLocale].[CurveName] AS CurveName
	--,[RawPriceLocale].[RPLcleRpHdrID] AS PriceServiceID
	,[RawPriceHeader].[RPHdrNme] AS PriceServiceName
	,[RawPriceLocale].[RPLcleIntrfceCde] AS InterfaceCode
	,[RawPriceHeader].[RPHdrCde] AS PriceServiceCode
	--,[RawPriceLocale].[RPLcleChmclParPrdctID] AS ProductID
	,[Chemical].[PrdctNme] AS ProductName
	--,[RawPriceLocale].[RPLcleLcleID] AS LocationID
	,[Locale].LcleNme + ISNULL([Locale].LcleNmeExtension, '') AS LocationName
	--,[RawPriceLocale].[ToLcleID] AS ToLocationID
	,[ToLocale].LcleNme + ISNULL([ToLocale].LcleNmeExtension, '') AS ToLocationName
	,[RawPriceDetail].[RPDtlQteFrmDte] AS QuoteToDate
	,[RawPriceDetail].[RPDtlQteToDte] AS QuoteFromDate
	,Case	When RawPriceHeader.RPHdrTpe In ('P', 'T') and RawPriceDetail.RPDtlTpe = 'A' 
				Then 'N/A' 
			When RawPriceLocale. IsSpotPrice = 1 and  RawPriceDetail.RPDtlTpe = 'A' 
				Then 'Spot' 
			Else PricingPeriodCategoryVETradePeriod.PricingPeriodName 
			End [DeliveryPeriod]
	,[RawPriceDetail].[RPDtlTrdeFrmDte] AS DeliveryFromDate
	,[RawPriceDetail].[RPDtlTrdeToDte] AS DeliveryToDate
	,[RawPriceLocale].[Status] AS PriceCurveStatus
	,[RawPriceDetail].[RPDtlTpe] AS Type
	,[PriceType].[PrceTpeNme] AS PriceType
	,AVG(RPVle) AS Value
	,[RawPriceDetail].[PublicationDate]
	--,[RawPriceDetail].[RPDtlRqstngUserID] AS RequestingUserID
	,CASE When [RequestContact].CntctLstNme IS NULL AND [RequestContact].CntctFrstNme IS NULL Then Null
			When [RequestContact].CntctLstNme IS NOT NULL AND [RequestContact].CntctFrstNme IS NULL Then [RequestContact].CntctLstNme
			When [RequestContact].CntctLstNme IS NULL AND [RequestContact].CntctFrstNme IS NOT NULL Then [RequestContact].CntctFrstNme
			ELSE [RequestContact].CntctLstNme + ', ' + [RequestContact].CntctFrstNme
			End AS RequestingUserName
	--,[RawPriceDetail].[RPDtlEntryUserID] AS RevisionUserID
	,CASE When [RevisionContact].CntctLstNme IS NULL AND [RevisionContact].CntctFrstNme IS NULL Then Null
			When [RevisionContact].CntctLstNme IS NOT NULL AND [RevisionContact].CntctFrstNme IS NULL Then [RevisionContact].CntctLstNme
			When [RevisionContact].CntctLstNme IS NULL AND [RevisionContact].CntctFrstNme IS NOT NULL Then [RevisionContact].CntctFrstNme
			ELSE [RevisionContact].CntctLstNme + ', ' + [RevisionContact].CntctFrstNme
			End As RevisionUserName
	,[RawPriceDetail].[RPDtlEntryDte] AS RevisionDate
	--,[RawPriceDetail].[RPDtlApprvngUserID] AS ApprovalUserID
	,CASE When [ApprovalContact].CntctLstNme IS NULL AND [ApprovalContact].CntctFrstNme IS NULL Then Null
			When [ApprovalContact].CntctLstNme IS NOT NULL AND [ApprovalContact].CntctFrstNme IS NULL Then [ApprovalContact].CntctLstNme
			When [ApprovalContact].CntctLstNme IS NULL AND [ApprovalContact].CntctFrstNme IS NOT NULL Then [ApprovalContact].CntctFrstNme
			ELSE [ApprovalContact].CntctLstNme + ', ' + [ApprovalContact].CntctFrstNme
			End As ApprovalUserName
	,[RawPriceDetail].[RPDtlApprvlDte] AS ApprovalDate
	,[RawPriceDetail].[RPDtlNte] AS Comment
	,[RawPriceDetail].[RPDtlCrrncyID] AS OriginalCurrency
	,[RawPriceDetail].[RPDtlUOM] AS OriginalUOM
	,[RawPriceDetail].[CreationDate]
	,[RawPriceDetail].[Source]
From	[RawPriceLocale] (NoLock)
	Join [RawPriceDetail] (NoLock) On
		[RawPriceDetail].RwPrceLcleID = [RawPriceLocale].RwPrceLcleID
	Join [RawPrice] (NoLock) On
		[RawPrice].RPRPDtlIdnty = [RawPriceDetail].Idnty
	Join [PriceTypeRelation] (NoLock) On
		[RawPrice].[RPPrceTpeIdnty] = [PriceTypeRelation].[PrceTpeRltnChldPrceTpeIdnty]
	Join [PriceType] (NoLock) On
		[PriceTypeRelation].PrceTpeRltnPrntPrceTpeIdnty = [PriceType].Idnty
	Join [RawPriceHeader] (NoLock) On
		[RawPriceLocale].RPLcleRPHdrID = [RawPriceHeader].RPHdrID
	Left Join [VETradePeriod] (NoLock) On
		[RawPriceDetail].VETradePeriodID = [VETradePeriod].VETradePeriodID
	Left Join [PricingPeriodCategoryVETradePeriod] (NoLock) On
		[RawPriceDetail].VETradePeriodID = [PricingPeriodCategoryVETradePeriod].VETradePeriodID 
			and exists (select '' from [RawPriceLocalePricingPeriodCategory] (NoLock) 
						where [RawPriceLocalePricingPeriodCategory].PricingPeriodCategoryID = [PricingPeriodCategoryVETradePeriod].PricingPeriodCategoryID 
						and [RawPriceLocalePricingPeriodCategory].IsUsedForSettlement = Case When [RawPriceDetail].RPDtlTpe = 'F' 
																							Then 0 
																						Else 1 
																						End 
						and [RawPriceLocalePricingPeriodCategory].RwPrceLcleID = [RawPriceDetail].RwPrceLcleID) 
			and [RawPriceDetail].RPDtlQteFrmDte between [PricingPeriodCategoryVETradePeriod].RollOnBoardDate and [PricingPeriodCategoryVETradePeriod].RollOffBoardDate
	Join [Product] [Chemical] (NoLock) On
		[RawPriceLocale].RPLcleChmclParPrdctID = [Chemical].PrdctID
	Left Join [ProductLocale] (NoLock) On
		[RawPriceLocale].RPLcleChmclChdPrdctID = [ProductLocale].PrdctID AND [RawPriceLocale].RPLcleLcleID = [ProductLocale].LcleID
	Left Join [Locale] (NoLock) On
		[RawPriceLocale].RPLcleLcleID = [Locale].LcleID
	Left Join [Locale] [ToLocale] (NoLock) On
		[RawPriceLocale].ToLcleID = [ToLocale].LcleID
	Left Join [Users] [RequestUser] (NoLock) On
		[RequestUser].UserID = [RawPriceDetail].RPDtlRqstngUserID
	Left Join [Contact] [RequestContact] (NoLock) On
		[RequestContact].CntctID = [RequestUser].UserCntctID
	Left Join [Users] [RevisionUser] (NoLock) On
		[RevisionUser].UserID = [RawPriceDetail].RPDtlEntryUserID
	Left Join [Contact] [RevisionContact] (NoLock) On
		[RevisionContact].CntctID = [RevisionUser].UserCntctID
	Left Join [Users] [ApprovalUser] (NoLock) On
		[ApprovalUser].UserID = [RawPriceDetail].RPDtlApprvngUserID
	Left Join [Contact] [ApprovalContact] (NoLock) On
		[ApprovalContact].CntctID = [ApprovalUser].UserCntctID
	Left Join [GeneralConfiguration] [FPSContractType] (NoLock) On
		[RawPriceHeader].RPHdrID = [FPSContractType].GnrlCnfgHdrID AND
		[FPSContractType].GnrlCnfgQlfr = 'FPSConditionType' AND
		[FPSContractType].GnrlCnfgTblNme = 'RawPriceHeader' AND
		[FPSContractType].GnrlCnfgHdrID <> 0
	Left Join [GeneralConfiguration] [TransferPriceType] (NoLock) On
		[RawPriceLocale].RwPrceLcleID = [TransferPriceType].GnrlCnfgHdrID AND
		[TransferPriceType].GnrlCnfgQlfr = 'TransferPriceType' AND
		[TransferPriceType].GnrlCnfgTblNme = 'RawPriceLocale' AND
		[TransferPriceType].GnrlCnfgHdrID <> 0

Where [RawPriceDetail].RPDtlQteFrmDte <= @EffectiveEndDate AND [RawPriceDetail].RPDtlQteToDte >= @EffectiveStartDate
		AND [FPSContractType].GnrlCnfgMulti IS NULL AND [TransferPriceType].GnrlCnfgMulti IS NULL 
		AND [RawPriceHeader].RPHdrID <> 4
		
GROUP BY [RawPriceLocale].[RwPrceLcleID]
	,[RawPriceLocale].[CurveName]
	--,[RawPriceLocale].[RPLcleRpHdrID]
	,[RawPriceHeader].[RPHdrNme]
	,[RawPriceLocale].[RPLcleIntrfceCde]
	,[RawPriceHeader].[RPHdrCde]
	--,[RawPriceLocale].[RPLcleChmclParPrdctID]
	,[Chemical].[PrdctNme]
	--,[RawPriceLocale].[RPLcleLcleID]
	,[Locale].LcleNme + ISNULL([Locale].LcleNmeExtension, '')
	--,[RawPriceLocale].[ToLcleID]
	,[ToLocale].LcleNme + ISNULL([ToLocale].LcleNmeExtension, '')
	,[RawPriceDetail].[RPDtlQteFrmDte]
	,[RawPriceDetail].[RPDtlQteToDte]
	,Case	When RawPriceHeader.RPHdrTpe In ('P', 'T') and RawPriceDetail.RPDtlTpe = 'A' 
				Then 'N/A' 
			When RawPriceLocale. IsSpotPrice = 1 and  RawPriceDetail.RPDtlTpe = 'A' 
				Then 'Spot' 
			Else PricingPeriodCategoryVETradePeriod.PricingPeriodName 
	End
	,[RawPriceDetail].[RPDtlTrdeFrmDte]
	,[RawPriceDetail].[RPDtlTrdeToDte]
	,[RawPriceLocale].[Status]
	,[RawPriceDetail].[RPDtlTpe]
	,[PriceType].[PrceTpeNme]
	--,AVG(RPVle)
	,[RawPriceDetail].[PublicationDate]
	--,[RawPriceDetail].[RPDtlRqstngUserID]
	,CASE When [RequestContact].CntctLstNme IS NULL AND [RequestContact].CntctFrstNme IS NULL Then Null
			When [RequestContact].CntctLstNme IS NOT NULL AND [RequestContact].CntctFrstNme IS NULL Then [RequestContact].CntctLstNme
			When [RequestContact].CntctLstNme IS NULL AND [RequestContact].CntctFrstNme IS NOT NULL Then [RequestContact].CntctFrstNme
			ELSE [RequestContact].CntctLstNme + ', ' + [RequestContact].CntctFrstNme
			End
	--,[RawPriceDetail].[RPDtlEntryUserID]
	,CASE When [RevisionContact].CntctLstNme IS NULL AND [RevisionContact].CntctFrstNme IS NULL Then Null
			When [RevisionContact].CntctLstNme IS NOT NULL AND [RevisionContact].CntctFrstNme IS NULL Then [RevisionContact].CntctLstNme
			When [RevisionContact].CntctLstNme IS NULL AND [RevisionContact].CntctFrstNme IS NOT NULL Then [RevisionContact].CntctFrstNme
			ELSE [RevisionContact].CntctLstNme + ', ' + [RevisionContact].CntctFrstNme
			End
	,[RawPriceDetail].[RPDtlEntryDte]
	--,[RawPriceDetail].[RPDtlApprvngUserID]
	,CASE When [ApprovalContact].CntctLstNme IS NULL AND [ApprovalContact].CntctFrstNme IS NULL Then Null
			When [ApprovalContact].CntctLstNme IS NOT NULL AND [ApprovalContact].CntctFrstNme IS NULL Then [ApprovalContact].CntctLstNme
			When [ApprovalContact].CntctLstNme IS NULL AND [ApprovalContact].CntctFrstNme IS NOT NULL Then [ApprovalContact].CntctFrstNme
			ELSE [ApprovalContact].CntctLstNme + ', ' + [ApprovalContact].CntctFrstNme
			End
	,[RawPriceDetail].[RPDtlApprvlDte]
	,[RawPriceDetail].[RPDtlNte]
	,[RawPriceDetail].[RPDtlCrrncyID]
	,[RawPriceDetail].[RPDtlUOM]
	,[RawPriceDetail].[CreationDate]
	,[RawPriceDetail].[Source]
	,[RawPriceLocale].[RPLcleIntrfceCde]
	,[RawPriceHeader].[RPHdrCde]


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakePricesExport]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVDataLakePricesExport.sql'
	PRINT '<<< ALTERED StoredProcedure MTVDataLakePricesExport >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVDataLakePricesExport >>>'
END
 