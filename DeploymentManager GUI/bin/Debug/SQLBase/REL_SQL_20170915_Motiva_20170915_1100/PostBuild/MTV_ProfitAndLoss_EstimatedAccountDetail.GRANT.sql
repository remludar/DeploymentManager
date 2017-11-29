/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_EstimatedAccountDetail WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_EstimatedAccountDetail.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_EstimatedAccountDetail]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss_EstimatedAccountDetail TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss_EstimatedAccountDetail >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss_EstimatedAccountDetail >>>'

