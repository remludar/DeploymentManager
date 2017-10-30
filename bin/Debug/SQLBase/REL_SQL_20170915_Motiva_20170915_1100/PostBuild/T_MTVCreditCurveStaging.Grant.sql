/*
*****************************************************************************************************
--USE FIND AND REPLACE ON T_MTVCreditCurveStaging 
*****************************************************************************************************
*/

/****** Object:  TableName [dbo].[MTVCreditCurveStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVCreditCurveStaging.GRANT.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditCurveStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVCreditCurveStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVCreditCurveStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVCreditCurveStaging >>>'
GO
