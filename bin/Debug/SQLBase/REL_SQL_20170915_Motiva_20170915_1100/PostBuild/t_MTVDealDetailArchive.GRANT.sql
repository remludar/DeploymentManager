
/****** Object:  ViewName [dbo].[MTVDealDetailArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailArchive.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealDetailArchive]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVDealDetailArchive TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealDetailArchive >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealDetailArchive >>>'

