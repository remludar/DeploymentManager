
/****** Object:  ViewName [dbo].[MTVDataLakePricesExport]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVDataLakePricesExport.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakePricesExport]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVDataLakePricesExport TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVDataLakePricesExport >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVDataLakePricesExport >>>'
GO
