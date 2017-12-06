PRINT 'Start Script=sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>'
GO
