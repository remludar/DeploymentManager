/*
*****************************************************************************************************
USE FIND AND REPLACE ON OASActualXRef WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_OASActualXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_OASActualXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_OASActualXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_OASActualXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_OASActualXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_OASActualXRef >>>'
GO
