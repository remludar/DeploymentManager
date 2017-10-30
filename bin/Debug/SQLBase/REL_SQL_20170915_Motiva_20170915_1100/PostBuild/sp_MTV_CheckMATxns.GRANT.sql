/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_CheckMATxns WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_CheckMATxns]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_CheckMATxns.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_CheckMATxns]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_CheckMATxns TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_CheckMATxns >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_CheckMATxns >>>'
GO



