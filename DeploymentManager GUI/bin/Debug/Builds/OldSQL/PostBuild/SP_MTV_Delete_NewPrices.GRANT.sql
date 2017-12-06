/****** Object:  ViewName [dbo].[MTV_Delete_NewPrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Delete_NewPrices.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Delete_NewPrices]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Delete_NewPrices TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Delete_NewPrices >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Delete_NewPrices >>>'

GO