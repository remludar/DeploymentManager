/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ProfitAndLoss]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ProfitAndLoss TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ProfitAndLoss >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ProfitAndLoss >>>'

