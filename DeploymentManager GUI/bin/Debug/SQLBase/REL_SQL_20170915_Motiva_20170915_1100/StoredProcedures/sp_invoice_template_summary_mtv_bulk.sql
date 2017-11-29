/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_summary_mtv WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_summary_mtv_bulk]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_summary_mtv_bulk.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_summary_mtv_bulk]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_summary_mtv_bulk] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_summary_mtv_bulk >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--exec sp_invoice_template_summary_mtv_bulk  1051
ALTER Procedure [dbo].sp_invoice_template_summary_mtv_bulk @i_SlsInvceHdrID Int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_summary_mtv  25       
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	
-- History:	
--
-- 	Date Modified 	Modified By  	Issue#	Modification
-- 	--------------- -------------- 	------	------------------------------------------------------------------------------------------------------------
--   9/9/2016       Dkeeton                 Change from using BusinessAssociateRelation for the Payment type and change to using the Term payment type
--------------------------------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

-- SECTION 1
Select	SalesInvoiceHeader. SlsInvceHdrDueDte 'duedte'
        , Term. TrmVrbge 'TermVerbiage'
        , SalesInvoiceHeader. SlsInvceHdrTtlVle 'TotalValue'
        , SalesInvoiceHeader. SlsInvceHdrDscntDte 'DiscountDate'
        , SalesInvoiceHeader. SlsInvceHdrDscntVle 'DiscountValue'
        , SalesInvoiceHeader. SlsInvceHdrNmbr  + case when SalesInvoiceHeader.DeferredInvoice = 'Y' then '*' else '' end 'InvoiceNumber'
	, SalesInvoiceHeader. SlsInvceHdrID 'SlsInvceHdrID'
	, ISNULL(Parent.SlsInvceHdrNmbr, '') 'CorrectingInvoiceNumber'
	, ISNULL(SalesInvoiceHeader.SlsInvceHdrPstdDte,GETDATE()) SlsInvceHdrPstdDte
	, dynamiclistbox.dynlstbxdesc paymentterms
	, ISNULL(Term.TrmDscnt *.01,0) TrmDscnt
	, SalesInvoiceHeader.SlsInvceHdrCrrncyID CrrncyID
INTO #temp
From	SalesInvoiceHeader
	Left Outer Join SalesInvoiceHeader Parent on 	(SalesInvoiceHeader.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	SalesInvoiceHeader.SlsInvceHdrPrntID <> SalesInvoiceHeader.SlsInvceHdrID)
    Inner Join Term 			  on 	(SalesInvoiceHeader. SlsInvceHdrTrmID = TrmID)
    inner join dynamiclistbox on dynlstbxtyp = Term.TrmPymntMthd
                            and DynLstBxQlfr = 'Paytype'
Where	SalesInvoiceHeader. SlsInvceHdrID = @i_SlsInvceHdrID
Union All
-- SECTION 2
Select	DefferedTaxInvoice. SlsInvceHdrDueDte
        , Term. TrmVrbge
        , DefferedTaxInvoice. SlsInvceHdrTtlVle
        , DefferedTaxInvoice. SlsInvceHdrDscntDte
        , DefferedTaxInvoice. SlsInvceHdrDscntVle
        , DefferedTaxInvoice. SlsInvceHdrNmbr + '*'
	, DefferedTaxInvoice. SlsInvceHdrID 
	, IsNull(Parent.SlsInvceHdrNmbr, '') 'CorrectingInvoiceNumber'
	, Isnull(DefferedTaxInvoice. SlsInvceHdrPstdDte,getdate())
	, dynamiclistbox.dynlstbxdesc paymentterms
	, ISNULL(Term.TrmDscnt *.01,0) TrmDscnt
	, SalesInvoiceHeader.SlsInvceHdrCrrncyID CrrncyID
From	SalesInvoiceHeader
        Inner Join SalesInvoiceHeaderRelation on (SalesInvoiceHeader. SlsInvceHdrID = SalesInvoiceHeaderRelation. SlsInvceHdrID)
        Inner Join SalesInvoiceHeader DefferedTaxInvoice on (RltdSlsInvceHdrID = DefferedTaxInvoice. SlsInvceHdrID)
	Inner Join Term on (DefferedTaxInvoice. SlsInvceHdrTrmID = TrmID)
	Left Outer Join SalesInvoiceHeader Parent on 	(SalesInvoiceHeader.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	SalesInvoiceHeader.SlsInvceHdrPrntID <> SalesInvoiceHeader.SlsInvceHdrID)
--	inner join BusinessAssociateRelation bar on bar.BARltnBAID = SalesInvoiceHeader.SlsInvceHdrIntrnlBAID
--	                                        and bar.BARltnRltn = 'T'
    inner join dynamiclistbox on dynlstbxtyp = term.TrmPymntMthd
                            and DynLstBxQlfr = 'Paytype'

Where	SalesInvoiceHeader. SlsInvceHdrID = @i_SlsInvceHdrID

Union All
--SECTION 3
Select	SalesInvoiceHeader. SlsInvceHdrDueDte
        , Term. TrmVrbge
        , SalesInvoiceHeader. SlsInvceHdrTtlVle
        , SalesInvoiceHeader. SlsInvceHdrDscntDte
        , SalesInvoiceHeader. SlsInvceHdrDscntVle
        , SalesInvoiceHeader. SlsInvceHdrNmbr + case when SalesInvoiceHeader.DeferredInvoice = 'Y' then '*' else '' end 'InvoiceNumber'
	, SalesInvoiceHeader. SlsInvceHdrID 
	--, '' 'CorrectingInvoiceNumber'
	, IsNull(Parent.SlsInvceHdrNmbr, '') 'CorrectingInvoiceNumber'
	, Isnull(SalesInvoiceHeader. SlsInvceHdrPstdDte,getdate())
	, dynamiclistbox.dynlstbxdesc paymentterms
	, ISNULL(Term.TrmDscnt *.01,0) TrmDscnt
	, SalesInvoiceHeader.SlsInvceHdrCrrncyID CrrncyID
From	SalesInvoiceHeader Deferred
        Inner Join SalesInvoiceHeaderRelation 	on (Deferred. SlsInvceHdrID = SalesInvoiceHeaderRelation. RltdSlsInvceHdrID)
        Inner Join SalesInvoiceHeader  		on (SalesInvoiceHeaderRelation.SlsInvceHdrID = SalesInvoiceHeader. SlsInvceHdrID)
	    Inner Join Term on (SalesInvoiceHeader. SlsInvceHdrTrmID = TrmID)
	    Left Outer Join SalesInvoiceHeader Parent on 	(Deferred.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	Deferred.SlsInvceHdrPrntID <> Deferred.SlsInvceHdrID)
    	inner join BusinessAssociateRelation bar on bar.BARltnBAID = SalesInvoiceHeader.SlsInvceHdrIntrnlBAID
	                                        and bar.BARltnRltn = 'T'
        inner join dynamiclistbox on dynlstbxtyp = term.TrmPymntMthd
                            and DynLstBxQlfr = 'Paytype'

Where	Deferred. SlsInvceHdrID = @i_SlsInvceHdrID

--Added Rounding Code Because the sp_calculate_due_date procedure that sets the Discount is summing all transactions then applying discount
-- instead of applying discount to each transaction.
UPDATE u SET u.DiscountValue = v.DiscountValue
FROM #temp u
INNER JOIN (
	SELECT t.SlsInvceHdrID,SUM(ROUND(ISNULL(ad.Value,0) * ISNULL(t.TrmDscnt,0),ISNULL(Currency.CrrncyRndngPrcsn,2))) DiscountValue
	FROM #temp t
	INNER JOIN SalesInvoiceDetail sid (NOLOCK) ON sid.SlsInvceDtlSlsInvceHdrID = t.SlsInvceHdrID AND ISNULL(t.DiscountValue,0) != 0
	INNER JOIN dbo.AccountDetail ad (NoLock) ON sid.SlsInvceDtlAcctDtlID = ad.AcctDtlID AND ad.AcctDtlSrceTble <> 'T'
	LEFT OUTER JOIN dbo.Currency WITH (NOLOCK) ON Currency.CrrncyID = t.CrrncyID
	GROUP BY t.SlsInvceHdrID
) v
ON u.SlsInvceHdrID = v.SlsInvceHdrID

SELECT duedte,TermVerbiage,TotalValue,DiscountDate,DiscountValue,InvoiceNumber,SlsInvceHdrID,CorrectingInvoiceNumber,SlsInvceHdrPstdDte,paymentterms
FROM #temp

GO

