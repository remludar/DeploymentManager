
/****** Object:  ViewName [dbo].[MTVArchiveDealDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDealDetails.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealDetails]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVArchiveDealDetails TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVArchiveDealDetails >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVArchiveDealDetails >>>'

