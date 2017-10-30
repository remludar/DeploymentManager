If OBJECT_ID('dbo.Custom_Interface_AD_Mapping') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Interface_AD_Mapping
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_AD_Mapping >>>'
End
Go  

Create Procedure dbo.Custom_Interface_AD_Mapping	 @i_ID				int				= NULL
													,@i_MessageID		int				= NULL
													,@vc_Source			char(2)			= 'SH'
													,@i_AccntngPrdID	int				= NULL
													,@i_P_EODSnpShtID	int				= NULL
													,@c_GLType			char(1)			= NULL
													,@i_AcctDtlID		int				= NULL
													,@b_GLReprocess		bit				= 0
													,@c_ReturnToInvoice	char(1)			= 'N'
													,@c_OnlyShowSQL  	char(1) 		= 'N' 

As 
-----------------------------------------------------------------------------------------------------------------------------
-- Name:		Custom_Interface_AD_Mapping	 @i_ID = 5 , @vc_Source = 'SH', @c_OnlyShowSQL = 'Y'
-- Overview:	
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Joshua Weber
-- History:		14/01/2013 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	Custom_Interface_AD_Mapping	 @i_ID = 34 , @vc_Source = 'GL', @i_AccntngPrdID = 281, @c_GLType = 'M', @c_OnlyShowSQL = 'Y'
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
Declare	 @vc_DynamicSQL					varchar(8000)
		,@vc_DynamicSQL2				varchar(8000)
		,@vc_Error						varchar(255)
		,@sdt_Date						smalldatetime
		,@i_Tax_XGrpID					int
		,@i_OpenAccntngPrdID			int
		,@sdt_OpenAccntngPrdBgnDte		smalldatetime
		,@sdt_GLAccntngPrdEndDte		smalldatetime
		,@i_InvoiceID					int
		,@i_BaseUOMID					smallint
		,@vc_BaseUOM					varchar(80)
		,@i_DefaultPerUnitDecimals		int
		,@i_DefaultQtyDecimals			int
		,@i_UOMQttyDecimalsPrnt			int
		,@i_RowID						int
		,@i_Ex_BAID						int
		,@c_Direction					char(1)
		,@i_DlHdrID						int
		,@i_DlDtlID						int
		,@i_ObID						int
		,@i_PlnndTrnsfrID				int
		,@i_PlnndMvtID					int
		,@i_MvtHdrID					int
		,@vc_Instruments				varchar(500)	
		,@vc_Banks						varchar(500)
		,@i_CurrencyRPHdrID				int
		,@i_CurrentDefaultPriceType		int
		,@i_CurrencyDefaultLcleID		int
		,@i_SGD							int
		,@d_InvoiceAmount				decimal(19,6)		
		,@d_TotalTaxAmount				decimal(19,6)
		,@d_TaxRecalc					decimal(19,6)
		,@d_TaxDifference				decimal(19,6)
		,@d_TaxRate						decimal(19,6)
		,@i_HighestTaxValue				int
		
----------------------------------------------------------------------------------------------------------------------
-- Set the Tax Group ID
----------------------------------------------------------------------------------------------------------------------
Select	@i_Tax_XGrpID	= XGrpID
From	TransactionGroup	(NoLock)
Where	XGrpName	= 'Tax'	

----------------------------------------------------------------------------------------------------------------------
-- Set the Currnet Open Accounting Period
----------------------------------------------------------------------------------------------------------------------
Select	@i_OpenAccntngPrdID	= Min(AccntngPrdID)
From	AccountingPeriod	(NoLock)
Where	AccntngPrdCmplte	= 'N'

Select	@sdt_OpenAccntngPrdBgnDte	= AccntngPrdBgnDte
From	AccountingPeriod	(NoLock)
Where	AccntngPrdID	= @i_OpenAccntngPrdID

Select	@sdt_GLAccntngPrdEndDte	= AccntngPrdEndDte
From	AccountingPeriod	(NoLock)
Where	AccntngPrdID	= @i_AccntngPrdID


Select	@sdt_Date	= GetDate()	

----------------------------------------------------------------------------------------------------------------------
-- Set the interface UOM defaults
----------------------------------------------------------------------------------------------------------------------
Select	 @i_BaseUOMID				= InterfaceDefaultUOMID
		,@vc_BaseUOM				= InterfaceDefaultUOM
		,@i_DefaultPerUnitDecimals	= InterfaceDefaultPerUnitDecimals
		,@i_DefaultQtyDecimals		= InterfaceDefaultQtyDecimals
From	CustomConfigAccounting	(NoLock)
Where	ConfigurationName		= 'Default'	

Select	@i_CurrencyRPHdrID			= ExchangeRatePublisherId
		,@i_CurrentDefaultPriceType	= ExchangeRatePriceTypeId	
		,@i_CurrencyDefaultLcleID	= ExchangeRateLocationId	
From	ConfigValuation	(NoLock)
Where	ConfigurationName	= 'Default'

Select	@i_SGD	= CrrncyID
From	Currency	(NoLock)
Where	CrrncySmbl	= 'SGD'	

----------------------------------------------------------------------------------------------------------------------
-- Set the parent registry id for the UOMQttyDecimals
----------------------------------------------------------------------------------------------------------------------
Select	@i_UOMQttyDecimalsPrnt	= RgstryID
From	Registry	(NoLock)
Where	RgstryFllKyNme	= 'System\SalesInvoicing\UOMQttyDecimals\'	

----------------------------------------------------------------------------------------------------------------------
-- Build the tmp_CustomAccountDetail temp table
----------------------------------------------------------------------------------------------------------------------		
If	@c_OnlyShowSQL = 'Y' And @c_ReturnToInvoice = 'N'
	Select	'
		Truncate Table	tmp_CustomAccountDetail
		'			
Else
		Truncate Table	tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Block 10: Load the relevant Account Details into the temp table
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Load tmp_CustomAccountDetail for Sales Invoice and Purchase Invoice records
----------------------------------------------------------------------------------------------------------------------
If	@vc_Source	In ('SH', 'PH')
	Begin	
		Select	@vc_DynamicSQL	= '	
		Insert	tmp_CustomAccountDetail
				(AcctDtlID
				,AcctDtlPrntID
				,AcctDtlSrceID
				,AcctDtlSrceTble
				,AccntngPrdID
				,PriorPeriod
				,Reversed
				,PayableMatchingStatus							
				,InterfaceSource
				,InterfaceMessageID
				,RAInvoiceID
				,InterfaceInvoiceID
				,InternalBAID
				,ExternalBAID
				,ParentPrdctID
				,ChildPrdctID	
				,TrnsctnTypID
				,WePayTheyPay
				,NetValue
				,CrrncyID
				,SupplyDemand				
				,Quantity
				,BaseUOMID
				,BaseUOM
				,XRefUOM
				,TransactionDate
				,DlHdrID	
				,DlDtlID
				,StrtgyID
				,PlnndTrnsfrID
				,MvtHdrID
				,DefaultPerUnitDecimals
				,DefaultQtyDecimals)
		Select	 AccountDetail. AcctDtlID											-- AcctDtlID
				,AccountDetail. AcctDtlPrntID										-- AcctDtlPrntID
				,AccountDetail. AcctDtlSrceID										-- AcctDtlSrceID
				,AccountDetail. AcctDtlSrceTble										-- AcctDtlSrceTble
				,AccountDetail. AcctDtlAccntngPrdID									-- AccntngPrdID
				,''N''																-- PriorPeriod
				,AccountDetail. Reversed											-- Reversed
				,AccountDetail. PayableMatchingStatus								-- PayableMatchingStatus


				,''' + Case @i_ID When -1 Then 'SH' When -2 Then 'PH' Else IsNull(@vc_Source,'NA') End + ''' 		-- InterfaceSource
				,' + Case When @i_ID < 0 Then 'BULK_TABLE.ID' Else convert(varchar, @i_MessageID) End + '									-- InterfaceMessageID
				,' + Case When @i_ID < 0 Then 'BULK_TABLE.EntityID' Else convert(varchar,IsNull(@i_ID,0)) End + '	-- RAInvoiceID

				,CustomInvoiceLog.ID												-- InterfaceInvoiceID

				,AccountDetail. InternalBAID										-- InternalBAID
				,AccountDetail. ExternalBAID										-- ExternalBAID
				,AccountDetail. ParentPrdctID										-- ParentPrdctID
				,IsNull(AccountDetail. ChildPrdctID, AccountDetail. ParentPrdctID)	-- ChildPrdctID	
				,AccountDetail. AcctDtlTrnsctnTypID									-- TrnsctnTypID
				,AccountDetail. WePayTheyPay										-- WePayTheyPay
				,AccountDetail. Value												-- NetValue
				,AccountDetail. CrrncyID											-- CrrncyID
				,AccountDetail. SupplyDemand										-- SupplyDemand				
				,AccountDetail. Volume												-- Quantity
				,AccountDetail. AcctDtlUOMID										-- BaseUOMID
				,''' + IsNull(@vc_BaseUOM,'NA') + ''' 								-- BaseUOM
				,''' + IsNull(@vc_BaseUOM,'NA') + '''								-- XRefUOM
				,AccountDetail. AcctDtlTrnsctnDte									-- TransactionDate
				,AccountDetail. AcctDtlDlDtlDlHdrID									-- DlHdrID	
				,AccountDetail. AcctDtlDlDtlID	 									-- DlDtlID
				,AccountDetail. AcctDtlStrtgyID										-- StrtgyID
				,AccountDetail. AcctDtlPlnndTrnsfrID								-- PlnndTrnsfrID
				,AccountDetail. AcctDtlMvtHdrID										-- MvtHdrID
				,' + convert(varchar,IsNull(@i_DefaultPerUnitDecimals, 0)) + '
				,' + convert(varchar,IsNull(@i_DefaultQtyDecimals, 0)) + '
'
+ Case	When @i_ID = -1 Then -- AR Bulk
		'		From	#AR_Bulk BULK_TABLE (NoLock)
						Inner Join dbo.AccountDetail (NoLock)
							on	AccountDetail. AcctDtlSlsInvceHdrID		= BULK_TABLE.EntityID
						Inner Join dbo.CustomInvoiceLog (NoLock)
							on	CustomInvoiceLog.InvoiceID		= BULK_TABLE.EntityID
							and	CustomInvoiceLog.InvoiceType	= ''SH''
		'
		When @i_ID = -2 Then -- AP Bulk
		'		From	#AP_Bulk BULK_TABLE (NoLock)
						Inner Join dbo.AccountDetail (NoLock)
							on	AccountDetail. AcctDtlPrchseInvceHdrID	= BULK_TABLE.EntityID
						Inner Join dbo.CustomInvoiceLog (NoLock)
							on	CustomInvoiceLog.InvoiceID		= BULK_TABLE.EntityID
							and	CustomInvoiceLog.InvoiceType	= ''PH''
		'
		Else
		'		From	AccountDetail	(NoLock)
						Inner Join dbo.CustomInvoiceLog (NoLock)
							on	CustomInvoiceLog.InvoiceID		= ' + convert(varchar,IsNull(@i_ID,0)) + '
							and	CustomInvoiceLog.InvoiceType	= ''' + @vc_Source + '''
		Where	1 = 1
		'	+	
			Case	
				When	@vc_Source	= 'SH'	Then	'And		AccountDetail. AcctDtlSlsInvceHdrID		= ' + convert(varchar,IsNull(@i_ID,0)) + '' 	
				When	@vc_Source	= 'PH'	Then	'And		AccountDetail. AcctDtlPrchseInvceHdrID	= ' + convert(varchar,IsNull(@i_ID,0)) + '' 		
				Else	''
			End
		End

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
		
	End
----------------------------------------------------------------------------------------------------------------------
-- Load tmp_CustomAccountDetail for the GL records
----------------------------------------------------------------------------------------------------------------------		
Else
	Begin
		Begin Try
			Execute dbo.Custom_Interface_GL_AD_Load	 @i_ID				= @i_ID
													,@i_AccntngPrdID	= @i_AccntngPrdID
													,@i_P_EODSnpShtID	= @i_P_EODSnpShtID
													,@c_GLType			= @c_GLType
													,@i_AcctDtlID		= @i_AcctDtlID
													,@b_GLReprocess		= @b_GLReprocess
													,@c_OnlyShowSQL		= @c_OnlyShowSQL

			----------------------------------------------------------------------------------------------------------------------------------
			-- Remove Deals where AccountingTreatment is NULL or "N"
			----------------------------------------------------------------------------------------------------------------------------------
			Select 	@vc_DynamicSQL = '	
			Delete	tmp_CustomAccountDetail
			From	tmp_CustomAccountDetail
					Left Outer Join GeneralConfiguration (NoLock)
						on	GeneralConfiguration.GnrlCnfgTblNme			= ''DealHeader''
						and	GeneralConfiguration.GnrlCnfgQlfr			= ''AccountingTreatment''
						and GeneralConfiguration.GnrlCnfgHdrID			= tmp_CustomAccountDetail.DlHdrID
					Left Outer Join v_MTV_XrefAttributes (NoLock)
						on	v_MTV_XrefAttributes.Source					= ''XRef''
						and	v_MTV_XrefAttributes.Qualifier				= ''Accounting Treatment'' -- note the space
						and	v_MTV_XrefAttributes.ExternalValue			= GeneralConfiguration.GnrlCnfgMulti
			Where	IsNull(v_MTV_XrefAttributes.RAValue, ''N'')	<> ''Y''
			and		tmp_CustomAccountDetail.TrnsctnTypID				in (2027,2028,2029,2030)
			and		not exists	(
								Select	1
								From	MovementHeader (NoLock)
										Inner Join MovementHeaderType (NoLock)
											on	MovementHeader.MvtHdrTyp		= MovementHeaderType.MvtHdrTyp
								Where	MovementHeader.MvtHdrID		= IsNull(tmp_CustomAccountDetail.MvtHdrID, 0)
								And		MovementHeaderType.Name		= ''Accrual''
								)
			'

			If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	


		End Try
		Begin Catch						
				Select	@vc_Error	= 'The GL Interface encountered an error executing Custom_Interface_GL_AD_Load: ' + ERROR_MESSAGE()	
				GoTo	Error	
		End Catch																								
	End		


----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Begin
		Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
	'
	End
Else
	Begin
		UPDATE STATISTICS tmp_CustomAccountDetail
	End

----------------------------------------------------------------------------------------------------------------------
-- Block 20: Normalize the basic columns
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Correct the NetValue sign on payables
----------------------------------------------------------------------------------------------------------------------
If	@vc_Source	In ('SH', 'PH')
	Begin
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		NetValue		= NetValue * - 1
		Where	InterfaceSource	= ''PH''
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Correct QUANTITY sign on receivables
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		Quantity		= Quantity	* -1
		Where	InterfaceSource	= ''SH''	
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

----------------------------------------------------------------------------------------------------------------------
-- Set the Child Product Name
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		ChildPrdctNme		= Child.PrdctNme,
		CmmdtyID			= Child.CmmdtyID,
		XRefChildPrdctCode	= Child.PrdctAbbv,
		ParentPrdctNme		= Product.PrdctNme
From	tmp_CustomAccountDetail					(NoLock)
		Inner Join	Product		(NoLock)	On	tmp_CustomAccountDetail.ParentPrdctID	= Product.PrdctID
		Inner Join	Product	Child (NoLock)	On	tmp_CustomAccountDetail.ChildPrdctID	= Child.PrdctID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Commodity Name
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		CmmdtyName	= Commodity. Name
From	tmp_CustomAccountDetail	(NoLock)
		Inner Join	Commodity	(NoLock)	On	tmp_CustomAccountDetail. CmmdtyID	= Commodity. CmmdtyID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

If	@vc_Source	In ('SH', 'PH')
	Begin
		----------------------------------------------------------------------------------------------------------------------
		-- Set the Transaction Type
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		TrnsctnTypDesc	= TransactionType. TrnsctnTypDesc
		From	tmp_CustomAccountDetail		(NoLock)
				Inner Join	TransactionType	(NoLock)	On	tmp_CustomAccountDetail. TrnsctnTypID	= TransactionType. TrnsctnTypID
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End
----------------------------------------------------------------------------------------------------------------------
-- Set the Currency
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		Currency	= Currency. CrrncySmbl
From	tmp_CustomAccountDetail	(NoLock)
		Inner Join	Currency	(NoLock)	On	tmp_CustomAccountDetail. CrrncyID	= Currency. CrrncyID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Strategy
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		StrtgyNme	= StrategyHeader. Name
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	StrategyHeader	(NoLock)	On	tmp_CustomAccountDetail. StrtgyID	= StrategyHeader. StrtgyID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Internal BA
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		InternalBANme	= BusinessAssociate. BaNme + IsNull(BusinessAssociate. BanmeExtended, '''')
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	BusinessAssociate	(NoLock)	On	tmp_CustomAccountDetail. InternalBAID	= BusinessAssociate. BAID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the External BA
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		ExternalBANme	= BusinessAssociate. BaNme + IsNull(BusinessAssociate. BanmeExtended, '''')
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	BusinessAssociate	(NoLock)	On	tmp_CustomAccountDetail. ExternalBAID	= BusinessAssociate. BAID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Block 30: Set the values from the Invoice architecture
----------------------------------------------------------------------------------------------------------------------
If	@vc_Source	= 'PH'
	Begin
		----------------------------------------------------------------------------------------------------------------------
		-- Set the values for the purchase invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		 InvoiceNumber					= PayableHeader. InvoiceNumber 
				,InvoiceDueDate					= PayableHeader. DueDate
				,InvoiceAmount					= Round(PayableHeader. InvoiceAmount,2)
				,InvoiceAmountPaid				= PayableHeader. PaidAmount
				,InvoiceIntBAID					= PayableHeader. InternalBAID
				,InvoiceExtBAID					= PayableHeader. ExternalBAID
				,InvoiceDate					= IsNull(CustomInvoiceHeader. NewInvoiceDate, PayableHeader. InvoiceDate)
				,InvoiceCrrncyID				= PayableHeader. CrrncyID
				,InvoiceCurrency				= Currency. CrrncySmbl
				,InvoiceExtBAOffceLcleID		= PayableHeader. OffceLcleID
				,InvoiceCreationDate			= PayableHeader. CreatedDate
				,InvoiceCreationUserID			= PayableHeader. CreatedUserID
				,Comments						= PayableHeader. Comments	

				,InvoicePaymentBank				= AI.AddressLine1	-- Bank Routing Number
				,XRefPaymentBankCode			= AI.AddressLine2	-- Bank Account Number
				,XRefExtBAAddressCode			= AI.Country		-- So we can say "X" if not USA

				,InvoiceParentInvoiceID		= PayableHeader.ParentPybleHdrID
				,InvoiceParentInvoiceNumber	= PH2.InvoiceNumber
				,InvoiceParentInvoiceValue	= Round(PH2.InvoiceAmount,2)
		From	tmp_CustomAccountDetail		(NoLock)		
				Inner Join	PayableHeader	(NoLock)	On	tmp_CustomAccountDetail. RAInvoiceID	= PayableHeader. PybleHdrID
				Inner Join	Currency		(NoLock)	On	PayableHeader. CrrncyID				= Currency. CrrncyID 
				Left Outer Join v_AddressInformation AI (NoLock)
						on	AI.BAID			= PayableHeader.ExternalBAID
						and	AI.LcleID		= PayableHeader.OffceLcleID
						and	AI.Type			= ''R''
				Left Outer Join CustomInvoiceHeader			(NoLock)	On	tmp_CustomAccountDetail. RAInvoiceID	= CustomInvoiceHeader. SlsInvceHdrID
																		And	CustomInvoiceHeader. InvoiceType	= tmp_CustomAccountDetail. InterfaceSource				
				Left Outer Join PayableHeader	as PH2 with (NoLock)
					on	PH2.PybleHdrID			= PayableHeader.ParentPybleHdrID

		Where	tmp_CustomAccountDetail. InterfaceSource	= ''PH''
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the InvoiceTrmID value -- ??? Requirements Not Known
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceTrmID	=	Terms.DlDtlTrmTrmID
		From	tmp_CustomAccountDetail
				Inner Join (
							Select	DealDetail.DlDtlTrmTrmID,
									InterfaceMessageID
							From	tmp_CustomAccountDetail	Sub	(NoLock)	
									Inner Join	DealDetail		(NoLock)
										On	DealDetail. DlDtlDlHdrID	= Sub. DlHdrID	
										And	DealDetail. DlDtlID			= Sub. DlDtlID
							Where	Not Exists	(
												Select	1
												From	tmp_CustomAccountDetail Sub2 (NoLock)
												Where	Sub2.InterfaceMessageID		= Sub.InterfaceMessageID
												And		Sub2.NetValue				> Sub.NetValue
												)
							) as Terms
								on	Terms.InterfaceMessageID		= tmp_CustomAccountDetail.InterfaceMessageID
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''PH''
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)-- jvHERE

		----------------------------------------------------------------------------------------------------------------------
		-- Set the InvoiceUOMID value
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceUOMID = DT.UOMID
		From	tmp_CustomAccountDetail
				Inner Join (
							Select	max(BaseUOMID) over (partition by InterfacemessageID order by BaseUOMID)as UOMID,
									InterfaceMessageID
							from	tmp_CustomAccountDetail sub
							) DT
								on	DT.InterfaceMessageID = tmp_CustomAccountDetail.InterfaceMessageID
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''PH''
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL) -- jvHERE
	End

If	@vc_Source	= 'SH'
	Begin	
		----------------------------------------------------------------------------------------------------------------------
		-- Set the values for the sales invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		 InvoiceNumber				= SalesInvoiceHeader. SlsInvceHdrNmbr 
				,InvoiceDueDate				= SalesInvoiceHeader. SlsInvceHdrDueDte
				,InvoiceAmount				= Round(SalesInvoiceHeader. SlsInvceHdrTtlVle,2)
				,InvoiceIntBAID				= SalesInvoiceHeader. SlsInvceHdrIntrnlBAID
				,InvoiceExtBAID				= SalesInvoiceHeader. SlsInvceHdrBARltnBAID
				,InvoiceRprtCnfgID			= SalesInvoiceHeader. RprtCnfgID
				,InvoiceDate				= Coalesce(CustomInvoiceHeader. NewInvoiceDate, SalesInvoiceHeader. SlsInvceHdrPstdDte,GetDate())
				,InvoiceUOMID				= SalesInvoiceHeader. SlsInvceHdrUOM
				,InvoiceCrrncyID			= SalesInvoiceHeader. SlsInvceHdrCrrncyID
				,InvoiceCurrency			= Currency. CrrncySmbl
				,InvoiceIntUserID			= Users. UserID 
				,InvoiceIntUserDBMnkr		= Users. UserDBMnkr 
				,InvoiceIntBAOffceLcleID	= Int. CntctOffceLcleID
				,InvoiceExtCntctID			= SalesInvoiceHeader. ExternalCntctID
				,InvoiceExtBAOffceLcleID	= Ext. CntctOffceLcleID
				,InvoiceTrmID				= SalesInvoiceHeader. SlsInvceHdrTrmID
				,InvoicePaymentBankID		= SalesInvoiceHeader. RemitSlsInvceVrbgeID
				,InvoicePaymentBank			= SalesInvoiceVerbiage. SlsInvceVrbgeDscrptn
				,InvoiceParentInvoiceID		= SalesInvoiceHeader.SlsInvceHdrPrntID
				,InvoiceParentInvoiceNumber	= SIH2.SlsInvceHdrNmbr
				,InvoiceParentInvoiceValue	= Round(SIH2. SlsInvceHdrTtlVle,2)
				,InvoiceCreationDate		= SalesInvoiceHeader. SlsInvceHdrCrtnDte
				,InvoiceCreationUserID		= CustomInvoiceLog. UserID			
				,InvoicePerUnitDecimal		= SalesInvoiceHeader. PerUnitDecimalPlaces	
				,Comments					= SalesInvoiceHeader. SlsInvceHdrCmmnts		
		From	tmp_CustomAccountDetail						(NoLock)		
				Inner Join	SalesInvoiceHeader				(NoLock)	On	tmp_CustomAccountDetail. RAInvoiceID			= SalesInvoiceHeader. SlsInvceHdrID
				Inner Join	Currency						(NoLock)	On	SalesInvoiceHeader. SlsInvceHdrCrrncyID		= Currency. CrrncyID 
				Left Outer Join	Contact					Int	(NoLock)	On	SalesInvoiceHeader. InternalCntctID			= Int. CntctID 
				Left Outer Join	Users						(NoLock)	On	Int. CntctID								= Users. UserCntctID 
				Left Outer Join	Contact					Ext	(NoLock)	On	SalesInvoiceHeader. ExternalCntctID			= Ext. CntctID 
				Left Outer Join	SalesInvoiceVerbiage		(NoLock)	On	SalesInvoiceHeader. WireSlsInvceVrbgeID		= SalesInvoiceVerbiage. SlsInvceVrbgeID
				Left Outer Join CustomInvoiceHeader			(NoLock)	On	tmp_CustomAccountDetail. RAInvoiceID			= CustomInvoiceHeader. SlsInvceHdrID
																		And	CustomInvoiceHeader. InvoiceType			= tmp_CustomAccountDetail. InterfaceSource	
				Left Outer Join	CustomInvoiceLog			(NoLock)	On	tmp_CustomAccountDetail. InterfaceInvoiceID	= CustomInvoiceLog. ID
				Left Outer Join SalesInvoiceHeader	as SIH2 with (NoLock)
					on	SIH2.SlsInvceHdrID			= SalesInvoiceHeader.SlsInvceHdrPrntID
		Where	tmp_CustomAccountDetail. InterfaceSource		= ''SH''
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	
	End

If	@vc_Source	In ('SH', 'PH')
	Begin	
		----------------------------------------------------------------------------------------------------------------------
		-- Determine the InvoiceTrmAbbrvtn value
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceTrmAbbrvtn	= Term. TrmAbbrvtn
		From	tmp_CustomAccountDetail	(NoLock)	
				Inner Join	Term		(NoLock)	On	tmp_CustomAccountDetail. InvoiceTrmID	= Term. TrmID	
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''PH'',''SH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the Internal BA value on the invoice
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceIntBANme		=     IsNull(GeneralConfiguration. GnrlCnfgMulti, BusinessAssociate. BaNme + IsNull(BusinessAssociate. BanmeExtended, ''''))
		From	tmp_CustomAccountDetail					(NoLock)	
				Inner Join	BusinessAssociate			(NoLock)	On	tmp_CustomAccountDetail. InvoiceIntBAID	= BusinessAssociate. BAID
				Left Outer Join	GeneralConfiguration	(NoLock)	On	BusinessAssociate. BAID					= GeneralConfiguration. GnrlCnfgHdrID
																	And	GeneralConfiguration. GnrlCnfgTblNme	= ''BusinessAssociate''
																	And	GeneralConfiguration. GnrlCnfgQlfr		= ''invoicedisplayname''
																	And	GeneralConfiguration. GnrlCnfgHdrID		<> 0		
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''PH'',''SH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the Registration value on the invoice
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceIntBARegistration		= GeneralConfiguration. GnrlCnfgMulti
		From	tmp_CustomAccountDetail					(NoLock)	
				Left Outer Join	GeneralConfiguration	(NoLock)	On	tmp_CustomAccountDetail. InvoiceIntBAOffceLcleID	= GeneralConfiguration. GnrlCnfgHdrID
																	And	GeneralConfiguration. GnrlCnfgTblNme			= ''Office''
																	And	GeneralConfiguration. GnrlCnfgQlfr				= ''registration''
																	And	GeneralConfiguration. GnrlCnfgHdrID				<> 0		
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''PH'',''SH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the External BA value on the invoice
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceExtBANme		= BusinessAssociate. BaNme + IsNull(BusinessAssociate. BanmeExtended, '''')
		From	tmp_CustomAccountDetail			(NoLock)	
				Inner Join	BusinessAssociate	(NoLock)	On	tmp_CustomAccountDetail. InvoiceExtBAID	= BusinessAssociate. BAID
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''PH'',''SH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

----------------------------------------------------------------------------------------------------------------------
-- Set the InvoiceUOM value on the invoice
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		InvoiceUOM		= UnitOfMeasure. UOMAbbv 
From	tmp_CustomAccountDetail			(NoLock)	
		Inner Join	UnitOfMeasure	(NoLock)	On	tmp_CustomAccountDetail. InvoiceUOMID	= UnitOfMeasure. UOM
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


If	@vc_Source	In ('SH', 'PH')
	Begin	
		----------------------------------------------------------------------------------------------------------------------
		-- Set the InvoiceQuantityDecimal value on the sales invoice
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceQuantityDecimal		= Registry. RgstryDtaVle 
		From	tmp_CustomAccountDetail	(NoLock)	
				Inner Join	Registry	(NoLock)	On	LTrim(RTrim(tmp_CustomAccountDetail. InvoiceUOM))	= LTrim(RTrim(Registry. RgstryKyNme))
													And	Registry. RgstryPrntID							= ' + convert(varchar,IsNull(@i_UOMQttyDecimalsPrnt,0)) + '	
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''SH''
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the Invoice Booking Date
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InterfaceBookingDate	= IsNull(CustomInvoiceHeader. NewSAPPostedDate, tmp_CustomAccountDetail. InvoiceDate)	
		From	tmp_CustomAccountDetail					(NoLock)
				Left Outer Join CustomInvoiceHeader		(NoLock)	On	tmp_CustomAccountDetail. RAInvoiceID	= CustomInvoiceHeader. SlsInvceHdrID
																	And	CustomInvoiceHeader. InvoiceType	= tmp_CustomAccountDetail. InterfaceSource		
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''PH'',''SH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the InterfaceBookingAccntngPrdID value
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InterfaceBookingAccntngPrdID	= AccountingPeriod. AccntngPrdID	
		From	tmp_CustomAccountDetail			(NoLock)	
				Inner Join	AccountingPeriod	(NoLock)	On	tmp_CustomAccountDetail. InvoiceDate	Between	AccountingPeriod. AccntngPrdBgnDte And AccountingPeriod. AccntngPrdEndDte   	
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''PH'',''SH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Determine the InterfaceBookingDate value
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InterfaceBookingDate	=	Case 
												When	AccountingPeriod. AccntngPrdCmplte	= ''Y''	Then	''' + convert(varchar,@sdt_OpenAccntngPrdBgnDte) + '''
												Else	tmp_CustomAccountDetail. InterfaceBookingDate
											End	
		From	tmp_CustomAccountDetail			(NoLock)	
				Inner Join	AccountingPeriod	(NoLock)	On	tmp_CustomAccountDetail. InterfaceBookingAccntngPrdID	= AccountingPeriod. AccntngPrdID	
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''PH'',''SH'')
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

	End

----------------------------------------------------------------------------------------------------------------------
-- Set the Local Currency
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		LocalCrrncyID	= BusinessAssociateCurrency. BACrrncyCrrncyID
		,LocalCurrency	= Currency. CrrncySmbl 
From	BusinessAssociateCurrency				(NoLock)
		Inner Join	tmp_CustomAccountDetail		(NoLock)	On	tmp_CustomAccountDetail. InternalBAID			= BusinessAssociateCurrency. BACrrncyBAID
		Inner Join	Currency					(NoLock)	On	BusinessAssociateCurrency. BACrrncyCrrncyID	= Currency. CrrncyID 						
'

if exists (Select 1 From BusinessAssociateCurrency (NoLock) Where BACrrncyCrrncyID <> 19)
	If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Block 40: Set the values from the Deal architecture
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Set the Deal values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		DlHdrIntrnlNbr					= DealHeader. DlHdrIntrnlNbr
		,DlHdrExtrnlNbr					= DealHeader. DlHdrExtrnlNbr
		,DlHdrTyp						= DealHeader. DlHdrTyp
		,DlHdrDsplyDte					= DealHeader. DlHdrDsplyDte
		,DlHdrTmplteID					= DealHeader. DlHdrTmplteID
		,DlHdrSubTemplateID				= DealHeader. SubTemplateID
		,DlHdrEntityTemplateID			= DealHeader. EntityTemplateID
		,DlHdrUserInterfaceTemplateID	= DealHeader. UserInterfaceTemplateID
		,MasterAgreementID				= DealHeader. MasterAgreement
		,MasterAgreementInternalNumber	= MasterAgreement. InternalNumber
		,MasterAgreementDate			= MasterAgreement. NegotiatedDate
From	tmp_CustomAccountDetail								(NoLock)
		Inner Join	DealHeader								(NoLock)	On	tmp_CustomAccountDetail. DlHdrID		= DealHeader. DlHdrID
		Left Outer Join	MasterAgreement						(NoLock)	On	DealHeader. MasterAgreement			= MasterAgreement. MasterAgreementId
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Clearport value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsClearPort					= 1
From	tmp_CustomAccountDetail				(NoLock)
		Inner Join	GeneralConfiguration	(NoLock)	On	tmp_CustomAccountDetail. DlHdrID			= GeneralConfiguration. GnrlCnfgHdrID
														And	GeneralConfiguration. GnrlCnfgTblNme	= ''DealHeader''
														And	GeneralConfiguration. GnrlCnfgQlfr		= ''ExchangeTraded''
														And	GeneralConfiguration. GnrlCnfgMulti		= ''Clearport''
														And	GeneralConfiguration. GnrlCnfgHdrID		<> 0		 	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
         
----------------------------------------------------------------------------------------------------------------------
-- Set the Deal Detail values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		 DlDtlTmplteID			= DealDetail. DlDtlTmplteID
		,DlDtlSubTemplateID		= DealDetail. SubTemplateID
		,DlDtlEntityTemplateID	= DealDetail. EntityTemplateID
		,INCOTerm				= DynamicListBox. DynLstBxAbbv
		,DlDtlTpe				= DealUserDefinedGroup. UserDefinedGroupDesc
From	tmp_CustomAccountDetail					(NoLock)
		Inner Join	DealDetail					(NoLock)	On	tmp_CustomAccountDetail. DlHdrID	= DealDetail. DlDtlDlHdrID
															And	tmp_CustomAccountDetail. DlDtlID	= DealDetail. DlDtlID
		Inner Join	DynamicListBox				(NoLock)	On	DealDetail. DeliveryTermID		= convert(int, DynamicListBox. DynLstBxTyp)
															And	DynamicListBox. DynLstBxQlfr	= ''DealDeliveryTerm''
		Left Outer Join	DealUserDefinedGroup	(NoLock)	On	DealDetail. SubType				= DealUserDefinedGroup. UserDefinedGroupCd													
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
----------------------------------------------------------------------------------------------------------------------
-- Block 50: Set the values from the Movement architecture
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Set the Movement Header values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		MvtHdrTmplteID		= MovementHeader. MvtHdrTmplteID
		,MvtHdrTyp			= MovementHeader. MvtHdrTyp
		,MvtHdrTypName		= MovementHeaderType. Name
		,MvtHdrLcleID		= MovementHeader. MvtHdrLcleID
		,MvtHdrOrgnLcleID	= MovementHeader. MvtHdrOrgnLcleID
		,MvtHdrDstntnLcleID	= MovementHeader. MvtHdrDstntnLcleID
		,VhcleID			= MovementHeader. MvtHdrVhcleID
		,MvtDcmntID			= MovementHeader. MvtHdrMvtDcmntID
		,SpecificGravity	= MovementHeader. MvtHdrGrvty
		-- ,VATDscrptnID		= MovementHeader. VATDscrptnID	
		,BDNNo				= MovementHeader. Text1
From	tmp_CustomAccountDetail				(NoLock)
		Inner Join	MovementHeader			(NoLock)	On	tmp_CustomAccountDetail. MvtHdrID	= MovementHeader. MvtHdrID  
		Left Outer Join	MovementHeaderType	(NoLock)	On	MovementHeader. MvtHdrTyp		= MovementHeaderType. MvtHdrTyp
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Set the Specific Gravity value for those items that didn't come through the movement architecture
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		SpecificGravity		= Product. PrdctSpcfcGrvty
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	Product			(NoLock)	On	tmp_CustomAccountDetail. ChildPrdctID	= Product. PrdctID
Where	IsNull(tmp_CustomAccountDetail. SpecificGravity, 1.0)	= 1			
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Movement Document values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		 MvtDcmntExtrnlDcmntNbr				= MovementDocument. MvtDcmntExtrnlDcmntNbr
		,MvtDcmntTmplteID					= MovementDocument. MvtDcmntTmplteID
		,MvtDcmntEntityTemplateID			= MovementDocument. EntityTemplateID
		,MvtDcmntUserInterfaceTemplateID	= MovementDocument. UserInterfaceTemplateID
From	tmp_CustomAccountDetail			(NoLock)
		Inner Join	MovementDocument	(NoLock)	On	tmp_CustomAccountDetail. MvtDcmntID		= MovementDocument. MvtDcmntID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the MvtHdrLocation value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		MvtHdrLocation			= Locale. LcleNme + IsNull(Locale. LcleNmeExtension, '''')
From	tmp_CustomAccountDetail	(NoLock)
		Inner Join	Locale		(NoLock)	On	tmp_CustomAccountDetail. MvtHdrLcleID	= Locale. LcleID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the MvtHdrLocation value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		MvtHdrOrigin			= Locale. LcleNme + IsNull(Locale. LcleNmeExtension, '''')
From	tmp_CustomAccountDetail					(NoLock)
		Left Outer Join Locale					(NoLock)	On	tmp_CustomAccountDetail. MvtHdrOrgnLcleID	= Locale. LcleID		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Determine the MvtHdrDestination value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		MvtHdrDestination		= Locale. LcleNme + IsNull(Locale. LcleNmeExtension, '''')
From	tmp_CustomAccountDetail						(NoLock)
		Left Outer Join		Locale					(NoLock)	On	tmp_CustomAccountDetail. MvtHdrDstntnLcleID	= Locale. LcleID		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
----------------------------------------------------------------------------------------------------------------------
-- Set the Vhcle value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		Vhcle				= Vehicle. VhcleNme
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	Vehicle (NoLock)	On	tmp_CustomAccountDetail.VhcleID	= Vehicle. VhcleID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
----------------------------------------------------------------------------------------------------------------------
-- Set the VhcleNumber value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		VhcleNumber			= Coalesce(VehicleVessel. IMONumber, VehicleBarge. IMONumber) 
From	tmp_CustomAccountDetail				(NoLock)
		Left Outer Join	VehicleVessel		(NoLock)	On	tmp_CustomAccountDetail. VhcleID				= VehicleVessel. VhcleVsslVhcleID
		Left Outer Join	VehicleBarge		(NoLock)	On	tmp_CustomAccountDetail. VhcleID				= VehicleBarge. VhcleBrgeVhcleID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Set the Temperature values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		 Temperature		= MovementHeaderTemperatureMeasurement. Temperature 
		,TemperatureScale	= MovementHeaderTemperatureMeasurement. TemperatureScale 
From	tmp_CustomAccountDetail									(NoLock)
		Inner Join		MovementHeaderTemperatureMeasurement	(NoLock)	On	tmp_CustomAccountDetail. MvtHdrID	= MovementHeaderTemperatureMeasurement. MvtHdrID 																
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Tax Currency values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		TaxFXFromCurrency		= FromCurrency. CrrncySmbl
		,TaxFXToCurrency		= ToCurrency. CrrncySmbl
From	tmp_CustomAccountDetail	(NoLock)						
		Left Outer Join	Currency	FromCurrency	(NoLock)	On	tmp_CustomAccountDetail. TaxFXFromCurrencyID	= FromCurrency. CrrncyID 
		Left Outer Join	Currency	ToCurrency		(NoLock)	On	tmp_CustomAccountDetail. TaxFXToCurrencyID		= ToCurrency. CrrncyID				
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the API value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		 API	= Convert(float,(141.5 / Case When SpecificGravity = 0 Then 1 Else SpecificGravity End  ) - 131.5)															
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Block 50: Quantity Conversions
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Set the BaseQuantity value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Update	tmp_CustomAccountDetail
Set		BaseQuantity	=	Quantity * v_UOMConversion.ConversionFactor / 
										Case	v_UOMConversion. FromUOMTpe + v_UOMConversion. ToUOMTpe
												When	''WV''
														Then	Case When Convert(Float,tmp_CustomAccountDetail. SpecificGravity) <> 0.0 Then Convert(Float,tmp_CustomAccountDetail. SpecificGravity) Else 1.0 End
												When	''VW''
														Then	1.0 / Case When Convert(Float,tmp_CustomAccountDetail. SpecificGravity) <> 0.0 Then Convert(Float,tmp_CustomAccountDetail. SpecificGravity) Else 1.0 End
												Else	1.0
										End									
From	tmp_CustomAccountDetail		(NoLock)											
		Inner Join v_UOMConversion	(NoLock)	On	v_UOMConversion. FromUOM	= 3		
												And v_UOMConversion. ToUOM		= ' + convert(varchar,@i_BaseUOMID) + '	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Set the InvoiceQuantity value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '
Update	tmp_CustomAccountDetail
Set		InvoiceQuantity	=	Quantity * v_UOMConversion.ConversionFactor / 
										Case	v_UOMConversion. FromUOMTpe + v_UOMConversion. ToUOMTpe
												When	''WV''
														Then	Case When Convert(Float,tmp_CustomAccountDetail. SpecificGravity) <> 0.0 Then Convert(Float,tmp_CustomAccountDetail. SpecificGravity) Else 1.0 End
												When	''VW''
														Then	1.0 / Case When Convert(Float,tmp_CustomAccountDetail. SpecificGravity) <> 0.0 Then Convert(Float,tmp_CustomAccountDetail. SpecificGravity) Else 1.0 End
												Else	1.0
										End									
From	tmp_CustomAccountDetail		(NoLock)											
		Inner Join v_UOMConversion	(NoLock)	On	v_UOMConversion. FromUOM	= 3		
												And v_UOMConversion. ToUOM		= tmp_CustomAccountDetail. InvoiceUOMID	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Block 60: Set the values from the Scheduling architecture
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Set the OBID
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		OBID			= PlannedTransfer. PlnndTrnsfrObID
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	PlannedTransfer	(NoLock)	On	tmp_CustomAccountDetail. PlnndTrnsfrID	= PlannedTransfer. PlnndTrnsfrID
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
-- Determine the PLNNDMVTBTCHID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		PlnndMvtBtchID				= PlannedMovementBatch. PlnndMvtBtchID
		,PlnndMvtBtchNme			= PlannedMovementBatch. Name
From	tmp_CustomAccountDetail									(NoLock)
		Inner Join	PlannedMovement							(NoLock)	On	tmp_CustomAccountDetail. PlnndMvtID						= PlannedMovement. PlnndMvtID
		Inner Join	PlannedMovementInPlannedMovementBatch	(NoLock)	On	PlannedMovement. PlnndMvtID								= PlannedMovementInPlannedMovementBatch. PlnndMvtID	
		Inner Join	PlannedMovementBatch					(NoLock)	On	PlannedMovementInPlannedMovementBatch. PlnndMvtBtchID	= PlannedMovementBatch. PlnndMvtBtchID
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Determine the TRANSSHIPMENTID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		TransShipmentID				= Transshipment. TransshipmentId
		,TransShipmentNm			= Transshipment. TransshipmentNm
From	tmp_CustomAccountDetail			(NoLock)
		Inner Join	VoyageAssn		(NoLock)	On	tmp_CustomAccountDetail. PlnndMvtBtchID	= VoyageAssn. VoyageId
		Inner Join	Transshipment	(NoLock)	On	VoyageAssn. TransshipmentId				= Transshipment. TransshipmentId  	 	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Block 70: Set the values from the Deal Detail Provision architecture
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Set the DlDtlPrvsnID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		DlDtlPrvsnID				= TransactionDetail. XDtlDlDtlPrvsnID
		,TransactionDetailID		= TransactionDetail. TransactionDetailID
		,XHdrID						= TransactionDetailLog. XDtlLgXDtlXHdrID
From	tmp_CustomAccountDetail					(NoLock)
		Inner Join	TransactionDetailLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlID					= TransactionDetailLog. XDtlLgAcctDtlID
		Inner Join	TransactionDetail		(NoLock)	On	TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID	= TransactionDetail. XDtlDlDtlPrvsnID
														And	TransactionDetailLog. XDtlLgXDtlXHdrID			= TransactionDetail. XDtlXHdrID 
														And	TransactionDetailLog. XDtlLgXDtlID				= TransactionDetail. XDtlID	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

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
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Set the DealDetail Provision values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		DlDtlPrvsnCostType			= DealDetailProvision. CostType
		,DlDtlPrvsnActual			= DealDetailProvision. Actual
		,DlDtlPrvsnDecimalPlaces	= DealDetailProvision. DecimalPlaces
		,PrvsnID					= DealDetailProvision. DlDtlPrvsnPrvsnID
		,PrvsnDscrptn				= Prvsn. PrvsnDscrptn 
From	tmp_CustomAccountDetail			(NoLock)
		Inner Join	DealDetailProvision	(NoLock)	On	tmp_CustomAccountDetail. DlDtlPrvsnID		= DealDetailProvision. DlDtlPrvsnID
		Inner Join	Prvsn				(NoLock)	On	DealDetailProvision. DlDtlPrvsnPrvsnID	= Prvsn. PrvsnID	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the Is Deemed value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsDeemed		= 1
From	tmp_CustomAccountDetail				(NoLock)
		Inner Join	DealDetailProvisionRow	(NoLock)	On	tmp_CustomAccountDetail. DlDtlPrvsnID									= DealDetailProvisionRow. DlDtlPrvsnID
														And	DealDetailProvisionRow. DlDtlPRvsnRwTpe								= ''F''
														And	RTrim(LTrim(IsNull(DealDetailProvisionRow. PriceAttribute32,'''')))	<> ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the RowText value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		RowText		= DealDetailProvisionRow.RowText
From	tmp_CustomAccountDetail				(NoLock)
		Inner Join	DealDetailProvisionRow	(NoLock)	On	tmp_CustomAccountDetail. DlDtlPrvsnID							= DealDetailProvisionRow. DlDtlPrvsnID
														And	RTrim(LTrim(IsNull(DealDetailProvisionRow. RowText,'''')))	<> ''''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- refresh the index
----------------------------------------------------------------------------------------------------------------------
If @c_OnlyShowSQL = 'Y'
	Print '	
	UPDATE STATISTICS tmp_CustomAccountDetail
'
Else
	UPDATE STATISTICS tmp_CustomAccountDetail

----------------------------------------------------------------------------------------------------------------------
-- Set the MvtExpnseID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		MvtExpnseID				= MovementExpenseLog. MvtExpnseLgMvtExpnseID
From	tmp_CustomAccountDetail			(NoLock)
		Inner Join	MovementExpenseLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlSrceID		= MovementExpenseLog. MvtExpnseLgID
													And	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''M''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the MnlLdgrEntryID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		MnlLdgrEntryID				= ManualLedgerEntryLog. MnlLdgrEntryID
From	tmp_CustomAccountDetail				(NoLock)
		Inner Join	ManualLedgerEntryLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlSrceID		= ManualLedgerEntryLog. MnlLdgrEntryLgID
														And	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''ML''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the TxDtlID value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		TxDtlID					= TaxDetailLog. TxDtlLgTxDtlID
From	tmp_CustomAccountDetail		(NoLock)
		Inner Join	TaxDetailLog	(NoLock)	On	tmp_CustomAccountDetail. AcctDtlSrceID		= TaxDetailLog. TxDtlLgID
												And	tmp_CustomAccountDetail. AcctDtlSrceTble	= ''T''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the IsPrimary values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsPrimary			= 1
Where	tmp_CustomAccountDetail. DlDtlPrvsnCostType	= ''P''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the IsPrimary values - Circles
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsPrimary			= 1
Where	tmp_CustomAccountDetail. PrvsnDscrptn	Like ''%Circle%''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the IsPrimary values - COGS
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsPrimary			= 1
Where	tmp_CustomAccountDetail. TrnsctnTypDesc	Like ''%COGS%''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the IsWriteOff values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsWriteOff		= 1
		,IsPrimary		= 0
Where	AcctDtlSrceTble	= ''P''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the IsAdjustment values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsAdjustment	= 1
		,IsWriteOff		= 0
		,IsPrimary		= 0
From	tmp_CustomAccountDetail				(NoLock)
		Inner Join	GeneralConfiguration	(NoLock)	On	tmp_CustomAccountDetail. PrvsnID			= GeneralConfiguration. GnrlCnfgHdrID
														And	GeneralConfiguration. GnrlCnfgTblNme	= ''Prvsn''
														And	GeneralConfiguration. GnrlCnfgQlfr		= ''Prvsn Adjustment''
														And	GeneralConfiguration. GnrlCnfgMulti		= ''Y''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the IsPrepayment values -- Change to Transaction Group ?
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		 IsPrepayment	= 1
		,IsAdjustment	= 0
		,IsWriteOff		= 0
		,IsPrimary		= 0
Where	TrnsctnTypDesc	Like ''%Prepayment%''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the IsProvisional values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		 IsProvisional	= 1
		,IsPrepayment	= 0
		,IsAdjustment	= 0
		,IsWriteOff		= 0
		,IsPrimary		= 0
Where	tmp_CustomAccountDetail. DlDtlPrvsnActual	In (''I'',''N'')
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the IsTax value - Transaction Group
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsTax			= 1
		,IsProvisional	= 0
		,IsPrepayment	= 0
		,IsAdjustment	= 0
		,IsWriteOff		= 0
		,IsPrimary		= 0
From	tmp_CustomAccountDetail				(NoLock)
		Inner Join	TransactionTypeGroup	(NoLock)	On	tmp_CustomAccountDetail. TrnsctnTypID	= TransactionTypeGroup. XTpeGrpTrnsctnTypID
														And	TransactionTypeGroup. XTpeGrpXGrpID	= ' + convert(varchar,IsNull(@i_Tax_XGrpID,0)) + '
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Set the IsSecondary values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsSecondary	= 1																						
Where	IsPrimary		<> 1
And		IsPrepayment	<> 1
And		IsProvisional	<> 1
And		IsAdjustment	<> 1 
And		IsTax			<> 1 
And		IsWriteOff		<> 1 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Block 80: Invoice Type
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Set the Quantity fields to 0 for Secondaries, Prepays, Adjustments, Taxes, and Write Offs
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		BaseQuantity		= 0
		,BaseUOMID			= Null
		,BaseUOM			= Null
		,XRefUOM			= Null
		,InvoiceQuantity	= 0
		-- ,InvoiceUOMID		= Null
		-- ,InvoiceUOM			= Null	
Where	(IsSecondary	= 1	
Or		IsPrepayment	= 1
Or		IsAdjustment	= 1
Or		IsTax			= 1
Or		IsWriteOff		= 1)		

'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)


----------------------------------------------------------------------------------------------------------------------
-- Swap Quantities ?
----------------------------------------------------------------------------------------------------------------------

If	@vc_Source	In ('SH', 'PH')
	Begin	
		----------------------------------------------------------------------------------------------------------------------
		-- Set the InvoiceLineType value - Sales Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceLineType		=	Case	
											When	InvoiceAmount	> 0	Then ''01''
											Else	''11''
										End
		From	tmp_CustomAccountDetail		(NoLock)
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''SH''			
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the InvoiceLineType value - Sales Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		InvoiceLineType		=	Case	
											When	InvoiceAmount	> 0	Then ''31''
											Else	''21''
										End
		From	tmp_CustomAccountDetail		(NoLock)
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''PH''			
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

----------------------------------------------------------------------------------------------------------------------
-- Set the IsPrimary values - Circles
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		IsPrimary			= 0
		,IsSecondary		= 1
Where	tmp_CustomAccountDetail. PrvsnDscrptn	Like ''%Circle%''
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)		
	
---------------------------------------------------------------------------------------------------------------------
-- Determine the InvoiceLineDescription value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		InvoiceLineDescription		= Case
										When	IsPrepayment		= 1										Then	ChildPrdctNme + '' Prepayment''
										When	IsProvisional		= 1										Then	ChildPrdctNme + '' Provisional Payment''
										When	IsPrimary = 1 And IsProvisional = 0 And IsPrepayment = 0	Then	ChildPrdctNme 
										When	IsAdjustment		= 1										Then	ChildPrdctNme
										When	IsSecondary			= 1										Then	Coalesce(PrvsnDscrptn, TrnsctnTypDesc)
										Else	TrnsctnTypDesc
									  End
From	tmp_CustomAccountDetail	(NoLock)
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	

----------------------------------------------------------------------------------------------------------------------
-- Block 100: Set the values from the Credit Center architecture
----------------------------------------------------------------------------------------------------------------------
/*
If	@c_OnlyShowSQL <> 'Y'
	Begin
	
		If	@vc_Source	In ('SH','PH')
			Begin	
	
				Select	@i_RowID	= Min(ID)
				From	tmp_CustomAccountDetail	(NoLock)
				Where	(tmp_CustomAccountDetail. IsPrimary	= 1
				Or		tmp_CustomAccountDetail. IsPrepayment	= 1
				Or		tmp_CustomAccountDetail. IsProvisional	= 1)

				While	@i_RowID	Is Not Null
						Begin		

							Select	@i_Ex_BAID			= InvoiceExtBAID
									,@c_Direction		= Case 
																When	InterfaceSource = 'SH' Then	'I' 
																When	InterfaceSource = 'PH' Then	'O'  
														  End
									,@i_DlHdrID			= DLHDRID
									,@i_DlDtlID			= DLDTLID
									,@i_ObID			= OBID
									,@i_PlnndTrnsfrID	= PLNNDTRNSFRID
									,@i_PlnndMvtID		= PLNNDMVTID
									,@i_MvtHdrID		= MVTHDRID
									,@vc_Instruments	= NULL
									,@vc_Banks			= NULL
							From	tmp_CustomAccountDetail	(NoLock)
							Where	tmp_CustomAccountDetail. ID	= @i_RowID	
							
							Execute	dbo.Custom_Invoice_Template_Credit_Instrument	@i_Ex_BAID
																					,@c_Direction
																					,@i_DlHdrID
																					,@i_DlDtlID
																					,@i_ObID
																					,@i_PlnndTrnsfrID
																					,@i_PlnndMvtID
																					,@i_MvtHdrID
																					,@vc_Instruments	OUTPUT	
																					,@vc_Banks			OUTPUT		
																		
							Update	tmp_CustomAccountDetail
							Set		FinanceSecurity		= Substring(@vc_Instruments, 0, 80)
									,FinanceBank		= Substring(@vc_Banks, 0, 100)
									,FinanceIssueDate	= NULL
							Where	tmp_CustomAccountDetail. ID = @i_RowID
							
							Select	@i_RowID	= Min(ID)
							From	tmp_CustomAccountDetail	(NoLock)
							Where	tmp_CustomAccountDetail. ID > @i_RowID
							And		(tmp_CustomAccountDetail. IsPrimary	= 1
							Or		tmp_CustomAccountDetail. IsPrepayment	= 1
							Or		tmp_CustomAccountDetail. IsProvisional	= 1)
							
					End				
			End
	End


----------------------------------------------------------------------------------------------------------------------
-- Override the FinanceSecurity value if needed
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		FinanceSecurity		= IsNull(CustomInvoiceHeader. NewLCNumber, tmp_CustomAccountDetail. FinanceSecurity)
From	tmp_CustomAccountDetail						(NoLock)
		Left Outer Join		CustomInvoiceHeader		(NoLock)	On	tmp_CustomAccountDetail. RAInvoiceID			= CustomInvoiceHeader. SlsInvceHdrID
																And	tmp_CustomAccountDetail. InterfaceSource		= CustomInvoiceHeader. InvoiceType			
Where	tmp_CustomAccountDetail. InterfaceSource	In (''SH'',''PH'')	
And		IsNull(CustomInvoiceHeader. NewLCNumber, tmp_CustomAccountDetail. FinanceSecurity) <> IsNull(tmp_CustomAccountDetail. FinanceSecurity,'''')
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Override the FinanceBank value if needed
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		FinanceBank		= IsNull(CustomInvoiceHeader. NewIssuingBank, tmp_CustomAccountDetail. FinanceBank)
From	tmp_CustomAccountDetail						(NoLock)
		Left Outer Join		CustomInvoiceHeader		(NoLock)	On	tmp_CustomAccountDetail. RAInvoiceID			= CustomInvoiceHeader. SlsInvceHdrID
																And	tmp_CustomAccountDetail. InterfaceSource		= CustomInvoiceHeader. InvoiceType			
Where	tmp_CustomAccountDetail. InterfaceSource	In (''SH'',''PH'')	
And		IsNull(CustomInvoiceHeader. NewIssuingBank, tmp_CustomAccountDetail. FinanceBank) <> IsNull(tmp_CustomAccountDetail. FinanceBank, '''')
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Override the FinanceIssueDate value if needed
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		FinanceIssueDate		= IsNull(CustomInvoiceHeader. NewIssuingDate, tmp_CustomAccountDetail. FinanceIssueDate)
From	tmp_CustomAccountDetail						(NoLock)
		Left Outer Join		CustomInvoiceHeader		(NoLock)	On	tmp_CustomAccountDetail. RAInvoiceID			= CustomInvoiceHeader. SlsInvceHdrID
																And	tmp_CustomAccountDetail. InterfaceSource		= CustomInvoiceHeader. InvoiceType			
Where	tmp_CustomAccountDetail. InterfaceSource	In (''SH'',''PH'')	
And		IsNull(CustomInvoiceHeader. NewIssuingDate, tmp_CustomAccountDetail. FinanceIssueDate) <> IsNull(tmp_CustomAccountDetail. FinanceIssueDate, ''1990-01-01'')
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
*/

----------------------------------------------------------------------------------------------------------------------
-- Block 120: VAT
----------------------------------------------------------------------------------------------------------------------

Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		PriorPeriod	= ''Y''
Where	tmp_CustomAccountDetail. AccntngPrdID	< ' + convert(varchar,@i_OpenAccntngPrdID) + '
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Set the DebitAccount value
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		DebitAccount		= DebitAC. AcctDtlAcctCdeCde
From	tmp_CustomAccountDetail					(NoLock)
		Inner Join	AccountDetailAccountCode DebitAC	(NoLock)
			On	tmp_CustomAccountDetail. AcctDtlID		= DebitAC. AcctDtlAcctCdeAcctDtlID  
			And	DebitAC. AcctDtlAcctCdeBlnceTpe		= ''D''	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		CreditAccount		= CreditAC. AcctDtlAcctCdeCde
From	tmp_CustomAccountDetail					(NoLock)
		Inner Join	AccountDetailAccountCode CreditAC	(NoLock)
			On	tmp_CustomAccountDetail. AcctDtlID		= CreditAC. AcctDtlAcctCdeAcctDtlID  
			And	CreditAC. AcctDtlAcctCdeBlnceTpe	= ''C''	
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
If	@vc_Source	In ('SH', 'PH')
	Begin	
		----------------------------------------------------------------------------------------------------------------------
		-- Set the CreditAccount value - Sales Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
			Set	CreditValue	=	Case
									When	NetValue	< 0	Then 0
									Else	NetValue
								End 				
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''SH''		
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the CreditAccount value - Payable Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
			Set	CreditValue	=	Case
									When	NetValue	< 0	Then NetValue
									Else	0
								End 				
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''PH''		
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the DebitValue value - Sales Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		DebitValue	=	Case
									When	NetValue	< 0	Then NetValue
									Else	0	
								End					 
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''SH''		
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the DebitValue value - Sales Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		DebitValue	=	Case
									When	NetValue	< 0	Then 0
									Else	NetValue
								End					 
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''PH''		
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the Lccal values - Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		LocalDebitValue		= IsNull(LocalFXRate,1.0) * DebitValue	
				,LocalCreditValue	= IsNull(LocalFXRate,1.0) * CreditValue	
				,LocalValue			= IsNull(LocalFXRate,1.0) * NetValue				 
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''SH'',''PH'')		
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

----------------------------------------------------------------------------------------------------------------------
-- Set the Lccal values
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		LocalValue			= IsNull(LocalFXRate,1.0) *	NetValue				 
Where	tmp_CustomAccountDetail. InterfaceSource	= ''GL''		
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

If	@vc_Source	In ('SH', 'PH')
	Begin	
		----------------------------------------------------------------------------------------------------------------------
		-- Set the GLLineType value - Sales Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		GLLineType		=	Case	
											When	NetValue	>= 0	Then ''50''
											Else	''40''
										End
		From	tmp_CustomAccountDetail		(NoLock)
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''SH''			
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the GLLineType value - Payaable Invoices
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		GLLineType		=	Case	
											When	NetValue	>= 0	Then ''40''
											Else	''50''
										End
		From	tmp_CustomAccountDetail		(NoLock)
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''PH''			
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the ReceiptRefundFlag value - Sales
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		ReceiptRefundFlag	=	Case	
											When	NetValue	>= 0	Then ''AR''
											Else	''AP''
										End
		From	tmp_CustomAccountDetail		(NoLock)
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''SH''			
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the ReceiptRefundFlag value - Purchases
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		ReceiptRefundFlag	=	Case	
											When	NetValue	>= 0	Then ''AP''
											Else	''AR''
										End
		From	tmp_CustomAccountDetail		(NoLock)
		Where	tmp_CustomAccountDetail. InterfaceSource	= ''PH''			
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the HighestValue value - No taxes
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		HighestValue	= ''Y''
		Where	tmp_CustomAccountDetail.InterfaceSource	In (''SH'',''PH'')
		And		tmp_CustomAccountDetail.IsTax				<> 1
		And		Not Exists	(
							Select	1
							From	tmp_CustomAccountDetail Sub (NoLock)
							Where	Sub.InterfaceMessageID		= tmp_CustomAccountDetail.InterfaceMessageID
							And		Sub.IsTax					<> 1
							And		Sub.NetValue				> tmp_CustomAccountDetail.NetValue
							)
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

		----------------------------------------------------------------------------------------------------------------------
		-- Set the HighestValue value - No taxes
		----------------------------------------------------------------------------------------------------------------------
		Select	@vc_DynamicSQL	= '	
		Update	tmp_CustomAccountDetail
		Set		HighestValue	= ''Y''
		Where	tmp_CustomAccountDetail. InterfaceSource	In (''SH'',''PH'')
		And		Not Exists	(
							Select	1
							From	tmp_CustomAccountDetail Sub (NoLock)
							Where	Sub.InterfaceMessageID		= tmp_CustomAccountDetail.InterfaceMessageID
							And		Sub.NetValue				> tmp_CustomAccountDetail.NetValue
							)
		And		Not Exists	(
							Select	1
							From	tmp_CustomAccountDetail Sub2 (NoLock)
							Where	Sub2.InterfaceMessageID		= tmp_CustomAccountDetail.InterfaceMessageID
							And		Sub2.IsTax					<> 1
							)
		'

		If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)
	End

----------------------------------------------------------------------------------------------------------------------
-- Block 130: Write Off Transactions
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
-- Determine the IS_WRITE_OFF values - Pass 1 Find a Primary Cost
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		WriteOffParentAcctDtlID	= (	Select	Top 1 AcctDtlID
									From	tmp_CustomAccountDetail Sub	(NoLock)
									Where	Sub.IsPrimary	= 1
									And		Sub.InterfaceMessageID	= tmp_CustomAccountDetail.InterfaceMessageID
									Order By NetValue Desc)		
Where	tmp_CustomAccountDetail. IsWriteOff	= 1
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	-- jvHERE

----------------------------------------------------------------------------------------------------------------------
-- Determine the IS_WRITE_OFF values - Pass 2 No Primary Cost Exists
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	tmp_CustomAccountDetail
Set		WriteOffParentAcctDtlID		= (	Select	Top 1 AcctDtlID
										From	tmp_CustomAccountDetail Sub	(NoLock)
										Where	IsWriteOff	= 0
										And		Sub.InterfaceMessageID	= tmp_CustomAccountDetail.InterfaceMessageID
										Order By NetValue Desc)		
Where	tmp_CustomAccountDetail. IsWriteOff				= 1
And		tmp_CustomAccountDetail. WriteOffParentAcctDtlID	Is Null 
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)	-- jvHERE

----------------------------------------------------------------------------------------------------------------------
-- Determine the IsWriteOff values from the Parent Transaction
----------------------------------------------------------------------------------------------------------------------
Select	@vc_DynamicSQL	= '	
Update	WriteOffAccountDetail
Set		 WriteOffAccountDetail. InvoiceTrmID			= ParentAccountDetail. InvoiceTrmID 
		,WriteOffAccountDetail. InvoiceTrmAbbrvtn		= ParentAccountDetail. InvoiceTrmAbbrvtn
		,WriteOffAccountDetail. XRefTrmCode				= ParentAccountDetail. XRefTrmCode 
		,WriteOffAccountDetail. StrtgyID				= ParentAccountDetail. StrtgyID  
		,WriteOffAccountDetail. StrtgyNme				= ParentAccountDetail. StrtgyNme 
		,WriteOffAccountDetail. TaxCode					= ParentAccountDetail. TaxCode 
		,WriteOffAccountDetail. DebitAccount			= ParentAccountDetail. DebitAccount
		,WriteOffAccountDetail. CreditAccount			= ParentAccountDetail. CreditAccount
		,WriteOffAccountDetail. XRefDocumentType		= ParentAccountDetail. XRefDocumentType
		,WriteOffAccountDetail. DlHdrID					= ParentAccountDetail. DlHdrID
		,WriteOffAccountDetail. DlHdrIntrnlNbr			= ParentAccountDetail. DlHdrIntrnlNbr
		,WriteOffAccountDetail. DlHdrDsplyDte			= ParentAccountDetail. DlHdrDsplyDte
		,WriteOffAccountDetail. DlDtlID					= ParentAccountDetail. DlDtlID
		,WriteOffAccountDetail. INCOTerm				= ParentAccountDetail. INCOTerm
		,WriteOffAccountDetail. FinanceSecurity			= ParentAccountDetail. FinanceSecurity
		,WriteOffAccountDetail. PlnndTrnsfrID			= ParentAccountDetail. PlnndTrnsfrID
		,WriteOffAccountDetail. PlnndMvtID				= ParentAccountDetail. PlnndMvtID
		,WriteOffAccountDetail. PlnndMvtNme				= ParentAccountDetail. PlnndMvtNme
		,WriteOffAccountDetail. PlnndMvtBtchID			= ParentAccountDetail. PlnndMvtBtchID
		,WriteOffAccountDetail. PlnndMvtBtchNme			= ParentAccountDetail. PlnndMvtBtchNme
		,WriteOffAccountDetail. TransShipmentID			= ParentAccountDetail. TransShipmentID
		,WriteOffAccountDetail. TransShipmentNm			= ParentAccountDetail. TransShipmentNm
		,WriteOffAccountDetail. MvtDcmntExtrnlDcmntNbr	= ParentAccountDetail. MvtDcmntExtrnlDcmntNbr
		,WriteOffAccountDetail. MvtHdrOrigin			= ParentAccountDetail. MvtHdrOrigin 
		,WriteOffAccountDetail. MvtHdrDestination		= ParentAccountDetail. MvtHdrDestination
		,WriteOffAccountDetail. MvtHdrLocation 			= ParentAccountDetail. MvtHdrLocation
		,WriteOffAccountDetail. MvtHdrLcleID 			= ParentAccountDetail. MvtHdrLcleID
		,WriteOffAccountDetail. Vhcle					= ParentAccountDetail. Vhcle			
From	tmp_CustomAccountDetail				WriteOffAccountDetail	(NoLock)
		Inner Join	tmp_CustomAccountDetail	ParentAccountDetail		(NoLock)
			On	WriteOffAccountDetail. WriteOffParentAcctDtlID	= ParentAccountDetail. AcctDtlID		
Where	WriteOffAccountDetail. IsWriteOff	= 1
'

If @c_OnlyShowSQL = 'Y' Select @vc_DynamicSQL Else Execute (@vc_DynamicSQL)

----------------------------------------------------------------------------------------------------------------------
-- Block 140: Final inserts
----------------------------------------------------------------------------------------------------------------------	
If	@c_OnlyShowSQL <> 'Y' And @c_ReturnToInvoice = 'N'
	Begin
	
		Begin Transaction InsertCustomAD
		
			----------------------------------------------------------------------------------------------------------------------
			-- If we are reprocessing a GL entry remove the original entry
			----------------------------------------------------------------------------------------------------------------------			
			If	@b_GLReprocess = 1
				Delete	CustomAccountDetail
				Where	BatchID			= IsNull(@i_ID,0)
				And		GLType			= IsNull(@c_GLType,'Z')
				And		AcctDtlID		= IsNull(@i_AcctDtlID,0)
				And		InterfaceSource	= 'GL'	
				
			----------------------------------------------------------------------------------------------------------------------
			-- Insert the records into
			----------------------------------------------------------------------------------------------------------------------					
			Insert	CustomAccountDetail
					(InterfaceMessageID
					,InterfaceSource
					,RAInvoiceID
					,InterfaceInvoiceID
					,InvoiceNumber
					,InternalInvoiceNumber
					,InvoiceAmount
					,InvoiceAmountPaid
					,InvoiceCrrncyID
					,InvoiceCurrency
					,LocalCrrncyID
					,LocalCurrency
					,LocalFXRate			
					,InvoiceDate
					,InterfaceBookingDate
					,InterfaceBookingAccntngPrdID
					,InvoiceDueDate
					,InvoiceTrmID
					,InvoiceTrmAbbrvtn
					,XRefTrmCode
					,InvoiceIntBAID
					,InvoiceIntBANme
					,XRefIntBACode
					,InvoiceIntUserID
					,InvoiceIntUserDBMnkr
					,XRefIntUserCode
					,InvoiceIntBAOffceLcleID
					,XRefIntBAAddressCode
					,InvoiceIntBATaxCode
					,InvoiceIntBARegistration
					,InvoiceExtBAID
					,InvoiceExtBANme
					,XRefExtBACode
					,ExtBAClass
					,InvoiceExtCntctID
					,InvoiceExtBAOffceLcleID
					,XRefExtBAAddressCode
					,InvoiceExtBATaxCode
					,InvoicePaymentBankID
					,InvoicePaymentBank
					,XRefPaymentBankCode
					,InvoiceType
					,XRefDocumentType
					,InvoiceLineType
					,InvoicePerUnitDecimal
					,InvoiceQuantityDecimal
					,InvoiceRprtCnfgID
					,InvoiceParentInvoiceID
					,InvoiceParentInvoiceNumber
					,InvoiceParentInvoiceValue
					,InvoiceCreationDate
					,InvoiceCreationUserID
					,AcctDtlID
					,AcctDtlPrntID
					,AcctDtlSrceID
					,AcctDtlSrceTble
					,AccntngPrdID
					,PriorPeriod
					,Reversed
					,PayableMatchingStatus
					,WePayTheyPay
					,SupplyDemand
					,ReceiptRefundFlag
					,HighestValue
					,StrtgyID
					,StrtgyNme
					,TaxParentAcctDtlID
					,WriteOffParentAcctDtlID
					,AdjParentAcctDtlID
					,InternalBAID
					,InternalBANme
					,ExternalBAID
					,ExternalBANme
					,ParentPrdctID
					,ParentPrdctNme
					,XRefParentPrdctCode
					,ChildPrdctID
					,ChildPrdctNme
					,XRefChildPrdctCode
					,MaterialGroup
					,CmmdtyID
					,CmmdtyName
					,TrnsctnTypID
					,TrnsctnTypDesc
					,XRefTrnsctnTypCode
					,InvoiceLineDescription
					,NetValue
					,GrossValue
					,LocalValue	
					,CrrncyID
					,Currency
					,Quantity
					,SpecificGravity
					,BaseQuantity
					,BaseUOMID
					,BaseUOM
					,XRefUOM
					,InvoiceQuantity
					,InvoiceUOMID
					,InvoiceUOM
					,TransactionDate
					,VATDscrptnID
					,VATDescription
					,TaxCode
					,TaxRate
					,TaxFXDate
					,TaxFXConversionRate
					,TaxFXFromCurrencyID
					,TaxFXFromCurrency
					,TaxFXToCurrencyID					
					,TaxFXToCurrency
					,MvtHdrID
					,MvtHdrTmplteID
					,MvtHdrTyp
					,MvtHdrTypName
					,MvtHdrLcleID
					,MvtHdrLocation
					,MvtHdrOrgnLcleID
					,MvtHdrOrigin
					,MvtHdrDstntnLcleID
					,MvtHdrDestination
					,BDNNo
					,VhcleID
					,Vhcle
					,VhcleNumber
					,StorageLocation
					,Plant
					,MvtDcmntID
					,MvtDcmntExtrnlDcmntNbr
					,MvtDcmntTmplteID
					,MvtDcmntEntityTemplateID
					,MvtDcmntUserInterfaceTemplateID
					,Temperature
					,TemperatureScale
					,API
					,XHdrID
					,ObID
					,PlnndTrnsfrID
					,PlnndMvtID
					,PlnndMvtNme
					,PlnndMvtBtchID
					,PlnndMvtBtchNme
					,TransShipmentID
					,TransShipmentNm
					,DlHdrID
					,DlHdrIntrnlNbr
					,DlHdrExtrnlNbr
					,DlHdrDsplyDte
					,DlHdrTyp
					,DlHdrTmplteID
					,DlHdrSubTemplateID
					,DlHdrEntityTemplateID
					,DlHdrUserInterfaceTemplateID
					,ClearingBrokerID
					,ClearingBroker
					,ClearingBrokerAccount
					,IsClearPort
					,MasterAgreementID
					,MasterAgreementInternalNumber
					,MasterAgreementDate
					,DlDtlID
					,DlDtlTmplteID
					,DlDtlSubTemplateID
					,DlDtlEntityTemplateID
					,INCOTerm
					,DlDtlTpe
					,SalesOffice
					,DlDtlPrvsnID
					,DlDtlPrvsnCostType
					,DlDtlPrvsnActual
					,DlDtlPrvsnDecimalPlaces
					,DlDtlPrvsnRwID
					,RowText
					,PrvsnID
					,PrvsnDscrptn
					,IsPrimary
					,IsSecondary
					,IsPrepayment
					,IsProvisional
					,IsAdjustment
					,IsTax
					,IsWriteOff
					,TransactionDetailID
					,TmeXDtlIdnty
					,MvtExpnseID
					,MnlLdgrEntryID
					,TxDtlID
					,FixedFloat
					,IsDeemed									
					,PriceStartDate
					,PriceEndDate
					,FinanceSecurity
					,FinanceBank
					,FinanceIssueDate
					,CostCenter	
					,ProfitCenter					
					,DebitAccount
					,CreditAccount
					,DebitValue	
					,CreditValue	
					,LocalDebitValue	
					,LocalCreditValue
					,GLLineType
					,BatchID
					,RiskID
					,P_EODEstmtedAccntDtlID
					,GLType
					,PostingType
					,Comments
					,DefaultPerUnitDecimals
					,DefaultQtyDecimals
					,CreationDate)
			Select	 InterfaceMessageID					-- InterfaceMessageID
					,InterfaceSource					-- InterfaceSource
					,RAInvoiceID						-- RAInvoiceID
					,InterfaceInvoiceID					-- InterfaceInvoiceID
					,InvoiceNumber						-- InvoiceNumber
					,InternalInvoiceNumber				-- InternalInvoiceNumber
					,InvoiceAmount						-- InvoiceAmount
					,InvoiceAmountPaid					-- InvoiceAmountPaid
					,InvoiceCrrncyID					-- InvoiceCrrncyID
					,InvoiceCurrency					-- InvoiceCurrency
					,LocalCrrncyID						-- LocalCrrncyID
					,LocalCurrency						-- LocalCurrency
					,LocalFXRate						-- LocalFXRate
					,InvoiceDate						-- InvoiceDate
					,InterfaceBookingDate				-- InterfaceBookingDate
					,InterfaceBookingAccntngPrdID		-- InterfaceBookingAccntngPrdID
					,InvoiceDueDate						-- InvoiceDueDate
					,InvoiceTrmID						-- InvoiceTrmID
					,InvoiceTrmAbbrvtn					-- InvoiceTrmAbbrvtn
					,XRefTrmCode						-- XRefTrmCode
					,InvoiceIntBAID						-- InvoiceIntBAID
					,InvoiceIntBANme					-- InvoiceIntBANme
					,XRefIntBACode						-- XRefIntBACode
					,InvoiceIntUserID					-- InvoiceIntUserID
					,InvoiceIntUserDBMnkr				-- InvoiceIntUserDBMnkr
					,XRefIntUserCode					-- XRefIntUserCode
					,InvoiceIntBAOffceLcleID			-- InvoiceIntBAOffceLcleID
					,XRefIntBAAddressCode				-- XRefIntBAAddressCode
					,InvoiceIntBATaxCode				-- InvoiceIntBATaxCode
					,InvoiceIntBARegistration			-- InvoiceIntBARegistration
					,InvoiceExtBAID						-- InvoiceExtBAID
					,InvoiceExtBANme					-- InvoiceExtBANme
					,XRefExtBACode						-- XRefExtBACode
					,ExtBAClass							-- ExtBAClass 
					,InvoiceExtCntctID					-- InvoiceExtCntctID
					,InvoiceExtBAOffceLcleID			-- InvoiceExtBAOffceLcleID
					,XRefExtBAAddressCode				-- XRefExtBAAddressCode
					,InvoiceExtBATaxCode				-- InvoiceExtBATaxCode
					,InvoicePaymentBankID				-- InvoicePaymentBankID
					,InvoicePaymentBank					-- InvoicePaymentBank
					,XRefPaymentBankCode				-- XRefPaymentBankCode
					,InvoiceType						-- InvoiceType
					,XRefDocumentType					-- XRefDocumentType
					,InvoiceLineType					-- InvoiceLineType				
					,InvoicePerUnitDecimal				-- InvoicePerUnitDecimal
					,InvoiceQuantityDecimal				-- InvoiceQuantityDecimal
					,InvoiceRprtCnfgID					-- InvoiceRprtCnfgID
					,InvoiceParentInvoiceID				-- InvoiceParentInvoiceID
					,InvoiceParentInvoiceNumber			-- InvoiceParentInvoiceNumber
					,InvoiceParentInvoiceValue			-- InvoiceParentInvoiceValue
					,InvoiceCreationDate				-- InvoiceCreationDate
					,InvoiceCreationUserID				-- InvoiceCreationUserID
					,AcctDtlID							-- AcctDtlID
					,AcctDtlPrntID						-- AcctDtlPrntID
					,AcctDtlSrceID						-- AcctDtlSrceID
					,AcctDtlSrceTble					-- AcctDtlSrceTble
					,AccntngPrdID						-- AccntngPrdID
					,PriorPeriod						-- PriorPeriod
					,Reversed							-- Reversed
					,PayableMatchingStatus				-- PayableMatchingStatus
					,WePayTheyPay						-- WePayTheyPay
					,SupplyDemand						-- SupplyDemand
					,ReceiptRefundFlag					-- ReceiptRefundFlag
					,HighestValue						-- ReceiptRefundFlag
					,StrtgyID							-- StrtgyID
					,StrtgyNme							-- StrtgyNme
					,TaxParentAcctDtlID					-- TaxParentAcctDtlID
					,WriteOffParentAcctDtlID			-- WriteOffParentAcctDtlID
					,AdjParentAcctDtlID					-- AdjParentAcctDtlID
					,InternalBAID						-- InternalBAID
					,InternalBANme						-- InternalBANme
					,ExternalBAID						-- ExternalBAID
					,ExternalBANme						-- ExternalBANme
					,ParentPrdctID						-- ParentPrdctID
					,ParentPrdctNme						-- ParentPrdctNme
					,XRefParentPrdctCode				-- XRefParentPrdctCode
					,ChildPrdctID						-- ChildPrdctID
					,ChildPrdctNme						-- ChildPrdctNme
					,XRefChildPrdctCode					-- XRefChildPrdctCode
					,MaterialGroup						-- XRefChildPrdctCode
					,CmmdtyID							-- CmmdtyID
					,CmmdtyName							-- CmmdtyName
					,TrnsctnTypID						-- TrnsctnTypID
					,TrnsctnTypDesc						-- TrnsctnTypDesc
					,XRefTrnsctnTypCode					-- XRefTrnsctnTypCode
					,InvoiceLineDescription				-- InvoiceLineDescription
					,NetValue							-- NetValue
					,GrossValue							-- GrossValue
					,LocalValue							-- LocalValue
					,CrrncyID							-- CrrncyID
					,Currency							-- Currency
					,Quantity							-- Quantity
					,SpecificGravity					-- SpecificGravity
					,BaseQuantity						-- BaseQuantity
					,BaseUOMID							-- BaseUOMID
					,BaseUOM							-- BaseUOM
					,XRefUOM							-- XRefUOM
					,InvoiceQuantity					-- InvoiceQuantity
					,InvoiceUOMID						-- InvoiceUOMID
					,InvoiceUOM							-- InvoiceUOM
					,TransactionDate					-- TransactionDate
					,VATDscrptnID						-- VATDscrptnID
					,VATDescription						-- VATDescription
					,TaxCode							-- TaxCode
					,TaxRate							-- TaxRate
					,TaxFXDate							-- TaxFXDate
					,TaxFXConversionRate				-- TaxFXConversionRate
					,TaxFXFromCurrencyID				-- TaxFXFromCurrencyID
					,TaxFXFromCurrency					-- TaxFXFromCurrency
					,TaxFXToCurrencyID					-- TaxFXToCurrencyID					
					,TaxFXToCurrency					-- TaxFXToCurrency
					,MvtHdrID							-- MvtHdrID
					,MvtHdrTmplteID						-- MvtHdrTmplteID
					,MvtHdrTyp							-- MvtHdrTyp
					,MvtHdrTypName						-- MvtHdrTypName
					,MvtHdrLcleID						-- MvtHdrLcleID
					,MvtHdrLocation						-- MvtHdrLocation
					,MvtHdrOrgnLcleID					-- MvtHdrOrgnLcleID
					,MvtHdrOrigin						-- MvtHdrOrigin
					,MvtHdrDstntnLcleID					-- MvtHdrDstntnLcleID
					,MvtHdrDestination					-- MvtHdrDestination
					,BDNNo								-- BDNNo
					,VhcleID							-- VhcleID
					,Vhcle								-- Vhcle
					,VhcleNumber						-- VhcleNumber
					,StorageLocation					-- StorageLocation
					,Plant								-- Plant
					,MvtDcmntID							-- MvtDcmntID
					,MvtDcmntExtrnlDcmntNbr				-- MvtDcmntExtrnlDcmntNbr
					,MvtDcmntTmplteID					-- MvtDcmntTmplteID
					,MvtDcmntEntityTemplateID			-- MvtDcmntEntityTemplateID
					,MvtDcmntUserInterfaceTemplateID	-- MvtDcmntUserInterfaceTemplateID
					,Temperature						-- Temperature
					,TemperatureScale					-- TemperatureScale
					,API								-- API
					,XHdrID								-- XHdrID
					,ObID								-- ObID
					,PlnndTrnsfrID						-- PlnndTrnsfrID
					,PlnndMvtID							-- PlnndMvtID
					,PlnndMvtNme						-- PlnndMvtNme
					,PlnndMvtBtchID						-- PlnndMvtBtchID
					,PlnndMvtBtchNme					-- PlnndMvtBtchNme
					,TransShipmentID					-- TransShipmentID
					,TransShipmentNm					-- TransShipmentNm
					,DlHdrID							-- DlHdrID
					,DlHdrIntrnlNbr						-- DlHdrIntrnlNbr
					,DlHdrExtrnlNbr						-- DlHdrExtrnlNbr
					,DlHdrDsplyDte						-- DlHdrDsplyDte
					,DlHdrTyp							-- DlHdrTyp
					,DlHdrTmplteID						-- DlHdrTmplteID
					,DlHdrSubTemplateID					-- DlHdrSubTemplateID
					,DlHdrEntityTemplateID				-- DlHdrEntityTemplateID
					,DlHdrUserInterfaceTemplateID		-- DlHdrUserInterfaceTemplateID
					,ClearingBrokerID					-- ClearingBrokerID
					,ClearingBroker						-- ClearingBroker
					,ClearingBrokerAccount				-- ClearingBrokerAccount
					,IsClearPort						-- IsClearPort
					,MasterAgreementID					-- MasterAgreementID
					,MasterAgreementInternalNumber		-- MasterAgreementInternalNumber
					,MasterAgreementDate
					,DlDtlID							-- DlDtlID
					,DlDtlTmplteID						-- DlDtlTmplteID
					,DlDtlSubTemplateID					-- DlDtlSubTemplateID
					,DlDtlEntityTemplateID				-- DlDtlEntityTemplateID
					,INCOTerm							-- INCOTerm
					,DlDtlTpe							-- DlDtlTpe
					,SalesOffice						-- SalesOffice	
					,DlDtlPrvsnID						-- DlDtlPrvsnID
					,DlDtlPrvsnCostType					-- DlDtlPrvsnCostType
					,DlDtlPrvsnActual					-- DlDtlPrvsnActual
					,DlDtlPrvsnDecimalPlaces			-- DlDtlPrvsnDecimalPlaces
					,DlDtlPrvsnRwID						-- DlDtlPrvsnRwID
					,RowText							-- RowText
					,PrvsnID							-- PrvsnID
					,PrvsnDscrptn						-- PrvsnDscrptn
					,IsPrimary							-- IsPrimary
					,IsSecondary						-- IsSecondary
					,IsPrepayment						-- IsPrepayment
					,IsProvisional						-- IsProvisional
					,IsAdjustment						-- IsAdjustment
					,IsTax								-- IsTax
					,IsWriteOff							-- IsWriteOff
					,TransactionDetailID				-- TransactionDetailID
					,TmeXDtlIdnty						-- TmeXDtlIdnty
					,MvtExpnseID						-- MvtExpnseID
					,MnlLdgrEntryID						-- MnlLdgrEntryID
					,TxDtlID							-- TxDtlID
					,FixedFloat							-- FixedFloat
					,IsDeemed							-- IsDeemed								
					,PriceStartDate						-- PriceStartDate
					,PriceEndDate						-- PriceEndDate
					,FinanceSecurity					-- FinanceSecurity
					,FinanceBank						-- FinanceBank
					,FinanceIssueDate					-- FinanceIssueDate
					,CostCenter							-- CostCenter
					,ProfitCenter						-- ProfitCenter					
					,DebitAccount						-- DebitAccount
					,CreditAccount						-- CreditAccount
					,DebitValue							-- DebitValue
					,CreditValue						-- CreditValue	
					,LocalDebitValue					-- LocalDebitValue
					,LocalCreditValue					-- LocalCreditValue	
					,GLLineType							-- LocalCreditValue	
					,BatchID							-- BatchID
					,RiskID								-- RiskID
					,P_EODEstmtedAccntDtlID				-- P_EODEstmtedAccntDtlID
					,GLType								-- GLType
					,PostingType						-- PostingType
					,Comments							-- Comments
					,DefaultPerUnitDecimals				-- DefaultPerUnitDecimals
					,DefaultQtyDecimals					-- DefaultQtyDecimals
					,@sdt_Date							-- CreationDate
			From	tmp_CustomAccountDetail	(NoLock)
			

			---------------------------------------------------------------------------------------------------------------------
			-- Check for Errors on the Insert
			----------------------------------------------------------------------------------------------------------------------
			If	@@error <> 0 
				Begin
					Rollback Transaction InsertCustomAD
					Truncate Table tmp_CustomAccountDetail
					Select	@vc_Error			= 'The Invoice Interface - Map Account Detail procedure encountered an error inserting a record into the CustomAccountDetail table.' 
					Raiserror (60010,15,-1, @vc_Error	)
				End	
					

			----------------------------------------------------------------------------------------------------------------------------------
			-- Commit the Transaction
			----------------------------------------------------------------------------------------------------------------------------------
		Commit Transaction InsertCustomAD
		

		
		---------------------------------------------------------------------------------------------------------------------
		-- Call the client hook procedure to populate any custom attributes, etc.
		----------------------------------------------------------------------------------------------------------------------
		exec Custom_Interface_AD_Mapping_ClientHook	@i_ID
													,@i_MessageID
													,@vc_Source
													,@i_AccntngPrdID
													,@i_P_EODSnpShtID
													,@c_GLType
													,@i_AcctDtlID
													,@b_GLReprocess
													,@c_ReturnToInvoice
													,@c_OnlyShowSQL

		Truncate Table tmp_CustomAccountDetail

	End	
	
----------------------------------------------------------------------------------------------------------------------
-- Drop the temp table
----------------------------------------------------------------------------------------------------------------------	
If	Object_ID('TempDB..tmp_CustomAccountDetail') Is Not Null And @c_ReturnToInvoice = 'N'
	Drop Table tmp_CustomAccountDetail	

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
If OBJECT_ID('dbo.Custom_Interface_AD_Mapping') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_AD_Mapping >>>'
	Grant Execute on dbo.Custom_Interface_AD_Mapping to SYSUSER
	Grant Execute on dbo.Custom_Interface_AD_Mapping to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_AD_Mapping >>>'
GO