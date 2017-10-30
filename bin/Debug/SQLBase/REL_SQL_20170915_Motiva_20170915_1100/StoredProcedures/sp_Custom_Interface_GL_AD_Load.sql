If OBJECT_ID('dbo.Custom_Interface_GL_AD_Load') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Interface_GL_AD_Load
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_GL_AD_Load >>>'
End
Go  

Create Procedure dbo.Custom_Interface_GL_AD_Load	@i_ID				int		= NULL
													,@i_AccntngPrdID	int		= NULL
													,@i_P_EODSnpShtID	int		= NULL
													,@c_GLType			char(2)	= NULL
													,@i_AcctDtlID		int		= NULL
													,@b_GLReprocess		bit		= 0
													,@c_OnlyShowSQL  	char(1) = 'N' 
As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		Custom_Interface_GL_AD_Load @i_ID = 6, @i_AccntngPrdID = 291, @c_GLType = 'M', @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
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
		,@sdt_AccntngPrdEndDte		smalldatetime
		,@i_Inv_Val_TrnsctnTypID	int
		,@i_Swap_TrnsctnTypID		int
		,@i_IH_TrnsctnTypID			int
		,@i_VAT_XGrpID				int
		,@i_NightlyGL_XGrpID		int
		,@i_MonthlyGL_XGrpID		int
		,@vc_UnrealizedString		varchar(50)
		,@vc_KeepSignString			varchar(50)
		,@i_DefaultUOMID			int
		,@i_DefaultUOM				varchar(80)
		,@i_DefaultPerUnitDecimals	int
		,@i_DefaultQtyDecimals		int
		,@i_CustomGLExclusionCount	int
		
----------------------------------------------------------------------------------------------------------------------
-- Set the Transaction Type Values that we will need
----------------------------------------------------------------------------------------------------------------------
Select	@i_Inv_Val_TrnsctnTypID	= TrnsctnTypID 
From	TransactionType	(NoLock)
Where	TrnsctnTypDesc	= 'Inventory Valuation'	

Select	@i_Swap_TrnsctnTypID	= TrnsctnTypID 
From	TransactionType	(NoLock)
Where	TrnsctnTypDesc	= 'Swaps'

Select	@i_VAT_XGrpID	= XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Tax'

select	@i_CustomGLExclusionCount = count(1)
From	dbo.CustomGLExclusion

/*
Select	@i_NightlyGL_XGrpID	= XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Include in Nightly GL'
*/

Select	@i_MonthlyGL_XGrpID = XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Exclude From Monthly GL'

Select	@i_IH_TrnsctnTypID	= TrnsctnTypID 
From	TransactionType	(NoLock)
Where	TrnsctnTypDesc	= 'Inhouse Transactions'

Select	@vc_KeepSignString	= '2061'

Select	@vc_UnrealizedString	= '2027,2028,2029,2030'

Select	@vc_UnrealizedString	= @vc_UnrealizedString + ',' + Convert(Varchar, TT.TrnsctnTypID)
From	TransactionType TT
Where	Exists	(
				Select	1
				From	Registry
				Where	Registry.RgstryFllKyNme		= 'Motiva\SAP\GLXctnTypes\SalesAccrual\'
				And		TT.TrnsctnTypDesc			= Registry.RgstryDtaVle
				)

Select	@vc_UnrealizedString	= @vc_UnrealizedString + ',' + Convert(Varchar, TT.TrnsctnTypID)
From	TransactionType TT
Where	Exists	(
				Select	1
				From	Registry
				Where	Registry.RgstryFllKyNme		= 'Motiva\SAP\GLXctnTypes\PurchaseAccrual\'
				And		TT.TrnsctnTypDesc			= Registry.RgstryDtaVle
				)

Select	@vc_UnrealizedString	= @vc_UnrealizedString + ',' + Convert(Varchar, TT.TrnsctnTypID)
From	TransactionType TT
Where	Exists	(
				Select	1
				From	Registry
				Where	Registry.RgstryFllKyNme		= 'Motiva\SAP\GLXctnTypes\IncompletePricingAccrual\'
				And		TT.TrnsctnTypDesc			= Registry.RgstryDtaVle
				)


Select	@i_DefaultUOMID				= InterfaceDefaultUOMID
		,@i_DefaultUOM				= InterfaceDefaultUOM
		,@i_DefaultPerUnitDecimals	= InterfaceDefaultPerUnitDecimals
		,@i_DefaultQtyDecimals		= InterfaceDefaultQtyDecimals		
From	CustomConfigAccounting	(NoLock)
Where	ConfigurationName	= 'Default'

/*
Include in Monthly GL
Include in Nightly GL
*/

----------------------------------------------------------------------------------------------------------------------
-- If we are running a monthly GL the accounting period id needs to be present
----------------------------------------------------------------------------------------------------------------------	
If	@i_AccntngPrdID Is Null Or @i_ID Is Null
	Begin
		If	@c_OnlyShowSQL = 'N'
			Begin 
				Select	@vc_Error	= 'A GL Batch requires an Accounting Period and Batch ID.'
				GoTo	Error
			End					
	End 

----------------------------------------------------------------------------------------------------------------------
-- Set the Accounting Period values that we will need
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_AccntngPrdEndDte	= AccntngPrdEndDte
From	AccountingPeriod	(NoLock)
Where	AccountingPeriod. AccntngPrdID	= IsNull(@i_AccntngPrdID, 720)

----------------------------------------------------------------------------------------------------------------------
-- Collect the Monthly GL Data
----------------------------------------------------------------------------------------------------------------------
If	@c_GLType	= 'M' And @b_GLReprocess = 0
	Begin
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for Realized records that have not been invoiced yet
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand															
				,AccountDetail. Value	
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume	
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID
				,''' + @c_GLType + '''
				,''AD''
				,' + convert(varchar,@i_ID) + '
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '

				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail				(NoLock)
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1 
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null	
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'', ''P'')
		And		TransactionType. TrnsctnTypMvt			<> ''I''																				-- Exclude Accrual Transaction Types
		And		AccountDetail. Value 					<> 0.0

		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		----------------------------------------------------------------------------------------------------------------------
		-- Remove any Discards
		----------------------------------------------------------------------------------------------------------------------			
		Select	@vc_DynamicSQL	= '
		Delete	tmp_CustomAccountDetail
		Where	tmp_CustomAccountDetail.PayableMatchingStatus	= ''D''
		And		( -- delete if it is Prior Month, or if it is NOT GL Do Not Reverse
				AccntngPrdID		< ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		Or		Not Exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID				= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName					= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= tmp_CustomAccountDetail.TrnsctnTypID
							)
				)
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

		----------------------------------------------------------------------------------------------------------------------
		-- Remove any GL Do Not Reverse for old periods
		----------------------------------------------------------------------------------------------------------------------			
		Select	@vc_DynamicSQL	= '
		Delete	tmp_CustomAccountDetail
		Where	tmp_CustomAccountDetail.PayableMatchingStatus	<> ''D''
		And		tmp_CustomAccountDetail.AccntngPrdID			< ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		Exists	(
						Select	1
						From	TransactionTypeGroup (NoLock)
								Inner Join TransactionGroup (NoLock)
									on	TransactionGroup.XGrpID				= TransactionTypeGroup.XTpeGrpXGrpID
						Where	TransactionGroup.XGrpName					= ''GL Do Not Reverse''
						And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= tmp_CustomAccountDetail.TrnsctnTypID
						)
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

		----------------------------------------------------------------------------------------------------------------------
		-- Get rid of the Clearport Swaps - they are fed in the Nightly Run
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Delete	tmp_CustomAccountDetail
		Where	TrnsctnTypID	= ' + convert(varchar,IsNull(@i_Swap_TrnsctnTypID,0)) + ' 	
		And		Exists	(	Select	''X''
							From	GeneralConfiguration	(NoLock)
							Where	GeneralConfiguration. GnrlCnfgTblNme				= ''DealHeader''
							And		GeneralConfiguration. GnrlCnfgQlfr					= ''ExchangeTraded''
							And		tmp_CustomAccountDetail. DlHdrID						= GeneralConfiguration. GnrlCnfgHdrID	
							And		GeneralConfiguration. GnrlCnfgHdrID					<> 0
							And		IsNull(GeneralConfiguration. GnrlCnfgMulti,'''')	Not In (''None'',''''))
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		
		
		----------------------------------------------------------------------------------------------------------------------
		-- Set the DlDtlPrvsnID value - Pass 1 Movement Based
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '		
		Update	tmp_CustomAccountDetail
		Set		DlDtlPrvsnID			= TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID
		From	tmp_CustomAccountDetail				(NoLock)
				Inner Join	TransactionDetailLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID	= TransactionDetailLog. XDtlLgAcctDtlID
		Where	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''X''	
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
		
		----------------------------------------------------------------------------------------------------------------------
		-- Set the DLDTLPRVSNID value - Pass 2 Time Transaction Based
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '		
		Update	tmp_CustomAccountDetail
		Set		DlDtlPrvsnID		= TimeTransactionDetail. TmeXDtlDlDtlPrvsnID
				,DlDtlPrvsnRwID		= TimeTransactionDetail. TmeXDtlDlDtlPrvsnRwID
		From	tmp_CustomAccountDetail						(NoLock)
				Inner Join	TimeTransactionDetailLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID					= TimeTransactionDetailLog. TmeXDtlLgAcctDtlID
				Inner Join	TimeTransactionDetail		(NoLock)	On	TimeTransactionDetailLog. TmeXDtlLgTmeXDtlIdnty	= TimeTransactionDetail. TmeXDtlIdnty
		Where	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''TT''	
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
		
		----------------------------------------------------------------------------------------------------------------------
		-- Set the DLDTLPRVSNID value - Pass 3 Movement Expense Based
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '		
		Update	tmp_CustomAccountDetail
		Set		DlDtlPrvsnID		= MovementExpenseLog. MvtExpnseLgMvtExpnseID
		From	tmp_CustomAccountDetail					(NoLock)
				Inner Join	MovementExpenseLog		(NoLock)	On	tmp_CustomAccountDetail. AcctDtlSrceID		= MovementExpenseLog. MvtExpnseLgID
																And	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''M''	
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		----------------------------------------------------------------------------------------------------------------------
		-- Set the DLDTLPRVSNID value - Pass 3 Movement Expense Based
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '		
		Update	tmp_CustomAccountDetail
		Set		DlDtlPrvsnID		= NULL
		Where	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''M''	
		'
		
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)																			
		
		----------------------------------------------------------------------------------------------------------------------
		-- Invoice Accruals
		----------------------------------------------------------------------------------------------------------------------				
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail with Details Attached to a Sales Invoice that has an Active or Held Status - Step 1
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)							
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				 
				,AccountDetail. AcctDtlSlsInvceHdrID
				,SalesInvoiceHeader. SlsInvceHdrNmbr																																									 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID													
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand														
				,AccountDetail. Value																				
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume																
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																				
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AR''	
				,' + convert(varchar,@i_ID) + '	
				,''SlsInvceHdrID:'' + convert(varchar,SalesInvoiceHeader. SlsInvceHdrID) + ''||InvoiceNumber:'' + SalesInvoiceHeader. SlsInvceHdrNmbr  + ''||Status:'' + SalesInvoiceHeader. SlsInvceHdrStts + ''||Reason:Invoice has not been distributed.''
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '				
				
				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc

		From	AccountDetail					(NoLock)
				Inner Join	SalesInvoiceHeader	(NoLock)	On	AccountDetail. AcctDtlSlsInvceHdrID		= SalesInvoiceHeader. SlsInvceHdrID
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		SalesInvoiceHeader. SlsInvceHdrStts		In (''A'', ''H'')
		And		SalesInvoiceHeader. SlsInvceHdrTtlVle	<> 0.0
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail with Details Attached to a Sales Invoice that has a Sent Status but Not Fed - Step 2
		----------------------------------------------------------------------------------------------------------------------	
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																	
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 													
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus												
				,''GL'' 																		
				,AccountDetail. AcctDtlSlsInvceHdrID
				,SalesInvoiceHeader. SlsInvceHdrNmbr																																								 	
				,AccountDetail. InternalBAID														
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand														
				,AccountDetail. Value																			
				,AccountDetail. CrrncyID														
				,AccountDetail. Volume															
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																			
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AR''	
				,' + convert(varchar,@i_ID) + '	
				,''SlsInvceHdrID:'' + convert(varchar,SalesInvoiceHeader. SlsInvceHdrID) + ''||InvoiceNumber:'' + SalesInvoiceHeader. SlsInvceHdrNmbr + ''||Status:'' + SalesInvoiceHeader. SlsInvceHdrStts + ''||Reason:Invoice is Fed but has no Fed Date.''		
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '
				
				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail					(NoLock)
				Inner Join	SalesInvoiceHeader	(NoLock)	On	AccountDetail. AcctDtlSlsInvceHdrID		= SalesInvoiceHeader. SlsInvceHdrID
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		SalesInvoiceHeader. SlsInvceHdrStts		= ''S''
		And		SalesInvoiceHeader.	SlsInvceHdrFdDte	Is Null
		And		SalesInvoiceHeader. SlsInvceHdrTtlVle	<> 0.0
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
		
		----------------------------------------------------------------------------------------------------------------------
		-- Do We Need a Step Checking Posted Dates?
		----------------------------------------------------------------------------------------------------------------------				
			
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail with records that are on Active or Held Purchase Invoices - Step 1
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				
				,AccountDetail.	AcctDtlPrchseInvceHdrID	
				,PayableHeader. InvoiceNumber																																		 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand															
				,AccountDetail. Value																					
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume																	 
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																						
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AP''	
				,' + convert(varchar,@i_ID) + '
				,''PybleHdrID:'' + convert(varchar,PayableHeader. PybleHdrID) + ''||SupplierInvoiceNumber:'' + PayableHeader. InvoiceNumber + ''||Status:'' + PayableHeader. Status + ''||Reason:Invoice is on Hold.''										
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '
				
				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail							(NoLock)
				Inner Join	PayableHeader				(NoLock)	On	AccountDetail. AcctDtlPrchseInvceHdrID		= PayableHeader. PybleHdrID				
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'',''T'')

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		PayableHeader. Status			= ''H''
		And		PayableHeader. InvoiceAmount	<> 0.0
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		
		
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail with records that are on Fed Purchase Invoices but Have Not Fed - Step 2
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID				
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals

				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID		
				,''N''											
				,AccountDetail. Reversed															
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus												
				,''GL'' 																				
				,AccountDetail.	AcctDtlPrchseInvceHdrID													
				,PayableHeader. InvoiceNumber																						 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID														
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
				,AccountDetail. AcctDtlTrnsctnTypID													
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand															
				,AccountDetail. Value																				
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume																
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																			
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AP''	
				,' + convert(varchar,@i_ID) + '	
				,''PybleHdrID:'' + convert(varchar,PayableHeader. PybleHdrID) + ''||SupplierInvoiceNumber:'' + PayableHeader. InvoiceNumber + ''||Status:'' + PayableHeader. Status + ''||Reason:Invoice is Fed but has no Fed Date.''
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '

				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail							(NoLock)
				Inner Join	PayableHeader				(NoLock)	On	AccountDetail. AcctDtlPrchseInvceHdrID		= PayableHeader. PybleHdrID				
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'',''T'')	

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)																
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		PayableHeader. Status			= ''F''
		And		PayableHeader. FedDate			Is Null
		And		PayableHeader. InvoiceAmount	<> 0.0
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')		
		'
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		----------------------------------------------------------------------------------------------------------------------
		-- Do We Need a Step Checking Posted Dates?
		----------------------------------------------------------------------------------------------------------------------						

		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for Physical Forward records
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID				
				,GLType
				,PostingType
				,BatchID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																			
				,AccountDetail. AcctDtlSrceID																
				,AccountDetail. AcctDtlSrceTble 															
				,AccountDetail. AcctDtlAccntngPrdID
				,''N''															
				,AccountDetail. Reversed																	
				,AccountDetail. AcctDtlPrntID																
				,AccountDetail. PayableMatchingStatus														
				,''GL'' 																					 																						 	
				,AccountDetail. InternalBAID																
				,AccountDetail. ExternalBAID																	
				,AccountDetail. ParentPrdctID																
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
				,AccountDetail. AcctDtlTrnsctnTypID																
				,AccountDetail. WePayTheyPay	
				,AccountDetail. SupplyDemand															
				,AccountDetail. Value
				,AccountDetail. CrrncyID																	
				,AccountDetail. Volume
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																				
				,AccountDetail. AcctDtlTrnsctnDte															
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''PF''	
				,' + convert(varchar,@i_ID) + '	
				,convert(varchar(max),ManualLedgerEntry. Comment)
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '

				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail						(NoLock)
				Inner Join	ManualLedgerEntryLog	(NoLock)	On	AccountDetail. AcctDtlSrceID			= ManualLedgerEntryLog. MnlLdgrEntryLgID
																And	AccountDetail. AcctDtlSrceTble			= ''ML''
				Inner Join	ManualLedgerEntry		(NoLock)	On	ManualLedgerEntryLog. MnlLdgrEntryID	= ManualLedgerEntry. MnlLdgrEntryID 		
				Inner Join	TransactionType			(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID		= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID				= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID			Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID				Is Null	
		And		AccountDetail. AcctDtlTrnsctnTypID				In ('+@vc_UnrealizedString+')
		And		AccountDetail. Value 							<> 0.0
		And		AccountDetail. Reversed							= ''N''

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)							
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End +	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')				
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		----------------------------------------------------------------------------------------------------------------------
		-- Strip out the Risk ID from the ML Comments 
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		RiskID	=	Case	
								When	IsNumeric(RTrim(LTrim(Replace(Substring(Comments, 0, CharIndex(''|'', Comments)),''RiskID: '',''''))))	= 1 Then	convert(int,RTrim(LTrim(Replace(Substring(Comments, 0, CharIndex(''|'', Comments)),''RiskID: '',''''))))
								Else	NULL
							End
		From	tmp_CustomAccountDetail					(NoLock)
		Where	tmp_CustomAccountDetail. PostingType	= ''PF''
		And		tmp_CustomAccountDetail. Comments		Like ''Risk%''
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for Inventory Change records
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID				
				,GLType
				,PostingType
				,BatchID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID
				,AccountDetail. AcctDtlSrceID														
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID														
				,AccountDetail. PayableMatchingStatus												
				,''GL'' 																																									 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay	
				,AccountDetail. SupplyDemand														
				,AccountDetail. Value
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																						
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''IV''		
				,' + convert(varchar,@i_ID) + '
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '

				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail				(NoLock)															
				Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null	
		And		AccountDetail. AcctDtlSrceTble			= ''IV''
		-- And		AccountDetail. Reversed					= ''N''  -- we need both originals & reversals to get change in inventory

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'					
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)		
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End +  Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for ML records
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID				
				,GLType
				,PostingType
				,BatchID
				,P_EODEstmtedAccntDtlID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				
				,InvoiceUOMID
				,TrnsctnTypDesc
				)
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID		
				,''N''												
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				 																						 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay	
				,AccountDetail. SupplyDemand														
				,AccountDetail. Value
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																				
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID				
				,''' + @c_GLType + '''
				,''AM''	
				,' + convert(varchar,@i_ID) + '	
				,ManualLedgerEntry. P_EODEstmtedAccntDtlID
				,convert(varchar(max),ManualLedgerEntry. Comment)	
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '
				
				,AccountDetail. AcctDtlUOMID
				,TransactionType. TrnsctnTypDesc
		From	AccountDetail						(NoLock)
				Inner Join	ManualLedgerEntryLog	(NoLock)	On	AccountDetail. AcctDtlSrceID			= ManualLedgerEntryLog. MnlLdgrEntryLgID
																And	AccountDetail. AcctDtlSrceTble			= ''ML''
				Inner Join	ManualLedgerEntry		(NoLock)	On	ManualLedgerEntryLog. MnlLdgrEntryID	= ManualLedgerEntry. MnlLdgrEntryID 
				Inner Join	TransactionType			(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID		= TransactionType. TrnsctnTypID 																
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID				= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID			Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID				Is Null	
		And		AccountDetail. AcctDtlTrnsctnTypID				Not In ('+@vc_UnrealizedString+')
		And		ManualLedgerEntry. DerivativeAccountingEntry	= 0
		And		AccountDetail. Value 							<> 0.0
		-- And		AccountDetail. Reversed							= ''N''

		And		(
				AccountDetail. AcctDtlAccntngPrdID		= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		or		not exists	(
							Select	1
							From	TransactionTypeGroup (NoLock)
									Inner Join TransactionGroup (NoLock)
										on	TransactionGroup.XGrpID						= TransactionTypeGroup.XTpeGrpXGrpID
							Where	TransactionGroup.XGrpName		= ''GL Do Not Reverse''
							And		TransactionTypeGroup.XTpeGrpTrnsctnTypID	= TransactionType.TrnsctnTypID
							)
				) -- current month only OR it is not "GL DO NOT REVERSE".  This way, the Do Not Reverse stuff is only sent once
		'		+	
				Case
					When	@i_AcctDtlID	Is Not Null	Then	'
		And		AccountDetail. AcctDtlID				= ' + convert(varchar,@i_AcctDtlID)	+ '
		'							
					Else	'		
		'		End	+	'		
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)				
		' + Case When @i_MonthlyGL_XGrpID is not null then '	
		And		Not Exists	(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')		-- Include Transactions Filter	
								' else '' end + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + 
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomAccountDetail	(NoLock)
								Where	CustomAccountDetail. AcctDtlID			= AccountDetail. AcctDtlID 
								And		CustomAccountDetail. BatchID			= '+ convert(varchar,IsNull(@i_ID,0)) + '
								And		CustomAccountDetail. InterfaceSource	= ''GL'')			
		'
			End
								
		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
		
	End
	
----------------------------------------------------------------------------------------------------------------------
-- Collect the Nightly GL Data
----------------------------------------------------------------------------------------------------------------------
If	@c_GLType	In ('N')  And @b_GLReprocess = 0
	Begin
	
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for any recors in the Feed in Nightly GL Group
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals)
		Select	 AccountDetail. AcctDtlID																
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID	
				,''N''													
				,AccountDetail. Reversed																
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																				
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID															
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)						
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand															
				,Case When AcctDtlTrnsctnTypID Not In (' + @vc_KeepSignString + ') Then Case When WePayTheyPay = ''R'' Then -1 Else 1 End * AccountDetail. Value Else AccountDetail. Value End
				,AccountDetail. CrrncyID																
				,Case When AcctDtlTrnsctnTypID Not In (' + @vc_KeepSignString + ') Then Case When SupplyDemand = ''D'' Then -1 Else 1 End * AccountDetail. Volume Else AccountDetail. Volume End
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																				
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID
				,''' + @c_GLType + '''
				,''RA''
				,' + convert(varchar,@i_ID) + '
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '						
		From	AccountDetail				(NoLock)															
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null		
		And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')	
		And		AccountDetail. AcctDtlTrnsctnTypID		<> ' + convert(varchar,IsNull(@i_Swap_TrnsctnTypID,-1)) + '	
		And		AccountDetail. Value 					<> 0.0								
		And		Exists		(	Select	''X''
								From	TransactionTypeGroup	(NoLock)
								Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
								And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_NightlyGL_XGrpID,0)) + ')	-- Include Transactions that are Fed in the Nightly GL Run
		' + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + 
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomGLInterface	(NoLock)
								Where	CustomGLInterface. AcctDtlID	= AccountDetail. AcctDtlID 
								And		CustomGLInterface. GLType		= ''N'')			
		'
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
					
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail for any exchange traded swaps
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals)
		Select	 AccountDetail. AcctDtlID																		
				,AccountDetail. AcctDtlSrceID															
				,AccountDetail. AcctDtlSrceTble 														
				,AccountDetail. AcctDtlAccntngPrdID		
				,''N''											
				,AccountDetail. Reversed															
				,AccountDetail. AcctDtlPrntID															
				,AccountDetail. PayableMatchingStatus													
				,''GL'' 																																								 	
				,AccountDetail. InternalBAID															
				,AccountDetail. ExternalBAID															
				,AccountDetail. ParentPrdctID																
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)					
				,AccountDetail. AcctDtlTrnsctnTypID														
				,AccountDetail. WePayTheyPay
				,AccountDetail. SupplyDemand																
				,AccountDetail. Value																					
				,AccountDetail. CrrncyID																
				,AccountDetail. Volume																	
				,' + convert(varchar,IsNull(@i_DefaultUOMID,0)) + '																						
				,''' + convert(varchar,IsNull(@i_DefaultUOM,'NA')) + '''
				,''' + IsNull(@i_DefaultUOM,'NA') + '''																						
				,AccountDetail. AcctDtlTrnsctnDte														
				,AccountDetail. AcctDtlMvtHdrID	
				,AccountDetail. AcctDtlPlnndTrnsfrID
				,AccountDetail. AcctDtlDlDtlDlHdrID
				,AccountDetail. AcctDtlDlDtlID
				,AccountDetail. AcctDtlStrtgyID
				,''' + @c_GLType + '''
				,''SW''
				,' + convert(varchar,@i_ID) + '
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '						
		From	AccountDetail				(NoLock)															
		Where	1 = 1
		And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
		And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
		And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null	
		And		AccountDetail. AcctDtlSrceTble			= ''TT''	
		And		AccountDetail. AcctDtlTrnsctnTypID		= ' + convert(varchar,IsNull(@i_Swap_TrnsctnTypID,-1)) + '
		And		AccountDetail. Value 					<> 0.0		
		And		Exists	(	Select	''X''
							From	GeneralConfiguration	(NoLock)
							Where	GeneralConfiguration. GnrlCnfgTblNme				= ''DealHeader''
							And		GeneralConfiguration. GnrlCnfgQlfr					= ''ExchangeTraded''
							And		AccountDetail. AcctDtlDlDtlDlHdrID					= GeneralConfiguration. GnrlCnfgHdrID	
							And		GeneralConfiguration. GnrlCnfgHdrID					<> 0
							And		IsNull(GeneralConfiguration. GnrlCnfgMulti,'''')	Not In (''None'',''''))	
		' + Case When @i_CustomGLExclusionCount <> 0 Then '
		And		Not Exists	(	Select	''X''
								From	CustomGLExclusion	(NoLock)
								Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
		' else '' End + '
		And		Not Exists	(	Select	''X''
								From	tmp_CustomAccountDetail	(NoLock)
								Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)																								
		'	+	
			Case	
				When	@c_OnlyShowSQL = 'Y' Then	'
		'
				Else	'
		And		Not Exists	(	Select	''X''
								From	CustomGLInterface	(NoLock)
								Where	CustomGLInterface. AcctDtlID	= AccountDetail. AcctDtlID 
								And		CustomGLInterface. GLType		= ''N'')			
		'	
			End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
		----------------------------------------------------------------------------------------------------------------------
		-- Set the PostingType value
		----------------------------------------------------------------------------------------------------------------------					
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		PostingType	=	Case
									When	TransactionGroup. XGrpName = ''Nightly GL - Futures''			Then ''FT''
									When	TransactionGroup. XGrpName = ''Nightly GL - Inhouse''			Then ''IH''
									When	TransactionGroup. XGrpName = ''Nightly GL - Swaps''				Then ''SW''
									Else	''RA''
								End
		From	tmp_CustomAccountDetail				(NoLock)
				Inner Join	TransactionTypeGroup	(NoLock)	On	tmp_CustomAccountDetail. TrnsctnTypID	= TransactionTypeGroup. XTpeGrpTrnsctnTypID										
				Inner Join	TransactionGroup		(NoLock)	On	TransactionTypeGroup. XTpeGrpXGrpID	= TransactionGroup. XGrpID
																And	TransactionGroup. XGrpQlfr			= ''GL Posting Type''					
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
		
		----------------------------------------------------------------------------------------------------------------------
		-- Correct the Sign on Futures and Inhouses - We Pays Need to be + and They Pays need to be -
		----------------------------------------------------------------------------------------------------------------------		
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		NetValue	= AccountDetail. Value	* -1	
				,Quantity	= AccountDetail. Volume * -1
		From	tmp_CustomAccountDetail		(NoLock)
				Inner Join	AccountDetail	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID 					
		Where	PostingType	In (''FT'',''IH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
				
			
	End

----------------------------------------------------------------------------------------------------------------------
-- If we are reprocessing just reload the information from CustomAccountDetail - account detail properties can't change
----------------------------------------------------------------------------------------------------------------------	
If	@b_GLReprocess = 1
	Begin	
	
		----------------------------------------------------------------------------------------------------------------------
		-- Load tmp_CustomAccountDetail
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,RiskID
				,P_EODEstmtedAccntDtlID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				,InvoiceUOMID
				,TrnsctnTypDesc
				)	
		Select	Distinct AcctDtlID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,AcctDtlPrntID
				,PayableMatchingStatus				
				,InterfaceSource
				,RAInvoiceID
				,InvoiceNumber
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,SupplyDemand
				,NetValue
				,CrrncyID
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate	
				,MvtHdrID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,StrtgyID
				,GLType
				,PostingType
				,BatchID
				,RiskID
				,P_EODEstmtedAccntDtlID
				,Comments
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals
				,InvoiceUOMID
				,TrnsctnTypDesc
		From	CustomAccountDetail	(NoLock)
		Where	BatchID		= ' + convert(varchar,@i_ID) + '
		And		GLType		= ''' + @c_GLType + '''
		And		AcctDtlID	= ' + convert(varchar,@i_AcctDtlID) + '
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
			
	End												

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
If OBJECT_ID('dbo.Custom_Interface_GL_AD_Load') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_GL_AD_Load >>>'
	Grant Execute on dbo.Custom_Interface_GL_AD_Load to SYSUSER
	Grant Execute on dbo.Custom_Interface_GL_AD_Load to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_GL_AD_Load >>>'
GO

 