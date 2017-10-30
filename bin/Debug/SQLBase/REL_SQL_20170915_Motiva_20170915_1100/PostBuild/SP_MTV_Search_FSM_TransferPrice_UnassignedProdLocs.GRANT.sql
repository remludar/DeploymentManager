/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Search_FSM_TransferPrice_UnassignedProdLocs WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Search_FSM_TransferPrice_UnassignedProdLocs]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Search_FSM_TransferPrice_UnassignedProdLocs.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Search_FSM_TransferPrice_UnassignedProdLocs]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Search_FSM_TransferPrice_UnassignedProdLocs TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Search_FSM_TransferPrice_UnassignedProdLocs >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Search_FSM_TransferPrice_UnassignedProdLocs >>>'

