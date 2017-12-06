
/****** Object:  ViewName [dbo].[MTV_DLInvStage_Complete]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_DLInvStage_Complete.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage_Complete]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_DLInvStage_Complete TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_DLInvStage_Complete >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_DLInvStage_Complete >>>'
GO
