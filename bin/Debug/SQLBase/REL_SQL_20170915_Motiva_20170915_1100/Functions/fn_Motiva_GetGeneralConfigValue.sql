/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  MTV_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[MTV_GetGeneralConfigValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_MTV_GetGeneralConfigValue.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetGeneralConfigValue]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[MTV_GetGeneralConfigValue](@In VARCHAR(1)) RETURNS VARCHAR(1) AS BEGIN DECLARE @OUT VARCHAR(1) SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function MTV_GetGeneralConfigValue >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER FUNCTION [dbo].[MTV_GetGeneralConfigValue] (
   @Tablename VARCHAR(255)  
  ,@Attribute VARCHAR(255)  
  ,@HdrId  INT  
  ,@DtlId  INT = NULL  
)  
    
Returns varchar(255)  
AS  
  
-- =============================================  
-- Author:        Ryan Borgman  
-- Create date:   11/3/2014  
-- Description:   function to get the System setting  
-- =============================================  
-- Date         Modified By     Issue#  Modification  
-- -----------  --------------  ------  -----------------------------------------------------------------------------  
-- SELECT dbo.MTV_GetGeneralConfigValue('Tablename','Attribute',HdrId, DtlId)  
  
Begin  
  
-------------------------------------------------------------------------------------------------------------------------------------------  
-- Variable Declaration Section  
-------------------------------------------------------------------------------------------------------------------------------------------  
Declare @Value   VarChar(255)       --Holds our new account code  
  
-------------------------------------------------------------------------------------------------------------------------------------------  
-- Get KeyValue  
-------------------------------------------------------------------------------------------------------------------------------------------  
SELECT @Value = GnrlCnfgMulti  
FROM GeneralConfiguration  
WHERE GnrlCnfgTblNme = @Tablename  
AND  GnrlCnfgQlfr = @Attribute  
AND  GnrlCnfgHdrID = @HdrId  
AND  GnrlCnfgDtlID = IsNull(@DtlId,0)  
  
Return @Value  

End



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[MTV_GetGeneralConfigValue]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'fn_MTV_GetGeneralConfigValue.sql'
			PRINT '<<< ALTERED Function MTV_GetGeneralConfigValue >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function MTV_GetGeneralConfigValue >>>'
	  END