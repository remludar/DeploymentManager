/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPhysicalDealArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPhysicalDealArchiveEntries.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVPhysicalDealArchiveEntries]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVPhysicalDealArchiveEntries] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVPhysicalDealArchiveEntries >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVPhysicalDealArchiveEntries >>>'

