/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[GetDeliveryPeriodRollOffBoardDate]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_GetDeliveryPeriodRollOffBoardDate.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetDeliveryPeriodRollOffBoardDate]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.GetDeliveryPeriodRollOffBoardDate TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure GetDeliveryPeriodRollOffBoardDate >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure GetDeliveryPeriodRollOffBoardDate >>>'
GO
