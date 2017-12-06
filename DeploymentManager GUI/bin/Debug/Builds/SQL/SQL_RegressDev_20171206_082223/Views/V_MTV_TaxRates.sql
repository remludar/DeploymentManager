
/****** Object:  View [dbo].[v_MTV_TaxRates]    Script Date: 4/13/2016 8:24:49 AM ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

Print 'Start Script=v_MTV_TaxRates.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxRates]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_TaxRates] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_TaxRates >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER View [dbo].[v_MTV_TaxRates] AS 
--****************************************************************************************************************
-- Name:        v_MTV_TaxRates												            Copyright 2016 OpenLink
-- Overview:    View of Tax Rates
-- Created by:  Sanjay S Kumar
-- History:     13 Apr 2016 - First Created
--****************************************************************************************************************
-- Date         Modified By     Issue#      Modification
-- -----------  --------------  ----------  ----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

--select distinct(AD.AcctDtlID)
--, case pat.PrvsnAttrTpeDscrptn when 'Percent Tax Rate Name' then trdp.Rate
--                               when 'Fixed Tax Rate Name' then trdf.rate
--                                                when 'Tax Percentage' then ddpa.DlDtlPnAttrDta
--                                                when 'Fixed Price' then ddpa.DlDtlPnAttrDta
--                                              else  ad.value end As TaxRate
--,  pat.PrvsnAttrTpeDscrptn
--from AccountDetail AD 
--       Left Join  TaxDetailLog TDL (NoLock)
--                     On  AD.AcctDtlSrceTble = 'T'
--                     And AD.AcctDtlSrceID = TDL.TxDtlLgID
--       Left Join    TaxDetail TD (NoLock)
--                     On  TDL.TxDtlLgTxDtlID = TD.TxDtlID
--       Left Join    DealDetailProvision DDP (NoLock)
--                     On  TD.DlDtlPrvsnID = DDP.DlDtlPrvsnID
--                     And TD.TransactionDate Between DDP.DlDtlPrvsnFrmDte and DDP.DlDtlPrvsnToDte
--          Left Join    DealDetailPrvsnAttribute DDPA on DDPA.DlDtlPnAttrDlDtlPnID = DDP.DlDtlPrvsnID
--          left join    PrvsnAttributeType pat on pat.PrvsnAttrTpeID = ddpa.DlDtlPnAttrPrvsnAttrTpeID
--                                     and pat.PrvsnAttrTpeDscrptn in ( 'Fixed Price','Tax Percentage')
--          left join    TaxRateName TRNP on TRNP.TaxrateNameID = ddpa.DlDtlPnAttrDta
--                                             and trnP.Type = 'P'
--                                             and pat.PrvsnAttrTpeDscrptn = 'Percent Tax Rate Name'
--          left join    taxratedetail trdp on trnp.TaxRateNameID = trdp.TaxRateNameID
--          left join    TaxRateName TRNF on TRNF.TaxrateNameID = ddpa.DlDtlPnAttrDta
--                                             and trnf.Type = 'F'
--                                             and pat.PrvsnAttrTpeDscrptn = 'Fixed Tax Rate Name'
--          left join    TaxRateDetail trdf on trdf.TaxRateNameID = trnf.TaxRateNameID
		  --where pat.PrvsnAttrTpeDscrptn is not null

 select AD.AcctDtlID, --DDPR.PriceAttribute1, 
		Case When count(DDPR.PriceAttribute1) > 1 Then  AD.Value
		Else TRD.Rate End As TaxRate
from AccountDetail AD  (NoLock)
	Left Join  TaxDetailLog TDL (NoLock)
	        On  AD.AcctDtlSrceTble = 'T'
	        And AD.AcctDtlSrceID = TDL.TxDtlLgID
	Left Join    TaxDetail TD (NoLock)
	        On  TDL.TxDtlLgTxDtlID = TD.TxDtlID
	Left Join    DealDetailProvision DDP (NoLock)
	        On  TD.DlDtlPrvsnID = DDP.DlDtlPrvsnID
	        And TD.TransactionDate Between DDP.DlDtlPrvsnFrmDte and DDP.DlDtlPrvsnToDte
	
	
	Left Join    DealDetailProvisionRow DDPR (NoLock)
	        On  DDP.DlDtlPrvsnID = DDPR.DlDtlPrvsnID
			and DDPR.PriceAttribute1 is not null
			And TD.TransactionDate Between DDP.DlDtlPrvsnFrmDte and DDP.DlDtlPrvsnToDte
	Left Join TransactionType As TaxTransactionType (NoLock) On
				AD.AcctDtlTrnsctnTypID = TaxTransactionType.TrnsctnTypID
	Left Join TaxRateDetail As TRD  (NoLock) On 
			CASE WHEN TRY_CONVERT(int, DDPR.PriceAttribute1) is null 
				THEN 0
				ELSE CONVERT(int, DDPR.PriceAttribute1)
				END = TRD.TaxRateNameID
				And TD.TransactionDate Between TRD.FromDate and TRD.ToDate
				where TaxTransactionType.TrnsctnTypDesc like '%Tax%' and DDPR.PriceAttribute1 is not null
				group by AD.AcctDtlID, DDPR.PriceAttribute1, TRD.Rate, Ad.Value



GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxRates]') IS NOT NULL
	  BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_TaxRates.sql'
			PRINT '<<< ALTERED View v_MTV_TaxRates >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_TaxRates >>>'
	  END