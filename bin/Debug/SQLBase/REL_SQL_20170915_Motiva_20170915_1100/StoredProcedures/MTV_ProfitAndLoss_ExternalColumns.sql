/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_ProfitAndLoss_ExternalColumns WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_ProfitAndLoss_ExternalColumns]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_ProfitAndLoss_ExternalColumns.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_ExternalColumns]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_ProfitAndLoss_ExternalColumns] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_ProfitAndLoss_ExternalColumns >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_ProfitAndLoss_ExternalColumns]
							@sdt_InstanceDateTime		SmallDateTime,
							@sdt_EndOfDay			SmallDateTime,
                            @vc_P_PrtflioID			Varchar(8000), --PVCS 11227
							@vc_AdditionalColumns		VarChar(8000)	= Null,
--							@vc_TempTable			Varchar(8000) = NULL,
							@c_OnlyShowSQL			Char(1)		= 'N'

AS
-----------------------------------------------------------------------------------------------------------------------------
-- SP:            MTV_ProfitAndLoss_ExternalColumns
-- Arguments:	 
-- Tables:         Tables
-- Indexes: LIST ANY INDEXES used in OPTIMIZER hints
-- Stored Procs:   StoredProcedures
-- Dynamic Tables: DynamicTables
-- Overview:       DocumentFunctionalityHere
--
-- Created by:     Matt Perry
-- Issues
--	Figure out how to get the snapshot selection window to come up on navigation
--	Check with Manning on cargo descriptor stuff
--	Probably want to set @i_AccntngPrdID_Inventory for when crossing months based on what user picks
--		For example if EOD is March 4th but Feb is still open, user may want to see inventory in March or Feb
--		depending on accounting or trading view
--	Doing currency conversion for accountdetails based on transaction date
--	Doing currency conversion for estimatedaccountdetails based on endofday b/c they do not put future month rates in
-- History:       05/21/09 - First Created
-- Date Modified Modified By        Modification
-- ------------- ------------------ -------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set Quoted_Identifier off

Declare @vc_SqL Varchar(8000)

Declare @vc_PoundsToKilograms Varchar(20)
Declare @vc_GallonsToLitres Varchar(20)
Declare @vc_RPHdrID Varchar(20)
Declare @vc_PriceTypeIdentity Varchar(20)

--Declare #FlatPriceQuotes varchar(25)
--Declare @FlatExposure varchar(25)
--Declare @RowAverages varchar(25)
--Declare #Hedge varchar(25)
--
--IF @vc_TempTable = '#MTVProfitAndLoss' 
--Begin
--	Select #FlatPriceQuotes	= '#FlatPriceQuotes1' 
--	Select @FlatExposure	= '#FlatExposure1'
--	Select @RowAverages		= '#RowAverages1'
--	Select #Hedge			= '#Hedge1'
--End 
--else
--Begin
--	Select #FlatPriceQuotes = '#FlatPriceQuotes2'
--	Select @FlatExposure	= '#FlatExposure2'
--	Select @RowAverages		= '#RowAverages2'
--	Select #Hedge			= '#Hedge'
--End


-- TK Start

----Select @vc_sql = 'Select * into  #MTVProfitAndLoss  from ' + @vc_TempTable
--
--if @c_OnlyShowSQL = 'Y'
--Begin
--	Select @vc_sql
--End
--Else
--Begin
--	Exec @vc_sql
--End
--TK End 


---------------------------------------------------------------------------------------------------------------------------------------------
-- Now we need to add and update any special external columns around flat price exposure
---------------------------------------------------------------------------------------------------------------------------------------------
If	lower(@vc_AdditionalColumns) LIKE '%TMPL.flatexposurequotestart%' or
	lower(@vc_AdditionalColumns) LIKE '%TMPL.flatexposurequoteend%' or
	lower(@vc_AdditionalColumns) LIKE '%TMPL.flatexposurequotecount%' or
	lower(@vc_AdditionalColumns) LIKE '%TMPL.flatexposurepricedinpercentage,%' or
	lower(@vc_AdditionalColumns) LIKE '%TMPL.flatpricevalue,%' or      --TK 13685021
	lower(@vc_AdditionalColumns) LIKE '%TMPL.curveshift%'       --TK 13685021
Begin

-- TK 13685021 Calculate Base Value/FlatPrice Begin


--	IF @vc_TempTable = '#MTVProfitAndLoss'
--	Begin 
		if @c_OnlyShowSQL = 'Y'
		Begin
			Select
		'
			Create Table #FlatPriceQuotes
			--declare #FlatPriceQuotes table
				(
				P_EODEstmtedAccntDtlID		Int,
				P_EODEstmtedAccntDtlRiskID	Int,
				ExposurePercentage		Float,
				PricedInPercentage		Float,
				RwPrceLcleID			Int,
				PrceTpeIdnty			Int,
				VETradePeriodID			Int,
				QuoteDate			SmallDateTime
				)
		'
		End
		Else
		Begin
			Create Table #FlatPriceQuotes
			--declare #FlatPriceQuotes table
				(
				P_EODEstmtedAccntDtlID		Int,
				P_EODEstmtedAccntDtlRiskID	Int,
				ExposurePercentage		Float,
				PricedInPercentage		Float,
				RwPrceLcleID			Int,
				PrceTpeIdnty			Int,
				VETradePeriodID			Int,
				QuoteDate			SmallDateTime
				)
		End
--	 End
--	Else 
--	Begin 
--		if @c_OnlyShowSQL = 'Y'
--		Begin
--			Select
--		'
--			Create Table #FlatPriceQuotes2
--			--declare #FlatPriceQuotes table
--				(
--				P_EODEstmtedAccntDtlID		Int,
--				P_EODEstmtedAccntDtlRiskID	Int,
--				ExposurePercentage		Float,
--				PricedInPercentage		Float,
--				RwPrceLcleID			Int,
--				PrceTpeIdnty			Int,
--				VETradePeriodID			Int,
--				QuoteDate			SmallDateTime
--				)
--		'
--		End
--		Else
--		Begin
--			Create Table #FlatPriceQuotes2
--			--declare #FlatPriceQuotes table
--				(
--				P_EODEstmtedAccntDtlID		Int,
--				P_EODEstmtedAccntDtlRiskID	Int,
--				ExposurePercentage		Float,
--				PricedInPercentage		Float,
--				RwPrceLcleID			Int,
--				PrceTpeIdnty			Int,
--				VETradePeriodID			Int,
--				QuoteDate			SmallDateTime
--				)
--		End
--	 End
--	End 

	select	@vc_SqL =
'
	Insert	#FlatPriceQuotes
		(
		P_EODEstmtedAccntDtlID,
		P_EODEstmtedAccntDtlRiskID,
		ExposurePercentage,
		PricedInPercentage,
		RwPrceLcleID,
		PrceTpeIdnty,
		VETradePeriodID,
		QuoteDate
		)
	Select	 #MTVProfitAndLoss .P_EODEstmtedAccntDtlID,
		EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID,
		EstimatedAccountDetailRisk.ExposurePercentage,
		EstimatedAccountDetailRiskDetail.PricedInPercentage,
		EstimatedAccountDetailRisk.RwPrceLcleID,
		EstimatedAccountDetailRisk.PrceTpeIdnty,
		EstimatedAccountDetailRiskDetail.VETradePeriodID,
		EstimatedAccountDetailRiskDetail.QuoteDate
	From	 #MTVProfitAndLoss  (NoLock)
		Inner Join EstimatedAccountDetailRisk (NoLock)	
			On	EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlID = Coalesce( #MTVProfitAndLoss .P_EODEstmtedAccntDtlID_Market, #MTVProfitAndLoss .P_EODEstmtedAccntDtlID)
			And	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + ''' Between EstimatedAccountDetailRisk.StartDate And EstimatedAccountDetailRisk.EndDate
		Inner Join RawPriceLocale (NoLock)		
			On	RawPriceLocale.RwPrceLcleID = EstimatedAccountDetailRisk.RwPrceLcleID
			And	RawPriceLocale.IsBasisCurve = 0
		Inner Join EstimatedAccountDetailRiskDetail (NoLock)	
			On	EstimatedAccountDetailRiskDetail.P_EODEstmtedAccntDtlRiskID = EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID
			And	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + ''' Between EstimatedAccountDetailRiskDetail.StartDate And EstimatedAccountDetailRiskDetail.EndDate
'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

--  Calculate Base Value/FlatPrice End
	
	if @c_OnlyShowSQL = 'Y'
	Begin
		Select
	'
		Create Table #FlatExposure
 			(
			P_EODEstmtedAccntDtlID		Int,
			FlatExposureQuoteStart		SmallDateTime,
			FlatExposureQuoteEnd		SmallDateTime,
			FlatExposureQuoteCount		Int,
			FlatExposurePricedInPercentage	float,
			FlatExposurePosition		Float,
			FlatExposurePriceInPosition		Float
			)
	'
	End
	Else
	Begin
		Create Table #FlatExposure
			(
			P_EODEstmtedAccntDtlID		Int,
			FlatExposureQuoteStart		SmallDateTime,
			FlatExposureQuoteEnd		SmallDateTime,
			FlatExposureQuoteCount		Int,
			FlatExposurePricedInPercentage	float,
			FlatExposurePosition		Float,
			FlatExposurePriceInPosition		Float
			)
	End

-------------------------------------------------------------------------------------
-- Non-Swap Deals
-------------------------------------------------------------------------------------
	select	@vc_SqL =
'
	Insert	#FlatExposure
		(
		P_EODEstmtedAccntDtlID,
		FlatExposureQuoteStart,
		FlatExposureQuoteEnd,
		FlatExposureQuoteCount,
		FlatExposurePricedInPercentage,
		FlatExposurePosition		,
		FlatExposurePriceInPosition		
		)
	Select	#MTVProfitAndLoss.P_EODEstmtedAccntDtlID,
		Min(EstimatedAccountDetailRiskDetail.QuoteDate),
		Max(EstimatedAccountDetailRiskDetail.QuoteDate),
		Count(*)/count(distinct EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID),
		0,
-- WE13724125  TK Start
--		Sum(EstimatedAccountDetailRisk.ExposurePercentage * 
--			Case When EstimatedAccountDetailRiskDetail.QuoteDate <= ''' + Convert(varchar,@sdt_EndOfDay,120) + ''' Then  EstimatedAccountDetailRiskDetail.PricedInPercentage Else 0.0 End * PercentageOfProvision)  
-- WE13724125  TK End
-- WE13724125 Redux TK Start

--		Sum(Case When EstimatedAccountDetailRiskDetail.QuoteDate <= ''' + Convert(varchar,@sdt_EndOfDay,120) + ''' 
--			Then  EstimatedAccountDetailRiskDetail.PricedInPercentage 
--			Else 0.0 End * PercentageOfProvision) / Count(*)/count(distinct EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID)  

	Sum(#MTVProfitAndLoss.PositionGallons * 
		Case When #MTVProfitAndLoss.CostType = ''S'' Then 0.0 
			Else 1.0 End * 
		Case When EstimatedAccountDetail.AttachedInhouse = ''Y'' Then -1.0 	
			Else 1.0 End * 
		Case #MTVProfitAndLoss.ReceiptDelivery When ''D'' Then -1.0 
			Else 1.0 End * 
		Case #MTVProfitAndLoss.IsReversal When ''Y'' Then -1.0 
			Else 1.0 End * 
		Coalesce(EstimatedAccountDetailRisk.PercentageOfProvision,1.0) * 
		Coalesce(EstimatedAccountDetailRiskPercentage.TotalPercentage, 1.0) * 
		Coalesce(BestAvailableVolumeStrategy. Percentage, 100.0) * 0.01), 


	Sum(#MTVProfitAndLoss.PositionGallons * 
		Case When #MTVProfitAndLoss.CostType = ''S'' Then 0.0 
			Else 1.0 End * 
		Case When EstimatedAccountDetail.AttachedInhouse = ''Y'' Then -1.0 
			Else 1.0 End * 
		Case #MTVProfitAndLoss.ReceiptDelivery When ''D'' Then -1.0 
			Else 1.0 End * 
		Case #MTVProfitAndLoss.IsReversal When ''Y'' Then -1.0 
			Else 1.0 End * 
		Coalesce(EstimatedAccountDetailRisk.PercentageOfProvision,1.0) * 
		Coalesce(EstimatedAccountDetailRiskPercentage.PricedInPercentage, 1.0) * 
		Coalesce(BestAvailableVolumeStrategy. Percentage, 100.0) * 0.01) 


-- WE13724125 Redux TK End
	From	 #MTVProfitAndLoss  (NoLock)
		Inner Join EstimatedAccountDetailRisk (NoLock)	
			On	EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlID = Coalesce(#MTVProfitAndLoss.P_EODEstmtedAccntDtlID_Market,#MTVProfitAndLoss.P_EODEstmtedAccntDtlID)
			And	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''	Between EstimatedAccountDetailRisk.StartDate And EstimatedAccountDetailRisk.EndDate
		Inner Join RawPriceLocale (NoLock)		
			On	RawPriceLocale.RwPrceLcleID = EstimatedAccountDetailRisk.RwPrceLcleID
			And	RawPriceLocale.IsBasisCurve = 0
		Inner Join EstimatedAccountDetailRiskDetail (NoLock)	
			On	EstimatedAccountDetailRiskDetail.P_EODEstmtedAccntDtlRiskID = EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID
			And	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''	Between EstimatedAccountDetailRiskDetail.StartDate And EstimatedAccountDetailRiskDetail.EndDate

left outer join EstimatedAccountDetailRiskPercentage (NoLock) 
	on EstimatedAccountDetailRiskPercentage.P_EODEstmtedAccntDtlRiskID = EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID
	and	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''	Between EstimatedAccountDetailRiskPercentage. StartDate and EstimatedAccountDetailRiskPercentage. EndDate

left outer join EstimatedAccountDetail
	on EstimatedAccountDetail.P_EODEstmtedAccntDtlID = #MTVProfitAndLoss.P_EODEstmtedAccntDtlID
	and	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''	Between EstimatedAccountDetail. StartDate and EstimatedAccountDetail. EndDate					
	and	EstimatedAccountDetail.InterimBilling				= ''N''
	and	IsNull( EstimatedAccountDetail.TmplteSrceTpe, ''DD'')		<> ''ED''

Inner Join BestAvailableVolumeStrategy (NoLock)		
	on	BestAvailableVolumeStrategy. P_EODBAVID 			= #MTVProfitAndLoss. P_EODBAVID
	and	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''	Between BestAvailableVolumeStrategy. StartDate and BestAvailableVolumeStrategy. EndDate

inner join dealdetailprovision 
	on EstimatedAccountDetailRisk.DlDtlPrvsnID = dealdetailprovision.DlDtlPrvsnID
inner join dealheader
	on dealdetailprovision.DlDtlPrvsnDlDtlDlHdrID = dealheader.dlhdrid
inner join dealtype
	on dealheader.dlhdrtyp = dealtype.DlTypID
--where charindex(''swap'', description) = 0
	Group by #MTVProfitAndLoss.P_EODEstmtedAccntDtlID
	having count(distinct EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID) > 0
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
/*

Commented out due to change in calculation method of FlatExposurePricedInPercentage

-------------------------------------------------------------------------------------
-- Swap Deals
-------------------------------------------------------------------------------------
	select	@vc_SqL =
'
	Insert	#FlatExposure
		(
		P_EODEstmtedAccntDtlID,
		FlatExposureQuoteStart,
		FlatExposureQuoteEnd,
		FlatExposureQuoteCount,
		FlatExposurePricedInPercentage
		)
	Select	#MTVProfitAndLoss.P_EODEstmtedAccntDtlID,
		Min(EstimatedAccountDetailRiskDetail.QuoteDate),
		Max(EstimatedAccountDetailRiskDetail.QuoteDate),
		Count(*)/count(distinct EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID),
-- WE13724125  TK Start
		Sum(abs(EstimatedAccountDetailRisk.ExposurePercentage) * 
			Case When EstimatedAccountDetailRiskDetail.QuoteDate <= "' + Convert(varchar,@sdt_EndOfDay,120) + '" 
			Then  EstimatedAccountDetailRiskDetail.PricedInPercentage Else 0.0 End * PercentageOfProvision)  
-- WE13724125  TK End
	From	 #MTVProfitAndLoss  (NoLock)
		Inner Join EstimatedAccountDetailRisk (NoLock)	On	EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlID = Coalesce(#MTVProfitAndLoss.P_EODEstmtedAccntDtlID_Market,#MTVProfitAndLoss.P_EODEstmtedAccntDtlID)
								And	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''	Between EstimatedAccountDetailRisk.StartDate And EstimatedAccountDetailRisk.EndDate
		Inner Join RawPriceLocale (NoLock)		On	RawPriceLocale.RwPrceLcleID = EstimatedAccountDetailRisk.RwPrceLcleID
								And	RawPriceLocale.IsBasisCurve = 0
		Inner Join EstimatedAccountDetailRiskDetail (NoLock)	On	EstimatedAccountDetailRiskDetail.P_EODEstmtedAccntDtlRiskID = EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID
									And	''' + Convert(Varchar,@sdt_InstanceDateTime,120) + '''	Between EstimatedAccountDetailRiskDetail.StartDate And EstimatedAccountDetailRiskDetail.EndDate
inner join dealdetailprovision 
	on EstimatedAccountDetailRisk.DlDtlPrvsnID = dealdetailprovision.DlDtlPrvsnID
inner join dealheader
	on dealdetailprovision.DlDtlPrvsnDlDtlDlHdrID = dealheader.dlhdrid
inner join dealtype
	on dealheader.dlhdrtyp = dealtype.DlTypID
where charindex(''swap'', description) <> 0
	Group by #MTVProfitAndLoss.P_EODEstmtedAccntDtlID
	having count(distinct EstimatedAccountDetailRisk.P_EODEstmtedAccntDtlRiskID) > 0
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
*/

	select 	@vc_SqL =
'
update #FlatExposure
	set FlatExposurePricedInPercentage = 
--		case when charindex(''swap'', description) > 0 then 
			ABS(case when FlatExposurePosition = 0.0 Then 100.0 else Round((FlatExposurePriceInPosition / FlatExposurePosition) ,5) end ) 
--		else 
--			case when FlatExposurePosition = 0.0 Then 100.0 else Round((FlatExposurePriceInPosition / FlatExposurePosition) / 100,2) end 
--		end 
	from #FlatExposure
		inner join #MTVProfitAndLoss 
			on #MTVProfitAndLoss.P_EODEstmtedAccntDtlID = #FlatExposure.P_EODEstmtedAccntDtlID 
		inner join DealHeader
			on #MTVProfitAndLoss.DlHdrID = DealHeader.DlHdrID
		inner join DealType
			on dealheader.dlhdrtyp = dealtype.DlTypID
'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



	select	@vc_SqL =
'
	Alter	Table  #MTVProfitAndLoss 
	Add	FlatExposureQuoteStart	SmallDateTime Null,
		FlatExposureQuoteEnd	SmallDateTime Null,
		FlatExposureQuoteCount	Int Null,
		FlatExposurePricedInPercentage Float Default 1.0 With Values		
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	select	@vc_SqL =
'
	Update	 #MTVProfitAndLoss 
	Set	#MTVProfitAndLoss.FlatExposureQuoteStart		= #FlatExposure.FlatExposureQuoteStart,
		#MTVProfitAndLoss.FlatExposureQuoteEnd			= #FlatExposure.FlatExposureQuoteEnd,
		#MTVProfitAndLoss.FlatExposureQuoteCount 		= #FlatExposure.FlatExposureQuoteCount,
		#MTVProfitAndLoss.FlatExposurePricedInPercentage	= #FlatExposure.FlatExposurePricedInPercentage
		--#MTVProfitAndLoss.FlatExposurePricedInPercentage	= Case When #MTVProfitAndLoss.DlDtlTmplteID In (22500,32000,32001,27001) then 1.0 - #FlatExposure.FlatExposurePricedInPercentage Else #FlatExposure.FlatExposurePricedInPercentage End
	From	#FlatExposure
	Where	#MTVProfitAndLoss.P_EODEstmtedAccntDtlID = #FlatExposure.P_EODEstmtedAccntDtlID
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


-- TK 13685021 Add Base Value/FlatPrice to  #MTVProfitAndLoss  End
End 
	If	lower(@vc_AdditionalColumns) LIKE '%TMPL.flatpricevalue%' or lower(@vc_AdditionalColumns) LIKE '%TMPL.curveshift%' 
	Begin


		if @c_OnlyShowSQL = 'Y'
		Begin
			Select
		'
			Create Table #RowAverages
--			Declare @RowAverages Table 
				(
				P_EODEstmtedAccntDtlID		Int,
				P_EODEstmtedAccntDtlRiskID	Int,
				Average				Float
				)
		'
		End
		Else
		Begin
			Create Table #RowAverages
--			Declare @RowAverages Table 
				(
				P_EODEstmtedAccntDtlID		Int,
				P_EODEstmtedAccntDtlRiskID	Int,
				Average				Float
				)
		End


		select	@vc_Sql =
		'
		Insert	#RowAverages
			(
			P_EODEstmtedAccntDtlID,
			P_EODEstmtedAccntDtlRiskID,
			Average
			)
		Select	FPQ.P_EODEstmtedAccntDtlID,
			FPQ.P_EODEstmtedAccntDtlRiskID,
			Avg(RawPrice.RPVle)
		From	#FlatPriceQuotes FPQ (NoLock)
			Inner Join VETradePeriod (NoLock)	On	VETradePeriod.VETradePeriodID = FPQ.VETradePeriodID
			Inner Join RawPriceDetail (NoLock)	On	RawPriceDetail.RwPrceLcleID = FPQ.RwPrceLcleID
								And	RawPriceDetail.RPDtlTrdeFrmDte = VETradePeriod.StartDate
								And	RawPriceDetail.RPDtlTrdeToDte = VETradePeriod.EndDate
								And	''' + Convert(varchar,@sdt_EndOfDay,120) + '''   Between RawPriceDetail.RPDtlQteFrmDte And RawPriceDetail.RPDtlQteToDte
								And	RawPriceDetail.RPDtlTpe = Case When ''' + Convert(varchar,@sdt_EndOfDay,120) + ''' = FPQ.QuoteDate Then ''A'' Else ''F'' End
								And	RawPriceDetail.RPDtlStts = ''A''
			Left Outer Join PriceTypeRelation (NoLock)
								On	PriceTypeRelation.PrceTpeRltnPrntPrceTpeIdnty = FPQ.PrceTpeIdnty
			Inner Join RawPrice (NoLock)		On	RawPrice.RPRPDtlIdnty = RawPriceDetail.Idnty
								And	RawPrice.RPPrceTpeIdnty = Coalesce(PriceTypeRelation.PrceTpeRltnChldPrceTpeIdnty,FPQ.PrceTpeIdnty)			
		Where	FPQ.QuoteDate >= ''' + Convert(varchar,@sdt_EndOfDay,120) + '''
		Group By FPQ.P_EODEstmtedAccntDtlID,FPQ.P_EODEstmtedAccntDtlRiskID
		'


		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

		select	@vc_SqL =
		'
		Alter	Table  #MTVProfitAndLoss 
		Add	FlatPriceValue	Float Null
		'
		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

		select	@vc_SqL =
		'
		Update	 #MTVProfitAndLoss 
		Set	 #MTVProfitAndLoss .FlatPriceValue =	(
									Select	Avg(#RowAverages.Average)
									From	#RowAverages (NoLock)
									Where	#RowAverages.P_EODEstmtedAccntDtlID =  #MTVProfitAndLoss .P_EODEstmtedAccntDtlID
									)
		'

		if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)


	End

-- TK 13685021 Add Base Value/FlatPrice to  #MTVProfitAndLoss  End
--End


---------------------------------------------------------------------------------------------------------------------------------------------
-- Now we need to add and update PricingIsDeemed external column if added
---------------------------------------------------------------------------------------------------------------------------------------------
If	lower(@vc_AdditionalColumns) LIKE '%TMPL.pricingisdeemed%'
Begin

	select	@vc_SqL =
'
	Alter	Table  #MTVProfitAndLoss 
	Add	PricingIsDeemed	Char(1) Default ''N'' With Values
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	---------------------------------------------------------------------------------------------------------------------
	-- Update all ones that are primary cost and and have a formula tablet row with some deem dates in DealDetailProvisionRow.PriceAttribute33
	---------------------------------------------------------------------------------------------------------------------
	select	@vc_SqL =
'
	Update	 #MTVProfitAndLoss 
	Set	 #MTVProfitAndLoss .PricingIsDeemed	= ''Y''
	Where	 #MTVProfitAndLoss .CostType		= ''P''
	And	Exists
		(
		Select	1
		From	DealDetailProvisionRow (NoLock)
		Where	DealDetailProvisionRow.DlDtlPrvsnID =  #MTVProfitAndLoss .DlDtlPrvsnID
		And	DealDetailProvisionRow.DlDtlPRvsnRwTpe = ''F''
		And	IsNull(DealDetailProvisionRow.PriceAttribute32,'''') <> ''''
		)
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End


---------------------------------------------------------------------------------------------------------------------------------------------
-- No we need to add and update PnL Transaction Group  external column if added
---------------------------------------------------------------------------------------------------------------------------------------------
If	lower(@vc_AdditionalColumns) LIKE '%TMPL.pnltransactiongroup%'
Begin

	select	@vc_SqL =
'
	Alter	Table  #MTVProfitAndLoss 
	Add	PnLTransactionGroup	Varchar(50)
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	---------------------------------------------------------------------------------------------------------------------
	-- Find the PnL transaction group using the PnL qualifier
	---------------------------------------------------------------------------------------------------------------------
	select	@vc_SqL =
'
	Update	 #MTVProfitAndLoss 
	Set	 #MTVProfitAndLoss .PnLTransactionGroup = TransactionGroup.XGrpName
	From	TransactionGroup (NoLock)
		Inner Join TransactionTypeGroup (NoLock)	On	TransactionTypeGroup.XTpeGrpXGrpID = TransactionGroup.XGrpID
		Inner Join  #MTVProfitAndLoss 		On	 #MTVProfitAndLoss .TrnsctnTypID = TransactionTypeGroup.XTpeGrpTrnsctnTypID
	Where	TransactionGroup.XGrpQlfr = ''PnL''
'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End


---------------------------------------------------------------------------------------------------------------------------------------------
-- Add the 1st portfolio above the strategy in the corporate rollup
---------------------------------------------------------------------------------------------------------------------------------------------
If	lower(@vc_AdditionalColumns) LIKE '%TMPL.corporateportfolio%'
Begin

	select	@vc_SqL =
'
	Alter	Table  #MTVProfitAndLoss 
	Add	CorporatePortfolio	Varchar(50)  
'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



	
	select	@vc_SQL = 
	'
	Update	#MTVProfitAndLoss
	Set		#MTVProfitAndLoss .CorporatePortfolio = P_Portfolio.Name
	From	P_PortfolioStrategy (NoLock)
			Inner Join P_Portfolio (NoLock)	On	P_Portfolio.P_PrtflioID = P_PortfolioStrategy.P_PrtflioID
	Where	P_PortfolioStrategy.StrtgyID = #MTVProfitAndLoss.StrtgyID
	And		Exists
			(
			Select	1
			From	P_PortfolioFlat (NoLock)
			Where	P_PortfolioFlat.PrntP_PrtflioID = 1
			And		P_PortfolioFlat.ChldP_PrtflioID = P_PortfolioStrategy.P_PrtflioID
			)
	'
	If @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End




----------------------------------------------------------------------------------------------------------------------
-- Add the market curve configuration description if selected
---------------------------------------------------------------------------------------------------------------------
IF lower(@vc_AdditionalColumns) LIKE '%TMPL.marketcurve%' 
BEGIN

	SELECT  @vc_SQL = 'Alter Table  #MTVProfitAndLoss  Add MarketCurve	Varchar(80)'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
	                
	SELECT  @vc_SQL =
	'
	UPDATE	#MTVProfitAndLoss
	SET		#MTVProfitAndLoss.MarketCurve = PriceCurveConfiguration.Description
	From	RawPriceLocale (NoLock)
			Inner Join PriceCurveProvisionBasis (NoLock)	On	PriceCurveProvisionBasis.RwPrceLcleID = RawPriceLocale.RwPrceLcleID
			Inner Join PriceCurveConfiguration (NoLock)		On	PriceCurveConfiguration.PrceCrveCnfgID = PriceCurveProvisionBasis.PrceCrveCnfgID
															And	PriceCurveConfiguration.Type = ''M''
	Where	RawPriceLocale.RPLcleRPHdrID = 4 -- Market
	And		#MTVProfitAndLoss.PrdctID = RawPriceLocale.RPLcleChmclParPrdctID
	And		#MTVProfitAndLoss.LcleID = RawPriceLocale.RPLcleLcleID
	'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End




----------------------------------------------------------------------------------------------------------------------
-- Add the Formula Offset
---------------------------------------------------------------------------------------------------------------------
/* here matt commenting this out b/c going to get this for eads where we are finding the raw price locale
   on the formula tablet row that is the flat price since we will be there anyway
IF lower(@vc_AdditionalColumns) LIKE '%TMPL.formulaoffset%'
BEGIN

	SELECT  @vc_SQL = 'Alter Table  #MTVProfitAndLoss  Add FormulaOffset	float'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)



	SELECT  @vc_SQL =
'
	UPDATE	#MTVProfitAndLoss
	SET	#MTVProfitAndLoss.FormulaOffset =
							(
							Select	Sum(Convert(Decimal(19,6),DealDetailProvisionRow.PriceAttribute2))
							From	DealDetailProvision (NoLock)
									Inner Join DealDetailProvisionRow (NoLock)	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
																				And	DealDetailProvisionRow.DlDtlPRvsnRwTpe = ''F''
																				And	IsNumeric(DealDetailProvisionRow.PriceAttribute2) = 1
							Where	DealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
							)

'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End
*/


/* here matt commenting this out b/c going to get this for eads where we are finding the raw price locale
   on the formula tablet row that is the flat price since we will be there anyway
----------------------------------------------------------------------------------------------------------------------
-- Add the Formula Percentage
---------------------------------------------------------------------------------------------------------------------
IF lower(@vc_AdditionalColumns) LIKE '%TMPL.formulapercentage%'
BEGIN
	SELECT  @vc_SQL = 'Alter Table  #MTVProfitAndLoss  Add FormulaPercentage	float'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Get the formula row % for the first row in the formula tablet
	------------------------------------------------------------------------------------------------------------------------------

	SELECT  @vc_SQL =
'
	UPDATE	#MTVProfitAndLoss
	SET	#MTVProfitAndLoss.FormulaPercentage =
							(
							Select	Top 1 Convert(Decimal(19,6),DealDetailProvisionRow.PriceAttribute1)
							From	DealDetailProvision (NoLock)
									Inner Join DealDetailProvisionRow (NoLock)	On	DealDetailProvisionRow.DlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
																				And	DealDetailProvisionRow.DlDtlPRvsnRwTpe = ''F''
																				And	IsNumeric(DealDetailProvisionRow.PriceAttribute2) = 1
							Where	DealDetailProvision.DlDtlPrvsnID = #MTVProfitAndLoss.DlDtlPrvsnID
							Order by DealDetailProvisionRow.DlDtlPrvsnRwID ASC
							)

'
	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)
End
*/
----------------------------------------------------------------------------------------------------------------------
-- Add Flat Exposure Priced In Percentage
---------------------------------------------------------------------------------------------------------------------
IF lower(@vc_AdditionalColumns) LIKE '%TMPL.flatexposurepricedinpercentage2%'
	or lower(@vc_AdditionalColumns) LIKE '%TMPL.curveshift%'
BEGIN
--	select '/****** lower(@vc_AdditionalColumns) LIKE ''%TMPL.flatexposurepricedinpercentage2%'' ******/'
	SELECT  @vc_SQL = 'Alter Table  #MTVProfitAndLoss  Add FlatExposurePricedInPercentage2	float'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End

----------------------------------------------------------------------------------------------------------------------
-- Add Base Value 2
---------------------------------------------------------------------------------------------------------------------
IF lower(@vc_AdditionalColumns) LIKE '%TMPL.flatpricevalue2%'
	or lower(@vc_AdditionalColumns) LIKE '%TMPL.curveshift%'
BEGIN
--	select '/lower(@vc_AdditionalColumns) LIKE ''*TMPL.flatpricevalue2%'' ******/'
	SELECT  @vc_SQL = 'Alter Table  #MTVProfitAndLoss  Add FlatPriceValue2	float'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End

----------------------------------------------------------------------------------------------------------------------
-- Add Curve Shift
---------------------------------------------------------------------------------------------------------------------
IF lower(@vc_AdditionalColumns) LIKE '%TMPL.curveshift%'
BEGIN
--	select '/****** lower(@vc_AdditionalColumns) LIKE ''%TMPL.curveshift%'' ******/'
	SELECT  @vc_SQL = 'Alter Table  #MTVProfitAndLoss  Add CurveShift	float'

	if @c_OnlyShowSQL = 'Y' select @vc_SQL Else Exec(@vc_SQL)

End



Set NoCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_ProfitAndLoss_ExternalColumns]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_ProfitAndLoss_ExternalColumns.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_ProfitAndLoss_ExternalColumns >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_ProfitAndLoss_ExternalColumns >>>'
	  END