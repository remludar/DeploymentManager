/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSProductPriceEvaluator WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_FPSProductPriceEvaluator]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FPSProductPriceEvaluator.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSProductPriceEvaluator]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_FPSProductPriceEvaluator] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_FPSProductPriceEvaluator >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_FPSProductPriceEvaluator] 
		@SoldTo			VARCHAR(20)
		,@ShipTo		VARCHAR(20)
		,@RADestLcleID	INT
		,@MaterialCode	VARCHAR(20)
		,@RAPrdctID		INT
		,@Plant			VARCHAR(20)
		,@RAOrigLcleID	INT
		,@MvtDte		SMALLDATETIME
		,@ValueOrText	VARCHAR(1)
AS

-- =============================================
-- Author:        YOURNAME
-- Create date:	  DATECREATED
-- Description:   SHORT DESCRIPTION OF WHAT THIS THINGS DOES\
-- =============================================
-- Date         Modified By     Issue#  Modification
-- 6/2/2017		Matt V			6853	Updated this SP to be able to return the price value or textual price type based upon input param
-- -----------  --------------  ------  ---------------------------------------------------------------------
--MTV_FPSProductPriceEvaluator @SoldTo='1234567890',@ShipTo='1234567',@Plant='J027',@MaterialCode='400007617',@MvtDte='2015-03-11 00:00:00',@RAPrdctID= 513,@RAOrigLcleID= 1912	,@RADestLcleID= 1912
-----------------------------------------------------------------------------
DECLARE	@ContractPriceExists	CHAR(1) = 'N'
		,@ShipToOnly			CHAR(1) = 'N'
		,@PriceServiceID		INT
		,@PriceValue			FLOAT = NULL
		,@PriceType				VARCHAR(4) = ''

		--Let's get our PriceService so we can find the price
		SELECT	@PriceServiceID	= RPHdrID FROM RawPriceHeader WHERE RawPriceHeader.RPHdrNme = 'Contract-' + @SoldTo AND RawPriceHeader.RPHdrStts = 'A'

IF	@PriceServiceID IS NOT NULL
BEGIN
		--Let's get our value
		SELECT	@PriceValue = RPVle
				,@ContractPriceExists = 'Y'
				,@PriceType = 'YP06'
		FROM		RawPriceLocale (NOLOCK)
		INNER JOIN	RawPriceDetail  (NOLOCK)
		ON	RawPriceLocale.RwPrceLcleID = RawPriceDetail.RwPrceLcleID
		AND		@MvtDte BETWEEN RawPriceDetail.RPDtlQteFrmDte AND RawPriceDetail.RPDtlQteToDte
		AND	RawPriceDetail.RPDtlStts = 'A'
		INNER JOIN	RawPrice (NOLOCK)
		ON	RawPriceDetail.Idnty = RawPrice.RPRPDtlIdnty
		AND	RawPrice.Status = 'A'
		WHERE	RawPriceLocale.RPLcleRPHdrID			= @PriceServiceID
		AND		RawPriceLocale.RPLcleChmclParPrdctID	= @RAPrdctID
		AND		RawPriceLocale.RPLcleLcleID				= @RAOrigLcleID
		AND		RawPriceLocale.ToLcleID					= @RADestLcleID
		AND		RawPriceLocale.status = 'A'

		--If can not find a price by ShipTo, check to see if contract price is for terminal
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = RPVle
					,@ContractPriceExists = 'Y'
					,@PriceType = 'YP06'
					--select *
			FROM		RawPriceLocale (NOLOCK)
			INNER JOIN	RawPriceDetail  (NOLOCK)
			ON	RawPriceLocale.RwPrceLcleID = RawPriceDetail.RwPrceLcleID
			AND		@MvtDte BETWEEN RawPriceDetail.RPDtlQteFrmDte AND RawPriceDetail.RPDtlQteToDte
			AND	RawPriceDetail.RPDtlStts = 'A'
			INNER JOIN	RawPrice (NOLOCK)
			ON	RawPriceDetail.Idnty = RawPrice.RPRPDtlIdnty
			AND	RawPrice.Status = 'A'
			WHERE	RawPriceLocale.RPLcleRPHdrID			= @PriceServiceID
			AND		RawPriceLocale.RPLcleChmclParPrdctID	= @RAPrdctID
			AND		RawPriceLocale.RPLcleLcleID				= @RAOrigLcleID
			AND		RawPriceLocale.ToLcleID					= @RAOrigLcleID
			AND		RawPriceLocale.status = 'A'
		END
END

--Now, let's check to see if we are supposed to have a contract price
If @PriceValue IS NULL
BEGIN	
	--Check to see if Contract record exists
	SELECT	@ContractPriceExists = 'Y'
			--,@ShipToOnly		 = CASE WHEN LEN(MTVFPSContractPriceDates.FPSshiptocode) > 0 THEN 'Y' ELSE 'N' END
	FROM	MTVFPSContractPriceDates  (NOLOCK)
	WHERE	MTVFPSContractPriceDates.FPSsoldtocode	= @SoldTo
	AND		CASE WHEN LEN(MTVFPSContractPriceDates.FPSshiptocode) = 0 OR MTVFPSContractPriceDates.FPSshiptocode IS NULL
			THEN @ShipTo ELSE MTVFPSContractPriceDates.FPSshiptocode END = @ShipTo
	AND		MTVFPSContractPriceDates.FPSplantcode	= @Plant
	AND		MTVFPSContractPriceDates.FPSproduct		= @MaterialCode
	AND		@MvtDte BETWEEN MTVFPSContractPriceDates.ContractStartDate and MTVFPSContractPriceDates.ContractEndDate
	AND		MTVFPSContractPriceDates.Status			= 'A'

	IF	@ContractPriceExists = 'Y'
		SELECT	@PriceValue = -999
				,@PriceType = 'YP06'
END

--Since we don't have a YPCP Record, now we can look for the Rack Price
IF @ContractPriceExists = 'N'
BEGIN
	SELECT  @PriceServiceID = NULL

	SELECT	@PriceServiceID	=  RPHdrID 
	--select *
	FROM		RawPriceHeader (NOLOCK)
	INNER JOIN GeneralConfiguration (NOLOCK)
	ON		RawPriceHeader.RPHdrID = GeneralConfiguration.GnrlCnfgHdrID
	AND		GeneralConfiguration.GnrlCnfgQlfr =  'FPSConditionType'
	AND		GeneralConfiguration.GnrlCnfgMulti = 'YP02'
	WHERE	RawPriceHeader.RPHdrStts = 'A'

	IF	@PriceServiceID IS NOT NULL
		--Let's get our value
 		SELECT	@PriceValue = RPVle
				,@PriceType = 'YP02'
		FROM		RawPriceLocale (NOLOCK)
		INNER JOIN	RawPriceDetail  (NOLOCK)
		ON	RawPriceLocale.RwPrceLcleID = RawPriceDetail.RwPrceLcleID
		AND	RawPriceDetail.RPDtlStts = 'A'
		AND		@MvtDte BETWEEN RawPriceDetail.RPDtlQteFrmDte AND RawPriceDetail.RPDtlQteToDte
		INNER JOIN	RawPrice (NOLOCK)
		ON	RawPriceDetail.Idnty = RawPrice.RPRPDtlIdnty
		AND	RawPrice.Status = 'A'
		WHERE	RawPriceLocale.RPLcleRPHdrID			= @PriceServiceID
		AND		RawPriceLocale.RPLcleChmclParPrdctID	= @RAPrdctID
		AND		RawPriceLocale.RPLcleLcleID				= @RAOrigLcleID
		AND		RawPriceLocale.ToLcleID					= @RAOrigLcleID
		AND		RawPriceLocale.status = 'A'
END

IF @ValueOrText = 'V'
	SELECT	@PriceValue
ELSE IF @ValueOrText = 'T'
	SELECT	@PriceType

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSProductPriceEvaluator]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_FPSProductPriceEvaluator.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_FPSProductPriceEvaluator >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_FPSProductPriceEvaluator >>>'
	  END