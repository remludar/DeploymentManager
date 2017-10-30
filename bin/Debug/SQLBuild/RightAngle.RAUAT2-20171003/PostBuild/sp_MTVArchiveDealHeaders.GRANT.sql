
/****** Object:  ViewName [dbo].[MTVArchiveDealHeaders]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDealHeaders.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealHeaders]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVArchiveDealHeaders TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVArchiveDealHeaders >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVArchiveDealHeaders >>>'

