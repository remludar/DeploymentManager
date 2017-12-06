/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVCirDetail WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVCirDetail [dbo].[v_MTVCirDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVCirDetail.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCirDetail]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.MTVCirDetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View MTVCirDetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View MTVCirDetail >>>'
GO
