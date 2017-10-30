
/****** Object:  ViewName [dbo].[MTV_DLInvStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_DLInvStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_DLInvStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_DLInvStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_DLInvStage >>>'
GO
