/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_Purge_TMSContracts WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[mtv_Purge_TMSContracts]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_Purge_TMSContracts.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_Purge_TMSContracts]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.mtv_Purge_TMSContracts TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure mtv_Purge_TMSContracts >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure mtv_Purge_TMSContracts >>>'

