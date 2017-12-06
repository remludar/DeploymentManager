
------------------------------------------------------------------------------------------------------------------
--Begining Of Script
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_RegressDev_20171206_082223\StoredProcedures\MTVDLInvStage.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
PRINT 'Start Script=SP_MTV_DLInvStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_DLInvStage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_DLInvStage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_DLInvStage]		@i_AccntngPrdID int = null
AS

-- =============================================
-- Author:        Jeremy von Hoff
-- Create date:	  24MAR2016
-- Description:   This SP compiles inventory data, and stages it to
--		MTVDLInvTransactionsStaging, MTVDLInvBalancesStaging and MTVDLInvPricesStaging
--		ready for the user to run the DataLakeInventoryExtract job
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
-- exec MTV_DLInvStage 0
/*

select * from MTVDLInvTransactionsStaging
select * from MTVDLInvBalancesStaging
select * from MTVDLInvPricesStaging
*/

DECLARE	@vc_ErrorString				Varchar(1000),
		@vc_AcctMonth				Varchar(20),
		@i_VETradePeriodID			Int,
		@sdt_InsertDate				SmallDateTime

/*******************************************
Can't do much without our Period
********************************************/
--if @i_AccntngPrdID is null
--	select	@i_AccntngPrdID = min(AccountingPeriod.AccntngPrdID)
--	From	AccountingPeriod
--	Where	AccountingPeriod.AccntngPrdCmplte = 'N'

if IsNull(@i_AccntngPrdID, -1) = -1
begin
	set @vc_ErrorString = 'No accounting period was provided.';
	THROW 51000, @vc_ErrorString, 1
end

if @i_AccntngPrdID = 0 -- pick the current open period
	select @i_AccntngPrdID = min(AccountingPeriod.AccntngPrdID) from AccountingPeriod with (NoLock) where AccntngPrdCmplte = 'N'

Select	@vc_AcctMonth = AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')
From	AccountingPeriod
Where	AccntngPrdID = @i_AccntngPrdID


if exists	(
			Select	1
			From	MTVDLInvInventoryTransactionsStaging Stg
			Where	Stg.AccountingPeriod	= @vc_AcctMonth
			And		Stg.Status				= 'C'
			)
or exists	(
			Select	1
			From	MTVDLInvTransactionsStaging Stg
			Where	Stg.AccountingMonth		= @vc_AcctMonth
			And		Stg.Status				= 'C'
			)
or exists	(
			Select	1
			From	MTVDLInvBalancesStaging Stg
			Where	Stg.AccountingMonth		= @vc_AcctMonth
			And		Stg.Status				= 'C'
			)
or exists	(
			Select	1
			From	MTVDLInvPricesStaging Stg
			Where	Stg.AccountingMonth		= @vc_AcctMonth
			And		Stg.Status				= 'C'
			)
begin
	set @vc_ErrorString = 'There are Complete records for this Accounting Period ('+ @vc_AcctMonth + ') already';
	THROW 51000, @vc_ErrorString, 1
end
else -- We don't have any Complete records, so we'll purge everything for this Accounting Period and start over
begin
	Delete	MTVDLInvInventoryTransactionsStaging
	Where	MTVDLInvInventoryTransactionsStaging.AccountingPeriod		= @vc_AcctMonth

	Delete	MTVDLInvTransactionsStaging
	Where	MTVDLInvTransactionsStaging.AccountingMonth					= @vc_AcctMonth

	Delete	MTVDLInvBalancesStaging
	Where	MTVDLInvBalancesStaging.AccountingMonth						= @vc_AcctMonth

	Delete	MTVDLInvPricesStaging
	Where	MTVDLInvPricesStaging.AccountingMonth						= @vc_AcctMonth
end

select	@i_VETradePeriodID = VETradePeriodID
From	PeriodTranslation
Where	AccntngPrdID = @i_AccntngPrdID

if @i_VETradePeriodID is null
	return

select @sdt_InsertDate = GetDate()

Create Table #InvBalance
			(
			AccountingMonth							Varchar(20),
			ISDID									Int,
			DlHdrID									Int,
			BalanceDlDtlID							Int,
			DealNumber								Varchar(20),
			DetailNumber							Int,
			BlendProduct							Char(3),
			ThirdPartyFlag							Varchar(255),
			EquityTerminalIndicator					Varchar(255),
			DealType								Varchar(80),
			StorageLocation							Varchar(255),
			ProductName								Varchar(150),
			RegradeProductName						Varchar(150),
			ProductGroup							Varchar(150),
			Subgroup								Varchar(150),
			MSAPPlantNumber							Varchar(255),
			MSAPMaterialNumber						Varchar(255),
			TradingBook								Varchar(120),
			ProfitCenter							Varchar(255),
			BegInvVolume							Decimal(19,6),
			EndingInvVolume							Decimal(19,6),
			UOM										Char(20),
			PerUnitValue							Decimal(19,6),
			EndingInvValue							Decimal(19,6),
			LocationCity							Varchar(255),
			LocationState							Varchar(255),
			LocationAddress							Varchar(255),
			LocationTCN								Varchar(255),
			LocationZip								Varchar(255),
			LocationType							Varchar(80),
			TerminalOperator						Varchar(255),
			PositionHolderName						Varchar(70),
			PositionHolderFEIN						Varchar(255),
			PositionHolderNameControl				Varchar(255),
			PositionHolderID						Varchar(255),
			LocationID								Int,
			FTAProductCode							Varchar(255),
			RATaxCommodity							Varchar(80),
			RegradeProductFTACode					Varchar(255),
			RegradeProductTaxCommodity				Varchar(80),
			TotalReceipts							Decimal(19,6),
			TotalDisbursement						Decimal(19,6),
			TotalBlend								Decimal(19,6),
			GainLoss								Decimal(19,6),
			BookAdjReason							Varchar(255),
			EndingPhysicalBalance					Decimal(19,6),
			GradeOfProduct							Varchar(255),
			StagingTableLoadDate					Smalldatetime,
			Status									Char(1)
			)

/*******************************************
Get the Inventory Transactions
********************************************/
Insert	MTVDLInvInventoryTransactionsStaging
		(
		AccountingPeriod,
		LogicalAccountingPeriod,
		Location,
		OriginLocale,
		DestinationLocation,
		Product,
		MaterialNumber,
		PlantCode,
		Quantity,
		UOM,
		MovementDate,
		MovementDocumentExternalNumber,
		ExternalBatch,
		DealNumber,
		DealTemplate,
		OurCompany,
		TheirCompany,
		SourceTable,
		ReasonCode,
		Direction,
		Reversal,
		OriginBaseProduct,
		OriginBaseLocation,
		OriginMaterialNumber,
		OriginPlantCode,
		SourceDealTemplate,
		StagingTableLoadDate,
		Status
		)
Select	ClosedAP.AccntngPrdYr + '-' + format(ClosedAP.AccntngPrdPrd, 'd2')				as	AccountingPeriod,
		LogicalAP.AccntngPrdYr + '-' + format(LogicalAP.AccntngPrdPrd, 'd2')			as	LogicalAccountingPeriod,
		TitleXfer.LcleAbbrvtn + IsNull(TitleXfer.LcleAbbrvtnExtension, '')				as	Location,
		Origin.LcleAbbrvtn + IsNull(Origin.LcleAbbrvtnExtension, '')					as	OriginLocale,
		Destination.LcleAbbrvtn + IsNull(Destination.LcleAbbrvtnExtension, '')			as	DestinationLocation,
		Product.PrdctAbbv																as	Product,
		GCMaterialNumber.GnrlCnfgMulti													as	MaterialNumber,
		GCPlantCode.GnrlCnfgMulti														as	PlantCode,
		InventoryReconcile.XhdrQty / 42.0
			* Case InventoryReconcile.XHdrTyp
				When 'R' Then -1.0
				When 'D' Then 1.0
				End
			* Case InventoryReconcile.InvntryRcncleRvrsd
				When 'Y' Then -1.0
				When 'N' Then 1.0
				End																		as	Quantity,
		'BBL'																			as	UOM,
		InventoryReconcile.MovementDate													as	MovementDate,
		MovementDocument.MvtDcmntExtrnlDcmntNbr											as	MovementDocumentExternalNumber,
		MovementHeader.ExternalBatch													as	ExternalBatch,
		DealHeader.DlHdrIntrnlNbr														as	DealNumber,
		DealHeaderTemplate.Description													as	DealTemplate,
		IntBA.Abbreviation																as	OurCompany,
		ExtBA.Abbreviation																as	TheirCompany,
		Case InventoryReconcile.InvntryRcncleSrceTble
			When 'X' Then 'Movement'
			When 'U' Then 'Missing'
			When 'R' Then 'Regrade'
			When 'V' Then 'ValueOnly'
		End																				as	SourceTable,
		AccountingReasonCode.Abbreviation												as	ReasonCode,
		InventoryReconcile.XHdrTyp														as	Direction,
		InventoryReconcile.InvntryRcncleRvrsd											as	Reversal,
		PrdctOrigin.PrdctAbbv															as	OriginBaseProduct,
		LcleOrigin.LcleAbbrvtn + IsNull(LcleOrigin.LcleAbbrvtnExtension, '')			as	OriginBaseLocation,
		GCOrigMaterialNumber.GnrlCnfgMulti												as	OriginMaterialNumber,
		GCOrigPlantCode.GnrlCnfgMulti													as	OriginPlantCode,
		DTRec.Description																as	SourceDealTemplate,
		@sdt_InsertDate																	as	StagingTableLoadDate,
		'N'																				as	Status



-- select XHDeliv.*, XHRec.*, IRRec.*, *
From	InventoryReconcile with (NoLock)
		Inner Join AccountingPeriod ClosedAP with (NoLock)
			on	ClosedAP.AccntngPrdID						= InventoryReconcile.InvntryRcncleClsdAccntngPrdID
		Inner Join AccountingPeriod LogicalAP with (NoLock)
			on	LogicalAP.AccntngPrdID						= InventoryReconcile.LogicalAccntngPrdID
        Left Outer Join TransactionHeader XHDeliv with (NoLock)
                on	InventoryReconcile.InvntryRcncleSrceID			= XHDeliv.XHdrID
                and	InventoryReconcile.InvntryRcncleSrceTble		= 'X'
                and	InventoryReconcile.XHdrTyp						= 'D' -- delivery into storage
        Left Outer Join TransactionHeader XHRec with (NoLock)
                on	XHRec.XHdrMvtDtlMvtHdrID						= XHDeliv.XHdrMvtDtlMvtHdrID
				and	XHRec.MvtHdrTyp									= XHDeliv.MvtHdrTyp
				and	XHRec.XHdrStat									= XHDeliv.XHdrStat
				and	XHRec.MvtHdrArchveID							= XHDeliv.MvtHdrArchveID
				and	XHRec.XHdrDte									= XHDeliv.XHdrDte
				and	XHRec.XHdrTyp									= 'R'
				and	exists	(
							Select	1
							From	PlannedTransfer PTRec with (NoLock)
									Inner Join PlannedTransfer PTDeliv with (NoLock)
										on	PTDeliv.PlnndTrnsfrPlnndStPlnndMvtID	= PTRec.PlnndTrnsfrPlnndStPlnndMvtID
										and	PTDeliv.PlnndTrnsfrID					= XHDeliv.XHdrPlnndTrnsfrID
										and	PTDeliv.PTReceiptDelivery				= 'D'
							Where	PTRec.PlnndTrnsfrID					= XHRec.XHdrPlnndTrnsfrID
							and		PTRec.PTReceiptDelivery				= 'R'
							And		PTRec.PlnndTrnsfrPlnndStSqnceNmbr	= PTDeliv.PlnndTrnsfrPlnndStSqnceNmbr
							)
        Left Outer Join InventoryReconcile IRRec with (NoLock)
                on	IRRec.InvntryRcncleSrceID						= XHRec.XHdrID
				and	IRRec.InvntryRcncleRvrsd						= Case When XHRec.XHdrStat = 'R' then 'Y' Else 'N' end
                and	IRRec.InvntryRcncleSrceTble						= 'X'
                and	IRRec.XHdrTyp									= 'R' -- receipt from inventory
        Left Outer Join InventoryChange ICOrigin with (NoLock)
                on	ICOrigin.SourceType								= 'I'
                and	ICOrigin.SourceID								= IRRec.InvntryRcncleID
        Left Outer Join Product PrdctOrigin with (NoLock)
                on	PrdctOrigin.PrdctID								= ICOrigin.BalancePrdctID
        Left Outer Join Locale LcleOrigin with (NoLock)
                on	LcleOrigin.LcleID								= ICOrigin.BalanceLcleID
		Left Outer Join DealDetail DDRec with (NoLock)
				on	XHRec.DealDetailID								= DDRec.DealDetailID
		Left Outer Join DealHeader DHRec with (NoLock)
			on	DHRec.DlHdrID										= DDRec.DlDtlDlHdrID
		Left Outer Join DealType DTRec with (NoLock)
			on	DTRec.DlTypID										= DHRec.DlHdrTyp
		Inner Join DealDetail with (NoLock)
			on	DealDetail.DlDtlDlHdrID						= InventoryReconcile.DlHdrID
			and	DealDetail.DlDtlID							= InventoryReconcile.DlDtlID
		Inner Join DealDetailTemplate with (NoLock)
			on	DealDetailTemplate.DlDtlTmplteID			= DealDetail.DlDtlTmplteID
		Inner Join DealHeader with (NoLock)
			on	DealHeader.DlHdrID							= DealDetail.DlDtlDlHdrID
		Inner Join DealHeaderTemplate with (NoLock)
			on	DealHeaderTemplate.DlHdrTmplteID			= DealHeader.DlHdrTmplteID
		Inner Join DealType with (NoLock)
			on	DealType.DlTypID							= DealHeader.DlHdrTyp
		Left Outer Join TransactionHeader with (NoLock)
			on	InventoryReconcile.InvntryRcncleSrceID		= TransactionHeader.XHdrID
			and	InventoryReconcile.InvntryRcncleSrceTble	= 'X'
		Left Outer Join MovementDocument with (NoLock)
			on	MovementDocument.MvtDcmntID					= TransactionHeader.XHdrMvtDcmntID
		Left Outer Join MovementHeader with (NoLock)
			on	MovementHeader.MvtHdrID						= TransactionHeader.XHdrMvtDtlMvtHdrID
		Inner Join Product with (NoLock)
			on	Product.PrdctID								= InventoryReconcile.ChildprdctID
		Left Outer Join Locale Origin with (NoLock)
			on	Origin.LcleID								= MovementHeader.MvtHdrOrgnLcleID
		Left Outer Join Locale Destination with (NoLock)
			on	Destination.LcleID							= MovementHeader.MvtHdrDstntnLcleID
		Left Outer Join Locale TitleXfer with (NoLock)
			on	TitleXfer.LcleID							= MovementHeader.MvtHdrLcleID
		Left Outer Join GeneralConfiguration GCMaterialNumber with (NoLock)
			on	GCMaterialNumber.GnrlCnfgTblNme				= 'Product'
			and	GCMaterialNumber.GnrlCnfgQlfr				= 'SAPMaterialCode'
			and	GCMaterialNumber.GnrlCnfgHdrID				= InventoryReconcile.ChildprdctID
		Left Outer Join GeneralConfiguration GCPlantCode with (NoLock)
			on	GCPlantCode.GnrlCnfgTblNme					= 'Locale'
			and	GCPlantCode.GnrlCnfgQlfr					= 'SAPPlantCode'
			and	GCPlantCode.GnrlCnfgHdrID					= MovementHeader.MvtHdrLcleID
		Left Outer Join GeneralConfiguration GCOrigMaterialNumber with (NoLock)
			on	GCOrigMaterialNumber.GnrlCnfgTblNme			= 'Product'
			and	GCOrigMaterialNumber.GnrlCnfgQlfr			= 'SAPMaterialCode'
			and	GCOrigMaterialNumber.GnrlCnfgHdrID			= ICOrigin.BalancePrdctID
		Left Outer Join GeneralConfiguration GCOrigPlantCode with (NoLock)
			on	GCOrigPlantCode.GnrlCnfgTblNme				= 'Locale'
			and	GCOrigPlantCode.GnrlCnfgQlfr				= 'SAPPlantCode'
			and	GCOrigPlantCode.GnrlCnfgHdrID				= ICOrigin.BalanceLcleID
		Inner Join BusinessAssociate IntBA with (NoLock)
			on	IntBA.BAID									= DealHeader.DlHdrIntrnlBAID
		Inner Join BusinessAssociate ExtBA with (NoLock)
			on	ExtBA.BAID									= DealHeader.DlHdrExtrnlBAID
		Left Outer Join AccountingReasonCode with (NoLock)
			on	AccountingReasonCode.Code					= InventoryReconcile.InvntryRcncleRsnCde
Where	InventoryReconcile.InvntryRcncleClsdAccntngPrdID	= @i_AccntngPrdID
And		DealType.Description not like '3rd%'
And		InventoryReconcile.InvntryRcncleSrceTble		<> 'U'
And		DealDetailTemplate.Description in (
											'Consumption Delivery', 'Production Receipt', 'Blending Delivery',
											'Blended Storage Delivery', 'Processing Delivery', 'Storage Delivery',
											'Terminaling Delivery', 'Pipeline Deal Segment', 'Truck Deal Segment', 'Railcar Deal Segment',
											'Location Railcar Segment', 'Location Truck Segment', 'Location Pipeline Segment'
											)
And		(InventoryReconcile.XHdrTyp		= 'D'
		or DealDetailTemplate.Description not in ('Pipeline Deal Segment', 'Truck Deal Segment', 'Railcar Deal Segment',
											'Location Railcar Segment', 'Location Truck Segment', 'Location Pipeline Segment')
		)
And		(		(IntBA.Abbreviation	<> 'MOTIVA-STL' or ExtBA.Abbreviation	<> 'MOTIVA-STL')
			or	DealDetailTemplate.Description not in ('Consumption Delivery', 'Production Receipt')
		)

/*******************************************
Get the Accounting Transactions
********************************************/
Insert	MTVDLInvTransactionsStaging 
		(	
			AccountingMonth,
			CompanyCode,
			MaterialNumber,
			ProductGroup,
			Subgroup,
			Product,
			Location,
			MaterialDesc,
			FTAProductCode,
			PlantNumber,
			RATaxCommodity,
			DealNumber,
			DetailNumber,
			Strategy,
			MaterialDocument,
			PostingDateInDoc,
			ReceiptQuantity,
			ThirdPartyFlag,
			PositionHolderName,
			PositionHolderFEIN,
			PositionHolderNameControl,
			PositionHolderID,
			Value,
			UOM,
			TransactionType,
			MovementDate,
			MovementType,
			VendorNumber,
			OriginLocale,
			OriginCity,
			OriginState,
			OriginTCN,
			DestinationLocale,
			DestinationCity,
			DestinationState,
			DestinationTCN,
			TitleTransferLocale,
			CostType,
			DealType,
			StagingTableLoadDate,
			Status
		)
Select	AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')								as AccountingMonth,
		GCCompanyCode.GnrlCnfgMulti														as CompanyCode,
		GCMaterialNumber.GnrlCnfgMulti													as MaterialNumber,
		RTRIM(Commodity.Name)															as ProductGroup,
		RTRIM(CommoditySubGroup.Name)													as Subgroup,
		Product.PrdctAbbv																as Product,
		Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')					as Location,
		GCMaterialNumber.GnrlCnfgMulti													as MaterialDesc,
		GCFTAProduct.GnrlCnfgMulti														as FTAProductCode,
		GCPlantNumber.GnrlCnfgMulti														as PlantNumber,
		RTRIM(TaxCommodity.Name)														as RATaxCommodity,

		DealHeader.DlHdrIntrnlNbr														as DealNumber,
		AccountDetail.AcctDtlDlDtlID													as DetailNumber,
		StrategyHeader.Name																as Strategy,

		MovementDocument.MvtDcmntExtrnlDcmntNbr											as MaterialDocument,
		MovementDocument.MvtDcmntDte													as PostingDateInDoc,
		AccountDetail.Volume															as ReceiptQuantity,

		Case When DealType.Description like '3rd%' Then 'Y' Else 'N' End				as ThirdPartyFlag,
		Case When DealType.Description like '3rd%'
				then BusinessAssociate.Abbreviation
				else IntBA.Abbreviation end												as PositionHolderName,
		GCPosHolderFEIN.GnrlCnfgMulti													as PositionHolderFEIN,
		GCPosHolderNmeCntrl.GnrlCnfgMulti												as PositionHolderNameControl,
		Case When DealType.Description like '3rd%'
				then BusinessAssociate.BAID
				else IntBA.BAID end														as PositionHolderID,

		AccountDetail.Value	* -1.0														as Value, --Defect 4023: multiply by -1.0
		UnitOfMeasure.UOMAbbv															as UOM,
		TransactionType.TrnsctnTypDesc													as TransactionType,
		AccountDetail.AcctDtlTrnsctnDte													as MovementDate,
		DLMoveType.DynLstBxAbbv															as MovementType,
		case when DealType.Description = 'Purchase Deal'
			then vVendor.VendorNumber else vVendor.SoldTo end							as VendorNumber,
		Origin.LcleAbbrvtn + IsNull(Origin.LcleAbbrvtnExtension, '')					as OriginLocale,
		GCOriginCity.GnrlCnfgMulti														as OriginCity,
		GCOriginState.GnrlCnfgMulti														as OriginState,
		GCOriginTCN.GnrlCnfgMulti														as OriginTCN,
		Destination.LcleAbbrvtn + IsNull(Destination.LcleAbbrvtnExtension, '')			as DestinationLocale,
		GCDestCity.GnrlCnfgMulti														as DestinationCity,
		GCDestState.GnrlCnfgMulti														as DestinationState,
		GCDestTCN.GnrlCnfgMulti															as DestinationTCN,

		TitleXfer.LcleAbbrvtn + IsNull(TitleXfer.LcleAbbrvtnExtension, '')				as TitleTransferLocale,
		EAD.CostType																	as CostType,
		RTRIM(DealType.Description)														as DealType,
		@sdt_InsertDate																	as StagingTableLoadDate,
		'N'																				as Status
-- select EAD.SourceTable, *
From	AccountDetail with (NoLock)
		Inner Join EstimatedAccountDetail EAD with (NoLock)
			on	EAD.AcctDtlID						= AccountDetail.AcctDtlID
			and	not exists (select 1 from EstimatedAccountDetail Sub with (NoLock) where sub.AcctDtlID = EAD.AcctDtlID and sub.EndDate > EAD.EndDate)
		Inner Join StrategyHeader
			on	StrategyHeader.StrtgyID				= AccountDetail.AcctDtlStrtgyID
		Inner Join AccountingPeriod with (NoLock)
			on	AccountingPeriod.AccntngPrdID		= AccountDetail.AcctDtlAccntngPrdID
		Inner Join Product with (NoLock)
			on	Product.PrdctID						= AccountDetail.ChildPrdctID
		Inner Join Locale with (NoLock)
			on	Locale.LcleID						= AccountDetail.AcctDtlLcleID
		Inner Join Commodity with (NoLock)
			on	Commodity.CmmdtyID					= Product.CmmdtyID
		Inner Join UnitOfMeasure with (NoLock)
			on	UnitOfMeasure.UOM					= 3 -- show everything in gallons
		Left Outer Join CommoditySubGroup with (NoLock)
			on	CommoditySubGroup.CmmdtySbGrpID		= Product.CmmdtySbGrpID
		Left Outer Join CommoditySubGroup TaxCommodity with (NoLock)
			on	TaxCommodity.CmmdtySbGrpID			= IsNull(Product.TaxCmmdtySbGrpID, -1)
		Inner Join DealHeader with (NoLock)
			on	DealHeader.DlHdrID					= AccountDetail.AcctDtlDlDtlDlHdrID
		Inner Join MovementHeader with (NoLock)
			on	MovementHeader.MvtHdrID				= AccountDetail.AcctDtlMvtHdrID
		Inner Join BusinessAssociate with (NoLock)
			on	BusinessAssociate.BAID				= DealHeader.DlHdrExtrnlBAID
		Inner Join BusinessAssociate IntBA with (NoLock)
			on	IntBA.BAID							= DealHeader.DlHdrIntrnlBAID
		Inner Join MovementDocument with (NoLock)
			on	MovementDocument.MvtDcmntID			= MovementHeader.MvtHdrMvtDcmntID
		Inner Join TransactionType with (NoLock)
			on	TransactionType.TrnsctnTypID		= AccountDetail.AcctDtlTrnsctnTypID
		Inner Join DealType with (NoLock)
			on	DealType.DlTypID					= DealHeader.DlHdrTyp
		Left Outer Join Locale Origin with (NoLock)
			on	Origin.LcleID						= MovementHeader.MvtHdrOrgnLcleID
		Left Outer Join Locale Destination with (NoLock)
			on	Destination.LcleID					= MovementHeader.MvtHdrDstntnLcleID
		Left Outer Join Locale TitleXfer with (NoLock)
			on	TitleXfer.LcleID					= MovementHeader.MvtHdrLcleID
		Left Outer Join GeneralConfiguration GCCompanyCode with (NoLock)
			on	GCCompanyCode.GnrlCnfgTblNme		= 'BusinessAssociate'
			and	GCCompanyCode.GnrlCnfgQlfr			= 'SAPCompanyCode'
			and	GCCompanyCode.GnrlCnfgHdrID			= DealHeader.DlHdrExtrnlBAID
		Left Outer Join v_MTV_DealDetailSoldToShipTo vVendor with (NoLock)
			on	vVendor.DlDtlDlHdrID				= AccountDetail.AcctDtlDlDtlDlHdrID
			and	vVendor.DlDtlID						= AccountDetail.AcctDtlDlDtlID
			and	getdate()							between vVendor.EffectiveFromDate and vVendor.EffectiveToDate
		Left Outer Join GeneralConfiguration GCMaterialNumber with (NoLock)
			on	GCMaterialNumber.GnrlCnfgTblNme		= 'Product'
			and	GCMaterialNumber.GnrlCnfgQlfr		= 'SAPMaterialCode'
			and	GCMaterialNumber.GnrlCnfgHdrID		= Product.PrdctID
		Left Outer Join GeneralConfiguration GCFTAProduct with (NoLock)
			on	GCFTAProduct.GnrlCnfgTblNme			= 'Product'
			and	GCFTAProduct.GnrlCnfgQlfr			= 'FTAProductCode'
			and	GCFTAProduct.GnrlCnfgHdrID			= Product.PrdctID
		Left Outer Join GeneralConfiguration GCPlantNumber with (NoLock)
			on	GCPlantNumber.GnrlCnfgTblNme		= 'Locale'
			and	GCPlantNumber.GnrlCnfgQlfr			= 'SAPPlantCode'
			and	GCPlantNumber.GnrlCnfgHdrID			= Origin.LcleID
		Left Outer Join GeneralConfiguration GCEquityTerminal with (NoLock)
			on	GCEquityTerminal.GnrlCnfgTblNme		= 'Locale'
			and	GCEquityTerminal.GnrlCnfgQlfr		= 'EquityTerminal'
			and	GCEquityTerminal.GnrlCnfgHdrID		= Origin.LcleID
		Left Outer Join GeneralConfiguration GCOriginCity with (NoLock)
			on	GCOriginCity.GnrlCnfgTblNme			= 'Locale'
			and	GCOriginCity.GnrlCnfgQlfr			= 'CityName'
			and	GCOriginCity.GnrlCnfgHdrID			= Origin.LcleID
		Left Outer Join GeneralConfiguration GCOriginState with (NoLock)
			on	GCOriginState.GnrlCnfgTblNme		= 'Locale'
			and	GCOriginState.GnrlCnfgQlfr			= 'StateAbbreviation'
			and	GCOriginState.GnrlCnfgHdrID			= Origin.LcleID
		Left Outer Join GeneralConfiguration GCOriginTCN with (NoLock)
			on	GCOriginTCN.GnrlCnfgTblNme			= 'Locale'
			and	GCOriginTCN.GnrlCnfgQlfr			= 'TCN'
			and	GCOriginTCN.GnrlCnfgHdrID			= Origin.LcleID
		Left Outer Join GeneralConfiguration GCDestCity with (NoLock)
			on	GCDestCity.GnrlCnfgTblNme			= 'Locale'
			and	GCDestCity.GnrlCnfgQlfr				= 'CityName'
			and	GCDestCity.GnrlCnfgHdrID			= Destination.LcleID
		Left Outer Join GeneralConfiguration GCDestState with (NoLock)
			on	GCDestState.GnrlCnfgTblNme			= 'Locale'
			and	GCDestState.GnrlCnfgQlfr			= 'StateAbbreviation'
			and	GCDestState.GnrlCnfgHdrID			= Destination.LcleID
		Left Outer Join GeneralConfiguration GCDestTCN with (NoLock)
			on	GCDestTCN.GnrlCnfgTblNme			= 'Locale'
			and	GCDestTCN.GnrlCnfgQlfr				= 'TCN'
			and	GCDestTCN.GnrlCnfgHdrID				= Destination.LcleID
		Left Outer Join DynamicListBox DLMoveType with (NoLock)
			on	DLMoveType.DynLstBxQlfr				= 'MovementType'
			and	DLMoveType.DynLstBxStts				= 'A'
			and	DLMoveType.DynLstBxTyp				= MovementHeader.MvtHdrTyp
		Left Outer Join GeneralConfiguration GCPosHolderNmeCntrl with (NoLock)
			on	GCPosHolderNmeCntrl.GnrlCnfgTblNme	= 'BusinessAssociate'
			and	GCPosHolderNmeCntrl.GnrlCnfgQlfr	= 'SCAC'
			and	GCPosHolderNmeCntrl.GnrlCnfgHdrID	= Case When DealType.Description like '3rd%'
														then BusinessAssociate.BAID
														else IntBA.BAID end
		Left Outer Join GeneralConfiguration GCPosHolderFEIN with (NoLock)
			on	GCPosHolderFEIN.GnrlCnfgTblNme		= 'BusinessAssociate'
			and	GCPosHolderFEIN.GnrlCnfgQlfr		= 'FederalTaxID'
			and	GCPosHolderFEIN.GnrlCnfgHdrID		= Case When DealType.Description like '3rd%'
														then BusinessAssociate.BAID
														else IntBA.BAID end
Where	AccountDetail.AcctDtlAccntngPrdID = @i_AccntngPrdID
and		exists	(
				Select	1
				From	TransactionTypeGroup with (NoLock)
						Inner Join TransactionGroup with (NoLock)
							on	TransactionTypeGroup.XTpeGrpXGrpID		= TransactionGroup.XGrpID
				Where	TransactionTypeGroup.XTpeGrpTrnsctnTypID		= TransactionType.TrnsctnTypID
				and		TransactionGroup.XGrpName						= 'PurchaseTransactions'
				and		TransactionGroup.XGrpQlfr						= 'DataLake'
				)


/*******************************************
Get the Inventory Prices
********************************************/
Insert	MTVDLInvPricesStaging
		(
		AccountingMonth,
		Product,
		MaterialCode,
		Location,
		PlantCode,
		ProductGroup,
		PriceService,
		Subgroup,
		Currency,
		QuoteFromDate,
		QuoteToDate,
		MinEndOfDay,
		MaxEndOfDay,
		DeliveryPeriod,
		Price,
		UOM,
		PricePerGallon,
		StagingTableLoadDate,
		Status
		)
Select	AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')												as AccountingMonth,
		Product.PrdctAbbv																				as Product,
		GCMaterialCode.GnrlCnfgMulti																	as MaterialCode,
		Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')									as Location,
		GCPlantCode.GnrlCnfgMulti																		as PlantCode,
		RTRIM(Commodity.Name)																			as ProductGroup,
		RawPriceHeader.RPHdrAbbv																		as PriceService,
		RTRIM(CommoditySubGroup.Name)																	as Subgroup,
		Currency.CrrncySmbl																				as Currency,
		RiskCurveValue.StartDate																		as QuoteFromDate,
		RiskCurveValue.EndDate																			as QuoteToDate,
		MinSS.EndOfDay																					as MinEndOfDay,
		MaxSS.EndOfDay																					as MaxEndOfDay,
		DatePart(Month, VETradePeriod.StartDate) * 10000 + DatePart(Year, VETradePeriod.StartDate)		as DeliveryPeriod,
		RiskCurveValue.BaseValue																		as Price,
		UnitOfMeasure.UOMAbbv																			as UOM,
		RiskCurveValue.BaseValue / ( v_UOMConversion.ConversionFactor / 
									Case	v_UOMConversion. FromUOMTpe + v_UOMConversion. ToUOMTpe
											When	'WV'
											Then	Case When convert(float,RiskCurveValue.SpecificGravity) <> 0.0 Then convert(float,RiskCurveValue.SpecificGravity) Else 1.0 End
											When	'VW'
											Then	1.0 / Case When convert(float,RiskCurveValue.SpecificGravity) <> 0.0 Then convert(float,RiskCurveValue.SpecificGravity) Else 1.0 End
											When	'EV'
											Then	Case When convert(float,RiskCurveValue.Energy) <> 0.0 Then convert(float,RiskCurveValue.Energy) Else 1.0 End
											When	'VE'
											Then	1.0 / Case When convert(float,RiskCurveValue.Energy) <> 0.0 Then convert(float,RiskCurveValue.Energy) Else 1.0 End
											When	'WE'
											Then	convert(float,RiskCurveValue.SpecificGravity) / Case When convert(float,RiskCurveValue.Energy) <> 0.0 Then convert(float,RiskCurveValue.Energy) Else 1.0 End
											When	'EW'
											Then	convert(float,RiskCurveValue.Energy) / Case When convert(float,RiskCurveValue.SpecificGravity) <> 0.0 Then convert(float,RiskCurveValue.SpecificGravity) Else 1.0 End
											Else	1.0
									End)																as PricePerGallon,

		@sdt_InsertDate																					as StagingTableLoadDate,
		'N'																								as Status
-- select * 
From	RiskCurve with (NoLock)
		Inner Join RiskCurveValue with (NoLock)
			on	RiskCurveValue.RiskCurveID				= RiskCurve.RiskCurveID
		Inner Join RawPriceHeader with (NoLock)
			on	RawPriceHeader.RPHdrID					= RiskCurve.RPHdrID
		Inner Join PeriodTranslation with (NoLock)
			on	PeriodTranslation.VETradePeriodID		= RiskCurve.VETradePeriodID
		Inner Join AccountingPeriod with (NoLock)
			on	AccountingPeriod.AccntngPrdID			= PeriodTranslation.AccntngPrdID
		Inner Join VETradePeriod with (NoLock)
			on	VETradePeriod.VETradePeriodID			= RiskCurve.VETradePeriodID
		Inner Join Product with (NoLock)
			on	Product.PrdctID							= RiskCurve.ChmclID
		Inner Join Locale with (NoLock)
			on	Locale.LcleID							= RiskCurve.LcleID

		Left Outer Join GeneralConfiguration GCMaterialCode with (NoLock)
			on	GCMaterialCode.GnrlCnfgTblNme		= 'Product'
			and	GCMaterialCode.GnrlCnfgQlfr			= 'SAPMaterialCode'
			and	GCMaterialCode.GnrlCnfgHdrID		= Product.PrdctID
		Left Outer Join GeneralConfiguration GCPlantCode with (NoLock)
			on	GCPlantCode.GnrlCnfgTblNme			= 'Locale'
			and	GCPlantCode.GnrlCnfgQlfr			= 'SAPPlantCode'
			and	GCPlantCode.GnrlCnfgHdrID			= Locale.LcleID

		Inner Join Commodity with (NoLock)
			on	Commodity.CmmdtyID						= Product.CmmdtyID
		Left Outer Join CommoditySubGroup with (NoLock)
			on	CommoditySubGroup.CmmdtySbGrpID			= Product.CmmdtySbGrpID
		Inner Join Currency with (NoLock)
			on	Currency.CrrncyID						= RiskCurve.CrrncyID
		Inner Join UnitOfMeasure with (NoLock)
			on	UnitOfMeasure.UOM						= RiskCurve.UOMID
		Left Outer Join v_UOMConversion	(Nolock)
			On	v_UOMConversion. FromUOM				= RiskCurve.UOMID
			And	v_UOMConversion. ToUOM					= 3
		Inner Join Snapshot MinSS (NoLock)
			on	MinSS.InstanceDateTime					= RiskCurveValue.StartDate
		Inner Join (
					Select	IsNull(Next.EndOfDay, Latest.EndOfDay) as EndOfDay,
							IsNull(DateAdd(minute, -1, Next.InstanceDateTime), '6/6/2079 23:59') EndingDateTime
					From	Snapshot (NoLock)
							Inner Join Snapshot Latest (NoLock)
								on	not exists (
												Select	1
												From	Snapshot sub (NoLock)
												Where	Sub.IsValid = 'Y'
												And		Sub.P_EODSnpshtID	> Latest.P_EODSnpshtID
												)
							Left Outer Join Snapshot Next (NoLock)
								on	Next.P_EODSnpshtID	> Snapshot.P_EODSnpshtID
								and	Next.IsValid		= 'Y'
								and not exists (
												Select	1
												From	Snapshot Sub (NoLock)
												Where	Sub.IsValid = 'Y'
												And		Sub.P_EODSnpshtID		> Snapshot.P_EODSnpshtID
												And		Sub.P_EODSnpshtID		< Next.P_EODSnpshtID
												)
					Where	Snapshot.IsValid	= 'Y'
					) MaxSS
			on	MaxSS.EndingDateTime					= RiskCurveValue.EndDate
Where	RiskCurve.VETradePeriodID		= @i_VETradePeriodID
And		RawPriceHeader.RPHdrAbbv		in ('Market', 'Transfer Price')
And		(
		RiskCurve.IsMarketCurve			= 1
		or	exists	(
					Select	1
					From	GeneralConfiguration with (NoLock)
					Where	GnrlCnfgTblNme	= 'RawPriceLocale'
					And		GnrlCnfgQlfr	= 'TransferPriceType'
					And		GnrlCnfgMulti	in ('YT02', 'YT04', 'YT06')
					And		GnrlCnfgHdrID	= RiskCurve.RwPrceLcleID
					)
		)



/*******************************************
Now get the Inventory Balances
********************************************/
Insert #InvBalance
			(
			AccountingMonth,
			DealNumber,
			DlHdrID,
			DetailNumber,
			BalanceDlDtlID,
			-- Location Stuff
			StorageLocation,
			LocationCity,
			LocationState,
			LocationAddress,
			LocationTCN,
			LocationZip,
			LocationType,
			LocationID,
			EquityTerminalIndicator,
			-- Base Product
			ProductName,
			ProductGroup,
			Subgroup,
			RATaxCommodity,

			FTAProductCode,
			GradeOfProduct,
			MSAPPlantNumber,
			MSAPMaterialNumber,

			-- Real Product
			BlendProduct,
			RegradeProductName,
			RegradeProductFTACode,
			RegradeProductTaxCommodity,
			
			TerminalOperator,
			PositionHolderName,
			PositionHolderFEIN,
			PositionHolderNameControl,
			PositionHolderID,

			ThirdPartyFlag,
			DealType,
			UOM,
			StagingTableLoadDate,
			Status,

			ISDID,
			TradingBook,
			ProfitCenter
			)
Select		DISTINCT
			@vc_AcctMonth																	as AccountingMonth,
			-- Deal
			DealHeader.DlHdrIntrnlNbr														as DealNumber,
			DDRR.DlDtlDlHdrID																as DlHdrID,
			DDRR.BaseDlDtlID																as DetailNumber,
			DDRR.BaseDlDtlID																as BalanceDlDtlID,
			-- Location
			Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')					as StorageLocation,
			GCLocationCity.GnrlCnfgMulti													as LocationCity,
			GCLocationState.GnrlCnfgMulti													as LocationState,
			GCLocationAddy.GnrlCnfgMulti													as LocationAddress,
			GCTCNNumber.GnrlCnfgMulti														as LocationTCN,
			GCLocationZip.GnrlCnfgMulti														as LocationZip,
			LocaleType.LcleTpeDscrptn														as LocationType,
			Locale.LcleID																	as LocationID,
			Case when GCEquityTerminal.GnrlCnfgMulti = 'Y' Then 'Y' Else 'N' End			as EquityTerminalIndicator,
			-- Base Product
			Chemical.PrdctAbbv																as ProductName,
			RTRIM(Commodity.Name)															as ProductGroup,
			RTRIM(Subgroup.Name)															as Subgroup,
			RTRIM(TaxCommodity.Name)														as RATaxCommodity,
			GCFTABase.GnrlCnfgMulti															as FTAProductCode,
			GCBasePrdctGrade.GnrlCnfgMulti													as GradeOfProduct,
			GCPlantNumber.GnrlCnfgMulti														as MSAPPlantNumber,
			GCMaterialNumber.GnrlCnfgMulti													as MSAPMaterialNumber,
			-- Real Product
			Case When BaseChmclID <> ChmclID Then 'Y' Else 'N' End								as BlendProduct,
			Case When BaseChmclID <> ChmclID Then Chemical.PrdctNme Else Null End				as RegradeProductName,
			Case When BaseChmclID <> ChmclID Then GCFTAChemical.GnrlCnfgMulti Else Null End		as RegradeProductFTACode,
			Case When BaseChmclID <> ChmclID Then RTRIM(ChemTaxCommodity.Name) Else Null End	as RegradeProductTaxCommodity,
			-- BA Stuff
			TermOperator.Abbreviation														as TerminalOperator,
			Case When DealType.Description like '3rd%'
				then BusinessAssociate.Abbreviation
				else IntBA.Abbreviation end													as PositionHolderName,
			GCPosHolderFEIN.GnrlCnfgMulti													as PositionHolderFEIN,
			GCPosHolderNmeCntrl.GnrlCnfgMulti												as PositionHolderNameControl,
			Case When DealType.Description like '3rd%'
				then BusinessAssociate.BAID
				else IntBA.BAID end															as PositionHolderID,
			Case When DealType.Description like '3rd%' Then 'Y' Else 'N' End				as ThirdPartyFlag,
			RTRIM(DealType.Description)														as DealType,

			'GAL'																			as UOM,
			GetDate()																		as StagingTableLoadDate,
			'N'																				as Status,

			ISD.InvntrySbldgrDtlID															as ISDID,
			StrategyHeader.Name																as TradingBook,
			GCProfitCtr.GnrlCnfgMulti														as ProfitCenter
From	DealDetailRegradeRecipe DDRR with (NoLock)
		Inner Join DealHeader with (NoLock)
			on	DealHeader.DlHdrID					= DDRR.DlDtlDlHdrID
		Inner Join DealDetail with (NoLock)
			on	DealDetail.DlDtlDlHdrID				= DDRR.DlDtlDlHdrID
			and	DealDetail.DlDtlID					= DDRR.BaseDlDtlID
		Inner Join DealType with (NoLock)
			on	DealType.DlTypID					= DealHeader.DlHdrTyp

		-- Location Stuff
		Inner Join Locale with (NoLock)
			on	Locale.LcleID						= DealDetail.DlDtlLcleID
		Inner Join LocaleType with (NoLock)
			on	LocaleType.LcleTpeID				= Locale.LcleTpeID
		Left Outer Join GeneralConfiguration GCLocationCity with (NoLock)
			on	GCLocationCity.GnrlCnfgTblNme		= 'Locale'
			and	GCLocationCity.GnrlCnfgQlfr			= 'CityName'
			and	GCLocationCity.GnrlCnfgHdrID		= Locale.LcleID
		Left Outer Join GeneralConfiguration GCLocationState with (NoLock)
			on	GCLocationState.GnrlCnfgTblNme		= 'Locale'
			and	GCLocationState.GnrlCnfgQlfr		= 'StateAbbreviation'
			and	GCLocationState.GnrlCnfgHdrID		= Locale.LcleID
		Left Outer Join GeneralConfiguration GCLocationAddy with (NoLock)
			on	GCLocationAddy.GnrlCnfgTblNme		= 'Locale'
			and	GCLocationAddy.GnrlCnfgQlfr			= 'AddrLine1'
			and	GCLocationAddy.GnrlCnfgHdrID		= Locale.LcleID
		Left Outer Join GeneralConfiguration GCLocationZip with (NoLock)
			on	GCLocationZip.GnrlCnfgTblNme		= 'Locale'
			and	GCLocationZip.GnrlCnfgQlfr			= 'PostalCode'
			and	GCLocationZip.GnrlCnfgHdrID			= Locale.LcleID
		Left Outer Join GeneralConfiguration GCTCNNumber with (NoLock)
			on	GCTCNNumber.GnrlCnfgTblNme			= 'Locale'
			and	GCTCNNumber.GnrlCnfgQlfr			= 'TCN'
			and	GCTCNNumber.GnrlCnfgHdrID			= Locale.LcleID
		Left Outer Join GeneralConfiguration GCLocationOperator with (NoLock)
			on	GCLocationOperator.GnrlCnfgTblNme	= 'Locale'
			and	GCLocationOperator.GnrlCnfgQlfr		= 'TerminalOperator'
			and	GCLocationOperator.GnrlCnfgHdrID	= Locale.LcleID

		-- Chemical
		Left Outer Join Product Chemical with (NoLock)
			on	Chemical.PrdctID					= DDRR.ChmclID
		Left Outer Join GeneralConfiguration GCFTAChemical with (NoLock)
			on	GCFTAChemical.GnrlCnfgTblNme		= 'Product'
			and	GCFTAChemical.GnrlCnfgQlfr			= 'FTAProductCode'
			and	GCFTAChemical.GnrlCnfgHdrID			= DDRR.ChmclID
		Left Outer Join CommoditySubGroup ChemTaxCommodity with (NoLock)
			on	ChemTaxCommodity.CmmdtySbGrpID		= IsNull(Chemical.TaxCmmdtySbGrpID, -1)
		Left Outer Join GeneralConfiguration GCMaterialNumber with (NoLock)
			on	GCMaterialNumber.GnrlCnfgTblNme		= 'Product'
			and	GCMaterialNumber.GnrlCnfgQlfr		= 'SAPMaterialCode'
			and	GCMaterialNumber.GnrlCnfgHdrID		= Chemical.PrdctID

		-- Base Chemical
		Inner Join Product BaseChemical with (NoLock)
			on	BaseChemical.PrdctID				= DDRR.BaseChmclID
		Inner Join Commodity with (NoLock)
			on	Commodity.CmmdtyID					= BaseChemical.CmmdtyID
		Left Outer Join CommoditySubGroup Subgroup with (NoLock)
			on	Subgroup.CmmdtySbGrpID				= IsNull(BaseChemical.CmmdtySbGrpID, -1)
		Left Outer Join CommoditySubGroup TaxCommodity with (NoLock)
			on	TaxCommodity.CmmdtySbGrpID			= IsNull(BaseChemical.TaxCmmdtySbGrpID, -1)
		Left Outer Join GeneralConfiguration GCFTABase with (NoLock)
			on	GCFTABase.GnrlCnfgTblNme			= 'Product'
			and	GCFTABase.GnrlCnfgQlfr				= 'FTAProductCode'
			and	GCFTABase.GnrlCnfgHdrID				= DDRR.BaseChmclID
		Left Outer Join GeneralConfiguration GCBasePrdctGrade with (NoLock)
			on	GCBasePrdctGrade.GnrlCnfgTblNme		= 'Product'
			and	GCBasePrdctGrade.GnrlCnfgQlfr		= 'ProductGrade'
			and	GCBasePrdctGrade.GnrlCnfgHdrID		= DDRR.BaseChmclID


		-- BA stuff
		Left Outer Join BusinessAssociate TermOperator with (NoLock)
			on	convert(varchar, TermOperator.BAID)	= GCLocationOperator.GnrlCnfgMulti
		Inner Join BusinessAssociate with (NoLock)
			on	BusinessAssociate.BAID				= DealHeader.DlHdrExtrnlBAID
		Inner Join BusinessAssociate IntBA with (NoLock)
			on	IntBA.BAID							= DealHeader.DlHdrIntrnlBAID
		Left Outer Join GeneralConfiguration GCEquityTerminal with (NoLock)
			on	GCEquityTerminal.GnrlCnfgTblNme		= 'Locale'
			and	GCEquityTerminal.GnrlCnfgQlfr		= 'EquityTerminal'
			and	GCEquityTerminal.GnrlCnfgHdrID		= Locale.LcleID
		Left Outer Join GeneralConfiguration GCPlantNumber with (NoLock)
			on	GCPlantNumber.GnrlCnfgTblNme		= 'Locale'
			and	GCPlantNumber.GnrlCnfgQlfr			= 'SAPPlantCode'
			and	GCPlantNumber.GnrlCnfgHdrID			= Locale.LcleID
		Left Outer Join GeneralConfiguration GCPosHolderFEIN with (NoLock)
			on	GCPosHolderFEIN.GnrlCnfgTblNme		= 'BusinessAssociate'
			and	GCPosHolderFEIN.GnrlCnfgQlfr		= 'FederalTaxID'
			and	GCPosHolderFEIN.GnrlCnfgHdrID		= Case When DealType.Description like '3rd%' then BusinessAssociate.BAID else IntBA.BAID end
		Left Outer Join GeneralConfiguration GCPosHolderNmeCntrl with (NoLock)
			on	GCPosHolderNmeCntrl.GnrlCnfgTblNme	= 'BusinessAssociate'
			and	GCPosHolderNmeCntrl.GnrlCnfgQlfr	= 'SCAC'
			and	GCPosHolderNmeCntrl.GnrlCnfgHdrID	= Case When DealType.Description like '3rd%' then BusinessAssociate.BAID else IntBA.BAID end

		-- ISD stuff
		Left Outer Join InventorySubledgerDetail ISD with (NoLock)
			on	ISD.DlDtlChmclDlDtlDlHdrID			= DealDetail.DlDtlDlHdrID
			and	ISD.DlDtlChmclDlDtlID				= DealDetail.DlDtlID
			and ISD.AccntngPrdID					= @i_AccntngPrdID +1
		Left Outer Join StrategyHeader with (NoLock)
			on	StrategyHeader.StrtgyID				= ISD.StrtgyID
		Left Outer Join GeneralConfiguration GCProfitCtr with (NoLock)
			on	GCProfitCtr.GnrlCnfgTblNme			= 'StrategyHeader'
			and	GCProfitCtr.GnrlCnfgQlfr			= 'ProfitCenter'
			and	GCProfitCtr.GnrlCnfgHdrID			= StrategyHeader.StrtgyID
Where	Exists	(
				Select	1
				From	AccountingPeriod (NoLock)
						Inner Join Calendar (NoLock)
							on	Calendar.Name			= 'US Bank Calendar'
						Inner Join CalendarDate (NoLock)
							on	Calendar.CalendarID		= CalendarDate.CalendarID
							and	CalendarDate.Date		between DDRR.FromDate and DDRR.ToDate
				Where	AccntngPrdID = @i_AccntngPrdID
				)



Update	#InvBalance
Set		BegInvVolume				= IsNull(ISDBegin.BeginningVolume, 0.0),
		EndingInvVolume				= ISD.BeginningVolume,
		PerUnitValue				= Case	when ISD.BeginningVolume <> 0
											then ISD.BeginningValue / ISD.BeginningVolume
											else 0.0 end,
		EndingInvValue				= ISD.BeginningValue,
		EndingPhysicalBalance		= EndInv.EndngInvntryExtrnlBlnce
-- select *
From	#InvBalance
		Inner Join InventorySubledgerDetail ISD with (NoLock)
			on	ISD.InvntrySbldgrDtlID				= #InvBalance.ISDID
		Left Outer Join InventorySubledgerDetail ISDBegin with (NoLock)
			on	ISD.DlDtlChmclDlDtlDlHdrID			= ISDBegin.DlDtlChmclDlDtlDlHdrID
			and	ISD.DlDtlChmclDlDtlID				= ISDBegin.DlDtlChmclDlDtlID
			and	ISD.DlDtlChmclChmclPrntPrdctID		= ISDBegin.DlDtlChmclChmclPrntPrdctID
			and	ISD.DlDtlChmclChmclChldPrdctID		= ISDBegin.DlDtlChmclChmclChldPrdctID
			and	ISD.StrtgyID						= ISDBegin.StrtgyID
			and	ISD.AccntngPrdID - 1				= ISDBegin.AccntngPrdID
		Left Outer Join ReconcileGroupDetail RGDetail with (NoLock)
			on	RGDetail.RcncleGrpDtlDlHdrID		= ISD.DlDtlChmclDlDtlDlHdrID
			and	RGDetail.DlDtlID					= ISD.DlDtlChmclDlDtlID
			and	RGDetail.PrdctID					= ISD.DlDtlChmclChmclChldPrdctID
		Left Outer Join EndingInventory EndInv with (NoLock)
			on	EndInv.EndngInvntryRcncleGrpID		= RGDetail.RcncleGrpDtlRcncleGrpID
			and	EndInv.AccntngPrdID					= ISD.AccntngPrdID



Update	#InvBalance
Set		TotalReceipts				= ICSub.Build,
		TotalDisbursement			= ICSub.Draw,
		GainLoss					= ICSub.GainLoss,
		TotalBlend					= ICSub.BlendQty,
		BookAdjReason				= ICSub.Description
From	#InvBalance
		Inner Join (
					Select	DealHeader.DlHdrIntrnlNbr										as DealNumber,
							InventoryChange.BalanceDldtlID									as BalanceDlDtlID,
							ICChemical.PrdctNme												as Chem,
							AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')				as AccountingMonth,
							Sum(Case	When TransactionHeader.XHdrTyp = 'R'
										Then VolumeQty * -1.0 Else 0 End)					as Draw,
							Sum(Case	When TransactionHeader.XHdrTyp = 'D'
										Then VolumeQty Else 0 End)							as Build,
							Sum(Case When IsAdjustment = 'Y'
									Then VolumeQty Else 0 End)								as GainLoss,
							Sum(Case When BalanceChemid <> ChemID
									Then VolumeQty Else 0 End)								as BlendQty,
							AccountingReasonCode.Description								as Description

					From	InventoryChange with (NoLock)
							Inner Join AccountingPeriod with (NoLock)
								on	AccountingPeriod.AccntngPrdID					= InventoryChange.BookAccntngPrdID
							Inner Join DealHeader with (NoLock)
								on	DealHeader.DlHdrID								= InventoryChange.DlHdrID
							Inner Join Product ICChemical with (NoLock)
								on	ICChemical.PrdctID								= InventoryChange.ChemID
							Inner Join InventoryReconcile with (NoLock)
								on	InventoryReconcile.InvntryRcncleID				= InventoryChange.SourceID
							Inner Join TransactionHeader with (NoLock)
								on	TransactionHeader.XHdrID						= InventoryReconcile.InvntryRcncleSrceID
								and	InventoryReconcile.InvntryRcncleSrceTble		= 'X'
							Left Outer Join AccountingReasonCode with (NoLock)
								on	AccountingReasonCode.Code						= InventoryReconcile.InvntryRcncleRsnCde
					Where	InventoryChange.SourceType			= 'I'
					And		InventoryChange.QuantityType		= 'M'
					And		IsNull(AccountingReasonCode.Description, '')	<> 'Beg Balance'

					Group By DealHeader.DlHdrIntrnlNbr,
							InventoryChange.BalanceDldtlID,
							ICChemical.PrdctNme,
							AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2'),
							AccountingReasonCode.Description			) ICSub
			on	ICSub.DealNumber			= #InvBalance.DealNumber
			and	ICSub.BalanceDlDtlID		= #InvBalance.BalanceDlDtlID
			and	ICSub.Chem					= IsNull(#InvBalance.RegradeProductName, #InvBalance.ProductName)
			and	ICSub.AccountingMonth		= #InvBalance.AccountingMonth


/*******************************************
Now, insert them into the real staging tables
********************************************/
Insert MTVDLInvBalancesStaging
		(
		AccountingMonth,
		DealNumber,
		DetailNumber,
		BlendProduct,
		ThirdPartyFlag,
		EquityTerminalIndicator,
		DealType,
		StorageLocation,
		ProductName,
		RegradeProductName,
		ProductGroup,
		Subgroup,
		MSAPPlantNumber,
		MSAPMaterialNumber,
		TradingBook,
		ProfitCenter,
		BegInvVolume,
		EndingInvVolume,
		UOM,
		PerUnitValue,
		EndingInvValue,
		LocationCity,
		LocationState,
		LocationAddress,
		LocationTCN,
		LocationZip,
		LocationType,
		TerminalOperator,
		PositionHolderName,
		PositionHolderFEIN,
		PositionHolderNameControl,
		PositionHolderID,
		LocationID,
		FTAProductCode,
		RATaxCommodity,
		RegradeProductFTACode,
		RegradeProductTaxCommodity,
		TotalReceipts,
		TotalDisbursement,
		TotalBlend,
		GainLoss,
		BookAdjReason,
		EndingPhysicalBalance,
		GradeOfProduct,
		StagingTableLoadDate,
		Status
		)
Select	AccountingMonth,
		DealNumber,
		DetailNumber,
		BlendProduct,
		ThirdPartyFlag,
		EquityTerminalIndicator,
		DealType,
		StorageLocation,
		ProductName,
		RegradeProductName,
		ProductGroup,
		Subgroup,
		MSAPPlantNumber,
		MSAPMaterialNumber,
		TradingBook,
		ProfitCenter,
		BegInvVolume,
		EndingInvVolume,
		UOM,
		PerUnitValue,
		EndingInvValue,
		LocationCity,
		LocationState,
		LocationAddress,
		LocationTCN,
		LocationZip,
		LocationType,
		TerminalOperator,
		PositionHolderName,
		PositionHolderFEIN,
		PositionHolderNameControl,
		PositionHolderID,
		LocationID,
		FTAProductCode,
		RATaxCommodity,
		RegradeProductFTACode,
		RegradeProductTaxCommodity,
		TotalReceipts,
		TotalDisbursement,
		TotalBlend,
		GainLoss,
		BookAdjReason,
		EndingPhysicalBalance,
		GradeOfProduct,
		StagingTableLoadDate,
		Status
From	#InvBalance

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_DLInvStage]') IS NOT NULL
    BEGIN
		EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_DLInvStage.sql'
		PRINT '<<< ALTERED StoredProcedure MTV_DLInvStage >>>'
	END
ELSE
	BEGIN
		PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_DLInvStage >>>'
	END
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_RegressDev_20171206_082223\StoredProcedures\MTVDLInvStage.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_RegressDev_20171206_082223\StoredProcedures\sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_custom_exchdiff_statement_retrieve_details_with_regrades WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_custom_exchdiff_statement_retrieve_details_with_regrades >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

--drop procedure [dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]
ALTER Procedure [dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades] @i_SalesInvoiceHeaderID Int
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_exchdiff_statement_retrieve_details_with_regrades 140966          Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Tracy Baird
-- History:	5/3/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	09/24/2002	HMD		29096	Bad join in 2nd retrieval (prior month movement transactions)
--					29102	to inventory reconcile was causing reversals to show up twice
--						and causing price changes to show up twice.  Added reversal flag to join.
--	01/21/2003	JJF			Changed join in section that gets all chemicals that haven't been retrieved yet.
--	04/16/2003	JJF		32852	Changed join in 2nd retrieval -- not picking up financial reversals correctly
--	05/06/2003	JJF		33075	Previous change caused multiple rows to be returned. Altered select so 
--						the TransactionDetailLog.XDtlLgRvrsd flag is not retrieved.
--	05/08/2003	JJF			Rewrote the sp to include the 2 temp tables.  Too many problems in retrieving
--						all necessary data and performance
--	07/18/2003	RPN		34715	Made performance modifications to the stored procedure, enhancing the work done
--                                              around the temp tables created on 5/8/2003, and remove the UNION ALL statements.
--                                              The result set is now stored in temporary table prior to returning to the client.
--	09/12/2003	HMD		31701	Added perunitdecimalplaces and quantitydecimalplaces
-- 	02/17/2004	CM		33060	Added Having clause to exclude zero vol, value, activity records if reg entry = 'Y'
-- 	04/2/2005	CM 		33060	Modified Having clause to exclude anything that would round to an int of 0	
--	11/21/2006	Alex Steen		Fixed index hints for SQLServer2005
--  08/14/2008	DJB		77300	Change index name in the hint
--	09/15/2009	JMK		SF16340	Had to change how we get regrades since we build them dynamically in S9 and up.

-- 2017-01-02	RMM		8359	Modified Type-3 Description to display 0 correctly.
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @vc_ExcludeZeroBalanceNoXctn varchar(1)

----------------------------------------------------------------------------------------------------------------------
-- Create a temporary table for holding the Sum Total for each Exchange Diff Groups
----------------------------------------------------------------------------------------------------------------------
Create Table #ExchangeDiffSum
(
	UnitValue	Float,
	XHdrID		Int,
--	Reversed	Char(1),
	XGroupID	Int,
	SourceTable	Char(2)
)

----------------------------------------------------------------------------------------------------------------------
-- Create a temporary table for holding Prior Period Adjustments
----------------------------------------------------------------------------------------------------------------------
--Create Table #PriorPeriodAdjustment
--( 
--	XHdrID		Int,
--	AcctDtlAccntngPrdID int,
--	ChildPrdctID	int,
--	AcctDtlDlDtlDlHdrID int,
--	AcctDtlDlDtlID int,
--	SlsInvceDtlDlvryTrmID int,
--	AmountDue	FLoat
--)

Create Table #Type0Results
(
	SlsInvceSttmntSlsInvceHdrID	int	Null, 
	ExtrnlBAID				int Null,
	DlHdrExtrnlNbr			varchar(20)	Null, 
	DlHdrIntrnlNbr			varchar(20)	Null, 
	AccntngPrdID			int Null,
	SlsInvceHdrUOM			varchar(20) Null,
	IESRowType				smallint Null
)

Create Table #Type1Results
(
	SlsInvceSttmntSlsInvceHdrID	int	Null, 
	ExtrnlBAID				varchar(100) Null,
	DlHdrExtrnlNbr			varchar(20)	Null, 
	DlHdrIntrnlNbr			varchar(20)	Null,
	BasePrdctAbbv			varchar(20) Null,
	ThisMonthsBalance		float Null,
	LastMonthsBalance		float Null,
	IESRowType				smallint Null
)

Create Table #Type2Results
(
	SlsInvceSttmntSlsInvceHdrID	int	Null, 
	SlsInvceSttmntXHdrID		int	Null, 
	SlsInvceSttmntRvrsd		char(1)	Null, 
	DlHdrExtrnlNbr			varchar(20)	Null, 
	DlHdrIntrnlNbr			varchar(20)	Null, 
	ParentPrdctAbbv			varchar(20)	Null, 
	ChildPrdctID			int	Null, 
	ChildPrdcAbbv			varchar(20)	Null, 
	OriginLcleAbbrvtn		varchar(20)	Null, 
	DestinationLcleAbbrvtn		varchar(20)	Null, 
	FOBLcleAbbrvtn			varchar(20)	Null, 
	Quantity			float	Null, 
	MvtDcmntExtrnlDcmntNbr		varchar(80)	Null, 
	MvtHdrDte			smalldatetime	Null, 
	XHdrTyp				char(1)	Null, 
	InvntryRcncleClsdAccntngPrdID	int	Null, 
	ChildPrdctOrder			smallint	Null, 
	Description			varchar(150)	Null, 
	TransactionDesc			varchar(50)	Null, 
	XchDiffGrpID1			int	Null, 
	XchDiffGrpName1			varchar(50)	Null, 
	XchUnitValue1			float	Null, 
	XchDiffGrpID2			int	Null, 
	XchDiffGrpName2			varchar(50)	Null, 
	XchUnitValue2			float	Null, 
	XchDiffGrpID3			int	Null, 
	XchDiffGrpName3			varchar(50)	Null, 
	XchUnitValue3			float	Null, 
	XchDiffGrpID4			int	Null, 
	XchDiffGrpName4			varchar(50)	Null, 
	XchUnitValue4			float	Null, 
	XchDiffGrpID5			int	Null, 
	XchDiffGrpName5			varchar(50)	Null, 
	XchUnitValue5			float	Null, 
	LastMonthsBalance		float	Null, 
	ThisMonthsbalance		float	Null, 
	Balance				float	Null, 
	DynLstBxDesc			varchar(50)	Null, 
	TotalValue			Float	Null,
	ContractContact			varchar(50)	Null, 
	UOMAbbv				varchar(20)	Null, 
	MovementTypeDesc		varchar(50)	Null,
	PerUnitDecimalPlaces		int		Null,
	QuantityDecimalPlaces		int		Null,
	AccountPeriod				int		NULL,
	ExternalBAID				int		NULL,
	Action						nvarchar(10) NULL,
	InterfaceMessage			varchar(2000) NULL,
	InterfaceFile				varchar(255) NULL,
	InterfaceID					varchar(20) NULL,
	ImportDate					smalldatetime NULL,
	ModifiedDate				smalldatetime NULL,
	UserId						int NULL,
	ProcessedDate				smalldatetime NULL,
	XHdrStat					char(1)	NULL,
	IESRowType					smallint NULL
)

Create Table #Type3Results
(
	SlsInvceSttmntSlsInvceHdrID	int	Null, 
	SlsInvceSttmntXHdrID		int	Null, 
	SlsInvceSttmntRvrsd		char(1)	Null, 
	DlHdrExtrnlNbr			varchar(20)	Null, 
	DlHdrIntrnlNbr			varchar(20)	Null, 
	ParentPrdctAbbv			varchar(20)	Null, 
	ChildPrdctID			int	Null, 
	ChildPrdcAbbv			varchar(20)	Null, 
	OriginLcleAbbrvtn		varchar(20)	Null, 
	DestinationLcleAbbrvtn		varchar(20)	Null, 
	FOBLcleAbbrvtn			varchar(20)	Null, 
	Quantity			float	Null, 
	MvtDcmntExtrnlDcmntNbr		varchar(80)	Null, 
	MvtHdrDte			smalldatetime	Null, 
	XHdrTyp				char(1)	Null, 
	InvntryRcncleClsdAccntngPrdID	int	Null, 
	ChildPrdctOrder			smallint	Null, 
	Description			varchar(150)	Null, 
	TransactionDesc			varchar(50)	Null, 
	XchDiffGrpID1			int	Null, 
	XchDiffGrpName1			varchar(50)	Null, 
	XchUnitValue1			float	Null, 
	XchDiffGrpID2			int	Null, 
	XchDiffGrpName2			varchar(50)	Null, 
	XchUnitValue2			float	Null, 
	XchDiffGrpID3			int	Null, 
	XchDiffGrpName3			varchar(50)	Null, 
	XchUnitValue3			float	Null, 
	XchDiffGrpID4			int	Null, 
	XchDiffGrpName4			varchar(50)	Null, 
	XchUnitValue4			float	Null, 
	XchDiffGrpID5			int	Null, 
	XchDiffGrpName5			varchar(50)	Null, 
	XchUnitValue5			float	Null, 
	LastMonthsBalance		float	Null, 
	ThisMonthsbalance		float	Null, 
	Balance				float	Null, 
	DynLstBxDesc			varchar(50)	Null, 
	TotalValue			Float	Null,
	ContractContact			varchar(50)	Null, 
	UOMAbbv				varchar(20)	Null, 
	MovementTypeDesc		varchar(50)	Null,
	PerUnitDecimalPlaces		int		Null,
	QuantityDecimalPlaces		int		Null,
	AccountPeriod				int		NULL,
	ExternalBAID				int		NULL,
	Action						nvarchar(10) NULL,
	InterfaceMessage			varchar(2000) NULL,
	InterfaceFile				varchar(255) NULL,
	InterfaceID					varchar(20) NULL,
	ImportDate					smalldatetime NULL,
	ModifiedDate				smalldatetime NULL,
	UserId						int NULL,
	ProcessedDate				smalldatetime NULL,
	XHdrStat					char(1)	NULL,
	IESRowType					smallint NULL
)

If @i_SalesInvoiceHeaderID is null
Begin
	Return
End

Declare @i_ExchDiffTransactionGroup1ID		Int
Declare @i_ExchDiffTransactionGroup2ID		Int
Declare @i_ExchDiffTransactionGroup3ID		Int
Declare @i_ExchDiffTransactionGroup4ID		Int
Declare @i_ExchDiffTransactionGroup5ID		Int
Declare @i_ExchDiffTransactionGroup1Name	VarChar(50)
Declare @i_ExchDiffTransactionGroup2Name	VarChar(50)
Declare @i_ExchDiffTransactionGroup3Name	VarChar(50)
Declare @i_ExchDiffTransactionGroup4Name	VarChar(50)
Declare @i_ExchDiffTransactionGroup5Name	VarChar(50)

Select	@i_ExchDiffTransactionGroup1ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup1Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group1'
Select	@i_ExchDiffTransactionGroup2ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup2Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group2'
Select	@i_ExchDiffTransactionGroup3ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup3Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group3'
Select	@i_ExchDiffTransactionGroup4ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup4Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group4'
Select	@i_ExchDiffTransactionGroup5ID 	= TransactionGroup.XGrpID,@i_ExchDiffTransactionGroup5Name = TransactionGroup.XGrpName From TransactionGroup Where TransactionGroup.XGrpQlfr = 'ExchDiffInv-Group5'

----------------------------------------------------------------------------------------------------------------------
-- BEGIN ADDED HMD 09/12/2003 31701 Determine per unit and quantity decimal places 
----------------------------------------------------------------------------------------------------------------------
Declare @i_QuantityDecimalPlaces int, @i_PerUnitDecimalPlaces int
Declare @vc_uomabbv varchar(20), @vc_key varchar(100), @vc_value varchar(100)

Select 	@vc_UOMAbbv = UOMAbbv,
	@i_PerUnitDecimalPlaces =  IsNull(PerUnitDecimalPlaces,0)
--select *
From	SalesInvoiceHeader (NoLock)
	Inner Join UnitofMeasure (NoLock) on SlsInvceHdrUOM = UOM
Where	SlsInvceHdrID = @i_SalesInvoiceHeaderID

select @vc_key = 'System\SalesInvoicing\UOMQttyDecimalsCombinedExchangeStatement\' + @vc_UOMAbbv

Exec sp_get_registry_value @vc_key, @vc_value out

IF @vc_value is not null
	BEGIN
	Select @i_QuantityDecimalPlaces = Convert(int, @vc_value)
	END
ELSE
	BEGIN
	Select @i_QuantityDecimalPlaces = 0
	END
----------------------------------------------------------------------------------------------------------------------
-- END ADDED HMD 09/12/2003 31701 Determine per unit and quantity decimal places 
----------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
-- Calculate the Exchange Differential Sums for movement tranactions for both current and prior months
----------------------------------------------------------------------------------------------------------------------
declare @sql  varchar(2000)

select  @SQL = '
Insert #ExchangeDiffSum
Select	sum(SalesInvoiceDetail.SlsInvceDtlPrUntVle)
	,TransactionDetailLog.XDtlLgXDtlXHdrID
	,TransactionTypeGroup.XTpeGrpXGrpID
	,"X"
From	AccountDetail WITH (NoLock, index =IF1287_AccountDetail) 
		Inner Join	TransactionDetailLog (NoLock) 	On	TransactionDetailLog.XDtlLgID			= AccountDetail.AcctDtlSrceId
								and	AccountDetail.AcctDtlSrceTble 			= "X"
		Inner Join	SalesInvoiceDetail (NoLock)	On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
		Inner Join	TransactionTypeGroup (NoLock) 	On	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= AccountDetail.AcctDtlTrnsctnTypID
								And	TransactionTypeGroup.XTpeGrpXGrpID		 In ( ' + Convert(varchar(10), @i_ExchDiffTransactionGroup1ID) + ', ' + Convert(Varchar(10), @i_ExchDiffTransactionGroup2ID) + ', ' + convert(Varchar(10),@i_ExchDiffTransactionGroup3ID) + ', ' + Convert(varchar(10), @i_ExchDiffTransactionGroup4ID) + ', ' + Convert(varchar(10),@i_ExchDiffTransactionGroup5ID) + ')
Where 	AccountDetail.AcctDtlSlsInvceHdrID		= ' + convert(varchar(10),@i_SalesInvoiceHeaderID) + '
Group by TransactionDetailLog.XDtlLgXDtlXHdrID, TransactionTypeGroup.XTpeGrpXGrpID, AccountDetail.AcctDtlSrceTble

--select * from #ExchangeDiffSum
'

Execute (@sql)

----------------------------------------------------------------------------------------------------------------------
-- Calculate the Exchange Differential Sums for time tranactions for both current and prior months
----------------------------------------------------------------------------------------------------------------------
Select @sql = '
Insert #ExchangeDiffSum	
Select 	Sum(SalesInvoiceDetail.SlsInvceDtlPrUntVle)
	, TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty
	, TransactionTypeGroup.XTpeGrpXGrpID
	, "TT"
From	AccountDetail (NoLock)	
	Inner Join	TimeTransactionDetailLog (NoLock) 	On	TimeTransactionDetailLog.TmeXDtlLgID		= AccountDetail.AcctDtlSrceId
								And	AccountDetail.AcctDtlSrceTble 			= "TT"
	Inner Join	SalesInvoiceDetail	 (NoLock)	On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
	Inner Join	TransactionTypeGroup (NoLock) 	 	On	TransactionTypeGroup.XTpeGrpTrnsctnTypID	= AccountDetail.AcctDtlTrnsctnTypID
								And	TransactionTypeGroup.XTpeGrpXGrpID		In ( ' + Convert(varchar(10), @i_ExchDiffTransactionGroup1ID) + ', ' + Convert(Varchar(10), @i_ExchDiffTransactionGroup2ID) + ', ' + convert(Varchar(10),@i_ExchDiffTransactionGroup3ID) + ', ' + Convert(varchar(10), @i_ExchDiffTransactionGroup4ID) + ', ' + Convert(varchar(10),@i_ExchDiffTransactionGroup5ID) + ')
Where 	AccountDetail.AcctDtlSlsInvceHdrID		= ' + convert(varchar(10),@i_SalesInvoiceHeaderID) + '
Group by TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty, TransactionTypeGroup.XTpeGrpXGrpID, AccountDetail.AcctDtlSrceTble

--select * from #ExchangeDiffSum
'

Execute (@sql)

----------------------------------------------------------------------------------------------------------------------
-- Calculate the statement balance
----------------------------------------------------------------------------------------------------------------------
Declare	@f_StatementBalance	float

Select	@f_StatementBalance =  Isnull((	Select Sum(  Case 
							When FromUOMTpe <> TOUOMTpe 	Then StatementBalance.SttmntBlnceEndngBlnce * Product.PrdctSpcfcGrvty * ConversionFactor 
							Else StatementBalance.SttmntBlnceEndngBlnce * ConversionFactor 
						   End)
					From	StatementBalance (NoLock)
						Inner Join	Product (NoLock)			On	Product.PrdctID				= StatementBalance.SttmntBlncePrdctID
						Inner Join	SalesInvoiceHeader (NoLock)		On	SalesInvoiceHeader.SlsInvceHdrID	= StatementBalance.SttmntBlnceSlsInvceHdrID
						Inner Join 	v_UOMConversion	 (NoLock)		On 	SalesInvoiceHeader.SlsInvceHdrUOM	= v_UOMConversion.ToUOM
													And	v_UOMConversion.FromUOM			= 3
					Where	StatementBalance.SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID ), 0.00)

--select getdate() 'Determine PPAs'
----------------------------------------------------------------------------------------------------------------------
-- Determine and Calculate the Values for all movement transactios that are prior month adjustements
----------------------------------------------------------------------------------------------------------------------
--Insert	#PriorPeriodAdjustment
--Select 	XDtlLgXDtlXHdrID,
--	AcctDtlAccntngPrdID,
--	ChildPrdctID,
--	AcctDtlDlDtlDlHdrID,
--	AcctDtlDlDtlID,
--	SlsInvceDtlDlvryTrmID
--	, Sum(SlsInvceDtlTrnsctnVle)
--	From 	SalesInvoiceDetail (	NoLock)
--		Inner Join		AccountDetail (NoLock)				On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
--											And	AccountDetail.AcctDtlSrceTble 			IN ('X', 'ML')
--		Inner Join		TransactionDetailLog (NoLock)			On	TransactionDetailLog.XDtlLgID			= AccountDetail.AcctDtlSrceID
----		Inner Join		TransactionHeader (NoLock)			On	TransactionDetailLog.XDtlLgXDtlXHdrID		= TransactionHEader.XHdrID
--	Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID	= @i_SalesInvoiceHeaderID
--	And	Not Exists 	(
--					Select 	''
--					From	SalesInvoiceStatement (NoLock)
--					Where	SalesInvoiceStatement.SlsInvceSttmntXHdrID		=	TransactionDetailLog.XDtlLgXDtlXHdrID
--					And	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID	= 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID --@i_SalesInvoiceHeaderID
--				)
--	Group By XDtlLgXDtlXHdrID,
--		AcctDtlAccntngPrdID,
--		ChildPrdctID,
--		AcctDtlDlDtlDlHdrID,
--		AcctDtlDlDtlID,
--		SlsInvceDtlDlvryTrmID

--select * from #PriorPeriodAdjustment


Insert #Type0Results
select distinct 
		StatementBalance.SttmntBlnceSlsInvceHdrID, 
		DealHeader.DlHdrExtrnlBAID,
		DealHeader.DlHdrExtrnlNbr,
		DealHeader.DlHdrIntrnlNbr,
		StatementBalance.SttmntBlnceAccntngPrdID,
		UnitOfMeasure.UOMAbbv,
		0
from StatementBalance (NoLock)
inner join SalesInvoiceHeader (NoLock)
on StatementBalance.SttmntBlnceSlsInvceHdrID = SalesInvoiceHeader.SlsInvceHdrID
inner join DealHeader (NoLock)
on StatementBalance.SttmntBlnceDlHdrID = DealHeader.DlHdrID
inner join UnitOfMeasure (NoLock)
on SalesInvoiceHeader.SlsInvceHdrUOM = UnitOfMeasure.UOM
where StatementBalance.SttmntBlnceSlsInvceHdrID	= @i_SalesInvoiceHeaderID
and DealHeader.DlHdrTyp = 20


Insert #Type1Results
select distinct 
		StatementBalance.SttmntBlnceSlsInvceHdrID,
		DealHeader.DlHdrExtrnlBAID,
		DealHeader.DlHdrExtrnlNbr,
		DealHeader.DlHdrIntrnlNbr,
		Parent.PrdctAbbv,
		ISNULL(StatementBalance.SttmntBlnceEndngBlnce, 0.00),
		ISNULL(LastMonthBalance.SttmntBlnceEndngBlnce, 0.00),
		1
from StatementBalance (NoLock)
inner join DealHeader (NoLock)
on StatementBalance.SttmntBlnceDlHdrID = DealHeader.DlHdrID
inner join Product Parent (NoLock)
on StatementBalance.SttmntBlncePrdctID = Parent.PrdctID
left join StatementBalance LastMonthBalance
on StatementBalance.SttmntBlnceDlHdrID = LastMonthBalance.SttmntBlnceDlHdrID
and StatementBalance.SttmntBlncePrdctID = LastMonthBalance.SttmntBlncePrdctID
and StatementBalance.SttmntBlnceLstAccntngPrdID = LastMonthBalance.SttmntBlnceAccntngPrdID
where StatementBalance.SttmntBlncePrdctID in 
	(select distinct BaseChmclID from DealDetailRegradeRecipe
		where DealHeader.DlHdrID = DealDetailRegradeRecipe.DlDtlDlHdrID)
and StatementBalance.SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID
and DealHeader.DlHdrTyp = 20


--select getdate() 'Get Movement Transactions'
----------------------------------------------------------------------------------------------------------------------
-- Retrieve Movement Transactions
----------------------------------------------------------------------------------------------------------------------
Insert	#Type2Results
select 	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID,
	SalesInvoiceStatement.SlsInvceSttmntXHdrID,
	SalesInvoiceStatement.SlsInvceSttmntRvrsd,
	Dealheader.DlHdrExtrnlNbr,
	DealHeader.DlHdrIntrnlNbr,
	Parent.PrdctAbbv 'ParentPrdctAbbv',
	Child.PrdctID 'ChildPrdctID',
	Child.PrdctAbbv 'ChildPrdcAbbv',
	Origin.LcleAbbrvtn 'OriginLcleAbbrvtn',
	Destination.LcleAbbrvtn 'DestinationLcleAbbrvtn',
	FOB.LcleAbbrvtn 'FOBLcleAbbrvtn',
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then ((InventoryReconcile.XHdrQty * Case InventoryReconcile.XHdrTyp + InventoryReconcile.InvntryRcncleRvrsd When 'RN' Then -1 When 'DY' Then -1 Else 1 End) * InventoryReconcile.XHdrSpcfcGrvty * ConversionFactor)
		Else (InventoryReconcile.XHdrQty * Case InventoryReconcile.XHdrTyp + InventoryReconcile.InvntryRcncleRvrsd When 'RN' Then -1 When 'DY' Then -1 Else 1 End) * ConversionFactor
	End 'Quantity',
	rtrim(MovementDocument.MvtDcmntExtrnlDcmntNbr),
	MovementHeader.MvtHdrDte,
	TransactionHeader.XHdrTyp,
	InventoryReconcile.InvntryRcncleClsdAccntngPrdID,
	Child.PrdctOrder 'ChildPrdctOrder',
	rtrim(MovementDocument.MvtDcmntExtrnlDcmntNbr + ' at ' + FOB.LcleAbbrvtn) 'Description',
	'Movement Transaction' 'Transaction Desc',
	@i_ExchDiffTransactionGroup1ID 		XchDiffGrpID1,
	@i_ExchDiffTransactionGroup1Name 	XchDiffGrpName1,
	isnull(perunit1.UnitValue, 0.00)	XchUnitValue1,
	@i_ExchDiffTransactionGroup2ID		XchDiffGrpID2,	
	@i_ExchDiffTransactionGroup2Name	XchDiffGrpName2,		
	isnull(perunit2.UnitValue, 0.00)	XchUnitValue2,
	@i_ExchDiffTransactionGroup3ID		XchDiffGrpID3,			
	@i_ExchDiffTransactionGroup3Name	XchDiffGrpName3,	
	isnull(perunit3.UnitValue, 0.00)	XchUnitValue3,
	@i_ExchDiffTransactionGroup4ID		XchDiffGrpID4,		
	@i_ExchDiffTransactionGroup4Name	XchDiffGrpName4,	
	isnull(perunit4.UnitValue, 0.00)	XchUnitValue4,
	@i_ExchDiffTransactionGroup5ID		XchDiffGrpID5,		
	@i_ExchDiffTransactionGroup5Name	XchDiffGrpName5,
	isnull(perunit5.UnitValue, 0.00)	XchUnitValue5,
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then Isnull(LastMonthBalance.SttmntBlnceEndngBlnce,0.00) * Child.PrdctSpcfcGrvty * ConversionFactor
		Else Isnull(LastMonthBalance.SttmntBlnceEndngBlnce,0.00)  * ConversionFactor
	End LastMonthsBalance,
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then Isnull(ThisMonthBalance.SttmntBlnceEndngBlnce,0.00) * Child.PrdctSpcfcGrvty * ConversionFactor
		Else Isnull(ThisMonthBalance.SttmntBlnceEndngBlnce,0.00)  * ConversionFactor
	End ThisMonthsbalance,

	@f_StatementBalance,

/*	IsNull((Select	Sum(	Case 
				When FromUOMTpe <> TOUOMTpe 	Then StatementBalance.SttmntBlnceEndngBlnce * Product.PrdctSpcfcGrvty * ConversionFactor 
				Else	StatementBalance.SttmntBlnceEndngBlnce * ConversionFactor 
				End)
		From	StatementBalance (NoLock)
			Inner Join	Product (NoLock)			On	Product.PrdctID				= StatementBalance.SttmntBlncePrdctID
			Inner Join	SalesInvoiceHeader (NoLock)		On	SalesInvoiceHeader.SlsInvceHdrID	= StatementBalance.SttmntBlnceSlsInvceHdrID
			Inner Join 	v_UOMConversion	 (NoLock)		On 	SalesInvoiceHeader.SlsInvceHdrUOM	= v_UOMConversion.ToUOM
										And	v_UOMConversion.FromUOM			= 3
		Where	StatementBalance.SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID),0.00) 'Balance',	*/

	Convert(VarChar,DynamicListBox.DynLstBxDesc) + ':' 'DynLstBxDesc',

	(	Select	IsNull(Sum(SalesInvoiceDetail.SlsInvceDtlTrnsctnVle),0.00)
			From	SalesInvoiceDetail (NoLock)
				Inner Join 	AccountDetail	 (NoLock)	On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
				Inner Join	TransactionDetailLog (NoLock)	On	TransactionDetailLog.XDtlLgID			= AccountDetail.AcctDtlSrceId
										And	AccountDetail.AcctDtlSrceTble 			= 'X'
										And	TransactionDetailLog.XDtlLgXDtlXHdrID		= SalesInvoiceStatement.SlsInvceSttmntXHdrID
		Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID	= @i_SalesInvoiceHeaderID
	) 'TotalValue', 

	Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ContractContact',
	UnitOfMeasure.UOMAbbv,
	Case When IsNull(MovementHeaderType. Name, '') = '' then 'None' else rtrim(MovementHeaderType. Name) end 'Movement Type Desc',
	0,
	0,
	ThisMonthBalance.SttmntBlnceAccntngPrdID 'AccountingPeriod',
	SalesInvoiceHeader.SlsInvceHdrBARltnBAID 'ExternalBAID',
	'N' 'Action',
	'' 'InterfaceMessage',
	'' 'InterfaceFile',
	'' 'InterfaceID',
	getdate() 'ImportDate',
	null 'ModifiedDate',
	0 'UserId',
	getdate() 'ProcessedDate',
	TransactionHeader.XHdrStat,
	2

From	SalesInvoiceStatement (NoLock)
	Inner Join		TransactionHeader (NoLock)			On	TransactionHeader.XHdrID			= SalesInvoiceStatement.SlsInvceSttmntXHdrID
	Inner Join	DealDetail TransactionDealDetail (NoLock)	On TransactionHeader.DealDetailID = TransactionDealDetail.DealDetailID
	Inner Join	DealHeader TransactionDealHeader (NoLock)	On TransactionDealDetail.DlDtlDlHdrID = TransactionDealHeader.DlHdrID
	Inner Join 	InventoryReconcile (NoLock)			On	InventoryReconcile.InvntryRcncleSrceID		= SalesInvoiceStatement.SlsInvceSttmntXHdrID
										And	InventoryReconcile.InvntryRcncleSrceTble	= 'X'
										And	InventoryReconcile.InvntryRcncleRvrsd		= SalesInvoiceStatement.SlsInvceSttmntRvrsd
	Inner Join 		DealHeader (NoLock)				On	DealHeader.DlHdrID				= InventoryReconcile.DlHdrID
	Inner Join		DealDetail	 (NoLock)			On	DealDetail.DlDtlDlHdrID				= InventoryReconcile.DlHdrID
										And	DealDetail.DlDtlID				= InventoryReconcile.DlDtlID
	Inner Join		DealDetailRegradeRecipe ddrg (NoLock)	On DealDetail.DlDtlDlHdrID = ddrg.DlDtlDlHdrID and DealDetail.DlDtlID = ddrg.DlDtlID
	Inner Join		Chemical	(NoLock)			On ddrg.BaseChmclID = Chemical.ChmclParPrdctID
	Inner Join		Contact		 (NoLock)			On	DealHeader.DlHdrExtrnlCntctID			= Contact.CntctID
	Inner Join		Product	Parent (NoLock)				On	Parent.PrdctID					= Chemical.ChmclParPrdctID
	Inner Join		Product	Child	 (NoLock)			On	Child.PrdctID					= InventoryReconcile.ChildPrdctID
	Inner Join		MovementHeader	 (NoLock)			On	MovementHeader.MvtHdrID				= TransactionHeader.XHdrMvtDtlMvtHdrID
	Left Outer Join 	MovementHeaderType				On 	MovementHeader.MvtHdrTyp			= MovementHeaderType.MvtHdrTyp
	Inner Join		MovementDocument (NoLock)			On	MovementDocument.MvtDcmntID			= TransactionHeader.XHdrMvtDcmntID
	Inner Join		Locale 	Origin		 (NoLock)		On	Origin.LcleID					= MovementHeader.MvtHdrLcleID
	Inner Join		Locale	FOB	 (NoLock)			On	FOB.LcleID					= TransactionHeader.MovementLcleID
	Left Outer Join	Locale	Destination		 (NoLock)		On	Destination.lcleID				= MovementHeader.MvtHdrDstntnLcleID		
	Inner Join		StatementBalance ThisMonthBalance  (NoLock)	On	ThisMonthBalance.SttmntBlnceSlsInvceHdrID	= SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID
										And	ThisMonthBalance.SttmntBlncePrdctID		= InventoryReconcile.ChildPrdctID
	Left Outer Join		StatementBalance LastMonthBalance (NoLock)	On	LastMonthBalance.SttmntBlnceDlHdrID     	= InventoryReconcile.DlHdrID 
										And	LastMonthBalance.SttmntBlncePrdctID    		= InventoryReconcile.ChildPrdctID
										And	LastMonthBalance.SttmntBlnceAccntngPrdID	= InventoryReconcile.InvntryRcncleClsdAccntngPrdID - 1
	Left Outer Join 	DynamicListBox  (NoLock)			On 	DynamicListBox.DynLstBxQlfr 			= 'DealDeliveryTerm'
															And 	DynamicListBox.DynLstBxTyp 			= DealDetail.DeliveryTermID
	Inner Join		SalesInvoiceHeader	 (NoLock)		On	SalesInvoiceHeader.SlsInvceHdrID		= SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID
	Inner Join 		v_UOMConversion		 (NoLock)		On 	SalesInvoiceHeader.SlsInvceHdrUOM		= v_UOMConversion.ToUOM
										And	v_UOMConversion.FromUOM				= 3
	Inner Join		UnitOfMeasure		 (NoLock)		On	UnitOfMeasure.UOM				= SalesInvoiceHeader.SlsInvceHdrUOM

	Left Outer Join		#ExchangeDiffSum as perunit1	(Nolock)		On	TransactionHeader.XHdrID			= perunit1.XHdrID
										And	perunit1.XGroupID				= @i_ExchDiffTransactionGroup1ID
										And	perunit1.SourceTable				= 'X'

	Left Outer Join		#ExchangeDiffSum as perunit2	(Nolock)		On	TransactionHeader.XHdrID			= perunit2.XHdrID
										And	perunit2.XGroupID				= @i_ExchDiffTransactionGroup2ID
										And	perunit2.SourceTable				= 'X'

	Left Outer Join		#ExchangeDiffSum as perunit3 (Nolock)			On	TransactionHeader.XHdrID			= perunit3.XHdrID
										And	perunit3.XGroupID				= @i_ExchDiffTransactionGroup3ID
										And	perunit3.SourceTable				= 'X'

	Left Outer Join		#ExchangeDiffSum as perunit4 (Nolock)			On	TransactionHeader.XHdrID			= perunit4.XHdrID
										And	perunit4.XGroupID				= @i_ExchDiffTransactionGroup4ID
										And	perunit4.SourceTable				= 'X'

	Left Outer Join		#ExchangeDiffSum as perunit5 (Nolock)			On	TransactionHeader.XHdrID			= perunit5.XHdrID
										And	perunit5.XGroupID				= @i_ExchDiffTransactionGroup5ID
										And	perunit5.SourceTable				= 'X'
where 	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID	= @i_SalesInvoiceHeaderID
and TransactionDealHeader.DlHdrTyp = 20


--select * from #Results

--select getdate() 'Get Time Transactions'
----------------------------------------------------------------------------------------------------------------------
-- Retrieve Time Transactions
----------------------------------------------------------------------------------------------------------------------
Insert #Type2Results
Select	Distinct 
	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID,
	TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty,
	TimeTransactionDetailLog.TmeXDtlLgRvrsd,
	Dealheader.DlHdrExtrnlNbr,
	DealHeader.DlHdrIntrnlNbr,
	Parent.PrdctAbbv,
	Child.PrdctID,
	Child.PrdctAbbv,
	Origin.LcleAbbrvtn,
	Origin.LcleAbbrvtn,
	Origin.LcleAbbrvtn,
	0.00,
	'',
	AccountDetail.AcctDtlTrnsctnDte,
	TimeTransactionDetail.TmeXDtlTyp,
	AccountDetail.AcctDtlAccntngPrdID,
	Child.PrdctOrder,
	rtrim(TimeTransactionDetail.TmeXDtlDesc + ' at ' + Origin.LcleAbbrvtn) Description,
	'Time Transactions',
	@i_ExchDiffTransactionGroup1ID 		XchDiffGrpID1,
	@i_ExchDiffTransactionGroup1Name 	XchDiffGrpName1,
	isnull(perunit1.UnitValue, 0.00)	XchUnitValue1,
	@i_ExchDiffTransactionGroup2ID		XchDiffGrpID2,	
	@i_ExchDiffTransactionGroup2Name	XchDiffGrpName2,		
	isnull(perunit2.UnitValue, 0.00)	XchUnitValue2,
	@i_ExchDiffTransactionGroup3ID		XchDiffGrpID3,			
	@i_ExchDiffTransactionGroup3Name	XchDiffGrpName3,	
	isnull(perunit3.UnitValue, 0.00)	XchUnitValue3,
	@i_ExchDiffTransactionGroup4ID		XchDiffGrpID4,		
	@i_ExchDiffTransactionGroup4Name	XchDiffGrpName4,	
	isnull(perunit4.UnitValue, 0.00)	XchUnitValue4,
	@i_ExchDiffTransactionGroup5ID		XchDiffGrpID5,		
	@i_ExchDiffTransactionGroup5Name	XchDiffGrpName5,
	isnull(perunit5.UnitValue, 0.00)	XchUnitValue5,
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then Isnull(LastMonthBalance.SttmntBlnceEndngBlnce,0.00) * Child.PrdctSpcfcGrvty * ConversionFactor
		Else Isnull(LastMonthBalance.SttmntBlnceEndngBlnce,0.00)  * ConversionFactor
	End LastMonthsBalance,
	Case 	When FromUOMTpe <> TOUOMTpe 
		Then Isnull(ThisMonthBalance.SttmntBlnceEndngBlnce,0.00) * Child.PrdctSpcfcGrvty * ConversionFactor
		Else Isnull(ThisMonthBalance.SttmntBlnceEndngBlnce,0.00)  * ConversionFactor
	End ThisMonthsbalance,

	@f_StatementBalance,
	/*IsNull((Select	Sum(	Case 
				When FromUOMTpe <> TOUOMTpe 	Then StatementBalance.SttmntBlnceEndngBlnce * Product.PrdctSpcfcGrvty * ConversionFactor 
				Else	StatementBalance.SttmntBlnceEndngBlnce * ConversionFactor 
				End)
		From	StatementBalance (NoLock)
			Inner Join	Product	 (NoLock)		On	Product.PrdctID				= StatementBalance.SttmntBlncePrdctID
			Inner Join	SalesInvoiceHeader (NoLock)	On	SalesInvoiceHeader.SlsInvceHdrID	= StatementBalance.SttmntBlnceSlsInvceHdrID
			Inner Join 	v_UOMConversion (NoLock)		On 	SalesInvoiceHeader.SlsInvceHdrUOM	= v_UOMConversion.ToUOM
								And	v_UOMConversion.FromUOM			= 3
		Where	StatementBalance.SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID),0.00),*/

	Convert(VarChar,DynamicListBox.DynLstBxDesc) + ':',

	(	Select	IsNull(Sum(SalesInvoiceDetail.SlsInvceDtlTrnsctnVle),0.00)
		From	SalesInvoiceDetail (NoLock)
			Inner Join 	AccountDetail (NoLock)		 On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
			Inner Join	TimeTransactionDetailLog (NoLock) On	TimeTransactionDetailLog.TmeXDtlLgID		= AccountDetail.AcctDtlSrceId
									 And	AccountDetail.AcctDtlSrceTble 			= 'TT'
									 And	TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty	= TimeTransactionDetail.TmeXDtlIdnty	
		Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID	= @i_SalesInvoiceHeaderID
	), 

	Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ContractContact',
	UnitOfMeasure.UOMAbbv,
	Null,
	0,
	0,
	ThisMonthBalance.SttmntBlnceAccntngPrdID 'AccountingPeriod',
	SalesInvoiceHeader.SlsInvceHdrBARltnBAID 'ExternalBAID',
	'N' 'Action',
	'' 'InterfaceMessage',
	'' 'InterfaceFile',
	'' 'InterfaceID',
	getdate() 'ImportDate',
	null 'ModifiedDate',
	0 'UserId',
	getdate() 'ProcessedDate',
	TimeTransactionDetail.TmeXDtlStat as 'XHdrStat',
	2

From 	SalesInvoiceDetail (NoLock)
	Inner Join		AccountDetail (NoLock)				On	AccountDetail.AcctDtlID				= SalesInvoiceDetail.SlsInvceDtlAcctDtlID
	Inner Join		TimeTransactionDetailLog (NoLock)		On	TimeTransactionDetailLog.TmeXDtlLgID		= AccountDetail.AcctDtlSrceID
										And	AccountDetail.AcctDtlSrceTble 			= 'TT'
	Inner Join		TimeTransactionDetail (NoLock)			On	TimeTransactionDetail.TmeXDtlIdnty		= TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty	
	Inner Join 		DealHeader (NoLock)				On	DealHeader.DlHdrID				= AccountDetail.AcctDtlDlDtlDlHdrID
	Inner Join		DealDetailRegradeRecipe ddrg (NoLock)	On AccountDetail.AcctDtlDlDtlDlHdrID = ddrg.DlDtlDlHdrID and AccountDetail.AcctDtlDlDtlID = ddrg.DlDtlID
	Inner Join		Chemical	(NoLock)			On ddrg.BaseChmclID = Chemical.ChmclParPrdctID
	Inner Join		Contact (NoLock)				On	DealHeader.DlHdrExtrnlCntctID			= Contact.Cntctid
	Inner Join		Product	Parent (NoLock)				On	Parent.PrdctID					= Chemical.ChmclParPrdctID
	Inner Join		Product	Child (NoLock)				On	Child.PrdctID					= AccountDetail.ChildPrdctID
	Inner Join		Locale 	Origin (NoLock)				On	Origin.LcleID					= AccountDetail.AcctDtlLcleID
	Inner Join		StatementBalance ThisMonthBalance (NoLock)	On	ThisMonthBalance.SttmntBlnceSlsInvceHdrID	= SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID
										And	ThisMonthBalance.SttmntBlncePrdctID		= AccountDetail.ChildPrdctID
	Left Outer Join		StatementBalance LastMonthBalance (NoLock)	On	LastMonthBalance.SttmntBlnceDlHdrID     	= AccountDetail.AcctDtlDlDtlDlHdrID 
										And	LastMonthBalance.SttmntBlncePrdctID    		= AccountDetail.ChildPrdctID
										And	LastMonthBalance.SttmntBlnceAccntngPrdID	= AccountDetail.AcctDtlAccntngPrdID - 1
	Left Outer Join 	DynamicListBox (NoLock) 			on 	DynamicListBox.DynLstBxQlfr 			= 'DealDeliveryTerm'
															And 	DynamicListBox.DynLstBxTyp 			= SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
	Inner Join		SalesInvoiceHeader (NoLock)			On	SalesInvoiceHeader.SlsInvceHdrID		= SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID
	Inner Join 		v_UOMConversion	 (NoLock)			On 	SalesInvoiceHeader.SlsInvceHdrUOM		= v_UOMConversion.ToUOM
										And	v_UOMConversion.FromUOM				= 3
	Inner Join		UnitOfMeasure	 (NoLock)			On	UnitOfMeasure.UOM				= SalesInvoiceHeader.SlsInvceHdrUOM		

	Left Outer Join		#ExchangeDiffSum as perunit1	(Nolock)		On	TimeTransactionDetail.TmeXDtlIdnty		= perunit1.XHdrID
										And	perunit1.XGroupID				= @i_ExchDiffTransactionGroup1ID
										And	perunit1.SourceTable				= 'TT'

	Left Outer Join		#ExchangeDiffSum as perunit2	(Nolock)		On	TimeTransactionDetail.TmeXDtlIdnty		= perunit2.XHdrID
										And	perunit2.XGroupID				= @i_ExchDiffTransactionGroup2ID
										And	perunit2.SourceTable				= 'TT'

	Left Outer Join		#ExchangeDiffSum as perunit3 (Nolock)			On	TimeTransactionDetail.TmeXDtlIdnty		= perunit3.XHdrID
										And	perunit3.XGroupID				= @i_ExchDiffTransactionGroup3ID
										And	perunit3.SourceTable				= 'TT'

	Left Outer Join		#ExchangeDiffSum as perunit4 (Nolock)			On	TimeTransactionDetail.TmeXDtlIdnty		= perunit4.XHdrID
										And	perunit4.XGroupID				= @i_ExchDiffTransactionGroup4ID
										And	perunit4.SourceTable				= 'TT'

	Left Outer Join		#ExchangeDiffSum as perunit5 (Nolock)			On	TimeTransactionDetail.TmeXDtlIdnty		= perunit5.XHdrID
										And	perunit5.XGroupID				= @i_ExchDiffTransactionGroup5ID
										And	perunit5.SourceTable				= 'TT'

Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= @i_SalesInvoiceHeaderID
and DealHeader.DlHdrTyp = 20


--select * from #Results

--select getdate() 'Get PPAs'
----------------------------------------------------------------------------------------------------------------------
-- Retrieve Prior Period Adjustements
----------------------------------------------------------------------------------------------------------------------
Insert	INTO #Type3Results 
(
	SlsInvceSttmntSlsInvceHdrID,
	DlHdrIntrnlNbr,
	ExternalBAID,
	ParentPrdctAbbv,
	ChildPrdctID,
	ChildPrdcAbbv,
	OriginLcleAbbrvtn,
	FOBLcleAbbrvtn,
	TransactionDesc,
	--MvtDcmntExtrnlDcmntNbr,
	MvtHdrDte,
	XHdrTyp,
	Description,
	DynLstBxDesc,
	TotalValue,
	Action,
	InterfaceMessage,
	InterfaceFile,
	InterfaceID,
	ImportDate,
	ModifiedDate,
	UserId,
	ProcessedDate,
	IESRowType
)
SELECT Distinct
	SlsInvceSttmntSlsInvceHdrID,
	DlHdrIntrnlNbr,
	ExternalBAID,
	ParentPrdctAbbv,
	ChildPrdctID,
	ChildPrdctAbbv,
	OriginLcleAbbrvtn,
	FOBLcleAbbrvtn,
	TransactionDesc,
	--MvtDcmntExtrnlDcmntNbr,
	MvtHdrDte,
	XHdrTyp,
	SUBSTRING(RTRIM(ISNULL(OriginLcleAbbrvtn, '') + ' ' 
		+ ISNULL(ChildPrdctAbbv, '') + ' ' 
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Handling Exp' THEN 'HNE' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Handling Rev' THEN 'HNR' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Regrade Diff Exp' THEN 'GRE' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Regrade Diff Rev' THEN 'GRR' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Location Diff Exp' THEN 'LOE' ELSE '' END
		+ CASE WHEN ISNULL(TransactionDesc, '') = 'Exchange-Location Diff Rev' THEN 'LOR' ELSE '' END
		+ ' ' + ISNULL(XHdrTyp, '') + ' ' 
		+ REPLACE(RTRIM(LTRIM(REPLACE(CAST(ISNULL(SlsInvceDtlPrUntVle, 0) AS varchar), '0', ' '))), ' ', '0') + ' ' 
		
		+ str(CAST(iif(SUM(ISNULL(SlsInvceDtlTrnsctnQntty, 0)) < 10 / power(10.0000, @i_QuantityDecimalPlaces),
					0,
					SUM(ISNULL(SlsInvceDtlTrnsctnQntty, 0))) AS varchar), 9, @i_QuantityDecimalPlaces))

	, 0, 50) Description,
	'Prior Month Movement Transaction',
	SUM(SlsInvceDtlTrnsctnVle),
	'N' 'Action',
	'' 'InterfaceMessage',
	'' 'InterfaceFile',
	'' 'InterfaceID',
	getdate() 'ImportDate',
	null 'ModifiedDate',
	0 'UserId',
	getdate() 'ProcessedDate',
	3 'IESRowType'
FROM 
(
	Select	--Distinct 
		@i_SalesInvoiceHeaderID 'SlsInvceSttmntSlsInvceHdrID',
		AccountDetailDealHeader.DlHdrIntrnlNbr,
		AccountDetailDealHeader.DlHdrExtrnlBAID 'ExternalBAID',
		ParentGC.GnrlCnfgMulti 'ParentPrdctAbbv',
		Child.PrdctID 'ChildPrdctID',
		ChildGC.GnrlCnfgMulti 'ChildPrdctAbbv',
		OriginGC.GnrlCnfgMulti 'OriginLcleAbbrvtn',
		FOB.LcleAbbrvtn 'FOBLcleAbbrvtn',
		TransactionType.TrnsctnTypDesc 'TransactionDesc',
		--rtrim(MovementDocument.MvtDcmntExtrnlDcmntNbr) 'MvtDcmntExtrnlDcmntNbr',
		CAST(CAST(DATEPART(YYYY, MovementHeader.MvtHdrDte) as varchar) + '-' + CAST(DATEPART(MM, MovementHeader.MvtHdrDte) as varchar) + '-01' AS date) 'MvtHdrDte',	--They wanted it grouped by Month
		TransactionHeader.XHdrTyp,
		SalesInvoiceDetail.SlsInvceDtlTrnsctnVle,
		CAST(SalesInvoiceDetail.SlsInvceDtlPrUntVle AS decimal(18, 5)) 'SlsInvceDtlPrUntVle',
		SalesInvoiceDetail.SlsInvceDtlTrnsctnQntty
	From SalesInvoiceDetail (NoLock)
		Inner Join		AccountDetail AD (NoLock)					On	AD.AcctDtlID = SalesInvoiceDetail.SlsInvceDtlAcctDtlID And	AD.AcctDtlSrceTble IN ('X', 'ML')
		Inner Join		TransactionDetailLog (NoLock)				On	TransactionDetailLog.XDtlLgID = AD.AcctDtlSrceID
		Inner Join		DealHeader AccountDetailDealHeader (NoLock)	On	AccountDetailDealHeader.DlHdrID = AD.AcctDtlDlDtlDlHdrID
		Inner Join		DealDetail AccountDetailDealDetail (NoLock) On	AccountDetailDealDetail.DlDtlDlHdrID =  AD.AcctDtlDlDtlDlHdrID and AccountDetailDealDetail.DlDtlID = AD.AcctDtlDlDtlID
		Inner Join		TransactionHeader (NoLock)					On	TransactionHeader.XHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
		Inner Join		DealDetailRegradeRecipe ddrg (NoLock)		On	AD.AcctDtlDlDtlDlHdrID = ddrg.DlDtlDlHdrID and AD.AcctDtlDlDtlID = ddrg.DlDtlID
		Inner Join		Chemical (NoLock)							On	ddrg.BaseChmclID = Chemical.ChmclParPrdctID
		Inner Join		Product	Parent (NoLock)						On	Parent.PrdctID = Chemical.ChmclParPrdctID
		Left Outer Join GeneralConfiguration ParentGC (NoLock)		On	Parent.PrdctID = ParentGC.GnrlCnfgHdrID and ParentGC.GnrlCnfgQlfr = 'SAPMaterialCode' and ParentGC.GnrlCnfgTblNme = 'Product'
		Inner Join		Product	Child (NoLock)						On	Child.PrdctID = AccountDetailDealDetail.DlDtlPrdctID
		Left Outer Join GeneralConfiguration ChildGC (NoLock)		On	Child.PrdctID = ChildGC.GnrlCnfgHdrID and ChildGC.GnrlCnfgQlfr = 'SAPMaterialCode' and ChildGC.GnrlCnfgTblNme = 'Product'
		Inner Join		MovementHeader (NoLock)						On	MovementHeader.MvtHdrID	= TransactionHeader.XHdrMvtDtlMvtHdrID
		Inner Join		MovementDocument (NoLock)					On	MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
		Inner Join		Locale 	FOB (NoLock)						On	FOB.LcleID = MovementHeader.MvtHdrLcleID
		Inner Join		Locale 	Origin (NoLock)						On	Origin.LcleID = MovementHeader.MvtHdrLcleID
		Left Outer Join GeneralConfiguration OriginGC (NoLock)		On	Origin.LcleID = OriginGC.GnrlCnfgHdrID and OriginGC.GnrlCnfgQlfr = 'SAPPlantCode' and OriginGC.GnrlCnfgTblNme = 'Locale'
		Inner Join		TransactionType (NoLock)					On	AD.AcctDtlTrnsctnTypID = TransactionType.TrnsctnTypID
	Where	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID	= @i_SalesInvoiceHeaderID
		And	Not Exists 	(
						Select 	''
						From	SalesInvoiceStatement (NoLock)
						Where	SalesInvoiceStatement.SlsInvceSttmntXHdrID		=	TransactionDetailLog.XDtlLgXDtlXHdrID
						And	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID	= 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID --@i_SalesInvoiceHeaderID
					)
		And AccountDetailDealHeader.DlHdrTyp = 20
) T3s
Group By
	SlsInvceSttmntSlsInvceHdrID,
	DlHdrIntrnlNbr,
	ExternalBAID,
	--MvtDcmntExtrnlDcmntNbr,
	ParentPrdctAbbv,
	ChildPrdctID,
	ChildPrdctAbbv,
	OriginLcleAbbrvtn,
	FOBLcleAbbrvtn,
	TransactionDesc,
	MvtHdrDte,
	XHdrTyp,
	SlsInvceDtlPrUntVle
Having sum(SlsInvceDtlTrnsctnVle) <> 0


Update 	#Type2Results 
Set 	PerUnitDecimalPlaces = @i_PerUnitDecimalPlaces,
	QuantityDecimalPlaces = @i_QuantityDecimalPlaces

-- CM - Begin Added - 33060 - 2/12/2004 
select @vc_key = 'System\SalesInvoicing\Statements\ExcludeZeroBalanceNoXctn'  
Exec sp_get_registry_value @vc_key, @vc_ExcludeZeroBalanceNoXctn out
-- CM - Begin Added - 33060 - 2/12/2004

Update 	#Type3Results 
Set 	PerUnitDecimalPlaces = @i_PerUnitDecimalPlaces,
	QuantityDecimalPlaces = @i_QuantityDecimalPlaces

-- CM - Begin Added - 33060 - 2/12/2004 
select @vc_key = 'System\SalesInvoicing\Statements\ExcludeZeroBalanceNoXctn'  
Exec sp_get_registry_value @vc_key, @vc_ExcludeZeroBalanceNoXctn out
-- CM - Begin Added - 33060 - 2/12/2004

UPDATE r SET r.ChildPrdcAbbv = gc.GnrlCnfgMulti
FROM  #Type2Results r
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = r.ChildPrdctID
AND gc.GnrlCnfgTblNme = 'Product'
AND gc.GnrlCnfgQlfr = 'SAPMaterialCode'

UPDATE r SET r.ParentPrdctAbbv = gc.GnrlCnfgMulti
FROM  #Type2Results r
INNER JOIN dbo.Product p
ON p.PrdctAbbv = r.ParentPrdctAbbv
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = p.PrdctID
AND gc.GnrlCnfgTblNme = 'Product'
AND gc.GnrlCnfgQlfr = 'SAPMaterialCode'

UPDATE r SET r.BasePrdctAbbv = gc.GnrlCnfgMulti
FROM  #Type1Results r
INNER JOIN dbo.Product p
ON p.PrdctAbbv = r.BasePrdctAbbv
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = p.PrdctID
AND gc.GnrlCnfgTblNme = 'Product'
AND gc.GnrlCnfgQlfr = 'SAPMaterialCode'

UPDATE r SET r.OriginLcleAbbrvtn = gc.GnrlCnfgMulti
FROM  #Type2Results r
INNER JOIN dbo.Locale l
ON l.LcleAbbrvtn = r.OriginLcleAbbrvtn
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = l.LcleID
AND gc.GnrlCnfgTblNme = 'Locale'
AND gc.GnrlCnfgQlfr = 'SAPPlantCode'

--Select *
--from 	#Results
---- CM - Begin Added - 33060 - 2/12/2004 
--Where	(round(Quantity,0)		<> 0
--Or	 round(LastMonthsBalance,0)	<> 0
--Or	 round(ThisMonthsBalance,0)	<> 0 
--Or	 round(TotalValue,0)		<> 0
--Or 	isnull(@vc_ExcludeZeroBalanceNoXctn,'N') <> 'Y')	
-- CM - End Added - 33060 - 2/12/2004

-- This is the Staging table that the report reads Exchange Statements

--delete from MTVIESExchangeStaging where SlsInvceSttmntSlsInvceHdrID in (select distinct(SlsInvceSttmntSlsInvceHdrID) from #Results)

DELETE d
FROM dbo.MTVIESExchangeStaging d
where d.SlsInvceSttmntSlsInvceHdrID = @i_SalesInvoiceHeaderID

INSERT INTO MTVIESExchangeStaging 
(SlsInvceSttmntSlsInvceHdrID,
ExternalBAID,
DlHdrIntrnlNbr,
DlHdrExtrnlNbr,
AccountPeriod,
UOMAbbv,
IESRowType,
Action)
SELECT SlsInvceSttmntSlsInvceHdrID, 
ExtrnlBAID,
DlHdrIntrnlNbr,
DlHdrExtrnlNbr,
AccntngPrdID,
SlsInvceHdrUOM,
IESRowType,
'N'
FROM #Type0Results


INSERT INTO MTVIESExchangeStaging 
(SlsInvceSttmntSlsInvceHdrID,
ExternalBAID,
DlHdrExtrnlNbr,
DlHdrIntrnlNbr,
ParentPrdctAbbv,
LastMonthsBalance,
ThisMonthsbalance,
IESRowType,
Action)
SELECT SlsInvceSttmntSlsInvceHdrID, 
ExtrnlBAID,
DlHdrExtrnlNbr,
DlHdrIntrnlNbr,
BasePrdctAbbv,
LastMonthsBalance,
ThisMonthsBalance,
IESRowType,
'N'
FROM #Type1Results


INSERT INTO MTVIESExchangeStaging 
SELECT * FROM #Type2Results 
UNION SELECT * FROM #Type3Results
ORDER BY SlsInvceSttmntSlsInvceHdrID, DlHdrIntrnlNbr, ParentPrdctAbbv, XHdrStat, FOBLcleAbbrvtn, ChildPrdcAbbv, MvtDcmntExtrnlDcmntNbr, IESRowType




GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


IF  OBJECT_ID(N'[dbo].[sp_custom_exchdiff_statement_retrieve_details_with_regrades]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql'
			PRINT '<<< ALTERED StoredProcedure sp_custom_exchdiff_statement_retrieve_details_with_regrades >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_custom_exchdiff_statement_retrieve_details_with_regrades >>>'
	  END


Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_RegressDev_20171206_082223\StoredProcedures\sp_custom_exchdiff_statement_retrieve_details_with_regrades.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_RegressDev_20171206_082223\StoredProcedures\SP_MTV_SalesForceDLInvoicesStaging.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------

PRINT 'Start Script=SP_MTVSalesforceDLInvoicesStaging.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDLInvoicesStaging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVSalesforceDLInvoicesStaging] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVSalesforceDLInvoicesStaging >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVSalesforceDLInvoicesStaging]
		@n_NumRecordsToBeStaged int,
		@c_OnlyShowSQL char(1) = 'N'
AS

-- =========================================================================
-- Author:        Sanjay Kumar
-- Create date:	  9MAY2016
-- Description:   This SP pulls data from the CustomInvoiceInterface table,
--				  pushes it into MTVSalesforceDLInvoicesStaging, ready for 
--				  the user to run the SalesforceDLInvoicesExtract job
-- =========================================================================
-- Date         Modified By     Issue#  Modification
-- 12/12/2016   Sanjay Kumar            Added the TaxRate type to be populated in the Staging table.
-- 11/13/2017	Reed Mattingly			Added RA-Dev Deferred Tax InvoiceType.
-- 11/13/2017	Reed Mattingly			Removed unused columns.
-- -----------  --------------  ------  -------------------------------------
-- exec MTVSalesforceDLInvoicesStaging 100, 'y'
--Latest Version
-----------------------------------------------------------------------------


DECLARE @vc_DynamicSQL	varchar(max)

set @vc_DynamicSQL = 'MTVTruncateMTVRetailerInvoicePreStage'
exec(@vc_DynamicSQL)

-- Create a temp table to hold our data
if (@c_OnlyShowSQL <> 'N')
	print '
	create table #Stage
	(
		Id								int,
		TagIdentifier					char(1),
		MsgQID							int,
		BillToSoldToNumber				Varchar(255),
		InvoiceNumber					Varchar(20),
		InvoiceDateTime					SmallDateTime,
		PaymentTerms					Varchar(255),
		ShipToNumber					Varchar(255),
		ProductNumber					Varchar(255),
		TerminalCode					Varchar(255),
		StandardCarrier					Varchar(255),
		CarrierName						Varchar(100),
		BOLNumber						Varchar(80),
		LoadDateTime					SmallDateTime,
		NetVolume						Decimal(19,6),
		GrossVolume						Decimal(19,6),
		UOM								Varchar(20),
		PerGallonBillingRate			Decimal(19,6),
		TotalProductCost				Decimal(19,6),
		TaxName							Varchar(80),
		RelatedSalesInvoiceNumber		Varchar(240),
		InvoiceDueDate					SmallDateTime,
		DiscountedTotalAmount			Decimal(19,6),
		InvoiceType						Varchar(20),
		CorrectingInvoiceNumber			Varchar(20),
		DeferredTaxInvoiceNumber		Varchar(4000),
		RegulatoryText					Varchar(8000),
		InvoiceTotalAmount				Float,
		TotalTax						Float,
		NetAmount						Float,
		CreationDate                    SmallDateTime,
		InvoiceId						INT,
		MvtHdrId						INT,
		AcctDtlId						INT,
		TransactionType					Varchar(80)
		)'
else
	create table #tempMessageQueueIds (MessageQueueId int)
	insert #tempMessageQueueIds
	select distinct top (@n_NumRecordsToBeStaged) CII.MessageQueueID from CustomInvoiceInterface CII 
								Inner Join MTVInvoiceInterfaceStatus MTVIIS (NoLock) on 
								MTVIIS.CIIMssgQID = CII.MessageQueueID 
								where CII.IntBAID = 22 and MTVIIS.SalesForceDataLakeStaged	<> convert(bit, 1)
								order by CII.MessageQueueID asc

	create table #Stage
	(
		Id								int,
		TagIdentifier					char(1),
		MsgQID							int,
		BillToSoldToNumber				Varchar(255),
		InvoiceNumber					Varchar(20),
		InvoiceDateTime					SmallDateTime,
		PaymentTerms					Varchar(255),
		ShipToNumber					Varchar(255),
		ProductNumber					Varchar(255),
		TerminalCode					Varchar(255),
		StandardCarrier					Varchar(255),
		CarrierName						Varchar(100),
		BOLNumber						Varchar(80),
		LoadDateTime					SmallDateTime,
		NetVolume						Decimal(19,6),
		GrossVolume						Decimal(19,6),
		UOM								Varchar(20),
		PerGallonBillingRate			Decimal(19,6),
		TotalProductCost				Decimal(19,6),
		TaxName							Varchar(80),
		RelatedSalesInvoiceNumber		Varchar(240),
		InvoiceDueDate					SmallDateTime,
		DiscountedTotalAmount			Decimal(19,6),
		InvoiceType						Varchar(20),
		CorrectingInvoiceNumber			Varchar(20),
		DeferredTaxInvoiceNumber		Varchar(4000),
		RegulatoryText					Varchar(8000),
		InvoiceTotalAmount				Float,
		TotalTax						Float,
		NetAmount						Float,
		CreationDate                    SmallDateTime,
		InvoiceId						INT,
		MvtHdrId						INT,
		AcctDtlId						INT,
		TransactionType					Varchar(80)
		)

--	Grab all records from the CustomInvoiceInterface table where the SalesForceDataLakeStaged column is not 1
if (@c_OnlyShowSQL <> 'N')
	print N'		Insert #Stage (	Id,
						TagIdentifier, 
						MsgQID, 
						BillToSoldToNumber, 
						InvoiceNumber, 
						InvoiceDateTime,
						PaymentTerms, 
						ShipToNumber, 
						ProductNumber, 
						TerminalCode, 
						StandardCarrier, 
						CarrierName,
						BOLNumber, 
						LoadDateTime, 
						NetVolume, 
						GrossVolume, 
						UOM, 
						PerGallonBillingRate, 
						TotalProductCost, 
						TaxName, 
						RelatedSalesInvoiceNumber,
						InvoiceDueDate, 
						DiscountedTotalAmount,
						InvoiceType,
						CorrectingInvoiceNumber, 
						DeferredTaxInvoiceNumber, 
						RegulatoryText, 
						InvoiceTotalAmount, 
						TotalTax,
						NetAmount,
						CreationDate,
						InvoiceId,
						MvtHdrId,
						AcctDtlId,
						TransactionType)
				Select	CII.Id,
						case when (CII.InvoiceLevel != ''H'' and CAD.DlDtlPrvsnCostType = ''S'') then ''F'' else CII.InvoiceLevel end, 
						CII.MessageQueueID, 
						CADA.SAPSoldToCode, 
						CII.InvoiceNumber, 
						CII.InvoiceDate, 
						case when (CII.InvoiceLevel = ''H'') then Term.TrmVrbge else '''' end,
						case when (CII.InvoiceLevel = ''D'') then CADA.SAPShipToCode else '''' end,
						SAPMC.GnrlCnfgMulti, -- Will need to tweak the Staging code to display at the Fee & Detail Level.
						CADA.SAPPlantCode, 
						CADA.ShipperSCAC, 
						case when (CII.InvoiceLevel = ''D'') then Carrier.BANme else '''' end, 
						case when (CII.BL = '''') then BillOfLading.MvtDcmntExtrnlDcmntNbr else CII.BL end, -- Will need to tweak the Staging code to display at the Tax & Detail Level.
						case when (CII.InvoiceLevel = ''D'' or CII.InvoiceLevel = ''H'') then MH.MvtHdrDte else '''' end,
						case when (CII.InvoiceLevel = ''D'' or CII.InvoiceLevel = ''H'') then AD.NetQuantity else null end, 
						case when (CII.InvoiceLevel = ''D'' or CII.InvoiceLevel = ''H'') then AD.GrossQuantity else null end,  
						case when (CII.InvoiceLevel = ''D'' or CII.InvoiceLevel = ''H'' or CII.InvoiceLevel = ''T'')then CII.UOM else '''' end, 
						case when (TransactionDetail.XDtlPrUntVal is null) then CII.PerUnitPrice else TransactionDetail.XDtlPrUntVal end, -- D, T & F
						case when (CII.AbsInvoiceValue = Abs(CII.LocalCreditValue)) then CII.LocalCreditValue
							 when (CII.AbsInvoiceValue = Abs(CII.LocalDebitValue)) then CII.LocalDebitValue end, -- H, D & F
						case when (CII.InvoiceLevel = ''T'') then TRS.InvoicingDescription else '''' end, 
						case when (CII.InvoiceLevel = ''H'') then (select stuff((select ''~ '' + RelatedInvoices.SlsInvceHdrNmbr from SalesInvoiceHeader SIH1
							Left Join SalesInvoiceHeaderRelation As RSIHR (NoLock) On
							SIH.SlsInvceHdrID = RSIHR.RltdSlsInvceHdrID
							Left Join SalesInvoiceHeader As RelatedInvoices  (NoLock) On
							RSIHR.SlsInvceHdrID = RelatedInvoices.SlsInvceHdrID
						where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID for xml path('''')),1,1,''''))
						else '''' end,
						case when (CII.InvoiceLevel = ''H'') then CII.DueDate else '''' end,	
						case when (CII.InvoiceLevel = ''H'') then CADA.DiscountAmount else null end, 
						case when (SIH.DeferredInvoice = ''Y'' ) then
							case when (AD.Reversed = ''Y'') then ''RA-Rev Deferred Tax'' else ''RA-Deferred Tax''  end
							 when (SIH.SlsinvceHdrId = SIH.SlsInvceHdrPrntID) then ''RA-Original'' 
							 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle < 0) then ''RA-Cancellation'' 
							 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle > 0) then ''RA-Rebill'' end, -- H only
						case when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID) then CIH.SlsInvceHdrNmbr else NULL end, -- H only
						case when (CII.InvoiceLevel = ''H'') then (select stuff((
							select ''~'' + RDI.SlsInvceHdrNmbr
								from SalesInvoiceHeader SIH1
								Left Join SalesInvoiceHeaderRelation SIHR on 
									SIHR.SlsInvceHdrID = SIH1.SlsInvceHdrID
								Left Join SalesInvoiceHeader RDI On
									SIHR.RltdSlsInvceHdrID = RDI.SlsInvceHdrID and RDI.DeferredInvoice = ''Y''
								where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
									order by SIH1.SlsInvceHdrID
									for xml path('''')),1,1,'''')) else '''' end,
						case when (CII.InvoiceLevel = ''H'') then (select stuff((
							select ''~ '' + SIA1.Mssge from SalesInvoiceHeader SIH1
								inner join SalesInvoiceAddendum SIA1 
									on SIH1.SlsInvceHdrID = SIA1.SlsInvceHdrID
								where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
									order by SIH1.SlsInvceHdrID
									for xml path('''')),1,1,'''')) else '''' end,	
						case when (CII.InvoiceLevel = ''H'') then SIH.SlsInvceHdrTtlVle else null end,
						0,
						case when (CII.InvoiceLevel = ''H'') then SIH.SlsInvceHdrTtlVle - CADA.DiscountAmount else null end,
						getdate(),
						CII.InvoiceId,
						CAD.MvtHdrID,
						CAD.AcctDtlID,
						CII.TransactionType
				From	CustomInvoiceInterface CII with (NoLock)
				inner join #tempMessageQueueIds
				ON	CII.MessageQueueID = #tempMessageQueueIds.MessageQueueId
						Left Outer Join SalesInvoiceHeader SIH (NoLock) on	
								CII.InvoiceID = SIH.SlsInvceHdrID
						Left Join DealHeader As DH (NoLock) On 
								DH.DlHdrIntrnlNbr = CASE ISNULL(CII.DealNumber,'''') WHEN '''' 
									THEN (select top 1 SIDtl.SlsInvceDtlDlHdrIntrnlNbr from SalesInvoiceDetail SIDtl where SIDtl.SlsInvceDtlSlsInvceHdrID = CII.InvoiceId) 
									ELSE CII.DealNumber END
						Left Outer Join Term with (NoLock) on 
								Term.TrmID = SIH.SlsInvceHdrTrmID
						Left Join StrategyHeader SH (NoLock) on
								SH.StrtgyID = (select top 1 StrtgyID from DealDetailStrategy DDS where DDS.DlHdrID = DH.DlHdrID)
						Left Join AccountDetail As AD (NoLock) On 
								AD.AcctDtlID = CII.AcctDtlID
						Left Join TransactionDetailLog (NoLock) On
								TransactionDetailLog.XDtlLgAcctDtlID = AD.AcctDtlId
						Left Join TransactionDetail (NoLock) On
								TransactionDetail.XdtlXHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
								and TransactionDetail.XdtlDlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
								and TransactionDetailLog.XDtlLgXDtlID = TransactionDetail. XDtlID
						Left Join CustomAccountDetail CAD (NoLock) On 
								CAD.InterfaceMessageID = CII.MessageQueueID and CAD.AcctDtlID = CII.AcctDtlID
						Left Join CustomAccountDetailAttribute CADA (NoLock) On	
								CADA.CADID = CAD.ID
						Left Join Product (NoLock) On 
								Product.PrdctID = AD.ChildPrdctID
						Left Join SalesInvoiceHeader CIH (NoLock) On 
								CIH.SlsInvceHdrID = SIH.SlsInvceHdrPrntID
						Left Join TaxDetailLog (NoLock) On
							AD.AcctDtlSrceID = TaxDetailLog.TxDtlLgID And (AD.AcctDtlSrceTble = ''T'' or AD.AcctDtlSrceTble = ''I'')
						Left Join TaxDetail (NoLock) On
							TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
						Left Join TaxRuleSet TRS (NoLock) On 
								TRS.TxRleStID = TaxDetail.TxRleStID
						Left Join MovementDocument As BillOfLading (NoLock) On
								BillOfLading.MvtDcmntID =  (select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId)
						Left Join MovementHeader MH (NoLock) On	
								MH.MvtHdrID = CAD.MvtHdrID
						Left Join BusinessAssociate Carrier (NoLock) On	
								Carrier.BAID = MH.MvtHdrCrrrBAID
						Left Join GeneralConfiguration As SAPMC (NoLock) On
								SAPMC.GnrlCnfgQlfr = ''SAPMaterialCode''
								And SAPMC.GnrlCnfgTblNme = ''Product''
								And SAPMC.GnrlCnfgHdrID = Product.PrdctID
'
else
		Insert #Stage (	Id,
						TagIdentifier, 
						MsgQID, 
						BillToSoldToNumber, 
						InvoiceNumber, 
						InvoiceDateTime,
						PaymentTerms, 
						ShipToNumber, 
						ProductNumber, 
						TerminalCode, 
						StandardCarrier, 
						CarrierName,
						BOLNumber, 
						LoadDateTime, 
						NetVolume, 
						GrossVolume, 
						UOM, 
						PerGallonBillingRate, 
						TotalProductCost, 
						TaxName, 
						RelatedSalesInvoiceNumber,
						InvoiceDueDate, 
						DiscountedTotalAmount,
						InvoiceType,
						CorrectingInvoiceNumber, 
						DeferredTaxInvoiceNumber, 
						RegulatoryText, 
						InvoiceTotalAmount, 
						TotalTax,
						NetAmount,
						CreationDate,
						InvoiceId,
						MvtHdrId,
						AcctDtlId,
						TransactionType)
				Select	CII.Id,
						case when (CII.InvoiceLevel != 'H' and CAD.DlDtlPrvsnCostType = 'S') then 'F' else CII.InvoiceLevel end, 
						CII.MessageQueueID, 
						CADA.SAPSoldToCode, 
						CII.InvoiceNumber, 
						CII.InvoiceDate, 
						case when (CII.InvoiceLevel = 'H') then Term.TrmVrbge else '' end,
						case when (CII.InvoiceLevel = 'D') then CADA.SAPShipToCode else '' end,
						SAPMC.GnrlCnfgMulti, -- Will need to tweak the Staging code to display at the Fee & Detail Level.
						CADA.SAPPlantCode, 
						CADA.ShipperSCAC, 
						case when (CII.InvoiceLevel = 'D') then Carrier.BANme else '' end, 
						case when (CII.BL = '') then BillOfLading.MvtDcmntExtrnlDcmntNbr else CII.BL end, -- Will need to tweak the Staging code to display at the Tax & Detail Level.
						case when (CII.InvoiceLevel = 'D' or CII.InvoiceLevel = 'H') then MH.MvtHdrDte else '' end,
						case when (CII.InvoiceLevel = 'D' or CII.InvoiceLevel = 'H') then AD.NetQuantity else null end, 
						case when (CII.InvoiceLevel = 'D' or CII.InvoiceLevel = 'H') then AD.GrossQuantity else null end,  
						case when (CII.InvoiceLevel = 'D' or CII.InvoiceLevel = 'H' or CII.InvoiceLevel = 'T')then CII.UOM else '' end, 
						case when (TransactionDetail.XDtlPrUntVal is null) then CII.PerUnitPrice else TransactionDetail.XDtlPrUntVal end, -- D, T & F
						case when (CII.AbsInvoiceValue = Abs(CII.LocalCreditValue)) then CII.LocalCreditValue
							 when (CII.AbsInvoiceValue = Abs(CII.LocalDebitValue)) then CII.LocalDebitValue end, -- H, D & F
						case when (CII.InvoiceLevel = 'T') then TRS.InvoicingDescription else '' end, 
						case when (CII.InvoiceLevel = 'H') then (select stuff((select '~ ' + RelatedInvoices.SlsInvceHdrNmbr from SalesInvoiceHeader SIH1
							Left Join SalesInvoiceHeaderRelation As RSIHR (NoLock) On
							SIH.SlsInvceHdrID = RSIHR.RltdSlsInvceHdrID
							Left Join SalesInvoiceHeader As RelatedInvoices  (NoLock) On
							RSIHR.SlsInvceHdrID = RelatedInvoices.SlsInvceHdrID
						where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID for xml path('')),1,1,''))
						else '' end,
						case when (CII.InvoiceLevel = 'H') then CII.DueDate else '' end,	
						case when (CII.InvoiceLevel = 'H') then CADA.DiscountAmount else null end, 
						case when (SIH.DeferredInvoice = 'Y' ) then
							case when (AD.Reversed = 'Y') then 'RA-Rev Deferred Tax' else 'RA-Deferred Tax'  end
							 when (SIH.SlsinvceHdrId = SIH.SlsInvceHdrPrntID) then 'RA-Original' 
							 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle < 0) then 'RA-Cancellation' 
							 when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID and SIH.SlsInvceHdrTtlVle > 0) then 'RA-Rebill' end, -- H only
						case when (SIH.SlsinvceHdrId != SIH.SlsInvceHdrPrntID) then CIH.SlsInvceHdrNmbr else NULL end, -- H only
						case when (CII.InvoiceLevel = 'H') then (select stuff((
							select '~' + RDI.SlsInvceHdrNmbr
								from SalesInvoiceHeader SIH1
								Left Join SalesInvoiceHeaderRelation SIHR on 
									SIHR.SlsInvceHdrID = SIH1.SlsInvceHdrID
								Left Join SalesInvoiceHeader RDI On
									SIHR.RltdSlsInvceHdrID = RDI.SlsInvceHdrID and RDI.DeferredInvoice = 'Y' 
								where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
									order by SIH1.SlsInvceHdrID
									for xml path('')),1,1,'')) else '' end,
						case when (CII.InvoiceLevel = 'H') then (select stuff((
							select '~ ' + SIA1.Mssge from SalesInvoiceHeader SIH1
								inner join SalesInvoiceAddendum SIA1 
									on SIH1.SlsInvceHdrID = SIA1.SlsInvceHdrID
								where SIH1.SlsInvceHdrID = SIH.SlsInvceHdrID
									order by SIH1.SlsInvceHdrID
									for xml path('')),1,1,'')) else '' end,	
						case when (CII.InvoiceLevel = 'H') then SIH.SlsInvceHdrTtlVle else null end,
						0,
						case when (CII.InvoiceLevel = 'H') then SIH.SlsInvceHdrTtlVle - CADA.DiscountAmount else null end,
						getdate(),
						CII.InvoiceId,
						CAD.MvtHdrID,
						CAD.AcctDtlID,
						CII.TransactionType
				From	CustomInvoiceInterface CII with (NoLock)
				inner join #tempMessageQueueIds
				ON	CII.MessageQueueID = #tempMessageQueueIds.MessageQueueId
						Left Outer Join SalesInvoiceHeader SIH (NoLock) on	
								CII.InvoiceID = SIH.SlsInvceHdrID
						Left Join DealHeader As DH (NoLock) On 
								DH.DlHdrIntrnlNbr = CASE ISNULL(CII.DealNumber,'') WHEN '' 
									THEN (select top 1 SIDtl.SlsInvceDtlDlHdrIntrnlNbr from SalesInvoiceDetail SIDtl where SIDtl.SlsInvceDtlSlsInvceHdrID = CII.InvoiceId) 
									ELSE CII.DealNumber END
						Left Outer Join Term with (NoLock) on 
								Term.TrmID = SIH.SlsInvceHdrTrmID
						Left Join StrategyHeader SH (NoLock) on
								SH.StrtgyID = (select top 1 StrtgyID from DealDetailStrategy DDS where DDS.DlHdrID = DH.DlHdrID)
						Left Join AccountDetail As AD (NoLock) On 
								AD.AcctDtlID = CII.AcctDtlID
						Left Join TransactionDetailLog (NoLock) On
								TransactionDetailLog.XDtlLgAcctDtlID = AD.AcctDtlId
						Left Join TransactionDetail (NoLock) On
								TransactionDetail.XdtlXHdrID = TransactionDetailLog.XDtlLgXDtlXHdrID
								and TransactionDetail.XdtlDlDtlPrvsnID = TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
								and TransactionDetailLog.XDtlLgXDtlID = TransactionDetail. XDtlID
						Left Join CustomAccountDetail CAD (NoLock) On 
								CAD.InterfaceMessageID = CII.MessageQueueID and CAD.AcctDtlID = CII.AcctDtlID
						Left Join CustomAccountDetailAttribute CADA (NoLock) On	
								CADA.CADID = CAD.ID
						Left Join Product (NoLock) On 
								Product.PrdctID = AD.ChildPrdctID
						Left Join SalesInvoiceHeader CIH (NoLock) On 
								CIH.SlsInvceHdrID = SIH.SlsInvceHdrPrntID
						Left Join TaxDetailLog (NoLock) On
							AD.AcctDtlSrceID = TaxDetailLog.TxDtlLgID And (AD.AcctDtlSrceTble = 'T' or AD.AcctDtlSrceTble = 'I')
						Left Join TaxDetail (NoLock) On
							TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
						Left Join TaxRuleSet TRS (NoLock) On 
								TRS.TxRleStID = TaxDetail.TxRleStID
						Left Join MovementDocument As BillOfLading (NoLock) On
								BillOfLading.MvtDcmntID =  (select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = CII.InvoiceId)
						Left Join MovementHeader MH (NoLock) On	
								MH.MvtHdrID = CAD.MvtHdrID
						Left Join BusinessAssociate Carrier (NoLock) On	
								Carrier.BAID = MH.MvtHdrCrrrBAID
						Left Join GeneralConfiguration As SAPMC (NoLock) On
								SAPMC.GnrlCnfgQlfr = 'SAPMaterialCode'
								And SAPMC.GnrlCnfgTblNme = 'Product'
								And SAPMC.GnrlCnfgHdrID = Product.PrdctID
						/*RLB - Removed due to Headers that have transactionstype of Discount when only reversal due to highestvalue flag on CAD*/

/*RLB - Added to remove any discounts due to logic above being commented out*/
DELETE FROM #Stage WHERE #Stage.TransactionType = 'Discount' and #Stage.TagIdentifier <> 'H'

--New Logic to fill in missing Header level stuff
UPDATE	#Stage
SET		LoadDateTime = MH.MvtHdrDte
FROM	#Stage
INNER JOIN	MovementHeader MH (NoLock) 
ON	(SELECT top 1 MvtHdrID from MovementHeader where MvtHdrMvtDcmntID in 
							(select top 1 SlsInvceDtlMvtDcmntID from SalesInvoiceDetail where SlsInvceDtlSlsInvceHdrID = #Stage.InvoiceId)) =  MH.MvtHdrID
WHERE	#Stage.MvtHdrId IS NULL

Select	@vc_DynamicSQL = '
Insert	MTVRetailerInvoicePreStage (
		TagIdentifier,
		CIIMssgQID,
		BillToSoldToNumber,
		InvoiceNumber,
		InvoiceDateTime,
		PaymentTerms,
		ShipToNumber,
		ProductNumber,
		TerminalCode,
		StandardCarrier,
		CarrierName,
		BOLNumber,
		LoadDateTime,
		NetVolume,
		GrossVolume,
		UOM,
		PerGallonBillingRate,
		TotalProductCost,
		TaxName,
		RelatedInvoiceNumber,
		InvoiceDueDate,
		CashDiscountAmount,
		InvoiceType,
		CorrectingInvoiceNumber,
		DeferredTaxInvoiceNumber,
		RegulatoryText,
		InvoiceTotalAmount,
		TotalTax,
		NetAmount,
		TransactionType,
		AcctDtlId,
		CreationDate)
   select ST.TagIdentifier
		, ST.MsgQID
		, ST.BillToSoldToNumber
		, ST.InvoiceNumber
		, ST.InvoiceDateTime
		, ST.PaymentTerms
		, ST.ShipToNumber
		, ST.ProductNumber
		, ST.TerminalCode					
		, ST.StandardCarrier					
		, ST.CarrierName						
		, ST.BOLNumber						
		, ST.LoadDateTime					
		, ST.NetVolume						
		, ST.GrossVolume						
		, ST.UOM								
		, ST.PerGallonBillingRate			
		, ST.TotalProductCost
		, ST.TaxName
		, ST.RelatedSalesInvoiceNumber						
		, ST.InvoiceDueDate					
		, ST.DiscountedTotalAmount	
		, ST.InvoiceType			
		, ST.CorrectingInvoiceNumber			
		, ST.DeferredTaxInvoiceNumber		
		, ST.RegulatoryText					
		, ST.InvoiceTotalAmount
		, ST.TotalTax
		, ST.NetAmount
		, ST.TransactionType
		, ST.AcctDtlId
		, ST.CreationDate
		from #Stage ST'

		if (@c_OnlyShowSQL <> 'N')
			print @vc_DynamicSQL
		else
			exec(@vc_DynamicSQL)

if (@c_OnlyShowSQL <> 'N')
	print @vc_DynamicSQL
else
	UPDATE t SET t.BillingBasisIndicator = 'Net' FROM MTVRetailerInvoicePreStage t
	INNER JOIN (
		SELECT DISTINCT InvoiceNumber FROM MTVRetailerInvoicePreStage t
		WHERE BillingBasisIndicator = 'Net'
	) i
	ON t.InvoiceNumber = i.InvoiceNumber
	AND t.BillingBasisIndicator IS NULL

	UPDATE t SET t.BillingBasisIndicator = 'Gross' FROM MTVRetailerInvoicePreStage t
	INNER JOIN (
		SELECT DISTINCT InvoiceNumber FROM MTVRetailerInvoicePreStage t
		WHERE BillingBasisIndicator = 'Gross'
	) i
	ON t.InvoiceNumber = i.InvoiceNumber
	AND t.BillingBasisIndicator IS NULL


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDLInvoicesStaging]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_SalesforceDLInvoicesStaging.sql'
			PRINT '<<< ALTERED StoredProcedure MTVSalesforceDLInvoicesStaging >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVSalesforceDLInvoicesStaging >>>'
	  END

Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_RegressDev_20171206_082223\StoredProcedures\SP_MTV_SalesForceDLInvoicesStaging.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Begining Of SQL_RegressDev_20171206_082223\StoredProcedures\SRA_Defragment_Indexes.sql
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
Go
SET QUOTED_IDENTIFIER OFF
Go
------------------------------------------------------------------------------------------------------------------
PRINT 'Start Script=SRA_Defragment_Indexes.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SRA_Defragment_Indexes]') IS NULL
      BEGIN
                     EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[SRA_Defragment_Indexes] AS SELECT 1'
                     PRINT '<<< CREATED StoredProcedure SRA_Defragment_Indexes >>>'
         END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


ALTER  Procedure [dbo].[SRA_Defragment_Indexes] (

        @online             int = 0                 ,

        @tempdb             int = 0                 ,

        @maxfrag            decimal = 20.0          ,

        @singletablename    varchar (128) = null

        )

As

------------------------------------------------------------------------------------------------------------------

-- Name:  SRA_Defragment_Indexes                                                        Copyright 2013 OpenLink

-- Overview:  Determines the logical fragmentation percentage for each index within the database,

--        and Reorganzies those indexes that are over 20% fragmented but under 30%. Rebuilds those

--        indexes where they are 30% fragmented or higher.

--

--

--        Procedure should be setup as nightly occuring SQL Server Job.

--        Procedure will not work running as a RAMQ Job, as sysuser is not DBO of the database.

--

-- Arguments: Online          - Allows for Online Rebuilds of Indexes.  Default is OFF.

--    tempdb    - Part of the work can be done in tempdb.  Default is OFF.

--            On those systems where the tempdb devices reside on seperate

--            Set of disks, there could be some performance gain. Uses more

--            Disk space.

--    MaxFrag         - Default 20% - Don't recommend changing the default

--    SingleTableName - Runs procedure for only the specified table

--

-- Examples:

--    Example 1:  EXECUTE DBO.SRA_DEFRAGMENT_INDEXES

--          Accepts the defaults  Online = OFF, tempdb = OFF, MaxFrag = 20.00 and ALL tables

--    Example 2:  EXECUTE DBO.SRA_DEFRAGMENT_INDEXES 1,1

--          Rebuilds indexes Online and intermediate sort results stored in tempdb, MaxFrag = 20.00 and ALL tables

--    Example 3:  EXECUTE DBO.SRA_DEFRAGMENT_INDEXES @singletablename='DealDetail'

--          Accepts the defaults  Online = OFF, tempdb = OFF, MaxFrag = 20.00 and only the table identified

--

-- SPs:

-- Temp Tables:

--

-- Created by:  Kurt Gerrild

-- History:     4/7/2011 - First Created

--

------------------------------------------------------------------------------------------------------------------

--  Date Modified   Modified By     Issue#  Modification

--  --------------- --------------  ------  ----------------------------------------------------------------------
--  11/16/2011      KEG                   Added code to update statistics on tables that were defragmented
--  12/07/2011      KEG                     Removed code to drop stats on computed columns.
--  12/08/2011      KEG                     Added a check of valid SQL Edition for ONLINE REBUILD of indexes.
--  02/26/2013      SABrown                 Modify to allow parm of Single Table to only handle indexes for that
--                                              table.
--  10/14/2015	    KEG			  Modified UPDATE STATISTICS to include WITH FULLSCAN, INDEX.  Removes the 
--					  COLUMNS STATS update which is included if nothing is specified. 
--	2017-11-08		RMM				Added space before WITH FULLSCAN in Update Statistics dynamic-SQL to avoid syntax errors.
------------------------------------------------------------------------------------------------------------------



SET NOCOUNT ON

SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON



-- Declare variables

Declare @tablename      varchar (128)

Declare @tableschema    varchar (128)

Declare @indexname      varchar (128)

Declare @execstr        varchar (max)

Declare @i_counter      int

Declare @dbid           int

Declare @objectid       int

Declare @indexid        int

Declare @frag           decimal

Declare @online_YN      varchar(3)

Declare @tempdb_YN      varchar(3)

Declare @parent_id      int



--Error checking for correct parameter values of Online and tempdb

If @Online not in (1,0)

  Begin

    RAISERROR ('*** The Online parameter must be set to an integer 1 (ON) or 0 (OFF) ***',16,-1)

    RETURN (1)

  End

If @tempdb not in (1,0)

  Begin

    RAISERROR ('*** The Tempdb parameter must be set to an integer 1 (ON) or 0 (OFF) ***',16,-1)

    RETURN (1)

  End



--Setting online and tempdb variable values based upon Argument input of stor proc.

-- Default is OFF for both

Select @online_YN = Case When @online = 1 Then 'ON' Else 'OFF' End

Select @tempdb_YN = Case When @tempdb = 1 Then 'ON' Else 'OFF' End



 -- Online Build set to 1  we do a SQL Edition Check and RETURN if the Edition is invalid for ONLINE Build

--If @online = 1

--  Begin

--    /* Check our server version; 1804890536 = Enterprise, 610778273 = Enterprise Evaluation, -2117995310 = Developer */

--    If (Select ServerProperty('EditionID')) Not In (1804890536, 610778273, -2117995310)

--      Begin

--        Print 'SQL Edition does not support ONLINE Rebuild of Indexes'

--        RETURN

--      End

--  End



Select @dbid = (Select db_id())

Select @objectid = (select OBJECT_ID(NULL))

--Create table to contain table names

CREATE TABLE #dbtables (

        tableID                         int identity(1,1)   ,

        table_schema                    varchar (255)       ,

        table_name                      varchar (255)

)



--Create table to contain table names that were defragmented

CREATE TABLE #defrag_tables (

        tableID                         int identity(1,1)   ,

        table_schema                    varchar (255)       ,

        table_name                      varchar (255)

)



-- Create the table to contain fragmented information

CREATE TABLE #fraglist (

        fragid                          int identity(1,1)   ,

        database_id                     smallint            ,

        ObjectId                        int                 ,

        IndexId                         int                 ,

        partition_number                int                 ,

        index_type_desc                 nvarchar (60)       ,

        alloc_unit_type_desc            nvarchar (60)       ,

        index_depth                     tinyint             ,

        index_level                     tinyint             ,

        avg_fragmentation_in_percent    float               ,

        fragment_count                  bigint              ,

        avg_fragmentation_size_in_pages float               ,

        page_count                      bigint              ,

        avg_page_space_used_in_percent  float               ,

        record_count                    bigint              ,

        ghost_record_count              bigint              ,

        version_ghost_record_count      bigint              ,

        min_record_size_in_bytes        int                 ,

        max_record_size_in_bytes        int                 ,

        avg_record_size_in_bytes        float               ,

        forwarded_record_count          bigint              ,

        table_schema                    varchar (255) NULL

)



Insert  #dbtables

Select  table_schema

      , table_name

From    INFORMATION_SCHEMA.TABLES

Where   TABLE_TYPE = 'BASE TABLE'

And     ISNULL(@singletablename, TABLE_NAME) = TABLE_NAME



-- Getting a list of indexes from the database

Insert  #fraglist

Select  frag.database_id

      , frag.object_id

      , frag.index_id

      , frag.partition_number

      , frag.index_type_desc

      , frag.alloc_unit_type_desc

      , frag.index_depth

      , frag.index_level

      , frag.avg_fragmentation_in_percent

      , frag.fragment_count

      , frag.avg_fragment_size_in_pages

      , frag.page_count

      , frag.avg_page_space_used_in_percent

      , frag.record_count

      , frag.ghost_record_count

      , frag.version_ghost_record_count

      , frag.min_record_size_in_bytes

      , frag.max_record_size_in_bytes

      , frag.avg_record_size_in_bytes

      , frag.forwarded_record_count

      , table_schema = myTables.table_schema

From    sys.dm_db_index_physical_stats (@dbid, @objectid, NULL, NULL , 'limited') frag

Join    sys.objects obj

        On  frag.object_id = obj.object_id

Join    sys.indexes i

        On  i.object_id = frag.object_id

        And i.index_id = frag.index_id

Join    #dbtables myTables

        On  obj.name = myTables.table_name



-- Defragging Indexes

Select  @i_counter = MIN(fragid)

From    #fraglist



-- loop through the indexes

While @i_counter > 0

  Begin

    --  First, get what we need to work with into variables

    Select  @objectid = frag.ObjectId

          , @tableschema = frag.table_schema

          , @indexid = frag.IndexId

          , @frag = frag.avg_fragmentation_in_percent

          , @tablename = obj.name

          , @parent_id = obj.parent_object_id

          , @indexname = i.name

    From    #fraglist frag

    Join    sys.objects obj (nolock)

            On  frag.ObjectId = obj.object_id

    Join    sys.indexes i (nolock)

            On  i.object_id = frag.objectid

            And i.index_id = frag.indexid

    Where   fragid = @i_counter



    --Checking to see if any columns on the table are LOB, If so I turn the ONLINE parameter to OFF.

    If EXISTS ( Select  'Y'

                From    sys.columns cols (nolock)

                Join    sys.types coltype (nolock)

                        On  cols.system_type_id = coltype.system_type_id

                        And (   coltype.name in ('image','text','ntext') -- system_type_id in (34,35,99)

                            or  cols.max_length = -1 )

                Where   cols.object_id in (@objectid,@parent_id)    )

        Set @Online_YN = 'OFF'



    --Check for Indexes where there is little to no fragmentation and Do Nothing

    If @frag < @maxfrag

      Begin

        Print 'Nothing to do, the INDEX ' + RTRIM(@indexname) + ' ON '

                + RTRIM(@tableschema) + '.' + RTRIM(@tablename) + ' - Fragamentation currently '

                + RTRIM(CONVERT(varchar(15),@frag)) + '%'

      End

    Else

      Begin

        --Check for Indexes where the fragmentation is Under 30% but because of the above check

        --the fragmentation is above 20%.  Do a REORGANIZE

        If @frag < 30.0

          Begin

            Select  @execstr = 'ALTER INDEX ' + RTRIM(@indexname) + ' ON '

                        + RTRIM(@tableschema) + '.' + RTRIM(@tablename) + ' REORGANIZE'



            Print 'Executing ' + @execstr + ' - Fragamentation currently '

                + RTRIM(CONVERT(varchar(15),@frag)) + '%'



            EXEC (@execstr)

          End

        Else  --All other indexes left have a fragmentation above 30% and we do a rebuild.

          Begin

            Select  @execstr = 'ALTER INDEX ' + RTRIM(@indexname) + ' ON '

                        + RTRIM(@tableschema) + '.' + RTRIM(@tablename) + ' REBUILD '



            Print 'Executing ' + @execstr + ' - Fragamentation currently '

                + RTRIM(CONVERT(varchar(15),@frag)) + '%'



            Select  @execstr = @execstr + 'WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = '

                        + @tempdb_YN + ', ONLINE = ' + @online_YN + ')'



            EXEC (@execstr)

          End



        --  This will set the list of tables that have been defragmented that will be used for

        --  UPDATE STATISTICS

        Insert  #defrag_tables (table_schema,table_name)

        Select  @tableschema, @tablename

        Where   Not Exists (Select  1

                            From    #defrag_tables

                            Where   table_schema = @tableschema

                            And     table_name = @tablename)



      End



    -- setting the ONLINE value back to what was specified when executed If it changed in LOB check

    Select  @online_YN = Case When @Online = 1 Then 'ON' Else 'OFF' End

    --  Get the next record to process

    Select  @i_counter = MIN(fragid)

    From    #fraglist

    Where   fragid > @i_counter

  End  --  While @@i_counter > 0



-- Now update statistics on those tables that were defragmented

--Added WITH FULLSCAN, INDEX   to the update Statistics, column statistics can be run outside of this process. 

Print 'Tables to be Altered since Defrag...'

Select  *

From    #defrag_tables



Select  @i_counter = MIN(tableID)

From    #defrag_tables



While @i_counter > 0

  Begin

    Select  @tablename = table_name

          , @tableschema = table_schema

    From    #defrag_tables

    Where   tableID = @i_counter



    If @frag >= @maxfrag

      Begin

        Select  @execstr = 'Update Statistics ' + RTRIM(@tableschema) + '.' + RTRIM(@tablename) + ' WITH FULLSCAN, INDEX'

        Print 'Updating: ' + @execstr

        EXEC (@execstr)

      End



    Select  @i_counter = MIN(tableID)

    From    #defrag_tables

    Where   tableID > @i_counter

  End



-- Delete the temporary table

DROP TABLE #fraglist
DROP TABLE #dbtables
DROP TABLE #defrag_tables




/****** Object:  ViewName [dbo].[SRA_Defragment_Indexes]    Script Date: DATECREATED ******/
PRINT 'Start Script=SRA_Defragment_Indexes.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[SRA_Defragment_Indexes]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.SRA_Defragment_Indexes TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure SRA_Defragment_Indexes >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure SRA_Defragment_Indexes >>>'
Go

------------------------------------------------------------------------------------------------------------------
--Ending Of SQL_RegressDev_20171206_082223\StoredProcedures\SRA_Defragment_Indexes.sql
------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------
--Ending Of Script
------------------------------------------------------------------------------------------------------------------

PRINT 'Start SQLPermissions  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()

--*************************************************************************************************
-- Run SQL permission restore script
------------------------------------------------------------------------------------------------------------------
-- SeedData:	SD_SQLPermissions                                                       Copyright 2015 OpenLink
-- Overview:    
-- Created by:	Blake Doerr
-- History:     7/9/99 - First Created
--
-- Modified     Modified By     Issue#  Modification
-- --------     -------------- 	------  --------------------------------------------------------------------------
-- 18 Feb 2015  Sean Brown              Change Grant statements to include schema name to allow for References
------------------------------------------------------------------------------------------------------------------
Begin
    Create Table #GrantRights (
        ID          int Not Null Identity   ,
        SQLCommand  Varchar(255)
        )

    Create Table #UserName (
        ID          int Not Null Identity   ,
        name        varchar (255)
        )
        
    Declare @i_minID    int
          , @s_UserName varchar (255)

    Insert  #UserName (name)
    Select  'sysuser'
    UNION
    Select  'RightAngleAccess'

    Select  @i_minID = MIN(ID)
    From    #UserName

    While @i_minID > 0
      Begin
        Select  @s_UserName = name
        From    #UserName
        Where   ID = @i_minID
        
        Insert  #GrantRights (SQLCommand) 
        Select  'Grant execute on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sys.objects Obj
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   type = 'P'
        Order by Obj.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant execute, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sys.objects Obj
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   type = 'fn'
        Order by Obj.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant Select, Insert, Alter, Update, Delete, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sys.objects Obj
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   type = 'u'
        Order by Obj.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant Select, Insert, Update, Delete, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sysobjects so
        Join    sys.objects Obj
                On  so.id = Obj.object_id
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   so.type = 'v'
        And     so.status >= 0
        Order by so.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant Select, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sysobjects so
        Join    sys.objects Obj
                On  so.id = Obj.object_id
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   so.type = 'TF'
        And     so.status >= 0
        Order by so.name

        Insert  #GrantRights (SQLCommand)
        Select  'Grant Select, Insert, Update, Delete, References on [' + s.name + '].[' + Obj.name + '] to ' + @s_UserName
        From    sysobjects so
        Join    sys.objects Obj
                On  so.id = Obj.object_id
        Join    sys.schemas S
                On  Obj.schema_id = s.schema_id
                And s.name != 'sys'
        Where   so.type = 'IF'
        And     so.status >= 0
        Order by so.name

        Select  @i_minID = MIN(ID)
        From    #UserName
        Where   ID > @i_minID
      End

    Drop Table #UserName

    --*************************************************************************************************
    --******************************   REMOVE GRANTED PRIVILEGES FROM PUBLIC
    Create Table #tmp1 (
        permission_name     nvarchar(128)
      , obj_name            nvarchar(128)
      , principal_name      nvarchar(128)
      , obj_schema          nvarchar(129)
        )

    Insert  #tmp1
    Select  dp.permission_name permission_name , obj.name obj_name , principals.name principal_name, S.name obj_schema
    From    sys.database_permissions dp
    Join    sys.database_principals principals
            On  dp.grantee_principal_id = principals.principal_id
            and principals.name = 'public'
    Join    sys.objects obj
            on  dp.major_id = obj.object_id
    Join    sys.schemas S
            On  obj.schema_id = S.schema_id
            And S.name != 'sys'
    Where   1=1
    and     dp.major_id > 0
    And     dp.minor_id = 0
    And     dp.grantor_principal_id = 1
    Order by dp.permission_name,obj.name,principals.name

    Insert #GrantRights (SQLCommand) 
    Select cast('Revoke ' as nvarchar) + sub1.permission_name + cast(' on [' as varchar) + sub1.obj_schema + cast('].[' as nvarchar) + sub1.obj_name + cast('] from ' as nvarchar) + sub1.principal_name 
    From    #tmp1 sub1
    Order by sub1.obj_name

    Truncate Table #tmp1
    Insert  #tmp1
    Select  dp.permission_name permission_name , obj.name obj_name , principals.name principal_name, S.name obj_schema
    From    sys.database_permissions dp
    Join    sys.database_principals principals
            On  dp.grantee_principal_id = principals.principal_id
            and principals.name = 'public'
    Join    sys.types obj
            on  dp.major_id = obj.user_type_id
    Join    sys.schemas S
            On  obj.schema_id = S.schema_id
            And S.name != 'sys'

    Where   1=1
    and     dp.major_id > 0
    And     dp.minor_id = 0
    And     dp.grantor_principal_id = 1
    And     dp.class_desc = 'Type'

    Insert  #GrantRights (SQLCommand) 
    Select  cast('REVOKE ' as nvarchar) + sub1.permission_name + cast(' on Type::[' as varchar) + sub1.obj_schema + cast('].[' as nvarchar) + sub1.obj_name + cast('] to ' as nvarchar) + sub1.principal_name 
    From    #tmp1 sub1
    Order by sub1.obj_name

    DROP TABLE #tmp1
    --******************************   END REMOVE GRANTED PRIVILEGES FROM PUBLIC
    --*************************************************************************************************

    Declare @vc_SQLCommand varchar(255)
    Declare @i int
    Select @i = Min(ID) From #GrantRights
    While @i > 0 
      Begin
        Select @vc_SQLCommand = SQLCommand From #GrantRights where ID = @i
        Execute (@vc_SQLCommand)
        Select @i = Min(ID) From #GrantRights Where ID > @i
      End

    Drop Table #GrantRights
End
Go

--******************************   END SQL Permission Restore Script
--*************************************************************************************************


-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	sd_AddAdditionalGrants
-- Overview:    
-- Created by:	Sean Brown
-- History:     28 Mar 2012 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--Grant rights left for PUBLIC
grant select on SourceSystemElementXref to public
go
grant select on users to public
go
grant select on GeneralConfiguration to public
go
grant select,insert,update,delete on SourceSystemElementXref to sysuser
go
