/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_RiskAdjustment WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_ProfitAndLoss_RiskAdjustment]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_RiskAdjustment.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_RiskAdjustment]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ProfitAndLoss_RiskAdjustment] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ProfitAndLoss_RiskAdjustment >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ProfitAndLoss_RiskAdjustment]
							@i_P_EODSnpShtID		Int,
							@vc_P_PrtflioID			Varchar(8000) = Null,
							@i_AccntngPrdID_From		Int,
							@i_AccntngPrdID_To		Int,
							@sdt_DeliveryPeriod_From	smalldatetime = Null,
							@sdt_DeliveryPeriod_To		smalldatetime = Null,
							@vc_PrntBAID			Varchar(8000) = Null,
							@i_XGrpID			Int,
							@i_AccntngPrdID_Inventory	Int = Null,
							@vc_TrnsctnTypID		Varchar(8000) = Null,
							@vc_PrdctID			Varchar(8000) = Null,
							@vc_LcleID			Varchar(8000) = Null,
							@vc_DealNumber			Varchar(20)= Null,
							@vc_DlDtlTmplteID		Varchar(8000) = Null,
							@i_RiskID			Int = Null,
							@c_IsThisNavigation 		Char(1) 	= 'N',
							@i_RprtCnfgID			Int		= Null,
							@vc_AdditionalColumns		VarChar(8000)	= Null,
							@c_OnlyShowSQL			Char(1)		= 'N',
							@sdt_InstanceDateTime		SmallDateTime,
							@sdt_EndOfDay			SmallDateTime,
							@sdt_AccntngPrdBgnDte_SnapShotStart	SmallDateTime,
							@vc_WaterDensity		Varchar(80)
As


Declare @vc_SQL		Varchar(8000)
Declare	@vc_SQL_Select	VarChar(8000)
Declare	@vc_SQL_From	VarChar(8000)
Declare	@vc_SQL_Where	VarChar(8000)



Declare @sdt_AccntngPrdBgnDte_To SmallDateTime


-- START of pvcs 11204
-- START of pvcs 11204



Declare @sdt_AccntngPrdBgnDte_From SmallDateTime

-- END of pvcs 11204
-- END of pvcs 11204


-----------------------------------------------------------------------------------------------------------------
-- Get the BeginDate of the ending accountingperiod
-----------------------------------------------------------------------------------------------------------------
Select	@sdt_AccntngPrdBgnDte_To = AccountingPeriod.AccntngPrdBgnDte
From	AccountingPeriod (NoLock)
Where	AccountingPeriod.AccntngPrdID = @i_AccntngPrdID_To



/*
	Instead of using @sdt_AccntngPrdBgnDte_SnapShotStart
	the from date needs to be determined by looking up the 
	AccountingPeriod.AccntngPrdBgnDte using the @i_AccntngPrdID_From
	that is passed into the SP.

	
*/


-----------------------------------------------------------------------------------------------------------------
-- Get the Date of the From accountingperiod
-----------------------------------------------------------------------------------------------------------------
Select	@sdt_AccntngPrdBgnDte_From = AccountingPeriod.AccntngPrdBgnDte
From	AccountingPeriod (NoLock)
Where	AccountingPeriod.AccntngPrdID = @i_AccntngPrdID_From

-- END of pvcs 11204
-- END of pvcs 11204



-----------------------------------------------------------------------------------------------------------------
-- Set the delivery period variables if they are null
-----------------------------------------------------------------------------------------------------------------
Select @sdt_DeliveryPeriod_From = Isnull(@sdt_DeliveryPeriod_From,'1900-01-01 00:00')
Select @sdt_DeliveryPeriod_To = Isnull(@sdt_DeliveryPeriod_To,'2049-12-31 23:59')

-------------------------------------------------------------------------------------------
-- Build the snapshot select for the insert into the temp table
-----------------------------------------------------------------------------------------------------------------
Select	@vc_SQL_Select =
'
	Insert	#MTVProfitAndLoss_RiskAdj
	Select	RiskDealIdentifier.Description,
		NULL, --AcctDtlID
		NULL, --P_EODBAVID
		NULL, --P_EODEstmtedAccntDtlID
		Risk.RiskID, --RiskID
		NULL, --DlHdrID
		RiskDealIdentifier.DlDtlID,
		NULL, --PlnndTrnsfrID
		Risk.PrdctID,
		Risk.ChmclID,
		Risk.LcleID,
		NULL, --MvtHdrID
		NULL, --DlDtlPrvsnID
		NULL, --DlDtlPrvsnRwID
		Risk.TrnsctnTypID,
		Risk.AccountingPeriodStartDate,
		Risk.DeliveryPeriodStartDate,
		Risk.StrtgyID,
		Risk.InternalBAID,
		Risk.ExternalBAID,
		Null, --AcctDtlSrceTble
		Null, --AcctDtlSrceID
		"E", --BAV Source Table
		"E", -- EAD Source Table
		0.0, --ValuationGallons update RiskPosition
--		0.0, --NetGallons update from RiskPosition
--		0.0, --NetPounds update from RiskPosition
		0.0, --Position Gallons update from RiskPosition
		0.0, --PositionPounds update
		0.0, --TotalValue update from RiskValue
		0.0, --MarketValue update from RiskValue
		0.0, --TotalPnL update
		19, --PaymentCrrncyID
		19, --MarketCrncyID
		1.0, --TotalValueFXRate update
		1.0, --MarketValueFXRate update
		Risk.DlDtlTmplteID,
		Null, --SpecificGravity update
		Null, --Energy
		Case When Risk.IsPrimaryCost = 1 Then "P" Else "S" End,
		0, --DealValueMissing
		0, --MarketValueMissing
		"N", --IsFlat
		"N", --WePayTheyPay
		"N", --IsReversal
		NULL, --BAV_VETradePeriodID
		"N", -- ReceiptDelivery
		RiskDealIdentifier.OverrideInternalUserID,
		RiskAdjustment.LastChangeDate, --Trade Date
		Case When Risk.AccountingPeriodStartDate > Risk.DeliveryPeriodStartDate Then "Y" Else "N" End, -- ISPPA
		Risk.DeliveryPeriodStartDate,
		Null, --Whatif
		Null, --DlDtlPrvsnActual
		' + Convert(Varchar,@i_P_EODSnpShtID) + ', --p_EODSnpShtID
		"' + Convert(Varchar,@sdt_EndOfDay,120) + '", --COB
		NUll, --COB compare
		Null, --p_EODSnpShtID_Compare
		0.0, --PositionGallons_Compare
		0.0, --PositionPounds_Compare
		0.0, --TotalValue_Compare
		0.0, --MarketValue_Compare
		Null, --XDtlStat
		Null, --AcctDtlPrntID
		Null, --XHdrID
		Null, --XDtlID
		Null, --DlDtlPrvsnUOMID
		Null,  --DlDtlDsplyUOM
		NULL, --MarketVAlue_Override
		Null, --P_EODEstmtedAccntDtlID_Market
		Null, --AcctDtlID_Market
		Null, --Overridden by UserID
--		"", --DlHdrDscrptn
		Null, -- P_EODEstmtedAccntDtlVleID
		NULL, --TotalValue_Override
		NULL, -- UserID_OverriddenBy_Trade
		NULL, --PaymentDueDate
		NULL, --SalesInvoiceID
		NULL, --PurchaseInvoiceID
		1.0, --DiscountFactor
		0.0,  --DiscountFactor_Compare
		Null, --FlatPriceRwPrceLcleID
		Null, --FlatPricePriceTypeIdnty
		Null, --FlatPriceCurveName
		Null, --BaseMarketRwPrceLcleID
		Null, --BaseMarketCurveName
		Null, --FormulaOffset
		Null, --FormulaPercentage
		Null, --FormulaEvaluationID
		Null, --MarketRiskCurveID
		1.0, -- PricedInPercentage
		Null, --QuoteStartDate
		Null,  --QuoteEndDate
		"N", --IsWriteOnWriteOff
		0.0 --SystemInventoryValue
From	Risk (NoLock)
		Left Outer Join RiskAdjustment (NoLock)		On	RiskAdjustment.SourceID = Risk.RiskID
		Left Outer Join RiskDealIdentifier (NoLock) 	On	RiskDealIdentifier.RiskDealIdentifierID = Risk.RiskDealIdentifierID
'



-----------------------------------------------------------------------------------------------------------------------
-- The accounting period criteria will always be in our where clause
-- IsVolumeOnly will always be no
-- Source table will always = "E"
--	A=AccountDetail,B=Estimated Inventory,E=External,X=MovementTransaction,T=Timetransaction,P=Transfer
-- Cost Source table will always be "E"
-- Excluded accountdetails where source table is "IV" b/c these are inventory change
-----------------------------------------------------------------------------------------------------------------------

-- START of pvcs 11204

--  added @sdt_AccntngPrdBgnDte_From to Where 

-- END of pvcs 11204


Select	@vc_SQL_Where =
'
	Where	Risk.AccountingPeriodStartDate Between "' + Convert(varchar,@sdt_AccntngPrdBgnDte_From,120) + '" And "' + Convert(Varchar,@sdt_AccntngPrdBgnDte_To,120) + '"
	And	Risk.DeliveryPeriodStartDate Between "' + Convert(Varchar,@sdt_DeliveryPeriod_From,120) + '" And "'+ Convert(Varchar,@sdt_DeliveryPeriod_To,120) + '"
	And	Risk.IsInventoryValuationAdjustment		= 0
	And	Risk.IsVolumeOnly				= 0
	And	Risk.SourceTable				= "E"
	And	Risk.CostSourceTable				= "E"
	And	Risk. IsWriteOnWriteOff				= 0
'

--------------------------------------------------------------------------------------------------------------------------
-- If navigated to then use the navigation temp table
--------------------------------------------------------------------------------------------------------------------------
If @c_IsThisNavigation = 'Y'
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Exists
		(
		Select	1
		From	#MTVProfitAndLoss_Navigation (NoLock)
		Where	#MTVProfitAndLoss_Navigation.RiskID = Risk.RiskID
		)
'
End


If @vc_P_PrtflioID Is Not Null
Begin
	Select @vc_SQL_Where = @vc_SQL_Where + '
	And	Exists
		(
		Select	1
		From	#Strategies (NoLock)
		Where	#Strategies.StrtgyID = Risk.StrtgyID
		)
	'
End


--------------------------------------------------------------------------------------------------------------------------
-- If a parent BA was passed add an exists to the where clause
--------------------------------------------------------------------------------------------------------------------------
if @vc_PrntBAID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Exists
		(
		Select	1
		From	#BAs (NoLock)
		Where	#BAs.BAID = Risk.InternalBAID
		)
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a transaction group was passed then add an exists to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @i_XGrpID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Exists
		(
		Select	1
		From	#TransactionTypes (NoLock)
		Where	#TransactionTypes.TrnsctnTypID = Risk.TrnsctnTypID
		)
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a transaction type was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_TrnsctnTypID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Risk.TrnsctnTypID in (' + @vc_TrnsctnTypID + ')
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a product was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_PrdctID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Risk.PrdctID in (' + @vc_PrdctID + ')
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a locale was passed add it to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_LcleID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Risk.LcleID in (' + @vc_LcleID + ')
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a DealNumber was passed add an exists to the where clause
--------------------------------------------------------------------------------------------------------------------------
if @vc_DealNumber is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	RiskDealIdentifier.Description = "' + @vc_DealNumber + '"
'
End

--------------------------------------------------------------------------------------------------------------------------
-- If a DlDtlTmplteID was passed in add to the where clause
--------------------------------------------------------------------------------------------------------------------------
If @vc_DlDtlTmplteID is Not Null
Begin
	Select	@vc_SQL_Where = @vc_SQL_Where +
'	And	Risk.DlDtlTmplteID in (' + @vc_DlDtlTmplteID + ')
'
End





if @c_OnlyShowSQL = 'Y'
Begin
	select @vc_SQL_Select
	select @vc_SQL_Where
End
Else
Begin
	exec( @vc_SQL_Select + @vc_SQL_Where )
End

------------------------------------------------------------------------------------------------------------------------------
-- Update the risk adjustments that have Trader = Null, we have to do this b/c of the weird way some risk adjustments
-- were being uploaded
------------------------------------------------------------------------------------------------------------------------------

select	@vc_SQL = '
Update	#MTVProfitAndLoss_RiskAdj
Set	#MTVProfitAndLoss_RiskAdj.Trader = Users.UserID
From	Contact (NoLock)
	Inner Join Users (NoLock) On Users.UserCntctID = Contact.CntctID
Where	Contact.CntctLstNme + ", " + CntctFrstNme like "%" + Left(#MTVProfitAndLoss_RiskAdj.DealNumber,CharIndex("||",#MTVProfitAndLoss_RiskAdj.DealNumber) - 1) + "%"
And	CharIndex("||",#MTVProfitAndLoss_RiskAdj.DealNumber) > 1
And	#MTVProfitAndLoss_RiskAdj.Trader Is Null
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else exec(@vc_SQL)

------------------------------------------------------------------------------------------------------------------------------
-- Update the Quantites for the risk adjustments from RiskPosition
------------------------------------------------------------------------------------------------------------------------------
select @vc_SQL = '
Update	#MTVProfitAndLoss_RiskAdj
Set	
	#MTVProfitAndLoss_RiskAdj.PositionGallons =
						Case	When #MTVProfitAndLoss_RiskAdj.CostType = "S" Then 0.0
							Else 1.0 * RiskPosition.Position
						End,
	#MTVProfitAndLoss_RiskAdj.PositionPounds =
						Case	When #MTVProfitAndLoss_RiskAdj.CostType = "S" Then 0.0
							Else 1.0
						End *
						Case	When RiskPosition.Weight is Not Null Then RiskPosition.Weight
							Else RiskPosition.Position * Abs(RiskPosition.SpecificGravity) * ' + @vc_WaterDensity + '
						End,
	#MTVProfitAndLoss_RiskAdj.ValuationGallons 	= RiskPosition.Position,
	#MTVProfitAndLoss_RiskAdj.SpecificGravity	= Abs(RiskPosition.SpecificGravity),
	#MTVProfitAndLoss_RiskAdj.Energy			= RiskPosition.Energy
From	#MTVProfitAndLoss_RiskAdj 
	Inner Join RiskPosition (NoLock)	On	RiskPosition.RiskID		= #MTVProfitAndLoss_RiskAdj.RiskID
						And	"' + convert(varchar,@sdt_InstanceDateTime,120) + '"	Between	RiskPosition.StartDate And RiskPosition.EndDate
'


if @c_OnlyShowSQL = 'Y' select @vc_SQL Else exec(@vc_SQL)

------------------------------------------------------------------------------------------------------------------------------
-- Update the Total Value
------------------------------------------------------------------------------------------------------------------------------
select @vc_SQL = '
Update	#MTVProfitAndLoss_RiskAdj
Set	TotalValue =		RiskValue.TotalValue
From	#MTVProfitAndLoss_RiskAdj
	Inner Join RiskValue (NoLock)	On	RiskValue.RiskID	= #MTVProfitAndLoss_RiskAdj.RiskID
					And	"' + convert(varchar,@sdt_InstanceDateTime,120) + '"	Between	RiskValue.StartDate And RiskValue.EndDate
					And	RiskValue.Type = 1
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else exec(@vc_SQL)

------------------------------------------------------------------------------------------------------------------------------
-- Update the Market Value
------------------------------------------------------------------------------------------------------------------------------
select @vc_SQL = '
Update	#MTVProfitAndLoss_RiskAdj
Set	MarketValue =		RiskValue.TotalValue
From	#MTVProfitAndLoss_RiskAdj
	Inner Join RiskValue (NoLock)	On	RiskValue.RiskID	= #MTVProfitAndLoss_RiskAdj.RiskID
					And	"' + convert(varchar,@sdt_InstanceDateTime,120) + '"	Between	RiskValue.StartDate And RiskValue.EndDate
					And	RiskValue.Type = 4
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else exec(@vc_SQL)

------------------------------------------------------------------------------------------------------------------------------
-- Update the Market Value
------------------------------------------------------------------------------------------------------------------------------
/*
select @vc_SQL = '
Update	#MTVProfitAndLoss_RiskAdj
Set	TotalPnL = #MTVProfitAndLoss_RiskAdj.TotalValue + #MTVProfitAndLoss_RiskAdj.MarketValue
From	#MTVProfitAndLoss_RiskAdj
Where	#MTVProfitAndLoss_RiskAdj.RiskID is Not Null
'

if @c_OnlyShowSQL = 'Y' select @vc_SQL Else exec(@vc_SQL)
*/


Set NoCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_RiskAdjustment]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_ProfitAndLoss_RiskAdjustment.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ProfitAndLoss_RiskAdjustment >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ProfitAndLoss_RiskAdjustment >>>'
	  END