/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_custom_all_exchdiff_statement_retrieve_details_with_regrades WITH YOUR stored procedure (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_OSPManualBOLXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_custom_all_exchdiff_statement_retrieve_details_with_regrades.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_custom_all_exchdiff_statement_retrieve_details_with_regrades]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.sp_custom_all_exchdiff_statement_retrieve_details_with_regrades TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure sp_custom_all_exchdiff_statement_retrieve_details_with_regrades >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure sp_custom_all_exchdiff_statement_retrieve_details_with_regrades >>>'
GO
