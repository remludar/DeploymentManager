/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_XrefAttributes WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_XrefAttributes [dbo].[v_MTV_XrefAttributes]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_XrefAttributes.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_XrefAttributes]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_XrefAttributes TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_XrefAttributes >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_XrefAttributes >>>'
GO
