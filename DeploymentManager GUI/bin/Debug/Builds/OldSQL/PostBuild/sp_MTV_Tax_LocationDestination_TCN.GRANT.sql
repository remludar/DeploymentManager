/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Tax_LocationDestination_TCN WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Tax_LocationDestination_TCN]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Tax_LocationDestination_TCN.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Tax_LocationDestination_TCN]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Tax_LocationDestination_TCN TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Tax_LocationDestination_TCN >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Tax_LocationDestination_TCN >>>'