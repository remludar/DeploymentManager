/****** Object: [dbo].[MTVFPSRackPriceStaging]    Script Date: 09282015 ******/
PRINT 'Start Script=T_MTVFPSRackPriceStaging.GRANT.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSRackPriceStaging]') IS NOT NULL
  BEGIN
    GRANT SELECT, ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSRackPriceStaging] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSRackPriceStaging >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSRackPriceStaging >>>'

