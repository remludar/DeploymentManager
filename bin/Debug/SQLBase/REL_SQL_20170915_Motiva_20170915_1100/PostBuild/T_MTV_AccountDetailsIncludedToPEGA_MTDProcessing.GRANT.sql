/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_AccountDetailsIncludedToPEGA_MTDProcessing]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_AccountDetailsIncludedToPEGA_MTDProcessing.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_AccountDetailsIncludedToPEGA_MTDProcessing]') IS NOT NULL
  BEGIN
    GRANT SELECT, ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTV_AccountDetailsIncludedToPEGA_MTDProcessing] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_AccountDetailsIncludedToPEGA_MTDProcessing >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_AccountDetailsIncludedToPEGA_MTDProcessing >>>'
