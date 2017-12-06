/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[Motiva_fn_LookupTaxExtractValue]    Script Date: DATECREATED ******/
PRINT 'Start Script=Motiva_fn_LookupTaxExtractValue.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[Motiva_fn_LookupTaxExtractValue]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Function [dbo].[Motiva_fn_LookupTaxExtractValue](@In VARCHAR(1)) RETURNS VARCHAR(1) AS BEGIN DECLARE @OUT VARCHAR(1) SET @OUT = 1 RETURN @OUT END'
			PRINT '<<< CREATED Function Motiva_fn_LookupTaxExtractValue >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER FUNCTION [dbo].[Motiva_fn_LookupTaxExtractValue](@vc_Tab varchar(8000),  @vc_Entity varchar(50), @vc_Value varchar(50)) Returns VarChar(8000)
As
Begin
-- =============================================
-- Author:        YOURNAME
-- Create date:	  DATECREATED
-- Description:   SHORT DESCRIPTION OF WHAT THIS THINGS DOES\
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------
/***********  INSERT YOUR CODE HERE  ***********  */
-----------------------------------------------------------------------------------------------------------------------------

-- Name:	[Motiva_fn_LookupValue]           Copyright 2016 OpenLink
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- Created by:	Joseph McClean
-- History:	5/24/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	12/23/2005	Blake Doerr	63437	Added provision attributes to encapsulate logic for formula tablets
------------------------------------------------------------------------------------------------------------------------------
	
	Declare	@vc_ReturnValue VarChar(8000)

	If @vc_Tab = 'Properties'
	Begin
	    if @vc_Entity in ('Load Fee','Capped Tax','VAT Tax', 'Embedded Tax', 'Allow Exemption', 'Use Position Holder Logic', 'Invoiceable', 'Allowed Deferred Billing', 'Create Remittable','Invoiceable', 'Use Rack Logic')
			Begin 
				select @vc_ReturnValue = case when @vc_Value ='Y' then 'Yes' 
											  when @vc_Value = 'N' then 'No'
											  when @vc_Value = 'A' then 'Always Defer'
										  end
			End
       else
		  If @vc_Entity in ('No Buyer License Indicates', 'No Seller License Indicates')
			Begin 
				select @vc_ReturnValue = case when @vc_Value ='N' then 'Non-Exempt' 
										      when @vc_Value = 'E' then 'Exempt'
										      when @vc_Value = 'S' then 'Setup-Error'
									      end
			End
     END
	
	Return @vc_ReturnValue
End

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[Motiva_fn_LookupTaxExtractValue]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'Motiva_fn_LookupTaxExtractValue.sql'
			PRINT '<<< ALTERED Function Motiva_fn_LookupTaxExtractValue >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Function Motiva_fn_LookupTaxExtractValue >>>'
	  END