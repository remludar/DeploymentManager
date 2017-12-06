/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FN_GetUOMConversionFactorSQLAsValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FN_GetUOMConversionFactorSQLAsValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FN_GetUOMConversionFactorSQLAsValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FN_GetUOMConversionFactorSQLAsValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function MTV_FN_GetUOMConversionFactorSQLAsValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function MTV_FN_GetUOMConversionFactorSQLAsValue >>>'

