/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_UpdateFPSProcessedStatusOnCustomInvoiceInterface >>>'
GO
