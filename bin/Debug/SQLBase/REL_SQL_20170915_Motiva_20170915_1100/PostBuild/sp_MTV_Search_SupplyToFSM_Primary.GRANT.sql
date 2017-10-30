/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_SupplyToFSM_Primary 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_SupplyToFSM_Primary]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_Search_SupplyToFSM_Primary.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_SupplyToFSM_Primary]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_SupplyToFSM_Primary TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_SupplyToFSM_Primary >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_SupplyToFSM_Primary >>>'
GO