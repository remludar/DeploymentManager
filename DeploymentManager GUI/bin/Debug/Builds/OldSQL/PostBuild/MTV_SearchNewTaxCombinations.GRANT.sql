/*
*****************************************************************************************************
USE FIND AND REPLACE ON MOT_Get_NewTaxCombinations WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MOT_SearchNewTaxCombinations]    Script Date: DATECREATED ******/
PRINT 'Start Script=MOT_SearchNewTaxCombinations.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MOT_SearchNewTaxCombinations]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MOT_SearchNewTaxCombinations TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MOT_SearchNewTaxCombinations  >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MOT_SearchNewTaxCombinations >>>'

