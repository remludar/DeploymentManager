PRINT 'Start Script=sp_MTV_Search_SupplyToFSM_Primary.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_SupplyToFSM_Primary]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Search_SupplyToFSM_Primary] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Search_SupplyToFSM_Primary >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
execute MTV_Search_SupplyToFSM_Primary @sdt_DateTime = '2015-03-31 00:00'
*/

ALTER PROCEDURE [dbo].[MTV_Search_SupplyToFSM_Primary]
								(
								@sdt_DateTime			SmallDateTime = Null,
								@vc_LocaleIds			Varchar(8000)	= NULL,
								@vc_ProductIds			Varchar(8000)	= NULL,
								@i_FromBAId				Varchar(8000)   = NULL,
								@i_ToBAId				Varchar(8000)	= NULL

								)

AS

DECLARE @vc_ProvisionRuleIDs	Varchar(8000)	= NULL,
	@vc_TransferPriceTypes	Varchar(8000)	= 'YT01'
	
If @sdt_DateTime = Null select @sdt_DateTime = getdate()

SET @sdt_DateTime = dateadd(DAY, -1, @sdt_DateTime)

   
Create Table #ProvisionRuleIds
(
	ID	Int
)

Create Table #BAIdsFrom 
(
	 ID INT, 
 )

Create Table #BAIdsTo
(
	 ID INT, 
 )

 Create Table #AllBAs
 (
  ID INT
 )
 
 --DECLARE @i_FromBAID Int,
--@i_ToBAID int 
--Select @i_FromBAID = BAID FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND ba.Name =  dbo.GetRegistryValue('MotivaSTLIntrnlBAName')
--Select @i_ToBAID = BAID FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND ba.Name = dbo.GetRegistryValue('MotivaFSMIntrnlBAName')

INSERT INTO #AllBAs
SELECT BAID
FROM BusinessAssociate AS ba 
WHERE ba.BAStts = 'A' AND
ba.Name IN (dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'),
			dbo.GetRegistryValue('MotivaSTLIntrnlBAName'),
			dbo.GetRegistryValue('MotivaPTArthrIntrnlBAName'),
			dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))

IF IsNull(LTrim(RTrim(@i_FromBAId)),'') = '' AND IsNull(LTrim(RTrim(@i_ToBAId)),'') = ''
	BEGIN
		INSERT #BAIdsFrom(ID)
		SELECT ID FROM #AllBAs

		----SELECT BAID
		----FROM BusinessAssociate AS ba 
		----WHERE ba.BAStts = 'A' AND
		----ba.Name IN (dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'),
		----			dbo.GetRegistryValue('MotivaSTLIntrnlBAName'),
		----			dbo.GetRegistryValue('MotivaPTArthrIntrnlBAName'),
		----			dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))

		INSERT #BAIdsTo(ID)
		SELECT ID FROM #AllBAs

		--SELECT BAID
		--FROM BusinessAssociate AS ba 
		--WHERE ba.BAStts = 'A' AND
		--ba.Name IN (dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'),
		--			dbo.GetRegistryValue('MotivaSTLIntrnlBAName'),
		--			dbo.GetRegistryValue('MotivaPTArthrIntrnlBAName'),
		--			dbo.GetRegistryValue('MotivaFSMIntrnlBAName'))
	END
ELSE
	BEGIN
		IF (@i_FromBAId IS NOT NULL)
			BEGIN
				INSERT #BAIdsFrom(ID)
				SELECT BAID FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND	ba.BAID = Convert(int, @i_FromBAId)
			END
		ELSE
			BEGIN
				INSERT #BAIdsFrom(ID)
				SELECT ID FROM #AllBAs
			END
					

		IF (@i_ToBAId IS NOT NULL)
			BEGIN
				INSERT #BAIdsTo(ID)
				SELECT BAID	FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND	ba.BAID = Convert(int, @i_ToBAId)
			END
		ELSE
			BEGIN
				INSERT #BAIdsTo(ID)
				SELECT ID FROM #AllBAs
			END
	END
	

If	IsNull(LTrim(RTrim(@vc_ProvisionRuleIDs)),'') = ''
Begin
	Insert	#ProvisionRuleIds
	Select	ProvisionRuleID
	From	dbo.ProvisionRule
	Where	[Status] = 'A'
	And		Exists
			(
			Select	1
			From	dbo.ProvisionRuleCondition
			Where	ProvisionRuleCondition.ProvisionRuleID = ProvisionRule.ProvisionRuleID
			And		ProvisionRuleCondition.FromBAID IN (select Id from #BAIdsFrom)--- STL
			And		ProvisionRuleCondition.ToBAID IN (select Id From #BAIdsTo) ---FSM
			And		ProvisionRuleCondition.Exclude = 'N'
			)		
End
Else
Begin
	Insert	#ProvisionRuleIds
	Select	Convert(Int,Value)
	From	dbo.CreateTableList(@vc_ProvisionRuleIDs) Ids
	Where	IsNumeric(Ids.Value) = 1

	Delete	#ProvisionRuleIds
	Where	Not Exists
			(
			Select	1
			From	ProvisionRule
			Where	ProvisionRule.ProvisionRuleID = #ProvisionRuleIds.ID
			And		ProvisionRule.[Status] = 'A'
			)
	And		Not Exists
			(
			Select	1
			From	dbo.ProvisionRuleCondition
			Where	ProvisionRuleCondition.ProvisionRuleID = #ProvisionRuleIds.ID
			And		ProvisionRuleCondition.FromBAID IN (select Id from #BAIdsFrom)--- STL
			And		ProvisionRuleCondition.ToBAID IN (select Id From #BAIdsTo) ---FSM
			And		ProvisionRuleCondition.Exclude = 'N'
			)
End

   
Create Table #Locales
(
	ID Int
)

If	IsNull(LTrim(RTrim(@vc_LocaleIds)),'') = ''
Begin
	Insert	#Locales
	Select	Distinct 
			ProvisionRuleProdLoc.LcleID
	From	dbo.ProvisionRuleProdLoc
End
Else
Begin
	Insert	#Locales
	Select	Convert(Int,Value)
	From	dbo.CreateTableList(@vc_LocaleIds) Ids
	Where	IsNumeric(Ids.Value) = 1
End

Create Table #Products
(
	ID Int
)

If	IsNull(LTrim(RTrim(@vc_ProductIds)),'') = ''
Begin
	Insert	#Products
	Select	Distinct 
			ProvisionRuleProdLoc.PrdctID
	From	dbo.ProvisionRuleProdLoc
End
Else
Begin
	Insert	#Products
	Select	Convert(Int,Value)
	From	dbo.CreateTableList(@vc_ProductIds) Ids
	Where	IsNumeric(Ids.Value) = 1
End

Create Table #TransferPriceTypes
(
	ID Varchar(4)
)

----------------------------------------------------------------------------------------------------
-- Not sure what the attribute will be named that is going to be on the RawPriceLocale to specify
-- YT2 to YT10, or if it will be in dynamic list box.  I put it in dynamic list box.
----------------------------------------------------------------------------------------------------

If	IsNull(LTrim(RTrim(@vc_TransferPriceTypes)),'') = ''
Begin
	Insert	#TransferPriceTypes
	Select	DynLstBxTyp
	From	dbo.DynamicListBox
	Where	DynLstBxQlfr = 'TransferPriceType' AND DynLstBxTblTyp IN ('YT01')
End
Else
Begin
	Insert	#TransferPriceTypes
	Select	Convert(Varchar(4),Value)
	From	dbo.CreateTableList(@vc_TransferPriceTypes) Ids
End

------------------------------------------------------------------------------------------------
-- Get the provision rule product locations
------------------------------------------------------------------------------------------------
Create Table #ProvisionRuleProdLocs
(
	ProvisionRuleProdLocID	Int,
	ProvisionRuleID			Int,
	PrdctID					Int,
	LcleID					Int
)

Insert	#ProvisionRuleProdLocs
		(
		ProvisionRuleProdLocID,
		ProvisionRuleID,
		PrdctID,
		LcleID
		)
Select	ProvisionRuleProdLocID,
		ProvisionRuleID,
		PrdctID,
		LcleID
From	dbo.ProvisionRuleProdLoc
Where	Exists
		(
		Select	1
		From	#ProvisionRuleIds
		Where	#ProvisionRuleIds.ID = ProvisionRuleProdLoc.ProvisionRuleID
		)
And		Exists
		(
		Select	1
		From	#Locales
		Where	#Locales.ID = ProvisionRuleProdLoc.LcleID
		)
And		Exists
		(
		Select	1
		From	#Products
		Where	#Products.ID = ProvisionRuleProdLoc.PrdctID
		)


--------------------------------------------------------------------------------------------
-- Get all the provision rows are secondary costs
--------------------------------------------------------------------------------------------
Create Table #DealDetailProvisionRows
(
	ProvisionRuleProdLocID Int,
	DlDtlPrvsnID	Int,
	DlDtlPrvsnRwID	Int,
	Percentage		Float,
	RwPrceLcleID	Int,
	PricetypeID		SMALLINT,
	ProvisionName	Varchar(80)
)

--------------------------------------------------------------------------------------------
-- First insert the ones that apply to all prod/locs on the rule
-- I chose not to dbo.V_FormulaTablet for performance reasons, but it could be used
----------------------------------------------------------------------------------------------
Insert	#DealDetailProvisionRows
		(
		ProvisionRuleProdLocID,
		DlDtlPrvsnID,
		DlDtlPrvsnRwID,
		Percentage,
		RwPrceLcleID,
		PricetypeID
		)
Select	#ProvisionRuleProdLocs.ProvisionRuleProdLocID,
		ProvisionRuleDlDtlPrvsn.DlDtlPrvsnID,
		DealDetailProvisionRow.DlDtlPrvsnRwID,
		Convert(float,DealDetailProvisionRow.PriceAttribute1),
		Convert(Int, PriceAttribute3),
		Convert(Int, PriceAttribute7)
From	#ProvisionRuleProdLocs
		Inner Join dbo.ProvisionRuleDlDtlPrvsn	On	ProvisionRuleDlDtlPrvsn.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
												And	@sdt_DateTime Between ProvisionRuleDlDtlPrvsn.StartDate And ProvisionRuleDlDtlPrvsn.EndDate
		Inner Join dbo.DealDetailProvision		On	DealDetailProvision.DlDtlPrvsnID = ProvisionRuleDlDtlPrvsn.DlDtlPrvsnID
												And	DealDetailProvision.[Status] = 'A'
												And	DealDetailProvision.CostType = 'P'
												And	@sdt_DateTime Between DealDetailProvision.DlDtlPrvsnFrmDte And DealDetailProvision.DlDtlPrvsnToDte
		Inner Join dbo.DealDetailProvisionRow	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute1) = 1
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute3) = 1
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute7) = 1
												AND DealDetailProvisionRow.DlDtlPRvsnRwTpe = 'F'



--------------------------------------------------------------------------------------------
-- Insert ones that only apply to specific product location combinations
----------------------------------------------------------------------------------------------
Insert	#DealDetailProvisionRows
		(
		ProvisionRuleProdLocID,
		DlDtlPrvsnID,
		DlDtlPrvsnRwID,
		Percentage,
		RwPrceLcleID,
		PricetypeID
		)
Select	#ProvisionRuleProdLocs.ProvisionRuleProdLocID,
		ProvisionRuleProdLocDlDtlPrvsn.DlDtlPrvsnID,
		DealDetailProvisionRow.DlDtlPrvsnRwID,
		Convert(float,DealDetailProvisionRow.PriceAttribute1),
		Convert(Int, DealDetailProvisionRow.PriceAttribute3),
		Convert(Int, DealDetailProvisionRow.PriceAttribute7)
From	#ProvisionRuleProdLocs
		Inner Join dbo.ProvisionRuleProdLocDlDtlPrvsn
												On	ProvisionRuleProdLocDlDtlPrvsn.ProvisionRuleProdLocID = #ProvisionRuleProdLocs.ProvisionRuleProdLocID
												And	@sdt_DateTime Between ProvisionRuleProdLocDlDtlPrvsn.StartDate And ProvisionRuleProdLocDlDtlPrvsn.EndDate
		Inner Join dbo.DealDetailProvision		On	DealDetailProvision.DlDtlPrvsnID = ProvisionRuleProdLocDlDtlPrvsn.DlDtlPrvsnID
												And	DealDetailProvision.[Status] = 'A'
												And	DealDetailProvision.CostType = 'P'
												And	@sdt_DateTime Between DealDetailProvision.DlDtlPrvsnFrmDte And DealDetailProvision.DlDtlPrvsnToDte
		Inner Join dbo.DealDetailProvisionRow	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute1) = 1
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute3) = 1
												And	IsNumeric(DealDetailProvisionRow.PriceAttribute7) = 1
												AND DealDetailProvisionRow.DlDtlPRvsnRwTpe = 'F'

UPDATE #DealDetailProvisionRows
 SET ProvisionName = Prvsn.PrvsnDscrptn
FROM #DealDetailProvisionRows INNER JOIN DealDetailProvision ON DealDetailProvision.DlDtlPrvsnID = #DealDetailProvisionRows.DlDtlPrvsnID
INNER JOIN Prvsn ON DealDetailProvision.DlDtlPrvsnPrvsnID = Prvsn.PrvsnID


--------------------------------------------------------------------------------------------
-- Get the distinct RwPrceLcleID and PriceTypeIDs to look up the prices and the categories
-- as there will be many provisions referencing the same ones
----------------------------------------------------------------------------------------------
Create Table #DistinctPrices
(
	ProvisionRuleProdLocID Int,
	RwPrceLcleID	Int,
	PriceTypeID		Int,
	RwPrceDtlID		INT NULL,
	RPDtlTpe		char(1) NULL,
	TransferPriceType	Varchar(40) NUll,
	Price			Float NULL,
	AllInPrice		FLOAT NULL
)

Insert	#DistinctPrices
		(
		ProvisionRuleProdLocID,
		RwPrceLcleID,
		PriceTypeID,
		RwPrceDtlID,
		TransferPriceType,
		Price
		)
Select	Distinct
		ProvisionRuleProdLocID,
		RwPrceLcleID,
		PriceTypeID,
		NULL,
		Null,
		NULL
From	#DealDetailProvisionRows

---------------------------------------------------------------------------------------------------
-- Update the TransferPriceType
---------------------------------------------------------------------------------------------------
Update	#DistinctPrices
Set		TransferPriceType = GeneralConfiguration.GnrlCnfgMulti
From	#DistinctPrices
		Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme = 'RawPriceLocale'
										And	GeneralConfiguration.GnrlCnfgQlfr = 'TransferPriceType'
										And	GeneralConfiguration.GnrlCnfgHdrID = #DistinctPrices.RwPrceLcleID
										And	GeneralConfiguration.GnrlCnfgDtlID = 0
										And	Exists
											(
											Select	1
											From	#TransferPriceTypes
											Where	#TransferPriceTypes.ID = GeneralConfiguration.GnrlCnfgMulti
											)

------------------------------------------------------------------------------------------------------
-- If running with all cost categories then don't delete out ones you we could not find
------------------------------------------------------------------------------------------------------
If	IsNull(LTrim(RTrim(@vc_TransferPriceTypes)),'') = ''
Begin
	Update	#DistinctPrices
	Set		TransferPriceType = 'Unknown'
	Where	TransferPriceType is Null
End
Else
Begin
	---------------------------------------------------------------------------------------------------
	-- Delete #DistinctPrices where category is null
	---------------------------------------------------------------------------------------------------
	Delete	#DistinctPrices
	Where	TransferPriceType is Null

	Delete	#DealDetailProvisionRows
	Where	Not Exists
			(
			Select	1
			From	#DistinctPrices
			Where	#DistinctPrices.RwPrceLcleID = #DealDetailProvisionRows.RwPrceLcleID
			And		#DistinctPrices.PriceTypeID = #DealDetailProvisionRows.PriceTypeID
			)

End

Update	#DistinctPrices
Set		RwPrceDtlID = A.RwPrceDtlID
		,RPDtlTpe = A.RPDtlTpe
		,Price = A.RPVle
From	#DistinctPrices
			CROSS apply (select * from dbo.Motiva_FN_GetRawPriceValue(#DistinctPrices.RwPrceLcleID, #DistinctPrices.PriceTypeID,@sdt_DateTime,null,1)) A 
		
WHERE #DistinctPrices.RwPrceLcleID = A.RwPrceLcleID and #DistinctPrices.RwPrceDtlID IS null			
			
UPDATE #DistinctPrices
SET AllInPrice = A.RPVle
--SELECT  * --rp.RPVle, rp.RPPrceTpeIdnty
FROM #DistinctPrices 
INNER JOIN #ProvisionRuleProdLocs AS prpl ON prpl.ProvisionRuleProdLocID = #DistinctPrices.ProvisionRuleProdLocID
INNER JOIN RawPriceLocale AS rpl ON rpl.RPLcleChmclParPrdctID = prpl.PrdctID AND rpl.RPLcleLcleID = prpl.LcleID 
INNER JOIN RawPriceHeader AS rph ON rph.RPHdrID = rpl.RPLcleRPHdrID 
AND rph.RPHdrNme = dbo.GetRegistryValue('STLFSM_TransferPriceServiceName')
CROSS apply (SELECT top 1 rpd.Idnty, rpd.RwPrceLcleID, rp.RPVle, rp.RPPrceTpeIdnty 
             from RawPriceDetail AS rpd
             INNER JOIN RawPrice rp ON rp.RPRPDtlIdnty = rpd.Idnty AND rp.[Status] = 'A'
               where rpd.RwPrceLcleID = rpl.RwPrceLcleID AND rpd.RPDtlStts = 'A' AND
	( @sdt_DateTime BETWEEN rpd.RPDtlQteFrmDte and rpd.RPDtlQteToDte OR rpd.RPDtlTrdeFrmDte < @sdt_DateTime)
             ORDER BY rpd.RPDtlQteFrmDte DESC) A where A.RwPrceLcleID = rpl.RwPrceLcleID 




SELECT distinct #DealDetailProvisionRows.ProvisionName,	
		ProvisionRule.[Description],
		Product.PrdctAbbv,
		Locale.LcleAbbrvtn,
		#DealDetailProvisionRows.Percentage,
		RawPriceHeader.RPHdrAbbv,
		RawPriceLocale.CurveName,
		GC1.GnrlCnfgMulti SAPMaterialCode,
		GC2.GnrlCnfgMulti SAPPlantCode,
		RawPriceLocale.RPLcleIntrfceCde PlattsCode,
		PriceType.PrceTpeNme,
		#DistinctPrices.TransferPriceType CurveType,
		#DistinctPrices.Price FullPrice,
		#DistinctPrices.Price * #DealDetailProvisionRows.Percentage * .01 FactoredPrice,
		#DistinctPrices.AllInPrice,
		#ProvisionRuleProdLocs.ProvisionRuleID,
		#ProvisionRuleProdLocs.PrdctID,
		#ProvisionRuleProdLocs.LcleID,
		#DistinctPrices.RwPrceLcleID PriceCurveID,
		#DistinctPrices.PriceTypeID,
		RawPriceHeader.RPHdrID,
		RawPriceDetail.RPDtlQteFrmDte StartDate, 
		RawPriceDetail.RPDtlQteToDte EndDate,
		RawPriceDetail.RPDtlTrdeFrmDte TradePeriodFromDate, 
		RawPriceDetail.RPDtlTrdeToDte TradePeriodToDate,
		RawPriceDetail.RPDtlUOM UOMID,
		PRC.FromBAID,
		PRC.ToBAID

		
From	#ProvisionRuleProdLocs
		Inner Join	#DealDetailProvisionRows	On	#DealDetailProvisionRows.ProvisionRuleProdLocID = #ProvisionRuleProdLocs.ProvisionRuleProdLocID
		Inner Join	#DistinctPrices				On	#DistinctPrices.RwPrceLcleID = #DealDetailProvisionRows.RwPrceLcleID
												And	#DistinctPrices.PriceTypeID = #DealDetailProvisionRows.PriceTypeID 
												AND #DistinctPrices.ProvisionRuleProdLocID = #DealDetailProvisionRows.ProvisionRuleProdLocID
		Inner Join	ProvisionRule				On	ProvisionRule.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
		Inner Join	Product						On	Product.PrdctID = #ProvisionRuleProdLocs.PrdctId
		left  join	GeneralConfiguration GC1	On	GC1.GnrlCnfgTblNme	=	'Product'
												and	GC1.GnrlCnfgQlfr	=	'SAPMaterialCode'
												and	GC1.GnrlCnfgHdrID	=	#ProvisionRuleProdLocs.PrdctID
		Inner Join	Locale						On	Locale.LcleID = #ProvisionRuleProdLocs.LcleID
		left  join	GeneralConfiguration GC2	On	GC2.GnrlCnfgTblNme	=	'Locale'
												and	GC2.GnrlCnfgQlfr	=	'SAPPlantCode'
												and	GC2.GnrlCnfgHdrID	=	#ProvisionRuleProdLocs.LcleID
		INNER JOIN  RawPriceDetail				ON  RawPriceDetail.Idnty = #DistinctPrices.RwPrceDtlID
		Inner Join	RawPriceLocale				On	RawPriceLocale.RwPrceLcleID = #DistinctPrices.RwPrceLcleID
		Inner Join	RawPriceHeader				On	RawPriceHeader.RPHdrID = RawPriceLocale.RPLcleRPHdrID
		Inner Join	PriceType					On	PriceType.Idnty = #DistinctPrices.PriceTypeID
		Inner Join  ProvisionRuleCondition PRC  On PRC.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
WHERE PRC.FromBAID IN (select Id from #BAIdsFrom) AND PRC.ToBAID IN (select Id from #BAIdsTo)
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_SupplyToFSM_Primary]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_Search_SupplyToFSM_Primary.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Search_SupplyToFSM_Primary >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Search_SupplyToFSM_Primary >>>'
	  END    
GO	  


--EXEC [MTV_Search_SupplyToFSM_Primary]

