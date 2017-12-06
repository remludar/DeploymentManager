/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_Transportation_Method WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Get_Transportation_Method]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_Transportation_Method.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_Transportation_Method]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Get_Transportation_Method TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Get_Transportation_Method >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Get_Transportation_Method >>>'

