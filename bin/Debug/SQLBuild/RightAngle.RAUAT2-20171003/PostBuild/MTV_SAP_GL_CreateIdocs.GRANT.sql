/****** Object:  ViewName [dbo].[MTV_SAP_GL_CreateIdocs]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_GL_CreateIdocs.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_GL_CreateIdocs]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SAP_GL_CreateIdocs TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SAP_GL_CreateIdocs >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SAP_GL_CreateIdocs >>>'

