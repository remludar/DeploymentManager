/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVSearchSoldToShipToMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSearchSoldToShipToMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVSearchSoldToShipToMasterDataStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSearchSoldToShipToMasterDataStaging]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVSearchSoldToShipToMasterDataStaging TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVSearchSoldToShipToMasterDataStaging >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVSearchSoldToShipToMasterDataStaging >>>'

