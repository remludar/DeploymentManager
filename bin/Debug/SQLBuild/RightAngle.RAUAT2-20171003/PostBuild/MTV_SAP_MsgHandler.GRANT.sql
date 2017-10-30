
/****** Object:  ViewName [dbo].[MTV_SAP_MsgHandler]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_MsgHandler.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_MsgHandler]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAP_MsgHandler TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAP_MsgHandler >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAP_MsgHandler >>>'
GO
