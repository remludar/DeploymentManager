/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_FSM_TransferPrice_Comparison WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_FSM_TransferPrice_Comparison]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Search_FSM_TransferPrice_Comparison.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_FSM_TransferPrice_Comparison]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_FSM_TransferPrice_Comparison TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_FSM_TransferPrice_Comparison >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_FSM_TransferPrice_Comparison >>>'

