/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  CompanyName_FN_ is already set*************************************************************************************************
*/

/****** Object:  ViewName [dbo].[Motiva_fn_LookupTaxExtractValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=Motiva_fn_LookupTaxExtractValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_fn_LookupTaxExtractValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.Motiva_fn_LookupTaxExtractValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function Motiva_fn_LookupTaxExtractValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function Motiva_fn_LookupTaxExtractValue >>>'
