/****** Object:  StoredProcedure [dbo].[MTV_SAP_ARStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_ARStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_ARStage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SAP_ARStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SAP_ARStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SAP_ARStage]
AS

-- =============================================
-- Author:        J. von Hoff
-- Create date:	  01FEB2016
-- Description:   Stage the AR data into the MTVSAPARStaging table
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare @i_checkoutStatus int
Exec @i_checkoutStatus = dbo.sra_checkout_process 'MTVSAPARCheckout'

if @i_checkoutStatus = 0
	return

Create Table #ARTemp
			(
			CIIID					Int,
			CIIMssgQID				Int,
			InvoiceLevel			Char(1),
			CompanyCode				Varchar(10),
			DocumentDate			SmallDateTime,
			PostingDate				SmallDateTime,
			Currency				Char(3),
			DocumentType			Char(2)	,
			DocumentHeaderText		Varchar(25),
			DocNumber				Varchar(50),
			ParentDocNumber			Varchar(16),
			PostingKey				Int,
			Customer				Varchar(20),
			ReferenceKey1			Varchar(20),
			ReferenceKey2			Varchar(20),
			ReferenceKey3			Varchar(20),
			Region					Char(2),
			TaxCode					Char(2),
			DocumentAmount			Decimal(19,6),
			Account					Varchar(10),
			LineItemText			Varchar(50),
			CostCenter				Varchar(10),
			ProfitCenter			Varchar(10),
			PaymentTerm				Char(4),
			PaymentReference		Varchar(30),
			PaymentMethod			Char(1),
			Material				Varchar(18),
			Plant					Char(4),
			DistributionChannel		Varchar(255),
			SalesOrg				Varchar(255),
			ShipTo					Varchar(10),
			TaxJurisdiction			Varchar(15),
			Quantity				Decimal(19,6),
			BaseUnit				Char(3),
			ReversalReason			Char(3),
			BaselineDate			SmallDateTime,
			PaymentBlock			Char(1),
			RightAngleStatus		Varchar(50),
			MiddlewareStatus		Varchar(50),
			SAPStatus				Varchar(50),
			Message					Varchar(1000)
			)

-- Clear the old data & set some defaults
----------------------------------------
delete MTVSAPARStaging Where RightAngleStatus in ('M', 'N', 'E')
Declare @vc_TaxCode varchar(255)
Select	@vc_TaxCode = "ZY" -- default for AR per Michele Rizzo




Insert	#ARTemp
		(
			CIIID,
			CIIMssgQID,
			InvoiceLevel,
			CompanyCode,
			DocumentDate,
			PostingDate,
			Currency,
			DocumentType,
			DocumentHeaderText,
			DocNumber,
			ParentDocNumber,
			PostingKey,
			Customer,
			ReferenceKey1,
			ReferenceKey2,
			ReferenceKey3,
			Region,
			TaxCode,
			DocumentAmount,
			Account,
			LineItemText,
			CostCenter,
			ProfitCenter,
			PaymentTerm,
			PaymentReference,
			PaymentMethod,
			Material,
			Plant,
			DistributionChannel,
			SalesOrg,
			ShipTo,
			TaxJurisdiction,
			Quantity,
			BaseUnit,
			ReversalReason,
			BaselineDate,
			PaymentBlock,
			RightAngleStatus,
			MiddlewareStatus,
			SAPStatus,
			Message
		)
Select		CII.ID									as	CIIID,
			CII.MessageQueueID						as	CIIMssgQID,
			CII.InvoiceLevel						as	InvoiceLevel,
			Left(CADA.SAPCompanyCode, 10)			as	CompanyCode,
			Convert(smalldatetime, CII.InvoiceDate)	as	DocumentDate,
			null									as	PostingDate,
			CII.InvoiceCurrency						as	Currency,
			null									as	DocumentType,
			CII.InterfaceInvoiceID					as	DocumentHeaderText,
			CII.InvoiceNumber						as	DocNumber,
			null									as	ParentDocNumber,
			Convert(Int, CII.LineType)				as	PostingKey,
			CADA.SAPSoldToCode						as	Customer,
			CADA.SAPStrategy						as	ReferenceKey1,
			Left(CII.BL,12)							as	ReferenceKey2,
			Left(CII.DealNumber,20)					as	ReferenceKey3,
			CADA.RegionCode							as	Region,
			@vc_TaxCode								as	TaxCode,
			CII.AbsInvoiceValue						as	DocumentAmount,
			Left(CII.Chart, 10)						as	Account,
			Left(CII.TransactionType, 50)			as	LineItemText,
			Left(CADA.SAPCostCenter, 10)			as	CostCenter,
			Left(CADA.SAPProfitCenter, 10)			as	ProfitCenter,
			CADA.SAPPaymentTerm						as	PaymentTerm,
			null									as	PaymentReference,
			null									as	PaymentMethod,
			Left(CADA.SAPMaterialCode, 10)			as	Material,
			Left(CADA.SAPPlantCode, 10)				as	Plant,
			CADA.DistChannel						as	DistributionChannel,
			CADA.SalesOrg							as	SalesOrg,
			Left(CADA.SAPShipToCode, 10)			as	ShipTo,
			null									as	TaxJurisdiction,
			CII.Quantity							as	Quantity,
			Left(GCUOM.GnrlCnfgMulti, 3)			as	BaseUnit,
			null									as	ReversalReason,
			Convert(smalldatetime, CII.DueDate)
													as	BaselineDate,
			null									as	PaymentBlock,
			'N'										as	RightAngleStatus,
			null									as	MiddlewareStatus,
			null									as	SAPStatus,
			''										as	Message
-- Select	*
From	CustomInvoiceInterface as CII with (NoLock)
		Left Outer Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
			and	CAD.InterfaceInvoiceID		= CII.InterfaceInvoiceID
			and	CAD.InterfaceSource			= 'SH'
		Left Outer Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
		Inner Join UnitOfMeasure UOM
			on	UOM.UOMAbbv					= CII.UOM
		Left Outer Join GeneralConfiguration GCUOM
			on	GCUOM.GnrlCnfgTblNme		= 'UnitOfMeasure'
			and	GCUOM.GnrlCnfgQlfr			= 'SAPUOMAbbv'
			and	GCUOM.GnrlCnfgHdrID			= UOM.UOM
Where	CII.InterfaceSource		= 'SH'
And		Not Exists	(
					Select	1
					From	MTVSAPARStaging with (NoLock)
					Where	MTVSAPARStaging.CIIMssgQID	= CII.MessageQueueID
					)




-- Set the SAP fields
--------------------------------------------------------------------------
Update	#ARTemp
Set		DocumentType = REPLACE(IsNull(TransactionGroup.XGrpName, ''),'Document Type ','')
From	#ARTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #ARTemp.CIIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
		Inner Join TransactionTypeGroup with (NoLock)
			on	TransactionTypeGroup.XTpeGrpTrnsctnTypID		= CAD.TrnsctnTypID
		Inner Join TransactionGroup with (NoLock)
			on	TransactionGroup.XGrpID							= TransactionTypeGroup.XTpeGrpXGrpID
			and	TransactionGroup.XGrpQlfr						= 'SAP Document Types'

-- Try to set the parent doc number (if necessary) -- this works for Reversals
--------------------------------------------------------------------------
Update	#ARTemp
Set		ParentDocNumber	= CIL.ID
From	#ARTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #ARTemp.CIIID
		Left Outer Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
		Left Outer Join CustomInvoiceLog CIL with (NoLock)
			on	CIL.InvoiceID				= CAD.InvoiceParentInvoiceID
			and	CIL.InvoiceType				= CAD.InterfaceSource
Where	1=1
and		IsNull(CII.ParentInvoiceNumber, '')		<> IsNull(CII.InvoiceNumber, '')
and		IsNull(CII.ParentInvoiceNumber, '')		<> ''


-- Try to set the parent doc number -- Rebills
--------------------------------------------------------------------------
Update	#ARTemp
Set		ParentDocNumber	= CIL.ID
From	#ARTemp
		Inner Join #ARTemp HeaderRow with (NoLock)
			on	HeaderRow.CIIMssgQID			= #ARTemp.CIIMssgQID
			and	HeaderRow.InvoiceLevel			= 'H'
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID							= HeaderRow.CIIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.InterfaceInvoiceID			= CII.InterfaceInvoiceID
			and	CAD.HighestValue				= 'Y'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID						= CAD.ID
		Inner Join CustomAccountDetail CADOlder with (NoLock)
			on	CADOlder.MvtDcmntID				= CAD.MvtDcmntID
			and	CADOlder.HighestValue			= 'Y'
			and	CADOlder.AcctDtlSrceTble		= CAD.AcctDtlSrceTble
			and	CADOlder.AcctDtlSrceID			< CAD.AcctDtlSrceID
			and CADOlder.ReceiptRefundFlag		= CAD.ReceiptRefundFlag
			and	CADOlder.ID						<> CAD.ID
			and	not exists	(
							Select	1
							From	CustomAccountDetail Sub with (NoLock)
							Where	Sub.MvtDcmntID			= CAD.MvtDcmntID
							and		Sub.HighestValue		= 'Y'
							and		Sub.AcctDtlSrceTble		= CAD.AcctDtlSrceTble
							and		Sub.AcctDtlSrceID		< CAD.AcctDtlSrceID
							and		Sub.ReceiptRefundFlag	= CAD.ReceiptRefundFlag
							and		Sub.ID					<> CAD.ID
							and		Sub.ID					> CADOlder.ID
							)
		Inner Join CustomAccountDetailAttribute CADAOlder with (NoLock)
			on	CADAOlder.CADID					= CADOlder.ID
		Inner Join CustomInvoiceLog CIL with (NoLock)
			on	CIL.InvoiceID				= CADOlder.InvoiceParentInvoiceID
			and	CIL.InvoiceType				= CAD.InterfaceSource
Where	1=1
and		#ARTemp.ParentDocNumber				is NULL
and		#ARTemp.InvoiceLevel				<> 'H'
and		CADA.SAPSoldToCode					= CADAOlder.SAPSoldToCode
and		exists	(
				Select	1
				From	MovementHeader MH with (NoLock)
						Inner Join MovementHeader MHOlder with (NoLock)
							on	MHOlder.MvtHdrMvtDcmntID		= CADOlder.MvtDcmntID
				Where	MH.MvtHdrMvtDcmntID								= CAD.MvtDcmntID
				and		YEAR(MH.MvtHdrDte)								= YEAR(MHOlder.MvtHdrDte)
				and		IsNull(MH.MvtHdrOrgnLcleID, MH.MvtHdrLcleID)	= IsNull(MHOlder.MvtHdrOrgnLcleID, MHOlder.MvtHdrLcleID)
				)



-- Set the ReasonCode
--------------------------------------------------------------------------
Update	#ARTemp
Set		ReversalReason = 'Z6' -- Deferred Taxes
From	#ARTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #ARTemp.CIIID
		Inner Join SalesInvoiceHeader SIH with (NoLock)
			on	SIH.SlsInvceHdrID			= CII.InvoiceID
		Inner Join SalesInvoiceType SIT with (NoLock)
			on	SIT.SlsInvceTpeID			= SIH.SlsInvceHdrSlsInvceTpeID
Where	SIT.SlsInvceTpeDscrptn = dbo.GetRegistryValue('System\SalesInvoicing\DeferredTaxInvoiceTypeName')


-- Set the Material & Plant where they're not really required (Financial & RINS invoices)
--------------------------------------------------------------------------
Update	#ARTemp
Set		Material = IsNull(#ARTemp.Material, 'None'),
		Plant = IsNull(#ARTemp.Plant, 'None')
From	#ARTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #ARTemp.CIIID
		Inner Join SalesInvoiceHeader SIH with (NoLock)
			on	SIH.SlsInvceHdrID			= CII.InvoiceID
		Inner Join SalesInvoiceType SIT with (NoLock)
			on	SIT.SlsInvceTpeID			= SIH.SlsInvceHdrSlsInvceTpeID
Where	SIT.SlsInvceTpeAbbrvtn		= 'Swap Invoice'

-- Set the Base Unit for time transactions
--------------------------------------------------------------------------
Update	#ARTemp
Set		BaseUnit = Case when IsNull(CII.Quantity, 0.00) = 0.00 then 'Non' else #ARTemp.BaseUnit end,
		Plant = IsNull(#ARTemp.Plant, 'None'),
		Material = IsNull(#ARTemp.Material, 'None')
From	#ARTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #ARTemp.CIIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
Where	CAD.AcctDtlSrceTble = 'TT'

-- Try to set the BOL number
--------------------------------------------------------------------------
Update	#ARTemp
Set		ReferenceKey2 = case when MinBOL = MaxBOL then MinBOL else 'Multiple' end
From	#ARTemp
		Inner Join (
					Select	Sub.CIIMssgQID,
							Min(Sub.ReferenceKey2) as MinBOL,
							Max(Sub.ReferenceKey2) as MaxBOL
					From	#ARTemp Sub with (NoLock)
					Where	Sub.InvoiceLevel	<> 'H'
					Group By Sub.CIIMssgQID
					) as Sub
						on	Sub.CIIMssgQID			= #ARTemp.CIIMssgQID
Where	#ARTemp.PostingKey		not in ('40','50')


-- Set the PaymentTerm from the SAP code
--------------------------------------------------------------------------
Update	#ARTemp
Set		PaymentReference	= Left(Term.TrmVrbge, 30),
		PaymentMethod		= Left(IsNull(GnrlCnfgMulti, ''), 1) --Case Term.TrmPymntMthd When 'A' Then 'D' When 'W' Then 'Z' Else NULL End
From	#ARTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #ARTemp.CIIID
		Inner Join SalesInvoiceHeader SIH with (NoLock)
			on	SIH.SlsInvceHdrID			= CII.InvoiceID
		Inner Join Term with (NoLock)
			on	Term.TrmID					= SIH.SlsInvceHdrTrmID
		Left Outer Join GeneralConfiguration with (NoLock)
			on	GnrlCnfgTblNme				= 'Term'
			and	GnrlCnfgQlfr				= 'SAPPayMethod'
			and	GnrlCnfgHdrID				= Term.TrmID


Update	#ARTemp
Set		#ARTemp.CompanyCode			= IsNull(#ARTemp.CompanyCode, Details.CompanyCode),
		#ARTemp.DocumentType		= IsNull(#ARTemp.DocumentType, Details.DocumentType),
		#ARTemp.Customer			= IsNull(#ARTemp.Customer, Details.Customer),
		#ARTemp.ReferenceKey1		= IsNull(#ARTemp.ReferenceKey1, Details.ReferenceKey1),
		#ARTemp.CostCenter			= IsNull(#ARTemp.CostCenter, Details.CostCenter),
		#ARTemp.ProfitCenter		= IsNull(#ARTemp.ProfitCenter, Details.ProfitCenter),
		#ARTemp.PaymentTerm			= IsNull(#ARTemp.PaymentTerm, Details.PaymentTerm),
		#ARTemp.PaymentMethod		= IsNull(#ARTemp.PaymentMethod, Details.PaymentMethod),
		#ARTemp.ParentDocNumber		= IsNull(#ARTemp.ParentDocNumber, Details.ParentDocNumber),
		#ARTemp.ShipTo				= IsNull(#ARTemp.ShipTo, Details.ShipTo),
		#ARTemp.Material			= IsNull(#ARTemp.Material, Details.Material),
		#ARTemp.Plant				= IsNull(#ARTemp.Plant, Details.Plant),
		#ARTemp.DistributionChannel	= IsNull(#ARTemp.DistributionChannel, Details.DistributionChannel),
		#ARTemp.SalesOrg			= IsNull(#ARTemp.SalesOrg, Details.SalesOrg)
From	#ARTemp
		Inner Join #ARTemp Details
			on	Details.CIIMssgQID		= #ARTemp.CIIMssgQID
			and	Details.InvoiceLevel	<> 'H'
			and	Details.LineItemText	<> 'Discount'
			and	not exists	(
							Select	1
							From	#ARTemp Sub
							Where	Sub.CIIMssgQID		= #ARTemp.CIIMssgQID
							and		Sub.InvoiceLevel	<> 'H'
							and		Sub.LineItemText	<> 'Discount'
							and		Sub.CIIID			< Details.CIIID
							)
Where	(#ARTemp.InvoiceLevel	= 'H'
or		#ARTemp.InvoiceLevel	= 'D' and #ARTemp.LineItemText = 'Discount')
And		(
			#ARTemp.CompanyCode			is null
		or	#ARTemp.DocumentType		is null
		or	#ARTemp.Customer			is null
		or	#ARTemp.ReferenceKey1		is null
		or	#ARTemp.CostCenter			is null
		or	#ARTemp.ProfitCenter		is null
		or	#ARTemp.PaymentTerm			is null
		or	#ARTemp.PaymentMethod		is null
		or	#ARTemp.ParentDocNumber		is null
		or	#ARTemp.ShipTo				is null
		or	#ARTemp.Material			is null
		or	#ARTemp.Plant				is null
		or	#ARTemp.DistributionChannel	is null
		or	#ARTemp.SalesOrg			is null
		)



Update	#ARTemp
Set		#ARTemp.LineItemText = Case When len(IsNull(#ARTemp.LineItemText, ''))	= 0 Then Details.LineItemText Else #ARTemp.LineItemText End,
		#ARTemp.ReferenceKey1 = Case When len(IsNull(#ARTemp.ReferenceKey1, '')) = 0 Then Details.ReferenceKey1 Else #ARTemp.ReferenceKey1 End
From	#ARTemp
		Inner Join	(
					Select	CIIMssgQID,
							LineItemText,
							ReferenceKey1
					From	#ARTemp Sub
					Where	Sub.InvoiceLevel <> 'H'
					and		not exists (
										Select	1
										From	#ARTemp SubSub
										Where	SubSub.CIIMssgQID	= Sub.CIIMssgQID
										And		SubSub.InvoiceLevel	<> 'H'
										And		SubSub.InvoiceLevel	< Sub.InvoiceLevel
										)
					) as Details
			on	Details.CIIMssgQID		= #ARTemp.CIIMssgQID

Where	#ARTemp.InvoiceLevel					= 'H'
And		(
		len(IsNull(#ARTemp.LineItemText, ''))	= 0
	or	
		len(IsNull(#ARTemp.ReferenceKey1, ''))	= 0
		)




/****************************************************************************************************************/
--			Do some initial validation
/****************************************************************************************************************/
Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'DocumentHeaderText is required. '
Where	IsNull(DocumentHeaderText, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'CompanyCode is required. '
Where	IsNull(CompanyCode, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'DocumentDate is required. '
Where	IsNull(DocumentDate, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'DocumentType is required. '
Where	IsNull(DocumentType, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'DocNumber is required. '
Where	IsNull(DocNumber, '') = ''

--Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'ParentDocNumber is required. '
--Where	IsNull(ParentDocNumber, '') = '' and ReversalReason	is not null

--Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'ReversalReason is required. '
--Where	IsNull(ReversalReason, '') = '' and ReversalReason	= 'P01'

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'Customer is required. '
Where	IsNull(Replace(Customer, '0', ''), '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'Account is required. '
Where	IsNull(Replace(Account, '0', ''), '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'PaymentTerm is required. '
Where	InvoiceLevel = 'H' and IsNull(Replace(PaymentTerm, '0', ''), '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'BaselineDate is required. '
Where	InvoiceLevel = 'H' and IsNull(BaselineDate, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'LineItemText is required. '
Where	IsNull(LineItemText, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'ReferenceKey1 is required. '
Where	InvoiceLevel <> 'H' and IsNull(ReferenceKey1, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'ReferenceKey2 is required. '
Where	InvoiceLevel <> 'H' and IsNull(ReferenceKey2, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'ProfitCenter is required. '
Where	InvoiceLevel <> 'H' and IsNull(Replace(ProfitCenter, '0', ''), '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'BaseUnit is required. '
Where	InvoiceLevel <> 'H' and IsNull(BaseUnit, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'Quantity is required. '
Where	InvoiceLevel <> 'H' and Quantity is null

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'SalesOrg is required. '
Where	InvoiceLevel <> 'H' and IsNull(SalesOrg, '') = '' and DocumentType in ('DR', 'DG', 'DD')

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'DistributionChannel is required. '
Where	InvoiceLevel <> 'H' and IsNull(DistributionChannel, '') = '' and DocumentType in ('DR', 'DG', 'DD')
--Defect 3574 Plant should not be required on Rins
Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'ReferenceKey3 is required. '
Where	InvoiceLevel <> 'H' and IsNull(ReferenceKey3, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'CostCenter is required. '
Where	InvoiceLevel = 'D' and IsNull(CostCenter, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'Plant is required. '
Where	InvoiceLevel <> 'H' and IsNull(Plant, '') = '' and DocumentType in ('DR', 'DG', 'DD')
and LineItemText not in ('Sales-Renewables')

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'ReferenceKey1 is required. '
Where	InvoiceLevel <> 'H' and IsNull(Replace(ReferenceKey1, '0', ''), '') = '' and DocumentType in ('DR', 'DG', 'DD')

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'Material is required. '
Where	InvoiceLevel <> 'H' and IsNull(Replace(Material, '0', ''), '') = '' and DocumentType in ('DR', 'DG', 'DD')

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'Region is required. '
Where	InvoiceLevel = 'T' and IsNull(Region, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'TaxCode is required. '
Where	InvoiceLevel = 'T' and IsNull(TaxCode, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'Currency is required. '
Where	InvoiceLevel <> 'H' and IsNull(Currency, '') = ''

Update	#ARTemp Set RightAngleStatus = 'E', Message = Message + 'DocumentAmount is required. '
Where	InvoiceLevel <> 'H' and DocumentAmount is null



Update	#ARTemp Set RightAngleStatus = 'E' Where RightAngleStatus <> 'E'
and Exists (Select 1 From #ARTemp Sub where Sub.CIIMssgQID = #ARTemp.CIIMssgQID and Sub.RightAngleStatus = 'E')


/****************************************************************************************************************/
--			Finally... insert into the Stage table
/****************************************************************************************************************/
Insert	MTVSAPARStaging
		(
		CIIMssgQID
		,CIIID
		,BatchID
		,InvoiceLevel
		,CompanyCode
		,DocumentDate
		,PostingDate
		,Currency
		,DocumentType
		,DocumentHeaderText
		,DocNumber
		,ParentDocNumber
		,PostingKey
		,Customer
		,ReferenceKey1
		,ReferenceKey2
		,ReferenceKey3
		,Region
		,TaxCode
		,DocumentAmount
		,Account
		,LineItemText
		,CostCenter
		,ProfitCenter
		,PaymentTerm
		,PaymentReference
		,PaymentMethod
		,Material
		,Plant
		,DistributionChannel
		,SalesOrg
		,ShipTo
		,TaxJurisdiction
		,Quantity
		,BaseUnit
		,ReversalReason
		,BaselineDate
		,PaymentBlock
		,RightAngleStatus
		,MiddlewareStatus
		,SAPStatus
		,Message
		)
Select	CIIMssgQID
		,CIIID
		,0
		,InvoiceLevel
		,CompanyCode
		,DocumentDate
		,PostingDate
		,Currency
		,DocumentType
		,DocumentHeaderText
		,DocNumber
		,ParentDocNumber
		,PostingKey
		,Customer
		,ReferenceKey1
		,ReferenceKey2
		,ReferenceKey3
		,Region
		,TaxCode
		,DocumentAmount
		,Account
		,LineItemText
		,CostCenter
		,ProfitCenter
		,PaymentTerm
		,PaymentReference
		,PaymentMethod
		,Material
		,Plant
		,DistributionChannel
		,SalesOrg
		,ShipTo
		,TaxJurisdiction
		,Quantity
		,BaseUnit
		,ReversalReason
		,BaselineDate
		,PaymentBlock
		,RightAngleStatus
		,MiddlewareStatus
		,SAPStatus
		,Message
From	#ARTemp


-- select * from MTVSAPARStaging

/****************************************************************************************************************/
--			Don't forget to update the MTVInvoiceInterfaceStatus table
/****************************************************************************************************************/
Update	MTVInvoiceInterfaceStatus
Set		ARAPStaged = Convert(Bit, 1)
From	#ARTemp
		Inner Join MTVInvoiceInterfaceStatus
			on	MTVInvoiceInterfaceStatus.CIIMssgQID	= #ARTemp.CIIMssgQID

/****************************************************************************************************************/
--			Check the process in
/****************************************************************************************************************/
exec dbo.sra_checkin_process 'MTVSAPARCheckout'

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_ARStage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SAP_ARStage.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SAP_ARStage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SAP_ARStage >>>'
	  END