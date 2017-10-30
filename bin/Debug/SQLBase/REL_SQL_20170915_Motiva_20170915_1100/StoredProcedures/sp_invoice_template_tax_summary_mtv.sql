/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_tax_summary_mtv WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_tax_summary_mtv]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_tax_summary_mtv.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_tax_summary_mtv]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_tax_summary_mtv] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_tax_summary_mtv >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

Alter Procedure [dbo].[sp_invoice_template_tax_summary_mtv] @i_SlsInvceHdrID int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_tax_summary           Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Tracy Baird
-- History:	5/7/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	11/7/03		BMM		43227	Modified Joins to be Inner Loop joins
--	1/27/2005	JJF		54293 	Added SalesInvoiceDetail.IsEmbeddedCost	= 'N'
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Select  SalesInvoiceHeader.SlsInvceHdrNmbr 'InvoiceNumber'
        , SalesInvoiceHeader.SlsInvceHdrDueDte 'DueDate'
        , SalesInvoiceDetail.DescriptionColumn 'Description'
        , Sum(SalesInvoiceDetail.SlsInvceDtlTrnsctnVle) 'SumTaxValue'
        , 0 'Deferred'
        ,v_MTV_TaxRates.TaxRate
From    SalesInvoiceHeader
        Inner loop Join SalesInvoiceDetail 	On 	SalesInvoiceHeader.SlsInvceHdrID 		= SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID
        Inner loop Join AccountDetail 		On 	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 	= AccountDetail.AcctDtlID
                                 		And 	AccountDetail.AcctDtlSrceTble 			= 'T'
        LEFT OUTER JOIN v_MTV_TaxRates ON v_MTV_TaxRates.acctdtlid = accountdetail.acctdtlid
Where   SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= @i_SlsInvceHdrID
And	SalesInvoiceDetail.IsEmbeddedCost	= 'N'	-- JJF Added 01/27/05 RAID 54293
Group By SalesInvoiceHeader.SlsInvceHdrNmbr, SalesInvoiceHeader.SlsInvceHdrDueDte, SalesInvoiceDetail.DescriptionColumn   ,v_MTV_TaxRates.TaxRate


Union All 

Select  Deffered.SlsInvceHdrNmbr 'InvoiceNumber'
        , Deffered.SlsInvceHdrDueDte 'DueDate'
        , SalesInvoiceDetail.DescriptionColumn + ' on invoice #' + Deffered.SlsInvceHdrNmbr
        , sum(SalesInvoiceDetail.SlsInvceDtlTrnsctnVle)
        , 1
        , null
From    SalesInvoiceHeaderRelation
        Inner Join SalesInvoiceHeader Deffered 		on SalesInvoiceHeaderRelation. RltdSlsInvceHdrID 	= Deffered. SlsInvceHdrID
        Inner loop Join SalesInvoiceDetail 		on Deffered. SlsInvceHdrID 				= SalesInvoiceDetail. SlsInvceDtlSlsInvceHdrID
Where   SalesInvoiceHeaderRelation. SlsInvceHdrID 		= @i_SlsInvceHdrID
And	SalesInvoiceDetail.IsEmbeddedCost	= 'N'	-- JJF Added 01/27/05 RAID 54293
Group By Deffered.SlsInvceHdrNmbr, Deffered.SlsInvceHdrDueDte, SalesInvoiceDetail.DescriptionColumn


GO


if OBJECT_ID('sp_invoice_template_tax_summary_mtv')is not null begin
   --print "<<< Procedure sp_invoice_template_tax_summary_mtv created >>>"
   grant execute on sp_invoice_template_tax_summary_mtv to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure sp_invoice_template_tax_summary_mtv failed >>>"
