
/****** Object:  ViewName [dbo].[sp_invoice_template_details_mtv2_bulk]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_details_mtv2_bulk.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv2_bulk]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_details_mtv2_bulk TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_details_mtv2_bulk >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_details_mtv2_bulk >>>'

