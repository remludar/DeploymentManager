/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SCTExchangeReportExternalColumnSaved]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_SCTExchangeReportExternalColumnSaved.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SCTExchangeReportExternalColumnSaved]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SCTExchangeReportExternalColumnSaved TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SCTExchangeReportExternalColumnSaved >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SCTExchangeReportExternalColumnSaved >>>'
GO
