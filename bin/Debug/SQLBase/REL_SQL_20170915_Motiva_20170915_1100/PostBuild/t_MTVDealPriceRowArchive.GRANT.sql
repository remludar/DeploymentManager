
/****** Object:  ViewName [dbo].[MTVDealPriceRowArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealPriceRowArchive.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDealPriceRowArchive]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVDealPriceRowArchive TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDealPriceRowArchive >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDealPriceRowArchive >>>'

