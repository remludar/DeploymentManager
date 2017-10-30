
/****** Object:  View [dbo].[v_MTV_LatestTaxRates]    Script Date: 4/13/2016 8:24:49 AM ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

Print 'Start Script=v_MTV_LatestTaxRates.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_LatestTaxRates]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_LatestTaxRates] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_LatestTaxRates >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER View [dbo].[v_MTV_LatestTaxRates] AS 
--****************************************************************************************************************
-- Name:        v_MTV_LatestTaxRates												   Copyright 2016 OpenLink
-- Overview:    View of Latest Effective Tax Rates
-- Created by:  Sanjay S Kumar
-- History:     13 Apr 2016 - First Created
--****************************************************************************************************************
-- Date         Modified By     Issue#      Modification
-- 12/12/2016   Sanjay Kumar	            Added TaxRate Type to display the Fixed and the Percent types.
-- -----------  --------------  ----------  ----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

 select AD.AcctDtlID,  
		Case When count(DDPR.PriceAttribute1) > 1 Then  AD.Value
		Else TRD.Rate End As TaxRate,
		(select top 1 NewValue from MTV_TaxAudit where TabChanged = 'Provisions' and EntityChanged = 'Fixed Tax Rate' and DlDtlPrvsnID = DDPR.DlDtlPrvsnID order by DateModified desc) As LatestTaxRate,
		TaxRuleSet.Type As TaxRateType
	from AccountDetail AD 
	Left Join TaxDetailLog TDL (NoLock)
	        On AD.AcctDtlSrceTble = 'T'
	        And AD.AcctDtlSrceID = TDL.TxDtlLgID
	Left Join TaxDetail TD (NoLock)
	        On TDL.TxDtlLgTxDtlID = TD.TxDtlID
	Left Join DealDetailProvision DDP (NoLock)
	        On TD.DlDtlPrvsnID = DDP.DlDtlPrvsnID
	        And TD.TransactionDate Between DDP.DlDtlPrvsnFrmDte and DDP.DlDtlPrvsnToDte
		
	Left Join DealDetailProvisionRow DDPR (NoLock)
	        On DDP.DlDtlPrvsnID = DDPR.DlDtlPrvsnID
			and DDPR.PriceAttribute1 is not null
			And TD.TransactionDate Between DDP.DlDtlPrvsnFrmDte and DDP.DlDtlPrvsnToDte
	Left Join TransactionType As TaxTransactionType (NoLock) On
				AD.AcctDtlTrnsctnTypID = TaxTransactionType.TrnsctnTypID
	Left Join TaxRateDetail As TRD (NoLock) On 
			CASE WHEN TRY_CONVERT(int, DDPR.PriceAttribute1) is null 
				THEN 0
				ELSE CONVERT(int, DDPR.PriceAttribute1)
				END = TRD.TaxRateNameID
				And TD.TransactionDate Between TRD.FromDate and TRD.ToDate
	Left join TaxRuleSet (NoLock) on
				TaxRuleSet.TxRleStID = TD.TxRleStID
				where TaxTransactionType.TrnsctnTypDesc like '%Tax%' and DDPR.PriceAttribute1 is not null
				group by AD.AcctDtlID, DDPR.DlDtlPrvsnID, TRD.Rate, Ad.Value, TaxRuleSet.Type

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_LatestTaxRates]') IS NOT NULL
	  BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_LatestTaxRates.sql'
			PRINT '<<< ALTERED View v_MTV_LatestTaxRates >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_LatestTaxRates >>>'
	  END