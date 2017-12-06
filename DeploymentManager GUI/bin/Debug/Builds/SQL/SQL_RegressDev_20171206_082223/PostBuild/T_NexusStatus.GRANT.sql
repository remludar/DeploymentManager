/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[NexusStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_NexusStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[NexusStatus]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[NexusStatus] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table NexusStatus >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table NexusStatus >>>'




