PRINT 'Start Script=MTV_Search_PortArthur_TransferPrice.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_PortArthur_TransferPrice]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Search_PortArthur_TransferPrice] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Search_PortArthur_TransferPrice >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


/*
execute MTV_Search_SupplyToFSM_Secondary @sdt_DateTime = '2015-03-31 00:00'
*/

ALTER PROCEDURE [dbo].[MTV_Search_PortArthur_TransferPrice]
								(
									@i_FromBAId				Varchar(8000)   = NULL,
									@i_ToBAId				Varchar(8000)	= NULL,
									@i_ProductIds			Varchar(8000)	= NULL,
									@i_LocaleIds			Varchar(8000)	= NULL
								)

AS

-- ==================================================
-- Author:        Joseph McClean
-- Create date:	  8/19/2016
-- Description:   Port Arthur Transfer Pricing Report
-- ====================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--
-----------------------------------------------------------------------------


---------------------------------------------------------------------------------
-- CREATE PROVISION RULE ID TEMP TABLE
---------------------------------------------------------------------------------
--- select the provision rules which are applicable for the particular transfer 
-- insert the provision rule id for rules between the pa

Create Table #BAIds 
(
	 ID INT, 
	 BAName VARCHAR(25)
 )

Create Table #AllBAs
(
	ID INT
)

Create Table #ProvisionRuleIds
(
	ID					Int,
	[Description]		varchar(255),
	FromInternalBAId	Int,
	ToInternalBAId		Int
)


INSERT INTO #AllBAs(ID)
SELECT BAID
FROM BusinessAssociate AS ba 
WHERE ba.BAStts = 'A' AND
ba.Name IN (dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'),
			dbo.GetRegistryValue('MotivaSTLIntrnlBAName'),
			dbo.GetRegistryValue('MotivaPTArthrIntrnlBAName'))


IF	IsNull(LTrim(RTrim(@i_FromBAId)),'') = '' AND IsNull(LTrim(RTrim(@i_ToBAId)),'') = ''
	--IF	@i_FromBAId IS NULL AND @i_ToBAId IS NULL
	BEGIN
	
		--INSERT #BAIds(ID)
		--SELECT BAID
		--FROM BusinessAssociate AS ba 
		--WHERE ba.BAStts = 'A' AND
		--ba.Name IN (dbo.GetRegistryValue('MotivaBaseOilsIntrnlBAName'),
		--			dbo.GetRegistryValue('MotivaSTLIntrnlBAName'),
		--			dbo.GetRegistryValue('MotivaPTArthrIntrnlBAName'))

		Insert	#ProvisionRuleIds 
		Select	PR.ProvisionRuleID, [Description], PRC.FromBAID, PRC.ToBAID
		From	dbo.ProvisionRule PR INNER JOIN ProvisionRuleCondition PRC ON PRC.ProvisionRuleID = PR.ProvisionRuleID
		Where	[Status] = 'A' 
				AND PRC.Exclude = 'N'
				AND PRC.FromBAID In (Select Id from #AllBAs)
				AND PRC.ToBAID In (Select Id From #AllBAs)
	END
ELSE
	BEGIN 
	   --- TODO: REFACTOR THIS WHEN I GET THE CHANCE. THIS IS A QAD FIX.
		IF (@i_FromBAId IS NOT NULL AND @i_ToBAId IS NOT NULL)
		BEGIN
			Insert	#ProvisionRuleIds(ID, Description, FromInternalBAId, ToInternalBAId)
			Select	PR.ProvisionRuleID,  [Description], PRC.FromBAID, PRC.ToBAID
			From	dbo.ProvisionRule PR INNER JOIN ProvisionRuleCondition PRC ON PRC.ProvisionRuleID = PR.ProvisionRuleID
			Where	[Status] = 'A' 
					AND PRC.Exclude = 'N'
					AND PRC.FromBAID = Convert(int, @i_FromBAId)
					AND PRC.ToBAID  = Convert(int, @i_ToBAId)
		END
		ELSE IF (@i_FromBAId IS  NULL AND @i_ToBAId IS NOT NULL)
		BEGIN
			Insert	#ProvisionRuleIds(ID, Description, FromInternalBAId, ToInternalBAId)
			Select	PR.ProvisionRuleID,  [Description], PRC.FromBAID, PRC.ToBAID
			From	dbo.ProvisionRule PR INNER JOIN ProvisionRuleCondition PRC ON PRC.ProvisionRuleID = PR.ProvisionRuleID
			Where	[Status] = 'A' 
					AND PRC.Exclude = 'N'
					AND PRC.FromBAID IN (SELECT ID FROM #AllBAs)
					AND PRC.ToBAID  = Convert(int, @i_ToBAId)
		END
		ELSE IF (@i_FromBAId IS NOT NULL AND @i_ToBAId IS NULL)
		BEGIN
			Insert	#ProvisionRuleIds(ID, Description, FromInternalBAId, ToInternalBAId)
			Select	PR.ProvisionRuleID,  [Description], PRC.FromBAID, PRC.ToBAID
			From	dbo.ProvisionRule PR INNER JOIN ProvisionRuleCondition PRC ON PRC.ProvisionRuleID = PR.ProvisionRuleID
			Where	[Status] = 'A' 
					AND PRC.Exclude = 'N'
					AND PRC.FromBAID =  Convert(int, @i_FromBAId)
					AND PRC.ToBAID  IN (SELECT ID FROM #AllBAs)
		END
END

---------------------------------------------------------------------------------
-- CREATE LOCALE TEMP TABLE
---------------------------------------------------------------------------------
Create Table #Locales
(
	ID Int, 
	LocaleName varchar(255)
)

If	IsNull(LTrim(RTrim(@i_LocaleIds)),'') = ''
Begin
	Insert	#Locales (ID, LocaleName)
	Select	Distinct 
			ProvisionRuleProdLoc.LcleID, NULL
	From	dbo.ProvisionRuleProdLoc
End
Else
Begin
	Insert	#Locales  (ID, LocaleName)
	Select	Convert(Int,Value), NULL
	From	dbo.CreateTableList(@i_LocaleIds) Ids
	Where	IsNumeric(Ids.Value) = 1
End

UPDATE #Locales
SET  LocaleName = LcleAbbrvtn
FROM #Locales INNER JOIN Locale ON Locale.LcleID = #Locales.ID
WHERE (LocaleName is null)


---------------------------------------------------------------------------------
-- CREATE PRODUCTS TEMP TABLE
---------------------------------------------------------------------------------
-- create a temp table to house products from the provision rule prod/loc user inputs. 
-- The '' indicates that all of the provision rule prod locs will be selected. 

Create Table #Products
(
	ID Int
   ,ProductName varchar(255)
)

If	IsNull(LTrim(RTrim(@i_ProductIds)),'') = ''
Begin
	Insert	#Products(ID)
	Select	Distinct 
			ProvisionRuleProdLoc.PrdctID
	From	dbo.ProvisionRuleProdLoc
End
Else
Begin
	Insert	#Products(ID)
	Select	Convert(Int,Value)
	From	dbo.CreateTableList(@i_ProductIds) Ids
	Where	IsNumeric(Ids.Value) = 1
End


UPDATE	#Products
SET		ProductName = PrdctAbbv
FROM	#Products INNER JOIN Product ON Product.PrdctID = #Products.ID
WHERE	(ProductName is null)


------------------------------------------------------------------------------------------------
-- Get the provision rules for the product location combinations
------------------------------------------------------------------------------------------------
-- Get the provision rules for the products and locations selected by the input paramters

Create Table #ProvisionRuleProdLocs
(
	ProvisionRuleProdLocID	Int,
	ProvisionRuleID			Int,
	PrdctID					Int,
	LcleID					Int,
	ProductName				varchar (255),
	LocaleName			    varchar(255)
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

UPDATE #ProvisionRuleProdLocs
SET ProductName = #Products.ProductName , LocaleName = #Locales.LocaleName
FROM #ProvisionRuleProdLocs 
inner join #Products on #Products.ID = #ProvisionRuleProdLocs.PrdctID 
inner join #Locales on #Locales.ID = #ProvisionRuleProdLocs.LcleID


--------------------------------------------------------------------------------------------
-- Get all the provision rows that are secondary costs
--------------------------------------------------------------------------------------------
Create Table #DealDetailProvisionRows
(
	ProvisionRuleProdLocID Int,
	DlDtlPrvsnID	Int,
	DlDtlPrvsnRwID	Int,
	Percentage		Float,
	RwPrceLcleID	Int,
	PricetypeID		SmallInt
   ,PrvsnDesc		varchar(255)
   ,PriceType		varchar(25)
   ,DateRule		varchar(80)
   ,Offset			decimal(10,2)
   ,FrmlaTbltRleID	Int
   ,PrvsnName		varchar(100)
   ,DlDtlPrvsnPrvsnID int
)

--------------------------------------------------------------------------------------------
-- First insert the ones that apply to all prod/locs on the rule. 
-- I chose not to dbo.V_FormulaTablet for performance reasons, but it could be used
----------------------------------------------------------------------------------------------
Insert	#DealDetailProvisionRows
		(
		ProvisionRuleProdLocID,
		DlDtlPrvsnID,
		DlDtlPrvsnRwID,
		Percentage,
		RwPrceLcleID,
		PricetypeID,
		Offset,
		FrmlaTbltRleID)

Select	#ProvisionRuleProdLocs.ProvisionRuleProdLocID,
		ProvisionRuleDlDtlPrvsn.DlDtlPrvsnID,
		DealDetailProvisionRow.DlDtlPrvsnRwID,
		Convert(float,DealDetailProvisionRow.PriceAttribute1),
		Convert(Int, PriceAttribute3),
		Convert(Int, PriceAttribute7),
		Convert(decimal, PriceAttribute2),
		FrmlaTbltRleID

From	#ProvisionRuleProdLocs
		Inner Join dbo.ProvisionRuleDlDtlPrvsn	On	ProvisionRuleDlDtlPrvsn.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
		Inner Join dbo.DealDetailProvision		On	DealDetailProvision.DlDtlPrvsnID = ProvisionRuleDlDtlPrvsn.DlDtlPrvsnID
												And	DealDetailProvision.[Status] = 'A'
												And	(DealDetailProvision.CostType IN ('P' , 'S'))
		Inner Join dbo.DealDetailProvisionRow	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
												AND TRY_CONVERT(float, DealDetailProvisionRow.PriceAttribute1) is not null
												And	TRY_CONVERT(int, DealDetailProvisionRow.PriceAttribute3) is not null
												And	TRY_CONVERT(int, DealDetailProvisionRow.PriceAttribute7) is not null
												AND TRY_CONVERT(decimal, DealDetailProvisionRow.PriceAttribute2) is not null
												AND FrmlaTbltRleID is not null --- this ensures that the provision is from a formula tablet

UPDATE #DealDetailProvisionRows
SET PrvsnDesc = Prvsn.PrvsnDscrptn, DlDtlPrvsnPrvsnID = Prvsn.PrvsnID, PrvsnName = Prvsn.PrvsnNme
FROM #DealDetailProvisionRows	INNER JOIN DealDetailProvision ON DealDetailProvision.DlDtlPrvsnID = #DealDetailProvisionRows.DlDtlPrvsnID
								INNER JOIN Prvsn ON DealDetailProvision.DlDtlPrvsnPrvsnID = Prvsn.PrvsnID


UPDATE #DealDetailProvisionRows
SET PriceType = Pricetype.PrceTpeNme
FROM #DealDetailProvisionRows INNER JOIN Pricetype on Pricetype.Idnty = #DealDetailProvisionRows.PricetypeID

UPDATE #DealDetailProvisionRows
SET DateRule = TabletRule.Name
FROM #DealDetailProvisionRows DDPR INNER JOIN FormulaTabletRule TabletRule ON TabletRule.FrmlaTbltRleID = DDPR.FrmlaTbltRleID

UPDATE #DealDetailProvisionRows
SET PrvsnName = Prvsn.PrvsnNme, DlDtlPrvsnPrvsnID = DDPR.DlDtlPrvsnPrvsnID
FROM #DealDetailProvisionRows DDPR INNER JOIN Prvsn ON Prvsn.PrvsnID = DDPR.DlDtlPrvsnPrvsnID

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
		PricetypeID,
		Offset,
		FrmlaTbltRleID
		)

Select	#ProvisionRuleProdLocs.ProvisionRuleProdLocID,
		ProvisionRuleProdLocDlDtlPrvsn.DlDtlPrvsnID,
		DealDetailProvisionRow.DlDtlPrvsnRwID,
		Convert(float,DealDetailProvisionRow.PriceAttribute1),
		Convert(int,DealDetailProvisionRow.PriceAttribute3),
		Convert(Int, DealDetailProvisionRow.PriceAttribute7),
		Convert(decimal, PriceAttribute2),
		FrmlaTbltRleID
From	#ProvisionRuleProdLocs
		Inner Join dbo.ProvisionRuleProdLocDlDtlPrvsn
												On	ProvisionRuleProdLocDlDtlPrvsn.ProvisionRuleProdLocID = #ProvisionRuleProdLocs.ProvisionRuleProdLocID
		Inner Join dbo.DealDetailProvision		On	DealDetailProvision.DlDtlPrvsnID = ProvisionRuleProdLocDlDtlPrvsn.DlDtlPrvsnID
												And	DealDetailProvision.[Status] = 'A'
												And	(DealDetailProvision.CostType IN ( 'P' , 'S'))
		Inner Join dbo.DealDetailProvisionRow	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
												AND TRY_CONVERT(float, DealDetailProvisionRow.PriceAttribute1) is not null
												And	TRY_CONVERT(int, DealDetailProvisionRow.PriceAttribute3) is not null
												And	TRY_CONVERT(int, DealDetailProvisionRow.PriceAttribute7) is not null
												And	TRY_CONVERT(decimal, DealDetailProvisionRow.PriceAttribute2) is not null
												And FrmlaTbltRleID is not null --- this ensures that the provision is from a formula tablet

UPDATE #DealDetailProvisionRows
SET PrvsnDesc = Prvsn.PrvsnDscrptn, DlDtlPrvsnPrvsnID = Prvsn.PrvsnID, PrvsnName = Prvsn.PrvsnNme
FROM #DealDetailProvisionRows INNER JOIN DealDetailProvision ON DealDetailProvision.DlDtlPrvsnID = #DealDetailProvisionRows.DlDtlPrvsnID
							  INNER JOIN Prvsn ON DealDetailProvision.DlDtlPrvsnPrvsnID = Prvsn.PrvsnID

UPDATE #DealDetailProvisionRows
SET PriceType = Pricetype.PrceTpeNme
FROM #DealDetailProvisionRows INNER JOIN Pricetype on Pricetype.Idnty = #DealDetailProvisionRows.PricetypeID

UPDATE #DealDetailProvisionRows
SET DateRule = TabletRule.Name
FROM #DealDetailProvisionRows DDPR INNER JOIN FormulaTabletRule TabletRule ON TabletRule.FrmlaTbltRleID = DDPR.FrmlaTbltRleID

UPDATE #DealDetailProvisionRows
SET PrvsnName = Prvsn.PrvsnNme, DlDtlPrvsnPrvsnID = DDPR.DlDtlPrvsnPrvsnID
FROM #DealDetailProvisionRows DDPR INNER JOIN Prvsn ON Prvsn.PrvsnID = DDPR.DlDtlPrvsnPrvsnID



-----------------------------------------------------------------------------------------------------
-- Select final data for report temp table
-----------------------------------------------------------------------------------------------------									
--#MTVPtArthurTrnsfrPrices
CREATE TABLE #MTVPtArthurTrnsfrPrices
(
	ID	int primary key identity(1,1),
	FromInternalBAId INT,
	ToInternalBAId INT,
	[Description] VARCHAR(255),
	PrdctAbbv VARCHAR(80),
	LcleAbbrvtn VARCHAR(100),
	PricingDate datetime,
	Percentage float,
	RPHdrAbbv VARCHAR(50),
	CurveName VARCHAR(255),
	PrceTpeNme VARCHAR(50),
	DateRule VARCHAR(100),
	Offset decimal (10,2),
	AllInPrice float NULL,
	PriceStatus VARCHAR(10)  NULL,
	ProductId INT,
	LocaleId  INT,
	DlDtlPrvsnPrvsnID INT,
	ProvisionRuleID INT
	--FromStrategyId INT,
	--ToStrategyId INT
)

INSERT INTO #MTVPtArthurTrnsfrPrices
SELECT		
			#ProvisionRuleIds.FromInternalBAId,
			#ProvisionRuleIds.ToInternalBAId,
			ProvisionRule.[Description],
			Product.PrdctAbbv,
			Locale.LcleAbbrvtn,
			NULL as 'PricingDate',
			#DealDetailProvisionRows.Percentage/100,
			RawPriceHeader.RPHdrAbbv,
			RawPriceLocale.CurveName,
			#DealDetailProvisionRows.PriceType,
			#DealDetailProvisionRows.DateRule,
			#DealDetailProvisionRows.Offset,
			NULL  as 'AllInPrice',
			NULL as 'PriceStatus',
			#ProvisionRuleProdLocs.PrdctID,
			#ProvisionRuleProdLocs.LcleID,
			#DealDetailProvisionRows.DlDtlPrvsnPrvsnID,
			#ProvisionRuleProdLocs.ProvisionRuleID
			--#ProvisionRuleIds.FromStrategyId,
			--#ProvisionRuleIds.ToStrategyId

FROM		#ProvisionRuleProdLocs
			Inner Join	#DealDetailProvisionRows	ON	#DealDetailProvisionRows.ProvisionRuleProdLocID = #ProvisionRuleProdLocs.ProvisionRuleProdLocID
			Inner Join	ProvisionRule				ON	ProvisionRule.ProvisionRuleID = #ProvisionRuleProdLocs.ProvisionRuleID
			Inner Join	Product						ON	Product.PrdctID = #ProvisionRuleProdLocs.PrdctId
			Inner Join	Locale						ON	Locale.LcleID = #ProvisionRuleProdLocs.LcleID
			Inner Join	RawPriceLocale				ON	RawPriceLocale.RwPrceLcleID = #DealDetailProvisionRows.RwPrceLcleID
			Inner Join	RawPriceHeader				ON	RawPriceHeader.RPHdrID = RawPriceLocale.RPLcleRPHdrID
			inner join  #ProvisionRuleIds			ON  #ProvisionRuleIds.ID = ProvisionRule.ProvisionRuleID


UPDATE	#MTVPtArthurTrnsfrPrices
SET		AllInPrice = ABS(PerUnitValue), 
		PricingDate = MaxValueDate, 
		PriceStatus = (CASE WHEN  PricedInPercentage = 1 THEN 'Actual' ELSE  'Estimate'  End)
FROM #MTVPtArthurTrnsfrPrices INNER JOIN 
(
 
 	SELECT	DISTINCT	PT.AliasPrdctID, PT.PhysicalLcleID, SubQry.MaxValueDate, PTV.PricedInPercentage, PTV.PerUnitValue, 	Prvsn.PrvsnNme, 	SubQry.PrvsnID
	FROM				PlannedTransfer PT 
						INNER JOIN PlannedTransferValue PTV ON PT.PlnndTrnsfrID =  PTV.PlnndTrnsfrID 
						--INNER JOIN DealDetailProductLocation DDPL ON DDPL.PrdctID = AliasPrdctID AND DDPL.LcleID = PhysicalLcleID 
						INNER JOIN DealDetailProvision DDP ON DDP.DlDtlPrvsnID = PTV.DlDtlPrvsnID
						INNER JOIN Prvsn ON Prvsn.PrvsnID = DDP.DlDtlPrvsnPrvsnID
				
						INNER JOIN (select	Prvsn.PrvsnID, 
											AliasPrdctID,
											PhysicalLcleID,
											MAX(LastValueDate) as MaxValueDate,
											Prvsn.PrvsnNme 
									from PlannedTransfer PT INNER JOIN PlannedTransferValue PTV ON PT.PlnndTrnsfrID =  PTV.PlnndTrnsfrID 
									--INNER JOIN DealDetailProductLocation DDPL ON DDPL.PrdctID = AliasPrdctID AND DDPL.LcleID = PhysicalLcleID 
									INNER JOIN DealDetailProvision DDP ON DDP.DlDtlPrvsnID = PTV.DlDtlPrvsnID
									INNER JOIN Prvsn ON Prvsn.PrvsnID = DDP.DlDtlPrvsnPrvsnID
									INNER JOIN DealDetailProvisionRow DDPR ON DDPR.DlDtlPrvsnID = DDP.DlDtlPrvsnID
									WHERE DDPR.DlDtlPRvsnRwTpe = 'F'   ---> filter out any provisions that aren't based on formula tablet 
									group by AliasPrdctID, PhysicalLcleID, Prvsn.PrvsnID, Prvsn.PrvsnNme ) SubQry ON SubQry.PrvsnID = Prvsn.PrvsnID AND
																													 SubQry.AliasPrdctID = PT.AliasPrdctID AND 
																													 PT.PhysicalLcleID = SubQry.PhysicalLcleID

    WHERE		PTV.ValueStatus = 'C'  AND MONTH(SubQry.MaxValueDate) = MONTH(getdate())  ------> Get the latest valuation that corresponds to the month the report is being run 

) TransferInfo  ON	TransferInfo.AliasPrdctID = #MTVPtArthurTrnsfrPrices.ProductId AND
					TransferInfo.PhysicalLcleID  = #MTVPtArthurTrnsfrPrices.LocaleId
					AND TransferInfo.PrvsnID = #MTVPtArthurTrnsfrPrices.DlDtlPrvsnPrvsnID
					--AND	dbo.#MTVPtArthurTrnsfrPrices.DlDtlPrvsnPrvsnID = TransferInfo.PrvsnID
 
  
 SELECT	
		ID,
		FromInternalBAId,
		ToInternalBAId,
		[Description],
		PrdctAbbv,
		LcleAbbrvtn,
		PricingDate,
		Percentage,
		RPHdrAbbv,
		CurveName,
		PrceTpeNme,
		DateRule,
		Offset,
		AllInPrice,
		PriceStatus ,
		ProductId,
		LocaleId,
		ProvisionRuleID
FROM	#MTVPtArthurTrnsfrPrices


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_PortArthur_TransferPrice]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_Search_PortArthur_TransferPrice.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Search_PortArthur_TransferPrice >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Search_PortArthur_TransferPrice >>>'
	  END    
GO	  