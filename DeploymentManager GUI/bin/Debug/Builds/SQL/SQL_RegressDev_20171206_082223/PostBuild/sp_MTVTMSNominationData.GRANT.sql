/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTV_TMSNominationData WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MTVTMSNominationData]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTMSNominationData.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSNominationData]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTVTMSNominationData TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTVTMSNominationData >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTVTMSNominationData >>>'

GO