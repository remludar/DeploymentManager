/****** Object:  ViewName [dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_UpdateYPPriceCurveUseForRiskFlag.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_UpdateYPPriceCurveUseForRiskFlag TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_UpdateYPPriceCurveUseForRiskFlag >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_UpdateYPPriceCurveUseForRiskFlag >>>'

GO