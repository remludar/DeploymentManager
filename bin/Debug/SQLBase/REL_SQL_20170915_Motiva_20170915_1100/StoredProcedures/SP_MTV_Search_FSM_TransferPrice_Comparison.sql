/****** Object:  StoredProcedure [dbo].[sp_GetDealHeaderTemplateDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_Search_FSM_TransferPrice_Comparison.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_FSM_TransferPrice_Comparison]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Search_FSM_TransferPrice_Comparison] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Search_FSM_TransferPrice_Comparison >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter PROCEDURE [dbo].[MTV_Search_FSM_TransferPrice_Comparison]
								(
								@sdt_DateTime			SmallDateTime = Null,
								@vc_LocaleIds			Varchar(8000)	= NULL,
								@vc_ProductIds			Varchar(8000)	= NULL,
								@ShowMatched			char(1) = null
								)

AS
DECLARE @vc_ProvisionRuleIDs	Varchar(8000)	= NULL,
	@vc_TransferPriceTypes	Varchar(8000)	= 'YT01',
		@i_FromBAID Int,
		@i_ToBAID int,
		@i_PriceType int

SELECT @i_PriceType = RPHdrID FROM dbo.RawPriceHeader (NOLOCK) WHERE RPHdrAbbv = 'Transfer Price'
	
If @sdt_DateTime = Null select @sdt_DateTime = getdate()

SET @sdt_DateTime = dateadd(DAY, -1, @sdt_DateTime)

IF OBJECT_ID(N'tempdb..#ProvisionRuleIds') IS NOT NULL
	drop table #ProvisionRuleIds
IF OBJECT_ID(N'tempdb..#Locales') IS NOT NULL
	drop table #Locales
IF OBJECT_ID(N'tempdb..#Products') IS NOT NULL
	drop table #Products
IF OBJECT_ID(N'tempdb..#ProvisionRuleProdLocs') IS NOT NULL
	drop table #ProvisionRuleProdLocs
IF OBJECT_ID(N'tempdb..#DealDetailProvisionRows') IS NOT NULL
	drop table #DealDetailProvisionRows
IF OBJECT_ID(N'tempdb..#ProvisionRuleIds') IS NOT NULL
	drop table #ProvisionRuleIds
--IF OBJECT_ID(N'tempdb..#TransferPriceTypes') IS NOT NULL
--	drop table #TransferPriceTypes
IF OBJECT_ID(N'tempdb..#PriceCurveConfigurationPriceCurveProvision') IS NOT NULL
	drop table #PriceCurveConfigurationPriceCurveProvision

Create Table #ProvisionRuleIds
(
	ID	Int
)
Select @i_FromBAID = BAID FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND ba.Name =  dbo.GetRegistryValue('MotivaSTLIntrnlBAName')
Select @i_ToBAID = BAID FROM BusinessAssociate AS ba WHERE ba.BAStts = 'A' AND ba.Name = dbo.GetRegistryValue('MotivaFSMIntrnlBAName')


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
			And		ProvisionRuleCondition.FromBAID = @i_FromBAID--- STL
			And		ProvisionRuleCondition.ToBAID = @i_ToBAID ---FSM
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
			And		ProvisionRuleCondition.FromBAID = @i_FromBAID--- STL
			And		ProvisionRuleCondition.ToBAID = @i_ToBAID ---FSM
			And		ProvisionRuleCondition.Exclude = 'N'
			)
End

   
Create Table #Locales
(
	ID Int,
	LcleAbbrvtn varchar(500),
	LcleAbbrvnExtension varchar(800)
)

If	IsNull(LTrim(RTrim(@vc_LocaleIds)),'') = ''
Begin
	Insert	#Locales
	Select	Distinct 
			ProvisionRuleProdLoc.LcleID,
			L.LcleAbbrvtn,
			L.LcleAbbrvtnExtension
	From	dbo.ProvisionRuleProdLoc
	join Locale L on l.LcleID = ProvisionRuleProdLoc.LcleID
End
Else
Begin
	Insert	#Locales
	Select	Convert(Int,Value),
	L.LcleAbbrvtn,
	L.LcleAbbrvtnExtension
	From	dbo.CreateTableList(@vc_LocaleIds) Ids
	join Locale L on l.LcleID = Ids.Value
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

--Create Table #TransferPriceTypes
--(
--	ID Varchar(4)
--)

----------------------------------------------------------------------------------------------------
-- Not sure what the attribute will be named that is going to be on the RawPriceLocale to specify
-- YT2 to YT10, or if it will be in dynamic list box.  I put it in dynamic list box.
----------------------------------------------------------------------------------------------------

--If	IsNull(LTrim(RTrim(@vc_TransferPriceTypes)),'') = ''
--Begin
--	Insert	#TransferPriceTypes
--	Select	DynLstBxTyp
--	From	dbo.DynamicListBox
--	Where	DynLstBxQlfr = 'TransferPriceType' AND DynLstBxTblTyp IN ('YT01')
--End
--Else
--Begin
--	Insert	#TransferPriceTypes
--	Select	Convert(Varchar(4),Value)
--	From	dbo.CreateTableList(@vc_TransferPriceTypes) Ids
--End

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

Create Table #DealDetailProvisionRows
(
	ProvisionRuleID INT,
	ProvisionRuleProdLocID INT,
	LcleID INT,
	PrdctID INT,
	PrvsnID INT,
	DlDtlPrvsnRwID INT,
	Percentage		Float,
	RwPrceLcleID	Int,
	PricetypeID		SMALLINT,
	ToPrdctID INT,
	ToLcleID INT
)

INSERT INTO #DealDetailProvisionRows
SELECT	prpl.ProvisionRuleID,
		prpl.ProvisionRuleProdLocID,
		prpl.LcleID,
		prpl.ChdPrdctID,
		ddp.DlDtlPrvsnPrvsnID PrvsnID,
		v.DlDtlPrvsnRwID,
		v.PercentOfTotal,
		v.RwPrceLcleID,
		v.PrceTpeIdnty,
		NULL,
		NULL
FROM ProvisionRuleProdLoc prpl (NOLOCK)
INNER JOIN #ProvisionRuleIds pr (NOLOCK) ON pr.ID = prpl.ProvisionRuleID
LEFT OUTER JOIN dbo.ProvisionRuleProdLocDlDtlPrvsn plp (NOLOCK)
ON plp.ProvisionRuleProdLocID = prpl.ProvisionRuleProdLocID
AND	GETDATE() Between plp.StartDate And plp.EndDate
LEFT OUTER JOIN dbo.DealDetailProvision ddp (NOLOCK) ON ddp.DlDtlPrvsnID = plp.DlDtlPrvsnID AND ddp.Status = 'A'
LEFT OUTER JOIN dbo.V_FormulaTablet v (NOLOCK) on v.DlDtlPrvsnID = ddp.DlDtlPrvsnID
INNER JOIN #locales l
ON l.ID = prpl.LcleID
INNER JOIN #products p
ON p.ID = prpl.ChdPrdctID

INSERT INTO #DealDetailProvisionRows
SELECT DISTINCT dpr.ProvisionRuleID,dpr.ProvisionRuleProdLocID,dpr.LcleID,dpr.PrdctID,
	p.PrvsnID,p.DlDtlPrvsnRwID,p.PercentOfTotal,p.RwPrceLcleID,p.PrceTpeIdnty,NULL,NULL
FROM (
	SELECT	prpl.ProvisionRuleID,prpl.ProvisionRuleProdLocID,
			prpl.LcleID,prpl.PrdctID,
			ddp.DlDtlPrvsnPrvsnID PrvsnID,
			v.DlDtlPrvsnRwID,v.PercentOfTotal,
			v.RwPrceLcleID,v.PrceTpeIdnty
	FROM ProvisionRuleProdLoc prpl (NOLOCK)
	INNER JOIN #ProvisionRuleIds pr (NOLOCK) ON pr.ID = prpl.ProvisionRuleID
	INNER JOIN dbo.ProvisionRuleDlDtlPrvsn prdp	(NOLOCK) ON	prdp.ProvisionRuleID = prpl.ProvisionRuleID
	INNER JOIN dbo.DealDetailProvision ddp (NOLOCK)
	ON ddp.DlDtlPrvsnID = prdp.DlDtlPrvsnID
	AND	ddp.Status = 'A'
	AND	ddp.CostType = 'P'
	INNER JOIN dbo.V_FormulaTablet v (NOLOCK) ON v.DlDtlPrvsnID = prdp.DlDtlPrvsnID
	INNER JOIN #locales l
	ON l.ID = prpl.LcleID
	INNER JOIN #products p
	ON p.ID = prpl.ChdPrdctID
) p
INNER JOIN #DealDetailProvisionRows dpr (NOLOCK)
ON dpr.ProvisionRuleID = p.ProvisionRuleID
AND dpr.ProvisionRuleProdLocID = p.ProvisionRuleProdLocID
AND dpr.LcleID = p.lcleID
AND dpr.PrdctID = p.PrdctID

--No longer need this placeholder since the cross join has been completed.
DELETE FROM #DealDetailProvisionRows WHERE PrvsnID IS NULL

UPDATE dpr SET dpr.ToPrdctID = rpl.RPLcleChmclParPrdctID,dpr.ToLcleID = rpl.RPLcleLcleID
FROM #DealDetailProvisionRows dpr
INNER JOIN RawPriceLocale rpl
ON dpr.RwPrceLcleID = rpl.RwPrceLcleID

CREATE TABLE #PriceCurveConfigurationPriceCurveProvision
(
	PrceCrveCnfgID INT,
	Type VARCHAR(2),
	ProvisionName VARCHAR(80),
	PriceCrvDesc VARCHAR(80),
	DlDtlPrvsnID INT,
	IsRuleOrCurve VARCHAR(2),
	Percentage FLOAT,
	PrdctID INT,
	LcleId INT,
	DlDtlPRvsnRwTpe VARCHAR(2),
	RwPrceLcleID INT,
	CurveName VARCHAR(500),
	DlDtlPrvsnRwID INT,
	ToPrdctID INT,
	ToLcleID INT
)

Insert #PriceCurveConfigurationPriceCurveProvision
(
PrceCrveCnfgID,
Type,
ProvisionName,
PriceCrvDesc,
DlDtlPrvsnID,
IsRuleOrCurve,
Percentage,
PrdctID,
LcleId,
DlDtlPRvsnRwTpe,
RwPrceLcleID,
CurveName,
DlDtlPrvsnRwID,
ToPrdctID,
ToLcleID
)
SELECT DISTINCT pcc.PrceCrveCnfgID, 
	pcc.Type,
	prv.PrvsnDscrptn as ProvisionName, 
	pcc.Description as PriceCrvDesc, 
	pcp.DlDtlPrvsnID,
	'C' as IsRuleOrCurve,
	(CASE When ISNUMERIC(ddpr.PriceAttribute1) = 1 and Convert(float,ddpr.PriceAttribute1) <= 100 then Convert(float,ddpr.PriceAttribute1) else 0 END) as Percentage,
	rpl.RPLcleChmclParPrdctID as PrdctID,
	rpl.RPLcleLcleID as LcleID,
	 ddpr.DlDtlPRvsnRwTpe,
	 rpl.RwPrceLcleID,
	 frm.CurveName,
	 ddpr.DlDtlPrvsnRwID,
	 frm.RPLcleChmclParPrdctID as ToPrdctID,
	frm.RPLcleLcleID as ToLcleID
FROM PriceCurveConfiguration pcc (NOLOCK)
INNER JOIN PriceCurveProvisionBasis pcb
ON pcb.PrceCrveCnfgID = pcc.PrceCrveCnfgID
INNER JOIN RawPriceLocale rpl
ON rpl.RwPrceLcleID = pcb.RwPrceLcleID
AND rpl.RPLcleRPHdrID = @i_PriceType
inner join PriceCurveProvision pcp on pcc.PrceCrveCnfgID = pcp.PrceCrveCnfgID
join DealDetailProvision ddp on ddp.DlDtlPrvsnID = pcp.DlDtlPrvsnID
join Prvsn prv on prv.PrvsnID = ddp.DlDtlPrvsnPrvsnID
INNER JOIN V_FormulaTablet v on v.DlDtlPrvsnID = ddp.DlDtlPrvsnID
join DealDetailProvisionRow ddpr on ddpr.DlDtlPrvsnRwID = v.DlDtlPrvsnRwID
INNER JOIN RawPriceLocale frm (NOLOCK)
ON frm.RwPrceLcleID = CASE WHEN ISNUMERIC(ddpr.PriceAttribute3) = 0 THEN -1 ELSE CONVERT(INT, CONVERT(FLOAT,ddpr.PriceAttribute3)) END
INNER JOIN #locales l
ON l.ID = rpl.RPLcleLcleID
INNER JOIN #products p
ON p.ID = rpl.RPLcleChmclParPrdctID


SELECT pcp.PriceCrvDesc CurveConfiguration,
	CONCAT((CASE WHEN pcp.Percentage >= 0 THEN '+ ' END),pcp.Percentage,'% ', pcp.CurveName) AS [Estimated Transfer Price],
	CASE WHEN (dpr.Percentage IS NULL OR dpr.RwPrceLcleID IS NULL) THEN '!Error!' ELSE CONCAT((CASE WHEN dpr.Percentage >= 0 THEN '+ ' END),dpr.Percentage,'% ',rpl.CurveName) END AS [Actual Transfer Price],
	ISNULL(pr.Description,'N/A') as InhouseDescription,
	CASE WHEN (concat(g.GnrlCnfgMulti,' : ', l.LcleAbbrvtn,l.LcleAbbrvtnExtension)) = ' : ' THEN (CONCAT(l.LcleNme, l.LcleNmeExtension)) 
	ELSE CONCAT(g.GnrlCnfgMulti,' : ', l.LcleAbbrvtn,l.LcleAbbrvtnExtension) END AS InhouseLocation,
	p.PrdctAbbv AS InhouseProduct,
	ISNull(prv.PrvsnDscrptn,pcp.ProvisionName) as ProvisionName,
	g.GnrlCnfgMulti as PlantCode,
	pcp.DlDtlPrvsnID as DlDtlPrvsnID,
	CASE WHEN prv.PrvsnDscrptn IS NULL THEN 'C' ELSE 'R' END AS IsRuleOrCurve,
	ISNULL(ISNULL(dpr.Percentage,pcp.Percentage),0) as Percentage,
	dpr.ProvisionRuleID as ProvisionRuleID,
	ISNULL(dpr.PrdctID,pcp.PrdctID) as PrdctID,
	ISNULL(dpr.LcleID,pcp.LcleId) as LcleID,
	CASE WHEN dpr.PrdctID IS NULL THEN 0 ELSE 1 END as IsMatched
FROM #PriceCurveConfigurationPriceCurveProvision pcp
INNER JOIN dbo.locale l ON l.lcleid = pcp.lcleid
INNER JOIN dbo.product p ON p.PrdctID = pcp.PrdctID
LEFT OUTER JOIN #DealDetailProvisionRows dpr
INNER JOIN RawPriceLocale rpl ON rpl.RwPrceLcleID = dpr.RwPrceLcleID
ON dpr.PrdctID = pcp.PrdctID
AND dpr.lcleID = pcp.lcleID
AND dpr.Percentage = pcp.Percentage
AND dpr.ToPrdctID = pcp.ToPrdctID
AND dpr.ToLcleID = pcp.ToLcleID
LEFT OUTER JOIN dbo.ProvisionRule pr (NOLOCK) ON dpr.ProvisionRuleID = pr.ProvisionRuleID
LEFT OUTER JOIN dbo.GeneralConfiguration g (NOLOCK) ON g.GnrlCnfgTblNme = 'Locale' AND G.GnrlCnfgQlfr = 'SAPPlantCode' AND g.GnrlCnfgHdrID = pcp.lcleID
LEFT OUTER JOIN dbo.prvsn prv (NOLOCK) ON prv.PrvsnID = dpr.PrvsnID
WHERE ISNULL(dpr.PrdctID,-100) = CASE ISNULL(@ShowMatched,'X') WHEN  'Y' THEN dpr.PrdctID WHEN 'N' THEN -100 ELSE ISNULL(dpr.PrdctID,-100) END

GO


