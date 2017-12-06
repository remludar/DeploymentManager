
/****** Object:  StoredProcedure [dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]
	@vc_StatementGrouping			VarChar(255)	= Null
	,@i_P_EODSnpShtID			Int 		= Null				-- The snapshotid of the data to get.  If it is null then get current "live" data
	,@i_Compare_P_EODSnpShtID		Int 		= Null				-- The snapshotid of the data to be compared.  It it is null then no compare is taking place
	,@i_id					Int		= 3				-- ID of the entity at the below level in the tree.  PrtflioID or StrtgyID
	,@vc_type				VarChar(100)	= 'PositionGroup'		-- Level in the tree valid values are 'Portfolio' or 'StrategyHeader' or 'UnassignedStrategies'
	,@i_TradePeriodFromID			Int		= 364				-- The VETradePeriodID that represents the from date to start in
	,@dt_maximumtradeperiodstartdate	SmallDateTime	= '2-1-2050 0:0:0.000'	-- The start date of the ending trade period to go to
	,@b_DiscountPositions			Bit		= 0
	,@vc_InventoryTypeCode			Char(1)		= 'B'
	,@c_Beg_Inv_SourceTable			Char(1)		= 'B'
	,@c_ExposureType			Char(1)		= 'N'	-- 'Y' or 'D' is Show Daily. ( Y was used in PB but isn't in .NET).  H - Historical with Pricing Events, P - Pricing Events
	,@c_ShowRiskType			Char(1)		= 'A'  --"F"lat, "B"asis, "A"ll
	,@b_ShowRiskDecomposed			Bit		= 1
	,@vc_AdditionalColumns			VarChar(Max)	= Null
	,@vc_TempTable				VarChar(200)	= '#RiskExposureResults'	-- .NET:  #RiskExposureResults		PB:  #RiskResults
	,@c_OnlyShowSQL				Char(1)		= 'N'
	
	-- PB & VC Parameters
	,@b_ShowZeroQuotational			Bit		= 0
	,@b_IsReport				Bit		= 1
	,@b_ShowCurrencyExposure		Bit		= 0
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables           
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Blake Doerr
-- History:	9/13/2010 - First Created
--
-- 	Date Modified 	Modified By		Issue#		Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	3.24.14			BMM				55889	Don't use precalculated sign logic for spreads on Position when determining exposure position signage when the deltas are signed properly.
--  5.2.14			JAK				55909	If #RiskExposureResults.CurveLevel is 0 we want to join directly to RawPriceLocale instead of joining through RiskOption.
-----------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
set Quoted_Identifier OFF

----------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------
Declare	@vc_DynamicSQL				VarChar(8000)
Declare	@sdt_VETPStartDate			SmallDateTime
Declare	@sdt_VETPEndDate			SmallDateTime

-- Get Report Reporting Period Info
Select	@sdt_VETPStartDate			= VETradePeriod. StartDate,
	@sdt_VETPEndDate			= VETradePeriod. EndDate
From	VETradePeriod (NoLock)
Where	VETradePeriod. VETradePeriodID	= @i_TradePeriodFromID

If @vc_StatementGrouping = 'Updates'
Begin

	----------------------------------------------------------------------------------------------------------------------
	-- Add Snapshot Information
	----------------------------------------------------------------------------------------------------------------------
	Execute dbo.SRA_Risk_Reports_Snapshot_Columns 	@i_P_EODSnpShtID		= @i_P_EODSnpShtID
							,@vc_AdditionalColumns		= @vc_AdditionalColumns
							,@c_OnlyShowSQL			= @c_OnlyShowSQL

	------------------------------------------------------
	-- Update the period for BALMO time physical exposure
	----------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	VETradePeriodID	=	 VETradePeriod.VETradePeriodID
	From	' + @vc_TempTable + '	#RiskExposureResults	
		Inner Join RiskPhysicalExposure	(NoLock)	On	#RiskExposureResults.RiskExposureTableIdnty	 =	RiskPhysicalExposure.RiskPhysicalExposureID
		Inner Join Risk (NoLock)			on	RiskPhysicalExposure.RiskID		 =	Risk.RiskID
		Inner Join RiskDealIdentifier (NoLock)		on	Risk.RiskDealIdentifierID	    = RiskDealIdentifier.RiskDealIdentifierID
		Inner Join RiskDealDetail (NoLock)		on	RiskDealIdentifier.DlHdrID  =	RiskDealDetail.DlHdrID
								and	RiskDealIdentifier.DlDtlID  =	RiskDealDetail.DlDtlID
		Inner Join VETradePeriod (NoLock)		on	RiskDealDetail.DlDtlFrmDte	=   VETradePeriod.StartDate
								and	RiskDealDetail.DlDtlToDte	=   VETradePeriod.EndDate						
	where	#RiskExposureResults.IsQuotational = 0
	and	#RiskExposureResults.SourceTable = ''O''
	and	#RiskExposureResults.InstanceDateTime between RiskDealDetail.StartDate and RiskDealDetail.EndDate
	And	RiskDealDetail. SrceSystmID			= RiskDealIdentifier.ExternalType
	and	exists (
			select	1
			from	ProductInstrument (NoLock) 
			where	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			And	ProductInstrument. PrdctId		= RiskDealDetail.DlDtlPrdctID
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


	------------------------------------------------------------------------------------------------------------------------------
	-- Update RiskCurve Id for Quotational Records
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskCurveID		= RiskCurve. RiskCurveID
		,PeriodStartDate	= RiskCurve. TradePeriodFromDate
		,PeriodEndDate		= RiskCurve. TradePeriodToDate
		,CrrncyID		= RiskCurve. CrrncyID
		,CurveProductID		= RiskCurve. PrdctID
		,CurveChemProductID	= RiskCurve. ChmclID
		,CurveLcleID		= RiskCurve. LcleID
		--,CurveLcle		= RiskCurve. LcleID
		,CurveServiceID		= RiskCurve. RPHdrID
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join RiskCurve	On	RiskCurve. RwPrceLcleID		= #RiskExposureResults. RwPrceLcleID
					And	RiskCurve. PrceTpeIdnty		= #RiskExposureResults. PrceTpeIdnty
					And	RiskCurve. VETradePeriodID	= #RiskExposureResults. VETradePeriodID
	Where	Exists	(
		Select	1 
		From	dbo.RawPriceLocaleCurrencyUOM	(NoLock)
		Where	RawPriceLocaleCurrencyUOM. RwPrceLcleID		= #RiskExposureResults. RwPrceLcleID
		And	RawPriceLocaleCurrencyUOM. CrrncyID		= RiskCurve. CrrncyID
		And	IsNull(RawPriceLocaleCurrencyUOM. UOM, -1)	= IsNull(RiskCurve. UOMID, -1)
			)'
			
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete RiskCurves that have incorrect UOM/Currencies
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join RiskCurve		(NoLock)	On	RiskCurve. RiskCurveID		= #RiskExposureResults. RiskCurveID
	Where	#RiskExposureResults. IsQuotational	= Convert(Bit, 0)
	And	Not Exists	(
		Select	1 
		From	dbo.RawPriceLocaleCurrencyUOM	(NoLock)
		Where	RawPriceLocaleCurrencyUOM. RwPrceLcleID		= RiskCurve. RwPrceLcleID
		And	RawPriceLocaleCurrencyUOM. CrrncyID		= RiskCurve. CrrncyID
		And	IsNull(RawPriceLocaleCurrencyUOM. UOM, -1)	= IsNull(RiskCurve. UOMID, -1)
			)'
		
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Update RiskCurve Id for Quotational Records
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	VETradePeriodID		= Case When IsNull(#RiskExposureResults. VETradePeriodID, -1) <> 0 Then Coalesce(VETradePeriod. VETradePeriodID, VETP.VETradePeriodID) Else #RiskExposureResults. VETradePeriodID End
		,PeriodStartDate	= Risk. DeliveryPeriodStartDate
		,PeriodEndDate		= Risk. DeliveryPeriodEndDate
		,CrrncyID		= RawPriceLocaleCurrencyUOM. CrrncyID
		,CurveProductID		= RawPriceLocale. RPLcleChmclParPrdctID
		,CurveChemProductID	= RawPriceLocale. RPLcleChmclChdPrdctID
		,CurveLcleID		= RawPriceLocale. RPLcleLcleID
		,CurveServiceID		= RawPriceLocale. RPLcleRPHdrID
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.RawPriceLocale		(NoLock)	On	RawPriceLocale. RwPrceLcleID		= #RiskExposureResults. RwPrceLcleID
		Inner Join dbo.RawPriceLocaleCurrencyUOM (NoLock)	On	RawPriceLocaleCurrencyUOM. RwPrceLcleID	= #RiskExposureResults. RwPrceLcleID
		Inner Join dbo.Risk			(NoLock)	On	Risk. RiskID				= #RiskExposureResults. RiskID
		Left Outer Join dbo.VETradePeriod	(NoLock)	On	VETradePeriod. StartDate		= Risk. DeliveryPeriodStartDate
									And	VETradePeriod. EndDate			= Risk. DeliveryPeriodEndDate
		Left Outer Join dbo.VETradePeriod VETP	(NoLock)	On	Risk. DeliveryPeriodEndDate		Between VETradePeriod. StartDate And VETradePeriod. EndDate
									And	VETP.Type				= "M"
									And	VETradePeriod.VETradePeriodID		Is Null
	Where	#RiskExposureResults. RiskCurveID	Is Null'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete Interim Billing records
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
	Where	Exists	(
			Select	''''
			From	DealDetailProvision
			Where	DealDetailProvision. DlDtlPrvsnID		= #RiskExposureResults. DlDtlPrvsnID
			And	DealDetailProvision. Actual	= ''I''
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete Physical side of Spread Options since we're brining in the quotational
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
	Where	#RiskExposureResults. SourceTable	= ''O''
	And	#RiskExposureResults. IsQuotational	= Convert(Bit, 0)
	And	#RiskExposureResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types, Over the Counter Options All Types') + ') 
	And	Exists	(
			Select	1 
			From	dbo.Risk	(NoLock)
				Inner Join dbo.RiskDealIdentifier	(NoLock)	On	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
				Inner Join dbo.RiskDealDetailProvision	(NoLock)	On	RiskDealDetailProvision. DlDtlPrvsnDlDtlDlHdrID	= RiskDealIdentifier. DlHdrID
											And	RiskDealDetailProvision. DlDtlPrvsnDlDtlID	= RiskDealIdentifier. DlDtlID
											And	#RiskExposureResults. InstanceDateTime Between RiskDealDetailProvision. StartDate and RiskDealDetailProvision. EndDate
			Where	Risk. RiskID					= #RiskExposureResults. RiskID
			And	RiskDealDetailProvision. DlDtlPrvsnPrvsnID	= ' + dbo.GetConfigurationValue('ProvisionOTCSpread') + '
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Now Update Position 
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	OriginalPhysicalPosition	= RiskPosition.Position
		,Position			= Case	When #RiskExposureResults.IsQuotational	= Convert(Bit, 1)
							Then IsNull(RiskQuotationalExposure.TotalPercentage, 1.0) 
								* IsNull(FormulaEvaluationPercentage.TotalPercentage, 1.0) 
								* RiskPosition.Position
							Else #RiskExposureResults. TotalPercentage * RiskPosition.Position
						End
		,SpecificGravity		= Abs(RiskPosition.SpecificGravity)
		,Energy				= Abs(RiskPosition.Energy)
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join RiskPosition (NoLock)	On	RiskPosition.RiskID		= #RiskExposureResults.RiskID
							And	#RiskExposureResults.InstanceDateTime	Between	RiskPosition.StartDate And RiskPosition.EndDate
							And	RiskPosition. Position		<> 0.0
		Left Outer Join RiskQuotationalExposure On	RiskQuotationalExposure.RiskQuotationalExposureID	= #RiskExposureResults.RiskExposureTableIdnty
							And	#RiskExposureResults.IsQuotational			= Convert(Bit, 1)
		Left Outer Join FormulaEvaluationPercentage	On FormulaEvaluationPercentage.FormulaEvaluationID		= #RiskExposureResults.FormulaEvaluationID
							And	#RiskExposureResults.EndOfDay	Between FormulaEvaluationPercentage.EndOfDayStartDate and FormulaEvaluationPercentage.EndOfDayEndDate
							And	FormulaEvaluationPercentage.VETradePeriodID			= #RiskExposureResults.VETradePeriodID

	'	

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Now Update Position for backward Pay/Receive
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	Position			= #RiskExposureResults.Position  * Case RiskDealDetail.DlDtlSpplyDmnd + RiskDealDetailProvision.DlDtlPrvsnMntryDrctn
										When ''RD'' Then -1.0 When ''DR'' Then -1.0  Else 1.0 End
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk			On	Risk.RiskID			= #RiskExposureResults.RiskID
		Inner Join RiskDealDetailProvision	On	RiskDealDetailProvision.DlDtlPrvsnID			= #RiskExposureResults.DlDtlPrvsnID
							And	#RiskExposureResults. InstanceDateTime Between RiskDealDetailProvision. StartDate and RiskDealDetailProvision. EndDate
		Inner Join dbo.RiskDealIdentifier	On	RiskDealIdentifier.RiskDealIdentifierID			= Risk. RiskDealIdentifierID
		Inner Join dbo.RiskDealDetail	On	RiskDealDetail.DealDetailID				= RiskDealIdentifier.DealDetailID
							And	#RiskExposureResults. InstanceDateTime Between RiskDealDetail. StartDate and RiskDealDetail. EndDate
	Where	#RiskExposureResults.IsQuotational	= Convert(Bit, 1)
	And	IsNull(RiskDealDetailProvision.TmplteSrceTpe , ''Z'') = ''DD''
	And	#RiskExposureResults.DlDtlTmplteId	Not In(' + dbo.GetDlDtlTmplteIds('Over the Counter Options All Types, Exchange Traded Options All Types, Swaps All Types, Futures All Types') + ')
	'	
	-- Add sign logic to multiply quotational times a negative for cases when customer sets provision to Receive for Purchase or Pay for Sales which is opposite of typical deal setup.
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete Clearported OTC & Swap Deals - Can't do this in snapshot since they're needed for MtM (premium)
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk			(NoLock)	On Risk. RiskID			= #RiskExposureResults. RiskID
	Where	#RiskExposureResults.DlDtlTmplteID 	In (' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types, Swaps All Types') + ')
	And	Exists	(
		Select	1
		From	dbo.RiskDealIdentifier		(NoLock)
			Inner Join dbo.DealHeaderLink	(NoLock)	On	DealHeaderLink. DlHdrID			= RiskDealIdentifier. DlHdrID
									And	DealHeaderLink. LinkType		= ''C''
			Inner Join dbo.RiskDealDetail	(NoLock)	On	RiskDealDetail. DlHdrID			= DealHeaderLink. RelatedDlHdrID
									And	#RiskExposureResults. InstanceDateTime		Between RiskDealDetail. StartDate and RiskDealDetail. EndDate
									And	RiskDealDetail. SrceSystmID		= ' + convert(varchar, dbo.GetRASourceSystemID()) + ' -- T-19256
		Where	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
		And	RiskDealDetail. NegotiatedDate			<= DateAdd(Minute, -1, DateAdd(Day, 1, #RiskExposureResults. EndOfDay))
		And	RiskDealDetail. DlHdrStat			= ''A''
			)
	Option (Force Order, Loop Join)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete Quotational Records
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	--Set	Position	= 0.0
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.RiskDealDetailProvisionRow	(NoLock)	On	RiskDealDetailProvisionRow.DlDtlPrvsnRwID	= #RiskExposureResults.DlDtlPrvsnRwID
								     		And	RiskDealDetailProvisionRow.StartDate		<= #RiskExposureResults.InstanceDateTime
	     									And	RiskDealDetailProvisionRow.EndDate		>= #RiskExposureResults.InstanceDateTime
	Where	#RiskExposureResults. IsQuotational						= Convert(Bit, 1)
	And	IsNull(RiskDealDetailProvisionRow.FormulaUseForRisk, Convert(Bit, 1)) 	<> Convert(Bit, 1)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- If Not Showing Daily Exposure, we need to get the priced in % for the quotational records since there's nothing triggering that calculation in the snapshot
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	If @c_ExposureType Not in( 'Y', 'P', 'H', 'D')
		Execute dbo.SRA_Risk_Reports_Exposure_UpdateHK_ExposurePercentage 	@i_P_EODSnpShtID	= @i_P_EODSnpShtID--TODO:  This has to work on the comparison snapshot too
											,@vc_TempTableName	= @vc_TempTable --'#RiskExposureResults'
											,@c_OnlyShowSQL		= @c_OnlyShowSQL
End

/*TODO*/
------------------------------------------------------------------------------------------------------------------------------
-- Update for Client External Columns
------------------------------------------------------------------------------------------------------------------------------
--If @vc_AdditionalColumns Like '%v_Risk_Reports_Exposure_Client_ExternalColumns%' And Object_ID('sp_Risk_Report_PriceRisk_Pre_Load_ClientColumns') Is Not Null
--Begin
--            Execute sp_Risk_Report_PriceRisk_Pre_Load_ClientColumns	
--                                                                 @c_IsThisNavigation		= @c_IsThisNavigation
--								,@c_MultiSelected		= @c_MultiSelected
--								,@i_id				= @i_id
--								,@vc_type			= @vc_type
--								,@vc_PositionGroupIDs		= @vc_PositionGroupIDs
--		 						,@vc_PortfolioIDs		= @vc_PortfolioIDs
--		 						,@vc_ProdLocIDs			= @vc_ProdLocIDs
--		 						,@vc_StrategyIDs		= @vc_StrategyIDs
--		 						,@vc_UnAssignedProdLoc		= @vc_UnAssignedProdLoc
--		 						,@vc_UnAssignedStrategy		= @vc_UnAssignedStrategy
--								,@i_TradePeriodFromID		= @i_TradePeriodFromID
--								,@vc_InternalBAID		= @vc_InternalBAID
--								,@dt_maximumtradeperiodstartdate	= @dt_maximumtradeperiodstartdate
--								,@i_P_EODSnpShtID		= @i_P_EODSnpShtID
--								,@i_Compare_P_EODSnpShtID	= @i_Compare_P_EODSnpShtID
--								,@c_ShowOutMonth		= @c_ShowOutMonth
--								,@c_strategy			= @c_strategy
--								,@i_RprtCnfgID			= @i_RprtCnfgID
--								,@vc_AdditionalColumns		= @vc_AdditionalColumns	Out
--								,@b_DiscountPositions		= @b_DiscountPositions
--								,@c_OnlyShowSQL			= @c_OnlyShowSQL
--								,@sdt_SnapshotEndofDay_1	= @sdt_SnapshotEndofDay_1
--								,@c_ExposureType		= @c_ExposureType
--								,@c_ShowInventory		= @c_ShowInventory
--								,@c_ShowRiskType		= @c_ShowRiskType
--								,@b_ShowHedgingDeals		= @b_ShowHedgingDeals
--                                                                ,@c_Beg_Inv_SourceTable		= @c_Beg_Inv_SourceTable
--                                                                ,@i_P_EODSnpShtLgID             = @i_P_EODSnpShtLgID
--End
	
If @vc_StatementGrouping = 'DecompositionAndUpdates'
Begin
	--------------------------------------------------------------------------------------------------------------------------------
	---- Call Procedure to Decompose
	--------------------------------------------------------------------------------------------------------------------------------
			 
	Exec dbo.sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure	@i_P_EODSnpShtID		= @i_P_EODSnpShtID	--TODO:  This has to work on the comparison snapshot too
							,@i_Compare_P_EODSnpShtID	= @i_Compare_P_EODSnpShtID
							,@c_ShowDailyExposure		= @c_ExposureType
							,@c_InventoryType		= @vc_InventoryTypeCode
							,@vc_AdditionalColumns		= @vc_AdditionalColumns
							,@vc_TempTableName		= @vc_TempTable -- '#RiskExposureResults'
							,@c_OnlyShowSQL			= @c_OnlyShowSQL
							,@b_ShowRiskDecomposed		= @b_ShowRiskDecomposed

	------------------------------------------------------------------------------------------------------------------------------
	-- Update Snapshot Information
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	Snapshot			= Snapshot.P_EODSnpShtID
		,SnapshotAccountingPeriod 	= AcctPeriod. StartDate
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join Snapshot (NoLock)			On	Snapshot. InstanceDateTime 		= #RiskExposureResults.InstanceDateTime
		Inner Join VETradePeriod AcctPeriod (NoLock)	On	Snapshot. StartedFromVETradePeriodID	= AcctPeriod. VETradePeriodID
	'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Update Snapshot Information 2 (Split query to perform better)
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	SnapshotTradePeriod		= TradePeriod. StartDate
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join VETradePeriod TradePeriod (NoLock)	On	#RiskExposureResults.EndOfDay			Between TradePeriod. StartDate and TradePeriod. EndDate
								And	TradePeriod.Type			= ''M'''

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete for Criteria - IsBasisCurve
	------------------------------------------------------------------------------------------------------------------------------
	If @c_ShowRiskType In( 'F', 'B' )
	Begin
		Select @vc_DynamicSQL = '
		Delete	#RiskExposureResults
		From	' + @vc_TempTable + '	#RiskExposureResults
		Where	#RiskExposureResults. IsBasisCurve = ' + Case When @c_ShowRiskType = 'F' -- Flat Risk
								Then 'Convert(Bit, 1)'
								When @c_ShowRiskType = 'B' -- Basis Risk
								Then 'Convert(Bit, 0)'
							End
							
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)				
	End

	------------------------------------------------------------------------------------------------------------------------------
	-- Update Period for Ending Inventory Report
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	PeriodStartDate		= "'+ Convert(VarChar, @sdt_VETPStartDate) +'"
		,PeriodEndDate		= "'+ Convert(VarChar, @sdt_VETPEndDate) +'"
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk		On Risk. RiskID			= #RiskExposureResults. RiskID
	Where	Risk. SourceTable	= ''' + @c_Beg_Inv_SourceTable + ''''

	If @vc_InventoryTypeCode = 'E'
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
	------------------------------------------------------------------------------------------------------------------------------
	-- Update ExposureStartDate for Pricing Events w/ Historical Exposure
	------------------------------------------------------------------------------------------------------------------------------
	if @c_ExposureType = 'H'
	Begin
		select @vc_DynamicSQL = '
		Update	#RiskExposureResults
		Set	ExposureStartDate			= Case 	When 	"' + Convert(VarChar, @sdt_VETPStartDate) + '" > RiskDealDetail. NegotiatedDate
								Then 	"' + Convert(VarChar, @sdt_VETPStartDate) + '"	-- Report Starting Period
								Else	RiskDealDetail. NegotiatedDate
							End
		From	' + @vc_TempTable + '	#RiskExposureResults
			Inner Join Risk			(NoLock)	On	#RiskExposureResults. RiskID				= Risk. RiskID
			Left Outer Join RiskDealIdentifier (NoLock)	On	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
			Left Outer Join RiskDealDetail	(NoLock)	On	RiskDealDetail. DlHdrID				= RiskDealIdentifier. DlHdrID
									And	RiskDealDetail. DlDtlID				= RiskDealIdentifier. DlDtlID
									And	#RiskExposureResults.InstanceDateTime			Between RiskDealDetail. StartDate and RiskDealDetail. EndDate
									And	RiskDealDetail. SrceSystmID			= RiskDealIdentifier. ExternalType -- T-19256
		Where	#RiskExposureResults. IsDailyPricingRow = 0'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

	----------------------------------------------------------------------------------------------------------------------
	-- RiskCurve should get everything, but we'll look on provion & BA as last resort
	----------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	CrrncyID 	= Coalesce(RiskDealDetailProvision.CrrncyID, BusinessAssociateCurrency.BACrrncyCrrncyID,' + dbo.GetConfigurationValue('DefaultCurrency') + ')
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk			(NoLock)	On 	Risk. RiskID	= #RiskExposureResults. RiskID
		Left Outer Join RiskDealDetailProvision (NoLock)	On	RiskDealDetailProvision.DlDtlPrvsnID	= #RiskExposureResults.DlDtlPrvsnID
									And	#RiskExposureResults.InstanceDateTime		Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		Left Outer Join dbo.BusinessAssociateCurrency 	(NoLock)	On	BusinessAssociateCurrency.BACrrncyBAID		= Risk.InternalBAID
										And	BusinessAssociateCurrency.BACrrncyDflt		= ''Y''
	Where	#RiskExposureResults.CrrncyID	Is Null
	'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Update Quotational Position for Sign
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if @vc_TempTable = '#RiskExposureResults' -- .NET
		select @vc_DynamicSQL = '
		Update	#RiskExposureResults
		Set	Position		=	----------------------------------------------------------------------------------------------------------------------
							-- When we are showing Pricing Events, we need to reverse the sign of the daily quotes
							----------------------------------------------------------------------------------------------------------------------
							Case 	When	IsDailyPricingRow = 1
								And	"' + @c_ExposureType + '" <> "Y"
								Then	-1.0 
								Else 	1.0
							End * /*IsNull(#RiskExposureResults. Percentage, 1.0) * BMM*/

							----------------------------------------------------------------------------------------------------------------------
							-- For Daily Rows, the quote percentage handles it.  For non-daily, we want to show the whole percentage when
							--   showing historical rows, but only the floating percentage for all others
							----------------------------------------------------------------------------------------------------------------------
							/* BMM Doesnt need to run since position is already determined
							Case	When	(("' + @c_ExposureType + '" In( "Y", "D")
								Or	#RiskExposureResults. IsDailyPricingRow	= 1)'
									+ Case when len(dbo.GetConfigurationValue('ProvisionTriggerAndFormula')) = 0 then '' else '
								And	RiskDealDetailProvision. DlDtlPrvsnPrvsnID	not in (' + dbo.GetConfigurationValue('ProvisionTriggerAndFormula') + ')' end + '
									)
								Then	1.0
								When	"' + @c_ExposureType + '" = "H"
								And	#RiskExposureResults. IsDailyPricingRow	= 0
								Then	#RiskExposureResults. TotalPercentage
								Else	#RiskExposureResults. TotalPercentage - #RiskExposureResults. Percentage
				      			End * 
							*/
							----------------------------------------------------------------------------------------------------------------------
							-- For physical risk that is represented as quotational risk, we just need to apply a -1.0, for others
							--   we need to look at the We Pay/They Pay flag in combination with the sign of the position
							----------------------------------------------------------------------------------------------------------------------
							Case	When	RiskDealDetailProvision.DlDtlPrvsnID		Is Null -- Clearport
								And	#RiskExposureResults. IsDailyPricingRow			= 0
								And	RiskPriceIdentifier.RiskPriceIdentifierID	Is Null -- Clearport
								Then	1.0
								When	RiskDealDetailProvision.DlDtlPrvsnID	Is Null
								And	#RiskExposureResults. IsDailyPricingRow		= 0
								And	"' + @c_ExposureType + '" 		<> "Y"
								Then	-1.0
 								When	IsNull(RiskPriceIdentifier.TmplteSrceTpe, "ED")	= "ED"
								And	#RiskExposureResults.DlDtlPrvsnRwID		Is Null
 								Then	1.0
								When	#RiskExposureResults.DlDtlTmplteID				In (' + dbo.GetDlDtlTmplteIDs('Swaps All Types') + ')
								And	IsNull(RiskDealDetailProvision.CostType, ''P'')		= ''P''
								And	(
										(
										RiskPosition. ValuationPosition 		< 0.0
									And	RiskDealDetailProvision.DlDtlPrvsnMntryDrctn 	= "R")
									Or 	(
										RiskPosition.ValuationPosition 			> 0.0
									And	RiskDealDetailProvision.DlDtlPrvsnMntryDrctn 	= "D"
										)
									)
								Then	1.0
								--Options really represent a physical exposure, so leave sign alone
								When	#RiskExposureResults.DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types, Over the Counter Options All Types') + ')
								Then	1.0
								Else	-1.0
							End 
							* #RiskExposureResults. Position
							/** BMM
							----------------------------------------------------------------------------------------------------------------------
							-- If the source of the volume is physical, we need to use the net position, otherwise the valuation position
							----------------------------------------------------------------------------------------------------------------------
							Case	When	RiskDealDetailProvision.DlDtlPrvsnID	Is Null
								Then	RiskPosition.Position
								Else	RiskPosition.ValuationPosition
							End */,
			SpecificGravity		= Abs(RiskPosition.SpecificGravity)
			,Energy			= Abs(RiskPosition.Energy)
		From	#RiskExposureResults
			Left Outer Join Risk			(NoLock)	On 	#RiskExposureResults. RiskID 			= Risk. RiskID
			Left Outer Join  RiskPriceIdentifier	(NoLock)	On 	Risk. RiskPriceIdentifierId 		= RiskPriceIdentifier. RiskPriceIdentifierID
			Inner Join RiskPosition			(NoLock)	On	RiskPosition.RiskID			= #RiskExposureResults.RiskID
										And	#RiskExposureResults.InstanceDateTime		Between	RiskPosition.StartDate And RiskPosition.EndDate
			Left Outer Join RiskDealDetailProvision	(NoLock)	On	RiskDealDetailProvision.DlDtlPrvsnID	= #RiskExposureResults. DlDtlPrvsnID
										And	#RiskExposureResults.InstanceDateTime		Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		Where	#RiskExposureResults.IsQuotational	= Convert(Bit, 1)'
	Else	-- PB Report or VC
		select @vc_DynamicSQL = '
		Update	#RiskResults
		Set	Position		=	----------------------------------------------------------------------------------------------------------------------
							-- When we are showing Pricing Events, we need to reverse the sign of the daily quotes
							----------------------------------------------------------------------------------------------------------------------
							Case 	When	IsDailyPricingRow = 1
								And	"' + @c_ExposureType + '" <> "Y"
								Then	-1.0 
								Else 	1.0
							End * /*IsNull(#RiskResults. Percentage, 1.0) * BMM*/

							----------------------------------------------------------------------------------------------------------------------
							-- For Daily Rows, the quote percentage handles it.  For non-daily, we want to show the whole percentage when
							--   showing historical rows, but only the floating percentage for all others
							----------------------------------------------------------------------------------------------------------------------
							/* BMM Doesnt need to run since position is already determined
							Case	When	(("' + @c_ExposureType + '" = "Y"
								Or	#RiskResults. IsDailyPricingRow	= 1)'
									+ Case when len(dbo.GetConfigurationValue('ProvisionTriggerAndFormula')) = 0 then '' else '
								And	RiskDealDetailProvision. DlDtlPrvsnPrvsnID	not in (' + dbo.GetConfigurationValue('ProvisionTriggerAndFormula') + ')' end + '
									)
								Then	1.0
								When	"' + @c_ExposureType + '" = "H"
								And	#RiskResults. IsDailyPricingRow	= 0
								Then	#RiskResults. TotalPercentage
								Else	#RiskResults. TotalPercentage - #RiskResults. Percentage
				      			End * 
							*/
							----------------------------------------------------------------------------------------------------------------------
							-- For physical risk that is represented as quotational risk, we just need to apply a -1.0, for others
							--   we need to look at the We Pay/They Pay flag in combination with the sign of the position
							----------------------------------------------------------------------------------------------------------------------
							Case	When	RiskDealDetailProvision.DlDtlPrvsnID		Is Null -- Clearport
								And	#RiskResults. IsDailyPricingRow			= 0
								And	RiskPriceIdentifier.RiskPriceIdentifierID	Is Null -- Clearport
								Then	1.0
								When	RiskDealDetailProvision.DlDtlPrvsnID	Is Null
								And	#RiskResults. IsDailyPricingRow		= 0
								And	"' + @c_ExposureType + '" 		<> "Y"
								Then	-1.0
 								When	IsNull(RiskPriceIdentifier.TmplteSrceTpe, "ED")	= "ED"
								And	#RiskResults.DlDtlPrvsnRwID		Is Null
 								Then	1.0
								When	#RiskResults.DlDtlTmplteID				In (' + dbo.GetDlDtlTmplteIDs('Swaps All Types') + ')
								And	IsNull(RiskDealDetailProvision.CostType, ''P'')		= ''P''
								And	(
										(
										RiskPosition. ValuationPosition 		< 0.0
									And	RiskDealDetailProvision.DlDtlPrvsnMntryDrctn 	= "R")
									Or 	(
										RiskPosition.ValuationPosition 			> 0.0
									And	RiskDealDetailProvision.DlDtlPrvsnMntryDrctn 	= "D"
										)
									)
								Then	1.0
								--Options really represent a physical exposure, so leave sign alone
								When	#RiskResults.DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types, Over the Counter Options All Types') + ')
								Then	1.0
								Else	-1.0
							End 
							* #RiskResults. Position
							/** BMM
							----------------------------------------------------------------------------------------------------------------------
							-- If the source of the volume is physical, we need to use the net position, otherwise the valuation position
							----------------------------------------------------------------------------------------------------------------------
							Case	When	RiskDealDetailProvision.DlDtlPrvsnID	Is Null
								Then	RiskPosition.Position
								Else	RiskPosition.ValuationPosition
							End */,
			SpecificGravity		= Abs(RiskPosition.SpecificGravity)
			,Energy			= Abs(RiskPosition.Energy)
		From	#RiskResults
			Left Outer Join Risk			(NoLock)	On 	#RiskResults. RiskID 			= Risk. RiskID
			Left Outer Join  RiskPriceIdentifier	(NoLock)	On 	Risk. RiskPriceIdentifierId 		= RiskPriceIdentifier. RiskPriceIdentifierID
			Inner Join RiskPosition			(NoLock)	On	RiskPosition.RiskID			= #RiskResults.RiskID
										And	#RiskResults.InstanceDateTime		Between	RiskPosition.StartDate And RiskPosition.EndDate
			Left Outer Join RiskDealDetailProvision	(NoLock)	On	RiskDealDetailProvision.DlDtlPrvsnID	= #RiskResults. DlDtlPrvsnID
										And	#RiskResults.InstanceDateTime		Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		Where	#RiskResults.IsQuotational	= Convert(Bit, 1)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


	-- Update for daily physical pricing rows (Monthly Average Futures)
	select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	Position	= -1.0 * Position
	From	' + @vc_TempTable + '	#RiskExposureResults
	Where	#RiskExposureResults.IsQuotational	= Convert(Bit, 0)
	And	#RiskExposureResults.IsDailyPricingRow	= Convert(Bit, 1)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	-----------------------------------------------------------------------------------------------------------------------------
	-- Delete 0 Position Records from #RiskExposureResults if no formula evaluation quotes exist
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Delete	#RiskExposureResults
	From	' + @vc_TempTable + '	#RiskExposureResults
	Where	#RiskExposureResults.Position		= 0.0
	And	IsNull(#RiskExposureResults. Argument, "")	not like  "%,IsCashSettleFuture,%"
	And	#RiskExposureResults.IsQuotational	= Convert(Bit, 1)
	And	Not Exists	(
				Select	''''
				From	FormulaEvaluationQuote (NoLock)
				Where	FormulaEvaluationQuote.FormulaEvaluationID	= #RiskExposureResults.FormulaEvaluationID
				And	FormulaEvaluationQuote.VETradePeriodID		= #RiskExposureResults.VETradePeriodID
				)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Delete 0 Position Records from #RiskExposureResults for zero valuationposition
	------------------------------------------------------------------------------------------------------------------------------
	If @b_ShowZeroQuotational = 0 or @b_IsReport = 0 or @vc_TempTable = '#RiskExposureResults'
	Begin
		Select @vc_DynamicSQL = '
		Delete	#RiskExposureResults
		From	' + @vc_TempTable + '	#RiskExposureResults
		Where	#RiskExposureResults.Position		= 0.0
		And	#RiskExposureResults.IsQuotational 	= Convert(Bit, 1)
		And	Not Exists	(
					Select	''''
					From	RiskPosition (NoLock)
					Where	RiskPosition. RiskID		= #RiskExposureResults.RiskID
		     			And	#RiskExposureResults.InstanceDateTime	Between RiskPosition. StartDate	And RiskPosition. EndDate
					And	RiskPosition. ValuationPosition	<> 0.0
					)'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		-- Delete for zero position records
		Select @vc_DynamicSQL = '
		Delete	#RiskExposureResults
		From	' + @vc_TempTable + '	#RiskExposureResults
		Where	Convert(Decimal(38, 6), #RiskExposureResults.Position)		=  0.0'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End
	
	----------------------------------------------------------------------------------------------------------------------
	-- If we're discounting, then get the discount factor and discount the reference columns
	----------------------------------------------------------------------------------------------------------------------
	If @b_DiscountPositions = 1 Or @b_ShowCurrencyExposure = 1
		Execute SRA_Risk_Reports_DiscountFactor 	@c_RetrieveAtSourceLevel	= 'N'
								,@vc_entity			= 'Exposure'
								,@vc_TempTableName		= @vc_TempTable --'#RiskExposureResults'
								,@c_OnlyShowSQL			= @c_OnlyShowSQL

					
	------------------------------------------------------------------------------------------------------------------------------
	-- Insert Option External Column Information
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskDealDetailOptionOTCID 	= RiskDealDetailOptionOTC. RiskDealDetailOptionOTCID		-- Needed for SRA_Risk_Reports_Option_Columns
	-- Select *
	From	' + @vc_TempTable + '	#RiskExposureResults
		Inner Join dbo.Risk			(NoLock)	On	Risk. RiskID					= #RiskExposureResults. RiskID
		Inner Join dbo.RiskDealIdentifier	(NoLock)	On	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
		Inner Join dbo.RiskDealDetailOption	(NoLock)	On 	RiskDealDetailOption. DlHdrID			= RiskDealIdentifier. DlHdrID
									And	RiskDealDetailOption. DlDtlID			= RiskDealIdentifier. DlDtlID
									And	#RiskExposureResults.InstanceDateTime Between RiskDealDetailOption. StartDate and RiskDealDetailOption. EndDate
		Inner Join dbo.RiskCurve		(NoLock)	On	RiskCurve. RiskCurveID				= #RiskExposureResults. RiskCurveId
		Inner Join dbo.RiskDealDetailOptionOTC	(NoLock)	On	RiskDealDetailOptionOTC. RiskDealDetailOptionID	= RiskDealDetailOption. RiskDealDetailOptionID
									And	#RiskExposureResults.InstanceDateTime Between RiskDealDetailOptionOTC. StartDate and RiskDealDetailOptionOTC. EndDate
									And	RiskDealDetailOptionOTC. RwPrceLcleID		= RiskCurve. RwPrceLcleID
									And	RiskDealDetailOptionOTC. PrceTpeIdnty		= RiskCurve. PrceTpeIdnty
	Where 	#RiskExposureResults. DlDtlTmplteID in(' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types') + ')'

	If @c_onlyshowsql <> 'Y' Execute (@vc_DynamicSQL) Else Select @vc_DynamicSQL

	Declare @vc_OptionsTempTable Varchar(200)
	Select	@vc_OptionsTempTable = Case When @vc_TempTable = '#RiskExposureResults' Then '#RiskExposureResultsOptions' Else '#RiskResultsOptions' End

	Execute SRA_Risk_Reports_Option_Columns 	@i_P_EODSnpShtID		= @i_P_EODSnpShtID	--TODO:  This has to work on the comparison snapshot too
							,@vc_AdditionalColumns		= @vc_AdditionalColumns
							,@vc_Entity 			= 'Exposure'
							,@vc_TempTableName		= @vc_OptionsTempTable	-- '#RiskExposureResultsOptions'
							,@vc_RiskResultsTempTableName	= @vc_TempTable		-- '#RiskExposureResults'
							,@c_OnlyShowSQL			= @c_OnlyShowSQL


	-----------------------------------------------------------------------------------------------------------------------------
	-- We have to reduce the quantity of the "O" records since they could have partially exercised
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	Position	 = Sign(Position) * (Abs(Position) - Abs(#RiskResultsOptions.ExercisedQuantity))
	From	' + @vc_TempTable + '	 #RiskResults
		Inner Join ' + @vc_OptionsTempTable + ' #RiskResultsOptions	On	#RiskResultsOptions. RiskId = #RiskResults. RiskId
	Where	#RiskResultsOptions.ExercisedQuantity	Is Not Null
	And	#RiskResultsOptions.ExercisedQuantity	<> 0.0'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Delete ones that are fully exercised
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete	#RiskResults
	From	' + @vc_TempTable + '	 #RiskResults
		Inner Join ' + @vc_OptionsTempTable + '  #RiskResultsOptions	On	#RiskResultsOptions. RiskId = #RiskResults. RiskId
	Where	#RiskResultsOptions.ExercisedQuantity	Is Not Null
	And	#RiskResultsOptions.ExercisedQuantity	<> 0.0
	And	#RiskResults.Position			= 0.0'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Delete knocked out options
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete	#RiskResults
	From	' + @vc_TempTable + '	 #RiskResults
		Inner Join ' + @vc_OptionsTempTable + '  #RiskResultsOptions	On	#RiskResultsOptions. RiskId = #RiskResults. RiskId
	Where	IsNull(#RiskResultsOptions.KnockOutStatus, ''N'') = ''Y'''

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Because postings and spot price formulas go from a real period to zero as they price in, we need to add the percentages
	--   to the earliest remaining period.  This will make the report look as if the spot prices are priced in as the earliest period.
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	PricedInPercentage	= #RiskResults.PricedInPercentage + (FormulaEvaluationPercentage.PricedInPercentage * RiskDealDetailProvisionRow.FormulaPercent/100.0),
		TotalPercentage		= #RiskResults.TotalPercentage + (FormulaEvaluationPercentage.TotalPercentage * RiskDealDetailProvisionRow.FormulaPercent/100.0)
	From	' + @vc_TempTable + '	 #RiskResults
		Inner Join dbo.FormulaEvaluationPercentage (NoLock)
					On	FormulaEvaluationPercentage.FormulaEvaluationID	= #RiskResults.FormulaEvaluationID
					And	#RiskResults.EndOfDay				Between FormulaEvaluationPercentage.EndOfDayStartDate And FormulaEvaluationPercentage.EndOfDayEndDate
					--We are only interested in 100% priced in posting/spot exposure
					And	FormulaEvaluationPercentage.VETradePeriodID	= 0
					And	FormulaEvaluationPercentage.PricedInPercentage	= FormulaEvaluationPercentage.TotalPercentage
		Inner Join dbo.RiskDealDetailProvisionRow (NoLock)
			On RiskDealDetailProvisionRow.DlDtlPrvsnRwID = #RiskResults.DlDtlPrvsnRwID
			And #RiskResults.InstanceDateTime between RiskDealDetailProvisionRow.StartDate and RiskDealDetailProvisionRow.EndDate
	Where	#RiskResults.VETradePeriodID	<> 0
	--This will guarantee that the earliest quoting period is the one that accumulates the spot/posting percentage
	And	(
		Select	Top 1 FEP.VETradePeriodID
		From	dbo.FormulaEvaluationPercentage FEP (NoLock)
		Where	FEP.FormulaEvaluationID	= #RiskResults.FormulaEvaluationID
		And	#RiskResults.EndOfDay	Between FEP.EndOfDayStartDate And FEP.EndOfDayEndDate
		And	FEP.VETradePeriodID	<> 0
		Order By FEP.QuoteRangeBeginDate, FEP.FormulaEvaluationPercentageID
		) = #RiskResults.VETradePeriodID'
		
	If @b_IsReport = 1 And @c_ExposureType = 'N'
	Begin
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--BLD - I'm removing position calculation using Put/Call and Buy/Sell because the following logic is the correct way to determine the sign:
			--Buy/Sell is embedded in RiskPosition.Position
			--Put/Call is embedded in the delta position, puts are always negative
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	/*
	Signage for Delta (only dependent on Put/Call):
	Put - Negative Delta
	Call - Positive Delta

	Position Signage:
	Buy Call - Positive position
	Buy Put - Negative position
	Sell Call - Negative position
	Sell Put - Positive position
	*/
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Apply Delta for ETO Options
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	Position	= #RiskResultsOptions.Delta * ABS(#RiskResultsOptions.Weight)
				* Abs(#RiskResults.Position) * Case When RiskDealDetail. DlDtlSpplyDmnd = ''R'' Then 1.0 Else -1.0 End
				-- For Monthly Average Asian options, we need to not apply the delta to percentage
		,PricedInPercentage	= Case	When	''' + @c_ExposureType + '''	<> ''N'' -- Show Daily Exposure
						--And	Risk.DlDtlTmplteID			in(  ' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types') + ') 
						And	#RiskResultsOptions. Flavor		= ''Asian''
						Then	PricedInPercentage
						When	IsNull(RiskDealDetailProvision.DlDtlPrvsnPrvsnID, 0) = ' + dbo.GetConfigurationValue('ProvisionOTCSpread') + ' -- Spread
						Then	#RiskResultsOptions.Delta
						Else	Abs(#RiskResultsOptions.Delta)	-- Else Show Priced % as Delta
							-- Delta for non spreads should be negative for puts and positive for calls.  We cant rely on the sign that currently exists since it can be different depending on the option model used.
							* Case		When #RiskResultsOptions.PutCall = ''Put'' 
									Then -1.0 Else 1.0 End 
					End
		,TotalPercentage	= Case	When	''' + @c_ExposureType + '''	<> ''N'' -- Show Daily Exposure
						And	Risk.DlDtlTmplteID			in(  ' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types') + ') 
						And	#RiskResultsOptions. Flavor		= ''Asian''
						Then	TotalPercentage
						Else	1.0	-- Otherwise we end up applying negatives or partial percentages screwing up the delta
					End
	From	' + @vc_TempTable + '	  #RiskResults
		Inner Join ' + @vc_OptionsTempTable + '   #RiskResultsOptions		On	#RiskResultsOptions. RiskID			= #RiskResults.RiskID
											And	#RiskResultsOptions.RiskExposureTableIdnty	= #RiskResults. RiskExposureTableIdnty
		Inner Join RiskDealDetail	(NoLock) On	RiskDealDetail. DlHdrID			= #RiskResultsOptions. DlHdrID
							And	RiskDealDetail. DlDtlID			= #RiskResultsOptions. DlDtlID
							And	#RiskResults.InstanceDateTime	Between RiskDealDetail. StartDate	And RiskDealDetail. EndDate
		Inner Join dbo.Risk	(NoLock)					On	Risk. RiskID					= #RiskResults.RiskID
		Left Outer Join dbo.DealDetailProvisionRow (NoLock)
								On	DealDetailProvisionRow.DlDtlPrvsnRwID	= IsNull(#RiskResults.DlDtlPrvsnRwID, #RiskResultsOptions.DlDtlPrvsnRwID)
		Left Outer Join dbo.RiskDealDetailProvision (NoLock)	On	RiskDealDetailProvision.DlDtlPrvsnID		= DealDetailProvisionRow.DlDtlPrvsnID
								And	#RiskResults. InstanceDateTime			Between RiskDealDetailProvision.StartDate And RiskDealDetailProvision.EndDate
		Left Outer Join dbo.RiskOption (NoLock)		On	RiskOption.RiskID				= #RiskResults.RiskID
								And	#RiskResults. InstanceDateTime			Between RiskOption.StartDate And RiskOption.EndDate
	'
	
	If @b_IsReport = 1
	Begin
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

	-----------------------------------------------------------------------------------------------------------------------------
	-- Additional Adjustment For Asian Options
	-- NonDaily Calculation = Total Quantity * [(Individual Unpriced Quantity) / (Individual Unpriced Total Quantity)]
	------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	select		(
				select	Sum( RERSub.Position)
				From	' + @vc_TempTable + ' RERSub
				Where	RERSub.RiskExposureTableIdnty = 	#RiskResults.RiskExposureTableIdnty
				And		RERSub.IsQuotational 	= 1
				) *
				(1.0 - Case When #RiskResults. TotalPercentage = 0.0 Then 1.0 Else #RiskResults. PricedInPercentage / #RiskResults. TotalPercentage End)
				/
				(
				select	Sum((1.0 - Case When RERSub. TotalPercentage = 0.0 Then 1.0 Else RERSub. PricedInPercentage / RERSub. TotalPercentage End))
				From	' + @vc_TempTable + '  RERSub
				Where	RERSub.RiskExposureTableIdnty = 	#RiskResults.RiskExposureTableIdnty
				And		RERSub.IsQuotational 	= 1
				)	Position,		
				#RiskResults.Idnty	
	Into	#RiskExposureResultsAsian											
	From	' + @vc_TempTable + ' #RiskResults
	Where	Exists (
					select	1
					From '	 + @vc_OptionsTempTable + ' #RiskResultsOptions
					Where	#RiskResultsOptions. RiskID					= #RiskResults.RiskID
					And		#RiskResultsOptions.RiskExposureTableIdnty	= #RiskResults. RiskExposureTableIdnty
					And		#RiskResultsOptions. Flavor	= ''Asian''
					)
	And		#RiskResults.IsQuotational 	= 1
	And		#RiskResults.DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types, Exchange Traded Options All Types') + ') -- All Options
	And		(
			select	Sum((1.0 - Case When RERSub. TotalPercentage = 0.0 Then 1.0 Else RERSub. PricedInPercentage / RERSub. TotalPercentage End))
			From	' + @vc_TempTable + ' RERSub
			Where	RERSub.RiskExposureTableIdnty = 	#RiskResults.RiskExposureTableIdnty
			And		RERSub.IsQuotational 	= 1
			) <> 0
	And		''' + @c_ExposureType + '''	= ''N''

	Update	#RiskResults
	Set		Position = #RiskExposureResultsAsian.Position
	From	' + @vc_TempTable + ' #RiskResults
			Inner Join #RiskExposureResultsAsian on #RiskExposureResultsAsian.Idnty = #RiskResults.Idnty
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	-------------------------------------------------------------------------------------------------------------------------------------------------
	-- Additional Adjustment For Asian Options
	-- Daily Calculation = Adjust to get individual weight by multiplying by 1/Percentage to get Original Position and then / number of unpriced quotes
	--------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set		Position = #RiskResults.Position * ((1/#RiskResults.Percentage) /
						(
						select count(1) 
						from ' + @vc_TempTable + '  #RiskResultsSub 
						Where  #RiskResultsSub.RiskExposureTableIdnty = #RiskResults.RiskExposureTableIdnty
						And		#RiskResultsSub.IsQuotational 	= 1
						))
	From	' + @vc_TempTable + ' #RiskResults
	Where	Exists (
					select	1
					From '	 + @vc_OptionsTempTable + ' #RiskResultsOptions
					Where	#RiskResultsOptions. RiskID					= #RiskResults.RiskID
					And		#RiskResultsOptions.RiskExposureTableIdnty	= #RiskResults. RiskExposureTableIdnty
					And		#RiskResultsOptions. Flavor	= ''Asian''
					)
	And		#RiskResults.IsQuotational 	= 1
	And		#RiskResults.DlDtlTmplteID	In (' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types, Exchange Traded Options All Types') + ') -- All Options
	And		#RiskResults.Percentage <> 0
	And		'''  + @c_ExposureType + '''	<> ''N'''

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


	-----------------------------------------------------------------------------------------------------------------------------
	-- Delete Expired/Exercised Options
	------------------------------------------------------------------------------------------------------------------------------
	select @vc_DynamicSQL = '
	Delete #RiskExposureResults
	-- Select *
	From	' + @vc_TempTable + '	  #RiskExposureResults
	Where	Exists	(
			Select 1
			From	' + @vc_OptionsTempTable + '   #RiskExposureResultsOptions
			Where	#RiskExposureResultsOptions. RiskId		= #RiskExposureResults. RiskId
			And	DATEADD(dd, 0, DATEDIFF(dd, 0, #RiskExposureResultsOptions. ExpirationDate)) <= #RiskExposureResults.EndOfDay
			And	#RiskExposureResultsOptions. ExpirationDate	Is Not Null
			)

	Delete #RiskExposureResults
	-- Select *
	From	' + @vc_TempTable + '	  #RiskExposureResults
	Where	Exists	(
			Select 1
			From	' + @vc_OptionsTempTable + '   #RiskExposureResultsOptions
			Where	#RiskExposureResultsOptions. RiskId		= #RiskExposureResults. RiskId
			And	DATEADD(dd, 0, DATEDIFF(dd, 0, #RiskExposureResultsOptions. ExercisedDate)) <= #RiskExposureResults.EndOfDay
			And	#RiskExposureResultsOptions. ExercisedDate	Is Not Null
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
	------------------------------------------------------------------------------------------------------------------------------
	-- Set Risk Type to Quotational for Cash Settled Futures.
	------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskType		= ''M''
	From	' + @vc_TempTable + '	  #RiskExposureResults
		Inner Join Risk (NoLock)    on	Risk. RiskID	= #RiskExposureResults. RiskID
	Where	#RiskExposureResults. IsQuotational	= Convert(Bit, 0)
	And	#RiskExposureResults. DlDtlTmplteId	In(' + dbo.GetDlDtlTmplteIds('Futures All Types') + ')
	And	Exists	(
			Select	1
			From	dbo.ProductInstrument	(NoLock)
			Where	ProductInstrument. PrdctId		= Risk. PrdctID-- Coalesce( #RiskExposureResults. CurveProductID, Risk. PrdctID) --Risk. PrdctID
			And	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Set Risk Type to Quotational for Cash Settled Options.
	------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskType		= Case When ProductInstrument. DefaultSettlementType = ''C'' Then ''M'' Else ''P'' End
	From	' + @vc_TempTable + '	  #RiskExposureResults
		Inner Join dbo.Risk		(NoLock)	On	Risk. RiskID				= #RiskExposureResults. RiskID
		Inner Join dbo.ExchangeOption	 (NoLock)	On	Risk. PrdctID				= ExchangeOption.PrdctID
		Inner Join dbo.ProductInstrument (NoLock)	On	ExchangeOption.ProductDerivativeID	= ProductInstrument.ProductDerivativeID
	Where	#RiskExposureResults. DlDtlTmplteId		In(' + dbo.GetDlDtlTmplteIds('Exchange Traded Options All Types') + ')	'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------
	-- Set Risk Type to Physical for Physically Settled OTCs.
	------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#RiskExposureResults
	Set	RiskType		= Case	When	Exists	(	-- Not Cash Settled
								Select	1
								From	RiskDealIdentifier (NoLock)
									Inner Join dbo.RiskDealDetailOption (NoLock)		On	RiskDealDetailOption. DlHdrID			= RiskDealIdentifier. DlHdrID
																And	RiskDealDetailOption. DlDtlID			= RiskDealIdentifier. DlDtlID
																And	#RiskExposureResults. InstanceDateTime 			Between RiskDealDetailOption. StartDate and RiskDealDetailOption. EndDate
									Inner Join dbo.RiskDealDetailOptionOTCStrip (NoLock)	On	RiskDealDetailOptionOTCStrip. RiskDealDetailOptionID = RiskDealDetailOption. RiskDealDetailOptionID
																And	#RiskExposureResults. InstanceDateTime 			Between RiskDealDetailOptionOTCStrip. StartDate and RiskDealDetailOptionOTCStrip. EndDate
								Where	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
								And	RiskDealDetailOptionOTCStrip. SettlementType	<> ''C''
								)
						And	Not Exists (
								Select	1
								From	RiskDealIdentifier (NoLock)
									Inner Join dbo.DealDetail	with (NoLock)	On DealDetail.DealDetailID	= RiskDealIdentifier.DealDetailID
								Where	RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
								And	Exists (
										Select	1 
										From	dbo.EntityTemplate	with (NoLock)
										where	EntityTemplate.EntityTemplateID	= DealDetail.EntityTemplateID
										And	EntityTemplate.TemplateName like ''swaption%''
										)
								)
						Then	''P''
						Else	''Q''
					End
	From	' + @vc_TempTable + '	  #RiskExposureResults
		Inner Join dbo.Risk		(NoLock)	On	Risk. RiskID				= #RiskExposureResults. RiskID
	Where	#RiskExposureResults. DlDtlTmplteId		In(' + dbo.GetDlDtlTmplteIds('Over the Counter Options All Types') + ')'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------
	--Show underlying (curve) prod/loc for OTC Options
	------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update #RiskExposureResults
	Set	PrdctID = RawPriceLocale.RPLcleChmclParPrdctID,
		ChmclID = RawPriceLocale.RPLcleChmclChdPrdctID,
		LcleID	= RawPriceLocale.RPLcleLcleID
	From ' + @vc_TempTable + ' #RiskExposureResults
		Inner Join dbo.RawPriceLocale ON (#RiskExposureResults.RwPrceLcleID = RawPriceLocale.RwPrceLcleID)
	Where #RiskExposureResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types') + ') 
	And #RiskExposureResults.CurveLevel = 0 
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	Select @vc_DynamicSQL = '
	Update #RiskExposureResults
	Set	PrdctID = RawPriceLocale.RPLcleChmclParPrdctID,
		ChmclID = RawPriceLocale.RPLcleChmclChdPrdctID,
		LcleID	= RawPriceLocale.RPLcleLcleID
	From	' + @vc_TempTable + '	  #RiskExposureResults
		Inner Join dbo.RiskOption (NoLock)	On (#RiskExposureResults.RiskID = RiskOption.RiskID)
							And #RiskExposureResults.InstanceDateTime between RiskOption.StartDate and RiskOption.EndDate
		Inner Join dbo.RawPriceLocale (NoLock)	On (RiskOption.UnderlyingRwPrceLcleID = RawPriceLocale.RwPrceLcleID)
	Where #RiskExposureResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Over the Counter Options All Types') + ') 
	And #RiskExposureResults.CurveLevel <> 0
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	----------------------------------------------------------------------------------------------------------------------------------------------------
	--  Lease Center Exposure 
	----------------------------------------------------------------------------------------------------------------------------------------------------
	Execute dbo.SRA_Risk_Report_LeaseCenter_Exposure	@vc_TempTableName	= @vc_TempTable	--'#RiskExposureResults'
								,@c_onlyshowsql		= @c_onlyshowsql

	------------------------------------------------------------------------------------------------------------------------------
	-- Insert Hedging External Column Information
	------------------------------------------------------------------------------------------------------------------------------
	Declare @vc_HedingTempTable Varchar(200)
	Select	@vc_HedingTempTable = Case When @vc_TempTable = '#RiskExposureResults' Then '#RiskExposureResultsHedge' Else '#RiskResultsHedging' End
	
	Execute dbo.SRA_Risk_Reports_Hedging_Columns 	@i_P_EODSnpShtID		= @i_P_EODSnpShtID	--TODO:  This has to work on the comparison snapshot too
							,@vc_AdditionalColumns		= @vc_AdditionalColumns
	--						,@vc_report			= 'PLShift'
							,@c_OnlyShowSQL			= @c_OnlyShowSQL
							,@vc_ResultsTempTableName	= @vc_TempTable	-- '#RiskExposureResults'
							,@vc_HedgingTempTableName	= @vc_HedingTempTable --'#RiskExposureResultsHedge'

	------------------------------------------------------------------------------------------------------------------------------
	---- Update for Misc External Columns
	--------------------------------------------------------------------------------------------------------------------------------
	--If @vc_AdditionalColumns Like '%CurveRiskType%'
	--Begin
	--	select @vc_DynamicSQL = '
	--	Update	#RiskExposureResults
	--	Set	CurveRiskType = RiskDealDetailProvisionDisaggregate.RiskType
	--	From	#RiskExposureResults
	--		Inner Join Risk (NoLock)		On	#RiskExposureResults.RiskID				= Risk.RiskID
	--		Inner Join RiskPriceIdentifier (NoLock)	On	RiskPriceIdentifier.RiskPriceIdentifierID		= Risk.RiskPriceIdentifierID
	--							And	RiskPriceIdentifier.TmplteSrceTpe			= "ED"
	--		Inner Join RiskDealDetailProvisionDisaggregate (NoLock)
	--							On	RiskDealDetailProvisionDisaggregate.DisaggregateDlDtlPrvsnID	= RiskPriceIdentifier.DlDtlPrvsnID
	--							And	IsNull(RiskDealDetailProvisionDisaggregate.RiskType, "")	<> ""
	--							And	#RiskExposureResults.InstanceDateTime				Between RiskDealDetailProvisionDisaggregate.StartDate And RiskDealDetailProvisionDisaggregate.EndDate'
		
	--	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	--End

	If @vc_AdditionalColumns Like '%AttachedInHouse%'
	Begin
		select @vc_DynamicSQL = '
		Update	#RiskExposureResults
		Set	AttachedInHouse = "Y"
		From	' + @vc_TempTable + '	#RiskExposureResults
			Inner Join Risk (NoLock)		On	#RiskExposureResults.RiskID				= Risk.RiskID
			Inner Join RiskPriceIdentifier (NoLock)	On	RiskPriceIdentifier.RiskPriceIdentifierID		= Risk.RiskPriceIdentifierID
								And	RiskPriceIdentifier.TmplteSrceTpe			Not Like "D%"'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End
	
	If	(
		IsNull(@vc_AdditionalColumns,'') Like '%RelatedDealNumber%'
	Or	IsNull(@vc_AdditionalColumns,'') Like '%MoveExternalDealID%'
		)
	Begin
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	RelatedDealNumber	= Case	When Risk. SourceTable In(''EIX'', ''EIP'') 
						Then RiskDealDetail. DlHdrIntrnlNbr
						Else RiskDealIdentifier. Description
					End	
		,MoveExternalDealID	= IsNull(RiskDealDetail. DlDtlID, RiskDealIdentifier. DlDtlID)
	From	' + @vc_TempTable + '		#RiskResults
		Inner Join dbo.Risk			(NoLock)	On	Risk.RiskID				= #RiskResults. RiskID
		Inner Join dbo.RiskDealIdentifier	(NoLock)	On	RiskDealIdentifier. RiskDealIdentifierID = Risk. RiskDealIdentifierID
		Left Outer Join dbo.RiskDealDetail		(NoLock)	
									On	RiskDealDetail. SourceID		= RiskDealIdentifier.ExternalID
									And	#RiskResults.InstanceDateTime		Between RiskDealDetail. StartDate and RiskDealDetail. EndDate
									And	RiskDealDetail. SrceSystmID		= RiskDealIdentifier. ExternalType
	Where	RiskDealIdentifier. ExternalType	<> ' + Convert(Varchar, dbo.GetRASourceSystemID()) + ' -- RA
	And	Risk. SourceTable			In(''EX'', ''EP'', ''EIX'', ''EIP'')
	'
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
End
End

/*TODO*/
------------------------------------------------------------------------------------------------------------------------------
-- Execute the Client Extension Stored Procedure
------------------------------------------------------------------------------------------------------------------------------
--If Object_ID('sp_Risk_Report_PriceRisk_ClientExtension') Is Not Null
--Begin
--            Execute sp_Risk_Report_PriceRisk_ClientExtension	@c_IsThisNavigation		= @c_IsThisNavigation
--								,@c_MultiSelected		= @c_MultiSelected
--								,@i_id				= @i_id
--								,@vc_type			= @vc_type
--								,@vc_PositionGroupIDs		= @vc_PositionGroupIDs
--		 						,@vc_PortfolioIDs		= @vc_PortfolioIDs
--		 						,@vc_ProdLocIDs			= @vc_ProdLocIDs
--		 						,@vc_StrategyIDs		= @vc_StrategyIDs
--		 						,@vc_UnAssignedProdLoc		= @vc_UnAssignedProdLoc
--		 						,@vc_UnAssignedStrategy		= @vc_UnAssignedStrategy
--								,@i_TradePeriodFromID		= @i_TradePeriodFromID
--								,@vc_InternalBAID		= @vc_InternalBAID
--								,@dt_maximumtradeperiodstartdate	= @dt_maximumtradeperiodstartdate
--								,@i_P_EODSnpShtID		= @i_P_EODSnpShtID
--								,@i_Compare_P_EODSnpShtID	= @i_Compare_P_EODSnpShtID
--								,@c_ShowOutMonth		= @c_ShowOutMonth
--								,@c_strategy			= @c_strategy
--								,@i_RprtCnfgID			= @i_RprtCnfgID
--								,@vc_AdditionalColumns		= @vc_AdditionalColumns	Out
--								,@i_WhatIf_ID			= @i_WhatIf_ID
--								,@i_WhatIf_Compare_ID		= @i_WhatIf_Compare_ID
--								,@b_discountpositions		= @b_discountpositions
--								,@c_OnlyShowSQL			= @c_OnlyShowSQL
--								,@sdt_SnapshotBeginDate_1	= @sdt_SnapshotBeginDate_1
--								,@sdt_SnapshotBeginDate_2	= @sdt_SnapshotBeginDate_2
--								,@sdt_SnapshotEndofDay_1	= @sdt_SnapshotEndofDay_1
--								,@sdt_SnapshotEndofDay_2	= @sdt_SnapshotEndofDay_2
--								,@c_ShowDailyExposure		= @c_ShowDailyExposure
--								,@c_ShowInventory		= @c_ShowInventory
--								,@c_ShowRiskType		= @c_ShowRiskType
--								,@b_ShowHedgingDeals		= @b_ShowHedgingDeals
--								,@c_InventoryType		= @c_InventoryType
--End

/*TODO*/
------------------------------------------------------------------------------------------------------------------------------
-- Update for Client External Columns
------------------------------------------------------------------------------------------------------------------------------
--If @vc_AdditionalColumns Like '%v_Risk_Reports_Exposure_Client_ExternalColumns%' And Object_ID('sp_Risk_Report_PriceRisk_Load_ClientColumns') Is Not Null
--Begin
--            Execute sp_Risk_Report_PriceRisk_Load_ClientColumns	@c_IsThisNavigation		= @c_IsThisNavigation
--								,@c_MultiSelected		= @c_MultiSelected
--								,@i_id				= @i_id
--								,@vc_type			= @vc_type
--								,@vc_PositionGroupIDs		= @vc_PositionGroupIDs
--		 						,@vc_PortfolioIDs		= @vc_PortfolioIDs
--		 						,@vc_ProdLocIDs			= @vc_ProdLocIDs
--		 						,@vc_StrategyIDs		= @vc_StrategyIDs
--		 						,@vc_UnAssignedProdLoc		= @vc_UnAssignedProdLoc
--		 						,@vc_UnAssignedStrategy		= @vc_UnAssignedStrategy
--								,@i_TradePeriodFromID		= @i_TradePeriodFromID
--								,@vc_InternalBAID		= @vc_InternalBAID
--								,@dt_maximumtradeperiodstartdate	= @dt_maximumtradeperiodstartdate
--								,@i_P_EODSnpShtID		= @i_P_EODSnpShtID
--								,@i_Compare_P_EODSnpShtID	= @i_Compare_P_EODSnpShtID
--								,@c_ShowOutMonth		= @c_ShowOutMonth
--								,@c_strategy			= @c_strategy
--								,@i_RprtCnfgID			= @i_RprtCnfgID
--								,@vc_AdditionalColumns		= @vc_AdditionalColumns	Out
--								,@i_WhatIf_ID			= @i_WhatIf_ID
--								,@i_WhatIf_Compare_ID		= @i_WhatIf_Compare_ID
--								,@b_discountpositions		= @b_discountpositions
--								,@c_OnlyShowSQL			= @c_OnlyShowSQL
--								,@sdt_SnapshotBeginDate_1	= @sdt_SnapshotBeginDate_1
--								,@sdt_SnapshotBeginDate_2	= @sdt_SnapshotBeginDate_2
--								,@sdt_SnapshotEndofDay_1	= @sdt_SnapshotEndofDay_1
--								,@sdt_SnapshotEndofDay_2	= @sdt_SnapshotEndofDay_2
--								,@c_ShowDailyExposure		= @c_ShowDailyExposure
--								,@c_ShowInventory		= @c_ShowInventory
--								,@c_ShowRiskType		= @c_ShowRiskType
--								,@b_ShowHedgingDeals		= @b_ShowHedgingDeals
--								,@vc_InventoryTypeCode		= @vc_InventoryTypeCode
--End

-- Fill the final temp table to return the results
/*
Create Table #RiskExposureFinalResults
		(
		RiskID				Int		Not Null
		,RiskExposureResultsIdnty	Int		Not Null
		,Description			Varchar(8000)	Null
		,DlDtlID			Int		Null
		,RiskType			Char(1)		Null
		,PeriodStartDate		SmallDateTime	Null
		,PeriodEndDate			SmallDateTime	Null
		,PeriodGroupStartDate		SmallDateTime	Null
		,PeriodGroupEndDate		SmallDateTime	Null
		,Position			Float		Null
		,StrtgyID			Int		Null
		,PricedInPercentage		Float		Null
		,PortfolioOrPositionGroup	VarChar(8000)	Null
		,ExposureQuoteDate		SmallDateTime	Null
		)

	Create NonClustered Index ID_#FinalResultsExposure_RiskID on #FinalResultsExposure (RiskID)
end
*/
If @vc_StatementGrouping = 'LoadFinalResults'
Begin
	Declare @vc_positionsql  varchar(8000)

	Select	@vc_positionsql  = 	Case	When	@b_DiscountPositions = 1
						Then	
		'Case	When	#RiskExposureResults.IsQuotational = 1
			Then	#RiskExposureResults.Position
			Else	#RiskExposureResults.Position * IsNull(#RiskExposureResults.DiscountFactor, 1.0)
		End'
						Else	'#RiskExposureResults.Position'
					End

	select	@vc_DynamicSQL  = '
	Insert	#RiskExposureFinalResults
		(
		RiskID
		,RiskExposureResultsIdnty
		,Description
		,DlDtlID
		,RiskType
		,PeriodStartDate
		,PeriodEndDate
		,PeriodGroupStartDate
		,PeriodGroupEndDate
		,Position
		,StrtgyID
		,PricedInPercentage
		,PortfolioOrPositionGroup
		,ExposureQuoteDate
		)
	Select	#RiskExposureResults.RiskID
		,#RiskExposureResults.Idnty
		,RiskDealIdentifier.Description
		,RiskDealIdentifier.DlDtlID
		,#RiskExposureResults.RiskType
		,#RiskExposureResults.PeriodStartDate
		,#RiskExposureResults.PeriodEndDate
		,Case When #RiskExposureResults.PeriodStartDate > ''' + convert(varchar(20), DateAdd(minute, -1, DateAdd(day, 1, @dt_maximumtradeperiodstartdate)) ,20) + ''' Then ''12/31/2050'' Else #RiskExposureResults.PeriodStartDate End
		,Case When #RiskExposureResults.PeriodStartDate > ''' + convert(varchar(20), DateAdd(minute, -1, DateAdd(day, 1, @dt_maximumtradeperiodstartdate)) ,20) + ''' Then ''12/31/2050'' Else #RiskExposureResults.PeriodEndDate End
		,' + @vc_positionsql + '
		,Coalesce(#RiskExposureResults.StrtgyID, Risk.StrtgyID)
		,Case	When	#RiskExposureResults. TotalPercentage = 0.0 
			Then	0.0 
			Else	IsNull(#RiskExposureResults.PricedInPercentage, 1.0) / #RiskExposureResults. TotalPercentage 
		End	--Priced In %
		,' + IsNull(dbo.RiskColumnPortfolioOrPositionGroup(@vc_type, @i_id, 'Y', 'N', 'N', 'Coalesce(#RiskExposureResults.StrtgyID, Risk.StrtgyID)', 'Risk.PrdctID', 'Risk.ChmclID', 'Risk.LcleID'), 'Null') + '
		,' + Case When @c_ExposureType in('P', 'Y', 'H', 'D' ) Then 'IsNull(#RiskExposureResults.ExposureStartDate, #RiskExposureResults.EndOfDay)' Else 'Convert(SmallDateTime, Null)' End + '
	From	#RiskExposureResults
		Left Outer Join dbo.Risk (NoLock)		On	#RiskExposureResults.RiskID	= Risk.RiskID
		Left Outer Join dbo.RiskDealIdentifier (NoLock)	On	Risk.RiskDealIdentifierID	= RiskDealIdentifier.RiskDealIdentifierID'

	------------------------------------------------------------------------------------------------------------------------------
	-- Return the data
	------------------------------------------------------------------------------------------------------------------------------
	if @c_OnlyShowSQL = 'Y'
		select	@vc_DynamicSQL
	Else
		Execute	(@vc_DynamicSQL)
End

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTV_RER_SRA_Risk_Report_Exposure_UpdateTempTables >>>'
	  END

