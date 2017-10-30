/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_search_ba_expiring_licenses WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[mtv_search_ba_expiring_licenses]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_search_ba_expiring_licenses.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_search_ba_expiring_licenses]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.mtv_search_ba_expiring_licenses TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure mtv_search_ba_expiring_licenses >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure mtv_search_ba_expiring_licenses >>>'
GO
