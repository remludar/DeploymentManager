/*
*****************************************************************************************************
USE FIND AND REPLACE ON PetroExBOLXRef WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_PetroExBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_PetroExBOLXRef.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_PetroExBOLXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_PetroExBOLXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_PetroExBOLXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_PetroExBOLXRef >>>'
GO
