/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPriceLoad]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPriceLoad.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVPriceLoad]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVPriceLoad] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVPriceLoad >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVPriceLoad >>>'


