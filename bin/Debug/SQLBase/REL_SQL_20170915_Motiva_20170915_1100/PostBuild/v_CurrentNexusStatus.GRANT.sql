/*
*****************************************************************************************************
USE FIND AND REPLACE ON CurrentNexusStatus WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  CurrentNexusStatus [dbo].[v_CurrentNexusStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_CurrentNexusStatus.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_CurrentNexusStatus]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_CurrentNexusStatus TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_CurrentNexusStatus >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_CurrentNexusStatus >>>'
GO
