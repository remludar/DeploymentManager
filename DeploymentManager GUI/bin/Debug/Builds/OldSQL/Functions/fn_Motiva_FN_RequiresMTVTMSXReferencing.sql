/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[Motiva_FN_RequiresMTVTMSXReferencing]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_RequiresMTVTMSXReferencing.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_RequiresMTVTMSXReferencing]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[Motiva_FN_RequiresMTVTMSXReferencing](@ID int) RETURNS BIT AS BEGIN DECLARE @OUT BIT SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function Motiva_FN_RequiresMTVTMSXReferencing >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER FUNCTION [dbo].[Motiva_FN_RequiresMTVTMSXReferencing] (@ID int) RETURNS INT
AS

-- =============================================
-- Author:        Ravi Chenna	
-- Create date:	  10/22/2015
-- Description:   function to check if the elemica datarows require referencing data
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------
-- SELECT dbo.Motiva_FN_RequiresMTVTMSXReferencing('xxxx\xxxxx')
--12/07/2016 check more fields to see if it qualifies for xReferencing

Begin

-------------------------------------------------------------------------------------------------------------------------------------------
-- Variable Declaration Section
-------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @returnValue Int
--Select all row that exists with following condtions if it is N, M, or in E and if any of the required fields are null

SELECT @returnValue = 

CASE WHEN EXISTS(
	SELECT 1 FROM MTVTMSMovementStaging AS ms WHERE
	ms.MESID = @ID
	AND (ms.TicketStatus NOT IN ('C','F','A','I') OR ms.TicketStatus IS NULL) 
	AND ( 
	LTRIM(ISNULL(ms.RATemplateName,'')) = ''
	OR ms.RAPrdctID IS NULL
	OR ms.RAMvtDcmntBAID IS NULL
	OR ms.RAMvtHdrDte IS NULL
	OR ms.RAMvtDcmntDte IS NULL
	OR ms.RAMvtHdrOrgnLcleID IS NULL
	OR ms.RAMvtHdrDstntnLcleID IS NULL
	OR ms.RALcleID IS NULL 
	OR ms.RAMvtHdrQty IS NULL
	OR ms.RAMvtHdrTyp IS NULL
	OR ms.RAMvtHdrDsplyUOM IS NULL 
)) THEN 1 

ELSE CASE WHEN EXISTS(SELECT 1 FROM MTVTMSMovementStaging AS ms WHERE
	ms.MESID = @ID
	AND (ms.TicketStatus NOT IN ('C','F','A','I') OR ms.TicketStatus IS NULL) 
	AND ms.RAMvtHdrCrrrBAID IS NULL 
) THEN 2 

ELSE 0 END END
 
RETURN @returnValue

End


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[Motiva_FN_RequiresMTVTMSXReferencing]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'fn_Motiva_FN_RequiresMTVTMSXReferencing.sql'
			PRINT '<<< ALTERED Function Motiva_FN_RequiresMTVTMSXReferencing >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function Motiva_FN_RequiresMTVTMSXReferencing >>>'
	  END