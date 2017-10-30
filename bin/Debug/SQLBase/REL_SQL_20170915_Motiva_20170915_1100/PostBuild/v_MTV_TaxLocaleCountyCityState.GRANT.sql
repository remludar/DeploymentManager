/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_TaxLocaleCountyCityState WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  v_MTV_TaxLocaleCountyCityState [dbo].[v_MTV_TaxLocaleCountyCityState]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxLocaleCountyCityState.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxLocaleCountyCityState]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_TaxLocaleCountyCityState TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_TaxLocaleCountyCityState >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_TaxLocaleCountyCityState >>>'
GO
