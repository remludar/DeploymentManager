/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[Motiva_FN_GetRawPriceValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_Motiva_FN_GetRawPriceValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_GetRawPriceValue]') IS NOT NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'Drop Function [dbo].[Motiva_FN_GetRawPriceValue]'
	PRINT '<<< DROPPED Function Motiva_FN_GetRawPriceValue >>>'
END
GO

IF  OBJECT_ID(N'[dbo].[Motiva_FN_GetRawPriceValue]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[Motiva_FN_GetRawPriceValue](@In VARCHAR(1)) RETURNS @TEST TABLE (TEST VARCHAR(1)) AS BEGIN INSERT @TEST SELECT 1 RETURN END'
			PRINT '<<< CREATED Function Motiva_FN_GetRawPriceValue >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER FUNCTION [dbo].[Motiva_FN_GetRawPriceValue] (@i_RwPrceLcleID int, @i_PriceTypeID int, @sdt_DateTime SmallDateTime, @vc_ActualEstimate varchar(2), @b_LastValid BIT)
Returns @Result TABLE (RwPrceLcleID int, RwPrceDtlID INT, RPDtlTpe CHAR(1), RPVle Float)  
AS

-- =============================================
-- Author:        Ravi Chenna
-- Create date:	  05/08/2016
-- Description:   function to get RawPriceValue for a curve based on pricetype and datetime
--				  if @i_RwPrceLcleID or @i_PriceTypeID is null return null (they are required parameters)
--				  if the requested type is average then get the computed value
--                if @sdt_DateTime is null then use todays date
--				  if vc_ActualEstimate is null then by default try to find estimate if not available try to find Estimate
--				  b_LastValid = 0 then looks for prices where the @sdt_DateTime is between from and to
--				  b_LastValid = 1 then looks for first price where from is less than @sdt_DateTime  
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------
-- SELECT dbo.Motiva_FN_GetRawPriceValue(6612,3,'05/12/2016', 'A', )

Begin

-------------------------------------------------------------------------------------------------------------------------------------------
-- Variable Declaration Section
-------------------------------------------------------------------------------------------------------------------------------------------
Declare @ExtValue  Float = NULL      --Holds our new account code
DECLARE @c_RPDtlTpe char(1) = NULL

IF @i_RwPrceLcleID IS NULL OR @i_PriceTypeID IS NULL 
  RETURN  


If IsNull(@sdt_DateTime, 0) = 0 
	select @sdt_DateTime = case when @b_LastValid  = 1 then DateAdd(DAY, -1, getDate()) ELSE getDate() END
	
DECLARE @i_RawPriceDetailID INT
SELECT @i_RawPriceDetailID = rpd.Idnty
	   ,@c_RPDtlTpe = rpd.RPDtlTpe FROM RawPriceDetail AS rpd WHERE rpd.RwPrceLcleID = @i_RwPrceLcleID 
and rpd.RPDtlTpe = IsNull(@vc_ActualEstimate, rpd.RPDtlTpe)	and rpd.RPDtlStts = 'A' AND @sdt_DateTime BETWEEN rpd.RPDtlQteFrmDte AND rpd.RPDtlQteToDte
	
--SELECT @i_RawPriceDetailID
	
IF @i_RawPriceDetailID IS NULL AND @b_LastValid = 1
	SELECT @i_RawPriceDetailID = k.Idnty
		   ,@c_RPDtlTpe = k.RPDtlTpe FROM (select top 1 rpd.Idnty, rpd.RPDtlTpe FROM RawPriceDetail AS rpd WHERE rpd.RwPrceLcleID = @i_RwPrceLcleID  and rpd.RPDtlStts = 'A' 
	AND rpd.RPDtlTpe = IsNull(@vc_ActualEstimate, rpd.RPDtlTpe) AND @sdt_DateTime > rpd.RPDtlQteFrmDte ORDER BY rpd.RPDtlQteFrmDte desc) k	
	
--SELECT @i_RawPriceDetailID	

IF @i_PriceTypeID <> 3
	select @ExtValue = RawPrice.RPVle FROM RawPrice WHERE RPRPDtlIdnty = @i_RawPriceDetailID	

IF @i_PriceTypeID = 3
	select @ExtValue = Sum(RawPrice.RPVle) * 0.5 FROM RawPrice where RawPrice.RPRPDtlIdnty = @i_RawPriceDetailID AND RawPrice.RPPrceTpeIdnty IN (1,2)

INSERT @Result(RwPrceLcleID, RwPrceDtlID, RPDtlTpe, RPVle) SELECT @i_RwPrceLcleID, @i_RawPriceDetailID, @c_RPDtlTpe, @ExtValue	
Return 

End



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[Motiva_FN_GetRawPriceValue]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'fn_Motiva_FN_GetRegistryValue.sql'
			PRINT '<<< ALTERED Function Motiva_FN_GetRawPriceValue >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function Motiva_FN_GetRawPriceValue >>>'
	  END