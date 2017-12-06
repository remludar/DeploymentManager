/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVInterfaceTranslationCache WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  v_MTVInterfaceTranslationCache [dbo].[v_MTVInterfaceTranslationCache]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVInterfaceTranslationCache.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVInterfaceTranslationCache]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTVInterfaceTranslationCache TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTVInterfaceTranslationCache >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTVInterfaceTranslationCache >>>'
GO
