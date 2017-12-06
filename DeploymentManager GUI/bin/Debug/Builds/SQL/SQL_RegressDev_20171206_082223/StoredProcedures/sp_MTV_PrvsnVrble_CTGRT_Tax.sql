
If OBJECT_ID('dbo.MTV_PrvsnVrble_CTGRT_Tax') Is Not NULL 
Begin
	DROP PROC dbo.MTV_PrvsnVrble_CTGRT_Tax
	PRINT '<<< DROPPED PROC dbo.MTV_PrvsnVrble_CTGRT_Tax >>>'
End
Go  

Create Procedure dbo.MTV_PrvsnVrble_CTGRT_Tax						
															@i_DlDtlPrvsnID			int
															,@i_DlDtlPrvsnRwID		int	
															,@i_XHdrID				int  --this is being passed the AcctDtlID for some reason
															,@i_AcctDtlID			int  --Sales/Purchase AcctDtlID

As	
																

-----------------------------------------------------------------------------------------------------------------------------
-- Name:			MTV_PrvsnVrble_CTGRT_Tax	Copyright 2003 SolArc
-- Overview:		
--					Determine whether to use the Max PPG or the Effective Tax Rate % from the CT GRT Tax Provision.  
--					When the product price plus Federal Oil Spill Tax exceeds the maximum set in the provision ($3.00 per gallon) 
--					the taxable value of the movement needs to be adjusted to be based on the volume of the movement times $3.00/gallon, 
--					then that total times the applicable Effective Tax Rate, currently 8.8139%, would be applied to the new adjusted value.   
--					When the price plus Federal Oil Spill is below $3.00/gallon the tax would be applied to the extend value times the Effective Rate.

--					This provision variable is used on a Tax Provision (which is on a Tax Rule) only - it is not used on Deal Provision types

-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:		Lindsey Hubble	
-- History:			10/08/2014 - First Created
--
-- 	Date Modified 	Modified By		Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set Quoted_Identifier OFF

/*
select * from Prvsn
select * from DealDetailProvision where DlDtlPrvsnPrvsnID = 289
select * from DealDetailProvisionRow where DlDtlPrvsnID = 28394
select * from AccountDetail
select * from TaxDetail
*/

Declare @d_AdjustedTotalValue		decimal(19,6)
		,@d_FedOilSpillTaxRate		decimal(19,6)
		,@i_FedOilSpillTaxTxID		int
		,@i_FedOilSpillTaxTxRleStID	int
		,@d_MaxPricePerGal			decimal(19,6)
		,@d_MvtAcctDtlPrice			decimal(19,6)
		,@d_MvtQty					decimal(19,6)
		,@i_TxCmmdtySbGrpID			int
		,@i_DlHdrTyp				int
		,@dt_MvtDte					datetime

--Motiva Customization :::::::  START
DECLARE	@TransactionGroup		VARCHAR(255)
		,@TaxDescription		VARCHAR(255)
		,@TransactionGroupId	INT
		,@d_AcctDtlTtlValue		decimal(19,6)
		,@MvtHdrId				INT

SELECT @TransactionGroup	= DBO.GetRegistryValue ('Motiva\Tax\CTGrossReceipts\transactiongroup')
		,@TaxDescription	= DBO.GetRegistryValue ('Motiva\Tax\CTGrossReceipts\taxdescription')

SELECT	@TransactionGroupId = XGrpID FROM TransactionGroup WHERE XGrpQlfr = 'Reporting' AND XGrpName = @TransactionGroup

--Motiva Customization :::::::  END

-----------------------------------------------------------------------------------------------------		
-- Get Max rates input on Tax Provision 		
-----------------------------------------------------------------------------------------------------

Select	@d_MaxPricePerGal = convert(decimal(19,6), PriceAttribute1)  
From	DealDetailProvisionRow (NoLock)	
Where	DealDetailProvisionRow.DlDtlPrvsnID = @i_DlDtlPrvsnID


-----------------------------------------------------------------------------------------------------
-- Lookup the Federal Oil Spill Tax Rate - based on Tax Commodity, Deal Type and Effective Dates
-----------------------------------------------------------------------------------------------------
/*
REMOVED PER JANET AFTER DISCUSSION WITH CT TAX REP:::  Federal Oil Spill Tax IS NOT TO BE INCLUDED IN CALCULATION
--Select	@i_FedOilSpillTaxTxID = TxID from Tax where Description = @TaxDescription

--Select	@i_TxCmmdtySbGrpID = Product.TaxCmmdtySbGrpID 
--		,@i_DlHdrTyp = DealHeader.DlHdrTyp
--		,@dt_MvtDte = MovementHeader.MvtHdrDte
--From	AccountDetail (NoLock)
--		Inner Join Product (NoLock)			On  AccountDetail.ParentPrdctID = Product.PrdctID 
--		Inner Join MovementHeader (NoLock)	On  AccountDetail.AcctDtlMvtHdrID = MovementHeader.MvtHdrID
--		Inner Join DealHeader (NoLock)		On  AccountDetail.AcctDtlDlDtlDlHdrID = DealHeader.DlHdrID
--Where	AccountDetail.AcctDtlID = @i_AcctDtlID


--Select	@i_FedOilSpillTaxTxRleStID = TaxRuleSet.TxRleStID  --it could find multiple, but so far all rules that overlap have the same Rate.  Set variable first so we just grab one of them
--From	TaxRuleSet (NoLock)
--		Inner Join TaxRuleSetRule DealRule (NoLock)			On  TaxRuleSet.TxID = DealRule.TxID
--															And TaxRuleSet.TxRleStID = DealRule.TxRleStID
--															And DealRule.TxRleID = 33
--		Inner Join TaxRuleSetRule TaxCommodityRule (NoLock)	On  TaxRuleSet.TxID = TaxCommodityRule.TxID
--															And TaxRuleSet.TxRleStID = TaxCommodityRule.TxRleStID
--															And TaxCommodityRule.TxRleID = 32
--Where	TaxRuleSet.Status = 'A'
--And		TaxRuleSet.TxID = @i_FedOilSpillTaxTxID	
--And		@dt_MvtDte between TaxRuleSet.FromDate and TaxRuleSet.ToDate	
--And		(DealRule.RuleValue like '%||' + convert(varchar, @i_DlHdrTyp) + '||%'
--			OR DealRule.RuleValue like '%||' + convert(varchar, @i_DlHdrTyp)
--			OR DealRule.RuleValue like convert(varchar, @i_DlHdrTyp) + '||%'
--			OR DealRule.RuleValue = convert(varchar, @i_DlHdrTyp))
--And		(TaxCommodityRule.RuleValue like '%||' + convert(varchar, @i_TxCmmdtySbGrpID) + '||%'
--			OR TaxCommodityRule.RuleValue like '%||' + convert(varchar, @i_TxCmmdtySbGrpID)
--			OR TaxCommodityRule.RuleValue like convert(varchar, @i_TxCmmdtySbGrpID) + '||%'
--			OR TaxCommodityRule.RuleValue = convert(varchar, @i_TxCmmdtySbGrpID))

----TOD:: Rewrite to use Rate Table or PriceAttribute1
--Select	@d_FedOilSpillTaxRate = convert(decimal(19,6), PriceAttribute1)  
--From	TaxProvision (NoLock) 
--		Inner Join DealDetailProvision (NoLock)			On  TaxProvision.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
--														And @dt_MvtDte between DealDetailProvision.DlDtlPrvsnFrmDte and DealDetailProvision.DlDtlPrvsnToDte
--		Inner Join DealDetailProvisionRow (NoLock)		On  DealDetailProvision.DlDtlPrvsnID = DealDetailProvisionRow.DlDtlPrvsnID
--Where	TaxProvision.TxRleStID = @i_FedOilSpillTaxTxRleStID
*/

-----------------------------------------------------------------------------------------------------
-- Get the Movement Per Unit
-----------------------------------------------------------------------------------------------------
--Motiva Customization ::::: START

--TODO: 1.  Get Volume from statement below
--		2.	Get AccountDetail Value from TransationTypes in TransactionGroup = 'CT Gross Receipts' reporting Group
				--
				--Sum values
/*
COMMENTED OUT ORIGINAL CODE, broke this out to separate statements to take into account additonal transaction 
types possible included
Select	@d_MvtAcctDtlPrice = Abs(AccountDetail.Value/AccountDetail.Volume)
		,@d_MvtQty = Abs(AccountDetail.Volume)
From	AccountDetail (NoLock) 
Where	AccountDetail.AcctDtlID = @i_AcctDtlID
*/

--GET volume of primary transaction type assigned on the tax rule
Select	@d_MvtQty = Abs(AccountDetail.Volume)
		,@MvtHdrId = AccountDetail.AcctDtlMvtHdrId
From	AccountDetail (NoLock) 
Where	AccountDetail.AcctDtlID = @i_AcctDtlID

/*This will get all the accountdetail values for the tranasaction types defined in the 
transaction group used for the CT Gross Receipts Proviison*/
SELECT	@d_AcctDtlTtlValue = SUM(AccountDetail.Value)
FROM	AccountDetail
INNER JOIN	TransactionTypeGroup
ON		AccountDetail.AcctDtlTrnsctnTypID = TransactionTypeGroup.XTpeGrpTrnsctnTypID
AND		TransactionTypeGroup.XTpeGrpXGrpID = @TransactionGroupId
INNER JOIN	TransactionType
ON		TransactionTypeGroup.XTpeGrpTrnsctnTypID = TransactionType.TrnsctnTypID
WHERE	AcctDtlMvtHdrId = @MvtHdrId

--Calculate Price to be compared to MAX per dollar
Select	@d_MvtAcctDtlPrice = abs(@d_AcctDtlTtlValue/@d_MvtQty)

--Motiva Customization :::::::  END

-----------------------------------------------------------------------------------------------------
-- Add the Movement Per Unit and the Federal Oil Spill Tax Rate from the Prvsn.  
-- If the Product price + tax rate > Max PPG then use the Max PPG, otherwise, use the Product Price + tax rate
-----------------------------------------------------------------------------------------------------
--Motiva Customization :::::::  START
/*
If @d_MvtAcctDtlPrice + @d_FedOilSpillTaxRate > @d_MaxPricePerGal
	Select @d_AdjustedTotalValue = @d_MaxPricePerGal * @d_MvtQty
Else 
	Select @d_AdjustedTotalValue = (@d_MvtAcctDtlPrice + @d_FedOilSpillTaxRate) * @d_MvtQty

Select @d_AdjustedTotalValue
*/

If @d_MvtAcctDtlPrice > @d_MaxPricePerGal
	Select @d_AdjustedTotalValue = @d_MaxPricePerGal * @d_MvtQty
Else 
	Select @d_AdjustedTotalValue = (@d_MvtAcctDtlPrice ) * @d_MvtQty

Select @d_AdjustedTotalValue

--Motiva Customization :::::::  END


GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.MTV_PrvsnVrble_CTGRT_Tax') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.MTV_PrvsnVrble_CTGRT_Tax >>>'
	Grant Execute on dbo.MTV_PrvsnVrble_CTGRT_Tax to SYSUSER
	Grant Execute on dbo.MTV_PrvsnVrble_CTGRT_Tax to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.MTV_PrvsnVrble_CTGRT_Tax >>>'
GO

 