/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_details_mtv_bulk_summary.GRANT WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_details_mtv_bulk_summary.GRANT]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_details_mtv_bulk_summary.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv_bulk_summary]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_details_mtv_bulk_summary TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_details_mtv_bulk_summary.GRANT >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_details_mtv_bulk_summary.GRANT >>>'
