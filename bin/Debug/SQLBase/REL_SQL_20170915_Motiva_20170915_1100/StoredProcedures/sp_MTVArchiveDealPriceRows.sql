
/****** Object:  StoredProcedure [dbo].[MTVArchiveDealPriceRows]    Script Date: 12/28/2016 2:41:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[MTVArchiveDealPriceRows] @PrvsnRowID INT
AS
SET NOCOUNT ON
-- ==========================================================================================
-- Author:		Alan Oldfield
-- Create date: July 7, 2016
-- Description:	Correct the billing term on erroneous FedTax invoices
-- ==========================================================================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--01-09-2017     Craig Albright 3690	Custom Pricing Text
--06-28-2017	Alan Oldfield			Added Custom Event DeemedDate and EventReference to the Archiving
-----------------------------------------------------------------------------
DECLARE @MaxRevisionID INT,@CurrentChangeCheckSum INT,@SecondaryChangeCheckSum INT,@CostType CHAR(1)
SET ANSI_WARNINGS OFF

DECLARE @DeemedDate VARCHAR(80),@EventReference VARCHAR(80),@EventSQL NVARCHAR(2000)

--If provision uses the dynamic code for setting the rule then get the attribute name that we will get the values from the DealDetailProvisionRow
SELECT @EventSQL = 'SELECT @DeemedDate = ' + ISNULL(dd.ColumnName,'NULL') + ',@EventReference = ' + ISNULL(er.ColumnName,'NULL') + ' FROM dbo.DealDetailProvisionRow WHERE DlDtlPrvsnRwID = ' + CAST(r.DlDtlPrvsnRwID AS VARCHAR)
FROM dbo.DealDetailProvisionRow r (NOLOCK)
INNER JOIN dbo.DealDetailProvision ddp (NOLOCK)
ON ddp.DlDtlPrvsnID = r.DlDtlPrvsnID
AND r.DlDtlPrvsnRwID = @PrvsnRowID
LEFT OUTER JOIN dbo.VrblePrvsn dd ON dd.VrblePrvsnPrvsnID = ddp.DlDtlPrvsnPrvsnID AND dd.VariableDescription = 'Deemed Date'
LEFT OUTER JOIN dbo.VrblePrvsn er ON er.VrblePrvsnPrvsnID = ddp.DlDtlPrvsnPrvsnID AND er.VariableDescription = 'Event Reference'
WHERE (dd.ColumnName IS NOT NULL OR er.ColumnName IS NOT NULL)

IF (@@ROWCOUNT > 0)
BEGIN
	EXEC sp_executesql @EventSQL, N'@DeemedDate VARCHAR(80) OUTPUT,@EventReference VARCHAR(80) OUTPUT', @DeemedDate OUTPUT,@EventReference OUTPUT
	SELECT @DeemedDate = NULL WHERE ISDATE(@DeemedDate) = 0
	SELECT @EventReference = NULL WHERE ISNUMERIC(@EventReference) = 0
END

--IF OBJECT_ID('tempdb..#ChangeRow') IS NOT NULL 	DROP TABLE #changeRow
--Changerowtemp
CREATE TABLE  #ChangeRow (
		PrvsnRwID INT NOT NULL,
		PrvsnID INT NOT NULL,
		CostType CHAR(1) NOT NULL,
		RowNumber INT NOT NULL,
		DlHdrID INT,
		DlDtlID INT,
		RowText VARCHAR(5000),
		Differential FLOAT,
		PrceTpeIdnty INT,
		RPHdrID INT,
		Actual CHAR(1),
		FixedValue FLOAT,
		DeemedDates VARCHAR(1000),
		RuleName VARCHAR(80),
		RuleDescription VARCHAR(1000),
		HolidayOption INT,
		HolidayOptionName VARCHAR(19),
		SaturdayOption INT,
		SaturdayOptionName VARCHAR(19),
		SundayOption INT,
		SundayOptionName VARCHAR(19),
		CurveName VARCHAR(500),
		LcleID INT,
		CrrncyID SMALLINT,
		comment VARCHAR(255),
		RevisionDate DATETIME NOT NULL,
		RevisionUserID INT NOT NULL,
		EventReference INT NULL
)
--insert
INSERT INTO #ChangeRow
SELECT 	r.DlDtlPrvsnRwID,
		ddp.DlDtlPrvsnPrvsnID,
		ddp.CostType,
		r.RowNumber,
		ddp.DlDtlPrvsnDlDtlDlHdrID,
		ddp.DlDtlPrvsnDlDtlID,
		r.RowText,
		frmtblt.Offset Differential,
		frmtblt.PrceTpeIdnty FormulatPriceType,
		frmtblt.RPHdrID PriceService,
		ddp.Actual ProvisionUsage,
		CAST(CASE WHEN f.DlDtlPrvsnRwID IS NULL AND TRY_CONVERT(FLOAT,r.PriceAttribute1) IS NOT NULL THEN r.PriceAttribute1 ELSE NULL END AS FLOAT) FixedValue,
		CASE ISNULL(frmtblt.DeemedDates,'') WHEN '' THEN @DeemedDate ELSE frmtblt.DeemedDates END,
		frmtblt.RuleName,
		frmtblt.RuleDescription,
		frmtblt.HolidayOption,
		frmtblt.HolidayOptionName,
		frmtblt.SaturdayOption,
		frmtblt.SaturdayOptionName,
		frmtblt.SundayOption,
		frmtblt.SundayOptionName,
		rpl.CurveName,
		frmtblt.LcleID,
		ddp.CrrncyID,
		r.comment,
		r.RevisionDate,
		r.RevisionUserID,
		CAST(@EventReference AS INT)
FROM dbo.DealDetailProvisionRow r (NOLOCK)
INNER JOIN dbo.DealDetailProvision ddp (NOLOCK)
ON ddp.DlDtlPrvsnID = r.DlDtlPrvsnID
AND r.DlDtlPrvsnRwID = @PrvsnRowID
LEFT OUTER JOIN dbo.DealDetailProvisionRow f (NOLOCK)
INNER JOIN dbo.V_FormulaTablet frmtblt (NOLOCK)
ON frmtblt.DlDtlPrvsnRwID = f.DlDtlPrvsnRwID
ON f.DlDtlPrvsnID = r.DlDtlPrvsnID
AND f.DlDtlPrvsnRwID = (SELECT MIN(DlDtlPrvsnRwID) FROM dbo.DealDetailProvisionRow (NOLOCK) WHERE DlDtlPrvsnID = r.DlDtlPrvsnID AND DlDtlPRvsnRwTpe = 'F')
LEFT OUTER JOIN dbo.RawPriceLocale rpl (NOLOCK)
ON rpl.RPLcleRPHdrID = frmtblt.RPHdrID
AND rpl.RPLcleLcleID = frmtblt.LcleID
AND rpl.RPLcleChmclParPrdctID =  frmtblt.PrdctID

--EFP Pricing Language Rowtext Update
IF ((
	SELECT COUNT(1)
	FROM #ChangeRow c
	INNER JOIN dbo.DealHeader dh (NOLOCK)
	ON dh.DlHdrID = c.DlHdrID
	INNER JOIN dbo.EntityTemplate et
	ON et.EntityTemplateID = dh.EntityTemplateID 
	AND et.TemplateName LIKE '%EFP%'
) > 0)
BEGIN

--if OBJECT_ID('tempdb..#ChangeRowVariables') is not null drop table #ChangeRowVariables
--temp table to populate pricing text
CREATE TABLE #ChangeRowVariables
(
	PrvsnRwID int not null,
	PrvsnID int not null,
	CostType char(1) not null,
	RowNumber int Not Null,
	RowTextType varchar(2) null,
	RowText varchar(5000) null,
	PriceService varchar(256) null,
	PriceMonth varchar(50) null,
	ContractMonthYear varchar(50) null,
	ContractMonth varchar(50) null,
	Product varchar(80) null,
	PriceServiceProduct varchar(256) null,
	DealDetailPrvsnID int null,
	DealDetailID int null,
	DealHeaderId int null,
	fullprice float null,
	basisprice float null,
	baseprice float null,
	diff float null,
	locale int null,
	settlementDate smalldatetime null
)

INSERT #ChangeRowVariables (PrvsnRwID,PrvsnID,CostType,RowNumber)
SELECT PrvsnRwID,PrvsnID,CostType,RowNumber FROM #ChangeRow

update #ChangeRowVariables set DealDetailPrvsnID = (select ddpr.DlDtlPrvsnID from DealDetailProvisionRow ddpr 
where ddpr.DlDtlPrvsnRwID = #ChangeRowVariables.PrvsnRwID and ddpr.DlDtlPRvsnRwTpe = 'A')

update #ChangeRowVariables set DealDetailID = (select ddp.DlDtlPrvsnDlDtlID from DealDetailProvision ddp 
where ddp.DlDtlPrvsnID = #ChangeRowVariables.DealDetailPrvsnID)

update #ChangeRowVariables set DealHeaderId = (Select  ddp.DlDtlPrvsnDlDtlDlHdrID from DealDetailProvision ddp 
where ddp.DlDtlPrvsnID = #ChangeRowVariables.DealDetailPrvsnID 
and ddp.DlDtlPrvsnDlDtlDlHdrID is not null)

update #ChangeRowVariables set RowTextType = ((select ddpr.PriceAttribute11 from DealDetailProvisionRow ddpr
join DealDetailProvision ddp on ddp.DlDtlPrvsnID = ddpr.DlDtlPrvsnID
join DealDetail dd on dd.DlDtlID = ddp.DlDtlPrvsnDlDtlID and dd.DlDtlDlHdrID = ddp.DlDtlPrvsnDlDtlDlHdrID
join DealHEader dh on dh.dlhdrid = ddp.DlDtlPrvsnDlDtlDlHdrID
where ddpr.PriceAttribute11 in ('F', 'D') and ddpr.DlDtlPRvsnRwTpeID = 95 and ddpr.DlDtlPrvsnID = #ChangeRowVariables.DealDetailPrvsnID ))

update #ChangeRowVariables set diff = ((select ddpr.PriceAttribute1 from DealDetailProvisionRow ddpr
join DealDetailProvision ddp on ddp.DlDtlPrvsnID = ddpr.DlDtlPrvsnID
join DealDetail dd on dd.DlDtlID = ddp.DlDtlPrvsnDlDtlID and dd.DlDtlDlHdrID = ddp.DlDtlPrvsnDlDtlDlHdrID
join DealHEader dh on dh.dlhdrid = ddp.DlDtlPrvsnDlDtlDlHdrID
where ddpr.PriceAttribute11 in ('F', 'D') and dd.Dldtlid = #ChangeRowVariables.DealDetailID 
and dd.DlDtlDlHdrID = #ChangeRowVariables.DealHeaderId))

update #ChangeRowVariables set diff = 0 where diff is null

UPDATE #ChangeRowVariables SET baseprice = ((SELECT MIN(ddpr.PriceAttribute8) FROM DealDetailProvisionRow ddpr
join DealDetailProvision ddp on ddp.DlDtlPrvsnID = ddpr.DlDtlPrvsnID
join DealDetail dd on dd.DlDtlID = ddp.DlDtlPrvsnDlDtlID and dd.DlDtlDlHdrID = ddp.DlDtlPrvsnDlDtlDlHdrID
join DealHEader dh on dh.dlhdrid = ddp.DlDtlPrvsnDlDtlDlHdrID
join DealDetailPrvsnAttribute ddpa on ddpa.DlDtlPnAttrDlDtlPnDlDtlDlHdrID = dh.DlHdrID and ddpa.DlDtlPnAttrDlDtlPnDlDtlID = dd.DlDtlID
join PrvsnAttributeType pat on ddpa.DlDtlPnAttrPrvsnAttrTpeID = pat.PrvsnAttrTpeID
where dd.DlDtlDlHdrID = #ChangeRowVariables.DealHeaderId and ddpr.DlDtlPrvsnRwID = #ChangeRowVariables.PrvsnRwID))

UPDATE #ChangeRowVariables SET baseprice = 0 WHERE baseprice is null

UPDATE #ChangeRowVariables SET fullprice = ((
select  ddpr.PriceAttribute2 from DealDetailProvisionRow ddpr
join DealDetailProvision ddp on ddp.DlDtlPrvsnID = ddpr.DlDtlPrvsnID
join DealDetail dd on dd.DlDtlID = ddp.DlDtlPrvsnDlDtlID and dd.DlDtlDlHdrID = ddp.DlDtlPrvsnDlDtlDlHdrID
join DealHEader dh on dh.dlhdrid = ddp.DlDtlPrvsnDlDtlDlHdrID
join DealDetailPrvsnAttribute ddpa on ddpa.DlDtlPnAttrDlDtlPnDlDtlDlHdrID = dh.DlHdrID and ddpa.DlDtlPnAttrDlDtlPnDlDtlID = dd.DlDtlID
join PrvsnAttributeType pat on ddpa.DlDtlPnAttrPrvsnAttrTpeID = pat.PrvsnAttrTpeID
where dd.DlDtlDlHdrID = #ChangeRowVariables.DealHeaderId and pat.PrvsnAttrTpeNme = 'FutureType' and ddpr.PriceAttribute2 is not null and priceAttribute12 = 'FIX'))

-- do we need this?
UPDATE #ChangeRowVariables SET fullprice = 0 where fullprice is null
UPDATE #ChangeRowVariables SET diff = fullprice - baseprice where diff = 0 and RowTextType = 'F'
UPDATE #ChangeRowVariables SET basisprice = diff where basisprice is null

UPDATE #ChangeRowVariables SET settlementDate = (select g.GnrlCnfgMulti from GeneralConfiguration g where g.GnrlCnfgTblNme = 'DealDetail' 
and g.GnrlCnfgQlfr = 'PricingDate' and GnrlCnfgHdrID = #ChangeRowVariables.DealHeaderId and g.GnrlCnfgDtlID = 1)

Declare @replaceTextFixed varchar(5000) = 
'The Cash price shall be USD {baseprice} per Gallon. The agreed Cash price of USD ${baseprice} per Gallon was derived by using the agreed to {ContractMonthYear} {PriceServiceProduct} contract price of USD ${fullprice} and a basis of {sign} USD ${basisprice} per Gal. The above part of an EFP in accordance with the rules and regulations of NYMEX as outlined for such transactions, whereby Seller shall receive from Buyer a number of {ContractMonthYear} {PriceServiceProduct} contracts equal to the physical quantity rounded to the nearest 1,000 barrels. The EFP shall be priced and posted prior to the last trading date of the {ContractMonthYear} Contract. Any imbalance between the quantity against which the EFP is posted and the physical quantity shall, notwithstanding the above, be settled in favor of the over-delivering party (futures or physical as applicable) by an additional EFP of {ContractMonthYear} {PriceServiceProduct} contracts. If the {ContractMonthYear} {PriceService} Contract has expired the parties shall post an additional EFP and the spread differential for the additional EFP shall be equal to the average of the differences between the settlement prices of the {ContractMonthYear} and {ContractMonthYear+1} {PriceServiceProduct} Contracts on the first three of the last four {Priceservice} trading days of {ContractMonthYear}.'

UPDATE #ChangeRowVariables SET RowText = @replaceTextFixed where RowTextType = 'F'

Declare @replaceTextDifferential varchar(5000) = 'Both parties shall mutually agree to the EFP posting price {nonplussed} ${pricedifferential} per Gallon. The Cash price shall be equal to the {ContractMonthYear} {PriceServiceProduct} contract price {sign} USD ${pricedifferential} per Gallon. Based upon {PriceMonth} {product} settlement price on {settlementpricedate}. The above is part of an EFP in accordance with the rules and regulations of NYMEX as outlined for such transactions, whereby Seller shall receive from Buyer a number of {ContractMonthYear} {PriceServiceProduct} Contracts equal to the physical quantity rounded to the nearest 1,000 barrels. The EFP shall be priced and posted prior to the last trading date of the {ContractMonthYear} Contract. Based upon {Month} {product} settlement price on {settlementpricedate}. Any imbalance between the quantity against which the EFP is posted and the physical quantity shall, notwithstanding the above, be settled in favor of the over-delivering party (futures or physical as applicable) by an additional EFP of {ContractMonthYear} {PriceServiceProduct} contracts. If the {ContractMonthYear} {PriceService} Contract has expired the parties shall post an additional EFP and the spread differential for the additional EFP shall be equal to the average of the differences between the settlement prices of the {ContractMonthYear} and {ContractMonthYear+1} {PriceServiceProduct} Contracts on the first three of the last four {Priceservice} trading days of {ContractMonthYear}.'
UPDATE #ChangeRowVariables SET RowText = @replaceTextDifferential where RowTextType = 'D'

UPDATE #ChangeRowVariables SET locale = (select v.LcleID from V_FormulaTablet v where v.DlDtlPrvsnRwID = (SELECT MIN(DlDtlPrvsnRwID) 
FROM dbo.DealDetailProvisionRow (NOLOCK) WHERE DlDtlPrvsnID = #ChangeRowVariables.DealDetailPrvsnID AND DlDtlPRvsnRwTpe = 'F'))

UPDATE #ChangeRowVariables SET PriceService = (select rph.rphdrnme from RawPriceHeader rph join V_FormulaTablet v on v.RPHdrID = rph.RPHdrID 
where v.DlDtlPrvsnRwID = (SELECT MIN(DlDtlPrvsnRwID) 
FROM dbo.DealDetailProvisionRow (NOLOCK) WHERE DlDtlPrvsnID = #ChangeRowVariables.DealDetailPrvsnID AND DlDtlPRvsnRwTpe = 'F'))
--Differential
UPDATE #ChangeRowVariables SET PriceServiceProduct = case when #ChangeRowVariables.RowTextType = 'D' then(select min (rpl.CurveName) from DealDetailProvisionRow ddpr
join DealDetailProvision ddp on ddp.DlDtlPrvsnID = ddpr.DlDtlPrvsnID
join V_FormulaTablet v on ddp.DlDtlPrvsnID = v.DlDtlPrvsnID and v.DlDtlPrvsnRwID = ddpr.DlDtlPrvsnRwID
join RawPriceLocale rpl on rpl.RwPrceLcleID = v.RwPrceLcleID
join dealdetail dd on dd.DlDtlID = ddp.DlDtlPrvsnDlDtlID and dd.DlDtlDlHdrID = ddp.DlDtlPrvsnDlDtlDlHdrID
join dealheader dh on dh.dlhdrid = dd.DlDtlDlHdrID
join DealDetailPrvsnAttribute ddpa on ddpa.DlDtlPnAttrDlDtlPnDlDtlDlHdrID = dh.DlHdrID and ddpa.DlDtlPnAttrDlDtlPnDlDtlID = dd.DlDtlID
join PrvsnAttributeType pat on ddpa.DlDtlPnAttrPrvsnAttrTpeID = pat.PrvsnAttrTpeID
where dh.DlHdrID = #ChangeRowVariables.DealHeaderId and PriceAttribute3 is not null and ddpr.DlDtlPRvsnRwTpe = 'F' and pat.PrvsnAttrTpeNme = 'FutureType'
) end

--Fixed
UPDATE #ChangeRowVariables SET PriceServiceProduct =  CONCAT((select min(rphdrnme) from rawpriceheader where rphdrid = (select Min(rpl.RPLcleRPHdrID) from DealDetailProvisionRow ddpr
join DealDetailProvision ddp on ddp.DlDtlPrvsnID = ddpr.DlDtlPrvsnID
join V_FormulaTablet v on ddp.DlDtlPrvsnID = v.DlDtlPrvsnID and v.DlDtlPrvsnRwID = ddpr.DlDtlPrvsnRwID
join RawPriceLocale rpl on rpl.RwPrceLcleID = v.RwPrceLcleID
join dealdetail dd on dd.DlDtlID = ddp.DlDtlPrvsnDlDtlID and dd.DlDtlDlHdrID = ddp.DlDtlPrvsnDlDtlDlHdrID
join dealheader dh on dh.dlhdrid = dd.DlDtlDlHdrID
join DealDetailPrvsnAttribute ddpa on ddpa.DlDtlPnAttrDlDtlPnDlDtlDlHdrID = dh.DlHdrID and ddpa.DlDtlPnAttrDlDtlPnDlDtlID = dd.DlDtlID
join PrvsnAttributeType pat on ddpa.DlDtlPnAttrPrvsnAttrTpeID = pat.PrvsnAttrTpeID
where dh.DlHdrID = #ChangeRowVariables.DealHeaderId and PriceAttribute3 is not null and ddpr.DlDtlPRvsnRwTpe = 'F')),' ',(select Top 1 (FutureSymbol) from dealheader dh
join dealdetail dd on dh.DlHdrID = dd.DlDtlDlHdrID
join dealdetailprovision ddp on ddp.DlDtlPrvsnDlDtlDlHdrID = dh.dlhdrid
join dealdetailprovisionrow ddpr on ddpr.DlDtlPrvsnID = ddp.DlDtlPrvsnID
join rawpricelocale rpl on ddpr.priceattribute3 = rpl.RwPrceLcleID
join product p on p.PrdctID = rpl.RPLcleChmclParPrdctID 
where dh.DlHdrID = #ChangeRowVariables.DealHeaderId and DlDtlPRvsnRwTpe = 'F'))  

--Product
UPDATE #ChangeRowVariables SET Product = (
	SELECT TOP 1 (FutureSymbol) from dealheader dh
	join dealdetail dd on dh.DlHdrID = dd.DlDtlDlHdrID
	join dealdetailprovision ddp on ddp.DlDtlPrvsnDlDtlDlHdrID = dh.dlhdrid
	join dealdetailprovisionrow ddpr on ddpr.DlDtlPrvsnID = ddp.DlDtlPrvsnID
	join rawpricelocale rpl on ddpr.priceattribute3 = rpl.RwPrceLcleID
	join product p on p.PrdctID = rpl.RPLcleChmclParPrdctID 
	where dh.DlHdrID = #ChangeRowVariables.DealHeaderId and DlDtlPRvsnRwTpe = 'F' and p.FutureSymbol IS NOT NULL)
WHERE Product IS NULL

UPDATE #ChangeRowVariables SET ContractMonthYear = (select vtp.name from VETradePeriod vtp 
where vtp.VETradePeriodID = (select ddpr.PriceAttribute4 from DealDetailProvisionRow ddpr where ddpr.DlDtlPrvsnRwID = (SELECT MIN(DlDtlPrvsnRwID) 
FROM dbo.DealDetailProvisionRow (NOLOCK) WHERE DlDtlPrvsnID = #ChangeRowVariables.DealDetailPrvsnID AND DlDtlPRvsnRwTpe = 'F')))

UPDATE #ChangeRowVariables SET ContractMonth = RTRIM(LTRIM(SUBSTRING(#ChangeRowVariables.ContractMonthYear,0, LEN(#ChangeRowVariables.ContractMonthYear)- 4))) where ContractMonthYear is not null

UPDATE #ChangeRowVariables SET PriceMonth = RTRIM(LTRIM(SUBSTRING(#ChangeRowVariables.ContractMonthYear,0, LEN(#ChangeRowVariables.ContractMonthYear)- 4))) where ContractMonthYear is not null

UPDATE #ChangeRowVariables SET settlementDate = DateAdd(Month,-1,CONVERT(smallDatetime,LTRIM(RTRIM(ContractMonthYear)))) where settlementDate is null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{PriceServiceProduct}',PriceServiceProduct)

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{baseprice}',RTRIM(LTRIM(Convert(varchar(64),baseprice))))

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{basisprice}',RTRIM(LTRIM(Convert(varchar(64),ABS(basisprice)))))

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{PriceService}',PriceService) where PriceService is not null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{ContractMonthYear}',ContractMonthYear) where ContractMonthYear is not null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{ContractMonthYear+1}',
 CONCAT (DateName(Month,(DateAdd(Month,1,CONVERT(smallDatetime,LTRIM(RTRIM(ContractMonthYear)))))),' ',DateName(YEAR,(DateAdd(Month,1,CONVERT(smallDatetime,LTRIM(RTRIM(ContractMonthYear))))))))
 Where ContractMonthYear is not null and ISDATE(ContractMonthYear) = 1

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{settlementpricedate}',Concat(DateName(Month,settlementDate),' ',DatePart(Day,settlementDate),', ',DatePart(Year,settlementDate))) where settlementDate is not null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{pricedifferential}',RTRIM(LTRIM(Convert(varchar(64),ABS(diff))))) where diff is not null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{fullprice}',RTRIM(LTRIM(Convert(varchar(64),fullprice)))) where fullprice is not null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{sign} ',case when (fullprice > baseprice and RowTextType = 'F') then 'minus ' when (fullprice < baseprice and RowTextType = 'F') 
then 'plus ' when (fullprice = baseprice and (RowTextType = 'F')) then ''
 when (RowTextType = 'D' and basisprice > 0) then 'plus ' when (RowTextType = 'D' and basisprice < 0) then 'minus ' when (RowTextType = 'D' and basisprice = 0) then 'plus ' end) where fullprice is not null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{nonplussed} ',case when (basisprice < 0 and RowTextType = 'D') then 'less ' when (basisprice > 0 and RowTextType = 'D') 
then 'plus ' when (basisprice = 0 and RowTextType = 'D') then 'plus ' end) where fullprice is not null  and RowTextType = 'D'

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{product}',Product) where Product is not null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{pricemonth}',PriceMonth) where PriceMonth is not null

UPDATE #ChangeRowVariables SET RowText = replace(RowText,'{Month}',ContractMonth) where ContractMonth is not null

Update #ChangeRow set RowText = (select min(crv.RowText) from #ChangeRowVariables crv)
END

SELECT	@CostType = CostType,
		@CurrentChangeCheckSum = CHECKSUM(RowText,HolidayOptionName,SaturdayOptionName,SundayOptionName,DeemedDates,EventReference),
		@SecondaryChangeCheckSum = CHECKSUM(PrvsnRwID,PrvsnID,CostType,RowNumber,Differential,PrceTpeIdnty,
			RPHdrID,Actual,FixedValue,RuleName,RuleDescription,HolidayOption,SaturdayOption,
			SundayOption,CurveName,LcleID,CrrncyID,comment)
FROM #ChangeRow

SELECT @MaxRevisionID = MAX(RevisionID) FROM dbo.MTVDealPriceRowArchive (NOLOCK) WHERE PrvsnRwID = @PrvsnRowID
IF (@MaxRevisionID IS NULL)  --New Row
BEGIN
	INSERT INTO dbo.MTVDealPriceRowArchive
	SELECT	PrvsnRwID,PrvsnID,0,CASE @CostType WHEN 'P' THEN 'A' ELSE 'N' END,CostType,
			RowNumber,RowText,Differential,PrceTpeIdnty,
			RPHdrID,Actual,FixedValue,DeemedDates,RuleName,
			RuleDescription,HolidayOption,HolidayOptionName,
			SaturdayOption,SaturdayOptionName,
			SundayOption,SundayOptionName,CurveName,LcleID,
			CrrncyID,comment,RevisionDate,RevisionUserID,
			@CurrentChangeCheckSum,
			@SecondaryChangeCheckSum,
			EventReference
	FROM #ChangeRow
	SELECT 'P' RevisionType,0 RevisionID,'A',RevisionDate,RevisionUserID,@PrvsnRowID PrvsnRowID FROM #ChangeRow
END
ELSE
BEGIN --Modified Row
	DECLARE @CurrentCheckSum INT,@SecondaryCheckSum INT

	SELECT	@CurrentCheckSum = ColumnCheckSum,
			@SecondaryCheckSum = SecondaryCheckSum
	FROM dbo.MTVDealPriceRowArchive (NOLOCK)
	WHERE RevisionID = @MaxRevisionID
	AND PrvsnRwID = @PrvsnRowID

	IF (@CurrentCheckSum = @CurrentChangeCheckSum OR @CostType != 'P')
	BEGIN
		IF (@SecondaryCheckSum != @SecondaryChangeCheckSum OR @CurrentCheckSum != @CurrentChangeCheckSum)
		BEGIN
			UPDATE a SET	a.SecondaryCheckSum = @SecondaryChangeCheckSum,
							a.PrvsnRwID = c.PrvsnRwID,
							a.PrvsnID = c.PrvsnID,
							a.CostType = c.CostType,
							a.RowNumber = c.RowNumber,
							a.Differential = c.Differential,
							a.PrceTpeIdnty = c.PrceTpeIdnty,
							a.RPHdrID = c.RPHdrID,
							a.Actual = c.Actual,
							a.FixedValue = c.FixedValue,
							a.DeemedDates = c.DeemedDates,
							a.RuleName = c.RuleName,
							a.RuleDescription = c.RuleDescription,
							a.HolidayOption = c.HolidayOption,
							a.HolidayOptionName = c.HolidayOptionName,
							a.SaturdayOption = c.SaturdayOption,
							a.SaturdayOptionName = c.SaturdayOptionName,
							a.SundayOption = c.SundayOption,
							a.SundayOptionName = c.SundayOptionName,
							a.CurveName = c.CurveName,
							a.LcleID = c.LcleID,
							a.CrrncyID = c.CrrncyID,
							a.comment = c.comment,
							a.RowText = c.RowText,
							a.RevisionDate = c.RevisionDate,
							a.RevisionUserID = c.RevisionUserID,
							a.EventReference = c.EventReference
			FROM dbo.MTVDealPriceRowArchive a
			INNER JOIN #ChangeRow c
			ON a.PrvsnRwID = c.PrvsnRwID
			AND a.RevisionID = @MaxRevisionID			
		END
		SELECT 'P' RevisionType,@MaxRevisionID RevisionID,'N',RevisionDate,RevisionUserID,@PrvsnRowID PrvsnRowID FROM #ChangeRow
	END
	ELSE
	BEGIN
		INSERT INTO dbo.MTVDealPriceRowArchive
		SELECT PrvsnRwID,PrvsnID,@MaxRevisionID + 1,'M',CostType,
			RowNumber,RowText,Differential,PrceTpeIdnty,
			RPHdrID,Actual,FixedValue,DeemedDates,RuleName,
			RuleDescription,HolidayOption,HolidayOptionName,
			SaturdayOption,SaturdayOptionName,
			SundayOption,SundayOptionName,CurveName,LcleID,
			CrrncyID,comment,RevisionDate,RevisionUserID,@CurrentChangeCheckSum,@SecondaryChangeCheckSum,EventReference
		FROM #ChangeRow
		SELECT 'P' RevisionType,@MaxRevisionID+1 RevisionID,'M',RevisionDate,RevisionUserID,@PrvsnRowID PrvsnRowID FROM #ChangeRow
	End
End



