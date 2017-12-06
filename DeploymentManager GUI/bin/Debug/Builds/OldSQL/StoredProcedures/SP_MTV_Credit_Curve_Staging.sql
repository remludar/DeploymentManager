
/****** Object:  StoredProcedure [dbo].[MTV_Credit_Curve_Staging]    Script Date: 6/17/2016 10:12:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_Credit_Curve_Staging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Credit_Curve_Staging] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Credit_Curve_Staging >>>'
	  END
GO
-- =======================================================================================================================================
-- Author:		Craig Albright	
-- Create date: 09/19/2016
-- Description:	Stage Price Curves
-- =======================================================================================================================================
ALTER PROCEDURE [dbo].[MTV_Credit_Curve_Staging] 
@fromDate DateTime, 
@toDate DateTime, 
@snapshotDate DateTime

AS


Select	[rpd].[Idnty] 
,[rpd].[RPDtlTpe]
,rpl.[CurveName]
,rpl.[RPLcleRpHdrID]
,[rpd].[RPDtlQteFrmDte]
,[rpd].[RPDtlQteToDte]
,pt.[PrceTpeNme]
,Case When RawPriceHeader.RPHdrTpe In ('P', 'T') and rpd.RPDtlTpe = 'A' Then 'N/A'  
      When rpl.IsSpotPrice = 1 and  rpd.RPDtlTpe = 'A' Then 'Spot' 
	  Else ppcvtp.PricingPeriodName End [DeliveryPeriod]
,[rpd].[RPDtlTrdeFrmDte]
,[rpd].[RPDtlTrdeToDte]
,AVG(RPVle) [RPVle]
,[rpd].[RPDtlCrrncyID]
,[rpd].[RPDtlUOM] 
,3 as OriginalUom
,19 as OriginalCur
,rpl.[IsBasisCurve] [IsBasisCurve] 
From	[RawPriceLocale] rpl (NoLock)	 
Join RawPriceDetail rpd (NoLock) On	 
		[rpd].RwPrceLcleID = rpl.RwPrceLcleID	
Join [RawPrice] rp (NoLock) On rp.RPRPDtlIdnty = [rpd].Idnty	
Join [PriceTypeRelation] ptr (NoLock) On	rp.[RPPrceTpeIdnty] = ptr.[PrceTpeRltnChldPrceTpeIdnty]	
Join [PriceType] pt (NoLock) On ptr.PrceTpeRltnPrntPrceTpeIdnty = pt.Idnty
Join [RawPriceHeader] (NoLock) On rpl.RPLcleRPHdrID = [RawPriceHeader].RPHdrID	
Left Join [VETradePeriod] (NoLock) On [rpd].VETradePeriodID = [VETradePeriod].VETradePeriodID
Left Join [PricingPeriodCategoryVETradePeriod] ppcvtp (NoLock) On [rpd].VETradePeriodID = ppcvtp.VETradePeriodID and exists 		 
                    (select '' from [RawPriceLocalePricingPeriodCategory] (NoLock) 		where [RawPriceLocalePricingPeriodCategory].PricingPeriodCategoryID = 	 
                    		ppcvtp.PricingPeriodCategoryID and 		 
                    	[RawPriceLocalePricingPeriodCategory].IsUsedForSettlement = Case When [rpd].RPDtlTpe = 'F' 	 
                    		Then 0 Else 1 End and [RawPriceLocalePricingPeriodCategory].RwPrceLcleID = [rpd].RwPrceLcleID) 	 
                    		and [rpd].RPDtlQteFrmDte between ppcvtp.RollOnBoardDate and ppcvtp.RollOffBoardDate	 
Join [Product] [Chemical] (NoLock) On rpl.RPLcleChmclParPrdctID = [Chemical].PrdctID
Left Join [ProductLocale] (NoLock) On rpl.RPLcleChmclChdPrdctID = [ProductLocale].PrdctID AND rpl.RPLcleLcleID = [ProductLocale].LcleID  
Where	(	(rpd. RPDtlQteFrmDte	Between  @fromDate  And   @toDate   or @snapshotDate   
                    Between rpd. RPDtlQteFrmDte	and	rpd.RPDtlQteToDte) And	[rpd].[RPDtlStts] = 'A'  
                    And	rpl.[IsBasisCurve] = 0	) GROUP BY	 [rpd].[Idnty], rpl.[CurveName], rpl.[RPLcleRpHdrID],  
                    rpl.[RPLcleChmclParPrdctID], rpl.[RPLcleChmclChdPrdctID], rpl.[RPLcleLcleID], rpl.[ToLcleID],  
                    [rpd].[RPDtlQteFrmDte], [rpd].[RPDtlQteToDte], Case When RawPriceHeader.RPHdrTpe In ('P', 'T') and rpd.RPDtlTpe = 'A'  
                    Then 'N/A' When rpl.IsSpotPrice = 1 and  rpd.RPDtlTpe = 'A' Then 'Spot' Else ppcvtp.PricingPeriodName End, 
                     [rpd].[RPDtlTrdeFrmDte], [rpd].[RPDtlTrdeToDte], [rpd].[RPDtlStts], [rpd].[RPDtlTpe], pt.[PrceTpeNme],  
                    [rpd].[PublicationDate], [rpd].[RPDtlRqstngUserID], [rpd].[RPDtlEntryUserID], [rpd].[RPDtlEntryDte],  
                    [rpd].[RPDtlApprvngUserID], [rpd].[RPDtlApprvlDte], [rpd].[RPDtlNte], [rpd].[RPDtlCrrncyID],  
                    [rpd].[RPDtlUOM], [rpd].[CreationDate], [rpd].[Source], Coalesce(ProductLocale.TypicalSpecificGravity,  
                    Chemical.PrdctSpcfcGrvty), Coalesce(ProductLocale.TypicalEnergy, Chemical.PrdctEnrgy), Case When RawPriceHeader.RPHdrTpe In ('I', 'C')  
                    Then null Else rpd.RPDtlCrrncyID End, rpl.[IsBasisCurve]
UNION ALL 
Select 
rc.RiskCurveID idnty
,rpd.RPDtlTpe
,rpl.CurveName
,rpl.RPLcleRPHdrID
,ISNULL(rpd.RPDtlQteFrmDte, rcv.StartDate) RPDtlQteFrmDte
,ISNULL(rpd.RPDtlQteFrmDte, rcv.EndDate) RPDtlQteFrmDte
,pt.[PrceTpeNme]
,Case When rph.RPHdrTpe In ('P', 'T') and rpd.RPDtlTpe = 'A' Then 'N/A'  
      When rpl.IsSpotPrice = 1 and  rpd.RPDtlTpe = 'A' Then 'Spot' 
	  Else ppcvtp.PricingPeriodName End [DeliveryPeriod]
,[rpd].[RPDtlTrdeFrmDte]
,[rpd].[RPDtlTrdeToDte]
,AVG(rcv.Value) [RPVle]
,[rpd].[RPDtlCrrncyID]
,[rpd].[RPDtlUOM] 
,3 as OriginalUom
,19 as OriginalCur
,rpl.[IsBasisCurve] [IsBasisCurve] 
From RawPriceLocale rpl 
join RiskCurve rc(nolock) on rc.RwPrceLcleID = rpl.RwPrceLcleID
join RiskCurveValue(nolock) rcv on rc.RiskCurveID = rcv.RiskCurveID
left join RawPriceDetail(nolock) rpd on rpd.RwPrceLcleID = rpl.RwPrceLcleID and rc.VETradePeriodID = rpd.VETradePeriodID
left join RawPriceHeader(nolock) rph on rpd.RPDtlRPLcleRPHdrID = rph.RPHdrID
left join RawPrice(nolock) rp on rp.RPRPDtlIdnty = rpd.Idnty
left Join [PriceTypeRelation] ptr (NoLock) On	rp.[RPPrceTpeIdnty] = ptr.[PrceTpeRltnChldPrceTpeIdnty]	
left Join [PriceType] pt (NoLock) On ptr.PrceTpeRltnPrntPrceTpeIdnty = pt.Idnty
Left Join [VETradePeriod] vetp (NoLock) On rpd.VETradePeriodID = vetp.VETradePeriodID
Left Join [PricingPeriodCategoryVETradePeriod] ppcvtp (NoLock) On [rpd].VETradePeriodID = ppcvtp.VETradePeriodID and exists 		 
                    (select '' from [RawPriceLocalePricingPeriodCategory] (NoLock) 		where [RawPriceLocalePricingPeriodCategory].PricingPeriodCategoryID = 	 
                    		ppcvtp.PricingPeriodCategoryID and 		 
                    	[RawPriceLocalePricingPeriodCategory].IsUsedForSettlement = Case When [rpd].RPDtlTpe = 'F' 	 
                    		Then 0 Else 1 End and [RawPriceLocalePricingPeriodCategory].RwPrceLcleID = [rpd].RwPrceLcleID) 	 
                    		and [rpd].RPDtlQteFrmDte between ppcvtp.RollOnBoardDate and ppcvtp.RollOffBoardDate
left Join [Product] [Chemical] (NoLock) On rpl.RPLcleChmclParPrdctID = [Chemical].PrdctID
Left Join [ProductLocale] (NoLock) On rpl.RPLcleChmclChdPrdctID = [ProductLocale].PrdctID AND rpl.RPLcleLcleID = [ProductLocale].LcleID  	 
Where @snapshotDate between rcv.StartDate and rcv.EndDate
					and rc.IsMarketCurve = 1
GROUP BY	 rc.RiskCurveID, rpl.[CurveName], rpl.[RPLcleRpHdrID],  
                    rpl.[RPLcleChmclParPrdctID], rpl.[RPLcleChmclChdPrdctID], rpl.[RPLcleLcleID], rpl.[ToLcleID],  
                    [rpd].[RPDtlQteFrmDte], [rpd].[RPDtlQteToDte], Case When rph.RPHdrTpe In ('P', 'T') and rpd.RPDtlTpe = 'A'  
                    Then 'N/A' When rpl.IsSpotPrice = 1 and  rpd.RPDtlTpe = 'A' Then 'Spot' Else ppcvtp.PricingPeriodName End, 
                     [rpd].[RPDtlTrdeFrmDte], rcv.StartDate, [rpd].[RPDtlTrdeToDte],rcv.EndDate, [rpd].[RPDtlStts], [rpd].[RPDtlTpe], pt.[PrceTpeNme],  
                    [rpd].[PublicationDate], [rpd].[RPDtlRqstngUserID], [rpd].[RPDtlEntryUserID], [rpd].[RPDtlEntryDte],  
                    [rpd].[RPDtlApprvngUserID], [rpd].[RPDtlApprvlDte], [rpd].[RPDtlNte], [rpd].[RPDtlCrrncyID],  
                    [rpd].[RPDtlUOM], [rpd].[CreationDate], [rpd].[Source], Coalesce(ProductLocale.TypicalSpecificGravity,  
                    Chemical.PrdctSpcfcGrvty), Coalesce(ProductLocale.TypicalEnergy, Chemical.PrdctEnrgy), Case When rph.RPHdrTpe In ('I', 'C')  
                    Then null Else rpd.RPDtlCrrncyID End, rpl.[IsBasisCurve]