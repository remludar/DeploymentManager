/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_ExternalColumns WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss_ExternalColumns]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_ExternalColumns.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_ExternalColumns]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss_ExternalColumns TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss_ExternalColumns >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss_ExternalColumns >>>'

