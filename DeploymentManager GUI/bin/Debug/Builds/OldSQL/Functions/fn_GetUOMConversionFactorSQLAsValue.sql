/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[GetUOMConversionFactorSQLAsValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=fn_GetUOMConversionFactorSQLAsValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetUOMConversionFactorSQLAsValue]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[GetUOMConversionFactorSQLAsValue](@In VARCHAR(1)) RETURNS VARCHAR(1) AS BEGIN DECLARE @OUT VARCHAR(1) SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function GetUOMConversionFactorSQLAsValue >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER FUNCTION [dbo].[GetUOMConversionFactorSQLAsValue]
(
	-- Add the parameters for the function here
	@vc_FromUOMColumn		VarChar(256),
	@vc_ToUOMColumn			VarChar(256),
	@vc_SpecificGravityColumn	VarChar(256),
	@vc_EnergyColumn		VarChar(256)
)
RETURNS float
AS
BEGIN
	Select	@vc_SpecificGravityColumn = Convert(Float, @vc_SpecificGravityColumn)
	Select	@vc_EnergyColumn = Convert(Float,@vc_EnergyColumn)

	return

	IsNull((
	Select	v_UOMConversion.ConversionFactor / 
	Case	v_UOMConversion. FromUOMTpe + v_UOMConversion. ToUOMTpe
		When	'WV'
		Then	Case When @vc_SpecificGravityColumn <> 0.0 Then @vc_SpecificGravityColumn Else 1.0 End
		When	'VW'
		Then	1.0 / Case When @vc_SpecificGravityColumn <> 0.0 Then @vc_SpecificGravityColumn Else 1.0 End
		When	'EV'
		Then	Case When @vc_EnergyColumn <> 0.0 Then @vc_EnergyColumn Else 1.0 End
		When	'VE'
		Then	1.0 / Case When @vc_EnergyColumn <> 0.0 Then @vc_EnergyColumn Else 1.0 End
		When	'WE'
		Then	@vc_SpecificGravityColumn / Case When @vc_EnergyColumn <> 0.0 Then @vc_EnergyColumn Else 1.0 End
		When	'EW'
		Then	@vc_EnergyColumn / Case When @vc_SpecificGravityColumn <> 0.0 Then @vc_SpecificGravityColumn Else 1.0 End
		Else	1.0
	End

	From	v_UOMConversion (NoLock)

	Where	v_UOMConversion.FromUOM	= @vc_FromUOMColumn
	And	v_UOMConversion.ToUOM	= @vc_ToUOMColumn
	), 1.0)

END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[GetUOMConversionFactorSQLAsValue]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'fn_GetUOMConversionFactorSQLAsValue.sql'
			PRINT '<<< ALTERED Function GetUOMConversionFactorSQLAsValue >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function GetUOMConversionFactorSQLAsValue >>>'
	  END