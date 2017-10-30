/****** Object:  StoredProcedure [dbo].[MTV_SAP_GLStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SAP_GLStage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_GLStage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SAP_GLStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SAP_GLStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SAP_GLStage]
AS

-- =============================================
-- Author:        J. von Hoff
-- Create date:	  01FEB2016
-- Description:   Stage the AP data into the MTVSAPAPStaging table
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

Create Table #GLTemp
			(
			ID						Int PRIMARY KEY IDENTITY,
			CGLIID					Int,
			BatchID					Int,
			CompanyCode				Varchar(10),
			DocumentDate			SmallDateTime,
			PostingDate				SmallDateTime,
			Currency				Char(3),
			DocumentType			Char(2),
			DocumentHeaderText		Varchar(25),
			ReferenceDocument		Varchar(50),
			PostingKey				Int,
			Customer				Varchar(20),
			ReferenceKey1			Varchar(20),
			ReferenceKey2			Varchar(20),
			ReferenceKey3			Varchar(20),
			TaxCode					Char(2),
			DocumentAmount			Decimal(19,6),
			Account					Varchar(10),
			LineItemText			Varchar(50),
			CostCenter				Varchar(10),
			ProfitCenter			Varchar(10),
			Material				Varchar(18),
			Plant					Char(4),
			Quantity				Decimal(19,6),
			BaseUnit				Char(3),
			RightAngleStatus		Varchar(50),
			MiddlewareStatus		Varchar(50),
			SAPStatus				Varchar(50),
			Message					Varchar(1000)
			)


-- Clear the old data
----------------------------------------
delete MTVSAPGLStaging Where RightAngleStatus in ('M', 'N', 'E')

Declare	@i_AccntngPrdID	int
select @i_AccntngPrdID = min(AccountingPeriod.AccntngPrdID) from AccountingPeriod with (NoLock) where AccntngPrdCmplte = 'N'

Declare	@vc_SalesAccrualXTypeDesc varchar(255)
Declare	@vc_PurchAccrualXTypeDesc varchar(255)
Declare	@i_IncompleteAccrualXTypeID int

Select	@vc_SalesAccrualXTypeDesc = Registry.RgstryDtaVle
From	Registry (NoLock)
Where	RgstryFllKyNme = 'Motiva\SAP\GLXctnTypes\SalesAccrual\'

Select	@vc_PurchAccrualXTypeDesc = Registry.RgstryDtaVle
From	Registry (NoLock)
Where	RgstryFllKyNme = 'Motiva\SAP\GLXctnTypes\PurchaseAccrual\'

Select	@i_IncompleteAccrualXTypeID = TransactionType.TrnsctnTypID
From	Registry (NoLock)
		Inner Join TransactionType (NoLock)
			on	TransactionType.TrnsctnTypDesc = Registry.RgstryDtaVle
Where	RgstryFllKyNme = 'Motiva\SAP\GLXctnTypes\IncompletePricingAccrual\'

/*******************************************************
--		GL Type - Unsent sales & payable invoices
********************************************************/
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		case CGLI.PostingType
			when 'AR' then 'SV'
			when 'AP' then 'SW'
		end											as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		case CGLI.PostingType
			when 'AR' then 'Sales Unsent Invoiced'
			when 'AP' then 'Unpaid Payable Transactions Invoiced'
		end 										as	ReferenceDocument,

		case CGLI.PostingType
			when 'AR' then 	Case
							When CAD.LocalValue > 0 and CGLI.LocalCreditValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
							When CAD.LocalValue < 0 and CGLI.LocalCreditValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
							When CAD.LocalValue > 0 and CGLI.LocalDebitValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
							When CAD.LocalValue < 0 and CGLI.LocalDebitValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
							End
			when 'AP' then	Case
							When CGLI.LocalCreditValue	> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
							When CGLI.LocalCreditValue	< 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
							When CGLI.LocalDebitValue	> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
							When CGLI.LocalDebitValue	< 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
							End
		end 				as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		Left(CGLI.BL,12)							as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		case CGLI.PostingType
			when 'AR' then 'ZY'
			when 'AP' then 'ZZ'
		end 										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,
		Left(CGLI.TransactionType, 50)				as	LineItemText,
		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	CGLI.PostingType				in ('AR','AP')
and		IsNull(CAD.MvtHdrTypName, 'x')	<> 'Accrual'
and		CAD.TrnsctnTypDesc				not like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID


/*******************************************************
--		GL Type - Uninvoiced sales transactions
********************************************************/
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		'SV'										as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		'Sales Not Invoiced'						as	ReferenceDocument,

		Case
			When CAD.LocalValue > 0 and CGLI.LocalCreditValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
			When CAD.LocalValue < 0 and CGLI.LocalCreditValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
			When CAD.LocalValue > 0 and CGLI.LocalDebitValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
			When CAD.LocalValue < 0 and CGLI.LocalDebitValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
		End											as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		Left(CGLI.BL,12)							as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		'ZY'										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,
		Left(CGLI.TransactionType, 50)				as	LineItemText,
		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	CGLI.PostingType				in ('AD', 'AM')
and		CAD.WePayTheyPay				= 'D'
and		IsNull(CAD.MvtHdrTypName, 'x')	<> 'Accrual'
and		CAD.TrnsctnTypDesc				not like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID




/*******************************************************
--		GL Type - Unpaid payables not on invoices
********************************************************/
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		'SW'										as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		'Unpaid Payable Transactions Not Invoiced' as	ReferenceDocument,

		Case
			When CGLI.LocalCreditValue	> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
			When CGLI.LocalCreditValue	< 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
			When CGLI.LocalDebitValue	> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
			When CGLI.LocalDebitValue	< 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
		End											as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		Left(CGLI.BL,12)							as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		'ZZ'										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,
		Left(CGLI.TransactionType, 50)				as	LineItemText,
		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	CGLI.PostingType				in ('AD', 'AM')
and		CAD.WePayTheyPay				= 'R'
and		IsNull(CAD.MvtHdrTypName, 'x')	<> 'Accrual'
and		CAD.TrnsctnTypDesc				not like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID



/*******************************************************
--		GL Type - Incomplete pricing (accruals)
********************************************************/
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		'SJ'										as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		'Incomplete Price'							as	ReferenceDocument,

		Case
			When CAD.LocalValue > 0 and CGLI.LocalCreditValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
			When CAD.LocalValue < 0 and CGLI.LocalCreditValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
			When CAD.LocalValue > 0 and CGLI.LocalDebitValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 50 else 40 end
			When CAD.LocalValue < 0 and CGLI.LocalDebitValue <> 0 then case when CAD.WePayTheyPay + CAD.Reversed in ('RN', 'DY') then 40 else 50 end
		End						as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		Left(CGLI.BL,12)							as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		null										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,

		case
			when CAD.WePayTheyPay = 'R' then Left(@vc_SalesAccrualXTypeDesc, 50)
			when CAD.WePayTheyPay = 'D' then Left(@vc_PurchAccrualXTypeDesc, 50)
			else Left(CGLI.TransactionType, 50)
		end											as	LineItemText,

		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	CAD.TrnsctnTypID					= @i_IncompleteAccrualXTypeID
and		IsNull(CAD.MvtHdrTypName, 'x')	<> 'Accrual'
and		CAD.TrnsctnTypDesc				not like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID


/*******************************************************
--		GL Type - Planned Movement - Actualized as Estimated
********************************************************/
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		'SJ'										as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		'Planned Movement Actualized as Estimated'
													as	ReferenceDocument,

		CGLI.LineType								as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		Left(CGLI.BL,12)							as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		null										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,
		Left(CGLI.TransactionType, 50)				as	LineItemText,
		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	IsNull(CAD.MvtHdrTypName, 'x')	= 'Accrual'
and		CAD.TrnsctnTypDesc				not like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID



/*******************************************************
--		GL Type - Posted Unrealized Financial Trades at EOM
********************************************************/
/*		-- commenting out for defect 8166
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		'SJ'										as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		'Posted unrealized financial trades at EOM' as	ReferenceDocument,

		Case When ABS(CGLI.LocalDebitValue) <> 0.0 then 40
			When ABS(CGLI.LocalCreditValue) <> 0.0 then 50
		End											as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		Left(CGLI.BL,12)							as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		null										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,
		Left(CGLI.TransactionType, 50)				as	LineItemText,
		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	IsNull(CAD.MvtHdrTypName, 'x')	<> 'Accrual'
and		CAD.TrnsctnTypID				in (2027,2028,2029,2030)
and		CAD.TrnsctnTypDesc				not like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID
*/


/*******************************************************
--		GL Type - Posted Realized Financial Trades at EOM
********************************************************/
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		'SJ'										as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		'Posted realized financial trades at EOM'	as	ReferenceDocument,
		
		Case When ABS(CGLI.LocalCreditValue) <> 0.0 -- I'm a credit account
				and	CAD.WePayTheyPay = 'R'
				and	CAD.LocalValue < 0 -- I'm negative (Credits get multiplied by -1 in Search Account Code)
				then 40 else 50
		End											as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		Left(CGLI.BL,12)							as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		null										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,
		Left(CGLI.TransactionType, 50)				as	LineItemText,
		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message					-- No mapping
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	CGLI.PostingType				in ('FT', 'IH', 'SW', 'RA')
and		IsNull(CAD.MvtHdrTypName, 'x')	<> 'Accrual'
and		CAD.TrnsctnTypID				not in (2027,2028,2029,2030)
and		CAD.TrnsctnTypDesc				not like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID


/*******************************************************
--		GL Type - Transfer Price
********************************************************/
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		'HL'										as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		'Transfer Price'							as	ReferenceDocument,

		Case
			When CGLI.LocalCreditValue > 0 then case when CAD.WePayTheyPay = 'R' then 40 else 50 end
			When CGLI.LocalCreditValue < 0 then case when CAD.WePayTheyPay = 'R' then 50 else 40 end
			When CGLI.LocalDebitValue > 0 then case when CAD.WePayTheyPay = 'R' then 50 else 40 end
			When CGLI.LocalDebitValue < 0 then case when CAD.WePayTheyPay = 'R' then 40 else 50 end
		End											as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		Left(CGLI.BL,12)							as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		null										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,
		Left(CGLI.TransactionType, 50)				as	LineItemText,
		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message					-- No mapping
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	CGLI.PostingType				in ('FT', 'IH', 'SW', 'RA', 'AD', 'PH')
and		IsNull(CAD.MvtHdrTypName, 'x')	<> 'Accrual'
and		CAD.TrnsctnTypDesc				like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID
and		CAD.AccntngPrdID				= @i_AccntngPrdID


/*******************************************************
--		GL Type - Inventory
********************************************************/
Insert	#GLTemp
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	CGLI.ID										as	CGLIID,
		CGLI.BatchID								as	BatchID,
		Left(CADA.SAPCompanyCode, 10)				as	CompanyCode,
		CGLI.DocumentDate							as	DocumentDate,
		CGLI.PostingDate							as	PostingDate,
		CAD.Currency								as	Currency,
		'HL'										as	DocumentType,
		CGLI.AcctDtlID								as	DocumentHeaderText,
		'Market Inventory Valuation'				as	ReferenceDocument,
		
		IsNull(
		Case
			When CAD.LocalValue > 0 and CGLI.LocalCreditValue <> 0 then case CAD.Reversed when 'Y' then 40 else 50 end
			When CAD.LocalValue < 0 and CGLI.LocalCreditValue <> 0 then case CAD.Reversed when 'Y' then 50 else 40 end
			When CAD.LocalValue > 0 and CGLI.LocalDebitValue <> 0 then case CAD.Reversed when 'Y' then 50 else 40 end
			When CAD.LocalValue < 0 and CGLI.LocalDebitValue <> 0 then case CAD.Reversed when 'Y' then 40 else 50 end
		End, CGLI.LineType)							as	PostingKey,

		null										as	Customer,
		Left(CADA.SAPStrategy,20)					as	ReferenceKey1,
		null										as	ReferenceKey2,
		Left(CAD.DlHdrIntrnlNbr,20)					as	ReferenceKey3,
		null										as	TaxCode,
		CGLI.AbsLocalValue							as	DocumentAmount,
		Left(CGLI.Chart, 10)						as	Account,
		Left(CGLI.TransactionType, 50)				as	LineItemText,
		Left(CADA.SAPCostCenter, 10)				as	CostCenter,
		Left(CADA.SAPProfitCenter, 10)				as	ProfitCenter,
		Left(CADA.SAPMaterialCode, 10)				as	Material,
		Left(CADA.SAPPlantCode, 10)					as	Plant,
		CGLI.Quantity								as	Quantity,
		null										as	BaseUnit,
		'N'											as	RightAngleStatus,
		null										as	MiddlewareStatus,
		null										as	SAPStatus,
		null										as	Message
-- Select	*
From	CustomGLInterface as CGLI with (NoLock)
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join CustomAccountDetailAttribute CADA with (NoLock)
			on	CADA.CADID					= CAD.ID
Where	CGLI.PostingType				in ('IV')
and		IsNull(CAD.MvtHdrTypName, 'x')	<> 'Accrual'
and		CAD.TrnsctnTypDesc				not like 'TP%'
and		CGLI.AccntngPrdID				= @i_AccntngPrdID


create nonclustered index idx1_tmp on #GLTemp (Account)
create nonclustered index idx2_tmp on #GLTemp (DocumentHeaderText)
create nonclustered index idx3_tmp on #GLTemp (LineItemText)

-- Do our GL Account Number override stuff
--    for non-tax stuff, if our PRIMARY account is in XREF, change our OFFSET account
Update	#GLTemp
Set		#GLTemp.Account	= Left(SSEX.InternalValue, 10)
-- select	DocumentHeaderText, Account, *
From	#GLTemp
		Inner Join SourceSystem
			on	SourceSystem.Name				= 'SAP Account Override'
		Inner Join SourceSystemElement SSE
			on	SSE.SrceSystmID					= SourceSystem.SrceSystmID
			and	SSE.ElementName					= 'NonTaxAccount'
		Inner Join SourceSystemElementXref SSEX
			on	SSEX.SrceSystmElmntID			= SSE.SrceSystmElmntID
			and	SSEX.InternalValue				<> #GLTemp.Account
Where	Exists	(
				Select	1
				From	#GLTemp Sub
				Where	Sub.DocumentHeaderText		= #GLTemp.DocumentHeaderText
				and		Sub.Account					= SSEX.ElementValue
				and		Sub.Account					<> #GLTemp.Account
				)
and		Left(#GLTemp.LineItemText, 5)	<> 'Tax -'


-- Do our GL Account Number override stuff -- DO IT AGAIN, FOR -AR or -AP items
--    for non-tax stuff, if our PRIMARY account is in XREF, change our OFFSET account
Update	#GLTemp
Set		#GLTemp.Account	= Left(SSEX.InternalValue, 10)
From	#GLTemp
		Inner Join CustomGLInterface as CGLI with (NoLock)
			on	CGLI.ID							= #GLTemp.CGLIID
		Inner Join CustomAccountDetail as CAD with (NoLock)
			on	CGLI.AcctDtlID					= CAD.AcctDtlID
			and	CAD.BatchID						= CGLI.BatchID
		Inner Join SourceSystem with (NoLock)
			on	SourceSystem.Name				= 'SAP Account Override'
		Inner Join SourceSystemElement SSE with (NoLock)
			on	SSE.SrceSystmID					= SourceSystem.SrceSystmID
			and	SSE.ElementName					= 'NonTaxAccount'
		Inner Join SourceSystemElementXref SSEX with (NoLock)
			on	SSEX.SrceSystmElmntID			= SSE.SrceSystmElmntID
			and	SSEX.InternalValue				<> #GLTemp.Account
Where	Exists	(
				Select	1
				From	#GLTemp Sub
				Where	Sub.DocumentHeaderText		= #GLTemp.DocumentHeaderText
				and		SSEX.ElementValue			= Sub.Account + '-' + Case CAD.WePayTheyPay When 'D' Then 'AR' When 'R' Then 'AP' End
				and		Sub.Account					<> #GLTemp.Account
				)
and		Left(#GLTemp.LineItemText, 5)	<> 'Tax -'


-- Do our GL Account Number override stuff
--    for TAX stuff, if our PRIMARY account is in XREF, change our PRIMARY account
Update	#GLTemp
Set		#GLTemp.Account	= Left(SSEX.InternalValue, 10)
-- select	DocumentHeaderText, Account, *
From	#GLTemp
		Inner Join SourceSystem with (NoLock)
			on	SourceSystem.Name				= 'SAP Account Override'
		Inner Join SourceSystemElement SSE with (NoLock)
			on	SSE.SrceSystmID					= SourceSystem.SrceSystmID
			and	SSE.ElementName					= 'TaxAccount'
		Inner Join SourceSystemElementXref SSEX with (NoLock)
			on	SSEX.SrceSystmElmntID			= SSE.SrceSystmElmntID
			and	SSEX.InternalValue				<> #GLTemp.Account
Where	#GLTemp.Account					= SSEX.ElementValue
and		Left(#GLTemp.LineItemText, 5)	= 'Tax -'


-- Set the UOM
Update	#GLTemp
Set		#GLTemp.BaseUnit	= Left(GCUOM.GnrlCnfgMulti, 3)
From	#GLTemp
		Inner Join CustomGLInterface CGLI
			on	CGLI.ID						= #GLTemp.CGLIID
		Inner Join UnitOfMeasure UOM
			on	UOM.UOMAbbv					= Case When CGLI.PostingType = 'IV' Then 'gal' Else CGLI.UOM End
		Left Outer Join GeneralConfiguration GCUOM
			on	GCUOM.GnrlCnfgTblNme		= 'UnitOfMeasure'
			and	GCUOM.GnrlCnfgQlfr			= 'SAPUOMAbbv'
			and	GCUOM.GnrlCnfgHdrID			= UOM.UOM

Update	#GLTemp
Set		#GLTemp.BaseUnit	= 'NON',
		#GLTemp.Plant		= 'NONE',
		#GLTemp.Material	= 'NONE',
		#GLTemp.Quantity	= NULL
From	#GLTemp
		Inner Join CustomGLInterface CGLI
			on	CGLI.ID						= #GLTemp.CGLIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
		Inner Join DealType with (NoLock)
			on	DealType.DlTypID			= CAD.DlHdrTyp
Where	DealType.Description in (	'Future Deal',
									'Option Deal',
									'Swap Deal',
									'OTC Option Deal',
									'EFP Deal',
									'EFS Deal',
									'Future Inhouse Deal',
									'Swap Inhouse Deal',
									'Option Inhouse Deal',
									'OTC Option Inhouse Deal',
									'What If Future Deal',
									'What If Option Deal',
									'FX Forward Deal',
									'FX Swap Deal',
									'FX Forward In-house Deal',
									'FX Swap Inhouse Deal')


Update	#GLTemp
Set		#GLTemp.BaseUnit	= 'NON',
		#GLTemp.Plant		= 'NONE',
		#GLTemp.Material	= 'NONE',
		#GLTemp.Quantity	= NULL
From	#GLTemp
		Inner Join CustomGLInterface CGLI
			on	CGLI.ID						= #GLTemp.CGLIID
		Inner Join CustomAccountDetail CAD with (NoLock)
			on	CAD.AcctDtlID				= CGLI.AcctDtlID
			and	CAD.BatchID					= CGLI.BatchID
			and	CAD.InterfaceSource			= 'GL'
Where	CAD.AcctDtlSrceTble = 'TT'


Update	#GLTemp
Set		DocumentHeaderText = DocumentHeaderText + 'R'
Where	Exists	(
				Select	1
				From	#GLTemp Older with (NoLock)
				Where	Older.DocumentHeaderText	= #GLTemp.DocumentHeaderText
				And		Older.PostingDate			< #GLTemp.PostingDate
				)

Update	#GLTemp
Set		DocumentHeaderText = DocumentHeaderText + '-' + convert(Varchar, @i_AccntngPrdID)

/****************************************************************************************************************/
--			Do some initial validation
/****************************************************************************************************************/

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'DocumentHeaderText is required. '
Where	IsNull(DocumentHeaderText, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'CompanyCode is required. '
Where	IsNull(CompanyCode, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'DocumentDate is required. '
Where	IsNull(DocumentDate, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'DocumentType is required. '
Where	IsNull(DocumentType, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'Account is required. '
Where	IsNull(Replace(Account, '0', ''), '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'LineItemText is required. '
Where	IsNull(LineItemText, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'ReferenceKey1 is required. '
Where	IsNull(ReferenceKey1, '') = ''

--Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'ReferenceKey2 is required. '
--Where	IsNull(ReferenceKey2, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'CostCenter is required. '
Where	IsNull(CostCenter, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'ProfitCenter is required. '
Where	IsNull(Replace(ProfitCenter, '0', ''), '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'BaseUnit is required. '
Where	IsNull(BaseUnit, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'Quantity is required. '
Where	Quantity is null and BaseUnit <> 'NON'

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'Plant is required. '
Where	IsNull(Plant, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'Material is required. '
Where	IsNull(Material, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'Currency is required. '
Where	IsNull(Currency, '') = ''

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'DocumentAmount is required. '
Where	DocumentAmount is null

Update	#GLTemp Set RightAngleStatus = 'E', Message = IsNull(Message, '') + 'TaxCode is required. '
Where	IsNull(TaxCode, '') = '' and LineItemText like 'Tax -%'

/****************************************************************************************************************/
--			Keep disaggregated data for posterity (and debugging!)
/****************************************************************************************************************/
Insert	MTVSAPGLStagingPreAggregate
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message,
		AcctDtlID,
		AccntngPrdID
		)
Select	CGLIID										as CGLIID,
		#GLTemp.BatchID								as BatchID,
		#GLTemp.CompanyCode							as CompanyCode,
		#GLTemp.DocumentDate						as DocumentDate,
		#GLTemp.PostingDate,
		#GLTemp.Currency							as Currency,
		#GLTemp.DocumentType						as DocumentType,
		'G'+ #GLTemp.DocumentHeaderText				as DocumentHeaderText,
		Left(#GLTemp.ReferenceDocument, 16)			as ReferenceDocument,
		#GLTemp.PostingKey,
		#GLTemp.Customer							as Customer,
		#GLTemp.ReferenceKey1						as ReferenceKey1,
		null										as ReferenceKey2,
		null										as ReferenceKey3,
		#GLTemp.TaxCode								as TaxCode,
		#GLTemp.DocumentAmount						as DocumentAmount,
		#GLTemp.Account,
		null										as LineItemText,
		#GLTemp.CostCenter,
		#GLTemp.ProfitCenter,
		#GLTemp.Material,
		#GLTemp.Plant,
		#GLTemp.Quantity							as Quantity,
		#GLTemp.BaseUnit							as BaseUnit,
		'N'											as RightAngleStatus,
		null										as MiddlewareStatus,
		null										as SAPStatus,
		null										as Message,
		CGLI.AcctDtlID								as AcctDtlID,
		CGLI.AccntngPrdID							as AccntngPrdID
From	#GLTemp with (NoLock)
		Inner Join CustomGLInterface as CGLI with (NoLock)
			on	CGLI.ID							= #GLTemp.CGLIID


/****************************************************************************************************************/
--			Finally... insert into the Stage table
/****************************************************************************************************************/
Insert	MTVSAPGLStaging
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	min(CGLIID)							as CGLIID,
		min(BatchID)						as BatchID,
		min(CompanyCode)					as CompanyCode,
		min(DocumentDate)					as DocumentDate,
		PostingDate,
		min(Currency)						as Currency,
		min(DocumentType)					as DocumentType,
		'G'+ min(DocumentHeaderText)		as DocumentHeaderText,
		Left(ReferenceDocument, 16)			as ReferenceDocument,
		PostingKey,
		min(Customer)						as Customer,
		min(ReferenceKey1)					as ReferenceKey1,
		null								as ReferenceKey2,
		null								as ReferenceKey3,
		min(TaxCode)						as TaxCode,
		Sum(DocumentAmount)					as DocumentAmount,
		Account,
		null								as LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Sum(Quantity)						as Quantity,
		min(BaseUnit)						as BaseUnit,
		'N'									as RightAngleStatus,
		null								as MiddlewareStatus,
		null								as SAPStatus,

		null								as Message

From	#GLTemp with (NoLock)
Where	not exists	(
					Select	1
					from	#GLTemp sub with (NoLock)
					where	sub.PostingDate					= #GLTemp.PostingDate
					and		sub.PostingKey					= #GLTemp.PostingKey
					and		IsNull(sub.Account, 'x')		= IsNull(#GLTemp.Account, 'x')
					and		IsNull(sub.CostCenter, 'x')		= IsNull(#GLTemp.CostCenter, 'x')
					and		IsNull(sub.ProfitCenter, 'x')	= IsNull(#GLTemp.ProfitCenter, 'x')
					and		IsNull(sub.Material, 'x')		= IsNull(#GLTemp.Material, 'x')
					and		IsNull(sub.Plant, 'x')			= IsNull(#GLTemp.Plant, 'x')
					and		sub.Message is not null
					)
GROUP BY PostingDate, PostingKey, Account, CostCenter, ProfitCenter, Material, Plant, ReferenceDocument


-- Now get the ones with Error messages
Insert	MTVSAPGLStaging
		(
		CGLIID,
		BatchID,
		CompanyCode,
		DocumentDate,
		PostingDate,
		Currency,
		DocumentType,
		DocumentHeaderText,
		ReferenceDocument,
		PostingKey,
		Customer,
		ReferenceKey1,
		ReferenceKey2,
		ReferenceKey3,
		TaxCode,
		DocumentAmount,
		Account,
		LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Quantity,
		BaseUnit,
		RightAngleStatus,
		MiddlewareStatus,
		SAPStatus,
		Message
		)
Select	min(CGLIID)							as CGLIID,
		min(BatchID)						as BatchID,
		min(CompanyCode)					as CompanyCode,
		min(DocumentDate)					as DocumentDate,
		PostingDate,
		min(Currency)						as Currency,
		min(DocumentType)					as DocumentType,
		'G'+ min(DocumentHeaderText)		as DocumentHeaderText,
		Left(ReferenceDocument, 16)			as ReferenceDocument,
		PostingKey,
		min(Customer)						as Customer,
		min(ReferenceKey1)					as ReferenceKey1,
		null								as ReferenceKey2,
		null								as ReferenceKey3,
		min(TaxCode)						as TaxCode,
		Sum(DocumentAmount)					as DocumentAmount,
		Account,
		null								as LineItemText,
		CostCenter,
		ProfitCenter,
		Material,
		Plant,
		Sum(Quantity)						as Quantity,
		min(BaseUnit)						as BaseUnit,
		'E'									as RightAngleStatus,
		null								as MiddlewareStatus,
		null								as SAPStatus,

		(SELECT DISTINCT '' + Message
		from	#GLTemp sub with (NoLock)
		where	sub.PostingDate		= #GLTemp.PostingDate
		and		sub.PostingKey		= #GLTemp.PostingKey
		and		IsNull(sub.Account, 'x')		= IsNull(#GLTemp.Account, 'x')
		and		IsNull(sub.CostCenter, 'x')		= IsNull(#GLTemp.CostCenter, 'x')
		and		IsNull(sub.ProfitCenter, 'x')	= IsNull(#GLTemp.ProfitCenter, 'x')
		and		IsNull(sub.Material, 'x')		= IsNull(#GLTemp.Material, 'x')
		and		IsNull(sub.Plant, 'x')			= IsNull(#GLTemp.Plant, 'x')

		FOR XML PATH (''))		as Message

From	#GLTemp with (NoLock)
Where	exists	(
				Select	1
				from	#GLTemp sub with (NoLock)
				where	sub.PostingDate					= #GLTemp.PostingDate
				and		sub.PostingKey					= #GLTemp.PostingKey
				and		IsNull(sub.Account, 'x')		= IsNull(#GLTemp.Account, 'x')
				and		IsNull(sub.CostCenter, 'x')		= IsNull(#GLTemp.CostCenter, 'x')
				and		IsNull(sub.ProfitCenter, 'x')	= IsNull(#GLTemp.ProfitCenter, 'x')
				and		IsNull(sub.Material, 'x')		= IsNull(#GLTemp.Material, 'x')
				and		IsNull(sub.Plant, 'x')			= IsNull(#GLTemp.Plant, 'x')
				and		sub.Message is not null
				)

GROUP BY PostingDate, PostingKey, Account, CostCenter, ProfitCenter, Material, Plant, ReferenceDocument

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SAP_GLStage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SAP_GLStage.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SAP_GLStage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SAP_GLStage >>>'
	  END