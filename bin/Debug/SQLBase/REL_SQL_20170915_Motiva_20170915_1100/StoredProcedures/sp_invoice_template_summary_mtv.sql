/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_summary_mtv WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_summary_mtv]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_summary_mtv.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_summary_mtv]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_summary_mtv] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_summary_mtv >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER Procedure [dbo].sp_invoice_template_summary_mtv @i_SlsInvceHdrID Int
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
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

-- SECTION 1
Select	SalesInvoiceHeader. SlsInvceHdrDueDte 'duedte'
        , Term. TrmVrbge 'TermVerbiage'
        , SalesInvoiceHeader. SlsInvceHdrTtlVle 'TotalValue'
        , SalesInvoiceHeader. SlsInvceHdrDscntDte 'DiscountDate'
        , SalesInvoiceHeader. SlsInvceHdrDscntVle 'DiscountValue'
        , SalesInvoiceHeader. SlsInvceHdrNmbr  + case when SalesInvoiceHeader.DeferredInvoice = 'Y' then '*' else '' end 'InvoiceNumber'
	, SalesInvoiceHeader. SlsInvceHdrID 'SlsInvceHdrID'
	, IsNull(Parent.SlsInvceHdrNmbr, '') 'CorrectingInvoiceNumber'
	,SalesInvoiceHeader.SlsInvceHdrCrtnDte
From	SalesInvoiceHeader
	Left Outer Join SalesInvoiceHeader Parent on 	(SalesInvoiceHeader.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	SalesInvoiceHeader.SlsInvceHdrPrntID <> SalesInvoiceHeader.SlsInvceHdrID)
        Inner Join Term 			  on 	(SalesInvoiceHeader. SlsInvceHdrTrmID = TrmID)
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
	,DefferedTaxInvoice.SlsInvceHdrCrtnDte
From	SalesInvoiceHeader
        Inner Join SalesInvoiceHeaderRelation on (SalesInvoiceHeader. SlsInvceHdrID = SalesInvoiceHeaderRelation. SlsInvceHdrID)
        Inner Join SalesInvoiceHeader DefferedTaxInvoice on (RltdSlsInvceHdrID = DefferedTaxInvoice. SlsInvceHdrID)
	Inner Join Term on (DefferedTaxInvoice. SlsInvceHdrTrmID = TrmID)
	Left Outer Join SalesInvoiceHeader Parent on 	(SalesInvoiceHeader.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	SalesInvoiceHeader.SlsInvceHdrPrntID <> SalesInvoiceHeader.SlsInvceHdrID)

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
	, SalesInvoiceHeader.SlsInvceHdrCrtnDte
From	SalesInvoiceHeader Deferred
        Inner Join SalesInvoiceHeaderRelation 	on (Deferred. SlsInvceHdrID = SalesInvoiceHeaderRelation. RltdSlsInvceHdrID)
        Inner Join SalesInvoiceHeader  		on (SalesInvoiceHeaderRelation.SlsInvceHdrID = SalesInvoiceHeader. SlsInvceHdrID)
	Inner Join Term on (SalesInvoiceHeader. SlsInvceHdrTrmID = TrmID)
	Left Outer Join SalesInvoiceHeader Parent on 	(Deferred.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	Deferred.SlsInvceHdrPrntID <> Deferred.SlsInvceHdrID)
Where	Deferred. SlsInvceHdrID = @i_SlsInvceHdrID



GO


if OBJECT_ID('sp_invoice_template_summary_mtv')is not null begin
   --print "<<< Procedure sp_invoice_template_tax_summary_mtv_fsm created >>>"
   grant execute on sp_invoice_template_summary_mtv to sysuser, RightAngleAccess
end
else
   print "<<<< Creation of procedure sp_invoice_template_summary_mtv failed >>>"
