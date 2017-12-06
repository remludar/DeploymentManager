/****** Object: [dbo].[MTVContractChangeStage]    Script Date: 09282015 ******/
PRINT 'Start Script=T_MTVContractChangeStage.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVContractChangeStage]') IS NOT NULL
  BEGIN
    GRANT SELECT, ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVContractChangeStage] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVContractChangeStage >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVContractChangeStage >>>'

