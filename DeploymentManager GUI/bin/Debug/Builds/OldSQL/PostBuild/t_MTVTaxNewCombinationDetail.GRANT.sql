


PRINT 'Start Script=t_MTVTaxNewCombinationDetail.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTaxNewCombinationDetail]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].MTVTaxNewCombinationDetail to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table dbo.MTVTaxNewCombinationDetail >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table dbo.MTVTaxNewCombinationDetail >>>'
