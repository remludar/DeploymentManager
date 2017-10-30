If OBJECT_ID('dbo.Custom_Closing_GL_Report') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Closing_GL_Report
    PRINT '<<< DROPPED PROC dbo.Custom_Closing_GL_Report >>>'
End
Go  

Create Procedure dbo.Custom_Closing_GL_Report	 @vc_InternalBAID		varchar(8000)	= NULL
												,@vc_ExternalBAID		varchar(8000)	= NULL
												,@vc_StrtgyID			varchar(8000)	= NULL
												,@vc_TransactionType	varchar(8000)	= NULL
												,@vc_AccountingPeriodID varchar(8000)	= NULL
												,@dt_FromDate			DateTime		= NULL
												,@dt_ToDate				DateTime		= NULL
												,@vc_DealNumber			varchar(20)		= NULL
												,@i_AccountDetailID		int				= NULL
												,@c_OnlyShowSQL			char(1)			= 'N' 
As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		Custom_Closing_GL_Report @c_OnlyShowSQL = 'Y'	Copyright 2003 SolArc
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
		,@i_AccntngPrdID			int
		,@c_GLType					char(2)
		,@i_ID						int

Select	@c_GLType	= 'M'
		,@i_ID		= 0
		
----------------------------------------------------------------------------------------------------------------------
-- Set the Transaction Type Values that we will need
----------------------------------------------------------------------------------------------------------------------
Select	@i_Inv_Val_TrnsctnTypID	= TrnsctnTypID 
From	TransactionType	(NoLock)
Where	TrnsctnTypDesc	= 'Inventory Valuation'	

Select	@i_Swap_TrnsctnTypID	= TrnsctnTypID 
From	TransactionType	(NoLock)
Where	TrnsctnTypDesc	= 'Financial Swaps'	

Select	@i_VAT_XGrpID	= XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Tax'	

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

Select	@i_DefaultUOMID				= InterfaceDefaultUOMID
		,@i_DefaultUOM				= InterfaceDefaultUOM
		,@i_DefaultPerUnitDecimals	= InterfaceDefaultPerUnitDecimals
		,@i_DefaultQtyDecimals		= InterfaceDefaultQtyDecimals		
From	CustomConfigAccounting	(NoLock)
Where	ConfigurationName	= 'Default'

----------------------------------------------------------------------------------------------------------------------
-- Set the current open accounting period
----------------------------------------------------------------------------------------------------------------------	
Select	@i_AccntngPrdID	= Min(AccntngPrdID)
From	AccountingPeriod	(NoLock)
Where	AccntngPrdCmplte	= 'N'

----------------------------------------------------------------------------------------------------------------------
-- Set the Accounting Period values that we will need
----------------------------------------------------------------------------------------------------------------------
Select	@sdt_AccntngPrdEndDte	= AccntngPrdEndDte
From	AccountingPeriod	(NoLock)
Where	AccountingPeriod. AccntngPrdID	= IsNull(@i_AccntngPrdID, 720)

----------------------------------------------------------------------------------------------------------------------
-- Create tmp_CustomAccountDetail for debugging only
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'Y'
	 Begin
		Select	'
		Truncate Table	tmp_CustomAccountDetail
				'	
	End
Else
	Begin
		Truncate Table	tmp_CustomAccountDetail
	End
----------------------------------------------------------------------------------------------------------------------
-- Create #RealizedReversals
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'Y'
	Begin
		Select	'
		Create Table	#RealizedReversals
						(AcctDtlID					int		Null
						,AcctDtlAccntngPrdID		int		Null
						,AcctDtlSrceTble			char(2)	Null 
						,AcctDtlPrntID				int		Null
						,AcctDtlPrntAccntngPrdID	int		Null
						,AcctDtlPrntInvoice			int		Null)	
'
	End
Else
	Begin
		Create Table	#RealizedReversals
						(AcctDtlID					int	Null
						,AcctDtlAccntngPrdID		int	Null
						,AcctDtlSrceTble			char(2)	Null 
						,AcctDtlPrntID				int	Null
						,AcctDtlPrntAccntngPrdID	int	Null
						,AcctDtlPrntInvoice			int	Null)	
	End	
		
----------------------------------------------------------------------------------------------------------------------
-- Create #SumTo0Reversals
----------------------------------------------------------------------------------------------------------------------
If	@c_OnlyShowSQL = 'Y'
	Begin
		Select	'		
		Create Table	#SumTo0Reversals
						(ID								int				Identity
						,AcctDtlSrceTble				char(2)			Null  										
						,InternalBAID					int				Null			
						,ExternalBAID					int				Null			
						,ParentPrdctID					int				Null				
						,ChildPrdctID					int				Null		
						,TrnsctnTypID					int				Null			
						,WePayTheyPay					char(1)			Null				
						,NetValue						decimal(19,6)	Not Null	Default 0.0							
						,CrrncyID						int				Null		
						,MvtHdrID						int				Null		
						,PlnndTrnsfrID					int				Null  			
						,DlHdrID						int				Null		
						,DlDtlID						smallint		Null
						,DlDtlPrvsnID					int				Null
						,DlDtlPrvsnRwID					int				Null
						,StrtgyID						int				Null)			
'
	End
Else
	Begin
		Create Table	#SumTo0Reversals
						(ID								int				Identity
						,AcctDtlSrceTble				char(2)			Null  										
						,InternalBAID					int				Null			
						,ExternalBAID					int				Null			
						,ParentPrdctID					int				Null				
						,ChildPrdctID					int				Null		
						,TrnsctnTypID					int				Null			
						,WePayTheyPay					char(1)			Null				
						,NetValue						decimal(19,6)	Not Null	Default 0.0							
						,CrrncyID						int				Null		
						,MvtHdrID						int				Null		
						,PlnndTrnsfrID					int				Null  			
						,DlHdrID						int				Null		
						,DlDtlID						smallint		Null
						,DlDtlPrvsnID					int				Null
						,DlDtlPrvsnRwID					int				Null
						,StrtgyID						int				Null)	
	End

----------------------------------------------------------------------------------------------------------------------
-- Collect the Monthly GL Data
----------------------------------------------------------------------------------------------------------------------
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
		,Case
			When	AccountDetail. AcctDtlTrnsctnTypID	= ' + convert(varchar,IsNull(@i_Swap_TrnsctnTypID,-1)) + '	Then	AccountDetail. Value 
			Else	Case 
						When	WePayTheyPay	= ''R''	Then	-1 * AccountDetail. Value
						Else	AccountDetail. Value	
					End	 
		 End																					
		,AccountDetail. CrrncyID																
		,Case 
			When	AccountDetail. AcctDtlTrnsctnTypID	= ' + convert(varchar,IsNull(@i_Swap_TrnsctnTypID,-1)) + '	Then	AccountDetail. Volume 
			Else	Case 
						When	SupplyDemand	= ''D''	Then	-1 * AccountDetail. Volume	
						Else	AccountDetail. Volume	
					End 
		 End																					
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
From	AccountDetail				(NoLock)
		Inner Join	TransactionType	(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID	= TransactionType. TrnsctnTypID 																
Where	1 = 1 
And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null		
And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null	
And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')
And		TransactionType. TrnsctnTypMvt			<> ''I''																				-- Exclude Accrual Transaction Types
And		AccountDetail. Value 					<> 0.0
And		Not Exists	(	Select	''X''
						From	TransactionTypeGroup	(NoLock)
						Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
						And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')	-- Exclude Transactions Filter	
And		Not Exists	(	Select	''X''
						From	CustomGLExclusion	(NoLock)
						Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																
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
-- Reversal Removal - Pass 1 - traditional reverse/rebooks in the same period
----------------------------------------------------------------------------------------------------------------------		
----------------------------------------------------------------------------------------------------------------------
-- Load #RealizedReversals with ADs that are reversals
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '		
Insert	#RealizedReversals
		(AcctDtlID
		,AcctDtlAccntngPrdID
		,AcctDtlSrceTble
		,AcctDtlPrntID)
Select	 AcctDtlID
		,AccntngPrdID
		,AcctDtlSrceTble
		,AcctDtlPrntID
From	tmp_CustomAccountDetail	(NoLock)		
Where	AcctDtlID	<> AcctDtlPrntID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Remove any records whose parent AD doesn't exist in the result set
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Delete	#RealizedReversals
Where	Not Exists	(	Select	''X''
						From	tmp_CustomAccountDetail	(NoLock)
						Where	#RealizedReversals. AcctDtlPrntID	= tmp_CustomAccountDetail. AcctDtlID
						And		#RealizedReversals. AcctDtlSrceTble	= tmp_CustomAccountDetail. AcctDtlSrceTble)
'								
				
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)						 
				
----------------------------------------------------------------------------------------------------------------------
-- Set the Accounting Period and Invoice status of the parent
----------------------------------------------------------------------------------------------------------------------						
Select	@vc_DynamicSQL	= '
Update	#RealizedReversals
Set		 AcctDtlPrntAccntngPrdID	= AccountDetail. AcctDtlAccntngPrdID
		,AcctDtlPrntInvoice			= Case
										When	AccountDetail. AcctDtlSlsInvceHdrID Is Not Null Or AccountDetail. AcctDtlPrchseInvceHdrID Is Not Null Then 1
										Else	0
									  End	
From	#RealizedReversals			(NoLock)
		Inner Join	AccountDetail	(NoLock)	On	#RealizedReversals. AcctDtlPrntID	= AccountDetail. AcctDtlID 
												And	#RealizedReversals. AcctDtlSrceTble	= AccountDetail. AcctDtlSrceTble
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		 	

----------------------------------------------------------------------------------------------------------------------
-- Remove any records that have a mismatch in accounting period
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Delete	#RealizedReversals	
Where	AcctDtlAccntngPrdID	<> AcctDtlPrntAccntngPrdID
'

-- If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL) //JPW - Leave this commented out for now  

----------------------------------------------------------------------------------------------------------------------
-- Remove any records where a parent is on an invoice
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '		
Delete	#RealizedReversals
Where	AcctDtlPrntInvoice	= 1
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Delete the revresal records tmp_CustomAccountDetail
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '		
Delete	tmp_CustomAccountDetail
From	#RealizedReversals	(NoLock)
		Inner Join	tmp_CustomAccountDetail	On	#RealizedReversals. AcctDtlID	= tmp_CustomAccountDetail. AcctDtlID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		

----------------------------------------------------------------------------------------------------------------------
-- Delete the parent records from tmp_CustomAccountDetail
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '		
Delete	tmp_CustomAccountDetail 
From	#RealizedReversals
		Inner Join	tmp_CustomAccountDetail	On	#RealizedReversals. AcctDtlPrntID	= tmp_CustomAccountDetail. AcctDtlID				
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Clear Out #RealizedReversals	
----------------------------------------------------------------------------------------------------------------------						
Select	@vc_DynamicSQL	= '	
Delete	#RealizedReversals	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
	
----------------------------------------------------------------------------------------------------------------------
-- Reversal Removal - Pass 2 - remove any futher lines which net to 0
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Load up the lines that net to 0 when aggregated
----------------------------------------------------------------------------------------------------------------------		
Select	@vc_DynamicSQL	= '										
		Insert	#SumTo0Reversals
				(AcctDtlSrceTble
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID
				,TrnsctnTypID
				,WePayTheyPay
				,NetValue
				,CrrncyID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,DlDtlPrvsnID
				,DlDtlPrvsnRwID
				,StrtgyID)
		Select	AcctDtlSrceTble
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID
				,TrnsctnTypID
				,WePayTheyPay
				,Sum(NetValue)
				,CrrncyID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID
				,DlDtlPrvsnID
				,DlDtlPrvsnRwID	
				,StrtgyID					
		From	tmp_CustomAccountDetail	(NoLock)
		Where	DlDtlPrvsnID	Is Not Null
		Group By AcctDtlSrceTble
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID
				,TrnsctnTypID
				,WePayTheyPay
				,CrrncyID
				,PlnndTrnsfrID
				,DlHdrID
				,DlDtlID 
				,DlDtlPrvsnID
				,DlDtlPrvsnRwID	
				,StrtgyID	Having Round(Sum(NetValue),2) = 0			
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)			

----------------------------------------------------------------------------------------------------------------------
-- Remove any of the net 0 lines from tmp_CustomAccountDetail
----------------------------------------------------------------------------------------------------------------------			
Select	@vc_DynamicSQL	= '					
		Delete	tmp_CustomAccountDetail
		From	tmp_CustomAccountDetail			(NoLock)
				Inner Join	#SumTo0Reversals	(NoLock)	On	IsNull(tmp_CustomAccountDetail. AcctDtlSrceTble,'''')	= IsNull(#SumTo0Reversals. AcctDtlSrceTble,'''')
															And	IsNull(tmp_CustomAccountDetail. InternalBAID,0)		= IsNull(#SumTo0Reversals. InternalBAID,0)
															And	IsNull(tmp_CustomAccountDetail. ExternalBAID,0)		= IsNull(#SumTo0Reversals. ExternalBAID,0)	
															And IsNull(tmp_CustomAccountDetail. ParentPrdctID,0)		= IsNull(#SumTo0Reversals. ParentPrdctID,0)
															And IsNull(tmp_CustomAccountDetail. ChildPrdctID,0)		= IsNull(#SumTo0Reversals. ChildPrdctID,0)	
															And IsNull(tmp_CustomAccountDetail. TrnsctnTypID,0)		= IsNull(#SumTo0Reversals. TrnsctnTypID,0)
															And IsNull(tmp_CustomAccountDetail. WePayTheyPay,'''')		= IsNull(#SumTo0Reversals. WePayTheyPay,'''')
															And	IsNull(tmp_CustomAccountDetail. CrrncyID,0)			= IsNull(#SumTo0Reversals. CrrncyID,0)	
															And IsNull(tmp_CustomAccountDetail. PlnndTrnsfrID,0)		= IsNull(#SumTo0Reversals. PlnndTrnsfrID,0)	
															And IsNull(tmp_CustomAccountDetail. DlHdrID,0)				= IsNull(#SumTo0Reversals. DlHdrID,0)
															And IsNull(tmp_CustomAccountDetail. DlDtlID,	0)			= IsNull(#SumTo0Reversals. DlDtlID,0)																		
															And IsNull(tmp_CustomAccountDetail. DlDtlPrvsnID,0)		= IsNull(#SumTo0Reversals. DlDtlPrvsnID,0)
															And IsNull(tmp_CustomAccountDetail. DlDtlPrvsnRwID,0)		= IsNull(#SumTo0Reversals. DlDtlPrvsnRwID,0)
															And IsNull(tmp_CustomAccountDetail. StrtgyID,0)			= IsNull(#SumTo0Reversals. StrtgyID,0)
																
																					
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- NULL out the DLDTLPRVSNID column
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '		
Update	tmp_CustomAccountDetail
Set		DlDtlPrvsnID		= NULL
		,DlDtlPrvsnRwID		= NULL		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)																			

----------------------------------------------------------------------------------------------------------------------
-- Remove any Discards
----------------------------------------------------------------------------------------------------------------------			
Select	@vc_DynamicSQL	= '		
Delete	tmp_CustomAccountDetail 
Where	PayableMatchingStatus	= ''D''			
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
		,-1 * AccountDetail. Volume																
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
From	AccountDetail					(NoLock)
		Inner Join	SalesInvoiceHeader	(NoLock)	On	AccountDetail. AcctDtlSlsInvceHdrID		= SalesInvoiceHeader. SlsInvceHdrID
Where	1 = 1
And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null
And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')
And		Not Exists	(	Select	''X''
						From	tmp_CustomAccountDetail	(NoLock)
						Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
And		Not Exists	(	Select	''X''
						From	TransactionTypeGroup	(NoLock)
						Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
						And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')	
And		Not Exists	(	Select	''X''
						From	CustomGLExclusion	(NoLock)
						Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																		
And		SalesInvoiceHeader. SlsInvceHdrStts		In (''A'', ''H'')
And		SalesInvoiceHeader. SlsInvceHdrTtlVle	<> 0.0
'
						
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
		,-1 * AccountDetail. Volume															
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
From	AccountDetail					(NoLock)
		Inner Join	SalesInvoiceHeader	(NoLock)	On	AccountDetail. AcctDtlSlsInvceHdrID		= SalesInvoiceHeader. SlsInvceHdrID
Where	1 = 1
And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
And		AccountDetail. AcctDtlPrchseInvceHdrID	Is Null
And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'', ''T'')	
And		Not Exists	(	Select	''X''
						From	tmp_CustomAccountDetail	(NoLock)
						Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
And		Not Exists	(	Select	''X''
						From	TransactionTypeGroup	(NoLock)
						Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
						And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')	
And		Not Exists	(	Select	''X''
						From	CustomGLExclusion	(NoLock)
						Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																			
And		SalesInvoiceHeader. SlsInvceHdrStts		= ''S''
And		SalesInvoiceHeader.	SlsInvceHdrFdDte	Is Null
And		SalesInvoiceHeader. SlsInvceHdrTtlVle	<> 0.0
'
						
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
		,AccountDetail.	AcctDtlPrchseInvceHdrID	
		,PayableHeader. InvoiceNumber																																		 	
		,AccountDetail. InternalBAID															
		,AccountDetail. ExternalBAID															
		,AccountDetail. ParentPrdctID															
		,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
		,AccountDetail. AcctDtlTrnsctnTypID														
		,AccountDetail. WePayTheyPay
		,AccountDetail. SupplyDemand															
		,-1 * AccountDetail. Value																					
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
From	AccountDetail							(NoLock)
		Inner Join	PayableHeader				(NoLock)	On	AccountDetail. AcctDtlPrchseInvceHdrID		= PayableHeader. PybleHdrID				
Where	1 = 1
And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null
And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'',''T'')	
And		Not Exists	(	Select	''X''
						From	tmp_CustomAccountDetail	(NoLock)
						Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)														
And		Not Exists		(	Select	''X''
						From	TransactionTypeGroup	(NoLock)
						Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
						And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')	
And		Not Exists	(	Select	''X''
						From	CustomGLExclusion	(NoLock)
						Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																			
And		PayableHeader. Status			= ''H''
And		PayableHeader. InvoiceAmount	<> 0.0
'

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
		,AccountDetail.	AcctDtlPrchseInvceHdrID													
		,PayableHeader. InvoiceNumber																						 	
		,AccountDetail. InternalBAID															
		,AccountDetail. ExternalBAID															
		,AccountDetail. ParentPrdctID														
		,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)							
		,AccountDetail. AcctDtlTrnsctnTypID													
		,AccountDetail. WePayTheyPay
		,AccountDetail. SupplyDemand															
		,-1 * AccountDetail. Value																				
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
From	AccountDetail							(NoLock)
		Inner Join	PayableHeader				(NoLock)	On	AccountDetail. AcctDtlPrchseInvceHdrID		= PayableHeader. PybleHdrID				
Where	1 = 1
And		AccountDetail. AcctDtlAccntngPrdID		<= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
And		AccountDetail. AcctDtlSlsInvceHdrID		Is Null
And		AccountDetail. AcctDtlSrceTble			In (''X'', ''TT'', ''M'',''T'')			
And		Not Exists	(	Select	''X''
						From	tmp_CustomAccountDetail	(NoLock)
						Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)																
And		Not Exists	(	Select	''X''
						From	TransactionTypeGroup	(NoLock)
						Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
						And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')	
And		Not Exists	(	Select	''X''
						From	CustomGLExclusion	(NoLock)
						Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																		
And		PayableHeader. Status			= ''F''
And		PayableHeader. FedDate			Is Null
And		PayableHeader. InvoiceAmount	<> 0.0
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Do We Need a Step Checking Posted Dates?
----------------------------------------------------------------------------------------------------------------------			
				
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
		,Case When AccountDetail. WePayTheyPay = ''R'' Then -1 Else 1 End * AccountDetail. Value						
		,AccountDetail. CrrncyID																
		,Case When AccountDetail. SupplyDemand = ''D'' Then -1 Else 1 End * AccountDetail. Volume	
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
From	AccountDetail						(NoLock)
		Inner Join	ManualLedgerEntryLog	(NoLock)	On	AccountDetail. AcctDtlSrceID			= ManualLedgerEntryLog. MnlLdgrEntryLgID
														And	AccountDetail. AcctDtlSrceTble			= ''ML''
		Inner Join	ManualLedgerEntry		(NoLock)	On	ManualLedgerEntryLog. MnlLdgrEntryID	= ManualLedgerEntry. MnlLdgrEntryID 
		Inner Join	TransactionType			(NoLock)	On	AccountDetail. AcctDtlTrnsctnTypID		= TransactionType. TrnsctnTypID 																
Where	1 = 1
And		AccountDetail. AcctDtlAccntngPrdID				= ' + convert(varchar,IsNull(@i_AccntngPrdID,0)) + '
And		AccountDetail. AcctDtlPrchseInvceHdrID			Is Null		
And		AccountDetail. AcctDtlSlsInvceHdrID				Is Null	
And		AccountDetail. AcctDtlTrnsctnTypID				Not In (2008,2027,2028,2029,2030)
And		ManualLedgerEntry. DerivativeAccountingEntry	= 0
And		AccountDetail. Value 							<> 0.0
And		AccountDetail. Reversed							= ''N''	
And		Not Exists	(	Select	''X''
						From	tmp_CustomAccountDetail	(NoLock)
						Where	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID)					 								 									
And		Not Exists	(	Select	''X''
						From	TransactionTypeGroup	(NoLock)
						Where	TransactionTypeGroup. XTpeGrpTrnsctnTypID	= AccountDetail. AcctDtlTrnsctnTypID
						And		TransactionTypeGroup. XTpeGrpXGrpID			= ' + convert(varchar,IsNull(@i_MonthlyGL_XGrpID,0)) + ')	
And		Not Exists	(	Select	''X''
						From	CustomGLExclusion	(NoLock)
						Where	CustomGLExclusion. AcctDtlID	= AccountDetail. AcctDtlID)																	
'
						
If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
							

----------------------------------------------------------------------------------------------------------------------
-- Additional Data Points
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- Determine the Transaction Type
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		TrnsctnTypDesc	= TransactionType. TrnsctnTypDesc
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	TransactionType	(NoLock)	On	tmp_CustomAccountDetail. TrnsctnTypID	= TransactionType. TrnsctnTypID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the Locale ID
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		LcleID		= AccountDetail. AcctDtlLcleID
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	AccountDetail	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID	= AccountDetail. AcctDtlID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the DlHdrIntrnlNbr
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		DlHdrIntrnlNbr	= DealHeader. DlHdrIntrnlNbr
From	tmp_CustomAccountDetail	(NoLock)
		Inner Join	DealHeader	(NoLock)	On	tmp_CustomAccountDetail. DlHdrID	= DealHeader. DlHdrID														
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the INCOTerm
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		INCOTerm	= DynamicListBox. DynLstBxAbbv
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	DealDetail		(NoLock)	On	tmp_CustomAccountDetail. DlHdrID	= DealDetail. DlDtlDlHdrID
												And	tmp_CustomAccountDetail. DlDtlID	= DealDetail. DlDtlID
		Inner Join	DynamicListBox	(NoLock)	On	DealDetail. DeliveryTermID		= convert(int, DynamicListBox. DynLstBxTyp)
												And	DynamicListBox. DynLstBxQlfr	= ''DealDeliveryTerm''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the SpecificGravity and Energy values - Pass 1
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		SpecificGravity		= MovementHeader. MvtHdrGrvty
		,Energy				= MovementHeader. Energy
From	tmp_CustomAccountDetail			(NoLock)
		Inner Join	MovementHeader	(NoLock)	On	tmp_CustomAccountDetail. MvtHdrID	= MovementHeader. MvtHdrID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the SpecificGravity and Energy values - Pass 2
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		SpecificGravity		= Product. PrdctSpcfcGrvty
		,Energy				= Product. PrdctEnrgy
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	Product			(NoLock)	On	tmp_CustomAccountDetail. ChildPrdctID	= Product. PrdctID
Where	IsNull(SpecificGravity,1.0)	= 1.0				
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the MvtDcmntExtrnlDcmntNbr values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		MvtDcmntExtrnlDcmntNbr		= MovementDocument. MvtDcmntExtrnlDcmntNbr
From	tmp_CustomAccountDetail			(NoLock)
		Inner Join	MovementHeader		(NoLock)	On	tmp_CustomAccountDetail. MvtHdrID		= MovementHeader. MvtHdrID
		Inner Join	MovementDocument	(NoLock)	On	MovementHeader. MvtHdrMvtDcmntID	= MovementDocument. MvtDcmntID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the Vhcle 
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		Vhcle				= Vehicle. VhcleNme
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	MovementHeader	(NoLock)	On	tmp_CustomAccountDetail. MvtHdrID	= MovementHeader. MvtHdrID
		Inner Join	Vehicle			(NoLock)	On	MovementHeader. MvtHdrVhcleID	= Vehicle. VhcleID										
Where	tmp_CustomAccountDetail. MvtHdrID		Is Not Null	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the PLNNDMVTID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		PlnndMvtID			= PlannedMovement. PlnndMvtID
		,PlnndMvtNme		= PlannedMovement. PlnndMvtNme
From	tmp_CustomAccountDetail			(NoLock)
		Inner Join	PlannedTransfer	(NoLock)	On	tmp_CustomAccountDetail. PlnndTrnsfrID				= PlannedTransfer. PlnndTrnsfrID
		Inner Join	PlannedMovement	(NoLock)	On	PlannedTransfer. PlnndTrnsfrPlnndStPlnndMvtID	= PlannedMovement. PlnndMvtID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the PlnndMvtBtchID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		PlnndMvtBtchID				= PlannedMovementBatch. PlnndMvtBtchID
		,PlnndMvtBtchNme			= PlannedMovementBatch. Name
From	tmp_CustomAccountDetail								(NoLock)
		Inner Join	PlannedMovement							(NoLock)	On	tmp_CustomAccountDetail. PlnndMvtID						= PlannedMovement. PlnndMvtID
		Inner Join	PlannedMovementInPlannedMovementBatch	(NoLock)	On	PlannedMovement. PlnndMvtID								= PlannedMovementInPlannedMovementBatch. PlnndMvtID	
		Inner Join	PlannedMovementBatch					(NoLock)	On	PlannedMovementInPlannedMovementBatch. PlnndMvtBtchID	= PlannedMovementBatch. PlnndMvtBtchID
'


If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the DlDtlPrvsnID values - Movement Based
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		DlDtlPrvsnID				= TransactionDetail. XDtlDlDtlPrvsnID
		,TransactionDetailID		= TransactionDetail. TransactionDetailID 
From	tmp_CustomAccountDetail				(NoLock)
		Inner Join	TransactionDetailLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID					= TransactionDetailLog. XDtlLgAcctDtlID
		Inner Join	TransactionDetail		(NoLock)	On	TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID	= TransactionDetail. XDtlDlDtlPrvsnID
														And	TransactionDetailLog. XDtlLgXDtlXHdrID			= TransactionDetail. XDtlXHdrID 
														And	TransactionDetailLog. XDtlLgXDtlID				= TransactionDetail. XDtlID	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the DlDtlPrvsnID values - Time Based
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		DlDtlPrvsnID				= TimeTransactionDetail. TmeXDtlDlDtlPrvsnID
		,DlDtlPrvsnRwID				= TimeTransactionDetail. TmeXDtlDlDtlPrvsnRwID
		,TmeXDtlIdnty				= TimeTransactionDetail. TmeXDtlIdnty
From	tmp_CustomAccountDetail					(NoLock)
		Inner Join	TimeTransactionDetailLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID					= TimeTransactionDetailLog. TmeXDtlLgAcctDtlID
		Inner Join	TimeTransactionDetail		(NoLock)	On	TimeTransactionDetailLog. TmeXDtlLgTmeXDtlIdnty	= TimeTransactionDetail. TmeXDtlIdnty
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the PrvsnID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		PrvsnID		= DealDetailProvision. DlDtlPrvsnPrvsnID
		,IsPrimary	= Case When DealDetailProvision. CostType = ''P'' Then 1 Else 0 End
From	tmp_CustomAccountDetail			(NoLock)
		Inner Join	DealDetailProvision	(NoLock)	On	tmp_CustomAccountDetail. DlDtlPrvsnID	= DealDetailProvision. DlDtlPrvsnID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the PriceEndDate for Movement Based Records
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		PriceEndDate					=	(	Select	Max(QuoteRangeEndDate)
												From	TransactionDetailExposure	(NoLock)
												Where	TransactionDetailExposure. TransactionDetailID	= tmp_CustomAccountDetail. TransactionDetailID)
Where	tmp_CustomAccountDetail. TransactionDetailID	Is Not Null
And		tmp_CustomAccountDetail. AcctDtlSrceTble		= ''X''													 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the PRICE_END_DATE for Time Transaction Based Records
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		PriceEndDate					=	(	Select	Max(QuoteRangeEndDate)
												From	TimeTransactionDetailExposure	(NoLock)
												Where	TimeTransactionDetailExposure. TmeXDtlIdnty		= tmp_CustomAccountDetail. TmeXDtlIdnty
												And		TimeTransactionDetailExposure. DlDtlPrvsnRwId	= tmp_CustomAccountDetail. DlDtlPrvsnRwID)
Where	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''TT''													 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Remove any rows that priced in after the close of the period - these may have bled through and were picked up by 
-- either the Accrual engine run or the Physical Forwards
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Delete	tmp_CustomAccountDetail
Where	IsNull(PriceEndDate,''2012-01-01'')	> ''' + convert(varchar,@sdt_AccntngPrdEndDte) + '''
And		tmp_CustomAccountDetail. GLType			= ''M''
And		tmp_CustomAccountDetail. PostingType		= ''AD''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Final Select
----------------------------------------------------------------------------------------------------------------------	
Select	@vc_DynamicSQL	= '	
Select	 tmp_CustomAccountDetail. AcctDtlID
		,tmp_CustomAccountDetail. AcctDtlID		''ID''
		,tmp_CustomAccountDetail. AcctDtlPrntID
		,tmp_CustomAccountDetail. AccntngPrdID
		,tmp_CustomAccountDetail. PostingType
		,tmp_CustomAccountDetail. DlHdrID
		,tmp_CustomAccountDetail. DlHdrIntrnlNbr
		,tmp_CustomAccountDetail. InternalBAID		
		,tmp_CustomAccountDetail. ExternalBAID
		,tmp_CustomAccountDetail. DlDtlID
		,tmp_CustomAccountDetail. INCOTerm
		,tmp_CustomAccountDetail. StrtgyID
		,tmp_CustomAccountDetail. DlDtlPrvsnID
		,tmp_CustomAccountDetail. PrvsnID
		,Case tmp_CustomAccountDetail. IsPrimary When 1 Then ''Y'' Else ''N'' End  as IsPrimary
		,tmp_CustomAccountDetail. PriceEndDate
		,tmp_CustomAccountDetail. PlnndTrnsfrID
		,tmp_CustomAccountDetail. PlnndMvtID
		,tmp_CustomAccountDetail. PlnndMvtNme
		,tmp_CustomAccountDetail. PlnndMvtBtchID
		,tmp_CustomAccountDetail. PlnndMvtBtchNme
		,tmp_CustomAccountDetail. MvtHdrID
		,tmp_CustomAccountDetail. MvtDcmntExtrnlDcmntNbr
		,tmp_CustomAccountDetail. Vhcle
		,tmp_CustomAccountDetail. LcleID		
		,tmp_CustomAccountDetail. ParentPrdctID
		,tmp_CustomAccountDetail. ChildPrdctID
		,tmp_CustomAccountDetail. TrnsctnTypDesc
		,tmp_CustomAccountDetail. TransactionDate
		,tmp_CustomAccountDetail. Quantity
		,Case 
			When	Quantity = 0.0 Then NetValue 
			Else	Case 
						When NetValue / Quantity >= 0 Then NetValue / Quantity
						Else NetValue / Quantity * -1 
					End  
		  End										''PerUnitValue''
		,tmp_CustomAccountDetail. NetValue
		,tmp_CustomAccountDetail. CrrncyID		
		,tmp_CustomAccountDetail. RAInvoiceID
		,tmp_CustomAccountDetail. InvoiceNumber
		,tmp_CustomAccountDetail. Comments
		,tmp_CustomAccountDetail. SpecificGravity
		,tmp_CustomAccountDetail. Energy
		,tmp_CustomAccountDetail. AcctDtlSrceTble
		,tmp_CustomAccountDetail. AcctDtlSrceID	
		,tmp_CustomAccountDetail. Reversed
		,tmp_CustomAccountDetail. PayableMatchingStatus			
From	tmp_CustomAccountDetail		(NoLock)
Where	1=1 
'
----------------------------------------------------------------------------------------------------------------------
-- Final Where
----------------------------------------------------------------------------------------------------------------------	
 If @i_AccountDetailID Is Null  
 Begin
 Select	@vc_DynamicSQL	= @vc_DynamicSQL + 
		Case
			When	@vc_InternalBAID Is Not Null		Then	'And	tmp_CustomAccountDetail. InternalBAID	In (' + @vc_InternalBAID + ')
'  	
			Else	''
		End	+	
		Case		
			When	@vc_ExternalBAID Is Not Null		Then	'And	tmp_CustomAccountDetail. ExternalBAID	In (' + @vc_ExternalBAID + ')
'				   
			Else	''
		End	+
		Case		
			When	@vc_TransactionType Is Not Null		Then	'And	tmp_CustomAccountDetail. TrnsctnTypID	In (' + @vc_TransactionType + ')
'				   
			Else	''
		End	+
		Case		
			When	@vc_StrtgyID Is Not Null			Then	'And	tmp_CustomAccountDetail. StrtgyID		In (' + @vc_StrtgyID + ')
'				   
			Else	''
		End	+
		Case		
			When	@vc_AccountingPeriodID Is Not Null	Then	'And	tmp_CustomAccountDetail. AccntngPrdID	In (' + @vc_AccountingPeriodID + ')
'				   
			Else	''
		End	+
		Case		
			When	@dt_FromDate Is Not Null			Then	'And	tmp_CustomAccountDetail. TransactionDate >= ''' + convert(varchar(20),@dt_FromDate, 120) + '''
'				   
			Else	''
		End	+
		Case		
			When	@dt_ToDate Is Not Null				Then	'And	tmp_CustomAccountDetail. TransactionDate <= ''' + convert(varchar(20),@dt_ToDate, 120) + '''
'				   
			Else	''
		End	+
		Case
			When	@vc_DealNumber Is Not Null			Then	'And	tmp_CustomAccountDetail. DlHdrIntrnlNbr	Like ''' + @vc_DealNumber + '''
'	
			Else	''
		End 	
End
Else
Begin
	 Select	@vc_DynamicSQL	= @vc_DynamicSQL +  
				' And tmp_CustomAccountDetail. AcctDtlID = Convert(int,' + Convert(VarChar, @i_AccountDetailID) +')' 
End 

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
	

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
If OBJECT_ID('dbo.Custom_Closing_GL_Report') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Closing_GL_Report >>>'
	Grant Execute on dbo.Custom_Closing_GL_Report to SYSUSER
	Grant Execute on dbo.Custom_Closing_GL_Report to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Closing_GL_Report >>>'
GO

 