/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_footer_terminalstatement WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_footer_terminalstatement]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_footer_terminalstatement.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME + '.' + db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_footer_terminalstatement]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_footer_terminalstatement TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_footer_terminalstatement >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_footer_terminalstatement >>>'
GO
