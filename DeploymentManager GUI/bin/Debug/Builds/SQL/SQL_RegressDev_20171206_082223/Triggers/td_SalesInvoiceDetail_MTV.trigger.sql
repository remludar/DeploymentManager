SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tD_SalesInvoiceDetail_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tD_SalesInvoiceDetail_MTV
    IF OBJECT_ID('dbo.tD_SalesInvoiceDetail_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tD_SalesInvoiceDetail_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tD_SalesInvoiceDetail_MTV >>>'
  END
go

-- ======================================================================
-- Author:		<Sanjay Kumar>
-- Create date: <6/6/2016>
-- Description:	<Captures Invoice Detail level links with Account Details>
-- ======================================================================

CREATE trigger [dbo].[tD_SalesInvoiceDetail_MTV] on [dbo].[SalesInvoiceDetail] for DELETE as
BEGIN

/*------------------------------------------------------- 
Remove link between SalesInvoiceDetail and AccountDetail 
whenever SalesInvoiceDetail is deleted.
-------------------------------------------------------*/
	
Insert MTV_InvoiceDetail_AccountDetail_DeleteLog
		(InvoiceHeaderId,
		 AccountDetailId,
		 InvoiceType,
		 CreatedDate)
		 Select Deleted.SlsInvceDtlSlsInvceHdrID,
				Deleted.SlsInvceDtlAcctDtlID,
				'SH',
				GetDate()
				From Deleted
END
GO
