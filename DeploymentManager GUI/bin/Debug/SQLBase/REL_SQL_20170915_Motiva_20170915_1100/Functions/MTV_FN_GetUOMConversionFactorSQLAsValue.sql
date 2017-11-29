

/****** Object:  Function [dbo].[MTV_FN_GetUOMConversionFactorSQLAsValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FN_GetUOMConversionFactorSQLAsValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FN_GetUOMConversionFactorSQLAsValue]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[MTV_FN_GetUOMConversionFactorSQLAsValue](@ID int) RETURNS BIT AS BEGIN DECLARE @OUT BIT SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function MTV_FN_GetUOMConversionFactorSQLAsValue >>>'
	  END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


alter FUNCTION [dbo].MTV_FN_GetUOMConversionFactorSQLAsValue
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

DECLARE @f_SpecificGravityColumn float
DECLARE @f_EnergyColumn float

	   Select 	@f_SpecificGravityColumn = case when isnumeric(@vc_SpecificGravityColumn) = 1 then convert(Float, @vc_SpecificGravityColumn) else 1.0 end
	   Select	@f_EnergyColumn = case when isnumeric(@vc_EnergyColumn) = 1 then Convert(Float,@vc_EnergyColumn) else 1.0 end

	return

	IsNull((
	Select	v_UOMConversion.ConversionFactor / 
	Case	v_UOMConversion. FromUOMTpe + v_UOMConversion. ToUOMTpe
		When	'WV'
		Then	Case When @f_SpecificGravityColumn <> 0.0 Then @f_SpecificGravityColumn Else 1.0 End
		When	'VW'
		Then	1.0 / Case When @f_SpecificGravityColumn <> 0.0 Then @f_SpecificGravityColumn Else 1.0 End
		When	'EV'
		Then	Case When @f_EnergyColumn <> 0.0 Then @f_EnergyColumn Else 1.0 End
		When	'VE'
		Then	1.0 / Case When @vc_EnergyColumn <> 0.0 Then @f_EnergyColumn Else 1.0 End
		When	'WE'
		Then	@f_SpecificGravityColumn / Case When @vc_EnergyColumn <> 0.0 Then @vc_EnergyColumn Else 1.0 End
		When	'EW'
		Then	@f_EnergyColumn / Case When @f_SpecificGravityColumn <> 0.0 Then @f_SpecificGravityColumn Else 1.0 End
		Else	1.0
	End

	From	v_UOMConversion (NoLock)

	Where	v_UOMConversion.FromUOM	= @vc_FromUOMColumn
	And	v_UOMConversion.ToUOM	= @vc_ToUOMColumn
	), 1.0)

END




GO


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[MTV_FN_GetUOMConversionFactorSQLAsValue]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_FN_GetUOMConversionFactorSQLAsValue.sql'
			PRINT '<<< ALTERED Function MTV_FN_GetUOMConversionFactorSQLAsValue >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function MTV_FN_GetUOMConversionFactorSQLAsValue >>>'
	  END