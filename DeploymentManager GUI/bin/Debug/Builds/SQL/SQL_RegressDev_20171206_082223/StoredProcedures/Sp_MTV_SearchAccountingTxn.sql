/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchAccountingTxnDataExtract WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_SearchAccountingTxnDataExtract]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchAccountingTxnDataExtract.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchAccountingTxnDataExtract]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SearchAccountingTxnDataExtract] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SearchAccountingTxnDataExtract >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SearchAccountingTxnDataExtract]
AS

-- =============================================
-- Author:        JM
-- Create date:	  4/12/2016
-- Description:   custom selection of all accounting transactions
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

/***********  INSERT YOUR CODE HERE  ***********  */
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

declare @i_StateStructureID int

declare @taxStatus table
(
Id char(1) not null,
Value varchar(20) not null
)
insert into @taxStatus values ('N', 'NotEvaluated'), ('R', 'Evaluated'),('A', 'Applied')


declare @yesnoLookup table 
(
	Id char(1) not null,
	Value varchar(4) not null
)
insert into @yesnoLookup values ('Y', 'Yes'), ('N', 'No')


declare @txnsourcelookup table
(
	Id char not null,
	Value varchar(20) not null
)
insert into @txnsourcelookup values ('T', 'Tax'), ('X', 'Movement')

Select @i_StateStructureID = (Select convert(int,GnrlCnfgMulti) 
				From	GeneralConfiguration 
				Where	GnrlCnfgQlfr = 'State Structure'
				And	GnrlCnfgTblNme = 'System')

IF NOT EXISTS (SELECT [name] FROM tempdb.sys.tables WHERE [name] like '#Locations%')
BEGIN
	SELECT LcleId AS LocationID,  LTrim(LcleNme + LcleNmeExtension) AS Name,  Case When LTrim(LcleAbbrvtn) + RTrim(LcleAbbrvtnExtension) = '' Then 'Missing Abbreviation' Else LTrim(LcleAbbrvtn) + RTrim(LcleAbbrvtnExtension) End AS Abbreviation,
		   Locale.LcleTpeID AS Type, LcleStts As Status, UseOnDealFlg, LocaleType.LcleTpeIsPhscl As IsPhysicalLocation
	INTO #Locations
	FROM dbo.Locale inner join dbo.LocaleType on dbo.Locale.LcleTpeID = dbo.LocaleType.LcleTpeID
END


IF NOT EXISTS (SELECT [name] FROM tempdb.sys.tables WHERE [name] like '#ParentLocs%')
BEGIN
	select parentLoc.LcleID StateLcleId, childLoc.LcleID ChildLcleId

	Into #ParentLocs

	from P_PositionGroupFlat parent
	Inner Join P_PositionGroupChemicalLocale parentLoc
		on parentLoc.P_PstnGrpID = parent.ChldP_PstnGrpID
	Inner Join P_PositionGroupChemicalLocaleFlat childLoc
		on parent.ChldP_PstnGrpID = childLoc.PrntP_PstnGrpID
	Where parent.PrntP_PstnGrpID = @i_StateStructureID -- Root State Group
	and parent.ChldLevel = 1
	Union All
	select parentLoc.LcleID StateLcleId, parentLoc.LcleID ChildLcleId
	from P_PositionGroupFlat parent
	Inner Join P_PositionGroupChemicalLocale parentLoc
		on parentLoc.P_PstnGrpID = parent.ChldP_PstnGrpID
	Where parent.PrntP_PstnGrpID = @i_StateStructureID -- Root State Group
	and parent.ChldLevel = 1
END
	
Select	 [AccountDetail].[AcctDtlID]				as	'AcctId'
		,[ExternalBA].BAAbbrvtn						as	'Ext BA'
		,case when [TransactionHeader].[XHdrTyp]='R' 
		 then 'Receipt' 
		 when [TransactionHeader].[XHdrTyp] = 'D'		
		 then 'Delivery' End						as	'R/D'
		--,[PlannedDealType].[Description]			as	'Deal Type'	
		,[DealType].[Description]						as  'Deal Type'	
		,[DealHeader].[DlHdrIntrnlNbr]				as	'Deal'
		,[AccountDetail].[AcctDtlTrnsctnDte]		as	'TktDate'
		,[MovementDocument].[MvtDcmntExtrnlDcmntNbr] as 'BOL'
	    ,[PlannedMovementHeader].[LineNumber]		as	'Ln#'
		,[AccountDetailLocation].LcleAbbrvtn		as	'AcctDtlLoc'
		,[Product].[PrdctAbbv]						as	'Product'
		,[ProductCode].GnrlCnfgMulti				as  'FTAProductCode'
		,[CommoditySubGroup].[Name]					as	'Tax Commodity'
		,[TransactionType].[TrnsctnTypDesc]			as  'Tran Type'
		,[AccountDetail].[Volume]					as	'Quantity'
		,[MovementHeaderType].Name					as	'MOD'
		, case when [DealDetail].[QuantityNetOrGross]='N' 
		  then 'Net' 
	      when [DealDetail].[QuantityNetOrGross]='G' 
		  then 'Gross' end							as 'N/G'
		,Case 
		 When AccountDetail.Volume = 0.0 Then Convert(Decimal(20,6),AccountDetail.Value  )
		 Else Case When AccountDetail.Value / AccountDetail.Volume >= 0 Then Convert(Decimal(20,6),AccountDetail.Value / AccountDetail.Volume)
		 Else Convert(Decimal(20,6), AccountDetail.Value / AccountDetail.Volume * -1)
		 End  End									as 'Rate'
		,[AccountDetail].[Value]					as 'Tran Amt'
		--,(Select	Min([DD1].[QuantityNetOrGross]) [N/G]
		--  From	    [DealDetail] [DD1] (NoLock)
		--  Where  	(
		--		       [DD1].DlDtlDlHdrID = [DealHeader].DlHdrID 
		--		    ))								[N/G]
		,[AccountDetail].CreatedDate				as	'CreateDate'
		,OriginLocation.LcleAbbrvtn					as 'Origin'
		,DestinationLocation.LcleAbbrvtn			as 'Destination'
		--,[AccountDetail].[AcctDtlDestinationLcleID] as 'Destination'
		,[SalesInvoiceHeader].[SlsInvceHdrNmbr]		as 'SlsInv'
		,[SalesInvoiceHeader].[SlsInvceHdrPstdDte]	as 'Distr'
		,[AccountDetail].[PayableMatchingStatus]	as 'Discard'
		,[PayableHeader].[InvoiceNumber]			as 'PurchInv'
		,OriginLocaleState.Abbreviation				as 'OS'
		,DestinationLocaleState.Abbreviation		as 'DS'
		,[AccountDetail].[NetQuantity]				as 'Net'
		,[AccountDetail].[GrossQuantity]			as 'Gross'
	    ,Concat( DateName(m, [AccountingPeriod].AccntngPrdBgnDte), ' ', year([AccountingPeriod].AccntngPrdBgnDte)) as 'AcctPer'
	    ,[Currency].[CrrncySmbl]					as 'Curr'
		--,[AccountDetail].[AcctDtlAcctCdeStts]		as 'ACS'
		--,AccountDetail.des
		,AccountCodeStatus.Value					as 'ACS'
		--,[AccountDetail].[Reversed]				as 'Rev'
		,AccountDtlIsReversed.Value					as 'Rev'
		--,[AccountDetail].[AcctDtlTxStts]			as 'Taxed'
		,TaxStatus.Value							as 'Taxed'
		--,[AccountDetail].[AcctDtlSrceTble] 		as 'Source'
		,[TxnSource].[Value]						as 'Source'
		--,[AccountDetail].[IsNetOut]				as 'NO'
		,AccountDtlIsNetOut.Value					as 'NO'
		,[InternalBA].[BAAbbrvtn]					as 'IntBA'
		,[TaxRuleSet].[InvoicingDescription]		as 'Invoicing Description'
		,[MovementHeader].[LineNumber]				as 'Line Item Line Number'
		,[TaxRuleSet].[AllowDeferedBilling]			as 'Allow Deferred Billing'
		,[Term].[TrmVrbge]							as 'Billing Term Description'
		,[TaxRuleSet].[Description]					as 'Description'
		--,SalesInvoiceDetail.SlsInvceDtlMvtHdrTyp	as 'Movement Type'
		,SlsInvDetailMvtHdr.Name					as 'Movement Type'
		--,[MovementHeader].[MvtHdrTyp]				as 'Line Item Movement Type'
		,LineItemMvtHdr.Name				as 'Line Item Movement Type'
		,MvtSoldTo.GnrlCnfgMulti			as 'SAPMvtSoldTo'
		
From	[AccountDetail] (NoLock)
		Left Join [SalesInvoiceHeader] (NoLock) On
			[AccountDetail].AcctDtlSlsInvceHdrID = [SalesInvoiceHeader].SlsInvceHdrID
		Left Join [PayableHeader] (NoLock) On
			[AccountDetail].AcctDtlPrchseInvceHdrID = [PayableHeader].PybleHdrID
		Left Join [DealHeader]  (NoLock) On
			[AccountDetail].AcctDtlDlDtlDlHdrID = [DealHeader].DlHdrID
		Left Join [MovementHeader] (NoLock) On
			[AccountDetail].AcctDtlMvtHdrID = [MovementHeader].MvtHdrID
		Left Join [TransactionDetailLog] (NoLock) On
			[AccountDetail].AcctDtlSrceID = [TransactionDetailLog].XDtlLgID And [AccountDetail].AcctDtlSrceTble = 'X'
		Left Join [Product] (NoLock) On
			IsNull([AccountDetail].ChildPrdctID, [AccountDetail].ParentPrdctID) = [Product].PrdctID
		Left Join [MovementDocument] (NoLock) On
			[MovementHeader].MvtHdrMvtDcmntID = [MovementDocument].MvtDcmntID
		--Added by MattV to pull in the SAPMvtSoldToNumber field
		Left Join [GeneralConfiguration] MvtSoldTo (NoLock) On
			[MovementHeader].MvtHdrID = MvtSoldTo.GnrlCnfgHdrID 
			and MvtSoldTo.GnrlCnfgQlfr = 'SAPMvtSoldToNumber'
			and MvtSoldTo.GnrlCnfgTblNme = 'MovementHeader'
		Left Join [TransactionHeader] (NoLock) On
			[TransactionDetailLog].XDtlLgXDtlXHdrID = [TransactionHeader].XHdrID
		Left Join [#ParentLocs] [OriginState] (NoLock) On
			OriginState.ChildLcleID = IsNull(MovementHeader.MvtHdrOrgnLcleID,AccountDetail.AcctDtlLcleID)
		Left Join [#ParentLocs] [DestState] (NoLock) On
			DestState.ChildLcleID  = Isnull(AccountDetail. AcctDtlDestinationLcleID, AccountDetail. AcctDtlLcleID)
		Left Join [DealDetailChemical] (NoLock) On
			DealDetailChemical.DlDtlChmclDlDtlDlHdrID  = AccountDetail. AcctDtlDlDtlDlHdrID and DealDetailChemical.DlDtlChmclDlDtlID  = AccountDetail. AcctDtlDlDtlID and NullIf(DealDetailChemical.DlDtlChmclChmclChldPrdctID,AccountDetail. ChildPrdctID) is null
		Left Join [AccountDetailExternal] (NoLock) On
			1=2
		Left Join [ExternalInvoiceDetail] (NoLock) On
			1=2
		Left Join [AccountDetailDescription] (NoLock) On
			1=2
		Left Join [ExternalInvoiceHeader] (NoLock) On
			1=2
		Join [AccountingPeriod] (NoLock) On
			AccountDetail.AcctDtlTrnsctnDte between AccountingPeriod.AccntngPrdBgnDte and AccountingPeriod.AccntngPrdEndDte
		Left Join [AccountDetailEstimatedDate] (NoLock) On
			[AccountDetail].AcctDtlID = [AccountDetailEstimatedDate].AcctDtlID
		Left Join [BusinessAssociate] (nolock) as InternalBA On
			InternalBA.BAID = AccountDetail.InternalBAID
		Left Join [BusinessAssociate] (nolock) as ExternalBA On
			ExternalBA.BAID = AccountDetail.ExternalBAID
		Left Join [DealType] (nolock) ON
			[DealType].DlTypID = [DealHeader].DlHdrTyp
		Left Join Locale As AccountDetailLocation (NoLock) On
			AccountDetailLocation.LcleID = AccountDetail.AcctDtlLcleID
		Left Join [GeneralConfiguration] As ProductCode (NoLock) On
			[ProductCode].[GnrlCnfgQlfr] = 'FTAProductCode'
				And [ProductCode].[GnrlCnfgTblNme] = 'Product'
				And [ProductCode].[GnrlCnfgHdrID] = [AccountDetail].[ParentPrdctID]
		Left Join CommoditySubGroup (nolock) On 
				CommoditySubGroup.CmmdtySbGrpID = Product.TaxCmmdtySbGrpID
		Left Join TransactionType (nolock) On
				TransactionType.TrnsctnTypID = AccountDetail.AcctDtlTrnsctnTypID
	    Left Join [MovementHeaderType] (nolock) On
				[MovementHeaderType].MvtHdrTyp = TransactionHeader.MvtHdrTyp 
		Left Join [Currency] (nolock) On
				Currency.CrrncyID = AccountDetail.CrrncyID
		Left Join [SalesInvoiceDetail] SalesInvoiceDetail (nolock) On
				[SalesInvoiceDetail].[SlsInvceDtlAcctDtlID] = [AccountDetail].[AcctDtlID]
		Left Join [Term] (nolock) On 
			[Term].TrmID = SalesInvoiceHeader.SlsInvceHdrTrmID
	    Left Join [TaxDetailLog]  (NoLock) On
			[AccountDetail].AcctDtlSrceID = TaxDetailLog.TxDtlLgID And [AccountDetail].AcctDtlSrceTble = 'T'
		Left Join [TaxDetail]  (NoLock) On
			[TaxDetailLog].TxDtlLgTxDtlID = TaxDetail.TxDtlID
		Left Join [TaxRuleSet]  (NoLock) On
			[TaxDetail].TxRleStID = TaxRuleSet.TxRleStID
		Left Join [DealDetail] (nolock) On
			[DealDetail].DlDtlDlHdrID = AccountDetail.AcctDtlDlDtlDlHdrID 
		And	[DealDetail].DlDtlID = AccountDetail.AcctDtlDlDtlID
		Left Join [PlannedTransfer] PlannedTrsf (nolock) On
			[TransactionHeader].[XHdrPlnndTrnsfrID] = PlannedTrsf.PlnndTrnsfrID
		Left Join [DealHeader] PlannedDealHeader (nolock) On 
			PlannedTrsf.PlnndTrnsfrObDlDtlDlHdrID = PlannedDealHeader.DlHdrID
		Left Join [DealType] PlannedDealType (nolock) ON
			PlannedDealType.DlTypID = PlannedDealHeader.DlHdrTyp
		Left Join [MovementHeader] PlannedMovementHeader (nolock) On 
			PlannedMovementHeader.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
		Left Join [Locale] OriginLocation (nolock) On 
			OriginLocation.LcleID = [AccountDetail].[AcctDtlLcleID]
		left Join [Locale] DestinationLocation (nolock) On
			DestinationLocation.LcleID = [AccountDetail].AcctDtlDestinationLcleID
		Left Join [#Locations] OriginLocaleState (nolock) On 
				OriginLocaleState.LocationID = [OriginState].[StateLcleId]
		Left Join [#Locations] DestinationLocaleState (nolock) On
				DestinationLocaleState.LocationID = [DestState].[StateLcleId]
		
		-- Formatting
		Left Join @yesnoLookup AccountDtlIsReversed On
				AccountDtlIsReversed.Id = AccountDetail.Reversed
		Left Join @yesnoLookup AccountCodeStatus On 
				AccountCodeStatus.Id = AccountDetail.AcctDtlAcctCdeStts
		Left Join @yesnoLookup AccountDtlIsNetOut On
				AccountDtlIsNetOut.Id = AccountDetail.IsNetOut
		Left Join @txnsourcelookup TxnSource On
				TxnSource.Id = [AccountDetail].[AcctDtlSrceTble]
		Left Join MovementHeaderType SlsInvDetailMvtHdr On 
				SlsInvDetailMvtHdr.MvtHdrTyp = [SalesInvoiceDetail].SlsInvceDtlMvtHdrTyp
		Left Join MovementHeaderType LineItemMvtHdr On
				LineItemMvtHdr.MvtHdrTyp = [MovementHeader].[MvtHdrTyp]
		Left Join @taxStatus TaxStatus On
				TaxStatus.Id = AccountDetail.AcctDtlTxStts
Where(
	  AccountDetail.AcctDtlSrceTble Not Like 'E%'
     )

Order By 'AcctId'


If	Object_ID('TempDB..#ParentLocs') Is Not Null
	Drop Table #ParentLocs	

If	Object_ID('TempDB..#Locations') Is Not Null
	Drop Table #Locations					


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchAccountingTxnDataExtract]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SearchAccountingTxnDataExtract.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SearchAccountingTxnDataExtract >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SearchAccountingTxnDataExtract >>>'
	  END