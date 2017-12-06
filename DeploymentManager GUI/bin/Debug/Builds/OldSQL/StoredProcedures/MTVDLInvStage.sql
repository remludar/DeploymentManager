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
			Status
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
			'N'																				as Status
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
Set		ISDID						= ISD.InvntrySbldgrDtlID,
		TradingBook					= StrategyHeader.Name,
		ProfitCenter				= GCProfitCtr.GnrlCnfgMulti,
		BegInvVolume				= IsNull(ISDBegin.BeginningVolume, 0.0),
		EndingInvVolume				= ISD.BeginningVolume,
		PerUnitValue				= Case	when ISD.BeginningVolume <> 0
											then ISD.BeginningValue / ISD.BeginningVolume
											else 0.0 end,
		EndingInvValue				= ISD.BeginningValue,
		EndingPhysicalBalance		= EndInv.EndngInvntryExtrnlBlnce
-- select *
From	#InvBalance
		Inner Join InventorySubledgerDetail ISD with (NoLock)
			on	ISD.DlDtlChmclDlDtlDlHdrID			= #InvBalance.DlHdrID
			and	ISD.DlDtlChmclDlDtlID				= #InvBalance.BalanceDlDtlID
		Inner Join StrategyHeader with (NoLock)
			on	StrategyHeader.StrtgyID				= ISD.StrtgyID
		Left Outer Join GeneralConfiguration GCProfitCtr with (NoLock)
			on	GCProfitCtr.GnrlCnfgTblNme			= 'StrategyHeader'
			and	GCProfitCtr.GnrlCnfgQlfr			= 'ProfitCenter'
			and	GCProfitCtr.GnrlCnfgHdrID			= StrategyHeader.StrtgyID
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
Where	ISD.AccntngPrdID	= @i_AccntngPrdID +1



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