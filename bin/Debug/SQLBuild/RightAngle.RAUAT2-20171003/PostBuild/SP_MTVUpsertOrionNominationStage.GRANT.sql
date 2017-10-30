/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVUpsertOrionNominationStage WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVUpsertOrionNominationStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVUpsertOrionNominationStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUpsertOrionNominationStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVUpsertOrionNominationStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVUpsertOrionNominationStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVUpsertOrionNominationStage >>>'
GO
