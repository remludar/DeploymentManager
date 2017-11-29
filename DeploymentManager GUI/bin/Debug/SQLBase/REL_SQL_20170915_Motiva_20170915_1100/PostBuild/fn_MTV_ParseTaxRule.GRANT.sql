/*
*****************************************************************************************************
USE FIND AND REPLACE ON ParseTaxRule WITH YOUR function (NOTE:  CompanyName_FN_ is already set*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[FN_ParseTaxRule]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_ParseTaxRule.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[fn_MTV_ParseTaxRule]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.fn_MTV_ParseTaxRule TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function fn_MTV_ParseTaxRule >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function fn_MTV_ParseTaxRule >>>'
