/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchVendorMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchVendorMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVSearchContactMasterDataStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSearchContactMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSearchContactMasterDataStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSearchContactMasterDataStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSearchContactMasterDataStaging >>>'

