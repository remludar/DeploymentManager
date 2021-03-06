/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVProductSeasonalityMonthDay]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVProductSeasonalityMonthDay.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVProductSeasonalityMonthDay]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVProductSeasonalityMonthDay] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVProductSeasonalityMonthDay >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVProductSeasonalityMonthDay >>>'
