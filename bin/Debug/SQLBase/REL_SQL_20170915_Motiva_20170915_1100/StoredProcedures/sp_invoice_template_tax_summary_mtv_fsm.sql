/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_tax_summary_mtv_fsm WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_tax_summary_mtv_fsm]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_tax_summary_mtv_fsm.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_tax_summary_mtv_fsm]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_tax_summary_mtv_fsm] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_tax_summary_fsm >>>'
	  END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
--sp_invoice_template_tax_summary_mtv_fsm 112
Alter Procedure [dbo].sp_invoice_template_tax_summary_mtv_fsm @i_SlsInvceHdrID int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_tax_summary_mtv_fsm         
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Tracy Baird
-- History:	5/7/2002 - First Created
--
-- 	Date Modified 	Modified By	     Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	11/7/03		    BMM		        43227	Modified Joins to be Inner Loop joins
--	1/27/2005	    JJF		        54293 	Added SalesInvoiceDetail.IsEmbeddedCost	= 'N'
--  9/20/2016       DLK
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

select XgrpName, XTpeGrpXGrpID, TrnsctnTypID into #allowanceTG
         	          from TransactionType TT 
	                        inner join TransactionTypeGroup TGT on TGT.XTpeGrpTrnsctnTypID = TT.TrnsctnTypID
	                        inner join TransactionGroup allowanceTG on allowanceTG.XGrpID = TGT.XTpeGrpXGrpID
	                                        and allowanceTG.XGrpName in (  'Collection Allowance for Invoice Printing')
select XgrpName, XTpeGrpXGrpID, TrnsctnTypID into #salestaxTG
         	          from TransactionType TT 
	                        inner join TransactionTypeGroup TGT on TGT.XTpeGrpTrnsctnTypID = TT.TrnsctnTypID
	                        inner join TransactionGroup salestaxTG on salestaxTG.XGrpID = TGT.XTpeGrpXGrpID
	                                        and salestaxTG.XGrpName in (  'Sales Tax for Invoice Printing')


Select  SalesInvoiceHeader.SlsInvceHdrNmbr 'InvoiceNumber'
        , SalesInvoiceHeader.SlsInvceHdrDueDte 'DueDate'
        , taxruleset.InvoicingDescription   'Description'
        , sum(SalesInvoiceDetail.SlsInvceDtlTrnsctnVle) 'SumTaxValue'
		, sum( case when salestaxTG.XgrpName is not null   then 0.0 else SalesInvoiceDetail.SlsInvceDtlTrnsctnQntty  end ) 'SumMovementQty'
        , sum( case when salestaxTG.XgrpName  is not null  then SalesInvoiceDetail.SlsInvceDtlTrnsctnVle  else 0.0 end ) 'sumfinancialvalue'
		, case taxRuleSet.Type when 'F' then '%' else unitofmeasure.Uomabbv end
		, max(currency.crrncysmbl) Crrncysymbl
		, case when salestaxTG.XgrpName is not null then 0 else 1 end recordtype
        , 0 'Deferred'
--        , case  when allowanceTG.XgrpName is not null then SalesInvoiceDetail.SlsInvceDtlPrUntVle  else v_MTV_TaxRates.TaxRate  end
        ,isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate )
From    SalesInvoiceHeader
        Inner  Join SalesInvoiceDetail 	On 	SalesInvoiceHeader.SlsInvceHdrID 		= SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID
        Inner  Join AccountDetail 		On 	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 	= AccountDetail.AcctDtlID
                                 		And 	AccountDetail.AcctDtlSrceTble 			= 'T'
		Inner  join TaxDetaillog on TaxDetaillog.TxDtlLgID = AccountDetail.AcctDtlSrceID
		Inner  join TaxDetail on TaxDetail.TxDtlID = taxdetaillog.TxDtlLgTxDtlID
		Inner  join TaxRuleSet on TaxRuleSet.TxRleStID = TaxDetail.TxRleStID
        Inner  Join DealDetailProvision DDP on DDP.DlDtlPrvsnID = TaxDetail.DlDtlPrvsnID
		Inner  Join Prvsn TaxPrvsn on TaxPrvsn.PrvsnID = DDP.DlDtlPrvsnPrvsnID
		inner join unitofmeasure on unitofmeasure.uom = AccountDetail.AcctDtlUomID 
		inner join currency on currency.CrrncyID = SalesInvoiceHeader.SlsInvceHdrCrrncyID
        LEFT OUTER JOIN v_MTV_TaxRates ON v_MTV_TaxRates.AcctDtlID = AccountDetail.AcctDtlID
        left outer join MTV_AccountDetailTaxRateArchive on MTV_AccountDetailTaxRateArchive.AcctDtlID = AccountDetail.AcctDtlID
		left outer join #allowanceTG allowanceTG on allowanceTG.TrnsctntypID = AccountDetail.AcctDtlTrnsctnTypID
		left outer join #salestaxTG salestaxTG on  salestaxTG.TrnsctntypID = AccountDetail.AcctDtlTrnsctnTypID
	                      
Where   SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= @i_SlsInvceHdrID
And	SalesInvoiceDetail.IsEmbeddedCost	= 'N'	-- JJF Added 01/27/05 RAID 54293
And TaxPrvsn.IsFlatFee = 'N'
group by SalesInvoiceHeader.SlsInvceHdrNmbr, SalesInvoiceHeader.SlsInvceHdrDueDte
, case taxRuleSet.Type when 'F' then '%' else unitofmeasure.Uomabbv end
, taxruleset.InvoicingDescription ,taxruleset.type
		, case when salestaxTG.XgrpName is not null then 0 else 1 end 
        , isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate )
        
 UNION
 
Select  SalesInvoiceHeader.SlsInvceHdrNmbr 'InvoiceNumber'
        , SalesInvoiceHeader.SlsInvceHdrDueDte 'DueDate'
        , taxruleset.InvoicingDescription   'Description'
        , sum(SalesInvoiceDetail.SlsInvceDtlTrnsctnVle) 'SumTaxValue'
		, sum( case when salestaxTG.XgrpName is not null   then 0.0 else SalesInvoiceDetail.SlsInvceDtlTrnsctnQntty  end ) 'SumMovementQty'
        , sum( case when salestaxTG.XgrpName  is not null  then SalesInvoiceDetail.SlsInvceDtlTrnsctnVle  else 0.0 end ) 'sumfinancialvalue'
		, case taxRuleSet.Type when 'F' then '%' else unitofmeasure.Uomabbv end
		, max(currency.crrncysmbl) Crrncysymbl
		, case when salestaxTG.XgrpName is not null then 0 else 1 end recordtype
        , 0 'Deferred'
--        , case  when allowanceTG.XgrpName is not null then SalesInvoiceDetail.SlsInvceDtlPrUntVle  else v_MTV_TaxRates.TaxRate  end
        ,sum( isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate ))
From    SalesInvoiceHeader
        Inner  Join SalesInvoiceDetail 	On 	SalesInvoiceHeader.SlsInvceHdrID 		= SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID
        Inner  Join AccountDetail 		On 	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 	= AccountDetail.AcctDtlID
                                 		And 	AccountDetail.AcctDtlSrceTble 			= 'T'
		Inner  join TaxDetaillog on TaxDetaillog.TxDtlLgID = AccountDetail.AcctDtlSrceID
		Inner  join TaxDetail on TaxDetail.TxDtlID = taxdetaillog.TxDtlLgTxDtlID
		Inner  join TaxRuleSet on TaxRuleSet.TxRleStID = TaxDetail.TxRleStID
        Inner  Join DealDetailProvision DDP on DDP.DlDtlPrvsnID = TaxDetail.DlDtlPrvsnID
		Inner  Join Prvsn TaxPrvsn on TaxPrvsn.PrvsnID = DDP.DlDtlPrvsnPrvsnID
		inner join unitofmeasure on unitofmeasure.uom = AccountDetail.AcctDtlUomID 
		inner join currency on currency.CrrncyID = SalesInvoiceHeader.SlsInvceHdrCrrncyID
        LEFT OUTER JOIN v_MTV_TaxRates ON v_MTV_TaxRates.AcctDtlID = AccountDetail.AcctDtlID
        left outer join MTV_AccountDetailTaxRateArchive on MTV_AccountDetailTaxRateArchive.AcctDtlID = AccountDetail.AcctDtlID
		left outer join #allowanceTG allowanceTG on allowanceTG.TrnsctntypID = AccountDetail.AcctDtlTrnsctnTypID
		left outer join #salestaxTG salestaxTG on  salestaxTG.TrnsctntypID = AccountDetail.AcctDtlTrnsctnTypID
	                      
Where   SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= @i_SlsInvceHdrID
And	SalesInvoiceDetail.IsEmbeddedCost	= 'N'	-- JJF Added 01/27/05 RAID 54293
And TaxPrvsn.IsFlatFee = 'Y'
group by SalesInvoiceHeader.SlsInvceHdrNmbr, SalesInvoiceHeader.SlsInvceHdrDueDte
, case taxRuleSet.Type when 'F' then '%' else unitofmeasure.Uomabbv end
, taxruleset.InvoicingDescription ,taxruleset.type
		, case when salestaxTG.XgrpName is not null then 0 else 1 end 
        
  
drop table #allowanceTG
drop table #SALESTAXtg

GO



IF  OBJECT_ID(N'[dbo].[sp_invoice_template_tax_summary_mtv_fsm]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_invoice_template_tax_summary_mtv_fsm.sql'
			PRINT '<<< ALTERED StoredProcedure sp_invoice_template_tax_summary_mtv_fsm >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_invoice_template_tax_summary_mtv_fsm >>>'
	  END
go