/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchVendorMasterDataStaging WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchVendorMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=MOT_ArchivePlannedTransferHistory.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_ArchivePlannedTransferHistory]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MOT_ArchivePlannedTransferHistory TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_ArchivePlannedTransferHistory >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_ArchivePlannedTransferHistory >>>'

