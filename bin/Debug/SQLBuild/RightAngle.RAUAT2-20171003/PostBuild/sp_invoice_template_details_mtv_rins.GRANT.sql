/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_details_mtv_rins WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_invoice_template_details_mtv_rins]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_invoice_template_details_mtv_rins.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv_rins]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_invoice_template_details_mtv_rins TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_invoice_template_details_mtv_rins >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_invoice_template_details_mtv_rins >>>'
GO
