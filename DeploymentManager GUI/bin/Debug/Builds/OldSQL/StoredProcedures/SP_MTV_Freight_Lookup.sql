/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Freight_Lookup WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Freight_Lookup]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Freight_Lookup.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Freight_Lookup] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Freight_Lookup >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Freight_Lookup]
	(
	@i_TxRleStID		Int,
	@i_DlDtlPrvsnID		Int,
	@i_XHdrID			Int,
	@i_PriceType		VARCHAR(50) = 'Posting',-- Posting--pricetype
	@vc_RPHdrCde		Varchar(5), --Frt, Fuel, Miles
	@i_PricingPrdctID	Int = NULL
	)
AS

-- =============================================
-- Author:        rlb
-- Create date:	  09/22/2016
-- Description:   This SP will look up freight costs to be used in variables
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare @i_BAID					Int
Declare @i_RPHdrID				Int

Declare	@i_FromLcleID			Int
Declare	@i_ToLcleID				Int
Declare @i_PrdctID				Int
Declare @i_RwPrceLcleID			Int
Declare @i_PriceTypeID			Int
Declare @GlblPrdctID			INT

Declare @flt_Rate				Float

Declare @sdt_MovementDate		SmallDateTime

SELECT	@GlblPrdctID = prdctid from product where product.PrdctNme = 'Global Product'

----------------------------------------------------------------------------------------------------------------------
-- Find price type
----------------------------------------------------------------------------------------------------------------------
SELECT @i_PriceTypeID = Idnty from pricetype where PrceTpeNme = @i_PriceType

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find price type
----------------------------------------------------------------------------------------------------------------------
SELECT @i_PriceTypeID = Idnty from pricetype where PrceTpeNme = @i_PriceType

If @i_PriceTypeID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price type.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Look up the BA on the Tax as this will be the carrier
----------------------------------------------------------------------------------------------------------------------
Select	@i_BAID = Tax.TaxAuthorityBAID
--select *
From	dbo.TaxRuleSet (NoLock)
		Inner Join Tax (NoLock) on Tax.TxID = TaxRuleSet.TxID
Where	TaxRuleSet.TxRleStID = @i_TxRleStID

----------------------------------------------------------------------------------------------------------------------
-- Get Movement Data off of the transaction
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_MovementDate = TransactionHeader.MovementDate,
		@i_FromLcleID = MovementHeader.MvtHdrOrgnLcleID,
		@i_ToLcleID = MovementHeader.MvtHdrDstntnLcleID,
		@i_PrdctID = MovementHeader.MvtHdrPrdctID
		--select *
From	dbo.TransactionHeader (NoLock)
		Inner Join dbo.MovementHeader (NoLock) On  MovementHeader.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
Where	TransactionHeader.XHdrID = @i_XHdrID

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find origin
----------------------------------------------------------------------------------------------------------------------
If @i_FromLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the origin location.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find Destination
----------------------------------------------------------------------------------------------------------------------
If @i_ToLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the destination location.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- If not passed in a pricing product then use the one on the movement
----------------------------------------------------------------------------------------------------------------------
If @i_PricingPrdctID is Null
Begin
	Select	@i_PricingPrdctID = @i_PrdctID
End

----------------------------------------------------------------------------------------------------------------------
-- Get the price service
----------------------------------------------------------------------------------------------------------------------
Select	Top 1
		@i_RPHdrID = RPHdrID
From	dbo.RawPriceHeader
Where	RPHdrBAID = @i_BAID
And		RPHdrCde = @vc_RPHdrCde
And		RPHdrStts = 'A'

If @i_RPHdrID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price service.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Get price curve based on type of freight
----------------------------------------------------------------------------------------------------------------------
IF	@vc_RPHdrCde IN ('Frt', 'Miles')
BEGIN

		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @i_PricingPrdctID
		And		RPLcleLcleID = @i_FromLcleID
		And		ToLcleID = @i_ToLcleID

		If @i_RwPrceLcleID is Null
	BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
		And		RPLcleLcleID = @i_FromLcleID
		And		ToLcleID = @i_ToLcleID
	END
END
IF @vc_RPHdrCde IN ('Fuel')
BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
END
IF @vc_RPHdrCde IN ('Clean','Misc')
BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleLcleID = @i_FromLcleID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
END

If @i_RwPrceLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price curve.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Get freight price
----------------------------------------------------------------------------------------------------------------------
Select	@flt_Rate = RawPrice.RPVle
From	RawPriceDetail
		Inner Join RawPrice		On	RawPrice.RPRPDtlIdnty = RawPriceDetail.Idnty
								And	RawPrice.RPPrceTpeIdnty = @i_PriceTypeID
Where	RawPriceDetail.RwPrceLcleID = @i_RwPrceLcleID
And		@sdt_MovementDate Between RawPriceDetail.RPDtlQteFrmDte And RawPriceDetail.RPDtlQteToDte

If @flt_Rate is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to a freight rate for the movement date.',61000)
	Select 0.0
	Return
End


Select @flt_Rate

GO


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Freight_Lookup.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Freight_Lookup >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Freight_Lookup >>>'
	  END/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Freight_Lookup WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Freight_Lookup]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Freight_Lookup.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Freight_Lookup] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Freight_Lookup >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Freight_Lookup]
	(
	@i_TxRleStID		Int,
	@i_DlDtlPrvsnID		Int,
	@i_XHdrID			Int,
	@i_PriceType		VARCHAR(50) = 'Posting',-- Posting--pricetype
	@vc_RPHdrCde		Varchar(5), --Frt, Fuel, Miles
	@i_PricingPrdctID	Int = NULL
	)
AS

-- =============================================
-- Author:        rlb
-- Create date:	  09/22/2016
-- Description:   This SP will look up freight costs to be used in variables
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare @i_BAID					Int
Declare @i_RPHdrID				Int

Declare	@i_FromLcleID			Int
Declare	@i_ToLcleID				Int
Declare @i_PrdctID				Int
Declare @i_RwPrceLcleID			Int
Declare @i_PriceTypeID			Int
Declare @GlblPrdctID			INT

Declare @flt_Rate				Float

Declare @sdt_MovementDate		SmallDateTime

SELECT	@GlblPrdctID = prdctid from product where product.PrdctNme = 'Global Product'

----------------------------------------------------------------------------------------------------------------------
-- Find price type
----------------------------------------------------------------------------------------------------------------------
SELECT @i_PriceTypeID = Idnty from pricetype where PrceTpeNme = @i_PriceType

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find price type
----------------------------------------------------------------------------------------------------------------------
SELECT @i_PriceTypeID = Idnty from pricetype where PrceTpeNme = @i_PriceType

If @i_PriceTypeID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price type.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Look up the BA on the Tax as this will be the carrier
----------------------------------------------------------------------------------------------------------------------
Select	@i_BAID = Tax.TaxAuthorityBAID
--select *
From	dbo.TaxRuleSet (NoLock)
		Inner Join Tax (NoLock) on Tax.TxID = TaxRuleSet.TxID
Where	TaxRuleSet.TxRleStID = @i_TxRleStID

----------------------------------------------------------------------------------------------------------------------
-- Get Movement Data off of the transaction
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_MovementDate = TransactionHeader.MovementDate,
		@i_FromLcleID = MovementHeader.MvtHdrOrgnLcleID,
		@i_ToLcleID = MovementHeader.MvtHdrDstntnLcleID,
		@i_PrdctID = MovementHeader.MvtHdrPrdctID
		--select *
From	dbo.TransactionHeader (NoLock)
		Inner Join dbo.MovementHeader (NoLock) On  MovementHeader.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
Where	TransactionHeader.XHdrID = @i_XHdrID

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find origin
----------------------------------------------------------------------------------------------------------------------
If @i_FromLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the origin location.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Raise an error if unable to find Destination
----------------------------------------------------------------------------------------------------------------------
If @i_ToLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the destination location.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- If not passed in a pricing product then use the one on the movement
----------------------------------------------------------------------------------------------------------------------
If @i_PricingPrdctID is Null
Begin
	Select	@i_PricingPrdctID = @i_PrdctID
End

----------------------------------------------------------------------------------------------------------------------
-- Get the price service
----------------------------------------------------------------------------------------------------------------------
Select	Top 1
		@i_RPHdrID = RPHdrID
From	dbo.RawPriceHeader
Where	RPHdrBAID = @i_BAID
And		RPHdrCde = @vc_RPHdrCde
And		RPHdrStts = 'A'

If @i_RPHdrID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price service.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Get price curve based on type of freight
----------------------------------------------------------------------------------------------------------------------
IF	@vc_RPHdrCde IN ('Frt', 'Miles')
BEGIN

		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @i_PricingPrdctID
		And		RPLcleLcleID = @i_FromLcleID
		And		ToLcleID = @i_ToLcleID

		If @i_RwPrceLcleID is Null
	BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
		And		RPLcleLcleID = @i_FromLcleID
		And		ToLcleID = @i_ToLcleID
	END
END
IF @vc_RPHdrCde IN ('Fuel')
BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
END
IF @vc_RPHdrCde IN ('Clean','Misc')
BEGIN
		Select	@i_RwPrceLcleID = RwPrceLcleID
		From	dbo.RawPriceLocale
		Where	RPLcleRPHdrID = @i_RPHdrID
		And		RPLcleLcleID = @i_FromLcleID
		And		RPLcleChmclParPrdctID = @GlblPrdctID
END

If @i_RwPrceLcleID is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to find the price curve.',61000)
	Select 0.0
	Return
End

----------------------------------------------------------------------------------------------------------------------
-- Get freight price
----------------------------------------------------------------------------------------------------------------------
Select	@flt_Rate = RawPrice.RPVle
From	RawPriceDetail
		Inner Join RawPrice		On	RawPrice.RPRPDtlIdnty = RawPriceDetail.Idnty
								And	RawPrice.RPPrceTpeIdnty = @i_PriceTypeID
Where	RawPriceDetail.RwPrceLcleID = @i_RwPrceLcleID
And		@sdt_MovementDate Between RawPriceDetail.RPDtlQteFrmDte And RawPriceDetail.RPDtlQteToDte

If @flt_Rate is Null
Begin
	RAISERROR (N'%s %d',11,1,N'Unable to a freight rate for the movement date.',61000)
	Select 0.0
	Return
End


Select @flt_Rate

GO


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Freight_Lookup]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Freight_Lookup.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Freight_Lookup >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Freight_Lookup >>>'
	  END