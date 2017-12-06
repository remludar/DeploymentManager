/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: Motiva is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_InvoiceDetail_AccountDetail_DeleteLog.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTV_InvoiceDetail_AccountDetail_DeleteLog] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_InvoiceDetail_AccountDetail_DeleteLog >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_InvoiceDetail_AccountDetail_DeleteLog >>>'

