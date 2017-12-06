/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[CompanyNameTABLENAME]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_GeneralComment.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GeneralComment]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTV_GeneralComment] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTV_GeneralComment >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTV_GeneralComment >>>'
GO

