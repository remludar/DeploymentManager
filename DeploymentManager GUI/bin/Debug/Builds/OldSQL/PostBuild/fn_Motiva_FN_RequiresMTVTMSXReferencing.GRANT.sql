/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[Motiva_FN_RequiresMTVTMSXReferencing]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_RequiresMTVTMSXReferencing.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_RequiresMTVTMSXReferencing]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.Motiva_FN_RequiresMTVTMSXReferencing TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function Motiva_FN_RequiresMTVTMSXReferencing >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function Motiva_FN_RequiresMTVTMSXReferencing >>>'

