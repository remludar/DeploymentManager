
/****** Object:  ViewName [dbo].[MTVArchiveDealPriceRows]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVArchiveDealPriceRows.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVArchiveDealPriceRows]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVArchiveDealPriceRows TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVArchiveDealPriceRows >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVArchiveDealPriceRows >>>'

