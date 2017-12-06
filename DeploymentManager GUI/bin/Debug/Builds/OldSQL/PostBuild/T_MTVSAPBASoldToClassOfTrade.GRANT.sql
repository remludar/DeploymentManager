/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPBASoldToClassOfTrade WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPBASoldToClassOfTrade]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPBASoldToClassOfTrade.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPBASoldToClassOfTrade]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPBASoldToClassOfTrade] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPBASoldToClassOfTrade >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPBASoldToClassOfTrade >>>'
