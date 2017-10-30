/*
*****************************************************************************************************
USE FIND AND REPLACE ON OSPManualBOLXRef WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_OSPManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_OSPManualBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_OSPManualBOLXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_OSPManualBOLXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_OSPManualBOLXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_OSPManualBOLXRef >>>'
GO
