/*
*****************************************************************************************************
USE FIND AND REPLACE ON DealSoldToVendorNumber WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTV_AccountDetailSoldToVendorNumber]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AccountDetailSoldToVendorNumber.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AccountDetailSoldToVendorNumber]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_AccountDetailSoldToVendorNumber] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_AccountDetailSoldToVendorNumber >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTV_AccountDetailSoldToVendorNumber]
AS
-- =============================================
-- Author:        YOURNAME
-- Create date:	  DATECREATED
-- Description:   SHORT DESCRIPTION OF WHAT THIS THINGS DOES\
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------

select	AccountDetail.AcctDtlID
		,CASE WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand NOT IN ('R','D') AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			ELSE MTVSAPBASoldTo.VendorNumber  END AS SAPIndentifier
		,MTVSAPBASoldTo.SoldTo
		,MTVSAPBASoldTo.VendorNumber
		,DynamicListBox.DynLstBxDesc as ClassOfTrade
		--select *
from	AccountDetail (NoLock)
INNER JOIN
		(
			select	DISTINCT DealHeader.DlHdrID
					,DealDetail.DlDtlID
					,DealHeader.DlHdrExtrnlBAID
					,MTVSAPBASoldTo.ClassOfTrade
					,GeneralConfiguration.GnrlCnfgMulti as BASoldToId
					,TransactionDetailLog.XDtlLgAcctDtlID
					--select *
			from	DealHeader (NoLock)
			INNER JOIN DealDetail (NoLock)
			ON	DealHeader.DlHdrID = DealDetail.DlDtlDlHdrID
			INNER JOIN DealDetailProvision (NoLock)
			ON	DealDetail.DlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
			AND	DealDetail.DlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
			--AND	DealDetailProvision.CostType = 'P'
			AND	DealHeader.DlHdrExtrnlBAID = DealDetailProvision.BAID
			INNER JOIN TransactionDetailLog (NoLock)
			ON	DealDetailProvision.DlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
			INNER JOIN	GeneralConfiguration (NoLock)
			ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
			AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
			AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
			AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
			INNER JOIN	MTVSAPBASoldTo (NoLock)
			ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
		) AS DealClassOfTrade
ON	AccountDetail.AcctDtlID = DealClassOfTrade.XDtlLgAcctDtlID
INNER JOIN	MTVSAPBASoldTo (NoLock)
ON	DealClassOfTrade.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
AND	DealClassOfTrade.BASoldToId = MTVSAPBASoldTo.ID
INNER JOIN	DynamicListBox (NoLock)
ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
where AccountDetail.AcctDtlSrceTble = 'X'
UNION
select	AccountDetail.AcctDtlID
		,CASE WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand NOT IN ('R','D') AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			ELSE MTVSAPBASoldTo.VendorNumber  END AS SAPIndentifier
		,MTVSAPBASoldTo.SoldTo
		,MTVSAPBASoldTo.VendorNumber
		,DynamicListBox.DynLstBxDesc as ClassOfTrade
		--select acctdtlid,ExternalBAID,DealClassOfTrade.BAID
from	AccountDetail (NoLock)
INNER JOIN
		(
			select	DISTINCT DealHeader.DlHdrID
					,DealDetail.DlDtlID
					,DealDetailProvision.BAID
					,MTVSAPBASoldTo.ClassOfTrade
					,GeneralConfiguration.GnrlCnfgMulti as BASoldToId
					,TransactionDetailLog.XDtlLgAcctDtlID
					--select *
			from	DealHeader (NoLock)
			INNER JOIN DealDetail (NoLock)
			ON	DealHeader.DlHdrID = DealDetail.DlDtlDlHdrID
			INNER JOIN DealDetailProvision (NoLock)
			ON	DealDetail.DlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
			AND	DealDetail.DlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
			AND	DealDetailProvision.CostType <> 'P'
			AND	DealHeader.DlHdrExtrnlBAID <> DealDetailProvision.BAID
			INNER JOIN TransactionDetailLog (NoLock)
			ON	DealDetailProvision.DlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
			INNER JOIN	GeneralConfiguration (NoLock)
			ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
			AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
			AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
			AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
			INNER JOIN	MTVSAPBASoldTo (NoLock)
			ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
		) AS DealClassOfTrade
ON	AccountDetail.AcctDtlID = DealClassOfTrade.XDtlLgAcctDtlID
INNER JOIN	MTVSAPBASoldTo (NoLock)
ON	DealClassOfTrade.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
AND	AccountDetail.ExternalBAID = MTVSAPBASoldTo.BAID
INNER JOIN	DynamicListBox (NoLock)
ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
where AccountDetail.AcctDtlSrceTble = 'X'
UNION
select	AccountDetail.AcctDtlID
		,CASE WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand NOT IN ('R','D') AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			ELSE MTVSAPBASoldTo.VendorNumber  END AS SAPIndentifier
		,MTVSAPBASoldTo.SoldTo
		,MTVSAPBASoldTo.VendorNumber
		,DynamicListBox.DynLstBxDesc as ClassOfTrade
		--select COUNT(*)
from	AccountDetail (NoLock)
		INNER JOIN Dealheader (NoLock)
			ON	AccountDetail.AcctDtlDlDtlDlHdrID = DealHeader.DlHdrID
		INNER JOIN	GeneralConfiguration (NoLock)
			ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
			AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
			AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
			AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
		INNER JOIN	MTVSAPBASoldTo (NoLock)
			ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
		INNER JOIN	DynamicListBox (NoLock)
			ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
			AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
where AccountDetail.AcctDtlSrceTble = 'T'
And		Not Exists	(
					Select	1
					From	TransactionTypeGroup (NoLock)
							Inner Join TransactionGroup (NoLock)
								on	TransactionGroup.XGrpID		= TransactionTypeGroup.XTpeGrpXGrpID
					Where	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= AccountDetail.AcctDtlTrnsctnTypID
					And		TransactionGroup.XGrpName					= 'Freight - Tax Engine'
					)
UNION
select	AccountDetail.AcctDtlID
		,CASE WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand NOT IN ('R','D') AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			ELSE MTVSAPBASoldTo.VendorNumber  END AS SAPIndentifier
		,MTVSAPBASoldTo.SoldTo
		,MTVSAPBASoldTo.VendorNumber
		,DynamicListBox.DynLstBxDesc as ClassOfTrade
		--select COUNT(*)
from	AccountDetail (NoLock)
		INNER JOIN TaxDetailLog (NoLock)
			on	TaxDetailLog.TxDtlLgID						= AccountDetail.AcctDtlSrceID
		Inner Join TaxDetail (NoLock)
			on	TaxDetail.TxDtlID							= TaxDetailLog.TxDtlLgTxDtlID
		Inner Join Tax (NoLock)
			on	Tax.TxID									= TaxDetail.TxID
		INNER JOIN	MTVSAPBASoldTo (NoLock)
			ON	MTVSAPBASoldTo.BAID							= Tax.TaxAuthorityBAID
			and	IsNull(MTVSAPBASoldTo.VendorNumber, '')		<> ''		-- For the Freight - Tax Engine group, we always want Vendor Number
		INNER JOIN	DynamicListBox (NoLock)
			ON	MTVSAPBASoldTo.ClassOfTrade					= DynamicListBox.DynLstBxTyp
			AND	DynamicListBox.DynLstBxQlfr					= 'BASoldToClassOfTrade'
where	AccountDetail.AcctDtlSrceTble = 'T'
And		Exists	(
				Select	1
				From	TransactionTypeGroup (NoLock)
						Inner Join TransactionGroup (NoLock)
							on	TransactionGroup.XGrpID		= TransactionTypeGroup.XTpeGrpXGrpID
				Where	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= AccountDetail.AcctDtlTrnsctnTypID
				And		TransactionGroup.XGrpName					= 'Freight - Tax Engine'
				)
UNION
select	AccountDetail.AcctDtlID
		,CASE WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand NOT IN ('R','D') AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			ELSE MTVSAPBASoldTo.VendorNumber  END AS SAPIndentifier
		,MTVSAPBASoldTo.SoldTo
		,MTVSAPBASoldTo.VendorNumber
		,DynamicListBox.DynLstBxDesc as ClassOfTrade
		--select *
from	AccountDetail (NoLock)
INNER JOIN
		(
			select	DISTINCT DealHeader.DlHdrID
					,DealDetail.DlDtlID
					,DealHeader.DlHdrExtrnlBAID
					,MTVSAPBASoldTo.ClassOfTrade
					,GeneralConfiguration.GnrlCnfgMulti as BASoldToId
					,TimeTransactionDetailLog.TmeXDtlLgAcctDtlID
					--select *
			from	DealHeader (NoLock)
			INNER JOIN DealDetail (NoLock)
			ON	DealHeader.DlHdrID = DealDetail.DlDtlDlHdrID
			INNER JOIN DealDetailProvision (NoLock)
			ON	DealDetail.DlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
			AND	DealDetail.DlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
			--AND	DealDetailProvision.CostType = 'P'
			AND	DealHeader.DlHdrExtrnlBAID = DealDetailProvision.BAID
			INNER JOIN	TimeTransactionDetail (NoLock)
			ON	 DealDetailProvision.DlDtlPrvsnID = TimeTransactionDetail.TmeXDtlDlDtlPrvsnID
			INNER JOIN TimeTransactionDetailLog (NoLock)
			ON	TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty = TimeTransactionDetail.TmeXDtlIdnty
			INNER JOIN	GeneralConfiguration (NoLock)
			ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
			AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
			AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
			AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
			INNER JOIN	MTVSAPBASoldTo (NoLock)
			ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
		) AS DealClassOfTrade
ON	AccountDetail.AcctDtlID = DealClassOfTrade.TmeXDtlLgAcctDtlID
INNER JOIN	MTVSAPBASoldTo (NoLock)
ON	DealClassOfTrade.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
AND	DealClassOfTrade.BASoldToId = MTVSAPBASoldTo.ID
INNER JOIN	DynamicListBox (NoLock)
ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
where AccountDetail.AcctDtlSrceTble = 'TT'
UNION
select	AccountDetail.AcctDtlID
		,CASE WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand NOT IN ('R','D') AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			ELSE MTVSAPBASoldTo.VendorNumber  END AS SAPIndentifier
		,MTVSAPBASoldTo.SoldTo
		,MTVSAPBASoldTo.VendorNumber
		,DynamicListBox.DynLstBxDesc as ClassOfTrade
		--select acctdtlid,ExternalBAID,DealClassOfTrade.BAID
from	AccountDetail (NoLock)
INNER JOIN
		(
			select	DISTINCT DealHeader.DlHdrID
					,DealDetail.DlDtlID
					,DealDetailProvision.BAID
					,MTVSAPBASoldTo.ClassOfTrade
					,GeneralConfiguration.GnrlCnfgMulti as BASoldToId
					,TimeTransactionDetailLog.TmeXDtlLgAcctDtlID
					--select *
			from	DealHeader (NoLock)
			INNER JOIN DealDetail (NoLock)
			ON	DealHeader.DlHdrID = DealDetail.DlDtlDlHdrID
			INNER JOIN DealDetailProvision (NoLock)
			ON	DealDetail.DlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
			AND	DealDetail.DlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
			AND	DealDetailProvision.CostType <> 'P'
			AND	DealHeader.DlHdrExtrnlBAID <> DealDetailProvision.BAID
			INNER JOIN	TimeTransactionDetail (NoLock)
			ON	 DealDetailProvision.DlDtlPrvsnID = TimeTransactionDetail.TmeXDtlDlDtlPrvsnID
			INNER JOIN TimeTransactionDetailLog (NoLock)
			ON	TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty = TimeTransactionDetail.TmeXDtlIdnty
			INNER JOIN	GeneralConfiguration (NoLock)
			ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
			AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
			AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
			AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
			INNER JOIN	MTVSAPBASoldTo (NoLock)
			ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
		) AS DealClassOfTrade
ON	AccountDetail.AcctDtlID = DealClassOfTrade.TmeXDtlLgAcctDtlID
INNER JOIN	MTVSAPBASoldTo (NoLock)
ON	DealClassOfTrade.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
AND	AccountDetail.ExternalBAID = MTVSAPBASoldTo.BAID
INNER JOIN	DynamicListBox (NoLock)
ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
where AccountDetail.AcctDtlSrceTble = 'TT'
UNION
Select	AccountDetail.AcctDtlID
		,CASE WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand NOT IN ('R','D') AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			ELSE MTVSAPBASoldTo.VendorNumber END AS SAPIndentifier
		,MTVSAPBASoldTo.SoldTo				as SoldTo
		,MTVSAPBASoldTo.VendorNumber		as VendorNumber
		,DLBBA.DynLstBxDesc					as ClassOfTrade
From	AccountDetail (NoLock)
		Inner Join BusinessAssociate (NoLock)
			on	BusinessAssociate.BAID					= AccountDetail.InternalBAID
		Left Outer Join GeneralConfiguration (NoLock)
			On	AccountDetail.AcctDtlDlDtlDlHdrID		= GeneralConfiguration.GnrlCnfgHdrID
			And	GeneralConfiguration.GnrlCnfgQlfr		= 'SAPSoldTo'
			And	GeneralConfiguration.GnrlCnfgTblNme		= 'DealHeader'
			And	GeneralConfiguration.GnrlCnfgHdrID		<> 0
		Left Outer Join MTVSAPBASoldTo (NoLock)
			on	(MTVSAPBASoldTo.BAID		= AccountDetail.ExternalBAID
			or	MTVSAPBASoldTo.ID			= GeneralConfiguration.GnrlCnfgMulti)
		Left Outer Join DynamicListBox DLBBA (NoLock)
			on	MTVSAPBASoldTo.ClassOfTrade				= DLBBA.DynLstBxTyp
			and	DLBBA.DynLstBxQlfr						= 'BASoldToClassOfTrade'
Where	AccountDetail.AcctDtlSrceTble in ( 'M', 'P')
And	Charindex(DLBBA.DynLstBxDesc, BusinessAssociate.BANme, 0) > 0
And	CASE	WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand = 'R' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			WHEN AccountDetail.SupplyDemand = 'D' AND AccountDetail.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
			WHEN AccountDetail.SupplyDemand NOT IN ('R','D') AND AccountDetail.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
			ELSE MTVSAPBASoldTo.VendorNumber
	END IS NOT NULL

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AccountDetailSoldToVendorNumber]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_AccountDetailSoldToVendorNumber.sql'
			PRINT '<<< ALTERED View v_MTV_AccountDetailSoldToVendorNumber >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_AccountDetailSoldToVendorNumber >>>'
	  END
