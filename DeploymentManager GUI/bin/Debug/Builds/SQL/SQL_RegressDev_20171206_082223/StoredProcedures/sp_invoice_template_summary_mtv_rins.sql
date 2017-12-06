/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_summary_mtv_rins WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_summary_mtv_rins]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_summary_mtv_rins.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_summary_mtv_rins]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_summary_mtv_rins] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_invoice_template_summary_mtv_rins >>>'
	  END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER Procedure [dbo].[sp_invoice_template_summary_mtv_rins] @i_SlsInvceHdrID Int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_summary  25         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Tracy Baird
-- History:	5/7/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	07/16/2002	HMD		27910	The deferred tax invoice needs to point to the product invoice so added
--						union all to get info for deferred tax's product invoice
--	09/16/2002	HMD		28904	Added correcting invoice number for the main invoice select
--	10/18/2002	HMD		29124	Added correcting invoice number for the deferred tax invoice select
--	12/30/2002	TSB		30884	Added Correcting Invoice Number to the Section 2 below.  Also added the joins 
--						to the parent invoice.  
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

-- SECTION 1
Select	SalesInvoiceHeader. SlsInvceHdrDueDte 'duedte'
        , Term. TrmVrbge 'TermVerbiage'
        , SalesInvoiceHeader. SlsInvceHdrTtlVle 'TotalValue'
        , SalesInvoiceHeader. SlsInvceHdrDscntDte 'DiscountDate'
        , SalesInvoiceHeader. SlsInvceHdrDscntVle 'DiscountValue'
        , SalesInvoiceHeader. SlsInvceHdrNmbr 'InvoiceNumber'
	, SalesInvoiceHeader. SlsInvceHdrID 'SlsInvceHdrID'
	, IsNull(Parent.SlsInvceHdrNmbr, '') 'CorrectingInvoiceNumber'
	,Currency.PrdctAbbv 'Currency'
From	SalesInvoiceHeader
	Left Outer Join SalesInvoiceHeader Parent on 	(SalesInvoiceHeader.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	SalesInvoiceHeader.SlsInvceHdrPrntID <> SalesInvoiceHeader.SlsInvceHdrID)
        Inner Join Term 			  on 	(SalesInvoiceHeader. SlsInvceHdrTrmID = TrmID)
	Inner Join Product Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.PrdctID
Where	SalesInvoiceHeader. SlsInvceHdrID = @i_SlsInvceHdrID


Union All
-- SECTION 2
Select	DefferedTaxInvoice. SlsInvceHdrDueDte
        , Term. TrmVrbge
        , DefferedTaxInvoice. SlsInvceHdrTtlVle
        , DefferedTaxInvoice. SlsInvceHdrDscntDte
        , DefferedTaxInvoice. SlsInvceHdrDscntVle
        , DefferedTaxInvoice. SlsInvceHdrNmbr
	, DefferedTaxInvoice. SlsInvceHdrID 
	, IsNull(Parent.SlsInvceHdrNmbr, '') 'CorrectingInvoiceNumber'
	,Currency.PrdctAbbv 'Currency'
From	SalesInvoiceHeader
        Inner Join SalesInvoiceHeaderRelation on (SalesInvoiceHeader. SlsInvceHdrID = SalesInvoiceHeaderRelation. SlsInvceHdrID)
        Inner Join SalesInvoiceHeader DefferedTaxInvoice on (RltdSlsInvceHdrID = DefferedTaxInvoice. SlsInvceHdrID)
	Inner Join Term on (DefferedTaxInvoice. SlsInvceHdrTrmID = TrmID)
	Left Outer Join SalesInvoiceHeader Parent on 	(SalesInvoiceHeader.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	SalesInvoiceHeader.SlsInvceHdrPrntID <> SalesInvoiceHeader.SlsInvceHdrID)
	Inner Join Product Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.PrdctID

Where	SalesInvoiceHeader. SlsInvceHdrID = @i_SlsInvceHdrID

Union All
--SECTION 3
Select	SalesInvoiceHeader. SlsInvceHdrDueDte
        , Term. TrmVrbge
        , SalesInvoiceHeader. SlsInvceHdrTtlVle
        , SalesInvoiceHeader. SlsInvceHdrDscntDte
        , SalesInvoiceHeader. SlsInvceHdrDscntVle
        , SalesInvoiceHeader. SlsInvceHdrNmbr
	, SalesInvoiceHeader. SlsInvceHdrID 
	--, '' 'CorrectingInvoiceNumber'
	, IsNull(Parent.SlsInvceHdrNmbr, '') 'CorrectingInvoiceNumber'
	,Currency.PrdctAbbv 'Currency'
From	SalesInvoiceHeader Deferred
        Inner Join SalesInvoiceHeaderRelation 	on (Deferred. SlsInvceHdrID = SalesInvoiceHeaderRelation. RltdSlsInvceHdrID)
        Inner Join SalesInvoiceHeader  		on (SalesInvoiceHeaderRelation.SlsInvceHdrID = SalesInvoiceHeader. SlsInvceHdrID)
	Inner Join Term on (SalesInvoiceHeader. SlsInvceHdrTrmID = TrmID)
	Left Outer Join SalesInvoiceHeader Parent on 	(Deferred.SlsInvceHdrPrntID = Parent.SlsInvceHdrID
						  and	Deferred.SlsInvceHdrPrntID <> Deferred.SlsInvceHdrID)
	Inner Join Product Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.PrdctID
Where	Deferred. SlsInvceHdrID = @i_SlsInvceHdrID

GO


IF  OBJECT_ID(N'[dbo].[sp_invoice_template_summary_mtv_rins]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_invoice_template_summary_mtv_rins.sql'
	PRINT '<<< ALTERED StoredProcedure sp_invoice_template_summary_mtv_rins >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_invoice_template_summary_mtv_rins >>>'
END
 


GO


