/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MPC_Statement_Detail_Mtv_TA WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[sp_MPC_Statement_Detail_Mtv_TA]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MPC_Statement_Detail_Mtv_TA.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_Detail_Mtv_TA]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_MPC_Statement_Detail_Mtv_TA TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>'
GO
