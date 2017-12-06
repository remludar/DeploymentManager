/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: Motiva is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MotivaBuildStatistics]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MotivaBuildStatistics.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MotivaBuildStatistics]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MotivaBuildStatistics] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MotivaBuildStatistics >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MotivaBuildStatistics >>>'

