



/****** Object:  ViewName [dbo].[sp_MTVTaxDetailInserted]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTaxDetailInserted.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTaxDetailInserted]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MTVTaxDetailInserted TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MTVTaxDetailInserted >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MTVTaxDetailInserted >>>'

GO