/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSClassOfTradeXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTMSClassOfTradeXRef.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSClassOfTradeXRef]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSClassOfTradeXRef] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSClassOfTradeXRef >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSClassOfTradeXRef >>>'

