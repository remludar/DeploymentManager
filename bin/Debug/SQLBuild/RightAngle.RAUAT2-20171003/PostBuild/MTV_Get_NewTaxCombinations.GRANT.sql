/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Get_NewTaxCombinations WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_Get_NewTaxCombinations]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_NewTaxCombinations.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_NewTaxCombinations]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_Get_NewTaxCombinations TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_Get_NewTaxCombinations >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_Get_NewTaxCombinations >>>'

