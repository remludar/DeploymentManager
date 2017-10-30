/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_StarMailStage WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_StarMailStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_StarMailStage.GRANT.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
	' on ' + @@SERVERNAME + '.' + db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_StarMailStage]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_StarMailStage TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_StarMailStage >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_StarMailStage >>>'
GO
