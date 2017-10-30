


PRINT 'Start Script=t_MTVTaxNewCombinationSummary.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVTaxNewCombinationSummary]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].MTVTaxNewCombinationSummary to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table dbo.MTVTaxNewCombinationSummary >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table dbo.MTVTaxNewCombinationSummary >>>'
