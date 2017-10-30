/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_FPSProductDiscountSurchargeEvaluator WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_FPSProductDiscountSurchargeEvaluator]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_FPSProductDiscountSurchargeEvaluator.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSProductDiscountSurchargeEvaluator]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_FPSProductDiscountSurchargeEvaluator] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_FPSProductDiscountSurchargeEvaluator >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_FPSProductDiscountSurchargeEvaluator] @SoldTo VARCHAR(20)
		,@ShipTo		VARCHAR(20)
		,@RADestLcleID	INT
		,@MaterialCode	VARCHAR(20)
		,@RAPrdctID		INT
		,@Plant			VARCHAR(20)
		,@RAOrigLcleID	INT
		,@MvtDte		SMALLDATETIME
		,@ConditionType	VARCHAR(4)
		,@GPC			VARCHAR(80)

AS

-- =============================================
-- Author:        rlb
-- Create date:	  DATECREATED
-- Description:   DiscountSurcharge Evaluator for FPS
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--MTV_FPSProductDiscountSurchargeEvaluator @SoldTo = '0012332030',@ShipTo = '0012313131',@Plant = '',@MaterialCode	= '',@MvtDte = '2015-03-15 00:00:00' ,@RAPrdctID = 513,@RAOrigLcleID	= 1912,@RADestLcleID	= 1912 ,@ConditionType	= 'YD41',@GPC			= '100'
-----------------------------------------------------------------------------
DECLARE	@PriceValue			FLOAT = NULL

DECLARE @LocationDiscSur TABLE
	(
	RABAID					INT
	,RAProductId			INT
	,RALocaleID				INT
	,RAToLocaleID			INT
	,RACurrencyID			INT
	,RAUOMID				INT
	,Value					FLOAT
	,FPSconditiontable		VARCHAR(80)
	,FPSsalesorg			VARCHAR(80)
	,FPSsoldtocode			VARCHAR(80)
	,FPSshiptocode			VARCHAR(80)
	,FPSplantcode			VARCHAR(80)
	,FPSproduct				VARCHAR(80)
	,FPSshippingcond		VARCHAR(80)
	,FPScustgroup			VARCHAR(80)
	);


--Reset GPC to real value instead of Attibute value (get down to 101 or 103 value sent from FPS)
SELECT	@GPC = RTRIM(LTRIM(LEFT(@GPC,CHARINDEX(' -',@GPC,0))))

--Let's just the Discounts for the conditiontype that is effective for that time period
INSERT	INTO @LocationDiscSur
SELECT	RABAID
		,RAProductId
		,RALocaleID
		,RAToLocaleID
		,RACurrencyID
		,RAUOMID
		,Value
		,FPSconditiontable
		,FPSsalesorg
		,FPSsoldtocode
		,FPSshiptocode
		,FPSplantcode
		,FPSproduct
		,FPSshippingcond
		,FPScustgroup
		--select *
FROM	MTVFPSDiscountSurcharge
WHERE	MTVFPSDiscountSurcharge.FPSconditiontype = @ConditionType
AND		@MvtDte BETWEEN StartDate and EndDate
AND		MTVFPSDiscountSurcharge.Status = 'A'

		--Let's check our ConditionTables according to logical order defined by FPS
		--610 - Sales Area/Sold-To/Ship-To/Plant/Material
		SELECT	@PriceValue = Value
		FROM	@LocationDiscSur LSD
		WHERE	LSD.FPSconditiontable = 610
		AND		LSD.FPSsoldtocode	= @SoldTo
		AND		LSD.FPSshiptocode	= @ShipTo
		AND		LSD.FPSplantcode	= @Plant
		AND		LSD.FPSproduct		= @MaterialCode

		--Let's check our ConditionTables according to logical order defined by FPS
		--612 - Sales Area/Sold-To/Ship-To/Shp Cond/Plant/Material
		SELECT	@PriceValue = Value
		FROM	@LocationDiscSur LSD
		WHERE	LSD.FPSconditiontable = 612
		AND		LSD.FPSsoldtocode	= @SoldTo
		AND		LSD.FPSshiptocode	= @ShipTo
		AND		LSD.FPSplantcode	= @Plant
		AND		LSD.FPSproduct		= @MaterialCode

		--604:Sales Area/Sold-To/Plant/Material
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 604
			AND		LSD.FPSsoldtocode	= @SoldTo
			AND		LSD.FPSplantcode	= @Plant
			AND		LSD.FPSproduct		= @MaterialCode	
		END

		--616:Sales Area/Sold-to/Ship-to/Shp.Cond./Material
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 616
			AND		LSD.FPSsoldtocode	= @SoldTo
			AND		LSD.FPSshiptocode	= @ShipTo
			AND		LSD.FPSproduct		= @MaterialCode
		END

		--768:Sales Area/Sold-To/Ship-To/Plant/GPC
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 768
			AND		LSD.FPSsoldtocode	= @SoldTo
			AND		LSD.FPSshiptocode	= @ShipTo
			AND		LSD.FPSplantcode	= @Plant
			AND		LSD.FPSproduct		= @GPC
		END

		--754:Sales Area/Sold-To/Ship-To/GPC
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 754
			AND		LSD.FPSsoldtocode	= @SoldTo
			AND		LSD.FPSshiptocode	= @ShipTo
			AND		LSD.FPSproduct		= @GPC
		END

		--659:Sales Area/Sold-To/Plant/GPC
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 659
			AND		LSD.FPSsoldtocode	= @SoldTo
			AND		LSD.FPSplantcode	= @Plant
			AND		LSD.FPSproduct		= @GPC

		END

		--607:Sales Area/Sold-to/Shp.Cond./Material
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 607
			AND		LSD.FPSsoldtocode	= @SoldTo
			AND		LSD.FPSproduct		= @MaterialCode
		END

		--757:Sales Area/Sold-To/GPC
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 757
			AND		LSD.FPSsoldtocode	= @SoldTo
			AND		LSD.FPSproduct		= @GPC
		END

		--623:Sales Area/Cust Group/Plant/Material
		--NOT USING Cust Group
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 623
			AND		LSD.FPSplantcode	= @Plant
			AND		LSD.FPSproduct		= @MaterialCode
		END

		--738:Sales Area/Plant/GPC
		IF @PriceValue IS NULL
		BEGIN
			SELECT	@PriceValue = Value
			FROM	@LocationDiscSur LSD
			WHERE	LSD.FPSconditiontable = 738
			AND		LSD.FPSplantcode	= @Plant
			AND		LSD.FPSproduct		= @GPC
		END

--IF	@ConditionType = 'YD37'
--BEGIN
--		SELECT	@PriceValue = (@PriceValue/100) * -1
--END

--IF	@ConditionType = 'YS80'
--BEGIN
--		SELECT	@PriceValue = (@PriceValue/100)
--END

SELECT ISNULL(@PriceValue,0)


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_FPSProductDiscountSurchargeEvaluator]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_FPSProductDiscountSurchargeEvaluator.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_FPSProductDiscountSurchargeEvaluator >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_FPSProductDiscountSurchargeEvaluator >>>'
	  END