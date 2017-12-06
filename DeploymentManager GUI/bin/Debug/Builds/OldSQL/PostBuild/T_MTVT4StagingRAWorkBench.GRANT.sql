/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVT4StagingRAWorkBench]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVT4StagingRAWorkBench.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVT4StagingRAWorkBench]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVT4StagingRAWorkBench] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVT4StagingRAWorkBench >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVT4StagingRAWorkBench >>>'


