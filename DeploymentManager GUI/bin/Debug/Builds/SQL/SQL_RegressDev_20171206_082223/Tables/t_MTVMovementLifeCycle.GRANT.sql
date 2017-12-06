/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVMovementLifeCycle]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVMovementLifeCycle.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVMovementLifeCycle]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].MTVMovementLifeCycle to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVMovementLifeCycle >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVMovementLifeCycle >>>'


