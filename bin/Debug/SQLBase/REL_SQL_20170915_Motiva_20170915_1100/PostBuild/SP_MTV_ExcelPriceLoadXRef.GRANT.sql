/*
*****************************************************************************************************
USE FIND AND REPLACE ON ExcelPriceLoadXRef WITH YOUR stored procedure (NOTE:  GN_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_ExcelPriceLoadXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_ExcelPriceLoadXRef.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ExcelPriceLoadXRef]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_ExcelPriceLoadXRef TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_ExcelPriceLoadXRef >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_ExcelPriceLoadXRef >>>'
GO
