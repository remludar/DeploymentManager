   PRINT 'Start Script=sp_MTVTMSContractCheckForDataChanged.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSContractCheckForDataChanged]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTVTMSContractCheckForDataChanged TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTVTMSContractCheckForDataChanged >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTVTMSContractCheckForDataChanged >>>'
