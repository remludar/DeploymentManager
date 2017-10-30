/****** Object:  StoredProcedure [dbo].[sp_GetDealHeaderTemplateDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_Search_FSM_TransferPrice_UnassignedProdLocs.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_FSM_TransferPrice_UnassignedProdLocs]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Search_FSM_TransferPrice_UnassignedProdLocs] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Search_FSM_TransferPrice_UnassignedProdLocs >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter PROCEDURE [dbo].[MTV_Search_FSM_TransferPrice_UnassignedProdLocs]
								(
								@vc_LocaleIds			Varchar(8000)	= NULL,
								@vc_ProductIds			Varchar(8000)	= NULL,
								@sdt_DateTime			datetime
								)

AS

DECLARE @vc_ProvisionRuleIDs	Varchar(8000)	= NULL,
	@vc_TransferPriceTypes	Varchar(8000)	= 'YT01'
	
  
Create Table #ProvisionRuleIds
(
	ID	Int
)

DECLARE @i_FromBAID Int,
@i_ToBAID int 

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

------------------------------------------------------------------------------------------------
-- Get the price curve configurations
------------------------------------------------------------------------------------------------
Create Table #PriceCurveConfigurationPriceCurveProvision
(
PrceCrveCnfgID int,
Type varchar(2),
ProvisionName varchar(80),
DlDtlPrvsnID int,
PrdctID int,
LcleId int,
DlDtlPRvsnRwTpe varchar(2),
DlDtlPrvsnRwID int,
RplID int
)

Insert #PriceCurveConfigurationPriceCurveProvision
(
PrceCrveCnfgID,
Type,
ProvisionName,
DlDtlPrvsnID,
PrdctID,
LcleId,
DlDtlPrvsnRwID,
RplID
)
Select distinct pcc.PrceCrveCnfgID, 
pcc.Type,
pn.PrvsnDscrptn as ProvisionName, 
pcp.DlDtlPrvsnID,
p.PrdctID as PrdctID,
l.LcleID as LcleID,
ddpr.DlDtlPrvsnRwID,
rpl.RwPrceLcleID
From RawPriceLocale rpl
join RawPriceHeader rph on rpl.RPLcleRPHdrID = rph.RPHdrID
join RawPriceHeaderPriceType rphpt on rphpt.RPHdrPrceTpeRPHdrID = rph.RPHdrID
join PriceTypeRelation ptr on rphpt.RPHdrPrceTpeIdnty = ptr.PrceTpeRltnPrntPrceTpeIdnty
join PriceType pt on ptr.PrceTpeRltnChldPrceTpeIdnty = pt.Idnty
join Product p on p.prdctid = rpl.RPLcleChmclParPrdctID
join Locale l on l.LcleID = rpl.RPLcleLcleID
left join PriceCurveProvisionBasis pcpb on rpl.RwPrceLcleID = pcpb.RwPrceLcleID and pt.Idnty =pcpb.PrceTpeIdnty and pcpb.Type = 'F'
left join PriceCurveConfiguration pcc on pcpb.PrceCrveCnfgID = pcc.PrceCrveCnfgID And pcc.Type = 'F'
left join PriceCurveProvision pcp on pcc.PrceCrveCnfgID = pcp.PrceCrveCnfgID
left join PriceCurveRelation pcr on pcr.PrceCrveCnfgID = pcp.PrceCrveCnfgID
left join PriceQueryRowTemplate pqrt on pqrt.RwPrceLcleID = rpl.RwPrceLcleID
join DealDetailProvisionRow ddpr on ddpr.DlDtlPrvsnID = pcp.DlDtlPrvsnID and DlDtlPRvsnRwTpe = 'F'
join DealDetailProvision ddp on ddp.DlDtlPrvsnID = pcp.DlDtlPrvsnID
join Prvsn pn on pn.PrvsnID = ddp.DlDtlPrvsnPrvsnID
where pcc.Type = 'F'

Create Table #ProdLocBucket
(
Description varchar(80) null,
productid int null,
productabv varchar(80) null,
localeid int null,
localeabv varchar(80) null,
Assigned bit null
)
insert #ProdLocBucket
(
Description,
productid,
productabv,
localeid, 
localeabv,
Assigned 
)
SELECT distinct 	
		'Inhouse ProdLoc' as Description,
		Product.PrdctID as productid,
		Product.PrdctAbbv as productabv,
		Locale.LcleID as localeid,
		Locale.LcleAbbrvtn as localeabv,
		0 as Assigned		
From	#ProvisionRuleProdLocs
		Inner Join	#DealDetailProvisionRows	On	#DealDetailProvisionRows.ProvisionRuleProdLocID = #ProvisionRuleProdLocs.ProvisionRuleProdLocID
		Inner Join	ProvisionRule				On	ProvisionRule.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
		Inner Join	Product						On	Product.PrdctID = #ProvisionRuleProdLocs.PrdctId
		Inner Join	Locale						On	Locale.LcleID = #ProvisionRuleProdLocs.LcleID
union all
Select distinct 'PriceCurve ProdLoc' as Description,
#PriceCurveConfigurationPriceCurveProvision.PrdctID as PrdctID,
(select product.PrdctAbbv from Product where Product.PrdctID =  #PriceCurveConfigurationPriceCurveProvision.PrdctID) as PrdctAbbv,
isnull(#PriceCurveConfigurationPriceCurveProvision.LcleId,0) as LcleID,
isnull((select locale.LcleAbbrvtn from locale where LcleID = #PriceCurveConfigurationPriceCurveProvision.LcleId),'N/A') as LcleAbbrvtn,
0 as Assigned
from #PriceCurveConfigurationPriceCurveProvision 
Order by productid, localeid

update #ProdLocBucket set assigned = 1 where productid in 
(select plb.productid from #ProdLocBucket plb where Description = 'Inhouse ProdLoc' and plb.localeid = localeid ) and
localeid in
(select plb.localeid from #ProdLocBucket plb where Description = 'Inhouse ProdLoc' and plb.productid = productid ) and 
Description = 'PriceCurve ProdLoc'

update #ProdLocBucket set assigned = 1 where productid in 
(select plb.productid from #ProdLocBucket plb where Description = 'PriceCurve ProdLoc' and plb.localeid = localeid ) and
localeid in
(select plb.localeid from #ProdLocBucket plb where Description = 'PriceCurve ProdLoc' and plb.productid = productid ) and 
Description = 'Inhouse ProdLoc'


select 
Description,
productid,
productabv,
localeid, 
localeabv,
Assigned 
from 
#ProdLocBucket
