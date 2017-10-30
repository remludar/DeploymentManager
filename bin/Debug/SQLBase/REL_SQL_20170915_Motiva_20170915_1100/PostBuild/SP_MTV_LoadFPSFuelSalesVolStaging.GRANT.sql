/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_LoadFPSFuelSalesVolStaging WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_LoadFPSFuelSalesVolStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_LoadFPSFuelSalesVolStaging.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_LoadFPSFuelSalesVolStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_LoadFPSFuelSalesVolStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_LoadFPSFuelSalesVolStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_LoadFPSFuelSalesVolStaging >>>'
GO
