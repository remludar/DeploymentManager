/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[T_MTVDemandForecastArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVDemandForecastArchive.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDemandForecastArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDemandForecastArchive] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDemandForecastArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDemandForecastArchive >>>'

