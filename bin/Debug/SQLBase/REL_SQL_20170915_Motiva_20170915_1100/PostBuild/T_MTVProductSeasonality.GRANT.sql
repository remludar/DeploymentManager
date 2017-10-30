/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVProductSeasonality]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVProductSeasonality.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVProductSeasonality]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVProductSeasonality] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVProductSeasonality >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVProductSeasonality >>>'
