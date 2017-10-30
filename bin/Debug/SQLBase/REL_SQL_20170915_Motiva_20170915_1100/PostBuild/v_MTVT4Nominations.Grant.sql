/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVT4Nominations WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVT4Nominations [dbo].[v_MTVT4Nominations]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVT4Nominations.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVT4Nominations]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTVT4Nominations TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTVT4Nominations >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTVT4Nominations >>>'
GO
