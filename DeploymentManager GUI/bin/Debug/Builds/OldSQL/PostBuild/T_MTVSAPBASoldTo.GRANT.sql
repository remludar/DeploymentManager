/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPBASoldTo WITH YOUR TABLE (NOTE:  is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPBASoldTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPBASoldTo.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPBASoldTo]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPBASoldTo] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVSAPBASoldTo >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVSAPBASoldTo >>>'
