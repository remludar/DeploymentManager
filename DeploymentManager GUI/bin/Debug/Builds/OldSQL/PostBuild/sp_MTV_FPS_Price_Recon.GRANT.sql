/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPS_Price_Recon 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_FPS_Price_Recon]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_FPS_Price_Recon.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPS_Price_Recon]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_FPS_Price_Recon TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_FPS_Price_Recon >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_FPS_Price_Recon >>>'
