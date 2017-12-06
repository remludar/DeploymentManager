/****** Object:  ViewName [dbo].[sp_invoice_template_summary_mtv_bulk]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_summary_mtv_bulk.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO
if OBJECT_ID('sp_invoice_template_summary_mtv_bulk')is not null begin
   print '<<< Procedure sp_invoice_template_summary_mtv_bulk created >>>'
   grant execute on sp_invoice_template_summary_mtv_bulk to sysuser, RightAngleAccess
end
else
   print '<<<< Creation of procedure sp_invoice_template_summary_mtv_bulk failed >>>'


