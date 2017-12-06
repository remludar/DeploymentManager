SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON 
GO

IF OBJECT_ID('dbo.tD_PayableDetail_MTV') IS NOT NULL
  BEGIN
    DROP TRIGGER dbo.tD_PayableDetail_MTV
    IF OBJECT_ID('dbo.tD_PayableDetail_MTV') IS NOT NULL
        PRINT '<<< FAILED DROPPING TRIGGER dbo.tD_PayableDetail_MTV >>>'
    ELSE
        PRINT '<<< DROPPED TRIGGER dbo.tD_PayableDetail_MTV >>>'
  END
go

-- ======================================================================
-- Author:		<Sanjay Kumar>
-- Create date: <6/6/2016>
-- Description:	<Captures Invoice Detail level links with Account Details>
-- ======================================================================

CREATE trigger [dbo].[tD_PayableDetail_MTV] on [dbo].[PayableDetail] for DELETE as
BEGIN

/*------------------------------------------------------- 
Add the link between PayableDetail and AccountDetail 
whenever PayableDetail is deleted.
-------------------------------------------------------*/
	
Insert MTV_InvoiceDetail_AccountDetail_DeleteLog
		(InvoiceHeaderId,
		 AccountDetailId,
		 InvoiceType,
		 CreatedDate)
		 Select Deleted.PybleHdrID,
				Deleted.PybleDtlID,
				'PH',
				GetDate()
				From Deleted
END
GO
