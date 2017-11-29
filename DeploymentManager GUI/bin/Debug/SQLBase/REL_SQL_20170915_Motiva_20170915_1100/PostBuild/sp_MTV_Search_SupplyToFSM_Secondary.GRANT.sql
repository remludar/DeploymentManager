/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_SupplyToFSM_Secondary 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_SupplyToFSM_Secondary]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_Search_SupplyToFSM_Secondary.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_SupplyToFSM_Secondary]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_SupplyToFSM_Secondary TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_SupplyToFSM_Secondary >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_SupplyToFSM_Secondary >>>'
GO