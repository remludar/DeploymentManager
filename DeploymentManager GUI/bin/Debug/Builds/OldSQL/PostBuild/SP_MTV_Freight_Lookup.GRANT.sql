/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Freight_Lookup WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Freight_Lookup]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Freight_Lookup.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Freight_Lookup TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Freight_Lookup >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Freight_Lookup >>>'

