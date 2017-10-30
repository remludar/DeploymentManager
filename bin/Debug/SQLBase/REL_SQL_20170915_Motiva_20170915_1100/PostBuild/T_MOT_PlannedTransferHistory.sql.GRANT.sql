/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MOT_PlannedTransferHistory.sql]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MOT_PlannedTransferHistory.sql.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_PlannedTransferHistory]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MOT_PlannedTransferHistory] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MOT_PlannedTransferHistory >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MOT_PlannedTransferHistory >>>'