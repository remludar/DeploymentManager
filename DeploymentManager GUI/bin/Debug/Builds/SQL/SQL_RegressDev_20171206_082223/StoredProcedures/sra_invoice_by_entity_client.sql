IF OBJECT_ID('dbo.sra_invoice_by_entity_client') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.sra_invoice_by_entity_client
	PRINT '<<< DROPPED STORED PROCEDURE dbo.sra_invoice_by_entity_client >>>'
END
GO

CREATE PROCEDURE dbo.sra_invoice_by_entity_client 

AS
-------------------------------------------------------------------------------------------------------------------------------------------
-- SP:            sra_invoice_by_entity_client          
--
-- Overview:      
-- This procedure is designed to take 
--
-- Created by:		Mark Black
-- History:			Created 11/13/2013
--   Date Modified  Modified By         Modification
--   -------------  ------------------  ---------------------------------------------------------------------------------------------------
--exec sra_invoice_by_entity_client
-------------------------------------------------------------------------------------------------------------------------------------------
SET NOCOUNT ON
--So need to update the #invoicedetails temp table and set the cmmdtyid to the same for 
--all Rins and it's related product for.   So is the SalesInvoiceTypeID ok to use to 
--group by?   I believe so.   Change the cmmdty to the refined products one.
--Will need to change those to the correct
declare @i_SlsInvceTypID int,
		@vc_sql varchar(1000)

create table #InvoiceDetails (CombinedInvoiceStatement char, SlsInvceTypID int)

Declare @i_objectid int
select @i_objectid = (select top 1 object_id('tempdb..#InvoiceDetails')  from sysobjects (nolock) )

If @i_objectid is not null
Begin
	select @i_SlsInvceTypID = SlsInvceTpeID
	From dbo.SalesInvoiceType (nolock) 
	where SlsInvceTpeAbbrvtn IN ('Exchange Statement')
	
	select @vc_sql = 'update #InvoiceDetails
					set CombinedInvoiceStatement = ''Y''
					where CombinedInvoiceStatement = ''N''
					and SlsInvceTypID = ' + cast(@i_SlsInvceTypID as varchar)
	execute(@vc_sql)

	--Exch Diff Statement
	select @i_SlsInvceTypID = SlsInvceTpeID
	From dbo.SalesInvoiceType (nolock) 
	where SlsInvceTpeAbbrvtn IN ('Exch Diff Statement')

	select @vc_sql = 'update #InvoiceDetails
					set CombinedInvoiceStatement = ''Y''
					where CombinedInvoiceStatement = ''N''
					and SlsInvceTypID = ' + cast(@i_SlsInvceTypID as varchar)
	execute(@vc_sql)

	--'Exchange Dffrntl'
	select @i_SlsInvceTypID = SlsInvceTpeID
	From dbo.SalesInvoiceType (nolock) 
	where SlsInvceTpeAbbrvtn IN ('Exchange Dffrntl')


	select @vc_sql = 'update #InvoiceDetails
					set CombinedInvoiceStatement = ''Y''
					where CombinedInvoiceStatement = ''N''
					and SlsInvceTypID = ' + cast(@i_SlsInvceTypID as varchar)
	execute(@vc_sql)

		--'Exchange Dffrntl'
	select @i_SlsInvceTypID = SlsInvceTpeID
	From dbo.SalesInvoiceType (nolock) 
	where SlsInvceTpeAbbrvtn IN ('3rd Party Storage')


	select @vc_sql = 'update #InvoiceDetails
					set CombinedInvoiceStatement = ''Y''
					where CombinedInvoiceStatement = ''N''
					and SlsInvceTypID = ' + cast(@i_SlsInvceTypID as varchar)
	execute(@vc_sql)

/*************************************************************************************
*	End of new change for interim reversals and actual rebooks
************************************************************************************/	
End

GO


IF OBJECT_ID('dbo.sra_invoice_by_entity_client') IS NOT NULL
BEGIN
	PRINT '<<< CREATED STORED PROCEDURE dbo.sra_invoice_by_entity_client >>>'
	grant execute on dbo.sra_invoice_by_entity_client to sysuser
	grant execute on dbo.sra_invoice_by_entity_client to RightAngleAccess
END
ELSE
	PRINT '<<< FAILED TO CREATE STORED PROCEDURE dbo.sra_invoice_by_entity_client >>>'
GO
      
      

