/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVUserBySecurityRole WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVUserBySecurityRole [dbo].[v_MTVUserBySecurityRole]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVUserBySecurityRole.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUserBySecurityRole]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVUserBySecurityRole TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View MTVUserBySecurityRole >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View MTVUserBySecurityRole >>>'
GO
