/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_RiskOverride_Trade]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_RiskOverride_Trade.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_RiskOverride_Trade]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTV_RiskOverride_Trade] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_RiskOverride_Trade >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_RiskOverride_Trade >>>'
