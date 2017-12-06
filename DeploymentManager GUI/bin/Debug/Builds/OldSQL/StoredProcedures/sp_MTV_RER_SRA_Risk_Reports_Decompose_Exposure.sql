/****** Object:  StoredProcedure [dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure] 	@i_P_EODSnpShtID	Int		= Null
								,@i_P_EODSnpShtLgID	Int		= Null
								,@i_Compare_P_EODSnpShtID Int		= Null
								,@c_ShowDailyExposure	char(1)		= Null
								,@b_IsCurrentExposure	char(1)		= 'N'
								,@b_ShowRiskDecomposed	Bit		= 1
								,@c_InventoryType	Char(1)		= 'B'
								,@b_IsReport		Bit 		= 1
								,@vc_AdditionalColumns 	VarChar(8000)	= Null
								,@vc_TempTableName	VarChar(128)	= '#RiskResults'
								,@c_OnlyShowSQL		Char(1)		= 'N'
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure, taken from Original SP  SRA_Risk_Reports_Decompose_Exposure. 
			--Due to performance issue at #Exposure temp table in while loop. Inserting data at curve level 2 or 3 causing query 
			--to run very slow. So after each loop, dropping indexes of temp table #Exposure and creating them increase performance of insert       
-- Overview:	
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Amar Kenguva

------------------------------------------------------------------------------------------------------------------------------
set Quoted_Identifier OFF
Set NoCount ON

----------------------------------------------------------- 
-- Check that we at least have a curve to load
-----------------------------------------------------------
--If	@i_PriceCurveId Is Null
--Or	@i_PriceTypeID	Is Null
--	Return

/*----------------------------------------------------------- 
-- Declare Local Variables
-----------------------------------------------------------*/
Declare @errno 				Int
Declare @dt_CurrentTime			DateTime
Declare	@errmsg 			VarChar(255)
Declare	@i_CurveLevel			TinyInt
Declare	@i_rowcount			Int

Select	@errno 				= '60000'
Select	@i_CurveLevel			= 0
Select	@i_rowcount			= 1
If @dt_CurrentTime Is Null
	Select @dt_CurrentTime = Current_TimeStamp

----------------------------------------------------------------------------------------------------
-- SQL Variables
----------------------------------------------------------------------------------------------------
Declare @vc_DynamicSQL			VarChar(8000)
Declare @vc_DynamicSQL_InsertTemplate	VarChar(8000)
Declare @vc_DynamicSQL_CurveDescription	VarChar(8000)
Declare @vc_DynamicSQL_Insert		VarChar(8000)
Declare @vc_DynamicSQL_GroupBy		VarChar(8000)
Declare @vc_DynamicSQL_GroupByTemplate	VarChar(8000)
Declare @vc_DynamicSQL_UpdateCurveStructureDescription	VarChar(8000)

----------------------------------------------------------------------------------------------------
-- Performance Variables
----------------------------------------------------------------------------------------------------
Declare	@b_RiskCurveExposure_Table_HasNonMonthlyRows	Bit
Declare	@b_RiskCurveExposureQuote_Table_HasRows		Bit

Select	@b_RiskCurveExposure_Table_HasNonMonthlyRows	= Case When Exists ( Select 1 From RiskCurveExposure Where QuoteStartDate Is Not Null ) Then 1 Else 0 End
Select	@b_RiskCurveExposureQuote_Table_HasRows		= Case When Exists ( Select 1 From RiskCurveExposureQuote) Then 1 Else 0 End


-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete quotational rows that shouldn't show exposure based on the Prvsn.ExposureStatus
-----------------------------------------------------------------------------------------------------------------------------------------------------
if @b_IsCurrentExposure = 'N'
begin

    Select @vc_DynamicSQL = '
    Delete	#RiskResults
    From	' + @vc_TempTableName + ' #RiskResults
    Where	#RiskResults. IsQuotational	= Convert(Bit, 1)
    And	Exists	(
			    Select	""
			    From	dbo.RiskDealDetailProvision	(NoLock)
				    Inner Join dbo.Prvsn	(NoLock)	On	Prvsn. PrvsnID		= RiskDealDetailProvision. DlDtlPrvsnPrvsnID
			    Where	RiskDealDetailProvision. DlDtlPrvsnID	= #RiskResults. DlDtlPrvsnID
			    And	#RiskResults. InstanceDateTime		Between RiskDealDetailProvision. StartDate and RiskDealDetailProvision. EndDate
			    And	Prvsn. ExposureStatus	<> RiskDealDetailProvision. CostType
			    And	Prvsn. ExposureStatus	<>''B''
			    )'


    If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)



	select  @vc_DynamicSQL = '
    Update  #RiskResults
    Set	    PrdctID	=   Risk. PrdctID
    From	' + @vc_TempTableName + ' #RiskResults
	    Inner Join	Risk (NoLock) on    #RiskResults.RiskID	=   Risk.RiskID'
	    
	   
    If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


    -----------------------------------------------------------------------------------------------------------------------------------------------------
    -- Delete Futures that have rolled off ( Need this since some futures are quotational which means the end date of RiskCurveLink won't work
    -----------------------------------------------------------------------------------------------------------------------------------------------------
    Select @vc_DynamicSQL = '
    Delete	#RiskResults
    From	' + @vc_TempTableName + ' #RiskResults
    Where	#RiskResults. DlDtlTmplteID In( ' + dbo.GetDlDtlTmplteIds('Futures All Types') + ')
    And	Not Exists	(
			    Select	""
			    From	RawPriceLocalePricingPeriodCategory	(NoLock)
				    Inner Join PricingPeriodCategoryVETradePeriod (NoLock)
									    On	PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID	= RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID
									    And	#RiskResults.EndOfDay						<= DateAdd(day, -1, PricingPeriodCategoryVETradePeriod.RollOffBoardDate)
									    And	PricingPeriodCategoryVETradePeriod.VETradePeriodID		= #RiskResults. VETradePeriodID
			    Where	RawPriceLocalePricingPeriodCategory.RwPrceLcleID		= #RiskResults. RwPrceLcleID
			    And	RawPriceLocalePricingPeriodCategory.IsUsedForSettlement		= Convert(Bit, 1)
			    )
	And	Not Exists	(
		Select	1
		From	dbo.ProductInstrument
		Where	ProductInstrument. PrdctID				= #RiskResults. PrdctID
		And	ProductInstrument. InstrumentType			= ''F''	-- Future
		And	IsNull(ProductInstrument. DefaultSettlementType, ''Z'')	= ''P'' -- Physically Settled
		And	ProductInstrument. PhysicalRwPrceLcleID			Is Not Null
		And	ProductInstrument. PhysicalPriceTypeID			Is Not Null
		)'


    If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
end	    
	    
----------------------------------------------------------------------------------------------
-- Delete relative period exposure (both Current Exposure and Risk Exposure)
----------------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Delete	#RiskResults
From	' + @vc_TempTableName + ' #RiskResults
Where	Exists	(
	Select	1 
	From	dbo.VETradePeriod	(NoLock)
	Where	VETradePeriod.VETradePeriodID	= #RiskResults. VETradePeriodID
	And	VETradePeriod.Type		= ''R'' 
		)'
    	    
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)    	    

----------------------------------------------------------------------------------------------
-- Delete the quotational exposures that have rolled off
----------------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Delete	#RiskResults
From	' + @vc_TempTableName + ' #RiskResults
Where	#RiskResults. IsQuotational	= Convert(Bit, 1)
And	Not Exists	(
		Select	1
		From	dbo.FormulaEvaluationPercentage	(NoLock)
		Where	FormulaEvaluationPercentage. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
		And	#RiskResults. EndOfDay < FormulaEvaluationPercentage. QuoteRangeEndDate
		)'

If @c_ShowDailyExposure in ('N', 'Y')
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- If it's a physically settled future, then update the curve prod/loc to the underlying physical
-----------------------------------------------------------------------------------------------------------------------------------------------------
Select @vc_DynamicSQL = '
Update	#RiskResults
Set	RiskCurveID		= RiskCurve. RiskCurveID
	,CurveProductID		= RawPriceLocale. RPLcleChmclParPrdctID
	,CurveChemProductID	= RawPriceLocale. RPLcleChmclChdPrdctID
	,CurveLcleID		= RawPriceLocale. RPLcleLcleID
	,CurveServiceID		= RawPriceLocale. RPLcleRPHdrID
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.ProductInstrument (NoLock)	On	ProductInstrument. PrdctID			= #RiskResults. PrdctID
							And	ProductInstrument. InstrumentType		= ''F''
							And	ProductInstrument. DefaultSettlementType	= ''P''
	Inner Join dbo.RawPriceLocale (NoLock)		On	RawPriceLocale. RwPrceLcleID			= ProductInstrument. PhysicalRwPrceLcleID
	Left Outer Join dbo.RiskCurve (NoLock)		On	RiskCurve. RwPrceLcleID				= ProductInstrument. PhysicalRwPrceLcleID
							And	RiskCurve. PrceTpeIdnty				= ProductInstrument. PhysicalPriceTypeID
							And	RiskCurve. VETradePeriodID			= #RiskResults. VETradePeriodID -- BMM: this may not work if periods dont match
Where	#RiskResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Futures All Types') + ')
And	ProductInstrument. PhysicalRwPrceLcleID	Is Not Null
And	ProductInstrument. PhysicalPriceTypeID	Is Not Null'

If  IsNull(dbo.GetRegistryValue('\System\PortfolioAnalysis\Mark Physically Delivered Futures after Rolloff to Underlying Physical'), 'N') = 'Y'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- If we're showing historical exposure, we're going to keep the non-daily quotational around, so update the percentage columns.
-----------------------------------------------------------------------------------------------------------------------------------------------------
If @c_ShowDailyExposure = 'H'
Begin
	Select @vc_DynamicSQL = '
	Update	#RiskResults
	Set	PricedInPercentage	= FormulaEvaluationPercentage.PricedInPercentage * FormulaEvaluationPercentage.TotalPercentage * RiskQuotationalExposure.FormulaPercentage
		,Percentage		= 1.0--FormulaEvaluationPercentage.PricedInPercentage
	From	' + @vc_TempTableName + ' #RiskResults
		Inner Join dbo.RiskQuotationalExposure		(NoLock)	On	RiskQuotationalExposure. RiskID				= #RiskResults. RiskID
		Inner Join dbo.FormulaEvaluationPercentage	(NoLock)	On	FormulaEvaluationPercentage. FormulaEvaluationID	= RiskQuotationalExposure. FormulaEvaluationID
		And	FormulaEvaluationPercentage. TotalPercentage		<>	0.0
		And	FormulaEvaluationPercentage.VETradePeriodID		=	#RiskResults.VETradePeriodID
		And	#RiskResults.EndOfDay					Between FormulaEvaluationPercentage. EndOfDayStartDate		And FormulaEvaluationPercentage. EndOfDayEndDate 		
	Where	#RiskResults.RiskType = "Q"
	'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
End

----------------------------------------------------------------------------------------------
-- Delete the physical exposrue BALMO & Monthly Average Futures since we're tracking it on quotational records
----------------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Update	#RiskResults
Set	NumberOfQuotesForPeriod	= IsNull(
				( 
				Select	Count(1)
				From	dbo.FormulaEvaluationQuote
				Where	FormulaEvaluationQuote. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
				And	FormulaEvaluationQuote. VETradePeriodID		= #RiskResults. VETradePeriodID
				), 0)
From	' + @vc_TempTableName + ' #RiskResults
Where	#RiskResults. IsQuotational	= Convert(Bit, 1)
'
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-------------------------------------------------------------
-- Create Temp Tables
-------------------------------------------------------------
Create	Table	#Exposure
(
	Idnty				Int		Not Null Identity
	,ParentIdnty			Int		Not Null
	,RiskResultsIdnty		Int		Not Null
	,RiskExposureTableIdnty		Int		Null
	,SourceTable			Varchar(3)	Not Null
	,DlDtlPrvsnRwID			Int		Null
	,IsQuotational			Bit		Not Null
	,CurveLevel			SmallInt	Not Null
	,ParentRiskCurveID		Int		Null		-- Will be null for spot curves where the VETradePeriod is Null.  Need to let them get in the table so we can calculate the correct daily exposure
	,RiskCurveID			Int		Null 		-- Will be null for spot curves where the VETradePeriod is Null.  Need to let them get in the table so we can calculate the correct daily exposure
	,QuoteDate			SmallDateTime	Not Null
	,AdjustedQuoteDate		SmallDateTime	Not Null
	,Position			Float		Null
	,Percentage			Float		Null
	,IsBottomLevel			Bit		Not Null Default 1
	,InstanceDateTime		SmallDateTime	Not Null
	,EndOfDay			SmallDateTime	Not Null
	,CalendarId			SmallInt	Null
	,ExposurePercentage		Float		Null
	,QuoteDateIsDefault		Bit		Not Null Default 0	-- Used for Physical exposure since the quote date defaults to today.  Needed so decomposed daily physical exposure isn't excluded
	,PromptVETradePeriodID		SmallInt	Null			-- Used for provisions that are set to roll to prompt for expired periods (Platts WTI)
	,CurveStructure			Varchar(100)	Null
	,CurveStructureDescription	Varchar(1000)	Null
	,UseCurrentActual			Varchar(75)	Null
	,RPRPDtlIdnty				Int		Null
	,IsExpiredCurve			Bit Not Null Default 0
	,IsPromptCurve			Bit		Not Null	Default 0	-- This is obsolete
	,IsMonthlyDecomposedPhysical	Bit	Not Null Default 1	-- Is it normal monthly exposure.  Needed for showing daily exposure for physical curves that decompose.  HK & Balmo would be 0
	,RiskCurveExposureID		Int	Not Null
	,CashSettledFuturesOverrideEndOfDay	SmallDateTime	Null
	,IsRiskCurveExposureQuote	Bit		Not Null Default 0
)
Create Clustered Index PK_#Exposure on #Exposure (Idnty)
Create Index IE_#Exposure on #Exposure (RiskExposureTableIdnty)
Create Index IE2_#Exposure on #Exposure (RiskCurveExposureID)
Create Index IE3_#Exposure On #Exposure (RiskCurveID, ParentRiskCurveID, DlDtlPrvsnRwID, EndOfDay, RiskResultsIdnty, RiskExposureTableIdnty)

If @c_OnlyShowSQL = 'Y'
	Select '
	Create	Table	#Exposure
	(
		Idnty				Int		Not Null Identity
		,ParentIdnty			Int		Not Null
		,RiskResultsIdnty		Int		Not Null
		,RiskExposureTableIdnty		Int		 Null
		,SourceTable			Varchar(3)	Not Null
		,DlDtlPrvsnRwID			Int		Null
		,IsQuotational			Bit		Not Null
		,CurveLevel			SmallInt	Not Null
		,ParentRiskCurveID		Int		Null		-- Will be null for spot curves where the VETradePeriod is Null.  Need to let them get in the table so we can calculate the correct daily exposure
		,RiskCurveID			Int		Null 		-- Will be null for spot curves where the VETradePeriod is Null.  Need to let them get in the table so we can calculate the correct daily exposure
		,QuoteDate			SmallDateTime	Not Null
		,AdjustedQuoteDate		SmallDateTime	Not Null
		,Position			Float		Null
		,Percentage			Float		Null
		,IsBottomLevel			Bit		Not Null Default 1
		,InstanceDateTime		SmallDateTime	Not Null
		,CalendarId			SmallInt	Null
		,EndOfDay			SmallDateTime	Not Null
		,ExposurePercentage		Float		Null
		,QuoteDateIsDefault		Bit		Not Null Default 0 
		,PromptVETradePeriodID		SmallInt	Null			-- Used for provisions that are set to roll to prompt for expired periods (Platts WTI)
		,CurveStructure			Varchar(100)	Null
		,CurveStructureDescription	Varchar(1000)	Null
		,UseCurrentActual			Varchar(75)	Null
		,RPRPDtlIdnty				Int		Null
		,IsExpiredCurve			Bit Not Null Default 0
		,IsPromptCurve			Bit		Not Null	Default 0		-- This is obsolete
		,IsMonthlyDecomposedPhysical	Bit	Not Null Default 1	-- Is it normal monthly exposure.  Needed for showing daily exposure for physical curves that decompose.  HK & Balmo would be 0
		,RiskCurveExposureID		Int	Not Null
		,CashSettledFuturesOverrideEndOfDay	SmallDateTime	Null
		,IsRiskCurveExposureQuote	Bit		Not Null Default 0
	)
	Create Clustered Index PK_#Exposure on #Exposure (Idnty)
	Create Index IE_#Exposure on #Exposure (RiskExposureTableIdnty)
	Create Index IE2_#Exposure on #Exposure (RiskCurveExposureID)
	Create Index IE3_#Exposure On #Exposure (RiskCurveID, ParentRiskCurveID, DlDtlPrvsnRwID, EndOfDay, RiskResultsIdnty, RiskExposureTableIdnty)
	'

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create Results Temp Table
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if @c_OnlyShowSQL = 'Y'
	Select	'
	Create Table #ExposureResults
		(
		Idnty			Int	Not Null 	Identity
		,RiskResultsIdnty	Int	Not Null
		,RiskExposureTableIdnty Int	 Null
		,RiskCurveID			Int		Null
		,CurveLevel			SmallInt	Not Null
		,Percentage			Float		Null
		,TotalPercentage		Float		Null
		,Position			Float		Null
		,PricedInPercentage		Float		Null
		,QuoteDate			SmallDateTime	Null	-- Daily Exposure Only
		,QuoteStartDate			SmallDateTime	Null	-- Non Daily Exposure Only
		,QuoteEndDate			SmallDateTime	Null	-- Non Daily Exposure Only
		,IsBasisCurve			Bit		Not Null 	Default 0
		,IsDailyPricingRow		Bit		Not Null	Default 0
		,MonthlyRatioPercentage		Float		Null
		,CurveStructureDescription	Varchar(1000)	Null
		)
	Create NonClustered Index IE_#ExposureResults_RiskResultsIdnty on #ExposureResults (RiskResultsIdnty)
	'

If dbo.GetTableColumns('#ExposureResults') Not like '%RiskResultsIdnty%'
Begin
	Create Table #ExposureResults
		(
		Idnty			Int	Not Null	Identity
		,RiskResultsIdnty	Int	Not Null
		,RiskExposureTableIdnty Int	 Null
		,RiskCurveID			Int		Null
		,CurveLevel			SmallInt	Not Null
		,Percentage			Float		Null
		,TotalPercentage		Float		Null
		,Position			Float		Null
		,PricedInPercentage		Float		Null
		,QuoteDate			SmallDateTime	Null	-- Daily Exposure Only
		,QuoteStartDate			SmallDateTime	Null	-- Non Daily Exposure Only
		,QuoteEndDate			SmallDateTime	Null	-- Non Daily Exposure Only
		,IsBasisCurve			Bit		Not Null 	Default 0
		,IsDailyPricingRow		Bit		Not Null	Default 0
		,MonthlyRatioPercentage		Float		Null
		,CurveStructureDescription	Varchar(1000)	Null
		)
		
	Create NonClustered Index IE_#ExposureResults_RiskResultsIdnty on #ExposureResults (RiskResultsIdnty)
End

--------------------------------------------------------------------------------------------------------------------------------------------------
-- Add CurveStructureDescription Column if it's been added to the report
--------------------------------------------------------------------------------------------------------------------------------------------------
If	dbo.GetTableColumns(@vc_TempTableName)	Not like '%CurveStructureDescription%'
And	(
	@c_OnlyShowSQL = 'Y' 
Or	IsNull(@vc_AdditionalColumns, '')	Like '%CurveStructureDescription%'
	)
Begin
	Select @vc_DynamicSQL = '
	Alter Table ' + @vc_TempTableName + '	Add	CurveStructureDescription	Varchar(1000)	Null
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL  + Case When @c_OnlyShowSQL = 'Y' Then Char(10) + Char(13) + 'G' + 'o' Else '' End
	Execute(@vc_DynamicSQL)
End

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for Physical Exposure for CurveLevel 0
------------------------------------------------------------------------------------------------------------------------------------------------------
Select @vc_DynamicSQL = '
Insert	#Exposure
(
	RiskResultsIdnty
	,ParentIdnty
	,RiskExposureTableIdnty
	,SourceTable
	,DlDtlPrvsnRwID
	,IsQuotational
	,Position
	,Percentage
	,CurveLevel
	,ParentRiskCurveID
	,RiskCurveID
	,InstanceDateTime
	,EndOfDay
	,QuoteDate
	,AdjustedQuoteDate
	,IsBottomLevel
	,QuoteDateIsDefault
	,IsMonthlyDecomposedPhysical
	,CurveStructure
	,RiskCurveExposureID
)
Select	#RiskResults. Idnty
	,0	ParentIdnty
	,#RiskResults. RiskExposureTableIdnty
	,#RiskResults. SourceTable
	,#RiskResults. DlDtlPrvsnRwID
	,#RiskResults. IsQuotational
	,#RiskResults. Position
	,#RiskResults. TotalPercentage
	,0 CurveLevel
	,#RiskResults. RiskCurveID	ParentRiskCurveID	-- Calculated
	,#RiskResults. RiskCurveID	RiskCurveID		-- Calculated
	,IsNull(#RiskResults. InstanceDateTime, getdate()) InstanceDateTime
	,#RiskResults. EndOfDay
	,Case	When #RiskResults. DlDtlTmplteID Not In(' + dbo.GetDlDtlTmplteIds('Physicals') + ')  -- Physicals
		Then IsNull(RiskPhysicalExposure. QuoteDate, #RiskResults. EndOfDay)
		Else #RiskResults. EndOfDay
	End QuoteDate
	,Case	When #RiskResults. DlDtlTmplteID Not In(' + dbo.GetDlDtlTmplteIds('Physicals') + ')  -- Physicals
		Then IsNull(RiskPhysicalExposure. QuoteDate, #RiskResults. EndOfDay)
		Else #RiskResults. EndOfDay
	End	 AdjustedQuoteDate
	,Case	When RawPriceLocale. DecomposePhysicalExposure = 0 
		And Not Exists (
				Select	1
				From	dbo.ProductInstrument	(NoLock)
				Where	ProductInstrument. PrdctId		= IsNull(#RiskResults. PrdctID, #RiskResults.CurveProductID)
				And	ProductInstrument. InstrumentType	= ''F''
				And	ProductInstrument. DefaultSettlementType = ''C''
				)
		And #RiskResults.IsQuotational = 0 Then 1
		When RawPriceLocale. DecomposeQuotationalExposure = 0 And #RiskResults.IsQuotational = 1 Then 1 Else 0 End	IsBottomLevel
	,Case	When	#RiskResults. DlDtlTmplteID In(' + dbo.GetDlDtlTmplteIds('Physicals') + ')  -- Physicals
		Or	RiskPhysicalExposure. QuoteDate Is Null
		Then 1 Else 0
	End QuoteDateIsDefault
	,1 IsMonthlyDecomposedPhysical
	,#RiskResults. RiskCurveID	-- CurveStructure
	,0	RiskCurveExposureID
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.RawPriceLocale			On	RawPriceLocale. RwPrceLcleID			= #RiskResults. RwPrceLcleID
	Left Outer Join dbo.RiskPhysicalExposure	On	RiskPhysicalExposure. RiskPhysicalExposureID	= #RiskResults. RiskExposureTableIdnty
											' + Case When @b_IsCurrentExposure = 'Y' Then ' And  1 = 2 ' Else ' ' End + '
Where	#RiskResults. RiskCurveID			Is Not Null
And	#RiskResults. IsQuotational			= Convert(Bit, 0)
And	RawPriceLocale. DecomposePhysicalExposure	= Convert(Bit, 1)
And	Not (IsCashSettledFuture = 1 And #RiskResults.PricedInPercentage = 1)'

if @b_ShowRiskDecomposed= 1
begin
    if @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
end
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert for Quotational Exposure for CurveLevel 0 - Daily
-- Curves with Calculated Price Types will be Split into Seperate rows with the noncalculated RiskCurveIDs
------------------------------------------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL = '
Insert	#Exposure
(
	RiskResultsIdnty
	,ParentIdnty
	,RiskExposureTableIdnty
	,SourceTable
	,DlDtlPrvsnRwID
	,IsQuotational
	,Position
	,Percentage
	,CurveLevel
	,ParentRiskCurveID	-- Calculated
	,RiskCurveID		-- Calculated
	,InstanceDateTime
	,EndOfDay
	,QuoteDate
	,AdjustedQuoteDate
	,IsBottomLevel
	,IsMonthlyDecomposedPhysical
	,CurveStructure
	,RiskCurveExposureID
)
Select	#RiskResults. Idnty
	,0		ParentIdnty
	,#RiskResults. RiskExposureTableIdnty
	,#RiskResults. SourceTable
	,#RiskResults. DlDtlPrvsnRwID
	,#RiskResults. IsQuotational
	,#RiskResults. Position * Case When NumberOfQuotesForPeriod = 0.0 Then 1.0 Else (Convert(Float, Convert(Float, 1.0) / NumberOfQuotesForPeriod )) End--(DateDiff(Day, FormulaEvaluationPercentage. QuoteRangeBeginDate, FormulaEvaluationPercentage. QuoteRangeEndDate) + 1)))-- * #RiskResults. TotalPercentage) -- Convert(Float,(Convert(Float, 1.0) / #RiskResults. TotalPercentage)))
	,Convert(Float, Convert(Float, 1.0) / FormulaEvaluation. NumberOfQuotes) Percentage
	,0 CurveLevel
	,#RiskResults. RiskCurveID	ParentRiskCurveID
	,#RiskResults. RiskCurveID	RiskCurveID 
	,IsNull(#RiskResults. InstanceDateTime, getdate()) InstanceDateTime
	,#RiskResults. EndOfDay
	,Case When #RiskResults. DlDtlTmplteID In(' + dbo.GetDlDtlTmplteIDs('Futures All Types') + ') Then #RiskResults. EndOfDay Else FormulaEvaluationQuote. QuoteDate End
	,Case When #RiskResults. DlDtlTmplteID In(' + dbo.GetDlDtlTmplteIDs('Futures All Types') + ') Then #RiskResults. EndOfDay Else FormulaEvaluationQuote. QuoteDate End
	,Case When RawPriceLocale. DecomposeQuotationalExposure = 0 Then 1 Else 0 End IsBottomLevel
	,0 IsMonthlyDecomposedPhysical
	,#RiskResults. RiskCurveID	-- CurveStructure
	,0	RiskCurveExposureID
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.RawPriceLocale		On	RawPriceLocale. RwPrceLcleID			= #RiskResults. RwPrceLcleID
	Inner Join dbo.FormulaEvaluationPercentage	On	FormulaEvaluationPercentage. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
							And	FormulaEvaluationPercentage. VETradePeriodID		= #RiskResults. VETradePeriodID
							And	#RiskResults. EndOfDay	Between FormulaEvaluationPercentage. EndOfDayStartDate and FormulaEvaluationPercentage. EndOfDayEndDate
	Inner Join dbo.FormulaEvaluationQuote	On	FormulaEvaluationQuote. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
						And	FormulaEvaluationQuote. VETradePeriodID		= #RiskResults. VETradePeriodID
	Inner Join dbo.FormulaEvaluation	On	FormulaEvaluation. FormulaEvaluationID		= #RiskResults. FormulaEvaluationID
Where	(
	#RiskResults. RiskCurveID		Is Not Null
Or	#RiskResults. VETradePeriodID		= 0
	)
And	#RiskResults. IsQuotational		= Convert(Bit, 1)
' + Case 
	-- If we're not showing daily exposure, then don't insert quotes since the original row in #RiskResults is all that's needed
	When @c_ShowDailyExposure = 'N' Then '
And	RawPriceLocale. DecomposeQuotationalExposure = Convert(Bit, 1)'
	When @c_ShowDailyExposure <> 'H' Then '
And	Convert(SmallDateTime, Convert(VarChar(12), FormulaEvaluationQuote. QuoteDate))	> #RiskResults. EndOfDay
' Else '' End
 -- JGV - No need to filter out "IsCashSettledFuture" because it'll fall out of the join to FormulaEvaluation
 -- BMM - Can't add the filter for FormulaEvaluationQuote > EOD, because the priced in % will not calculate correctly.


if @b_ShowRiskDecomposed= 1  Or @c_ShowDailyExposure <> 'N'
begin
    if @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
end

------------------------------------------------------------------------------------------------------------------------------------------------
-- If we're not showing daily, then delete rows that don't have any rows in RiskCurveExposure.  Hopefully this helps performance
------------------------------------------------------------------------------------------------------------------------------------------------
If  @c_ShowDailyExposure = 'N'
Begin
	Select	@vc_DynamicSQL = '
	Delete	#Exposure
	From	#Exposure
		Inner Join dbo.RiskCurveRelation (NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
	Where	Not Exists	(
		Select 1
		From	dbo.RiskCurveExposure (NoLock)
		Where	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
		and	RiskCurveExposure. Percentage		<> 0.0
				)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	-- Update the position for priced in % if there's no Exposure records.  This needs to be done here since it's handled after decomposition
	Select	@vc_DynamicSQL = '
	Update	#RiskResults
	Set	Position	= Position  * (1.0 - Case When #RiskResults. TotalPercentage = 0.0 Then 1.0 Else #RiskResults. PricedInPercentage / #RiskResults. TotalPercentage End)
	From	' + @vc_TempTableName + ' #RiskResults
	Where	#RiskResults. IsQuotational = Convert(Bit, 1)
	And	#RiskResults. DlDtlTmplteID	Not In (' + dbo.GetDlDtlTmplteIDs('Exchange Traded Options All Types, Over the Counter Options All Types') + ')
	And	Not Exists	(
		Select 1
		From	dbo.#Exposure
		Where	#Exposure. RiskResultsIdnty	= #RiskResults. Idnty
				)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
End
------------------------------------------------------------------------------------------------------------------------------------------------
-- If we are showing daily exposure, then update is bottom level if there's no rows in RiskCurveExposure
------------------------------------------------------------------------------------------------------------------------------------------------
Else
Begin
	Select	@vc_DynamicSQL = '
	Update	#Exposure
	Set	IsBottomLevel	= Convert(Bit, 1)
	From	#Exposure
		Inner Join dbo.RiskCurveRelation (NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
	Where	Not Exists	(
		Select 1
		From	dbo.RiskCurveExposure (NoLock)
		Where	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
		and	RiskCurveExposure. Percentage		<> 0.0
				)'

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	--Skip decompose logic for historical days.
	If @c_ShowDailyExposure = 'H'
	Begin
		Select	@vc_DynamicSQL = '
		Update	#Exposure
		Set	IsBottomLevel	= Convert(Bit, 1)
		From	#Exposure			
		Where	#Exposure.QuoteDate	< #Exposure.EndOfDay
		And	#Exposure.IsQuotational	= Convert(Bit, 1)'
	
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End	
End



If @c_OnlyShowSQL = 'Y'
	Select '
	-- Delete #Exposure Where QuoteDate <> ''2005-06-01''
	'
------------------------------------------------
-- Update CurveStructureDescription
------------------------------------------------
Select	@vc_DynamicSQL_CurveDescription = 'Case 
        When IsNull(ParentExposure. CurveStructureDescription, '''') = '''' 
        Then Convert(Varchar, Convert(Decimal(6,2), 
		Case When IsNull(#RiskResults.TotalPercentage, 1.0) * 100.0 > 9999.99 Then 9999.99
                When IsNull(#RiskResults.TotalPercentage, 1.0) * 100.0 < -9999.99 Then -9999.99
		Else IsNull(#RiskResults.TotalPercentage, 1.0) * 100.0 End
	))  + "%-"
        Else IsNull(ParentExposure. CurveStructureDescription, '''') 
                + ''|||Level:@@CurveLevel@@=>|||'' 
                + Convert(Varchar, Convert(Decimal(6,2), 
                        Case When IsNull(#Exposure.ExposurePercentage, 1.0) * 100.0 > 9999.99 Then 9999.99
                        When IsNull(#Exposure.ExposurePercentage, 1.0) * 100.0 < 9999.99 Then -9999.99
		        Else IsNull(#Exposure.ExposurePercentage, 1.0) * 100.0 End 
        )) + "%-" 
        End 
	+ Convert(Varchar(66), Coalesce(Null, Convert(Varchar, RiskCurve. RiskCurveID) + "-" + RawPriceHeader. RPHdrAbbv + "-" + Product. PrdctAbbv + "@" + Locale. LcleAbbrvtn, "Unknown Curve") + "-" + IsNull(PriceType.PrceTpeNme, "N/A") + "-" + IsNull(VETradePeriod. Name, "N/A"))'
				
Select	@vc_DynamicSQL_UpdateCurveStructureDescription = '
Update	#Exposure
Set	CurveStructureDescription =	' + @vc_DynamicSQL_CurveDescription + '
From	#Exposure
	Inner Join RiskCurve		(NoLock)	On RiskCurve. RiskCurveID	= #Exposure. RiskCurveID
	Inner Join RawPriceLocale	(NoLock)	On RawPriceLocale. RwPrceLcleID	= RiskCurve. RwPrceLcleID
	Inner Join Product		(NoLock)	On RiskCurve.PrdctID		= Product.PrdctID
	Inner Join Locale		(NoLock)	On RiskCurve.LcleID		= Locale.LcleID
	Inner Join RawPriceHeader	(NoLock)	On RiskCurve.RPHdrID		= RawPriceheader.RPHdrID
	Inner Join VETradePeriod	(NoLock)	On RiskCurve.TradePeriodFromDate = VETradePeriod.StartDate
							And RiskCurve.TradePeriodToDate = VETradePeriod.EndDate
	Inner Join PriceType		(NoLock)	On RiskCurve.PrceTpeIdnty	= PriceType. Idnty
	Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty		= #Exposure. RiskResultsIdnty
	Left Outer Join #Exposure ParentExposure	On ParentExposure. Idnty = #Exposure. ParentIdnty
Where	#Exposure. CurveLevel	= @@CurveLevel@@
'

If	@c_OnlyShowSQL = 'Y' 
Or	dbo.GetTableColumns('#Exposure')	like '%CurveStructureDescription%'
Begin
	Select @vc_DynamicSQL = Replace(@vc_DynamicSQL_UpdateCurveStructureDescription, '@@CurveLevel@@', '0')
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
End

------------------------------------------------
-- Create Temp table to hold distinct riskcurves
------------------------------------------------
While	@i_CurveLevel	< 10
And	@i_rowcount	> 0
------------------------------------------------------------------------------------------------------------------------------------------------
-- If we are showing daily exposure, but not showing decomposed, then don't allow for decomposition
------------------------------------------------------------------------------------------------------------------------------------------------
And	@b_ShowRiskDecomposed= 1 
Begin
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Calculated Price Type Riskcurves will use RiskCurveRelation to join RiskCurveExposure.RiskCurveID (Not Calculated).
	-- RiskCurveExposure.ChildRiskCurveID can be calculated and will save to #Exposure.RiskCurveID.
	-- Decomposing through multiple layers of average will result in calculated price type riskcurves in #Exposure.RiskCurveID & #Exposure.ParentRiskCurveID
	----------------------------------------------------------------------------------------------------------------------------------------------------------------

	-------------------------------------------
	-- Increment Curve Level
	-------------------------------------------
	Select	@i_CurveLevel		= @i_CurveLevel + 1
		,@i_rowcount	= 0


	Select @vc_DynamicSQL = '
	Update	#Exposure
	Set	CashSettledFuturesOverrideEndOfDay	=	(
								Select	Min(RiskCurveExposure.EndOfDayStartDate)
								From	dbo.RiskCurveRelation	(NoLock)
									Inner Join dbo.RiskCurveExposure (NoLock)	On	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
															And	RiskCurveExposure. QuoteStartDate	Is Null
															And	'','' + #Exposure.CurveStructure + '',''	Not Like ''%,'' + Convert(VarChar, RiskCurveExposure. ChildRiskCurveID) + '',%''
								Where	RiskCurveRelation. RiskCurveID	= #Exposure. RiskCurveID
								And	RiskCurveExposure. RiskCurveID	<> RiskCurveExposure. ChildRiskCurveID
								And	RiskCurveExposure. Percentage	<> 0.0
								And Exists (select 1 from RiskCurveExposureQuote with (NoLock) where RiskCurveExposureQuote.RiskCurveExposureID	=	RiskCurveExposure.RiskCurveExposureID)
								)
	From	' + @vc_TempTableName + ' #RiskResults
		Inner Join #Exposure	On	#Exposure.RiskResultsIdnty	= #RiskResults.Idnty
	Where	#Exposure. CurveLevel			= ' + Convert(varchar, @i_CurveLevel) + ' - 1
	And	#Exposure. IsBottomLevel		= Convert(Bit, 0)
	And	Exists	(
			Select	1
			From	dbo.ProductInstrument	(NoLock)
			Where	ProductInstrument. PrdctId		= IsNull(#RiskResults. PrdctID, #RiskResults.CurveProductID)
			And	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			)'
			
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	Select @vc_DynamicSQL = '
	Update	#Exposure
	Set	CashSettledFuturesOverrideEndOfDay = NULL
	--select *
	From	#Exposure
	Inner Join dbo.' + @vc_TempTableName + '  #RiskResults
		On	#Exposure.RiskResultsIdnty					= #RiskResults.Idnty
	Inner Join dbo.RiskCurve (NoLock)
		On	#Exposure.RiskCurveID						= RiskCurve.RiskCurveID	
	Inner Join dbo.RawPriceLocalePricingPeriodCategory (NoLock)
		On	RiskCurve.RwPrceLcleID						= RawPriceLocalePricingPeriodCategory.RwPrceLcleID
	Inner Join dbo.PricingPeriodCategoryVETradePeriod
		On	RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID	= PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID
		And	PricingPeriodCategoryVETradePeriod.VETradePeriodID		= RiskCurve.VETradePeriodID
	Where	RawPriceLocalePricingPeriodCategory.IsUsedForSettlement			= Convert(Bit, 1)
	And	#RiskResults.IsCashSettledFuture					= Convert(Bit, 1)
	And	#Exposure.CashSettledFuturesOverrideEndOfDay				< PricingPeriodCategoryVETradePeriod.RollOffBoardDate
	And	#Exposure.EndOfDay							>  #Exposure.CashSettledFuturesOverrideEndOfDay	
	'
	--BMM Commented this out since it appears like it will always undo the update from above since the bottom two filters will always be true.
	--If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	
    DROP INDEX PK_#Exposure ON #Exposure;
	DROP INDEX IE_#Exposure ON #Exposure;
	DROP INDEX IE2_#Exposure ON #Exposure;
	DROP INDEX IE3_#Exposure ON #Exposure;

	Create Clustered Index PK_#Exposure on #Exposure (Idnty)
	Create Index IE_#Exposure on #Exposure (RiskExposureTableIdnty)
	Create Index IE2_#Exposure on #Exposure (RiskCurveExposureID)
	Create Index IE3_#Exposure On #Exposure (RiskCurveID, ParentRiskCurveID, DlDtlPrvsnRwID, EndOfDay, RiskResultsIdnty, RiskExposureTableIdnty)
	
	
	Select @vc_DynamicSQL_InsertTemplate = '
	Insert	#Exposure
	(
		ParentIdnty
		,RiskResultsIdnty
		,RiskExposureTableIdnty
		,SourceTable
		,DlDtlPrvsnRwID
		,IsQuotational
		,Position
		,Percentage
		,CurveLevel
		,ParentRiskCurveID	-- Calculated RiskCurveID
		,RiskCurveID		-- Calculated RiskCurveID
		,InstanceDateTime
		,EndOfDay
		,QuoteDate
		,AdjustedQuoteDate
		,ExposurePercentage
		,QuoteDateIsDefault
		,IsExpiredCurve
		,IsMonthlyDecomposedPhysical
		,CurveStructure
		,RiskCurveExposureID
		,IsRiskCurveExposureQuote
	)
	Select	#Exposure. Idnty
		,#Exposure. RiskResultsIdnty
		,#Exposure. RiskExposureTableIdnty
		,#Exposure. SourceTable
		,RiskCurveExposure. DlDtlPrvsnRwID
		,#Exposure. IsQuotational
		,#Exposure. Position * @@RiskCurveExposureTableForPercentage@@. Percentage * Case When RiskCurveRelation. RiskCurveID <> RiskCurveRelation.NonCalculatedRiskCurveID Then 0.5 Else 1.0 End Position
		,#Exposure. Percentage * @@RiskCurveExposureTableForPercentage@@. Percentage * Case When RiskCurveRelation. RiskCurveID <> RiskCurveRelation.NonCalculatedRiskCurveID Then 0.5 Else 1.0 End Percentage
		,@@CurveLevel@@ CurveLevel
		,#Exposure. RiskCurveID		ParentRiskCurveID
		,RiskCurveExposure. ChildRiskCurveID		RiskCurveID
		,#Exposure. InstanceDateTime
		,#Exposure. EndOfDay
		,@@QuoteStartDate@@
		,@@QuoteStartDate@@
		,@@RiskCurveExposureTableForPercentage@@. Percentage * Case When RiskCurveRelation. RiskCurveID <> RiskCurveRelation.NonCalculatedRiskCurveID Then 0.5 Else 1.0 End ExposurePercentage
		,@@QuoteDateIsDefault@@		QuoteDateIsDefault
		,@@IsExpiredCurve@@ IsExpiredCurve
		,@@IsMonthlyDecomposedPhysical@@ IsMonthlyDecomposedPhysical
		,#Exposure.CurveStructure + '','' + Convert(VarChar, RiskCurveExposure.ChildRiskCurveID)
		,RiskCurveExposure.RiskCurveExposureID
		,@@IsRiskCurveExposureQuote@@ IsRiskCurveExposureQuote'
		--,#Exposure. CurveStructure + ''-'' + Case	When	Min(RiskCurveRelation. RiskCurveID) = Min(RiskCurveRelation. NonCalculatedRiskCurveID)
		--							Then	Convert(Varchar, Min(RiskCurveExposure. RiskCurveExposureID) )
		--							Else	Convert(Varchar, Min(RiskCurveExposure. RiskCurveExposureID)) + '','' + Convert(Varchar, Max(RiskCurveExposure. RiskCurveExposureID))
		--							End	CurveStructure

	------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Decompose for Simple Curves (No Exposure Quotes or Nonmonthly Quote Ranges)
	------------------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	From	#Exposure
		Inner Join dbo.RiskCurveRelation	(NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
		Inner Join dbo.RiskCurveExposure	(NoLock)	On	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
									And	RiskCurveExposure. QuoteStartDate	Is Null
									And	IsNull(#Exposure.CashSettledFuturesOverrideEndOfDay, #Exposure. EndOfDay)	Between	RiskCurveExposure. EndOfDayStartDate and RiskCurveExposure. EndOfDayEndDate
									' + Case When @i_CurveLevel > 1 Then '
									And	'','' + #Exposure.CurveStructure + '',''	Not Like ''%,'' + Convert(VarChar, RiskCurveExposure. ChildRiskCurveID) + '',%''
									' Else '' End + '
	Where	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel) + ' - 1
	And	#Exposure. IsBottomLevel	= Convert(Bit, 0)
	And	RiskCurveExposure. RiskCurveID	<> RiskCurveExposure. ChildRiskCurveID
	And	RiskCurveExposure. Percentage	<> 0.0'
				
	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_InsertTemplate, '@@QuoteStartDate@@', '#Exposure. AdjustedQuoteDate' )
	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@CurveLevel@@', @i_CurveLevel )
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@RiskCurveExposureTableForPercentage@@', 'RiskCurveExposure')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@QuoteDateIsDefault@@', '#Exposure. QuoteDateIsDefault')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsExpiredCurve@@', '0')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsRiskCurveExposureQuote@@', 'Convert(Bit, 0)')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsMonthlyDecomposedPhysical@@', 'Case When #Exposure. IsQuotational = 1 Then 0 Else 1 End ')

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/ Else Execute (@vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/)
	Select @i_rowcount = @i_rowcount  + @@RowCount
	
	Select	@vc_DynamicSQL = '
	Delete	#Exposure
	Where	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel) + '
	And	Exists		(
				Select	1
				From	dbo.RiskCurveExposureQuote	(NoLock)
				Where	RiskCurveExposureQuote. RiskCurveExposureID	= #Exposure. RiskCurveExposureID
				)'
				
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL  Else Execute (@vc_DynamicSQL)
	
	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Decompose for Curves with Exposure Quotes (HK)
	------------------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	From	#Exposure
		Inner Join dbo.RiskCurveRelation	(NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
		Inner Join dbo.RiskCurveExposure	(NoLock)	On	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
									And	RiskCurveExposure. QuoteStartDate	Is Null
									And	IsNull(#Exposure.CashSettledFuturesOverrideEndOfDay, #Exposure. EndOfDay)		Between	RiskCurveExposure. EndOfDayStartDate and RiskCurveExposure. EndOfDayEndDate
									And	'','' + #Exposure.CurveStructure + '',''	Not Like ''%,'' + Convert(VarChar, RiskCurveExposure. ChildRiskCurveID) + '',%''
									-- BMM Changed to use EOD along with other refactoring work
									--And	#Exposure. AdjustedQuoteDate	Between	RiskCurveExposure. EndOfDayStartDate and RiskCurveExposure. EndOfDayEndDate
		Inner Join dbo.RiskCurveExposureQuote	(NoLock)	On	RiskCurveExposureQuote. RiskCurveExposureID	= RiskCurveExposure. RiskCurveExposureID
	Where	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel) + ' - 1
	And	#Exposure. IsBottomLevel	= Convert(Bit, 0)
	And	RiskCurveExposure. RiskCurveID	<> RiskCurveExposure. ChildRiskCurveID
	And	RiskCurveExposure. Percentage	<> 0.0
	And	Not Exists	( -- Dont insert if theres already a quote with the same curve higher up.  This prevents performance problems with Monthly Averages decomposing into Monthly Averages multiple times
			Select	1
			From	#Exposure	Sub
			Where	Sub.RiskResultsIdnty		= #Exposure. RiskResultsIdnty
			And	Sub.RiskExposureTableIdnty	= #Exposure. RiskExposureTableIdnty
			And	Sub. CurveLevel			< ' + Convert(varchar, @i_CurveLevel) + '
			And	Sub.ParentRiskCurveID		= RiskCurveExposure. ChildRiskCurveID
			And	Sub.AdjustedQuoteDate		= RiskCurveExposureQuote. QuoteDate
				)
	'

	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_InsertTemplate, '@@QuoteStartDate@@', 'RiskCurveExposureQuote. QuoteDate' )
	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@CurveLevel@@', @i_CurveLevel )
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@RiskCurveExposureTableForPercentage@@', 'RiskCurveExposureQuote')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@QuoteDateIsDefault@@', '0')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsExpiredCurve@@', '0')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsRiskCurveExposureQuote@@', 'Convert(Bit, 1)')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsMonthlyDecomposedPhysical@@', '0')

	If @b_RiskCurveExposureQuote_Table_HasRows = Convert(bit, 1)
	Begin
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/ Else Execute (@vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/)
		Select @i_rowcount = @i_rowcount  + @@RowCount
	End

	------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Decompose for Curves with Exposure Quotes (Nonmonthly Quote Ranges)
	------------------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	From	#Exposure
		Inner Join dbo.RiskCurveRelation	(NoLock)	On	RiskCurveRelation. RiskCurveID		= #Exposure. RiskCurveID
		Inner Join dbo.RiskCurveExposure	(NoLock)	On	RiskCurveExposure. RiskCurveID		= RiskCurveRelation. NonCalculatedRiskCurveID
									And	#Exposure. EndOfDay			Between RiskCurveExposure. EndOfDayStartDate And RiskCurveExposure. EndOfDayEndDate
									And	#Exposure. AdjustedQuoteDate		Between	RiskCurveExposure. QuoteStartDate and RiskCurveExposure. QuoteEndDate
									And	'','' + #Exposure.CurveStructure + '',''	Not Like ''%,'' + Convert(VarChar, RiskCurveExposure. ChildRiskCurveID) + '',%''
	Where	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel) + ' - 1
	And	#Exposure. IsBottomLevel	= Convert(Bit, 0)
	And	RiskCurveExposure. RiskCurveID	<> RiskCurveExposure. ChildRiskCurveID
	And	RiskCurveExposure. Percentage	<> 0.0
	'

	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_InsertTemplate, '@@QuoteStartDate@@', '#Exposure. AdjustedQuoteDate' )
	Select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@CurveLevel@@', @i_CurveLevel )
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@RiskCurveExposureTableForPercentage@@', 'RiskCurveExposure')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@QuoteDateIsDefault@@', '#Exposure. QuoteDateIsDefault')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsExpiredCurve@@', '0')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsRiskCurveExposureQuote@@', 'Convert(Bit, 0)')
	select @vc_DynamicSQL_Insert = Replace(@vc_DynamicSQL_Insert, '@@IsMonthlyDecomposedPhysical@@', 'Case When #Exposure. IsQuotational = 1 Then 0 Else 1 End ')

	If @b_RiskCurveExposure_Table_HasNonMonthlyRows = Convert(bit, 1)
	Begin
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/ Else Execute (@vc_DynamicSQL_Insert + @vc_DynamicSQL /*+ @vc_DynamicSQL_GroupBy*/)
		Select @i_rowcount = @i_rowcount  + @@RowCount
	End
	
	-- Update the CurveLevelDescription Column
	If	@c_OnlyShowSQL = 'Y' 
	Or	IsNull(@vc_AdditionalColumns, '')	Like '%CurveStructureDescription%'
	Begin
		Select @vc_DynamicSQL = Replace(@vc_DynamicSQL_UpdateCurveStructureDescription, '@@CurveLevel@@', Convert(Varchar, @i_CurveLevel))
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

	
	---------------------------------------------------------------------------------------------------------------------------------------------
	-- Delete for UseForRisk
	---------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Delete	#Exposure
	From	#Exposure
		Inner Join dbo.RiskCurve	(NoLock)	On	RiskCurve. RiskCurveID		= #Exposure. RiskCurveID
		Inner Join dbo.RawPriceLocale	(NoLock)	On	RawPriceLocale. RwPrceLcleID	= RiskCurve. RwPrceLcleID
	Where	RawPriceLocale. UseForRisk	= ''N''
	And	#Exposure. CurveLevel		= ' + Convert(varchar, @i_CurveLevel)
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	---------------------------------------------------------------------------------------------------------------------------------------------
	-- Update Period/RiskCurve for curves that need to roll to prompt period
	---------------------------------------------------------------------------------------------------------------------------------------------
	Exec dbo.SRA_Risk_Exposure_UpdateExpiredPeriods 	@i_P_EODSnpShtID	= @i_P_EODSnpShtID
								,@i_P_EODSnpShtLgID	= @i_P_EODSnpShtLgID
								,@i_Compare_P_EODSnpShtID = @i_Compare_P_EODSnpShtID
								,@b_IsReport		= @b_IsReport
								,@i_CurveLevel 		= @i_CurveLevel
								,@c_OnlyShowSQL		= @c_OnlyShowSQL
								
	-------------------------------------------------------------------------------------------------------------------------------------
	-- Determine if Use Latest Actuals, Propogate Latest Actuals, & Use Actual for Curve Detail is used
	-------------------------------------------------------------------------------------------------------------------------------------
	Exec dbo.SRA_Risk_Exposure_UseLatestActuals_Delete		@i_CurveLevel 		= @i_CurveLevel
									,@c_OnlyShowSQL		= @c_OnlyShowSQL
	
	---------------------------------------------------------------------------------------------------------------------------------------------
	-- Update IsBottomLevel & Calendar
	---------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#Exposure
	Set	CalendarID	= RawPriceLocale. CalendarID
		,IsBottomLevel	= Case When	(
						RawPriceLocale. DecomposePhysicalExposure	= Convert(Bit, 0)
					And	#Exposure. IsQuotational			= Convert(Bit, 0)
						)
					Or	(
						RawPriceLocale. DecomposeQuotationalExposure	= Convert(Bit, 0)
					And	#Exposure. IsQuotational			= Convert(Bit, 1)
						)
						Then 1 Else 0 End
	From	#Exposure
		Inner Join dbo.RiskCurve	(NoLock)	On	RiskCurve. RiskCurveID			= #Exposure. RiskCurveID
		Inner Join dbo.RawPriceLocale	(NoLock)	On	RawPriceLocale. RwPrceLcleID		= RiskCurve. RwPrceLcleID
	Where	#Exposure. CurveLevel	= ' + Convert(varchar, @i_CurveLevel) + '
	'
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	------------------------------------------------------------------------------------------------------------------------------------------------
	-- Adjust the quote date for First Before (Exclude & First After aren't supported).
	------------------------------------------------------------------------------------------------------------------------------------------------
	Select	@vc_DynamicSQL = '
	Update	#Exposure
	Set	AdjustedQuoteDate	=	(
						Select	Max(FirstBefore. Date)
						From	dbo.CalendarDate FirstBefore	(NoLock)
						Where	FirstBefore. CalendarID		= #Exposure. CalendarID
						And	FirstBefore. BusinessDay	= Convert(Bit, 1)
						And	FirstBefore. Date		< #Exposure. AdjustedQuoteDate
						)
	From	#Exposure
	Where	#Exposure. CurveLevel	= ' + Convert(varchar, @i_CurveLevel) + '
	And	Exists	(
			Select 1
			From	dbo.CalendarDate	(NoLock)
			Where	CalendarDate. CalendarID	= #Exposure. CalendarID
			And	CalendarDate. Date		= #Exposure. AdjustedQuoteDate
			And	CalendarDate. BusinessDay	= Convert(Bit, 0)
			)'
			
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	-- Exit if we're debugging
	If @c_OnlyShowSQL = 'Y' and @i_CurveLevel = 3
	Begin
		Select @i_CurveLevel = 10
		Select '-- END LOOP'	
	End
End


---------------------------------------------------------------------------------------------------------------------------------------------
-- Now Update IsBottomLevel for curves whos curve is set to decompose, but there's not any forward curves setup to decompose into
-- BMM Added this because HK futures initially insert with a quotedate of EOD, but then they decompose using Delivery Start to End/RiskCurveExposureQuote which causes the quote dates to not match
---------------------------------------------------------------------------------------------------------------------------------------------
Select @vc_DynamicSQL = '
Update #Exposure
Set    IsBottomLevel              = Convert(Bit, 1)
From   #Exposure
Where  #Exposure. IsBottomLevel   = Convert(Bit, 0)
And    Not Exists    (
                     Select 1
                     From   dbo.#Exposure HigherLevelExposure
                     Where  HigherLevelExposure. RiskExposureTableIdnty     = #Exposure. RiskExposureTableIdnty
                     And    HigherLevelExposure. SourceTable         = #Exposure. SourceTable
                     And    HigherLevelExposure. IsQuotational       = #Exposure. IsQuotational
                     And    (
                                  HigherLevelExposure. IsRiskCurveExposureQuote = Convert(Bit, 1)
                           Or     HigherLevelExposure. QuoteDate                  = #Exposure. QuoteDate
                           )
                     And    HigherLevelExposure. CurveLevel                 > #Exposure. CurveLevel
                     And    HigherLevelExposure. ParentRiskCurveID          = #Exposure. RiskCurveID
                     )'


If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

---------------------------------------------------------------------------------------------------------------------------------------------
-- Update Records that weren't caught from above update
-- BMM Added this because HK futures initially insert with a quotedate of EOD, but then they decompose using Delivery Start to End/RiskCurveExposureQuote which causes the quote dates to not match
---------------------------------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL = '
Update	#Exposure
Set	IsBottomLevel		= Convert(Bit, 0)
--Select *
From	#Exposure
Where	#Exposure. IsBottomLevel = Convert(Bit, 1)
And	Exists	(
		Select	1
		From	dbo.#Exposure HigherLevelExposure
		Where	HigherLevelExposure. RiskExposureTableIdnty	= #Exposure. RiskExposureTableIdnty
		And	HigherLevelExposure. SourceTable		= #Exposure. SourceTable
		And	HigherLevelExposure. IsQuotational		= #Exposure. IsQuotational
		--And	HigherLevelExposure. QuoteDate			= #Exposure. QuoteDate  -- Cant do this for exposures that use RiskCurveExposureQuote
		And	HigherLevelExposure. CurveLevel			> #Exposure. CurveLevel
		And	HigherLevelExposure. ParentIdnty		= #Exposure. Idnty
		And	HigherLevelExposure. IsBottomLevel		= Convert(Bit, 1)
		)'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert Period Exposure by summing the daily.
-------------------------------------------------------------------------------------------------------------------------------------------------
If @c_ShowDailyExposure Not In('H', 'Y')
Begin
	
	
	Select @vc_DynamicSQL = '
	Insert	#ExposureResults
	(
		RiskResultsIdnty
		,RiskExposureTableIdnty
		,CurveLevel
		,RiskCurveID
		,Position
		,Percentage
		,QuoteStartDate
		,QuoteEndDate
		,PricedInPercentage
		--,CurveStructure
		' + Case When dbo.GetTableColumns('#ExposureResults') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,CurveStructureDescription' Else '' End + '
	)
	Select	#Exposure. RiskResultsIdnty
		,#Exposure. RiskExposureTableIdnty
		,#Exposure. CurveLevel
		,#Exposure. RiskCurveID
		,Sum(#Exposure. Position) Position
		,Sum(#Exposure. Percentage) Percentage
		,Min(#Exposure. AdjustedQuoteDate) QuoteStartDate
		,Max(#Exposure. AdjustedQuoteDate) QuoteEndDate
		,Case When Count(1) = 0 Then 1.0 Else Sum(Convert(Float, Case When  #Exposure. AdjustedQuoteDate <= #Exposure. EndOfDay Then 1.0 Else 0.0 End)) / Convert(Float, Count(1)) End	PricedInPercentage
		--,Convert(Varchar(30), #Exposure. CurveStructure) CurveStructure
		' + Case When dbo.GetTableColumns('#Exposure') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,#Exposure. CurveStructureDescription' Else '' End + '
	From	#Exposure
		--Inner Join #RiskResults			On	#RiskResults. Idnty			= #Exposure. RiskResultsIdnty
		--Inner Join dbo.FormulaEvaluation	On	FormulaEvaluation. FormulaEvaluationID	= #RiskResults. FormulaEvaluationID
	Where	#Exposure. IsBottomLevel	= Convert(Bit, 1)
	Group By #Exposure. RiskResultsIdnty
		,#Exposure. RiskExposureTableIdnty
		,#Exposure. CurveLevel
		--,#Exposure. ParentRiskCurveID
		,#Exposure. RiskCurveID
		--,#Exposure. Percentage
		--,Convert(Varchar(30), #Exposure. CurveStructure)
		' + Case When dbo.GetTableColumns('#Exposure') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,#Exposure. CurveStructureDescription' Else '' End + '
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	---------------------------------------------------------------------------------------------------------
	-- Update the MonthlyRatioPercentage column
	---------------------------------------------------------------------------------------------------------
	if	Exists (
			Select	1 
			From	dbo.DealDetailProvisionRow (NoLock)
			Where	IsNull(DealDetailProvisionRow. MonthlyRatioRule, 'N') <> 'N'
			)
		Exec dbo.SRA_Risk_Reports_Decompose_Exposure_MonthlyRatio 	@i_P_EODSnpShtID	= @i_P_EODSnpShtID
										,@c_OnlyShowSQL		= @c_OnlyShowSQL
	
	---------------------------------------------------------------------------------------------------------
	-- Override the PricedInPercentage for Quotational Exposure for EFP Futures that must show
	-- Without this, the PricedInPercentage is 1.0 after the update above since QuoteDaet = EOD
	---------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#ExposureResults
	Set	PricedInPercentage = #RiskResults. PricedInPercentage -- Should be 0.0
	From	#ExposureResults
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty = #ExposureResults. RiskResultsIdnty
	Where	#ExposureResults. PricedInPercentage	<> #RiskResults. PricedInPercentage
	And	#RiskResults. IsQuotational		= 1
	And	#ExposureResults. CurveLevel		= 0
	And	#ExposureResults. QuoteStartDate	= #ExposureResults. QuoteEndDate
	And	#RiskResults. EndOfDay			= #ExposureResults. QuoteEndDate
	And	#RiskResults. DlDtlTmplteID		= 26000 -- EFP Future
	'
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Update the position based on priced in %.  Need to do this since we update non decomposed positions to: position * (1.0 - PricedInPercentage/TotalPercentage)
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#ExposureResults
	Set	Position		= #ExposureResults. Position 
						* Case	-- If Quotational or Physical exposure that decomposes into daily, i.e. HK
							When	#RiskResults. IsQuotational = Convert(bit, 1) 
							Or	Abs(DateDiff(day, #ExposureResults. QuoteStartDate, #ExposureResults. QuoteEndDate)) > 0
							Then	(1.0 - IsNull(#ExposureResults. PricedInPercentage, 0.0)) 
							Else	1.0 
						End * IsNull(#ExposureResults.MonthlyRatioPercentage, 1.0)
		--Position		= #ExposureResults. Position * (1.0 - Case When #RiskResults. TotalPercentage = 0.0 Then 1.0 Else IsNull(#ExposureResults. PricedInPercentage, 0.0) / #RiskResults. TotalPercentage End)
		,Percentage		= #ExposureResults. PricedInPercentage
		,TotalPercentage	= #RiskResults. TotalPercentage
	From	#ExposureResults
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty	= #ExposureResults. RiskResultsIdnty'
	
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Update the position based on priced in %.  Need to do this since we update non decomposed positions to: position * (1.0 - PricedInPercentage/TotalPercentage)
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#ExposureResults
	Set	PricedInPercentage	=  #RiskResults. PricedInPercentage * IsNull(#ExposureResults.MonthlyRatioPercentage, 1.0) -- Abs(#ExposureResults. Percentage * #RiskResults. TotalPercentage)
	From	#ExposureResults
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty	= #ExposureResults. RiskResultsIdnty
	where Not Exists	(
			Select	1
			From	dbo.ProductInstrument	(NoLock)
			Where	ProductInstrument. PrdctId		= IsNull(#RiskResults. PrdctID, #RiskResults.CurveProductID)
			And	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			)
	-- If a parent curve exists with the same price curve, do not do this logic for the child curve
	And	Not Exists	(
					select	1
					From	RiskCurve with (NoLock) 
					where	RiskCurve.RiskCurveID			= #ExposureResults.RiskCurveID
					and		#RiskResults.RwPrceLcleID		= RiskCurve.RwprceLcleID
					and		#ExposureResults.CurveLevel	>	#RiskResults.CurveLevel
					)	'
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	
	

End

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert Daily Exposure
-------------------------------------------------------------------------------------------------------------------------------------------------
If @c_ShowDailyExposure <> 'N'	-- Insert Daily Exposure
begin
	Select @vc_DynamicSQL = '
	Insert	#ExposureResults
	(
		RiskResultsIdnty
		,RiskExposureTableIdnty
		,CurveLevel
		,RiskCurveID
		,Position
		,Percentage
		,PricedInPercentage
		,TotalPercentage
		,QuoteDate
		--,CurveStructure
		,IsDailyPricingRow
		' + Case When dbo.GetTableColumns('#ExposureResults') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,CurveStructureDescription' Else '' End + '
	)
	Select	#Exposure. RiskResultsIdnty
		,#Exposure. RiskExposureTableIdnty
		,#Exposure. CurveLevel
		,#Exposure. RiskCurveID
		,Sum(#Exposure. Position) Position
		,Sum(#Exposure. Percentage) Percentage
		,Sum(Abs(#Exposure. Percentage * #RiskResults. TotalPercentage))	PricedInPercentage
		,Min(#RiskResults. TotalPercentage) TotalPercentage
		,#Exposure. AdjustedQuoteDate -- QuoteDate
		--,Convert(Varchar(30), #Exposure. CurveStructure) CurveStructure
		,Case When #Exposure.QuoteDate is not null and "' + @c_ShowDailyExposure + '" in( "P" , "H" ) Then 1 Else 0 End
		' + Case When dbo.GetTableColumns('#Exposure') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
		,#Exposure. CurveStructureDescription' Else '' End + '
	From	#Exposure
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty	= #Exposure. RiskResultsIdnty
	Where	#Exposure. IsBottomLevel	= Convert(Bit, 1)
	' + Case When @c_ShowDailyExposure In("P", "H") Then '
	And	(
		#RiskResults. IsQuotational	= Convert(Bit, 1)
	Or	(	-- Dont show the Daily Pricing Event Row
			#RiskResults. IsQuotational	= Convert(Bit, 0)
		And	#RiskResults. IsDailyPricingRow	= Convert(Bit, 1)
		)) ' 
		-- If were not showing pricing events, then we need to allow the quote to decompose
		-- Commented the exists below since it was preventing NG physical decomposition.  The only issue that may be left is BALMO and HK decomposition
		Else "" End + '
	' + Case When @c_ShowDailyExposure <> 'H' Then '
	And	(
		#Exposure. AdjustedQuoteDate		> #RiskResults. EndOfDay
	Or	#Exposure. QuoteDateIsDefault		= Convert(Bit, 1)
--	Or	#Exposure. IsMonthlyDecomposedPhysical	= Convert(Bit, 1)
		)
	' Else '' End + '	
	Group By	#Exposure. RiskResultsIdnty
			,#Exposure. RiskExposureTableIdnty
			,#Exposure. CurveLevel
			,#Exposure. RiskCurveID
			,#Exposure. AdjustedQuoteDate -- QuoteDate
			,Case When #Exposure.QuoteDate is not null and "' + @c_ShowDailyExposure + '" in( "P" , "H" ) Then 1 Else 0 End
			' + Case When dbo.GetTableColumns('#Exposure') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
			,#Exposure. CurveStructureDescription' Else '' End + '
	'
	-- Need to do a group by since Adjusted QuoteDates, i.e. first befores, need to be grouped

	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	---------------------------------------------------------------------------------------------------------
	-- Update the MonthlyRatioPercentage column
	---------------------------------------------------------------------------------------------------------
	if	Exists (
			Select	1 
			From	dbo.DealDetailProvisionRow (NoLock)
			Where	IsNull(DealDetailProvisionRow. MonthlyRatioRule, 'N') <> 'N'
			)
		Exec dbo.SRA_Risk_Reports_Decompose_Exposure_MonthlyRatio 	@i_P_EODSnpShtID	= @i_P_EODSnpShtID
										,@c_OnlyShowSQL		= @c_OnlyShowSQL

	--------------------------------------------------
	-- Update the position based on Monthly Ratio %.  
	--------------------------------------------------
	Select @vc_DynamicSQL = '
	Update	#ExposureResults
	Set	Position		= #ExposureResults. Position * IsNull(#ExposureResults.MonthlyRatioPercentage, 1.0)
		,PricedInPercentage	=  #ExposureResults. PricedInPercentage * IsNull(#ExposureResults.MonthlyRatioPercentage, 1.0)
	From	#ExposureResults
		Inner Join ' + @vc_TempTableName + ' #RiskResults	On #RiskResults. Idnty	= #ExposureResults. RiskResultsIdnty
	where Not Exists	(
			Select	1
			From	dbo.ProductInstrument	(NoLock)
			Where	ProductInstrument. PrdctId		= IsNull(#RiskResults. PrdctID, #RiskResults.CurveProductID)
			And	ProductInstrument. InstrumentType	= ''F''
			And	ProductInstrument. DefaultSettlementType = ''C''
			)'
	
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

End


-------------------------------------------------------------------------------------------------------------------------------------------------
-- Insert Decomposed Curve back into #RiskResults
-------------------------------------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL = '
Insert	' + @vc_TempTableName + '
(
	RiskID
	,ExposureID
	,RiskExposureTableIdnty
	,FormulaEvaluationID
	,SourceTable
	,DlDtlTmplteID
	,IsInventory
	,IsPrimaryCost
	,RiskCurveID
	,RwPrceLcleID
	,VETradePeriodID
	,PeriodStartDate
	,PeriodEndDate
	,PrceTpeIdnty
	,CrrncyID
	,RiskType
	,IsQuotational
	,DlDtlPrvsnID
	,DlDtlPrvsnRwID
	,Percentage
	,PricedInPercentage
	,TotalPercentage
	,InstanceDateTime
	,EndOfDay
	,CurveLevel
	,ExposureStartDate
	,ExposureQuoteStartDate
	,ExposureQuoteEndDate
	,OriginalPhysicalPosition
	,Position
	,IsDailyPricingRow
	,SpecificGravity
	,Energy
	,CurveServiceID
	,CurveProductID
	,CurveChemProductID
	,CurveLcleID
	--,CurveStructure
	' + Case When dbo.GetTableColumns('#ExposureResults') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
	,CurveStructureDescription' Else '' End + '
	,DlHdrID
	,DlDtlId
	,PrdctID
	,ChmclID
	,LcleID
	,StrtgyID
	' + Case When @b_IsCurrentExposure = 'Y' Then '
	,ValueID
	,SourceID' Else '' End + '
)
Select	#RiskResults. RiskID
	,#RiskResults. ExposureID
	,#RiskResults. RiskExposureTableIdnty
	,#RiskResults. FormulaEvaluationID
	,#RiskResults. SourceTable
	,#RiskResults. DlDtlTmplteID
	,#RiskResults. IsInventory
	,#RiskResults. IsPrimaryCost
	,RiskCurve. RiskCurveID -- #RiskResults. RiskCurveID  TFS: 51712
	,IsNull(RiskCurve. RwPrceLcleID, #RiskResults. RwPrceLcleID)
	,IsNull(RiskCurve. VETradePeriodID, #RiskResults. VETradePeriodID)
	,IsNull(RiskCurve. TradePeriodFromDate, #RiskResults. PeriodStartDate)
	,IsNull(RiskCurve. TradePeriodToDate, #RiskResults. PeriodEndDate)
	,IsNull(RiskCurve. PrceTpeIdnty, #RiskResults. PrceTpeIdnty)
	,IsNull(RiskCurve. CrrncyID, #RiskResults. CrrncyID)
	,#RiskResults. RiskType
	,#RiskResults. IsQuotational
	,#RiskResults. DlDtlPrvsnID
	,#RiskResults. DlDtlPrvsnRwID
	,#ExposureResults. Percentage
	,#ExposureResults. PricedInPercentage
	,#ExposureResults. TotalPercentage
	,IsNull(#RiskResults. InstanceDateTime, getdate())
	,#RiskResults. EndOfDay
	,#ExposureResults. CurveLevel
	,#ExposureResults.QuoteDate	ExposureStartDate
	,#ExposureResults.QuoteStartDate
	,#ExposureResults.QuoteEndDate
	,#RiskResults.OriginalPhysicalPosition
	,#ExposureResults. Position
	,#ExposureResults. IsDailyPricingRow
	,#RiskResults.SpecificGravity
	,#RiskResults.Energy
	,IsNull(RiskCurve.RPHdrID, #RiskResults. CurveServiceID)
	,IsNull(RiskCurve.PrdctID, #RiskResults. CurveProductID)
	,IsNull(RiskCurve.ChmclID, #RiskResults. CurveChemProductID)
	,IsNull(RiskCurve.LcleID, #RiskResults. CurveLcleID)
	--,#ExposureResults. CurveStructure
	' + Case When dbo.GetTableColumns('#ExposureResults') like '%CurveStructureDescription%' or @c_OnlyShowSQL = 'Y' Then '
	,#ExposureResults. CurveStructureDescription' Else '' End + '
	,#RiskResults.DlHdrID
	,#RiskResults.DlDtlId
	,#RiskResults.PrdctID
	,#RiskResults.ChmclID
	,#RiskResults.LcleID
	,#RiskResults.StrtgyID
	' + Case When @b_IsCurrentExposure = 'Y'  /* or @c_OnlyShowSQL = 'Y' */ Then '
	,#RiskResults. ValueID
	,#RiskResults. SourceID' Else '' End + '
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join #ExposureResults			On #ExposureResults. RiskResultsIdnty	= #RiskResults. Idnty
	Left Outer Join dbo.RiskCurve	(NoLock)	On RiskCurve. RiskCurveID		= #ExposureResults. RiskCurveID

'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-------------------------------------------------------------------------------------
-- Delete the original records that were inserted into #RiskResults (CurveLevel 0)
-------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Delete	#RiskResults
From	' + @vc_TempTableName + ' #RiskResults
Where	Exists	(
	Select	1
	From	#ExposureResults
	Where	#ExposureResults. RiskResultsIdnty	= #RiskResults. Idnty
		)
' + Case	When	@c_ShowDailyExposure = 'H' 
		Then	'And	#RiskResults.RiskType	<> "Q"'
		Else	'' 
		End


If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete Futures that have rolled off ( Need this since some futures are quotational which means the end date of RiskCurveLink won't work
-----------------------------------------------------------------------------------------------------------------------------------------------------
Select @vc_DynamicSQL = '
Create Table #ExposuresToExpire
(
	RiskResultsIdnty	Int Not Null
	,EndOfDay		SmallDateTime	Not Null
	,InstanceDateTime	SmallDateTime	Not Null
	,CalendarID		SmallInt	Null
	,CurveRollOffDate	SmallDateTime	Null
	,EarlyRollOffDays	Int		Null
	,AdjustedRollOffDate	SmallDateTime	Null
	,DlDtlPrvsnID		Int		Null
)
'
			
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL

Create Table #ExposuresToExpire
(
	RiskResultsIdnty	Int Not Null
	,EndOfDay		SmallDateTime	Not Null
	,InstanceDateTime	SmallDateTime	Not Null
	,CalendarID		SmallInt	Null
	,CurveRollOffDate	SmallDateTime	Null
	,EarlyRollOffDays	Int		Null
	,AdjustedRollOffDate	SmallDateTime	Null
	,DlDtlPrvsnID		Int		Null
)

Select @vc_DynamicSQL = '
Insert	#ExposuresToExpire
(
	RiskResultsIdnty
	,InstanceDateTime
	,EndOfDay
	,CurveRollOffDate
	,CalendarID
	,DlDtlPrvsnID
)
Select	#RiskResults. Idnty
	,IsNull(#RiskResults. InstanceDateTime, Current_timestamp)
	,#RiskResults. EndOfDay
	,DateAdd(day, -1, DateAdd(minute, 1, (
		Select	Max(PricingPeriodCategoryVETradePeriod. RollOffBoardDate)
		From	RawPriceLocalePricingPeriodCategory	(NoLock)
			Inner Join PricingPeriodCategoryVETradePeriod (NoLock)
								On	PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID	= RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID
								And	PricingPeriodCategoryVETradePeriod.VETradePeriodID		= RiskCurve. VETradePeriodID
		Where	RawPriceLocalePricingPeriodCategory.RwPrceLcleID		= RiskCurve. RwPrceLcleID
		And	RawPriceLocalePricingPeriodCategory.IsUsedForSettlement		= Convert(Bit, 1)
		)))	RollOffBoardDate
	,RawPriceLocale. CalendarID
' + Case When @b_IsCurrentExposure = 'N' Then '	
	,(
		Select Max(DlDtlPrvsnID)
		From	dbo.Risk			(NoLock)	
			Inner Join dbo.RiskDealIdentifier	(NoLock)	On RiskDealIdentifier. RiskDealIdentifierID	= Risk. RiskDealIdentifierID
			Inner Join dbo.RiskDealDetailProvision	(NoLock)	On RiskDealDetailProvision. DlDtlPrvsnDlDtlDlHdrID	= RiskDealIdentifier. DlHdrID
										And RiskDealDetailProvision. DlDtlPrvsnDlDtlID		= RiskDealIdentifier. DlDtlID
		Where	Risk. RiskID					= #RiskResults. RiskID	
		And	RiskDealDetailProvision. Status			= ''A''
		And	RiskDealDetailProvision. CostType		= ''P''
		and	#RiskResults. InstanceDateTime Between RiskDealDetailProvision. StartDate and RiskDealDetailProvision.EndDate
	)
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.RiskCurve		(NoLock)	On RiskCurve. RiskCurveID			= #RiskResults. RiskCurveID
' Else '
,(
		Select	Max(DlDtlPrvsnID)
		From	dbo.DealDetailProvision	(NoLock)
		Where	DealDetailProvision. DlDtlPrvsnDlDtlDlHdrID	= #RiskResults. DlHdrID
		And	DealDetailProvision. DlDtlPrvsnDlDtlID	= #RiskResults. DlDtlID	
		And	DealDetailProvision. Status		= ''A''
		And	DealDetailProvision. CostType		= ''P''
	)
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join dbo.RiskCurve		(NoLock)	On RiskCurve. RiskCurveID			= #RiskResults. RiskCurveID
								And #RiskResults. CurveLevel			= 0
' End + '
	Inner Join dbo.RawPriceLocale		(NoLock)	On RawPriceLocale. RwPrceLcleID			= RiskCurve. RwPrceLcleID
Where	#RiskResults. DlDtlTmplteID	In( ' + dbo.GetDlDtlTmplteIds('Futures All Types') + ')
And	#RiskResults. IsQuotational	= Convert(Bit, 0)
'
			
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

Select @vc_DynamicSQL = '	
Update	#ExposuresToExpire
Set	AdjustedRollOffDate	= DateAdd(day, IsNull(Formula. EarlyRollOffDays, 0), 
					 Case	When	CalendarDate. BusinessDay	= 1
						Then	CurveRollOffDate
						When	CalendarDate. DayofWeek		= 7 -- Saturday
						Then	Case When IsNull(Formula. SaturdayRule, 0) In(1,3) Then FirstAfter.Date When IsNull(Formula. SaturdayRule, 0) = 2 Then FirstBefore.Date  Else 0 End
						When	CalendarDate. DayofWeek		= 1 -- Sunday
						Then	Case When IsNull(Formula. SundayRule, 0) In(1,3) Then FirstAfter.Date When IsNull(Formula. SundayRule, 0) = 2 Then FirstBefore.Date  Else 0 End
						Else	Case When IsNull(Formula. HolidayRule, 0) In(1,3) Then FirstAfter.Date When IsNull(Formula. HolidayRule, 0) = 2 Then FirstBefore.Date  Else 0 End
					End)
-- Select *
From	#ExposuresToExpire
	Inner Join dbo.CalendarDate		(NoLock)	On CalendarDate. CalendarID				= #ExposuresToExpire. CalendarID
									And CalendarDate. Date				= #ExposuresToExpire. CurveRollOffDate
	Inner Join dbo.CalendarDate	FirstBefore	(NoLock)	On FirstBefore. CalendarID			= #ExposuresToExpire. CalendarID
									And FirstBefore. Date				= (	Select	Max(FB.Date) 
																From	CalendarDate FB  (NoLock) 
																Where	FB. CalendarID	= #ExposuresToExpire. CalendarID
																And	FB. Date	< #ExposuresToExpire. CurveRollOffDate
																And	FB. BusinessDay	= 1
																)
	Inner Join dbo.CalendarDate	FirstAfter	(NoLock)	On FirstAfter. CalendarID			= #ExposuresToExpire. CalendarID
									And FirstAfter. Date				= (	Select	Min(FA.Date) 
																From	CalendarDate FA  (NoLock) 
																Where	FA. CalendarID	= #ExposuresToExpire. CalendarID
																And	FA. Date	> #ExposuresToExpire. CurveRollOffDate
																And	FA. BusinessDay	= 1
																)
	Left Outer Join	(
			Select	#ExposuresToExpire.RiskResultsIdnty
				,Convert(Int, IsNull(DealDetailProvisionRow. PriceAttribute14, 0))	HolidayRule
				,Convert(Int, IsNull(DealDetailProvisionRow. PriceAttribute15, 0))	SaturdayRule
				,Convert(Int, IsNull(DealDetailProvisionRow. PriceAttribute16, 0))	SundayRule
				,Convert(tinyint, IsNull(DealDetailProvisionRow. PriceAttribute34, ''0''))	EarlyRollOffDays
			From	#ExposuresToExpire
				Inner Join dbo.DealDetailProvisionRow	(NoLock)	On DealDetailProvisionRow. DlDtlPrvsnID	= #ExposuresToExpire. DlDtlPrvsnID
			Where	DealDetailProvisionRow. DlDtlPRvsnRwTpe		= ''F''
			)	Formula	On Formula. RiskResultsIdnty	= #ExposuresToExpire. RiskResultsIdnty
'
			
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
			
Select @vc_DynamicSQL = '
    Delete	#RiskResults
    -- Select *
    From	' + @vc_TempTableName + ' #RiskResults
    Where	Exists	(
		Select	1 
		From	dbo.#ExposuresToExpire
		Where	#ExposuresToExpire. RiskResultsIdnty	= #RiskResults. Idnty
		And	#ExposuresToExpire. AdjustedRollOffDate	<= #RiskResults. EndOfDay
				)
	And Not Exists	(
			Select	1
			From	dbo.ProductInstrument
			Where	ProductInstrument. PrdctID				= #RiskResults. PrdctID
			And	ProductInstrument. InstrumentType			= ''F''	-- Future
			And	IsNull(ProductInstrument. DefaultSettlementType, ''Z'')	= ''P'' -- Physically Settled
			And	ProductInstrument. PhysicalRwPrceLcleID			Is Not Null
			And	ProductInstrument. PhysicalPriceTypeID			Is Not Null
			)'
			
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

-------------------------------------------------------------------------------------
-- Update Period Info
-------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Update	#RiskResults
Set	PricingPeriodCategoryVETradePeriodID	= PricingPeriodCategoryVETradePeriod. Idnty
	,PeriodName 				= Coalesce(PricingPeriodCategoryVETradePeriod. PricingPeriodName, VETradePeriod. Name, RiskCurvePeriod. Name)
	,PeriodAbbv				= Coalesce(PricingPeriodCategoryVETradePeriod. PricingPeriodAbbv, VETradePeriod. Name, RiskCurvePeriod. Name)
	,CurveRiskType				= RawPriceLocale.CurveType
	,IsBasisCurve				= RawPriceLocale. IsBasisCurve
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join RawPriceLocale			(NoLock)	On	RawPriceLocale. RwPrceLcleID 		= #RiskResults. RwPrceLcleID
	Left Outer Join RawPriceLocalePricingPeriodCategory (NoLock)	On	RawPriceLocalePricingPeriodCategory. RwPrceLcleID 		= #RiskResults. RwPrceLcleID
	Left Outer Join PricingPeriodCategoryVETradePeriod (NoLock)	On	RawPriceLocalePricingPeriodCategory.PricingPeriodCategoryID 	= PricingPeriodCategoryVETradePeriod.PricingPeriodCategoryID
									And	PricingPeriodCategoryVETradePeriod. VETradePeriodID 		= #RiskResults. VETradePeriodID
									And	#RiskResults.EndOfDay						Between PricingPeriodCategoryVETradePeriod. RollOnBoardDate and PricingPeriodCategoryVETradePeriod. RollOffBoardDate
	Left Outer Join VETradePeriod			(NoLock)	On	PricingPeriodCategoryVETradePeriod. VETradePeriodID		= VETradePeriod. VETradePeriodID
	Left Outer Join VETradePeriod RiskCurvePeriod (NoLock) 		On	RiskCurvePeriod. VETradePeriodID				= #RiskResults. VETradePeriodID'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------
-- Update Quote Date to End Of Day for Futures & ETO's.  Exclude BALMO & Monthly Ave Futures
----------------------------------------------------------------------------------------------
select @vc_DynamicSQL = '
Update	#RiskResults
Set	ExposureStartDate	= #RiskResults. EndOfDay
From	' + @vc_TempTableName + ' #RiskResults
Where	#RiskResults. DlDtlTmplteID	In(' + dbo.GetDlDtlTmplteIDs('Futures All Types,Exchange Traded Options All Types') + ')
And	#RiskResults. IsQuotational	= Convert(Bit, 0)
And	Not Exists	(
		Select	1
		From	dbo.ProductInstrument	(NoLock)
		Where	ProductInstrument. PrdctID	= #RiskResults. PrdctID
		And	ProductInstrument. InstrumentType	= ''F''
		And	ProductInstrument. SettlementRule	In(''PB'', ''PA'')	-- Monthly Average or BALMO
		)'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

------------------------------------------------------------------------------------------------------------------------------------------------
-- Update the CurveDescription Column if we didn't insert into #Exposure (non daily only)
------------------------------------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL = '
Update	#RiskResults
Set	CurveStructureDescription	= ' + @vc_DynamicSQL_CurveDescription + '
From	' + @vc_TempTableName + ' #RiskResults
	Inner Join RiskCurve		(NoLock)	On RiskCurve. RiskCurveID	= #RiskResults. RiskCurveID
	Inner Join RawPriceLocale	(NoLock)	On RawPriceLocale. RwPrceLcleID	= RiskCurve. RwPrceLcleID
	Inner Join Product		(NoLock)	On RiskCurve.PrdctID		= Product.PrdctID
	Inner Join Locale		(NoLock)	On RiskCurve.LcleID		= Locale.LcleID
	Inner Join RawPriceHeader	(NoLock)	On RiskCurve.RPHdrID		= RawPriceheader.RPHdrID
	Inner Join VETradePeriod	(NoLock)	On RiskCurve.TradePeriodFromDate = VETradePeriod.StartDate
							And RiskCurve.TradePeriodToDate = VETradePeriod.EndDate
	Inner Join PriceType		(NoLock)	On RiskCurve.PrceTpeIdnty	= PriceType. Idnty
	Left Outer Join #Exposure ParentExposure	On 1 = 2  -- Need this since Im sharing the update
	Left Outer Join #Exposure			On 1 = 2
Where	IsNull(#RiskResults. CurveStructureDescription, '''') = ''''
'
If	IsNull(@vc_AdditionalColumns, '')	Like '%CurveStructureDescription%'
Or	@c_OnlyShowSQL = 'Y' 
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


----------------------------------------------------------------------------------------------------------------------
-- Error Reporting
----------------------------------------------------------------------------------------------------------------------
noerror:
	Return
error:
	RAISERROR (N'%s %d',11,1,@errmsg,@errno) --48187



GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTV_RER_SRA_Risk_Reports_Decompose_Exposure >>>'
	  END

