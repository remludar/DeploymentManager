/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSStagePrices WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FPSStagePrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FPSStagePrices.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME + '.' + db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSStagePrices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FPSStagePrices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FPSStagePrices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FPSStagePrices >>>'
GO
