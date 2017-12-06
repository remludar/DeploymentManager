/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[Motiva_FN_RequiresMTVElemicaXReferencing]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_RequiresMTVElemicaXReferencing.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_RequiresMTVElemicaXReferencing]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[Motiva_FN_RequiresMTVElemicaXReferencing](@ID int) RETURNS BIT AS BEGIN DECLARE @OUT BIT SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function Motiva_FN_RequiresMTVElemicaXReferencing >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER FUNCTION [dbo].[Motiva_FN_RequiresMTVElemicaXReferencing] (@ID int) RETURNS BIT
AS

-- =============================================
-- Author:        Ravi Chenna	
-- Create date:	  10/22/2015
-- Description:   function to check if the elemica datarows require referencing data
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------
-- SELECT dbo.Motiva_FN_RequiresMTVElemicaXReferencing('xxxx\xxxxx')

Begin

-------------------------------------------------------------------------------------------------------------------------------------------
-- Variable Declaration Section
-------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @returnValue BIT

 SELECT @returnValue = CASE WHEN EXISTS(SELECT 1 FROM MTVElemicaStaging AS ms WHERE
 ms.MESID = @ID
 AND ms.TicketStatus NOT IN ('I', 'C') 
 AND ( 
 ms.RAMvtDcmntBAID IS NULL 
 OR ms.RALcleID IS NULL 
 OR ms.RAPrdctID IS NULL 
 OR ms.RAMvtHdrDsplyUOM IS NULL 
 OR ms.RAMvtHdrCrrrBAID IS NULL
 OR ms.RAMvtHdrOrgnLcleID IS NULL
 OR ms.RAMvtHdrDstntnLcleID IS NULL
 OR ms.RAMvtHdrTyp IS NULL
 OR ms.RAMvtHdrQty IS NULL
 OR ms.RAMvtHdrDte IS NULL
 )) THEN 1 ELSE 0 END
 
 RETURN @returnValue

End



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[Motiva_FN_RequiresMTVElemicaXReferencing]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'fn_Motiva_FN_RequiresMTVElemicaXReferencing.sql'
			PRINT '<<< ALTERED Function Motiva_FN_RequiresMTVElemicaXReferencing >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function Motiva_FN_RequiresMTVElemicaXReferencing >>>'
	  END