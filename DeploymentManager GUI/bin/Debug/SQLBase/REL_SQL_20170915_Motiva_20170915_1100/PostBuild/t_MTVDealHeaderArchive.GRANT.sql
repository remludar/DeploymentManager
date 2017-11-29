
/****** Object:  ViewName [dbo].[MTVDealHeaderArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealHeaderArchive.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealHeaderArchive]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVDealHeaderArchive TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealHeaderArchive >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealHeaderArchive >>>'

