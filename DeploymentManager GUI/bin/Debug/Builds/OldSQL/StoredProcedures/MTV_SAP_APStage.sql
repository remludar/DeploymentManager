/****** Object:  StoredProcedure [dbo].[MTV_SAP_APStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_APStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_APStage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SAP_APStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SAP_APStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SAP_APStage]
AS

-- =============================================
-- Author:        J. von Hoff
-- Create date:	  01FEB2016
-- Description:   Stage the AP data into the MTVSAPAPStaging table
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Declare @i_checkoutStatus int
Exec @i_checkoutStatus = dbo.sra_checkout_process 'MTVSAPAPCheckout'

if @i_checkoutStatus = 0
	return

Create Table #APTemp
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
			ParentDocNumber			Varchar(50),
			PostingKey				Int,
			Vendor					Varchar(20),
			ReferenceKey1			Varchar(20),
			ReferenceKey2			Varchar(20),
			ReferenceKey3			Varchar(20),
			TaxCode					Char(2),
			DocumentAmount			Decimal(19,6),
			Account					Varchar(10),
			LineItemText			Varchar(50),
			CostCenter				Varchar(10),
			ProfitCenter			Varchar(10),
			PaymentTerm				Char(4),
			PaymentReference		Varchar(30),
			PaymentMethod			Char(1),
			PaymentBank				Char(5),
			HouseBank				Char(5),
			BankRoute				Varchar(50),
			BankAcct				Varchar(50),
			Material				Varchar(18),
			Plant					Char(4),
			TaxJurisdiction			Varchar(15),
			Quantity				Decimal(19,6),
			BaseUnit				Char(3),
			DebitMemo				Char(1),
			BaselineDate			SmallDateTime,
			PaymentBlock			Char(1),
			RightAngleStatus		Varchar(50),
			MiddlewareStatus		Varchar(50),
			SAPStatus				Varchar(50),
			Message					Varchar(1000)
			)


-- Clear the old data & set some defaults
----------------------------------------
delete MTVSAPAPStaging Where RightAngleStatus in ('M', 'N', 'E')
Declare @vc_TaxCode varchar(255)
select @vc_TaxCode = 'ZZ' -- default per Michele Rizzo 13MAY2016


Insert	#APTemp
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
			Vendor,
			ReferenceKey1,
			ReferenceKey2,
			ReferenceKey3,
			TaxCode,
			DocumentAmount,
			Account,
			LineItemText,
			CostCenter,
			ProfitCenter,
			PaymentTerm,
			PaymentReference,
			PaymentMethod,
			PaymentBank,
			HouseBank,
			BankRoute,
			BankAcct,
			Material,
			Plant,
			TaxJurisdiction,
			Quantity,
			BaseUnit,
			DebitMemo,
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
			Convert(smalldatetime, CII.InvoiceDate)
													as	DocumentDate,
			null									as	PostingDate,
			CII.InvoiceCurrency						as	Currency,
			null									as	DocumentType,
			CII.InterfaceInvoiceID					as	DocumentHeaderText,
			Left(CII.InvoiceNumber,16)				as	DocNumber,
			null									as	ParentDocNumber,
			Convert(Int, CII.LineType)				as	PostingKey,
			CADA.SAPVendorNumber					as	Vendor,
			CADA.SAPStrategy						as	ReferenceKey1,
			Left(CII.BL,12)							as	ReferenceKey2,
			Left(CII.DealNumber,20)					as	ReferenceKey3,
			@vc_TaxCode								as	TaxCode,
			CII.AbsInvoiceValue						as	DocumentAmount,
			Left(CII.Chart, 10)						as	Account,
			Left(CII.TransactionType, 50)			as	LineItemText,
			Left(CADA.SAPCostCenter, 10)			as	CostCenter,
			Left(CADA.SAPProfitCenter, 10)			as	ProfitCenter,
			CADA.SAPPaymentTerm						as	PaymentTerm,
			null									as	PaymentReference,
			null									as	PaymentMethod,
			null									as	PaymentBank,
			null									as	HouseBank,
			null									as	BankRoute,
			null									as	BankAcct,
			Left(CADA.SAPMaterialCode, 10)			as	Material,
			Left(CADA.SAPPlantCode, 10)				as	Plant,
			null									as	TaxJurisdiction,
			CII.Quantity							as	Quantity,
			Left(IsNull(GCUOM.GnrlCnfgMulti, 'NON'), 3)			as	BaseUnit,
			'N'										as	DebitMemo,
			Convert(smalldatetime, CII.DueDate)		as	BaselineDate,
			null									as	PaymentBlock,
			'N'										as	RightAngleStatus,
			null									as	MiddlewareStatus,
			null									as	SAPStatus,
			''										as	Message
--Select	*
From	CustomInvoiceInterface as CII with (NoLock)
		Left Outer Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
			and	CAD.InterfaceInvoiceID		= CII.InterfaceInvoiceID
			and	CAD.InterfaceSource			= 'PH'
		Left Outer Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
		Left Outer Join UnitOfMeasure UOM
			on	UOM.UOMAbbv					= CII.UOM
		Left Outer Join GeneralConfiguration GCUOM
			on	GCUOM.GnrlCnfgTblNme		= 'UnitOfMeasure'
			and	GCUOM.GnrlCnfgQlfr			= 'SAPUOMAbbv'
			and	GCUOM.GnrlCnfgHdrID			= UOM.UOM
Where	CII.InterfaceSource		= 'PH'
And		Not Exists	(
					Select	1
					From	MTVSAPAPStaging with (NoLock)
					Where	MTVSAPAPStaging.CIIMssgQID	= CII.MessageQueueID
					)




-- Set the SAP fields
--------------------------------------------------------------------------
Update	#APTemp
Set		DocumentType = REPLACE(IsNull(TransactionGroup.XGrpName, ''),'Document Type ','')
From	#APTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #APTemp.CIIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
		Inner Join TransactionTypeGroup with (NoLock)
			on	TransactionTypeGroup.XTpeGrpTrnsctnTypID		= CAD.TrnsctnTypID
		Inner Join TransactionGroup with (NoLock)
			on	TransactionGroup.XGrpID							= TransactionTypeGroup.XTpeGrpXGrpID
			and	TransactionGroup.XGrpQlfr						= 'SAP Document Types'

-- Try to set the parent doc number (if necessary)
--------------------------------------------------------------------------
Update	#APTemp
Set		ParentDocNumber	= CIL.ID,
		DebitMemo		= 'Y'
From	#APTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #APTemp.CIIID
		Left Outer Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
		Left Outer Join CustomInvoiceLog CIL with (NoLock)
			on	CIL.InvoiceID				= CAD.InvoiceParentInvoiceID
			and	CIL.InvoiceType				= CAD.InterfaceSource
Where	1=1
and		IsNull(CII.ParentInvoiceNumber, '')		<> IsNull(CII.InvoiceNumber, '')
and		IsNull(CII.ParentInvoiceNumber, '')		<> ''

-- Set the PaymentTerm from the SAP code
--------------------------------------------------------------------------
Update	#APTemp
Set		PaymentReference	= Left(Term.TrmVrbge, 30),
		PaymentMethod		= Case	When CAD.XRefExtBAAddressCode = 'United States'
									Then Left(IsNull(GnrlCnfgMulti, ''), 1) --Case Term.TrmPymntMthd When 'A' Then 'D' When 'W' Then 'Z' Else NULL End
									Else 'T'
								End
From	#APTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #APTemp.CIIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
		Inner Join Term with (NoLock)
			on	Term.TrmID					= CAD.InvoiceTrmID
		Left Outer Join GeneralConfiguration with (NoLock)
			on	GnrlCnfgTblNme				= 'Term'
			and	GnrlCnfgQlfr				= 'SAPPayMethod'
			and	GnrlCnfgHdrID				= Term.TrmID
Where	#APTemp.InvoiceLevel	<> 'H'


-- Set the Bank info
--------------------------------------------------------------------------
Update	#APTemp
Set		BankRoute	= CAD.InvoicePaymentBank,
		BankAcct	= CAD.XRefPaymentBankCode
From	#APTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #APTemp.CIIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID


-- Set the plant & material codes for RINS products
--------------------------------------------------------------------------
Update	#APTemp
Set		Plant = 'None',
		Material = 'None'
From	#APTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #APTemp.CIIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
		Inner Join DealType with (NoLock)
			on	DealType.DlTypID			= CAD.DlHdrTyp
Where	DealType.Description = 'Swap Deal'

-- Set the Base Unit for time transactions
--------------------------------------------------------------------------
Update	#APTemp
Set		BaseUnit = Case	when CAD.AcctDtlSrceTble = 'TT' and IsNull(CII.Quantity, 0.00) = 0.00
						then 'Non'
						when CAD.AcctDtlSrceTble = 'P'
						then IsNull(#APTemp.BaseUnit, 'Non')
						else #APTemp.BaseUnit end,
		Plant = IsNull(#APTemp.Plant, 'None'),
		Material = IsNull(#APTemp.Material, 'None')
From	#APTemp
		Inner Join CustomInvoiceInterface CII with (NoLock)
			on	CII.ID						= #APTemp.CIIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CII.AcctDtlID
Where	CAD.AcctDtlSrceTble in ('TT', 'P')

-- Try to set the BOL number
--------------------------------------------------------------------------
Update	#APTemp
Set		ReferenceKey2 = case when MinBOL = MaxBOL then MinBOL else 'Multiple' end
From	#APTemp
		Inner Join (
					Select	Sub.CIIMssgQID,
							Min(Sub.ReferenceKey2) as MinBOL,
							Max(Sub.ReferenceKey2) as MaxBOL
					From	#APTemp Sub with (NoLock)
					Where	Sub.InvoiceLevel	<> 'H'
					Group By Sub.CIIMssgQID
					) as Sub
						on	Sub.CIIMssgQID			= #APTemp.CIIMssgQID
Where	#APTemp.PostingKey		not in ('40','50')



Update	#APTemp
Set		LineItemText = AcctCdeAccnt
From	#APTemp
		Inner Join AccountCode with (NoLock)
			on	AcctCdeCde	= #APTemp.Account
Where	#APTemp.InvoiceLevel	= 'H'

Update	#APTemp
Set		#APTemp.CompanyCode			= IsNull(#APTemp.CompanyCode, Details.CompanyCode),
		#APTemp.DocumentType		= IsNull(#APTemp.DocumentType, Details.DocumentType),
		#APTemp.Vendor				= IsNull(#APTemp.Vendor, Details.Vendor),
		#APTemp.ProfitCenter		= IsNull(#APTemp.ProfitCenter, Details.ProfitCenter),
		#APTemp.PaymentTerm			= IsNull(#APTemp.PaymentTerm, Details.PaymentTerm),
		#APTemp.PaymentMethod		= IsNull(#APTemp.PaymentMethod, Details.PaymentMethod),
		#APTemp.BankRoute			= IsNull(#APTemp.BankRoute, Details.BankRoute),
		#APTemp.BankAcct			= IsNull(#APTemp.BankAcct, Details.BankAcct)
From	#APTemp
		Inner Join #APTemp Details
			on	Details.CIIMssgQID		= #APTemp.CIIMssgQID
			and	Details.InvoiceLevel	<> 'H'
			and	not exists	(
							Select	1
							From	#APTemp Sub
							Where	Sub.CIIMssgQID		= #APTemp.CIIMssgQID
							and		Sub.InvoiceLevel	<> 'H'
							and		Sub.CIIID			< Details.CIIID
							)
Where	#APTemp.InvoiceLevel	= 'H'
And		(
			#APTemp.CompanyCode			is null
		or	#APTemp.DocumentType		is null
		or	#APTemp.Vendor				is null
		or	#APTemp.ProfitCenter		is null
		or	#APTemp.PaymentTerm			is null
		or	#APTemp.PaymentMethod		is null
		)

Update	#APTemp
Set		ParentDocNumber = Details.ParentDocNumber
From	#APTemp
		Inner Join #APTemp Details
			on	Details.CIIMssgQID		= #APTemp.CIIMssgQID
			and	Details.InvoiceLevel	<> 'H'
			and	Details.ParentDocNumber	is not null
			and	not exists	(
							Select	1
							From	#APTemp Sub
							Where	Sub.CIIMssgQID		= #APTemp.CIIMssgQID
							and		Sub.InvoiceLevel	<> 'H'
							and		Sub.ParentDocNumber	is not null
							and		Sub.CIIID			< Details.CIIID
							)
Where	#APTemp.InvoiceLevel		= 'H'
And		#APTemp.ParentDocNumber		is null


Update	#APTemp
Set		#APTemp.ReferenceKey1 = Case When len(IsNull(#APTemp.ReferenceKey1, '')) = 0 Then Details.ReferenceKey1 Else #APTemp.ReferenceKey1 End
From	#APTemp
		Inner Join	(
					Select	CIIMssgQID,
							LineItemText,
							ReferenceKey1
					From	#APTemp Sub
					Where	Sub.InvoiceLevel <> 'H'
					and		not exists (
										Select	1
										From	#APTemp SubSub
										Where	SubSub.CIIMssgQID	= Sub.CIIMssgQID
										And		SubSub.InvoiceLevel	<> 'H'
										And		SubSub.InvoiceLevel	< Sub.InvoiceLevel
										)
					) as Details
			on	Details.CIIMssgQID		= #APTemp.CIIMssgQID

Where	#APTemp.InvoiceLevel					= 'H'
And		len(IsNull(#APTemp.ReferenceKey1, ''))	= 0



/****************************************************************************************************************/
--			Do some initial validation
/****************************************************************************************************************/
Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'DocumentHeaderText is required. '
Where	IsNull(DocumentHeaderText, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'CompanyCode is required. '
Where	IsNull(CompanyCode, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'DocumentDate is required. '
Where	IsNull(DocumentDate, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'DocumentType is required. '
Where	IsNull(DocumentType, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'DocNumber is required. '
Where	IsNull(DocNumber, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'ParentDocNumber is required. '
Where	IsNull(ParentDocNumber, '') = '' and DebitMemo = 'Y'

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'Vendor is required. '
Where	IsNull(Replace(Vendor, '0', ''), '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'Account is required. '
Where	IsNull(Replace(Account, '0', ''), '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'PaymentTerm is required. '
Where	InvoiceLevel = 'H' and IsNull(PaymentTerm, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'BaselineDate is required. '
Where	InvoiceLevel = 'H' and IsNull(BaselineDate, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'LineItemText is required. '
Where	InvoiceLevel <> 'H' and IsNull(LineItemText, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'ReferenceKey1 is required. '
Where	InvoiceLevel <> 'H' and IsNull(ReferenceKey1, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'ReferenceKey2 is required. '
Where	InvoiceLevel <> 'H' and IsNull(ReferenceKey2, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'ReferenceKey3 is required. '
Where	InvoiceLevel <> 'H' and IsNull(ReferenceKey3, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'CostCenter is required. '
Where	InvoiceLevel = 'D' and IsNull(CostCenter, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'ProfitCenter is required. '
Where	InvoiceLevel <> 'H' and IsNull(Replace(ProfitCenter, '0', ''), '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'BaseUnit is required. '
Where	InvoiceLevel <> 'H' and IsNull(BaseUnit, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'Quantity is required. '
Where	InvoiceLevel <> 'H' and Quantity is null

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'Plant is required. '
Where	InvoiceLevel <> 'H' and DocumentType in ('DR', 'DG', 'DD') and IsNull(Plant, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'ReferenceKey1 is required. '
Where	InvoiceLevel <> 'H' and DocumentType in ('DR', 'DG', 'DD') and IsNull(ReferenceKey1, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'Material is required. '
Where	InvoiceLevel <> 'H' and DocumentType in ('DR', 'DG', 'DD') and IsNull(Material, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'TaxCode is required. '
Where	InvoiceLevel = 'T' and DocumentType in ('DR', 'DG', 'DD') and IsNull(TaxCode, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'Currency is required. '
Where	InvoiceLevel <> 'H' and IsNull(Currency, '') = ''

Update	#APTemp Set RightAngleStatus = 'E', Message = Message + 'DocumentAmount is required. '
Where	InvoiceLevel <> 'H' and DocumentAmount is null



Update	#APTemp Set RightAngleStatus = 'E' Where RightAngleStatus <> 'E' and Exists (Select 1 From #APTemp Sub where Sub.CIIMssgQID = #APTemp.CIIMssgQID and Sub.RightAngleStatus = 'E')



/****************************************************************************************************************/
--			Finally... insert into the Stage table
/****************************************************************************************************************/
Insert	MTVSAPAPStaging
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
		,Vendor
		,ReferenceKey1
		,ReferenceKey2
		,ReferenceKey3
		,TaxCode
		,DocumentAmount
		,Account
		,LineItemText
		,CostCenter
		,ProfitCenter
		,PaymentTerm
		,PaymentReference
		,PaymentMethod
		,PaymentBank
		,HouseBank
		,BankRoute
		,BankAcct
		,Material
		,Plant
		,TaxJurisdiction
		,Quantity
		,BaseUnit
		,DebitMemo
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
		,Vendor
		,ReferenceKey1
		,ReferenceKey2
		,ReferenceKey3
		,TaxCode
		,DocumentAmount
		,Account
		,LineItemText
		,CostCenter
		,ProfitCenter
		,PaymentTerm
		,PaymentReference
		,PaymentMethod
		,PaymentBank
		,HouseBank
		,BankRoute
		,BankAcct
		,Material
		,Plant
		,TaxJurisdiction
		,Quantity
		,BaseUnit
		,DebitMemo
		,BaselineDate
		,PaymentBlock
		,RightAngleStatus
		,MiddlewareStatus
		,SAPStatus
		,Message
From	#APTemp


-- select * from MTVSAPAPStaging

/****************************************************************************************************************/
--			Don't forget to update the MTVInvoiceInterfaceStatus table
/****************************************************************************************************************/
Update	MTVInvoiceInterfaceStatus
Set		ARAPStaged = Convert(Bit, 1)
From	#APTemp
		Inner Join MTVInvoiceInterfaceStatus
			on	MTVInvoiceInterfaceStatus.CIIMssgQID	= #APTemp.CIIMssgQID

/****************************************************************************************************************/
--			Check the process in
/****************************************************************************************************************/
exec dbo.sra_checkin_process 'MTVSAPAPCheckout'

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_APStage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SAP_APStage.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SAP_APStage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SAP_APStage >>>'
	  END