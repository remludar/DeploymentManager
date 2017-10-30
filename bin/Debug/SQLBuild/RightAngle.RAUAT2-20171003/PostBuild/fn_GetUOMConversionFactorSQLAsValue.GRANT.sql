/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[GetUOMConversionFactorSQLAsValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=GetUOMConversionFactorSQLAsValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetUOMConversionFactorSQLAsValue]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.GetUOMConversionFactorSQLAsValue TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Function GetUOMConversionFactorSQLAsValue >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Function GetUOMConversionFactorSQLAsValue >>>'

