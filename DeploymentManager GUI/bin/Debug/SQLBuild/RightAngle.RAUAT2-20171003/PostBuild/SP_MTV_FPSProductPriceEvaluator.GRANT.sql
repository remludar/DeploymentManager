/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSProductPriceEvaluator WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FPSProductPriceEvaluator]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FPSProductPriceEvaluator.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSProductPriceEvaluator]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FPSProductPriceEvaluator TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FPSProductPriceEvaluator >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FPSProductPriceEvaluator >>>'

