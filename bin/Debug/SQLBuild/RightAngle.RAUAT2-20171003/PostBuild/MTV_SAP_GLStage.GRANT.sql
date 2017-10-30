
/****** Object:  ViewName [dbo].[MTV_SAP_GLStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_SAP_GLStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_GLStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAP_GLStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAP_GLStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAP_GLStage >>>'
GO
