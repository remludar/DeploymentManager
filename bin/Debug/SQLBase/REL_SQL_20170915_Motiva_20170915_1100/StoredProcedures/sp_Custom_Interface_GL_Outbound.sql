If OBJECT_ID('dbo.Custom_Interface_GL_Outbound') Is Not NULL
Begin
    DROP PROC dbo.Custom_Interface_GL_Outbound
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_GL_Outbound >>>'
End
Go

Create Procedure dbo.Custom_Interface_GL_Outbound	 @i_ID				int			= NULL
													,@b_Reprocess		bit			= 0	 
													,@c_GLType			char(1)		= 'M'
													,@i_AccntngPrdID	int			= NULL
													,@c_OnlyShowSQL		char(1)		= 'N'
As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	Custom_Interface_GL_Outbound @i_ID = NULL, @b_Reprocess = 0, @c_OnlyShowSQL = 'Y' 	Copyright 2003 SolArc
-- Overview:
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Joshua Weber
-- History:		06/05/2013 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--
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
Declare	 @vc_DynamicSQL				varchar(8000)
		,@vc_Error					varchar(255)
		,@c_StageInterfaceData		char(1)
		,@i_VETradePeriodID			int
		,@i_P_EODSnpShtID			int
		,@i_BatchID					int
		,@i_InvoiceID				int
		,@sdt_Date					smalldatetime
		,@sdt_PostingDate			smalldatetime
		,@sdt_RevPostingDate		smalldatetime
		,@sdt_AccntngPrdEndDte		smalldatetime
		,@i_AcctDtlID				int

----------------------------------------------------------------------------------------------------------------------
-- Block 10: Validation and Prep
----------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------
-- If an Accounting Period wasn't passed set it to the current open period
----------------------------------------------------------------------------------------------------------------------		
If	@i_AccntngPrdID	Is Null
	Select	@i_AccntngPrdID = Min(AccntngPrdID) From AccountingPeriod (NoLock) Where AccntngPrdCmplte = 'N' 

Select	@sdt_Date	= GetDate()

If	IsNull(@b_Reprocess,0) = 0
	Select @b_Reprocess = 0

----------------------------------------------------------------------------------------------------------------------
-- Check to make sure the re-processing logic is only being applied to records in an error state
----------------------------------------------------------------------------------------------------------------------	
If	@c_OnlyShowSQL = 'N'
	Begin
		If	@b_Reprocess = 1
			Begin
				If	Not Exists (Select 'X' From CustomGLInterface (NoLock) Where ID	= IsNull(@i_ID,0) And InterfaceStatus = 'E')
					GoTo NoError		  
			End
	End

----------------------------------------------------------------------------------------------------------------------
-- If we have an account detail id, set it
----------------------------------------------------------------------------------------------------------------------	
If	IsNull(@i_ID,0)	<> 0 And @b_Reprocess = 1
	Select	@i_AcctDtlID		= AcctDtlID
			,@i_AccntngPrdID	= AccntngPrdID
			,@c_GLType			= GLType
			,@i_BatchID			= BatchID
			,@i_P_EODSnpShtID	= P_EODSnpShtID
			,@sdt_PostingDate	= PostingDate
	From	CustomGLInterface	(NoLock)
	Where	ID	= @i_ID		 
	
----------------------------------------------------------------------------------------------------------------------
-- Set the accounting period end date
----------------------------------------------------------------------------------------------------------------------		
Select	@sdt_AccntngPrdEndDte	= AccntngPrdEndDte
From	AccountingPeriod (NoLock) 
Where	AccntngPrdID			= @i_AccntngPrdID

----------------------------------------------------------------------------------------------------------------------
-- Error out if the user is trying to run the Month End GL too early
----------------------------------------------------------------------------------------------------------------------
If	@sdt_Date < @sdt_AccntngPrdEndDte And @c_GLType = 'M' And @i_AcctDtlID Is Null
	Begin
		If	@c_OnlyShowSQL = 'N'
			Begin 
				Select	@vc_Error	= 'You may not proccess a Month End GL before the end of accounting period ' + convert(varchar,@i_AccntngPrdID) + '. '
				GoTo	Error
			End	
	End
		
----------------------------------------------------------------------------------------------------------------------
-- Error out if we already have a GL Header Record for this Accounting Period
----------------------------------------------------------------------------------------------------------------------
If	Exists(Select 'X' From CustomGLInterface (NoLock) Where AccntngPrdID = @i_AccntngPrdID And GLType = 'M' ) And @c_GLType = 'M' And @i_AcctDtlID Is Null
	Begin
		If	@c_OnlyShowSQL = 'N'
			Begin 
				Select	@vc_Error	= 'A GL Batch has already been created with accounting period ' + convert(varchar,@i_AccntngPrdID) + '. '
				GoTo	Error
			End	
	End

----------------------------------------------------------------------------------------------------------------------
-- Error out if this Accounting Period has already been closed
----------------------------------------------------------------------------------------------------------------------	
If	Exists(Select 'X' From AccountingPeriod (NoLock) Where AccntngPrdID = @i_AccntngPrdID And AccntngPrdCmplte = 'Y') And @c_GLType = 'M' And @i_AcctDtlID Is Null
	Begin
		If	@c_OnlyShowSQL = 'N'
			Begin
				Select	@vc_Error	= 'A GL Batch cannot be created for accounting period ' + convert(varchar,@i_AccntngPrdID) + '. It has already been closed.'
				GoTo	Error	
			End	
	End  			

----------------------------------------------------------------------------------------------------------------------
-- Error out if this Accounting Period is not the next in line to be closed 
----------------------------------------------------------------------------------------------------------------------
If	(Select Min(AccntngPrdID) From AccountingPeriod (NoLock) Where AccntngPrdCmplte = 'N') <> @i_AccntngPrdID And @c_GLType = 'M' And @i_AcctDtlID Is Null
	Begin
		If	@c_OnlyShowSQL = 'N'
			Begin 
				Select	@vc_Error	= 'A GL Batch cannot be created for accounting period ' + convert(varchar,@i_AccntngPrdID) + '. It has already been closed.'
				GoTo	Error
			End					
	End 		

----------------------------------------------------------------------------------------------------------------------
-- If we aren't reprocessing and its a Monthly GL run set the VETradePeriodID & P_EODSnpShtID values
----------------------------------------------------------------------------------------------------------------------
If	@b_Reprocess = 0
	Begin
		If	@c_GLType = 'M'	
			Begin
			
				----------------------------------------------------------------------------------------------------------------------
				-- Set the VETradePeriodID value
				----------------------------------------------------------------------------------------------------------------------
				Select	@i_VETradePeriodID	= VETradePeriodID
				From	PeriodTranslation	(NoLock)
				Where	AccntngPrdID	= @i_AccntngPrdID	
				
				----------------------------------------------------------------------------------------------------------------------
				-- Set the Month End Snapshot value
				----------------------------------------------------------------------------------------------------------------------
				Select	@i_P_EODSnpShtID			= Max(P_EODSnpShtID)
				From	Snapshot	(NoLock)
				Where	StartedFromVETradePeriodID	= @i_VETradePeriodID
				And		IsAsOfSnapshot	= 'Y'
				And		IsValid			= 'Y'
				And		Purged			= 'N'
				
				Select	@sdt_PostingDate	= AccntngPrdEndDte
				From	AccountingPeriod	(NoLock)
				Where	AccntngPrdID	= @i_AccntngPrdID
				
				Select	@sdt_RevPostingDate	= AccntngPrdBgnDte
				From	AccountingPeriod	(NoLock)
				Where	AccntngPrdID	= @i_AccntngPrdID + 1						
			End	
		Else
			Begin
				Select	@i_P_EODSnpShtID			= Max(P_EODSnpShtID)
				From	Snapshot	(NoLock)
				Where	Snapshot. Purged							= 'N'
				And		Snapshot. IsValid							= 'Y'
				And		Snapshot. IsAsOfSnapshot					= 'N'
				And		Exists	(
									Select	'X'
									From	SnapshotLog	(NoLock)
									Where	SnapshotLog. P_EODSnpShtID	= Snapshot. P_EODSnpShtID
								)
				
				Select	@sdt_PostingDate	= EndOfDay
				From	Snapshot		(NoLock)
				Where	P_EODSnpShtID	= @i_P_EODSnpShtID
				
				Select	@sdt_PostingDate	= DateAdd(mi,-1,DateAdd(d,1,@sdt_PostingDate))		
			End		
	End
		
----------------------------------------------------------------------------------------------------------------------
-- Determine the BATCH_ID
----------------------------------------------------------------------------------------------------------------------	
If	@c_OnlyShowSQL	= 'N' And @b_Reprocess = 0	
	Execute dbo.sp_getkey	'GLBatch', @i_BatchID OUTPUT
Else
	If	@b_Reprocess <> 1	
		Begin			
			Select	@i_BatchID	= Max(BatchID)
			From	CustomGLInterface	(NoLock)
			Where	AccntngPrdID	= @i_AccntngPrdID	
			And		GLType			= @c_GLType
		End	
		
If	IsNull(@i_BatchID,0) = 0
	Select	@i_BatchID	= Max(BatchID) + 1
	From	CustomGLInterface	(NoLock)				
	
----------------------------------------------------------------------------------------------------------------------
-- Block 20: Load the GL data
----------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------
-- Call Custom_Interface_AD_Mapping to denormalize the posting data
----------------------------------------------------------------------------------------------------------------------
Begin Try
		Execute dbo.Custom_Interface_AD_Mapping  @i_ID				= @i_BatchID
												,@i_MessageID		= NULL
												,@vc_Source			= 'GL'
												,@i_AccntngPrdID	= @i_AccntngPrdID
												,@i_P_EODSnpShtID	= @i_P_EODSnpShtID
												,@c_GLType			= @c_GLType
												,@i_AcctDtlID		= @i_AcctDtlID
												,@b_GLReprocess		= @b_Reprocess
												,@c_ReturnToInvoice	= 'N'
												,@c_OnlyShowSQL		= @c_OnlyShowSQL	-- 'N'																								
End Try
Begin Catch						
		Select	@vc_Error	= 'The GL Interface encountered an error executing Custom_Interface_AD_Mapping: ' + ERROR_MESSAGE()	
		GoTo	Error	
End Catch	

----------------------------------------------------------------------------------------------------------------------
-- Block 20: Stage the Data for the Interface
----------------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------------
-- Create #GLInterface
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'Y'
	Begin
		Select	'
		Create Table	#GLInterface
						(ID								int				Identity
						,BatchID						int				Not Null
						,AccntngPrdID					int				Null
						,P_EODSnpShtID					int				Null
						,GLType							char(2)			Null
						,PostingDate					varchar(25)		Null
						,DocumentDate					varchar(25)		Null
						,Chart							varchar(80)		Null
						,LocalCurrency					char(3)			Null
						,LocalDebitValue				decimal(19,2)	Null	Default 0	
						,LocalCreditValue				decimal(19,2)	Null	Default 0
						,InvoiceID						int				Null
						,ExtBAID						int				Null
						,ExtBACustomerCode				varchar(25)		Null
						,Comments						varchar(2000)	Null
						,TransactionDate				varchar(25)		Null
						,Quantity						decimal(19,6)	Null
						,PerUnitPrice					decimal(19,6)	Null	Default 0	
						,TaxCode						varchar(15)		Null
						,ProductCode					varchar(50)		Null	
						,FXConversionRate				decimal(28,13)	Null	Default 1.0	
						,DocumentCurrency				char(3)			Null
						,DocumentDebitValue				decimal(19,2)	Null	Default 0
						,DocumentCreditValue			decimal(19,2)	Null	Default 0
						,IntBAID						int				Null
						,IntBACode						varchar(25)		Null
						,InvoiceNumber					varchar(20)		Null 
						,AccountIndicator				varchar(15)		Null
						,TitleTransfer					varchar(150)	Null
						,Destination					varchar(150)	Null
						,TransactionType				varchar(80)		Null
						,Vehicle						varchar(50)		Null
						,CarrierMode					varchar(50)		Null
						,DocumentType					varchar(25)		Null
						,ExtBAVendorCode				varchar(25)		Null
						,BL								varchar(80)		Null
						,PaymentTermCode				varchar(20)		Null
						,UnitPrice						decimal(19,6)	Null	Default 0
						,UOM							varchar(20)		Null
						,AbsLocalValue					decimal(19,2)	Null	Default 0
						,LineType						varchar(3)		Null
						,ProfitCenter					varchar(80)		Null
						,CostCenter						varchar(80)		Null
						,AcctDtlID						int				Null
						,DealType						varchar(20)		Null
						,DealNumber						varchar(20)		Null
						,DealDetailID					smallint		Null
						,TransferID						int				Null
						,OrderID						int				Null
						,OrderBatchID					int				Null
						,AccrualReversed				char(1)			Null
						,PostingType					char(2)			Null
						,RiskID							int				Null
						,P_EODEstmtedAccntDtlID			int				Null
						,InterfaceStatus				char(1)			Null
						,InterfaceMessage				varchar(2000)	Null
						,AccntngPrdEndDte				smalldatetime	Null
						,AccntngPrdCmplte				char(1)			Null
						,PriceEndDate					smalldatetime	Null
						,WePayTheyPay					char(1)			Null
						,Reversed						char(1)			Null)
'
	End
Else
	Begin
		Create Table	#GLInterface
						(ID								int				Identity
						,BatchID						int				Not Null
						,AccntngPrdID					int				Null
						,P_EODSnpShtID					int				Null
						,GLType							char(2)			Null
						,PostingDate					varchar(25)		Null
						,DocumentDate					varchar(25)		Null
						,Chart							varchar(80)		Null
						,LocalCurrency					char(3)			Null
						,LocalDebitValue				decimal(19,2)	Null	Default 0	
						,LocalCreditValue				decimal(19,2)	Null	Default 0
						,InvoiceID						int				Null
						,ExtBAID						int				Null
						,ExtBACustomerCode				varchar(25)		Null
						,Comments						varchar(2000)	Null
						,TransactionDate				varchar(25)		Null
						,Quantity						decimal(19,6)	Null
						,PerUnitPrice					decimal(19,6)	Null	Default 0	
						,TaxCode						varchar(15)		Null
						,ProductCode					varchar(50)		Null	
						,FXConversionRate				decimal(28,13)	Null	Default 1.0	
						,DocumentCurrency				char(3)			Null
						,DocumentDebitValue				decimal(19,2)	Null	Default 0
						,DocumentCreditValue			decimal(19,2)	Null	Default 0
						,IntBAID						int				Null
						,IntBACode						varchar(25)		Null
						,InvoiceNumber					varchar(20)		Null 
						,AccountIndicator				varchar(15)		Null
						,TitleTransfer					varchar(150)	Null
						,Destination					varchar(150)	Null
						,TransactionType				varchar(80)		Null
						,Vehicle						varchar(50)		Null
						,CarrierMode					varchar(50)		Null
						,DocumentType					varchar(25)		Null
						,ExtBAVendorCode				varchar(25)		Null
						,BL								varchar(80)		Null
						,PaymentTermCode				varchar(20)		Null
						,UnitPrice						decimal(19,6)	Null	Default 0
						,UOM							varchar(20)		Null
						,AbsLocalValue					decimal(19,2)	Null	Default 0
						,LineType						varchar(3)		Null
						,ProfitCenter					varchar(80)		Null
						,CostCenter						varchar(80)		Null
						,AcctDtlID						int				Null
						,DealType						varchar(20)		Null
						,DealNumber						varchar(20)		Null
						,DealDetailID					smallint		Null
						,TransferID						int				Null
						,OrderID						int				Null
						,OrderBatchID					int				Null
						,AccrualReversed				char(1)			Null
						,PostingType					char(2)			Null
						,RiskID							int				Null
						,P_EODEstmtedAccntDtlID			int				Null
						,InterfaceStatus				char(1)			Null
						,InterfaceMessage				varchar(2000)	Null
						,AccntngPrdEndDte				smalldatetime	Null
						,AccntngPrdCmplte				char(1)			Null
						,PriceEndDate					smalldatetime	Null
						,WePayTheyPay					char(1)			Null
						,Reversed						char(1)			Null)
	End	
	
----------------------------------------------------------------------------------------------------------------------
-- Load the #GLInterface - Credits CustomGLInterface CustomAccountDetail
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- We need to think about how to handle negatives and whether or not to qualify WePayTheyPay = 'D'
-- Probably want to handle swaps separately
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Insert	#GLInterface		
		(BatchID
		,AccntngPrdID
		,P_EODSnpShtID
		,GLType
		,PostingDate
		,DocumentDate
		,Chart
		,LocalCurrency
		,LocalDebitValue
		,LocalCreditValue
		,InvoiceID
		,ExtBAID
		,ExtBACustomerCode
		,Comments
		,TransactionDate
		,Quantity
		,PerUnitPrice	
		,TaxCode
		,ProductCode
		,FXConversionRate
		,DocumentCurrency
		,DocumentDebitValue
		,DocumentCreditValue
		,IntBAID
		,IntBACode
		,InvoiceNumber
		,AccountIndicator
		,TitleTransfer
		,Destination
		,TransactionType
		,Vehicle
		,CarrierMode
		,DocumentType
		,ExtBAVendorCode
		,BL
		,PaymentTermCode
		,UnitPrice
		,UOM
		,AbsLocalValue
		,LineType
		,ProfitCenter
		,CostCenter
		,AcctDtlID
		,DealType
		,DealNumber
		,DealDetailID
		,TransferID
		,OrderID
		,OrderBatchID
		,AccrualReversed
		,PostingType
		,RiskID
		,P_EODEstmtedAccntDtlID
		,InterfaceStatus
		,InterfaceMessage
		,PriceEndDate
		,WePayTheyPay
		,Reversed)
Select	 BatchID													-- BatchID
		,' + convert(varchar,@i_AccntngPrdID) + '					-- AccntngPrdID
		,' + convert(varchar,IsNull(@i_P_EODSnpShtID, 0)) + '		-- P_EODSnpShtID
		,GLType														-- GLType
		,dbo.Custom_Format_SAP_Date_String(''' + convert(varchar,IsNull(@sdt_PostingDate,GetDate())) + ''')				-- PostingDate
		,dbo.Custom_Format_SAP_Date_String(''' + convert(varchar,IsNull(@sdt_PostingDate,GetDate())) + ''')				-- DocumentDate
		,AccountDetailAccountCode. AcctDtlAcctCdeCde				-- Chart
		,LocalCurrency												-- LocalCurrency
		,0.0														-- LocalDebitValue
		,Round(LocalValue,2)										-- LocalCreditValue
		,RAInvoiceID												-- InvoiceID
		,ExternalBAID												-- ExtBAID
		,XRefExtBACode												-- ExtBACustomerCode
		,Comments													-- Comments
		,dbo.Custom_Format_SAP_Date_String(TransactionDate)			-- TransactionDate
		,Round(Case When AcctDtlSrceTble = ''IV''
					Then Quantity
					Else InvoiceQuantity End, 3)					-- Quantity
		,0															-- PerUnitPrice	
		,NULL														-- TaxCode					-- Should be blank
		,XRefChildPrdctCode											-- ProductCode
		,1.0														-- FXConversionRate			-- Assumed all values are in USD
		,LocalCurrency												-- DocumentCurrency
		,0.0														-- DocumentDebitValue
		,Round(LocalValue,2)										-- DocumentCreditValue
		,InternalBAID												-- IntBAID
		,XRefIntBACode												-- IntBACode
		,InvoiceNumber												-- InvoiceNumber
		,Case When AccountCode. AcctCdeTpe = ''P'' Then ''2'' Else ''1'' End	-- AccountIndicator			-- 1 - P/L Row / 2 - GL Row
		,MvtHdrLocation												-- TitleTransfer
		,MvtHdrDestination											-- Destination
		,TrnsctnTypDesc												-- TransactionType
		,Vhcle														-- Vehicle
		,MvtHdrTypName												-- CarrierMode
		,''ACC''													-- DocumentType		
		,XRefExtBACode												-- ExtBAVendorCode
		,MvtDcmntExtrnlDcmntNbr										-- BL
		,XRefTrmCode												-- PaymentTermCode
		,0															-- UnitPrice
		,InvoiceUOM													-- UOM
		,Round(Abs(LocalValue),2)									-- AbsLocalValue
		,''50''														-- LineType					-- 40 Debit / 50 Credit
		,ProfitCenter												-- ProfitCenter
		,CostCenter													-- CostCenter
		,AcctDtlID													-- AcctDtlID
		,DlDtlTpe													-- DealType
		,DlHdrIntrnlNbr												-- DealNumber
		,DlDtlID													-- DealDetailID
		,PlnndTrnsfrID												-- TransferID
		,PlnndMvtID													-- OrderID
		,PlnndMvtBtchID												-- OrderBatchID
		,''N''														-- AccrualReversed
		,PostingType												-- PostingType
		,RiskID														-- RiskID
		,P_EODEstmtedAccntDtlID										-- P_EODEstmtedAccntDtlID
		,''R''														-- InterfaceStatus
		,''''														-- InterfaceMessage
		,PriceEndDate												-- PriceEndDate 
		,WePayTheyPay												-- WePayTheyPay
		,Reversed
From	CustomAccountDetail							(NoLock)
		Left Outer Join	AccountDetailAccountCode	(NoLock)	On	CustomAccountDetail. AcctDtlID						= AccountDetailAccountCode. AcctDtlAcctCdeAcctDtlID  	
																And	AccountDetailAccountCode. AcctDtlAcctCdeBlnceTpe	= ''C''	
		Left Outer Join	AccountCode					(NoLock)	On	AccountDetailAccountCode. AcctDtlAcctCdeAcctCdeID	= AccountCode. AcctCdeID				

Where	CustomAccountDetail. InterfaceSource		= ''GL''
And		CustomAccountDetail. BatchID				= ' + convert(varchar,IsNull(@i_BatchID,0)) + '
'	+	
	Case
		When	@i_AcctDtlID	Is Not Null	Then	'
And		CustomAccountDetail. AcctDtlID				= ' + convert(varchar, @i_AcctDtlID) + '
'  	
		Else	'
'
	End

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Load the #GLInterface - Debits CustomGLInterface CustomAccountDetail
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- We need to think about how to handle negatives and whether or not to qualify WePayTheyPay = 'R'
-- Probably want to handle swaps separately
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Insert	#GLInterface		
		(BatchID
		,AccntngPrdID
		,P_EODSnpShtID
		,GLType
		,PostingDate
		,DocumentDate
		,Chart
		,LocalCurrency
		,LocalDebitValue
		,LocalCreditValue
		,InvoiceID
		,ExtBAID
		,ExtBACustomerCode
		,Comments
		,TransactionDate
		,Quantity
		,PerUnitPrice	
		,TaxCode
		,ProductCode
		,FXConversionRate
		,DocumentCurrency
		,DocumentDebitValue
		,DocumentCreditValue
		,IntBAID
		,IntBACode
		,InvoiceNumber
		,AccountIndicator
		,TitleTransfer
		,Destination
		,TransactionType
		,Vehicle
		,CarrierMode
		,DocumentType
		,ExtBAVendorCode
		,BL
		,PaymentTermCode
		,UnitPrice
		,UOM
		,AbsLocalValue
		,LineType
		,ProfitCenter
		,CostCenter
		,AcctDtlID
		,DealType
		,DealNumber
		,DealDetailID
		,TransferID
		,OrderID
		,OrderBatchID
		,AccrualReversed
		,PostingType
		,RiskID
		,P_EODEstmtedAccntDtlID
		,InterfaceStatus
		,InterfaceMessage
		,PriceEndDate
		,WePayTheyPay
		,Reversed)
Select	 BatchID													-- BatchID
		,' + convert(varchar,@i_AccntngPrdID) + '					-- AccntngPrdID
		,' + convert(varchar,IsNull(@i_P_EODSnpShtID, 0)) + '		-- P_EODSnpShtID
		,GLType														-- GLType
		,dbo.Custom_Format_SAP_Date_String(''' + convert(varchar,IsNull(@sdt_PostingDate,GetDate())) + ''')				-- PostingDate
		,dbo.Custom_Format_SAP_Date_String(''' + convert(varchar,IsNull(@sdt_PostingDate,GetDate())) + ''')				-- DocumentDate
		,AccountDetailAccountCode. AcctDtlAcctCdeCde				-- Chart
		,LocalCurrency												-- LocalCurrency
		,Round(LocalValue,2) 										-- LocalDebitValue
		,0.0														-- LocalCreditValue
		,RAInvoiceID												-- InvoiceID
		,ExternalBAID												-- ExtBAID
		,XRefExtBACode												-- ExtBACustomerCode
		,Comments													-- Comments
		,dbo.Custom_Format_SAP_Date_String(TransactionDate)			-- TransactionDate
		,Round(Case When AcctDtlSrceTble = ''IV''
					Then Quantity
					Else InvoiceQuantity End, 3)					-- Quantity
		,0															-- PerUnitPrice	
		,NULL														-- TaxCode					-- Should be blank
		,XRefChildPrdctCode											-- ProductCode
		,1.0														-- FXConversionRate			-- Assumed all values are in USD
		,LocalCurrency												-- DocumentCurrency
		,Round(LocalValue,2) 										-- DocumentDebitValue
		,0.0														-- DocumentCreditValue
		,InternalBAID												-- IntBAID
		,XRefIntBACode												-- IntBACode
		,InvoiceNumber												-- InvoiceNumber
		,Case When AccountCode. AcctCdeTpe = ''P'' Then ''2'' Else ''1'' End	-- AccountIndicator			-- 1 - P/L Row / 2 - GL Row
		,MvtHdrLocation												-- TitleTransfer
		,MvtHdrDestination											-- Destination
		,TrnsctnTypDesc												-- TransactionType
		,Vhcle														-- Vehicle
		,MvtHdrTypName												-- CarrierMode
		,''ACC''													-- DocumentType		
		,XRefExtBACode												-- ExtBAVendorCode
		,MvtDcmntExtrnlDcmntNbr										-- BL
		,XRefTrmCode												-- PaymentTermCode
		,0															-- UnitPrice
		,InvoiceUOM													-- UOM
		,Round(Abs(LocalValue),2)									-- AbsLocalValue
		,''40''														-- LineType					-- 40 Debit / 50 Credit
		,ProfitCenter												-- ProfitCenter
		,CostCenter													-- CostCenter
		,AcctDtlID													-- AcctDtlID
		,DlDtlTpe													-- DealType
		,DlHdrIntrnlNbr												-- DealNumber
		,DlDtlID													-- DealDetailID
		,PlnndTrnsfrID												-- TransferID
		,PlnndMvtID													-- OrderID
		,PlnndMvtBtchID												-- OrderBatchID
		,''N''														-- AccrualReversed
		,PostingType												-- PostingType
		,RiskID														-- RiskID
		,P_EODEstmtedAccntDtlID										-- P_EODEstmtedAccntDtlID
		,''R''														-- InterfaceStatus
		,''''														-- InterfaceMessage
		,PriceEndDate												-- PriceEndDate 
		,WePayTheyPay												-- WePayTheyPay
		,Reversed
From	CustomAccountDetail							(NoLock)
		Left Outer Join	AccountDetailAccountCode	(NoLock)	On	CustomAccountDetail. AcctDtlID						= AccountDetailAccountCode. AcctDtlAcctCdeAcctDtlID  	
																And	AccountDetailAccountCode. AcctDtlAcctCdeBlnceTpe	= ''D''	
		Left Outer Join	AccountCode					(NoLock)	On	AccountDetailAccountCode. AcctDtlAcctCdeAcctCdeID	= AccountCode. AcctCdeID				

Where	CustomAccountDetail. InterfaceSource		= ''GL''
And		CustomAccountDetail. BatchID				= ' + convert(varchar,IsNull(@i_BatchID,0)) + '
'	+	
	Case
		When	@i_AcctDtlID	Is Not Null	Then	'
And		CustomAccountDetail. AcctDtlID				= ' + convert(varchar, @i_AcctDtlID) + '
'  	
		Else	'
'
	End

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Reset the reversal charts
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		LocalDebitValue			= Abs(LocalCreditValue)
		,LocalCreditValue		= Abs(LocalDebitValue)
		,DocumentDebitValue		= Abs(DocumentCreditValue)
		,DocumentCreditValue	= Abs(DocumentDebitValue)
		,LineType				= Case When LineType = 40 Then 50 Else 40 End
From	#GLInterface	(NoLock)
Where	#GLInterface. Reversed	= ''Y''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Determine the Accounting Period End Date for the Postings
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		AccntngPrdEndDte	= AccountingPeriod. AccntngPrdEndDte
		,AccntngPrdCmplte	= AccountingPeriod. AccntngPrdCmplte
From	#GLInterface				(NoLock)
		Inner Join	AccountDetail		(NoLock)	On	#GLInterface. AcctDtlID				= AccountDetail. AcctDtlID		
		Inner Join	AccountingPeriod	(NoLock)	On	AccountDetail. AcctDtlAccntngPrdID	= AccountingPeriod. AccntngPrdID
Where	#GLInterface. GLType	= ''N''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		

----------------------------------------------------------------------------------------------------------------------
-- Roll Previous Month's Postings Back to the Appropriate Period
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		PostingDate	=	Case
							When	AccntngPrdEndDte < PostingDate And AccntngPrdCmplte = ''N''	Then	AccntngPrdEndDte
							When	AccntngPrdEndDte < PostingDate And AccntngPrdCmplte = ''Y''	Then	''' + convert(varchar,@sdt_PostingDate) + '''
							Else	PostingDate
						End
From	#GLInterface			(NoLock)
Where	#GLInterface. GLType	= ''N''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Remove any rows that priced in after the close of the period - these may have bled through and were picked up by 
-- either the Accrual engine run or the Physical Forwards
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Delete	#GLInterface
Where	IsNull(PriceEndDate,''2012-01-01'')	> ''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''
And		#GLInterface. GLType			= ''M''
And		#GLInterface. PostingType		= ''AD''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the per unit price value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Update	#GLInterface
Set		PerUnitPrice	=	Abs(Case
								When	Quantity	<> 0 Then ( (IsNull(LocalDebitValue,0) + IsNull(LocalCreditValue,0)) / Quantity )
								Else	0.0
							End )
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		
	
----------------------------------------------------------------------------------------------------------------------
-- Block 30: Data Validation
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Validate a Chart value is present
----------------------------------------------------------------------------------------------------------------------
/*Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Chart could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. Chart, '''')))	= ''''	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Local Currency value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Local Currency could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. LocalCurrency, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Transaction Date value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Transaction Date could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. TransactionDate, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Product Code value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Product Code could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. ProductCode, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Document Currency value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Document Currency could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. DocumentCurrency, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Int BA Code value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Int BA Code could not be determined [SAPInternalNumber Attribute - BA Maint]. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. IntBACode, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Transaction Type value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Transaction Type could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. TransactionType, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Line Type value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Line Type could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. LineType, '''')))	= ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Profit Center value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Profit Center could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. ProfitCenter, '''')))	= ''''
And		#GLInterface. WePayTheyPay = ''D''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Validate a Cost Center value is present
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	#GLInterface
Set		InterfaceMessage	= InterfaceMessage + '' A value for Cost Center could not be determined. ''
		,InterfaceStatus	= ''E''
Where	RTrim(LTrim(IsNull(#GLInterface. CostCenter, '''')))	= ''''
And		#GLInterface. WePayTheyPay = ''R''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Reset records to 'R' if we are ignoring errors
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
If	(Select GenerateFileWithErrors From CustomConfigAccounting (NoLock) Where ConfigurationName = ''Default'') = ''Y''
	Update	#GLInterface
	Set		InterfaceStatus		= ''R''
	Where	InterfaceStatus		= ''E''		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
*/
----------------------------------------------------------------------------------------------------------------------
-- Block 40: Insert the reversals
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Insert	#GLInterface		
		(BatchID
		,AccntngPrdID
		,P_EODSnpShtID
		,GLType
		,PostingDate
		,DocumentDate
		,Chart
		,LocalCurrency
		,LocalDebitValue
		,LocalCreditValue
		,InvoiceID
		,ExtBAID
		,ExtBACustomerCode
		,Comments
		,TransactionDate
		,Quantity
		,PerUnitPrice	
		,TaxCode
		,ProductCode
		,FXConversionRate
		,DocumentCurrency
		,DocumentDebitValue
		,DocumentCreditValue
		,IntBAID
		,IntBACode
		,InvoiceNumber
		,AccountIndicator
		,TitleTransfer
		,Destination
		,TransactionType
		,Vehicle
		,CarrierMode
		,DocumentType
		,ExtBAVendorCode
		,BL
		,PaymentTermCode
		,UnitPrice
		,UOM
		,AbsLocalValue
		,LineType
		,ProfitCenter
		,CostCenter
		,AcctDtlID
		,DealType
		,DealNumber
		,DealDetailID
		,TransferID
		,OrderID
		,OrderBatchID
		,AccrualReversed
		,PostingType
		,RiskID
		,P_EODEstmtedAccntDtlID
		,InterfaceStatus
		,InterfaceMessage
		,PriceEndDate
		,WePayTheyPay)
Select	BatchID
		,AccntngPrdID
		,P_EODSnpShtID
		,GLType
		,dbo.Custom_Format_SAP_Date_String(''' + convert(varchar,DateAdd(day, 1, IsNull(@sdt_PostingDate,GetDate()))) + ''')			-- PostingDate
		,dbo.Custom_Format_SAP_Date_String(''' + convert(varchar,IsNull(@sdt_PostingDate,GetDate())) + ''')				-- DocumentDate
		,Chart
		,LocalCurrency
		,LocalCreditValue
		,LocalDebitValue 
		,InvoiceID
		,ExtBAID
		,ExtBACustomerCode
		,Comments
		,TransactionDate
		,Quantity
		,PerUnitPrice	
		,TaxCode
		,ProductCode
		,FXConversionRate
		,DocumentCurrency
		,DocumentCreditValue 
		,DocumentDebitValue
		,IntBAID
		,IntBACode
		,InvoiceNumber
		,AccountIndicator
		,TitleTransfer
		,Destination
		,TransactionType
		,Vehicle
		,CarrierMode
		,DocumentType
		,ExtBAVendorCode
		,BL
		,PaymentTermCode
		,UnitPrice
		,UOM
		,AbsLocalValue
		,Case When LineType = 40 Then 50 Else 40 End	-- LineType
		,ProfitCenter
		,CostCenter
		,AcctDtlID
		,DealType
		,DealNumber
		,DealDetailID
		,TransferID
		,OrderID
		,OrderBatchID
		,''Y''											-- AccrualReversed
		,PostingType
		,RiskID
		,P_EODEstmtedAccntDtlID
		,InterfaceStatus
		,InterfaceMessage
		,PriceEndDate
		,WePayTheyPay		
From	#GLInterface		(NoLock)
Where	TransactionType	<> ''Inventory Valuation''
and		TransactionType	not like ''TP-%''
and		not exists	(
					Select	1
					From	TransactionType (NoLock)
							Inner Join TransactionTypeGroup (NoLock)
								on	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							Inner Join TransactionGroup (NoLock)
								on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
					Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
					And		TransactionType.TrnsctnTypDesc	= #GLInterface.TransactionType
					)
'	
	
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Block 50: Stage the interface tables
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL <> 'Y'
	Begin
	
		Begin Transaction InsertGL
		
			----------------------------------------------------------------------------------------------------------------------
			-- If we are reprocessing a gl entry remove the original entry  sp_columnlist CustomGLInterface
			----------------------------------------------------------------------------------------------------------------------			
			If	@b_Reprocess = 1							
				Delete	CustomGLInterface							
				Where	BatchID			= IsNull(@i_BatchID,0)
				And		GLType			= IsNull(@c_GLType,'Z')
				And		AcctDtlID		= IsNull(@i_AcctDtlID,0)
				
			----------------------------------------------------------------------------------------------------------------------
			-- Stage the record into SRA's CustomGLInterface table
			----------------------------------------------------------------------------------------------------------------------	
			Insert	CustomGLInterface		
					(BatchID
					,AccntngPrdID
					,P_EODSnpShtID
					,GLType
					,PostingDate
					,DocumentDate
					,Chart
					,LocalCurrency
					,LocalDebitValue
					,LocalCreditValue
					,InvoiceID
					,ExtBAID
					,ExtBACustomerCode
					,Comments
					,TransactionDate
					,Quantity
					,PerUnitPrice
					,TaxCode
					,ProductCode
					,FXConversionRate
					,DocumentCurrency
					,DocumentDebitValue
					,DocumentCreditValue
					,IntBAID
					,IntBACode
					,InvoiceNumber
					,AccountIndicator
					,TitleTransfer
					,Destination
					,TransactionType
					,Vehicle
					,CarrierMode
					,DocumentType
					,ExtBAVendorCode
					,BL
					,PaymentTermCode
					,UnitPrice
					,UOM
					,AbsLocalValue
					,LineType
					,ProfitCenter
					,CostCenter
					,AcctDtlID
					,DealType
					,DealNumber
					,DealDetailID
					,TransferID
					,OrderID
					,OrderBatchID
					,AccrualReversed
					,PostingType
					,RiskID
					,P_EODEstmtedAccntDtlID
					,InterfaceStatus
					,InterfaceMessage
					,CreationDate)
			Select	 BatchID
					,AccntngPrdID
					,P_EODSnpShtID
					,GLType
					,IsNull(PostingDate,'')
					,IsNull(DocumentDate,'')
					,IsNull(Chart,'')
					,IsNull(LocalCurrency,'')
					,IsNull(LocalDebitValue,0)
					,IsNull(LocalCreditValue,0)
					,InvoiceID
					,ExtBAID
					,IsNull(ExtBACustomerCode,'')
					,IsNull(Comments,'')
					,IsNull(TransactionDate,'')
					,IsNull(Quantity,0)
					,IsNull(PerUnitPrice,0)
					,IsNull(TaxCode,'')
					,IsNull(ProductCode,'')
					,IsNull(FXConversionRate,1)
					,IsNull(DocumentCurrency,'')
					,IsNull(DocumentDebitValue,0)
					,IsNull(DocumentCreditValue,0)
					,IntBAID
					,IsNull(IntBACode,'')
					,IsNull(InvoiceNumber,'')
					,IsNull(AccountIndicator,'')
					,IsNull(TitleTransfer,'')
					,IsNull(Destination,'')
					,IsNull(TransactionType,'')
					,IsNull(Vehicle,'')
					,IsNull(CarrierMode,'')
					,DocumentType
					,IsNull(ExtBAVendorCode,'')
					,IsNull(BL,'')
					,IsNull(PaymentTermCode,'')
					,IsNull(UnitPrice,0)
					,IsNull(UOM,'')
					,IsNull(AbsLocalValue,0)
					,IsNull(LineType,'')
					,IsNull(ProfitCenter,'')
					,IsNull(CostCenter,'')
					,AcctDtlID
					,IsNull(DealType,'')
					,IsNull(DealNumber,'')
					,DealDetailID
					,TransferID
					,OrderID
					,OrderBatchID
					,AccrualReversed
					,PostingType
					,RiskID
					,P_EODEstmtedAccntDtlID
					,InterfaceStatus
					,IsNull(InterfaceMessage,'')
					,@sdt_Date												
			From	#GLInterface	(NoLock)														
			
			---------------------------------------------------------------------------------------------------------------------
			-- Check for Errors on the Insert
			----------------------------------------------------------------------------------------------------------------------
			If	@@error <> 0 
				Begin
					Rollback Transaction InsertGL
					
					Select	@vc_Error			= 'The GL Interface encountered an error inserting a record into the CustomGLInterface table.' 									
					Goto	Error						
				End						

			----------------------------------------------------------------------------------------------------------------------------------
			-- Commit the Transaction
			----------------------------------------------------------------------------------------------------------------------------------
			Commit Transaction InsertGL					
	End
	
----------------------------------------------------------------------------------------------------------------------
-- Drop the temp table
----------------------------------------------------------------------------------------------------------------------	
If	Object_ID('TempDB..#GLInterface') Is Not Null
	Drop Table #GLInterface	
					
----------------------------------------------------------------------------------------------------------------------
-- Return out
----------------------------------------------------------------------------------------------------------------------
NoError:
	Return	
		
----------------------------------------------------------------------------------------------------------------------
-- Error Handler:
----------------------------------------------------------------------------------------------------------------------
Error:  
Raiserror (60010,15,-1, @vc_Error	)


GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.Custom_Interface_GL_Outbound') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_GL_Outbound >>>'
	Grant Execute on dbo.Custom_Interface_GL_Outbound to SYSUSER
	Grant Execute on dbo.Custom_Interface_GL_Outbound to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_GL_Outbound >>>'
GO

 