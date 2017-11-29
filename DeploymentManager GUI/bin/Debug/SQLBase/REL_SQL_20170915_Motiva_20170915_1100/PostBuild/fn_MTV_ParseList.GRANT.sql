/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  CompanyName_FN_ is already set*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[fn_MTV_ParseList]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_ParseList.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[fn_MTV_ParseList]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.fn_MTV_ParseList TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function fn_MTV_ParseList >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function fn_MTV_ParseList >>>'
