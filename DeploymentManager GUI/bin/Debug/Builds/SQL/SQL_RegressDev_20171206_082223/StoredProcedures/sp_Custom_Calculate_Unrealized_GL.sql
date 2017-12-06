If OBJECT_ID('dbo.Custom_Calculate_Unrealized_GL') Is Not NULL
Begin
    DROP PROC dbo.Custom_Calculate_Unrealized_GL
    PRINT '<<< DROPPED PROC dbo.Custom_Calculate_Unrealized_GL >>>'
End
GO
/*
Execute Custom_Calculate_Unrealized_GL @vc_seeselects = 'Y'
*/
Create Procedure dbo.Custom_Calculate_Unrealized_GL  	 @i_P_EODSnpShtID 	int				= Null
														,@vc_temptables		varchar(1)		= 'N'
														,@vc_seeselects  	varchar(1) 		= 'N'
														,@vc_ReverseOnly	varchar(1)		= 'N'
														,@vc_InternalBAID	varchar(2000)	= '0'
							
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		Custom_Calculate_Unrealized_GL  @i_P_EODSnpShtID = 7147 , @vc_temptables = 'Y', @vc_seeselects = 'Y'      Copyright 2003 SolArc
-- Overview:	
-- Arguments:	
-- SPs: 
-- Temp Tables:
-- Created by:	Brian McKay
-- History:		12/19/2003 - First Created
--
-- 	Modified 	By		Issue#	Modification
-- 	----------	------	------	-------------------------------------------------------------------------
--	11/11/2011	JPW				Cloning SRA's proc
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set ANSI_NULLS ON
Set ANSI_PADDING ON
Set ANSI_Warnings ON
Set Quoted_Identifier OFF
Set Concat_Null_Yields_Null ON

----------------------------------------------------------------------------------------------------------------------
-- Local Variables
----------------------------------------------------------------------------------------------------------------------
Declare  @vc_sql_insert 						varchar(8000)
		,@i_sysuser								int
		,@i_currentAcctPrdid					int
		,@i_templateid							int
		,@errno 								int
		,@errmsg 								varchar(255)
		,@sdt_SnapshotEndOfDay 					smalldatetime
		,@i_ManualLedgerEntry_key				int
		,@i_ManualLedgerEntryLog_key			int
		,@i_AccountDetail_key					int
		,@i_Count_New							int
		,@i_Count_All							int
		,@vc_sql_ManualLedgerEntry_Insert		varchar(8000)
		,@vc_sql_ManualLedgerEntry_Select		varchar(8000)
		,@vc_sql_ManualLedgerEntryLog_Insert	varchar(8000)
		,@vc_sql_ManualLedgerEntryLog_Select	varchar(8000)
		,@vc_sql_Accountdetail_Insert			varchar(8000)
		,@vc_sql_Accountdetail_Select			varchar(8000)
		,@vc_sql_RiskDescription_Insert			varchar(8000)
		,@vc_sql_RiskDescription_Select			varchar(8000)

Select	@errno 	= '60010'

----------------------------------------------------------------------------------------------------------------------
-- Temp Tables
----------------------------------------------------------------------------------------------------------------------
If	object_id('tempdb..#GLTempData') is null
	Begin
		If	@vc_seeselects = 'Y'
			Begin 
				Select 'Create Table	#GLTempData
										(Idnty					int 			Identity
										,RiskID					int				Null
										,SourceTable			VarChar(3)		Null
										,DlHdrid				int 			Null
										,DlDtlid				int 			Null
										,AcctDtlPlnndTrnsfrID 	int 			Null
										,MnlLdgrEntryID			int				Null
										,MnlLdgrEntryLgID		int				Null
										,InternalBAID			int				Null
										,ExternalBAID			int				Null
										,AcctPrdid				int				Null
										,TrdePrdid				int				null
										,Volume					Float			Null
										,TradePrice				Decimal (19,6)	Null
										,MarketPrice			Decimal (19,6)	Null
										,GainLoss				Decimal (19,6)	Null
										,TransactionTypeid		int				Null
										,WePayTheyPay			char(1)			Null
										,ParentPrdctID			int				Null
										,ChildPrdctID			int 			Null
										,StrtgyID				int 			Null
										,ReferenceDate			DateTime		Null
										,AcctDtlLcleID			int				Null
										,BARelationShip 		Char(1)			null
										,SupplyDemand   		Char(1)			null
										,MLAcctPrdId			int				null
										,CrrncyID				int				null
										,new					char(1)			null
										,OriginalAcctDtlID		int				null
										,P_EODEstmtedAccntDtlID int				Null
										,BaseExchangeRate		Float			Null
										,RawPriceDetailID		int				Null
										,BaseCurrencyID			int				Null
										,BAVTradePeriod			int				Null
										,UOMID					int				Null	
										,HedgeHeaderID			int				Null
										,Term					Char(1)			Null	
										,Type					Char(1)			Null
										,HedgeType				Char(1)			Null	
										,IsHedge				Char(1)			Null
										,OldStyleVolume         Float			Null	Default Null
										,OldStyleValue          Decimal (19,6)	Null	Default Null
										,ApplyNegative			Char(1)			Default ''N''
										,Credit					Char(1)			Default	''N''
										,IsPrimaryCost			Char(1)			Default ''N'')'
			End
 
			Create Table	#GLTempData
							(Idnty					Int 			Identity
							,RiskID					Int				Null
							,SourceTable			VarChar(3)		Null
							,DlHdrid				Int 			Null
							,DlDtlid				Int 			Null
							,AcctDtlPlnndTrnsfrID 	Int 			Null
							,MnlLdgrEntryID			Int				Null
							,MnlLdgrEntryLgID		Int				Null
							,InternalBAID			Int				Null
							,ExternalBAID			Int				Null
							,AcctPrdid				Int				Null
							,TrdePrdid				Int				null
							,Volume					Float			Null
							,TradePrice				Decimal (19,6)	Null
							,MarketPrice			Decimal (19,6)	Null
							,GainLoss				Decimal (19,6)	Null
							,TransactionTypeid		Int				Null
							,WePayTheyPay			char(1)			Null
							,ParentPrdctID			Int				Null
							,ChildPrdctID			Int 			Null
							,StrtgyID				Int 			Null
							,ReferenceDate			DateTime		Null
							,AcctDtlLcleID			Int				Null
							,BARelationShip 		Char(1)			null
							,SupplyDemand   		Char(1)			null
							,MLAcctPrdId			Int				null
							,CrrncyID				Int				null
							,new					char(1)			null
							,OriginalAcctDtlID		Int				null
							,P_EODEstmtedAccntDtlID Int				Null
							,BaseExchangeRate		Float			Null
							,RawPriceDetailID		Int				Null
							,BaseCurrencyID			Int				Null
							,BAVTradePeriod			Int				Null
							,UOMID					Int				Null	
							,HedgeHeaderID			Int				Null
							,Term					Char(1)			Null	
							,Type					Char(1)			Null
							,HedgeType				Char(1)			Null	
							,IsHedge				Char(1)			Null
							,OldStyleVolume         Float			Null	Default Null
							,OldStyleValue          Decimal (19,6)	Null	Default Null
							,ApplyNegative			Char(1)			Default 'N'
							,Credit					Char(1)			Default	'N'
							,IsPrimaryCost			Char(1)			Default 'N')
	End

Select @vc_SQL_Insert = '
Insert	#GLTempData
		(DlHdrid
		,DlDtlid
		,AcctDtlPlnndTrnsfrID
		,MnlLdgrEntryID
		,MnlLdgrEntryLgID
		,InternalBAID
		,ExternalBAID
		,AcctPrdid
		,TrdePrdid
		,Volume
		,TradePrice
		,MarketPrice
		,GainLoss
		,TransactionTypeid
		,WePayTheyPay
		,ParentPrdctID
		,ChildPrdctID
		,StrtgyID
		,ReferenceDate
		,AcctDtlLcleID
		,BARelationShip
		,SupplyDemand
		,MLAcctPrdId
		,CrrncyID
		,new
		,OriginalAcctDtlID
		,P_EODEstmtedAccntDtlID
		,BaseExchangeRate
		,RawPriceDetailID
		,BaseCurrencyID
		,BAVTradePeriod
		,UOMID
		,HedgeHeaderID
		,Term
		,Type
		,HedgeType
		,IsHedge
		,OldStyleVolume         
		,OldStyleValue    
		,ApplyNegative)'

----------------------------------------------------------------------------------------------------------------------
-- Get the InstanceDateTime and EndOfDay of the specified Snapshot, if no Snapshot is specified use the max snapshot
----------------------------------------------------------------------------------------------------------------------
-- If we don't have a snapshot, then look for the latest month end snapshot.
If	@i_P_EODSnpShtID Is Null 
	Begin 
		-- First Get Latest Month End
		Select 	@i_P_EODSnpShtID =  Max(P_EODSnpShtID) 
		From 	SnapShot (NoLock) 
		Where 	IsValid			= 'Y' 
		And 	Purged			= 'N' 
		And 	IsAsOfSnapshot	= 'Y'	
	End

If	@i_P_EODSnpShtID Is Null
	Begin
		Select	@errmsg = 'Unable to determine a month end snapshot record'
		GoTo error
	End

Select	@sdt_SnapshotEndOfDay 		= EndOfDay
From	Snapshot (NoLock)
Where	Snapshot.P_EODSnpShtID		= @i_P_EODSnpShtID

----------------------------------------------------------------------------------------------------------------------
-- Get the default currency, default uom, and current time
----------------------------------------------------------------------------------------------------------------------
Select 	@i_sysuser			= UserID From Users Where UserDBMnkr = 'sysuser'
Select  @i_currentAcctPrdid = Min (AccntngPrdID) From AccountingPeriod Where AccountingPeriod.AccntngPrdCmplte = 'N'
Select  @i_templateid		= Min(MnlLdgrEntryTmplteID) From ManualLedgerEntrytemplate


If @i_sysuser Is Null Or @i_currentAcctPrdid Is Null
Begin
	Select	@errmsg = 'Unable to find system user or current accounting period id'
	GoTo error
End

----------------------------------------------------------------------------------------------------------------------
-- JPW - Prevent the user from accidentally running the process twice for the same period
----------------------------------------------------------------------------------------------------------------------
If	Exists	(Select 'X' From AccountDetail (NoLock) Where AcctDtlSrceTble = 'ML' And AcctDtlTrnsctnTypID In (2027, 2029) And AcctDtlAccntngPrdID = @i_currentAcctPrdid And Reversed = 'N') And @vc_seeselects = 'N'
	Begin
		Select	@errmsg = 'The Calculate Unrealized Earnings Process has Already Run for Period: ' + convert(varchar,@i_currentAcctPrdid)
		goto error
	End 
	
----------------------------------------------------------------------------------------------------------------------
-- Populate Temp Table with the Physical Deals that are marked as Track Gain/Loss set to 'Y'
----------------------------------------------------------------------------------------------------------------------
If	@vc_ReverseOnly = 'N'	
	Begin	
		If	@vc_seeselects = 'N'
			Begin
				----------------------------------------------------------------------------------------------------------------------
				-- 18/06/2012 -- JPW Removed - Replace KM_HedgeAcct_Physicals_Unrealized with Custom_Calculate_Unrealized_Earnings
				---------------------------------------------------------------------------------------------------------------------- 
				Execute dbo.Custom_Calculate_Unrealized_Earnings	 @i_P_EODSnpShtID	= @i_P_EODSnpShtID
																	,@i_AccntngPrdID	= @i_currentAcctPrdid 
																	,@vc_InternalBAID	= @vc_InternalBAID                  
																	,@vc_SQL_Insert		= 'Insert	#GLTempData
																									(RiskID
																									,SourceTable
																									,DlHdrid
																									,DlDtlid
																									,AcctDtlPlnndTrnsfrID
																									,MnlLdgrEntryID
																									,MnlLdgrEntryLgID
																									,InternalBAID
																									,ExternalBAID
																									,AcctPrdid
																									,TrdePrdid
																									,Volume
																									,TradePrice
																									,MarketPrice
																									,GainLoss
																									,TransactionTypeid
																									,WePayTheyPay
																									,ParentPrdctID
																									,ChildPrdctID
																									,StrtgyID
																									,ReferenceDate
																									,AcctDtlLcleID
																									,BARelationShip
																									,SupplyDemand
																									,MLAcctPrdId
																									,CrrncyID
																									,new
																									,OriginalAcctDtlID
																									,P_EODEstmtedAccntDtlID
																									,BaseExchangeRate
																									,RawPriceDetailID
																									,BaseCurrencyID
																									,BAVTradePeriod
																									,UOMID
																									,HedgeHeaderID
																									,Term
																									,Type
																									,HedgeType
																									,IsHedge
																									,OldStyleVolume         
																									,OldStyleValue    
																									,ApplyNegative
																									,Credit
																									,IsPrimaryCost)
																									'
																,@c_OnlyShowSQL			= 'N'
				If	@@error <> 0
					Begin
						Select	@errmsg = 'Error - Getting the Unrealized Transactions'
						GoTo error
					End
			End
		Else
			Begin
				
				Select	'Execute dbo.Custom_Calculate_Unrealized_Earnings	 @i_P_EODSnpShtID	= ' + convert(varchar,@i_P_EODSnpShtID) + '
																			,@i_AccntngPrdID	= ' + convert(varchar,@i_currentAcctPrdid) + '
																			,@vc_InternalBAID	= ''' + @vc_InternalBAID + '''
																			,@vc_SQL_Insert		= ''Insert	#GLTempData
																										(RiskID
																										,SourceTable
																										,DlHdrid
																										,DlDtlid
																										,AcctDtlPlnndTrnsfrID
																										,MnlLdgrEntryID
																										,MnlLdgrEntryLgID
																										,InternalBAID
																										,ExternalBAID
																										,AcctPrdid
																										,TrdePrdid
																										,Volume
																										,TradePrice
																										,MarketPrice
																										,GainLoss
																										,TransactionTypeid
																										,WePayTheyPay
																										,ParentPrdctID
																										,ChildPrdctID
																										,StrtgyID
																										,ReferenceDate
																										,AcctDtlLcleID
																										,BARelationShip
																										,SupplyDemand
																										,MLAcctPrdId
																										,CrrncyID
																										,new
																										,OriginalAcctDtlID
																										,P_EODEstmtedAccntDtlID
																										,BaseExchangeRate
																										,RawPriceDetailID
																										,BaseCurrencyID
																										,BAVTradePeriod
																										,UOMID
																										,HedgeHeaderID
																										,Term
																										,Type
																										,HedgeType
																										,IsHedge
																										,OldStyleVolume         
																										,OldStyleValue    
																										,ApplyNegative
																										,Credit
																										,IsPrimaryCost)
																										''
																		,@c_OnlyShowSQL			= ''N''	
						'												
			End
	End

------------------------------------------------------------------------------------------------------------------------
-- Populate Temp Table with the transactions that need to be reversed
------------------------------------------------------------------------------------------------------------------------
If	@vc_ReverseOnly = 'Y'
	Begin
		If	@vc_seeselects = 'N' 
			Begin 
				Execute dbo.SRA_HedgeAcct_Reversals @i_currentAcctPrdid, @vc_sql_insert, @sdt_SnapshotEndOfDay	
				If	@@error <> 0
					Begin
						Select	@errmsg = 'Error - Getting the Reversal Transactions'
						GoTo error
					End			
			End
		Else
			Begin
				Select 'Execute dbo.SRA_HedgeAcct_Reversals ' + Convert(varchar,@i_currentAcctPrdid) + ',''' + @vc_sql_insert + ''','''+Convert(varchar,@sdt_SnapshotEndOfDay)+''', ''Y'''  
			End
	End			

If	@vc_seeselects = 'N' and @vc_temptables = 'N' 
	Begin
		If	(Select Count(*) From #GLTempData) <= 0
			Begin
			Goto noerror
		End 
	End	

----------------------------------------------------------------------------------------------------------------------
-- Get Keys
----------------------------------------------------------------------------------------------------------------------
If	@vc_seeselects = 'N' And @vc_temptables = 'N'
	Begin
		Select	@i_Count_New = Isnull(Max(Idnty),0) From #GLTempData Where New = 'Y'
			
		If	(Select @i_Count_New) >= 0 
			Begin
				Execute dbo.sp_getkey 'ManualLedgerEntry', @i_ManualLedgerEntry_key out , @i_Count_New
				Select @i_ManualLedgerEntry_key = @i_ManualLedgerEntry_key - 1
			End

		If	@@error <> 0
			Begin
				Select	@errmsg = 'Error - Unable to get Key for ManualLedgerEntry'
				GoTo error
			End
	
		Select @i_Count_All = IsNull(Max(Idnty),0) From #GLTempData 
	
		If	(Select @i_Count_All) >= 0 
			Begin
				Execute sp_getkey 'ManualLedgerEntryLog', @i_ManualLedgerEntryLog_key out , @i_Count_All
				Select 	@i_ManualLedgerEntryLog_key = @i_ManualLedgerEntryLog_key - 1
			End 

		If	@@error <> 0
			Begin
				Select	@errmsg = 'Error - Unable to get Key for ManualLedgerEntryLog'
				GoTo error
			End

		If	(Select @i_Count_All) >= 0 
			Begin
				Execute sp_getkey 'AccountDetail', @i_AccountDetail_key out , @i_Count_All
				Select @i_AccountDetail_key = @i_AccountDetail_key - 1
			End

		If	@@error <> 0
			Begin
				Select	@errmsg = 'Error - Unable to get Key for AccountDetail'
				GoTo error
			End

		If	@i_ManualLedgerEntry_key Is Null Or @i_ManualLedgerEntryLog_key Is Null Or @i_AccountDetail_key Is Null
			Begin
				Select	@errmsg = 'Error - Null Keys returned'
				GoTo error
			End
	End
Else
	Select	 @i_ManualLedgerEntry_key		= 0
			,@i_ManualLedgerEntryLog_key	= 0
			,@i_AccountDetail_key			= 0

----------------------------------------------------------------------------------------------------------------------
-- If See Sql then make this print out the calls to debug the Key logic.
----------------------------------------------------------------------------------------------------------------------
If @vc_seeselects = 'Y' 
Begin
	Print 'Declare @i_Count_New Int, @i_Count_All Int, @i_ManualLedgerEntry_key Int, @i_ManualLedgerEntryLog_key Int,  @i_AccountDetail_key Int'
	Print 'Select @i_Count_New = Max(Idnty) from #GLTempData Where New = ''Y'''
	Print 'execute sp_getkey ''ManualLedgerEntry'', @i_ManualLedgerEntry_key out , @i_Count_New'
	Print 'Select @i_ManualLedgerEntry_key = @i_ManualLedgerEntry_key - 1'
	
	Print 'Select @i_Count_All = MaX(Idnty) from #GLTempData '
	Print 'execute sp_getkey ''ManualLedgerEntryLog'', @i_ManualLedgerEntryLog_key out , @i_Count_All'
	Print 'Select 	@i_ManualLedgerEntryLog_key = @i_ManualLedgerEntryLog_key - 1'

	Print 'execute sp_getkey ''AccountDetail'', @i_AccountDetail_key out , @i_Count_All'
	Print 'Select @i_AccountDetail_key = @i_AccountDetail_key - 1'
End

----------------------------------------------------------------------------------------------------------------------
-- Display the temp tables or Insert the Data
----------------------------------------------------------------------------------------------------------------------
Begin Transaction GLTempData

	----------------------------------------------------------------------------------------------------------------------
	-- Insert into ManualLedgerEntry
	----------------------------------------------------------------------------------------------------------------------
	Select @vc_sql_ManualLedgerEntry_Insert = '
	Insert 	ManualLedgerEntry
			(MnlLdgrEntryID
			,MnlLdgrEntryTmplteID
			,InternalBAID
			,ExternalBAID
			,StrtgyID
			,LcleID
			,ParentPrdctID
			,TrnsctnTypID
			,WePayTheyPay
			,Value
			,CrrncyID
			,SupplyDemand
			,Quantity
			,UnitofMeasure
			,Comment
			,TransactionDate
			,ChildPrdctID
			,IsEstimate
			,P_EODEstmtedAccntDtlID
			,BrokerAccountID
			,BaseExchangeRate
			,RwPrceDtlID     
			,Status
			,MarketPrice
			,TradePrice 
			,HedgeHeaderID
			,DerivativeAccountingEntry)
	'
			
	Select @vc_sql_ManualLedgerEntry_Select = '
	Select	' + convert(varchar,@i_ManualLedgerEntry_key) + ' + Idnty	MnlLdgrEntryID
			,'+ convert(varchar,@i_templateid) + '	MnlLdgrEntryTmplteID
			,InternalBAID				InternalBAID
			,ExternalBAID				ExternalBAID
			,StrtgyID					StrtgyID
			,AcctDtlLcleID				LcleID 
			,ParentPrdctID				ParentPrdctID
			,TransactionTypeid			TrnsctnTypID
			,WePayTheyPay 				WePayTheyPay
			,Abs(GainLoss) * Case When Credit = ''Y'' Then -1 Else 1 End	Value
			,CrrncyID					CrrncyID
			,SupplyDemand				SupplyDemand
			,Abs(Volume)				Quantity
			,UOMID 						UnitofMeasure
			,''RiskID: '' + convert(varchar,IsNull(RiskID,0)) + ''||Source:'' +	Case 
																					When	#GLTempData. SourceTable = ''E''	Then	''Risk Adjustment''
																					When	#GLTempData. SourceTable = ''S''	Then	''Inventory Subledger'' 
																					When	#GLTempData. SourceTable = ''X''	Then	''Risk Accrual''  
																					Else	''Forward'' 
																				End		+
																				Case
																					When	#GLTempData. IsPrimaryCost = ''Y''	Then	''||PrimaryCost:Y'' 
																					Else	''||PrimaryCost:N''
																				End		Comment
			,ReferenceDate				TransactionDate
			,ChildPrdctID				ChildPrdctID
			,''Y''						IsEstimate
			,P_EODEstmtedAccntDtlID		P_EODEstmtedAccntDtlID
			,Null						BrokerAccountID
			,BaseExchangeRate			BaseExchangeRate
			,Null						RawPriceDetailID
			,''A''						Status
			,#GLTempData.MarketPrice	MarketPrice
			,#GLTempData.TradePrice		TradePrice
			,#GLTempData.HedgeHeaderID	HedgeHeader
			,1							DerivativeAccountingEntry
	From	#GLTempData	(NoLock)
	Where	New					= ''Y''
	And		BaseExchangeRate	Is Not Null
	'

	If	@vc_seeselects = 'N' And @vc_temptables = 'N'
		Exec (@vc_sql_ManualLedgerEntry_Insert + @vc_sql_ManualLedgerEntry_Select)

	If	@@error <> 0
		Begin
			Select	@errmsg = 'Error - Unable to Insert ManualLedgerEntry'
			RollBack Transaction GLTempData
			GoTo error
		End

	----------------------------------------------------------------------------------------------------------------------
	-- Insert into ManualLedgerEntryLog
	----------------------------------------------------------------------------------------------------------------------
	Select @vc_sql_ManualLedgerEntryLog_Insert = '
	Insert	 ManualLedgerEntryLog
			(MnlLdgrEntryLgID 
			,MnlLdgrEntryID
			,AccntngPrdID
			,RequestingUserID
			,ChangedDate
			,Reversed
			,Used
			,TransactionDate)
	'
			
	Select @vc_sql_ManualLedgerEntryLog_Select = '
	Select	' + convert(varchar,@i_ManualLedgerEntryLog_key) + ' + Idnty	MnlLdgrEntryLgID
			,Case New When ''N'' then MnlLdgrEntryID Else ' + convert(varchar,@i_ManualLedgerEntry_key) + ' + Idnty End	MnlLdgrEntryID
			,AcctPrdid										AccntngPrdID	
			,' + convert(varchar,@i_sysuser) + '			RequestingUserID
			,GetDate()										ChangedDate
			,Case New When ''N'' then ''Y'' else ''N'' End	Reversed
			,''N''											Used
			,#GLTempData. ReferenceDate						TransactionDate
	From	#GLTempData	(NoLock)
	Where	#GLTempData.BaseExchangeRate Is Not Null
	'
	
	If	@vc_seeselects = 'N' And @vc_temptables = 'N'
		Exec (@vc_sql_ManualLedgerEntryLog_Insert + @vc_sql_ManualLedgerEntryLog_Select)

	If	@@error <> 0
		Begin
			Select	@errmsg = 'Error - Unable to Insert ManualLedgerEntryLog'
			RollBack Transaction GLTempData
			GoTo error
		End

	----------------------------------------------------------------------------------------------------------------------
	-- Insert into AccountDetail
	----------------------------------------------------------------------------------------------------------------------
	Select @vc_sql_Accountdetail_Insert = '
	Insert	AccountDetail	
			(AcctDtlID
			,AcctDtlSrceID
			,AcctDtlTrnsctnTypID
			,AcctDtlAccntngPrdID
			,AcctDtlSlsInvceHdrID
			,AcctDtlPrchseInvceHdrID
			,AcctDtlClseStts
			,AcctDtlAcctCdeStts
			,AcctDtlTxStts
			,AcctDtlUsd
			,AcctDtlPrntID
			,AcctDtlTrnsctnDte
			,InternalBAID
			,ExternalBAID
			,Volume
			,Value
			,CrrncyID
			,ParentPrdctID
			,ChildPrdctID
			,AcctDtlUOMID
			,AcctDtlDlDtlDlHdrID
			,AcctDtlDlDtlID
			,AcctDtlMvtHdrID
			,AcctDtlPlnndTrnsfrID
			,AcctDtlLcleID
			,AcctDtlDestinationLcleID
			,AcctDtlPlnndMvtOrgnLcleID
			,AcctDtlPlnndMvtDstntnLcleID
			,PayableMatchingStatus
			,CreatedDate
			,NetQuantity
			,GrossQuantity
			,IsNetOut
			,AcctDtlSrceTble
			,BaseExchangeRate
			,SupplyDemand
			,WePayTheyPay
			,Reversed
			,BARelationship
			,AcctDtlIntraDvsnl
			,OldStyleVolume
			,OldStyleValue
			,AcctDtlStrtgyID)
	'
			
	Select @vc_sql_Accountdetail_Select = '
	Select	' + convert(varchar,@i_AccountDetail_key) + ' + Idnty			AcctDtlID
			,' + convert(varchar,@i_ManualLedgerEntryLog_key) + ' + Idnty	AcctDtlSrceID
			,TransactionTypeid		AcctDtlTrnsctnTypID
			,AcctPrdid				AcctDtlAccntngPrdID
			,Null					AcctDtlSlsInvceHdrID
			,Null					AcctDtlPrchseInvceHdrID
			,''N''					AcctDtlClseStts
			,''N''					AcctDtlAcctCdeStts
			,''R''					AcctDtlTxStts 
			,''Y''					AcctDtlUsd
			,Case	#GLTempData.New
					When ''N''	Then	#GLTempData.OriginalAcctDtlID
					Else	' + convert(varchar,@i_AccountDetail_key) + ' + Idnty		
			 End					AcctDtlPrntID
			,ReferenceDate			AcctDtlTrnsctnDte
			,InternalBAID			InternalBAID
			,ExternalBAID			ExternalBAID
			,Case	#GLTempData.New
					When	''Y''	Then 	(Abs(Volume) *	Case 	
																When SupplyDemand = ''D'' Then -1
																Else 1
															End)								
					Else	Volume * -1
			 End	Volume
			,Case	#GLTempData.New
					When	''Y''	Then	(Abs(GainLoss) *	Case 	
																	When WePayTheyPay = ''R'' Then -1
																	Else 1
																End )	 * Case When Credit = ''Y'' Then -1 Else 1 End					
					Else	GainLoss * -1
			 End	Value
			,CrrncyID				CrrncyID
			,ParentPrdctID			ParentPrdctID
			,ChildPrdctID			ChildPrdctID
			,UOMID					AcctDtlUOMID
			,DlHdrid				AcctDtlDlDtlDlHdrID
			,DlDtlid				AcctDtlDlDtlID
			,Null 					AcctDtlMvtHdrID
			,AcctDtlPlnndTrnsfrID	AcctDtlPlnndTrnsfrID
			,AcctDtlLcleID			AcctDtlLcleID
			,Null					AcctDtlDestinationLcleID
			,Null					AcctDtlPlnndMvtOrgnLcleID
			,Null					AcctDtlPlnndMvtDstntnLcleID
			,''N''					PayableMatchingStatus
			,GetDate()				CreatedDate
			,Case	#GLTempData.New
					When	''Y''	Then 	(Abs(Volume) *	Case 	
																When SupplyDemand = ''D'' Then -1
																Else 1
															End )								
								
					Else	Volume * -1
			 End					NetQuantity
			,Case	#GLTempData.New
					When	''Y''	Then 	(Abs(Volume) *	Case 	
																When SupplyDemand = ''D'' Then -1
																Else 1
															End )								
					Else	Volume * -1
			 End					GrossQuantity
			,''N''
			,''ML''
			,BaseExchangeRate
			,SupplyDemand
			,WePayTheyPay
			,Case New When ''N'' Then ''Y'' Else ''N'' End Reversed
			,BARelationship
			,''N'' AcctDtlIntraDvsnl	--Case BARelationship When ''D'' Then ''Y'' Else ''N'' End 
			,Case	#GLTempData.New
					When	''N''	Then 	OldStyleVolume * -1
					Else	Abs (Volume) 
			 End					OldStyleVolume
			,Case	#GLTempData.New
					When	''N''	Then    OldStyleValue  * -1
					Else	Abs (GainLoss)  * Case When Credit = ''Y'' Then -1 Else 1 End
			 End					OldStyleValue
			,StrtgyID
	From	#GLTempData							(NoLock)
			Left Outer Join DealDetailChemical	(NoLock)	On	#GLTempData.DlHdrID																	= DealDetailChemical.DlDtlChmclDlDtlDlHdrID
															And	#GLTempData.DlDtlID																	= DealDetailChemical.DlDtlChmclDlDtlID
															And	#GLTempData.ParentPrdctID															= DealDetailChemical.DlDtlChmclChmclPrntPrdctID
															And	NullIf(DealDetailChemical.DlDtlChmclChmclChldPrdctID, #GLTempData.ChildPrdctID )	Is Null -- SF15309
	Where 	BaseExchangeRate Is Not Null
	'

	If	@vc_seeselects = 'N' And @vc_temptables = 'N'
		Exec (@vc_sql_Accountdetail_Insert + @vc_sql_Accountdetail_Select)

	If @@error <> 0
		Begin
			Select	@errmsg = 'Error - Unable to Insert AccountDetail'
			RollBack Transaction GLTempData
			GoTo error
		End

	----------------------------------------------------------------------------------------------------------------------
	-- Insert into RiskDescription - JPW 04/02 - Uncomment once we figure out how BWO wants to handle
	----------------------------------------------------------------------------------------------------------------------
	/*
	Select @vc_sql_RiskDescription_Insert = '
	Insert	RiskDescription
			(SourceID
			,SourceTable
			,Description)
	'		

	Select @vc_sql_RiskDescription_Select = '
	Select	#GLTempData. RiskID
			,''Risk''
			,''IsEstMovementWithFuturePricing''
	From	#GLTempData	(NoLock)
	Where	#GLTempData. SourceTable		= ''X''	
	And		#GLTempData. New				= ''Y''
	And		#GLTempData. RiskID				Is Not Null
	And		#GLTempData. TransactionTypeid	In (2166,2167)	-- Sales (Accruals), Purchase (Accruals) 
	'

	If	@vc_seeselects = 'N' And @vc_temptables = 'N'
		Exec (@vc_sql_RiskDescription_Insert + @vc_sql_RiskDescription_Select)

	If	@@error <> 0
		Begin
			Select	@errmsg = 'Error - Unable to Insert RiskDescription'
			RollBack Transaction GLTempData
			GoTo error
		End
*/
	
Commit Transaction GLTempData

If	@vc_temptables = 'Y'
	Begin
		Print '#GLTempData'
		Print ''
		Select * from #GLTempData

		Print 'ManualLedgerEntry'
		Print ''
		Exec (@vc_sql_ManualLedgerEntry_Select)	

		Print 'ManualLedgerEntryLog'
		Print ''
		Exec (@vc_sql_ManualLedgerEntryLog_Select)	

		Print 'AccountDetail'
		Print ''
		Exec (@vc_sql_Accountdetail_Select)
		
		Print 'RiskDescription'
		Print ''
		Exec (@vc_sql_RiskDescription_Select)
	End

If	@vc_seeselects = 'Y'
	Begin
		Print (@vc_sql_ManualLedgerEntry_Insert + @vc_sql_ManualLedgerEntry_Select)
		Print (@vc_sql_ManualLedgerEntryLog_Insert + @vc_sql_ManualLedgerEntryLog_Select)
		Print (@vc_sql_Accountdetail_Insert + @vc_sql_Accountdetail_Select)
		Print (@vc_sql_RiskDescription_Insert + @vc_sql_RiskDescription_Select)
	End

----------------------------------------------------------------------------------------------------------------------------------------------------
--  Return Out
----------------------------------------------------------------------------------------------------------------------------------------------------
noerror:

If	@vc_seeselects = 'N'
	Begin
		Drop Table #GLTempData
		Return
	End
	
Error:

If	@vc_seeselects = 'N'
	Begin
		Select	@errmsg = 'ERROR:  ' + @errmsg
		Raiserror (@errno,15,-1, @errmsg)
		Drop Table #GLTempData
	End


GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Calculate_Unrealized_GL') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Calculate_Unrealized_GL >>>'
	Grant Execute on dbo.Custom_Calculate_Unrealized_GL to SYSUSER
	Grant Execute on dbo.Custom_Calculate_Unrealized_GL to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Calculate_Unrealized_GL>>>'
GO