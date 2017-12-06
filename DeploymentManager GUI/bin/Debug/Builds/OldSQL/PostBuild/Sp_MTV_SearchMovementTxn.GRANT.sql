/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchMovementTxn WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_SearchMovementTxn]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchMovementTxn.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchMovementTxn]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_SearchMovementTxn TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_SearchMovementTxn >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_SearchMovementTxn >>>'
GO
