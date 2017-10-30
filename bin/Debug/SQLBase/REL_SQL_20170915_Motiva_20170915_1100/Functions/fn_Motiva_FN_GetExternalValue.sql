/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[Motiva_FN_GetExternalValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_GetRegistryValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_GetExternalValue]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[Motiva_FN_GetExternalValue](@In VARCHAR(1)) RETURNS VARCHAR(1) AS BEGIN DECLARE @OUT VARCHAR(1) SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function Motiva_FN_GetExternalValue >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER FUNCTION [dbo].[Motiva_FN_GetExternalValue] (
  @RAValue VARCHAR(255), @Source VARCHAR(255) = NULL, @Qualifier VARCHAR(255) = NULL
)
  
Returns varchar(255)
AS

-- =============================================
-- Author:        David Colson
-- Create date:	  2/27/2013
-- Description:   function to get the System setting
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------
-- SELECT dbo.Motiva_FN_GetExternalValue(1,'BusinessAssociate','primarycontact')

Begin

-------------------------------------------------------------------------------------------------------------------------------------------
-- Variable Declaration Section
-------------------------------------------------------------------------------------------------------------------------------------------
Declare @ExtValue   VarChar(255)       --Holds our new account code

-------------------------------------------------------------------------------------------------------------------------------------------
-- Get KeyValue
-------------------------------------------------------------------------------------------------------------------------------------------
SELECT	@ExtValue = ExtValue
--select *
FROM	v_MTVInterfaceTranslationCache
WHERE	v_MTVInterfaceTranslationCache.RAValue = @RAValue
AND		v_MTVInterfaceTranslationCache.Source = @Source
AND		v_MTVInterfaceTranslationCache.Qualifier = @Qualifier

Return @ExtValue

End



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[Motiva_FN_GetExternalValue]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'fn_Motiva_FN_GetRegistryValue.sql'
			PRINT '<<< ALTERED Function Motiva_FN_GetExternalValue >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function Motiva_FN_GetExternalValue >>>'
	  END