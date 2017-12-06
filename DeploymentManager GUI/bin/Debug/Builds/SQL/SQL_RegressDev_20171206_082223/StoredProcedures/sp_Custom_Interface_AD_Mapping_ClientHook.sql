If OBJECT_ID('dbo.Custom_Interface_AD_Mapping_ClientHook') Is Not NULL 
Begin
    DROP PROC dbo.Custom_Interface_AD_Mapping_ClientHook
    PRINT '<<< DROPPED PROC dbo.Custom_Interface_AD_Mapping_ClientHook >>>'
End
Go  

Create Procedure dbo.Custom_Interface_AD_Mapping_ClientHook
													 @i_ID				int				= NULL
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
-- Name:		Custom_Interface_AD_Mapping_ClientHook	 @i_ID = 5 , @vc_Source = 'SH', @c_OnlyShowSQL = 'Y'
-- Overview:	Created initially for Motiva.  Change this header & content depending on client needs
-- Arguments:		
-- SPs:
-- Temp Tables:
-- Created by:	Jeremy von Hoff
-- History:		15OCT2015 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set ANSI_NULLS ON
Set ANSI_PADDING ON
Set ANSI_Warnings ON
Set Quoted_Identifier OFF
Set Concat_Null_Yields_Null ON


Declare	 @vc_DynamicSQL					varchar(8000)
		,@vc_Error						varchar(255)


----------------------------------------------------------------------------------------------------------------------
-- Create the entry in the attribute table
----------------------------------------------------------------------------------------------------------------------
Insert	CustomAccountDetailAttribute (CADID)
Select	CustomAccountDetail.ID
From	CustomAccountDetail with (NoLock)
Where	Not Exists (Select 1 From CustomAccountDetailAttribute sub Where sub.CADID = CustomAccountDetail.ID)

----------------------------------------------------------------------------------------------------------------------
-- Update the ShipperSCAC
----------------------------------------------------------------------------------------------------------------------
Update	CustomAccountDetailAttribute
Set		ShipperSCAC = Left(GC.GnrlCnfgMulti, 4)
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join MovementHeader MH with (NoLock)
			on	MH.MvtHdrID			= CAD.MvtHdrID
		Inner Join GeneralConfiguration GC with (NoLock)
			on	GC.GnrlCnfgTblNme	= 'BusinessAssociate'
			and	GC.GnrlCnfgQlfr		= 'SCAC'
			and	GC.GnrlCnfgHdrID	= MH.MvtHdrCrrrBAID
Where	CustomAccountDetailAttribute.ShipperSCAC 	is null

----------------------------------------------------------------------------------------------------------------------
-- Update the MovementDate
----------------------------------------------------------------------------------------------------------------------
Update	CustomAccountDetailAttribute
Set		MovementDate = MH.MvtHdrDte
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join MovementHeader MH with (NoLock)
			on	MH.MvtHdrID			= CAD.MvtHdrID
Where	CustomAccountDetailAttribute.MovementDate	is null

----------------------------------------------------------------------------------------------------------------------
-- Update the Region Code
----------------------------------------------------------------------------------------------------------------------
Update	CustomAccountDetailAttribute
Set		RegionCode = substring(CAD.TrnsctnTypDesc, 7, 2)
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
Where	CustomAccountDetailAttribute.RegionCode is null
and		CAD.TrnsctnTypDesc	like 'Tax - %'
	
----------------------------------------------------------------------------------------------------------------------
-- Update the Discounting info
----------------------------------------------------------------------------------------------------------------------
Update	CustomAccountDetailAttribute
Set		DiscountDueDate = Coalesce(SIH.SlsInvceHdrDscntDte, PH.DiscountDate, NULL),
		DiscountAmount	= Coalesce(SIH.SlsInvceHdrDscntVle, PH.DiscountAmount, NULL)
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Left Outer Join SalesInvoiceHeader SIH with (NoLock)
			on	SIH.SlsInvceHdrID		= CAD.RAInvoiceID
			and	CAD.InterfaceSource		= 'SH'
		Left Outer Join PayableHeader PH with (NoLock)
			on	PH.PybleHdrID			= CAD.RAInvoiceID
			and	CAD.InterfaceSource		= 'PH'
Where	CustomAccountDetailAttribute.DiscountDueDate	is null

----------------------------------------------------------------------------------------------------------------------
-- Update the SAP info
----------------------------------------------------------------------------------------------------------------------
Update	CustomAccountDetailAttribute
Set		SAPCompanyCode = XREF.ExternalValue
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.InternalBAID
			and XREF.RATable		= 'BusinessAssociate'
			and	XREF.Qualifier		= 'SAPIntCoID'
Where	CustomAccountDetailAttribute.SAPCompanyCode	is null

Update	CustomAccountDetailAttribute
Set		SAPInternalCode = XREF.ExternalValue
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.InvoiceIntBAID
			and XREF.RATable		= 'BusinessAssociate'
			and	XREF.Qualifier		= 'SAPInternalCode'
Where	CustomAccountDetailAttribute.SAPInternalCode	is null

Update	CustomAccountDetailAttribute
Set		SAPPlantCode = XREF.ExternalValue
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join AccountDetail AD with (NoLock)
			on	AD.AcctDtlID		= CAD.AcctDtlID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= IsNull(AD.AcctDtlLcleID, CAD.MvtHdrOrgnLcleID)
			and XREF.RATable		= 'Locale'
			and	XREF.Qualifier		= 'SAPPlantCode'
Where	CustomAccountDetailAttribute.SAPPlantCode	is null

Update	CustomAccountDetailAttribute
Set		SAPStrategy = Left(LTRIM(RTRIM(XREF.ExternalValue)), 12)	-- we only take 12 characters, but there is no mask on the field to stop 13+
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.StrtgyID
			and	XREF.RATable		= 'StrategyHeader'
			and	XREF.Qualifier		= 'SAPStrategy'
Where	CustomAccountDetailAttribute.SAPStrategy		is null

Update	CustomAccountDetailAttribute
Set		SAPCostCenter = LTRIM(RTRIM(XREF.ExternalValue))
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.StrtgyID
			and	XREF.RATable		= 'StrategyHeader'
			and	XREF.Qualifier		= 'CostCenter'
Where	CustomAccountDetailAttribute.SAPCostCenter		is null

Update	CustomAccountDetailAttribute
Set		SAPProfitCenter = LTRIM(RTRIM(XREF.ExternalValue))
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.StrtgyID
			and XREF.RATable		= 'StrategyHeader'
			and	XREF.Qualifier		= 'ProfitCenter'
Where	CustomAccountDetailAttribute.SAPProfitCenter	is null

Update	CustomAccountDetailAttribute
Set		SAPMaterialCode = XREF.ExternalValue
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.ChildPrdctID
			and XREF.RATable		= 'Product'
			and	XREF.Qualifier		= 'SAPMaterialCode'
Where	CustomAccountDetailAttribute.SAPMaterialCode	is null

Update	CustomAccountDetailAttribute
Set		SAPPaymentTerm = XREF.ExternalValue
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.InvoiceTrmID
			and XREF.RATable		= 'Term'
			and	XREF.Qualifier		= 'SAPTermCode'
Where	CustomAccountDetailAttribute.SAPPaymentTerm	is null

--Update	CustomAccountDetailAttribute
--Set		SAPShipToCode = v.ShipTo
--From	tmp_CustomAccountDetail
--		Inner Join CustomAccountDetail CAD with (NoLock)
--			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
--		Inner Join CustomAccountDetailAttribute with (NoLock)
--			on	CAD.ID				= CustomAccountDetailAttribute.CADID
--		Inner Join v_MTV_SAPSoldToShipTo v with (NoLock)
--			on	v.DlDtlDlHdrID		= CAD.DlHdrID
--			and	v.DlDtlID			= CAD.DlDtlID
--			and	getdate()			between IsNull(v.EffectiveFromDate, '1/1/1900') and IsNull(v.EffectiveToDate, '1/1/2078')
--Where	CustomAccountDetailAttribute.SAPShipToCode		is null
-- Sanjay
Update	CustomAccountDetailAttribute
Set		SAPShipToCode = ShipTo.GnrlCnfgMulti
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join GeneralConfiguration As ShipTo (NoLock)
			on ShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo'
			And ShipTo.GnrlCnfgTblNme = 'MovementHeader'
			And ShipTo.GnrlCnfgHdrID =	CAD.MvtHdrID
			And ShipTo.GnrlCnfgMulti != 'X'
Where CustomAccountDetailAttribute.SAPShipToCode is null



if exists (select 1 from tmp_CustomAccountDetail where AcctDtlSrceTble = 'X')
begin
	----------------------------------------------------------------------------------------------------------------------
	-- Set the Vendor & SoldTo/Customer numbers -- SourceTable "X" -- Prvsn BA = Deal BA
	----------------------------------------------------------------------------------------------------------------------
	Update	CustomAccountDetailAttribute
	Set		SAPVendorNumber =	Case When SAPVendorNumber	is null Then MTVSAPBASoldTo.VendorNumber Else SAPVendorNumber End,
			SAPSoldToCode =		Case When SAPSoldToCode		is null Then MTVSAPBASoldTo.SoldTo Else SAPSoldToCode End,
			SAPCustomerNumber =	Case When SAPCustomerNumber	is null Then MTVSAPBASoldTo.SoldTo Else SAPCustomerNumber End
	From	tmp_CustomAccountDetail
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
			Inner Join CustomAccountDetailAttribute with (NoLock)
				on	CAD.ID				= CustomAccountDetailAttribute.CADID
			INNER JOIN		(
							select	DISTINCT DealHeader.DlHdrID
									,DealDetail.DlDtlID
									,DealHeader.DlHdrExtrnlBAID
									,MTVSAPBASoldTo.ClassOfTrade
									,GeneralConfiguration.GnrlCnfgMulti as BASoldToId
									,TransactionDetailLog.XDtlLgAcctDtlID
									--select *
							from	TransactionDetailLog (NoLock)
									INNER JOIN DealDetailProvision (NoLock)
										ON	DealDetailProvision.DlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
									INNER JOIN DealDetail (NoLock)
										ON	DealDetail.DlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
										AND	DealDetail.DlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
										--AND	DealDetailProvision.CostType = 'P'
									INNER JOIN DealHeader (NoLock)
										ON	DealHeader.DlHdrID = DealDetail.DlDtlDlHdrID
										AND	DealHeader.DlHdrExtrnlBAID = DealDetailProvision.BAID
									INNER JOIN	GeneralConfiguration (NoLock)
										ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
										AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
										AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
										AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
									INNER JOIN	MTVSAPBASoldTo (NoLock)
										ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
			) AS DealClassOfTrade
				ON	CAD.AcctDtlID = DealClassOfTrade.XDtlLgAcctDtlID
			INNER JOIN	MTVSAPBASoldTo (NoLock)
				ON	DealClassOfTrade.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
				AND	DealClassOfTrade.BASoldToId = MTVSAPBASoldTo.ID
			INNER JOIN	DynamicListBox (NoLock)
				ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
				AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
	where	tmp_CustomAccountDetail.AcctDtlSrceTble = 'X'
	and		(SAPVendorNumber		is null
			or	SAPSoldToCode		is null 
			or	SAPCustomerNumber	is null
			)
	Option (FORCE ORDER)

	----------------------------------------------------------------------------------------------------------------------
	-- Set the Vendor & SoldTo/Customer numbers -- SourceTable "X" -- Prvsn BA <> Deal BA
	----------------------------------------------------------------------------------------------------------------------
	Update	CustomAccountDetailAttribute
	Set		SAPVendorNumber =	Case When SAPVendorNumber	is null Then MTVSAPBASoldTo.VendorNumber Else SAPVendorNumber End,
			SAPSoldToCode =		Case When SAPSoldToCode		is null Then MTVSAPBASoldTo.SoldTo Else SAPSoldToCode End,
			SAPCustomerNumber =	Case When SAPCustomerNumber	is null Then MTVSAPBASoldTo.SoldTo Else SAPCustomerNumber End
	From	tmp_CustomAccountDetail
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
			Inner Join CustomAccountDetailAttribute with (NoLock)
				on	CAD.ID				= CustomAccountDetailAttribute.CADID
			INNER JOIN		(
							select	DISTINCT DealHeader.DlHdrID
									,DealDetail.DlDtlID
									,DealDetailProvision.BAID
									,MTVSAPBASoldTo.ClassOfTrade
									,GeneralConfiguration.GnrlCnfgMulti as BASoldToId
									,TransactionDetailLog.XDtlLgAcctDtlID
									--select *
							from	TransactionDetailLog (NoLock)
									INNER JOIN DealDetailProvision (NoLock)
										ON	DealDetailProvision.DlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
									INNER JOIN DealDetail (NoLock)
										ON	DealDetail.DlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
										AND	DealDetail.DlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
										AND	DealDetailProvision.CostType <> 'P'
									INNER JOIN DealHeader (NoLock)
										ON	DealHeader.DlHdrID = DealDetail.DlDtlDlHdrID
										AND	DealHeader.DlHdrExtrnlBAID <> DealDetailProvision.BAID
									INNER JOIN	GeneralConfiguration (NoLock)
										ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
										AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
										AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
										AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
									INNER JOIN	MTVSAPBASoldTo (NoLock)
										ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
					) AS DealClassOfTrade
				ON	CAD.AcctDtlID = DealClassOfTrade.XDtlLgAcctDtlID
			INNER JOIN	MTVSAPBASoldTo (NoLock)
				ON	DealClassOfTrade.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
				AND	CAD.ExternalBAID = MTVSAPBASoldTo.BAID
			INNER JOIN	DynamicListBox (NoLock)
				ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
				AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
	where	tmp_CustomAccountDetail.AcctDtlSrceTble = 'X'
	and		(SAPVendorNumber		is null
			or	SAPSoldToCode		is null 
			or	SAPCustomerNumber	is null
			)
	Option (FORCE ORDER)
end

if exists (select 1 from tmp_CustomAccountDetail where AcctDtlSrceTble = 'T')
begin
	----------------------------------------------------------------------------------------------------------------------
	-- Set the Vendor & SoldTo/Customer numbers -- SourceTable "T" -- NON freight
	----------------------------------------------------------------------------------------------------------------------
	Update	CustomAccountDetailAttribute
	Set		SAPVendorNumber =	Case When SAPVendorNumber	is null Then MTVSAPBASoldTo.VendorNumber Else SAPVendorNumber End,
			SAPSoldToCode =		Case When SAPSoldToCode		is null Then MTVSAPBASoldTo.SoldTo Else SAPSoldToCode End,
			SAPCustomerNumber =	Case When SAPCustomerNumber	is null Then MTVSAPBASoldTo.SoldTo Else SAPCustomerNumber End
	From	tmp_CustomAccountDetail
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
			Inner Join CustomAccountDetailAttribute with (NoLock)
				on	CAD.ID				= CustomAccountDetailAttribute.CADID
			INNER JOIN Dealheader (NoLock)
				ON	CAD.DlHdrID			= DealHeader.DlHdrID
			INNER JOIN	GeneralConfiguration (NoLock)
				ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
				AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
				AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
				AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
			INNER JOIN	MTVSAPBASoldTo (NoLock)
				ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
			INNER JOIN	DynamicListBox (NoLock)
				ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
				AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
	where	tmp_CustomAccountDetail.AcctDtlSrceTble = 'T'
	and		(SAPVendorNumber		is null
			or	SAPSoldToCode		is null 
			or	SAPCustomerNumber	is null
			)
	And		Not Exists	(
						Select	1
						From	TransactionTypeGroup (NoLock)
								Inner Join TransactionGroup (NoLock)
									on	TransactionGroup.XGrpID		= TransactionTypeGroup.XTpeGrpXGrpID
						Where	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= CAD.TrnsctnTypID
						And		TransactionGroup.XGrpName					= 'Freight - Tax Engine'
						)


	----------------------------------------------------------------------------------------------------------------------
	-- Set the Vendor & SoldTo/Customer numbers -- SourceTable "T" -- freight stuff from the tax engine
	----------------------------------------------------------------------------------------------------------------------
	Update	CustomAccountDetailAttribute
	Set		SAPVendorNumber =	Case When SAPVendorNumber	is null Then MTVSAPBASoldTo.VendorNumber Else SAPVendorNumber End,
			SAPSoldToCode =		Case When SAPSoldToCode		is null Then MTVSAPBASoldTo.SoldTo Else SAPSoldToCode End,
			SAPCustomerNumber =	Case When SAPCustomerNumber	is null Then MTVSAPBASoldTo.SoldTo Else SAPCustomerNumber End
	From	tmp_CustomAccountDetail
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
			Inner Join CustomAccountDetailAttribute with (NoLock)
				on	CAD.ID				= CustomAccountDetailAttribute.CADID
			INNER JOIN TaxDetailLog (NoLock)
				on	TaxDetailLog.TxDtlLgID						= CAD.AcctDtlSrceID
			Inner Join TaxDetail (NoLock)
				on	TaxDetail.TxDtlID							= TaxDetailLog.TxDtlLgTxDtlID
			Inner Join Tax (NoLock)
				on	Tax.TxID									= TaxDetail.TxID
			INNER JOIN	MTVSAPBASoldTo (NoLock)
				ON	MTVSAPBASoldTo.BAID							= Tax.TaxAuthorityBAID
				and	IsNull(MTVSAPBASoldTo.VendorNumber, '')		<> ''		-- For the Freight - Tax Engine group, we always want Vendor Number
			INNER JOIN	DynamicListBox (NoLock)
				ON	MTVSAPBASoldTo.ClassOfTrade					= DynamicListBox.DynLstBxTyp
				AND	DynamicListBox.DynLstBxQlfr					= 'BASoldToClassOfTrade'
	where	tmp_CustomAccountDetail.AcctDtlSrceTble = 'T'
	and		(SAPVendorNumber		is null
			or	SAPSoldToCode		is null 
			or	SAPCustomerNumber	is null
			)
	And		Exists	(
					Select	1
					From	TransactionTypeGroup (NoLock)
							Inner Join TransactionGroup (NoLock)
								on	TransactionGroup.XGrpID		= TransactionTypeGroup.XTpeGrpXGrpID
					Where	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= CAD.TrnsctnTypID
					And		TransactionGroup.XGrpName					= 'Freight - Tax Engine'
					)
end

if exists (select 1 from tmp_CustomAccountDetail where AcctDtlSrceTble = 'TT')
begin
	----------------------------------------------------------------------------------------------------------------------
	-- Set the Vendor & SoldTo/Customer numbers -- SourceTable "TT" -- Prvsn BA = Deal BA
	----------------------------------------------------------------------------------------------------------------------
	Update	CustomAccountDetailAttribute
	Set		SAPVendorNumber =	Case When SAPVendorNumber	is null Then MTVSAPBASoldTo.VendorNumber Else SAPVendorNumber End,
			SAPSoldToCode =		Case When SAPSoldToCode		is null Then MTVSAPBASoldTo.SoldTo Else SAPSoldToCode End,
			SAPCustomerNumber =	Case When SAPCustomerNumber	is null Then MTVSAPBASoldTo.SoldTo Else SAPCustomerNumber End
	From	tmp_CustomAccountDetail
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
			Inner Join CustomAccountDetailAttribute with (NoLock)
				on	CAD.ID				= CustomAccountDetailAttribute.CADID
			INNER JOIN	(
						select	DISTINCT DealHeader.DlHdrID
								,DealDetail.DlDtlID
								,DealHeader.DlHdrExtrnlBAID
								,MTVSAPBASoldTo.ClassOfTrade
								,GeneralConfiguration.GnrlCnfgMulti as BASoldToId
								,TimeTransactionDetailLog.TmeXDtlLgAcctDtlID
								--select *
						from	TimeTransactionDetailLog (NoLock)
								INNER JOIN TimeTransactionDetail (NoLock)
									ON	TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty = TimeTransactionDetail.TmeXDtlIdnty
								INNER JOIN DealDetailProvision (NoLock)
									ON	 DealDetailProvision.DlDtlPrvsnID = TimeTransactionDetail.TmeXDtlDlDtlPrvsnID
								INNER JOIN DealDetail (NoLock)
									ON	DealDetail.DlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
									AND	DealDetail.DlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
									--AND	DealDetailProvision.CostType = 'P'
								INNER JOIN DealHeader (NoLock)
									ON	DealHeader.DlHdrID = DealDetail.DlDtlDlHdrID
									AND	DealHeader.DlHdrExtrnlBAID = DealDetailProvision.BAID
								INNER JOIN	GeneralConfiguration (NoLock)
									ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
									AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
									AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
									AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
								INNER JOIN	MTVSAPBASoldTo (NoLock)
									ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
						) AS DealClassOfTrade
				ON	CAD.AcctDtlID = DealClassOfTrade.TmeXDtlLgAcctDtlID
			INNER JOIN	MTVSAPBASoldTo (NoLock)
				ON	DealClassOfTrade.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
				AND	DealClassOfTrade.BASoldToId = MTVSAPBASoldTo.ID
			INNER JOIN	DynamicListBox (NoLock)
				ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
				AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
	where	tmp_CustomAccountDetail.AcctDtlSrceTble = 'TT'
	and		(SAPVendorNumber		is null
			or	SAPSoldToCode		is null 
			or	SAPCustomerNumber	is null
			)
	Option (FORCE ORDER)

	----------------------------------------------------------------------------------------------------------------------
	-- Set the Vendor & SoldTo/Customer numbers -- SourceTable "TT" -- Prvsn BA <> Deal BA
	----------------------------------------------------------------------------------------------------------------------
	Update	CustomAccountDetailAttribute
	Set		SAPVendorNumber =	Case When SAPVendorNumber	is null Then MTVSAPBASoldTo.VendorNumber Else SAPVendorNumber End,
			SAPSoldToCode =		Case When SAPSoldToCode		is null Then MTVSAPBASoldTo.SoldTo Else SAPSoldToCode End,
			SAPCustomerNumber =	Case When SAPCustomerNumber	is null Then MTVSAPBASoldTo.SoldTo Else SAPCustomerNumber End
	From	tmp_CustomAccountDetail
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
			Inner Join CustomAccountDetailAttribute with (NoLock)
				on	CAD.ID				= CustomAccountDetailAttribute.CADID
			INNER JOIN	(
							select	DISTINCT DealHeader.DlHdrID
									,DealDetail.DlDtlID
									,DealDetailProvision.BAID
									,MTVSAPBASoldTo.ClassOfTrade
									,GeneralConfiguration.GnrlCnfgMulti as BASoldToId
									,TimeTransactionDetailLog.TmeXDtlLgAcctDtlID
									--select *
							from	TimeTransactionDetailLog (NoLock)
									INNER JOIN	TimeTransactionDetail (NoLock)
										ON	TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty = TimeTransactionDetail.TmeXDtlIdnty
									INNER JOIN DealDetailProvision (NoLock)
										ON	 DealDetailProvision.DlDtlPrvsnID = TimeTransactionDetail.TmeXDtlDlDtlPrvsnID
									INNER JOIN DealDetail (NoLock)
										ON	DealDetail.DlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
										AND	DealDetail.DlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
										AND	DealDetailProvision.CostType <> 'P'
									INNER JOIN DealHeader (NoLock)
										ON	DealHeader.DlHdrID = DealDetail.DlDtlDlHdrID
										AND	DealHeader.DlHdrExtrnlBAID <> DealDetailProvision.BAID
									INNER JOIN	GeneralConfiguration (NoLock)
										ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
										AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
										AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
										AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
									INNER JOIN	MTVSAPBASoldTo (NoLock)
										ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
						) AS DealClassOfTrade
				ON	CAD.AcctDtlID = DealClassOfTrade.TmeXDtlLgAcctDtlID
			INNER JOIN	MTVSAPBASoldTo (NoLock)
				ON	DealClassOfTrade.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
				AND	CAD.ExternalBAID = MTVSAPBASoldTo.BAID
			INNER JOIN	DynamicListBox (NoLock)
				ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
				AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'
	where	tmp_CustomAccountDetail.AcctDtlSrceTble = 'TT'
	and		(SAPVendorNumber		is null
			or	SAPSoldToCode		is null 
			or	SAPCustomerNumber	is null
			)
	Option (FORCE ORDER)
end

if exists (select 1 from tmp_CustomAccountDetail where AcctDtlSrceTble in ('M', 'P'))
begin
	----------------------------------------------------------------------------------------------------------------------
	-- Set the Vendor & SoldTo/Customer numbers -- SourceTable "M" and "P"
	----------------------------------------------------------------------------------------------------------------------
	Update	CustomAccountDetailAttribute
	Set		SAPVendorNumber =	Case When SAPVendorNumber	is null Then MTVSAPBASoldTo.VendorNumber Else SAPVendorNumber End,
			SAPSoldToCode =		Case When SAPSoldToCode		is null Then MTVSAPBASoldTo.SoldTo Else SAPSoldToCode End,
			SAPCustomerNumber =	Case When SAPCustomerNumber	is null Then MTVSAPBASoldTo.SoldTo Else SAPCustomerNumber End
	From	tmp_CustomAccountDetail
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	tmp_CustomAccountDetail.AcctDtlID		= CAD.AcctDtlID
			Inner Join CustomAccountDetailAttribute with (NoLock)
				on	CustomAccountDetailAttribute.CADID		= CAD.ID
			Inner Join BusinessAssociate (NoLock)
				on	BusinessAssociate.BAID					= CAD.InternalBAID
			Inner Join MTVSAPBASoldTo (NoLock)
				on	MTVSAPBASoldTo.BAID						= CAD.ExternalBAID
			Inner Join DynamicListBox DLBBA (NoLock)
				on	MTVSAPBASoldTo.ClassOfTrade				= DLBBA.DynLstBxTyp
				and	DLBBA.DynLstBxQlfr						= 'BASoldToClassOfTrade'
	where	tmp_CustomAccountDetail.AcctDtlSrceTble in ( 'M', 'P')
	and		(SAPVendorNumber		is null
			or	SAPSoldToCode		is null 
			or	SAPCustomerNumber	is null
			)
	And	Charindex(DLBBA.DynLstBxDesc, BusinessAssociate.BANme, 0) > 0
	And	CASE	WHEN CAD.SupplyDemand = 'R' AND CAD.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
				WHEN CAD.SupplyDemand = 'R' AND CAD.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
				WHEN CAD.SupplyDemand = 'D' AND CAD.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
				WHEN CAD.SupplyDemand = 'D' AND CAD.WePayTheyPay = 'R' THEN MTVSAPBASoldTo.VendorNumber
				WHEN CAD.SupplyDemand NOT IN ('R','D') AND CAD.WePayTheyPay = 'D' THEN MTVSAPBASoldTo.SoldTo
				ELSE MTVSAPBASoldTo.VendorNumber
		END IS NOT NULL
end

if exists (select 1 from tmp_CustomAccountDetail where AcctDtlSrceTble = 'I')
begin
	----------------------------------------------------------------------------------------------------------------------
	-- Set the Vendor & SoldTo/Customer numbers -- SourceTable "I"
	----------------------------------------------------------------------------------------------------------------------
	Update	CustomAccountDetailAttribute
	Set		SAPSoldToCode =		Case When CustomAccountDetailAttribute.SAPSoldToCode		is null Then CustNum.SAPCustomerNumber Else CustomAccountDetailAttribute.SAPSoldToCode End,
			SAPCustomerNumber =	Case When CustomAccountDetailAttribute.SAPCustomerNumber	is null Then CustNum.SAPCustomerNumber Else CustomAccountDetailAttribute.SAPCustomerNumber End
	From	tmp_CustomAccountDetail
			Inner Join CustomAccountDetail CAD with (NoLock)
				on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
				and	CAD.InterfaceSource	= 'SH'
			Inner Join CustomAccountDetailAttribute with (NoLock)
				on	CAD.ID				= CustomAccountDetailAttribute.CADID
			Inner Join MTVManualInvoiceCustomerNumber CustNum with (NoLock)
				on	CustNum.SlsInvceHdrID	= CAD.RAInvoiceID
	where	tmp_CustomAccountDetail.AcctDtlSrceTble = 'I'
	and		(
			CustomAccountDetailAttribute.SAPSoldToCode		is null 
			or	CustomAccountDetailAttribute.SAPCustomerNumber	is null
			)

end

----------------------------------------------------------------------------------------------------------------------
-- Set the SalesOrg and DistChannel
----------------------------------------------------------------------------------------------------------------------
Update	CustomAccountDetailAttribute
Set		SalesOrg = XREF.ExternalValue
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.InvoiceIntBAID
			and XREF.RATable		= 'BusinessAssociate'
			and	XREF.Qualifier		= 'SalesOrganization'
Where	CustomAccountDetailAttribute.SalesOrg			is null

Update	CustomAccountDetailAttribute
Set		DistChannel = XREF.ExternalValue
From	tmp_CustomAccountDetail
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID		= tmp_CustomAccountDetail.AcctDtlID
		Inner Join CustomAccountDetailAttribute with (NoLock)
			on	CAD.ID				= CustomAccountDetailAttribute.CADID
		Inner Join v_MTV_XrefAttributes XREF with (NoLock)
			on	XREF.RAKey			= CAD.InvoiceIntBAID
			and XREF.RATable		= 'BusinessAssociate'
			and	XREF.Qualifier		= 'DistributionChannel'
Where	CustomAccountDetailAttribute.DistChannel		is null


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
If OBJECT_ID('dbo.Custom_Interface_AD_Mapping_ClientHook') Is NOT Null
BEGIN
	PRINT '<<< CREATED PROC dbo.Custom_Interface_AD_Mapping_ClientHook >>>'
	Grant Execute on dbo.Custom_Interface_AD_Mapping_ClientHook to SYSUSER
	Grant Execute on dbo.Custom_Interface_AD_Mapping_ClientHook to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating Procedure dbo.Custom_Interface_AD_Mapping_ClientHook >>>'
GO