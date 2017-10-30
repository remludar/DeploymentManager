/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVSearchCustomerMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSearchCustomerMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVSearchSoldToMasterDataStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSearchSoldToMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSearchSoldToMasterDataStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSearchSoldToMasterDataStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSearchSoldToMasterDataStaging >>>'

