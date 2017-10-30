/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVOrionNominationStagingRetrieve WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOrionNominationStagingRetrieve]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVOrionNominationStagingRetrieve.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVOrionNominationStagingRetrieve]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVOrionNominationStagingRetrieve TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVOrionNominationStagingRetrieve >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVOrionNominationStagingRetrieve >>>'
GO
