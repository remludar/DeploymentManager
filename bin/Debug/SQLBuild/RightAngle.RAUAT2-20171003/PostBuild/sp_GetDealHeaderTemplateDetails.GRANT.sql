/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_GetDealHeaderTemplateDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_GetDealHeaderTemplateDetails.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_GetDealHeaderTemplateDetails]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_GetDealHeaderTemplateDetails TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_GetDealHeaderTemplateDetails >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_GetDealHeaderTemplateDetails >>>'
GO
