
   /****** Object:  ViewName [dbo].[STOREDPROCEDURENAME]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_details_mtv2_fsm.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv2_fsm]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_details_mtv2_fsm TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_details_mtv2_fsm >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_details_mtv2_fsm >>>'



