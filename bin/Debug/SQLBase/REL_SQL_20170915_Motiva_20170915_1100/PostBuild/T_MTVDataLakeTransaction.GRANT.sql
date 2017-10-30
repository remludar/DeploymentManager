/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeTransaction]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeTransaction.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTransaction]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVDataLakeTransaction] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVDataLakeTransaction >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVDataLakeTransaction >>>'




