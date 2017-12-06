/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_GetFPSFuelSalesVol WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_GetFPSFuelSalesVol]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_GetFPSFuelSalesVol.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetFPSFuelSalesVol]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_GetFPSFuelSalesVol TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_GetFPSFuelSalesVol >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_GetFPSFuelSalesVol >>>'
GO
