PRINT 'Start Script=sp_MPC_Statement_balance_Mtv_TA.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_balance_Mtv_TA]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MPC_Statement_balance_Mtv_TA] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MPC_Statement_balance_Mtv_TA >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

--select beginningvolume / 42,* from InventorySubledgerDetail where DlDtlChmclDlDtlDlHdrID= 79 and accntngprdid = 321 --sept beginning august ending
--exec sp_mpc_statement_balance_mtv_ta 246464 --65341



/*--------------------------------------------------------------------------------------------------
-- rules:   only show balance product
--          get current month - 1 from inventorysubledgerdetail  ( this is beginning balance )
--          get current month  from inventorysubledgerdetail ( this is ending balance )
--          get all adjustments in inventory change
--          get all regrades in inventory change
-----------------------------------------------------------------------------------------------------          
*/
ALTER PROCEDURE dbo.sp_MPC_Statement_balance_Mtv_TA
( @i_SlsInvceHdrID int )
AS

DECLARE	@vc_ErrorString				Varchar(1000),
		@vc_AcctMonth				Varchar(20),
		@dt_AccntngPrdBgnDte        DateTime,
		@i_VETradePeriodID			Int,
		@sdt_InsertDate				SmallDateTime,
		@i_accntngprdid             Int,
		@i_dlhdrid                  Int,
		@AccountingMonth            varchar(20),
		@DealNumber                 varchar(20)



select @i_AccntngPrdID = ( Select top 1 SttmntBlnceAccntngPrdID From StatementBalance where SttmntBlnceSlsInvceHdrID = @i_SlsInvceHdrID )

Select	@vc_AcctMonth = AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')
, @dt_AccntngPrdBgnDte = AccntngPrdBgnDte
, @AccountingMonth =   AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')

From	AccountingPeriod
Where	AccntngPrdID = @i_AccntngPrdID


select	@i_VETradePeriodID = VETradePeriodID
From	PeriodTranslation
Where	AccntngPrdID = @i_AccntngPrdID


select @i_DlHdrID = ( Select top 1 SttmntBlnceDlHdrID From StatementBalance where SttmntBlnceSlsInvceHdrID = @i_SlsInvceHdrID )
select @DealNumber = ( Select DlHdrIntrnlNbr from DealHeader where DlHdrID = @i_DlHdrID )

select @sdt_InsertDate = GetDate()


/*
select * 
into #InvBalance
from MTVDLInvBalancesStaging 
where dealnumber = @DealNumber
  and AccountingMonth = @AccountingMonth
*/


Create Table #InvBalance
			(
			AccountingMonth							Varchar(20),
			DlHdrID                                 int,
			DealNumber								Varchar(20),
			DetailNumber							Int,
			BlendProduct							Char(3) NULL,
			StorageLocation							Varchar(255) NULL,
			ProductName								Varchar(150) NULL,
			RegradeProductName						Varchar(150) NULL,
			BegInvVolume							Decimal(19,6) NULL,
			EndingInvVolume							Decimal(19,6) NULL,
			UOM										Char(20) NULL,
			TotalReceipts							Decimal(19,6) NULL,
			TotalDisbursement						Decimal(19,6) NULL,
			TotalBlend								Decimal(19,6) NULL,
			GainLoss								Decimal(19,6) NULL,
			BookAdjReason							Varchar(255) NULL,
			IsAdjustment                            Char(1) NULL
			)

/*******************************************
Now get the Inventory Balances beginning/ending
********************************************/
Insert #InvBalance
			(
			AccountingMonth,							
			DlHdrID,
			DealNumber,								
			DetailNumber,							
			BlendProduct,							
			StorageLocation,							
			ProductName,			
			RegradeProductName,
			BegInvVolume,							
			EndingInvVolume,							
			UOM,										
			TotalReceipts,							
			TotalDisbursement,						
			TotalBlend,								
			GainLoss,								
			BookAdjReason,							
			IsAdjustment                          
			)
Select	DISTINCT
		AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')								as AccountingMonth,
		DealHeader.DlHdrID,
		DealHeader.DlHdrIntrnlNbr														as DealNumber,
		DealDetail.DlDtlID																as DetailNumber,
		ICSub.BlendProduct																as BlendProduct,
		locale.LcleAbbrvtn + isnull(locale.LcleAbbrvtnExtension,'')                      as storagelocation,
		Product.PrdctNme																as ProductName,
		ICSub.ChemName																	as RegradeProductName,
		IsNull(ISDBegin.BeginningVolume, 0.0)											as BegInvVolume,
		ISD.BeginningVolume																as EndingInvVolume,
		'GAL'																			as UOM,
		0.0																				as TotalReceipts,
		0.0																				as TotalDisbursement,
		0.0																				as TotalBlend,
		0.0																				as GainLoss,
		''																	    		as BookAdjReason,
		'N'                                                                             as IsAdjustment
From	InventorySubledgerDetail ISD with (NoLock)
		Inner Join AccountingPeriod with (NoLock)
			on	AccountingPeriod.AccntngPrdID		= ISD.AccntngPrdID -1
		Inner Join (
					Select	DlHdrID, BalanceDlDtlID, BookAccntngPrdID, ChemID,
							Case When BalanceChemID <> ChemID Then 'Y' Else 'N' End	as BlendProduct,
							Case When BalanceChemID <> ChemID Then ICChemical.PrdctNme Else NULL End				as ChemName
					From	InventoryChange with (NoLock)
							Inner Join Product ICChemical with (NoLock)
								on	ICChemical.PrdctID					= InventoryChange.ChemID

					Where	InventoryChange.QuantityType		= 'M'
					  and   DlHdrID = @i_DlHdrID
					Group By DlHdrID, BalanceDlDtlID, BookAccntngPrdID, ChemID,Case When BalanceChemID <> ChemID Then 'Y' Else 'N' End,
							Case When BalanceChemID <> ChemID Then ICChemical.PrdctNme Else NULL End	
					) ICSub
			on	ICSub.DlHdrID			= ISD.DlDtlChmclDlDtlDlHdrID
			and	ICSub.BalanceDlDtlID	= ISD.DlDtlChmclDlDtlID
			and	ICSub.BookAccntngPrdID	in (ISD.AccntngPrdID -1, ISD.AccntngPrdID-2)
		Inner Join DealHeader with (NoLock)
			on	DealHeader.DlHdrID					= ISD.DlDtlChmclDlDtlDlHdrID
		Inner Join DealDetail with (NoLock)
			on	DealDetail.DlDtlDlHdrID				= ISD.DlDtlChmclDlDtlDlHdrID
			and	DealDetail.DlDtlID					= ISD.DlDtlChmclDlDtlID
		Inner Join Product Chemical with (NoLock)
			on	Chemical.PrdctID					= ISD.DlDtlChmclChmclChldPrdctID
		Inner Join Product with (NoLock)
			on	Product.PrdctID						= ISD.DlDtlChmclChmclPrntPrdctID
		Inner Join Locale on Locale.LcleID = DealDetail.DlDtlLcleID
		Left Outer Join InventorySubledgerDetail ISDBegin with (NoLock)
			on	ISD.DlDtlChmclDlDtlDlHdrID			= ISDBegin.DlDtlChmclDlDtlDlHdrID
			and	ISD.DlDtlChmclDlDtlID				= ISDBegin.DlDtlChmclDlDtlID
			and	ISD.DlDtlChmclChmclPrntPrdctID		= ISDBegin.DlDtlChmclChmclPrntPrdctID
			and	ISD.DlDtlChmclChmclChldPrdctID		= ISDBegin.DlDtlChmclChmclChldPrdctID
			and	ISD.StrtgyID						= ISDBegin.StrtgyID
			and	ISD.AccntngPrdID - 1				= ISDBegin.AccntngPrdID
		Left Outer Join ReconcileGroupDetail RGDetail with (NoLock) 
		    ON RGDetail.RcncleGrpDtlDlHdrID = DealHeader.DlHdrID
			and RGDetail.DlDtlID = DealDetail.DlDtlID
		Left Outer Join EndingInventory EndInv with (NoLock)
			on	EndInv.EndngInvntryRcncleGrpID		= RGDetail.RcncleGrpDtlRcncleGrpID
			and	EndInv.AccntngPrdID					= ISD.AccntngPrdID
Where	ISD.AccntngPrdID	= @i_AccntngPrdID +1
  and   DealHeader.DlHdrID = @i_DlHdrID
  

------------------------------------------------------
-- now put row for all zero base balances
------------------------------------------------------
insert into #InvBalance
(   AccountingMonth,	
    DlHdrID,					
    DealNumber,								
	DetailNumber,							
	BlendProduct,							
	StorageLocation,							
	ProductName,	
	RegradeProductName,		
	BegInvVolume,							
	EndingInvVolume,							
	UOM,										
	TotalReceipts,							
	TotalDisbursement,						
	TotalBlend,								
	GainLoss,								
	BookAdjReason,							
	IsAdjustment                          
)
Select DISTINCT
		AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2') as AccountingMonth			
, bcv.DlDtlDlHdrID
, DH.DlHdrIntrnlNbr
, bcv.DlDtlID
, 'N'
, Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')  as StorageLocation
, product.PrdctNme  as ProductName
, product.PrdctNme  as ProductName
, IsNull(ISD.BeginningVolume,0.0)   as BeginningVolume
, IsNull(ISDplus1.BeginningVolume,0.0)	as EndingInvVolume
, 'GAL'
, 0.0
, 0.0
, 0.0
, 0.0
, null
, 'N'
From balanceconfigView bcv with (noLock)
    join AccountingPeriod with (NoLock) on AccntngPrdID = @i_AccntngPrdID
	inner join DealHeader DH With (Nolock) on dh.DlHdrID = bcv.DlDtlDlHdrID
	inner join DealDetail DD With (Nolock) on dd.DlDtlDlHdrID = bcv.DlDtlDlHdrID
	                                     and  dd.DlDtlID = bcv.BaseDlDtlID
	Inner Join DealDetailStrategy DDS WITH (NoLock) ON DDS.DlHdrID = dd.DlDtlDlHdrID
	                                               AND DDS.DlDtlID = dd.DlDtlID
	inner join Product with (NoLock) on Product.PrdctID = bcv.PrdctID
	inner join Locale with (Nolock) on Locale.LcleID = bcv.LcleID
    Left Outer Join InventorySubledgerDetail ISD with (NoLock)
			on	ISD.DlDtlChmclDlDtlDlHdrID			= bcv.DlDtlDlHdrID
			and	ISD.DlDtlChmclDlDtlID				= bcv.BaseDlDtlID
			and	ISD.DlDtlChmclChmclPrntPrdctID		= bcv.BaseChmclID
			and	ISD.DlDtlChmclChmclChldPrdctID		= bcv.BaseChmclID
			and	ISD.StrtgyID						= dds.StrtgyID
			and	ISD.AccntngPrdID 			    	= @i_accntngprdid
    Left Outer Join InventorySubledgerDetail  isdplus1 with (nolock) 
			on	isdplus1.DlDtlChmclDlDtlDlHdrID			= bcv.DlDtlDlHdrID
			and	isdplus1.DlDtlChmclDlDtlID				= bcv.BaseDlDtlID
			and	isdplus1.DlDtlChmclChmclPrntPrdctID		= bcv.BaseChmclID
			and	isdplus1.DlDtlChmclChmclChldPrdctID		= bcv.BaseChmclID
			and	isdplus1.StrtgyID						= dds.StrtgyID
			and	isdplus1.AccntngPrdID 			    	= @i_accntngprdid + 1
where bcv.DlDtlDlHdrID = @i_DlHdrID
    and bcv.BaseRecDel = bcv.RecDel
    and bcv.BaseDlDtlID =bcv.DlDtlID
    and bcv.ChmclID = BaseChmclID
  and not exists ( select 'x' 
                      from #InvBalance IB where IB.DlHdrID = BCV.DlDtlDlHdrID and IB.DetailNumber = BCV.DlDtlID and IB.blendproduct = 'N')
                                  
/*------------------------------------------------------------------------------------
--  now put a row for all movements
-------------------------------------------------------------------------------------*/
insert into #InvBalance
(   AccountingMonth,	
    DlHdrID,					
    DealNumber,								
	DetailNumber,							
	BlendProduct,							
	StorageLocation,							
	ProductName,	
	RegradeproductName,		
	BegInvVolume,							
	EndingInvVolume,							
	UOM,										
	TotalReceipts,							
	TotalDisbursement,						
	TotalBlend,								
	GainLoss,								
	BookAdjReason,							
	IsAdjustment                          
)
Select	Distinct
		AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')								as AccountingMonth,
		Dealheader.DlHdrID,
		DealHeader.DlHdrIntrnlNbr														as DealNumber,
		DealDetail.DlDtlID																as DetailNumber,
		ICSub.BlendProduct																as BlendProduct,
		Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')					as StorageLocation,
		Product.PrdctNme																as ProductName,
		ICSub.ChemName                                                                  as RegradeProductName,
		0.0																				as BegInvVolume,
		0.0																				as EndingInvVolume,
		'GAL'																			as UOM,
		0.0																				as TotalReceipts,
		0.0																				as TotalDisbursement,
		0.0																				as TotalBlend,
		0.0																	   			as GainLoss,
		''																			    as BookAdjReason,
		'N' 
From	InventoryChange with (NoLock)
		Inner Join AccountingPeriod with (NoLock)
			on	AccountingPeriod.AccntngPrdID		= InventoryChange.BookAccntngPrdID
		Inner Join (
					Select	DlHdrID, BalanceDlDtlID, BookAccntngPrdID, ChemID,
							Case When BalanceChemID <> ChemID Then 'Y' Else 'N' End									as BlendProduct,
							Case When BalanceChemID <> ChemID Then ICChemical.PrdctNme Else NULL End				as ChemName,
							Case When BalanceChemID <> ChemID Then GCFTAChemical.GnrlCnfgMulti Else NULL End		as ChemFTA,
							Case When BalanceChemID <> ChemID Then RTRIM(ChemTaxCommodity.Name) Else NULL End		as ChemTaxCommodity
					From	InventoryChange with (NoLock)
							Inner Join Product ICChemical with (NoLock)
								on	ICChemical.PrdctID					= InventoryChange.ChemID
							Inner Join GeneralConfiguration GCFTAChemical with (NoLock)
								on	GCFTAChemical.GnrlCnfgTblNme		= 'Product'
								and	GCFTAChemical.GnrlCnfgQlfr			= 'FTAProductCode'
								and	GCFTAChemical.GnrlCnfgHdrID			= ICChemical.PrdctID
							Inner Join CommoditySubGroup ChemTaxCommodity with (NoLock)
								on	ChemTaxCommodity.CmmdtySbGrpID		= IsNull(ICChemical.TaxCmmdtySbGrpID, -1)
					Where	InventoryChange.QuantityType		= 'M'
					  and   InventoryChange.DlHdrID = @i_DlHdrID
					  and   InventoryChange.BookAccntngPrdID = @i_AccntngPrdID
					Group By DlHdrID, BalanceDlDtlID, BookAccntngPrdID, ChemID, BalanceChemID, ICChemical.PrdctNme, GCFTAChemical.GnrlCnfgMulti, ChemTaxCommodity.Name
					) ICSub
			on	ICSub.DlHdrID						= InventoryChange.DlHdrID
			and	ICSub.BalanceDlDtlID				= InventoryChange.BalanceDlDtlID
			and	ICSub.BookAccntngPrdID				= InventoryChange.BookAccntngPrdID
		Inner Join DealHeader with (NoLock)
			on	DealHeader.DlHdrID					= InventoryChange.DlHdrID
		Inner Join DealDetail with (NoLock)
			on	DealDetail.DlDtlDlHdrID				= InventoryChange.DlHdrID
			and	DealDetail.DlDtlID					= InventoryChange.BalanceDlDtlID
		Inner Join Locale with (NoLock)
			on	Locale.LcleID						= DealDetail.DlDtlLcleID
		Inner Join Product Chemical with (NoLock)
			on	Chemical.PrdctID					= InventoryChange.PrdctID
		Inner Join Product with (NoLock)
			on	Product.PrdctID						= InventoryChange.ChemID
		Left Outer Join ReconcileGroupDetail RGDetail with (NoLock)
			on	RGDetail.RcncleGrpDtlDlHdrID		= InventoryChange.DlHdrID
			and	RGDetail.DlDtlID					= InventoryChange.BalanceDlDtlID
			and	RGDetail.PrdctID					= Product.PrdctID
		Left Outer Join EndingInventory EndInv with (NoLock)
			on	EndInv.EndngInvntryRcncleGrpID		= RGDetail.RcncleGrpDtlRcncleGrpID
			and	EndInv.AccntngPrdID					= InventoryChange.BookAccntngPrdID

Where	InventoryChange.BookAccntngPrdID	= @i_AccntngPrdID
and     DealHeader.DlHdrID = @i_DlHdrID
and		InventoryChange.QuantityType		= 'M'
And		not exists	(
					Select	1
					From	#InvBalance Sub with (NoLock)
							Inner Join DealHeader DHSub with (NoLock)
								on	DHSub.DlHdrIntrnlNbr			= Sub.DealNumber
					Where	DHSub.DlHdrID							= InventoryChange.DlHdrID
					And		Sub.DetailNumber						= InventoryChange.BalanceDlDtlID
					And		IsNull(Sub.RegradeProductName, 'X')		= IsNull(ICSub.ChemName, 'X')
					)







Update	#InvBalance
Set		TotalReceipts				= ICSub.Build,
		TotalDisbursement			= ICSub.Draw,
		GainLoss					= ICSub.GainLoss,
		TotalBlend					= ICSub.BlendQty,
		BookAdjReason				= isnull(ICSub.Description,'')
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
					And		IsNull(AccountingReasonCode.Description, '')	= ''

					Group By DealHeader.DlHdrIntrnlNbr,
							InventoryChange.BalanceDldtlID,
							ICChemical.PrdctNme,
							AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2'),
							AccountingReasonCode.Description			) ICSub
			on	ICSub.DealNumber			= #InvBalance.DealNumber
			and	ICSub.BalanceDldtlID		= #InvBalance.DetailNumber
			and	ICSub.Chem					= IsNull(#InvBalance.RegradeProductName, #InvBalance.ProductName)
			and	ICSub.AccountingMonth		= #InvBalance.AccountingMonth

Insert #InvBalance
			(
			AccountingMonth,							
			DlHdrID,
			DealNumber,								
			DetailNumber,							
			BlendProduct,							
			StorageLocation,							
			ProductName,			
			RegradeProductName,
			BegInvVolume,							
			EndingInvVolume,							
			UOM,										
			TotalReceipts,							
			TotalDisbursement,						
			TotalBlend,								
			GainLoss,								
			BookAdjReason,							
			IsAdjustment                          
			)
select Distinct
		icsub.AccountingMonth								as AccountingMonth,
		icsub.DlHdrID,
		icsub.DealNumber														        as DealNumber,
		icsub.BalanceDlDtlID														    as DetailNumber,
        'N',
		icsub.StorageLocation                               					        as StorageLocation,
		icsub.prdctnme															    	as ProductName,
		icsub.chemname                                                                  as RegradeProductName,
		0.0																				as BegInvVolume,
		0.0																				as EndingInvVolume,
		'GAL'																			as UOM,
		0.0																				as TotalReceipts,
		0.0																				as TotalDisbursement,
		0.0																				as TotalBlend,
		icsub.	GainLoss																as GainLoss,
		icsub.Description																as BookAdjReason,
		'Y'                                                       
From	 (
					Select	DealHeader.DlHdrIntrnlNbr										as DealNumber,
					        DealHeader.DlHdrID,
							InventoryChange.BalanceDldtlID									as BalanceDlDtlID,
							ICChemical.PrdctNme												as Chem,
							AccntngPrdYr + '-' + format(AccntngPrdPrd, 'd2')				as AccountingMonth,
						    VolumeQty * -1						                    		as GainLoss,
							AccountingReasonCode.Description								as Description,
							Locale.LcleAbbrvtn + IsNull(Locale.LcleAbbrvtnExtension, '')    as StorageLocation,
							ICChemical.prdctnme,
							Case When BalanceChemID <> ChemID Then ICChemical.PrdctNme Else NULL End				as ChemName
					From	InventoryChange with (NoLock)
							Inner Join AccountingPeriod with (NoLock)
								on	AccountingPeriod.AccntngPrdID					= InventoryChange.BookAccntngPrdID
							Inner Join DealHeader with (NoLock)
								on	DealHeader.DlHdrID								= InventoryChange.DlHdrID
							Inner Join Product ICChemical with (NoLock)
								on	ICChemical.PrdctID								= InventoryChange.ChemID
							Inner Join Locale with (NoLock) 
							    on Locale.LcleID = InventoryChange.LcleID
							Inner Join InventoryReconcile with (NoLock)
								on	InventoryReconcile.InvntryRcncleID				= InventoryChange.SourceID
							Inner Join TransactionHeader with (NoLock)
								on	TransactionHeader.XHdrID						= InventoryReconcile.InvntryRcncleSrceID
								and	InventoryReconcile.InvntryRcncleSrceTble		= 'X'
							Left Outer Join AccountingReasonCode with (NoLock)
								on	AccountingReasonCode.Code						= InventoryReconcile.InvntryRcncleRsnCde
					Where	DealHeader.DlHdrID = @i_DlHdrID
					And     InventoryChange.BookAccntngPrdID = @i_AccntngPrdID
					And     InventoryChange.SourceType			= 'I'
					And		InventoryChange.QuantityType		= 'M'
					And		IsNull(AccountingReasonCode.Description, '')	<> ''

                  ) icsub




            update #InvBalance
			set BegInvVolume = round(BegInvVolume / 42,2) * -1
			, EndingInvVolume = round(EndingInvVolume / 42,2)  * -1
			, TotalDisbursement  = round(TotalReceipts / 42,2) * -1
			, TotalReceipts = round(TotalDisbursement / 42,2)  
			, TotalBlend = ( select sum(i2.TotalBlend) /42 from #invBalance i2 where i2.ProductName = #invBalance.ProductName and i2.storagelocation = #invBalance.StorageLocation  and BlendProduct = 'Y') * -1
			, GainLoss = ( select sum(i2.GainLoss) /42 from #invBalance i2 where i2.ProductName = #invBalance.ProductName and i2.storagelocation = #invBalance.StorageLocation  and IsAdjustment = 'Y') 

			--round(GainLoss / 42,2) 
			from #INVBalance
			Where #INVBalance.BlendProduct = 'N'
			  and #INVBalance.IsAdjustment = 'N'

		   update #invbalance set totalblend = 0.0 where totalblend is  null

			select datename(month,@dt_AccntngPrdBgnDte) + ' ' + datename(yyyy,@dt_AccntngPrdBgnDte),Product.PrdctAbbv,
			AccountingMonth,
			dealnumber,
			detailnumber,
			blendproduct,
			storagelocation,
			productname,
			sum(beginvvolume),
			sum(endinginvvolume),
			uom,
			sum(totalreceipts),
			sum(totaldisbursement),
			sum(totalblend),
			sum(gainloss),
			'',
			'N'
			from #InvBalance
			     inner join Product on Product.PrdctNme = #InvBalance.ProductName
			where blendproduct = 'N'
			  and IsAdjustment = 'N'
            group by		
			 Product.PrdctAbbv,
			AccountingMonth,
			dealnumber,
			detailnumber,
			blendproduct,
			UOM,
			storagelocation,
			productname


/*			union All
			select datename(month,@dt_AccntngPrdBgnDte) + ' ' + datename(yyyy,@dt_AccntngPrdBgnDte),Product.PrdctAbbv,
			AccountingMonth,
			dealnumber,
			detailnumber,
			blendproduct,
			storagelocation,
			productname,
			0.0,
			0.0,
			uom,
			0.0,
			0.0,
			0.0,
			gainloss,
			bookadjreason,
			'Y'
			from #InvBalance
			     inner join Product on Product.PrdctNme = #InvBalance.ProductName
			where IsAdjustment = 'Y' and GainLoss <> 0
			--Order by Product.PrdctAbbv, storagelocation,isadjustment
*/

DROP TABLE #InvBalance


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_balance_Mtv_TA]') IS NOT NULL
    BEGIN
		EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MPC_Statement_balance_Mtv_TA.sql'
		PRINT '<<< ALTERED StoredProcedure sp_MPC_Statement_balance_Mtv_TA >>>'
	END
ELSE
	BEGIN
		PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MPC_Statement_balance_Mtv_TA >>>'
	END