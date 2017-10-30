/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[GetDeliveryPeriodRollOnBoardDate]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_GetDeliveryPeriodRollOnBoardDate.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetDeliveryPeriodRollOnBoardDate]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.GetDeliveryPeriodRollOnBoardDate TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure GetDeliveryPeriodRollOnBoardDate >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure GetDeliveryPeriodRollOnBoardDate >>>'
GO
