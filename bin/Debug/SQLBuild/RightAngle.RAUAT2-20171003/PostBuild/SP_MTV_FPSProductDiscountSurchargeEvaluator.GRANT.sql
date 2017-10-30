/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSProductDiscountSurchargeEvaluator WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FPSProductDiscountSurchargeEvaluator]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FPSProductDiscountSurchargeEvaluator.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSProductDiscountSurchargeEvaluator]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FPSProductDiscountSurchargeEvaluator TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FPSProductDiscountSurchargeEvaluator >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FPSProductDiscountSurchargeEvaluator >>>'

