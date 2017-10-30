/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchInterfaceMessage WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchInterfaceMessage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchInterfaceMessage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchInterfaceMessage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SearchInterfaceMessage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SearchInterfaceMessage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SearchInterfaceMessage >>>'

