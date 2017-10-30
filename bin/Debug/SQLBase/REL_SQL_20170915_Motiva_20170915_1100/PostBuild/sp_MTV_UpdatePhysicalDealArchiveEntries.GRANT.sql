/*
*****************************************************************************************************
USE FIND AND REPLACE ON GetDealHeaderTemplateDetails WITH YOUR stored procedure (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_UpdatePhysicalDealArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_UpdatePhysicalDealArchiveEntries.sql  Domain=MPC  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdatePhysicalDealArchiveEntries]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_UpdatePhysicalDealArchiveEntries TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_UpdatePhysicalDealArchiveEntries >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_UpdatePhysicalDealArchiveEntries >>>'
GO
