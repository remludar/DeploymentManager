
/****** Object:  ViewName [dbo].[MTVArchiveDeal]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDeal.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDeal]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVArchiveDeal TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVArchiveDeal >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVArchiveDeal >>>'

