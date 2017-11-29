/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_RequestMessage WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_RequestMessage [dbo].[v_RequestMessage]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_RequestMessage.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_RequestMessage]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_RequestMessage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_RequestMessage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_RequestMessage >>>'
GO
