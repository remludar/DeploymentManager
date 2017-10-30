/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_IncrementalTransferPrices WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_IncrementalTransferPrices]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTV_IncrementalTransferPrices.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTransferPrices]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[MTV_IncrementalTransferPrices](@In smalldatetime) AS SELECT 1'
			PRINT '<<< CREATED Procedure MTV_IncrementalTransferPrices >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[MTV_IncrementalTransferPrices]    Script Date: 6/2/2016 8:20:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER Procedure [dbo].[MTV_IncrementalTransferPrices]	@transactionsFromDate smalldatetime, 
														@userId int, 
														@accountingPeriodID int
As

-----------------------------------------------------------------------------------------------------------------------------
-- Name:	MTV_IncrementalTransferPrices         Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	Pull all the movement and the accounting transactions with the tax details.
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Sanjay Kumar
-- History:	16/12/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
DECLARE  @nullDate SMALLDATETIME
DECLARE  @closeDate SMALLDATETIME

----------------------------------------------------------------------------------------------------------------------
-- Drop the temp table
----------------------------------------------------------------------------------------------------------------------	
If	Object_ID('TempDB..#TaxLocaleStructure') Is Not Null
BEGIN
	Drop Table #TaxLocaleStructure	
	PRINT 'Dropped Temp Table #TaxLocaleStructure'
END

If	Object_ID('TempDB..#TaxRates') Is Not Null
BEGIN
	Drop Table #TaxRates
	PRINT 'Dropped Temp Table #TaxRates'
END

TRUNCATE TABLE MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Transfer Price Interface'	,GETDATE(),'Start','SQL','Sysuser',db_name(),'Start','Gathering Tax Locale Structure'

SELECT prnt.LcleID,tl.LcleAbbrvtn + ISNULL(tl.LcleAbbrvtnExtension,'') LcleAbbrvtn,lt.LcleTpeDscrptn
INTO #LocaleStructure
FROM dbo.LocaleType lt (NOLOCK)
INNER JOIN dbo.Locale l (NOLOCK)
ON l.LcleTpeID = lt.LcleTpeID 
AND lt.LcleTpeDscrptn IN ('County','States','City')
INNER JOIN dbo.P_PositionGroupChemicalLocaleFlat chld (NOLOCK)
ON chld.LcleID = l.LcleID
AND chld.ChldP_PstnGrpID IS NULL
INNER JOIN dbo.P_PositionGroup pg2 (NOLOCK)
ON chld.P_PstnGrpID = PG2.P_PstnGrpID
AND pg2.Name like 'Tax||%'
INNER JOIN dbo.Product p (NOLOCK)
ON  chld.PrdctID = p.PrdctID
AND p.PrdctAbbv = 'Global Product'
INNER JOIN dbo.P_PositionGroupChemicalLocaleFlat prnt (NOLOCK)
ON prnt.PrntP_PstnGrpID = chld.P_PstnGrpID
INNER JOIN dbo.P_PositionGroupTemplate pgt (NOLOCK)
ON  prnt.P_PstnGrpTmplteIDParent = pgt.P_PstnGrpTmplteID
AND prnt.P_PstnGrpTmplteIDChild = pgt.P_PstnGrpTmplteID
AND pgt.Description = 'Location'
INNER JOIN dbo.P_PositionGroup pg (NOLOCK)
ON prnt.PrntP_PstnGrpID = PG.P_PstnGrpID
AND PG.Name like 'Tax||%'
INNER JOIN dbo.Locale tl (NOLOCK)
ON tl.LcleID = chld.LcleID

UPDATE t SET t.LcleAbbrvtn = c.Name
FROM #LocaleStructure t
INNER JOIN (
	SELECT lcleID,dbo.fn_MTV_GetTaxLocaleStructureFlat(LcleID,'County') Name
	FROM #LocaleStructure
	WHERE LcleTpeDscrptn = 'County' GROUP BY lcleID HAVING COUNT(1) > 1
) c
ON t.LcleID = c.LcleID
AND t.LcleTpeDscrptn = 'County'

UPDATE t SET t.LcleAbbrvtn = c.Name
FROM #LocaleStructure t
INNER JOIN (
	SELECT lcleID,dbo.fn_MTV_GetTaxLocaleStructureFlat(LcleID,'States') Name
	FROM #LocaleStructure
	WHERE LcleTpeDscrptn = 'States' GROUP BY lcleID HAVING COUNT(1) > 1
) c
ON t.LcleID = c.LcleID
AND t.LcleTpeDscrptn = 'States'

UPDATE t SET t.LcleAbbrvtn = c.Name
FROM #LocaleStructure t
INNER JOIN (
	SELECT lcleID,dbo.fn_MTV_GetTaxLocaleStructureFlat(LcleID,'City') Name
	FROM #LocaleStructure
	WHERE LcleTpeDscrptn = 'City' GROUP BY lcleID HAVING COUNT(1) > 1
) c
ON t.LcleID = c.LcleID
AND t.LcleTpeDscrptn = 'City'

SELECT DISTINCT l.lcleID,cnty.LcleAbbrvtn LocaleCounty,c.LcleAbbrvtn LocaleCity,s.LcleAbbrvtn LocaleState
INTO	#TaxLocaleStructure
FROM (SELECT DISTINCT LcleID FROM #LocaleStructure) l
LEFT OUTER JOIN #LocaleStructure s ON s.LcleID = l.LcleID AND s.LcleTpeDscrptn = 'States'
LEFT OUTER JOIN #LocaleStructure c ON c.LcleID = l.LcleID AND c.LcleTpeDscrptn = 'City'
LEFT OUTER JOIN #LocaleStructure cnty ON cnty.LcleID = l.LcleID AND cnty.LcleTpeDscrptn = 'County'

CREATE NONCLUSTERED INDEX [TLSLcle_Idx] ON #TaxLocaleStructure (LcleID)

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Transfer Price Interface'	,GETDATE(),'Complete','SQL','Sysuser',db_name(),'Stop','Gathering Tax Locale Structure'

/*
--REPLACED WITH PROCESSING TABLE
CREATE TABLE MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing(	[AcctDtlID] [int] NOT NULL,
												[AcctDtlSrceID] [int] NOT NULL,
												[AcctDtlTrnsctnTypID] [smallint] NOT NULL,
												[AcctDtlAccntngPrdID] [int] NULL,
												[AcctDtlSlsInvceHdrID] [int] NULL,
												[AcctDtlPrchseInvceHdrID] [int] NULL,
												[AcctDtlClseStts] [char](1) NOT NULL,
												[AcctDtlAcctCdeStts] [char](1) NOT NULL,
												[AcctDtlTxStts] [char](1) NOT NULL,
												[AcctDtlPrntID] [int] NOT NULL,
												[AcctDtlTrnsctnDte] [smalldatetime] NOT NULL,
												[InternalBAID] [int] NOT NULL,
												[ExternalBAID] [int] NOT NULL,
												[Volume] [decimal](19, 6) NOT NULL,
												[Value] [decimal](19, 6) NOT NULL,
												[CrrncyID] [int] NOT NULL,
												[ParentPrdctID] [int] NULL,
												[AcctDtlDlDtlDlHdrID] [int] NULL,
												[AcctDtlMvtHdrID] [int] NULL,
												[AcctDtlLcleID] [int] NOT NULL,
												[AcctDtlDestinationLcleID] [int] NULL,
												[PayableMatchingStatus] [char](1) NOT NULL,
												[CreatedDate] [smalldatetime] NOT NULL,
												[NetQuantity] [decimal](19, 6) NULL,
												[GrossQuantity] [decimal](19, 6) NULL,
												[Status] [int] NOT NULL,
												[AcctDtlSrceTble] [char](2) NOT NULL,
												[Reversed] [char](1) NULL,
												[SupplyDemand] [char](1) NULL
												PRIMARY KEY CLUSTERED 
												(
													[AcctDtlID] ASC
												)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
												) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [AcctDtlSrceID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlSrceID)
	CREATE NONCLUSTERED INDEX [AcctDtlAccntngPrdID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlAccntngPrdID)
	CREATE NONCLUSTERED INDEX [AcctDtlSlsInvceHdrID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlSlsInvceHdrID)
	CREATE NONCLUSTERED INDEX [AcctDtlPrchseInvceHdrID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlPrchseInvceHdrID)
	CREATE NONCLUSTERED INDEX [InternalBAID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (InternalBAID)
	CREATE NONCLUSTERED INDEX [AcctDtlDlDtlDlHdrID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlDlDtlDlHdrID)
	CREATE NONCLUSTERED INDEX [AcctDtlMvtHdrID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlMvtHdrID)
	CREATE NONCLUSTERED INDEX [AcctDtlLcleID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlLcleID)
	CREATE NONCLUSTERED INDEX [AcctDtlDestinationLcleID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlDestinationLcleID)
	CREATE NONCLUSTERED INDEX [AcctDtlSrceTble_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlSrceTble)
	CREATE NONCLUSTERED INDEX [AcctDtlTrnsctnTypID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlTrnsctnTypID)
	CREATE NONCLUSTERED INDEX [AcctDtlClseStts_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlClseStts)
	CREATE NONCLUSTERED INDEX [AcctDtlAcctCdeStts_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlAcctCdeStts)
	CREATE NONCLUSTERED INDEX [AcctDtlTxStts_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlTxStts)
	CREATE NONCLUSTERED INDEX [AcctDtlPrntID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlPrntID)
	CREATE NONCLUSTERED INDEX [AcctDtlTrnsctnDte_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlTrnsctnDte)
	CREATE NONCLUSTERED INDEX [ExternalBAID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (ExternalBAID)
	CREATE NONCLUSTERED INDEX [ParentPrdctID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (ParentPrdctID)
	CREATE NONCLUSTERED INDEX [PayableMatchingStatus_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (PayableMatchingStatus)
	CREATE NONCLUSTERED INDEX [CreatedDate_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (CreatedDate)
	*/
--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Transfer Price Interface'	,GETDATE(),'Start','SQL','Sysuser',db_name(),'Start','Gathering Tax Rates Structure'
	
	select * into #TaxRates from v_MTV_TaxRates

	CREATE NONCLUSTERED INDEX [TRAcctDtlId_Idx] ON #TaxRates (AcctDtlId)

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Transfer Price Interface'	,GETDATE(),'Stop','SQL','Sysuser',db_name(),'Complete','Gathering Tax Rates Structure'

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Transfer Price Interface'	,GETDATE(),'Start','SQL','Sysuser',db_name(),'Start','Gathering Eligable AccountDetails'

	-- Filter the Accounting transactions for all types that do not belong to the Transaction Group ExcludedFromPEGA
	Insert MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (AcctDtlID,
										 AcctDtlSrceID,
										 AcctDtlTrnsctnTypID,
										 AcctDtlAccntngPrdID,
										 AcctDtlSlsInvceHdrID,
										 AcctDtlPrchseInvceHdrID,
										 AcctDtlClseStts,
										 AcctDtlAcctCdeStts,
										 AcctDtlTxStts,
										 AcctDtlPrntID,
										 AcctDtlTrnsctnDte,
										 InternalBAID,
										 ExternalBAID,
										 Volume,
										 Value,
										 CrrncyID,
										 ParentPrdctID,
										 AcctDtlDlDtlDlHdrID,
										 AcctDtlMvtHdrID,
										 AcctDtlLcleID,
										 AcctDtlDestinationLcleID,
										 PayableMatchingStatus,
										 CreatedDate,
										 NetQuantity,
										 GrossQuantity,
										 Status,
										 AcctDtlSrceTble,
										 Reversed,
										 SupplyDemand,
										 PrvsnNme)
	select	AD.AcctDtlID,
			AD.AcctDtlSrceID,
			AD.AcctDtlTrnsctnTypID,
			AD.AcctDtlAccntngPrdID,
			AD.AcctDtlSlsInvceHdrID,
			AD.AcctDtlPrchseInvceHdrID,
			AD.AcctDtlClseStts,
			AD.AcctDtlAcctCdeStts,
			AD.AcctDtlTxStts,
			AD.AcctDtlPrntID,
			AD.AcctDtlTrnsctnDte,
			AD.InternalBAID,
			AD.ExternalBAID,
			AD.Volume,
			AD.Value,
			AD.CrrncyID,
			AD.ParentPrdctID,
			AD.AcctDtlDlDtlDlHdrID,
			AD.AcctDtlMvtHdrID,
			AD.AcctDtlLcleID,
			AD.AcctDtlDestinationLcleID,
			AD.PayableMatchingStatus,
			AD.CreatedDate,
			AD.NetQuantity,
			AD.GrossQuantity,
			AD.Status,
			AD.AcctDtlSrceTble,
			AD.Reversed,
			AD.SupplyDemand,
			CASE WHEN TDLPrvsn.PrvsnID IS NOT NULL THEN TDLPrvsn.PrvsnNme ELSE (CASE WHEN TTDPrvsn.PrvsnID IS NOT NULL THEN TTDPrvsn.PrvsnNme ELSE NULL END) END AS PrvsnNme
		from AccountDetail AD (NoLock)  
		left join TransactionDetailLog TDL
		on TDL.XDtlLgID = (CASE WHEN AD.AcctDtlSrceTble = 'X' THEN AD.AcctDtlSrceID ELSE NULL END)
		left join DealDetailProvision TDLDtlPrvsn 
		on TDL.XDtlLgXDtlDlDtlPrvsnID = TDLDtlPrvsn.DlDtlPrvsnID
		left join Prvsn TDLPrvsn
		on TDLDtlPrvsn.DlDtlPrvsnPrvsnID = TDLPrvsn.PrvsnID
		left join TimeTransactionDetailLog TTDL
		on TTDL.TmeXDtlLgID = (CASE WHEN AD.AcctDtlSrceTble = 'TT' THEN AD.AcctDtlSrceID ELSE NULL END)
		left join TimeTransactionDetail TTD
		on TTDL.TmeXDtlLgTmeXDtlIdnty = TTD.TmeXDtlID
		left join DealDetailProvision TTDDtlPrvsn
		on TTD.TmeXDtlDlDtlPrvsnID = TTDDtlPrvsn.DlDtlPrvsnID
		left join Prvsn TTDPrvsn
		on TTDDtlPrvsn.DlDtlPrvsnPrvsnID = TTDPrvsn.PrvsnID
		where AcctDtlTrnsctnTypID in
			(select XTpeGrpTrnsctnTypID from TransactionTypeGroup  (NoLock) where XTpeGrpXGrpID = 
				(select XGrpID from TransactionGroup  (NoLock) where XGrpName = 'ExcludeFromPega' and XGrpQlfr = 'IncludeForDataLake'))
		and AcctDtlAccntngPrdID >= @accountingPeriodID
		and CreatedDate >= @transactionsFromDate


--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Transfer Price Interface'	,GETDATE(),'Stop','SQL','Sysuser',db_name(),'Complete','Gathering Eligable AccountDetails'

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Transfer Price Interface'	,GETDATE(),'Start','SQL','Sysuser',db_name(),'Start','Insert Eligable AccountDetails'

	INSERT INTO dbo.MTVDataLakeTransferPriceStaging
	Select	TaxLocale.LocaleState as MVT_TitleTransfer
		,abs(cast(MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Volume as decimal(15,2))) As MVT_BilledUnits
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As MVT_BillOfLading
		,MovementDocument.MvtDcmntIntrnlDcmntNbr As MVT_InternalDocumentNumber
		,TransactionHeader.MovementDate As MVT_BillOfLadingDate
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrGrssQty else TaxTransactionHeader.XHdrGrssQty end as MVT_GrossUnits
		,case when (PayableHeader.CreatedDate is not null) then PayableHeader.CreatedDate else SalesInvoiceHeader.SlsInvceHdrCrtnDte end as MVT_InvoiceDate
		,case when (PayableHeader.InvoiceNumber is not null) then PayableHeader.InvoiceNumber else SalesInvoiceHeader.SlsInvceHdrNmbr end as MVT_PurchaseInvoiceNumber
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrQty else TaxTransactionHeader.XHdrQty end as MVT_NetUnits
		,ProductCode.GnrlCnfgMulti As MVT_ProductCode
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Volume != 0) then ABS(convert(DECIMAL(15,6), MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Value/MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Volume)) else 0 end as MVT_UnitPrice
				
		,'FEIN' as MVT_BuyerIdType
		,BuyerFEIN.GnrlCnfgMulti As MVT_BuyerIdCode
		,convert(int, Buyer.BAID) as MVT_BuyerCustomId
		,Buyer.Abbreviation As MVT_BuyerTradeName
		,Buyer.Name As MVT_BuyerLegalName
		,BuyerControlName.GnrlCnfgMulti As MVT_BuyerNameControl
		
		,'FEIN' As MVT_CarrierIdType
		,CarrierFEIN.GnrlCnfgMulti As MVT_CarrierIdCode
		,convert(int, Carrier.BAID) As MVT_CarrierCustomId
		,Carrier.Abbreviation As MVT_CarrierTradeName
		,Carrier.Name As MVT_CarrierLegalName
		,CarrierControlName.GnrlCnfgMulti As MVT_CarrierNameControl

		,'FEIN' as MVT_ConsignorIdType
		,ConsignorFEIN.GnrlCnfgMulti As MVT_ConsignorIdCode
		,convert(int, Consignor.BAID) As MVT_ConsignorCustomId
		,Consignor.Abbreviation As MVT_ConsignorTradeName
		,Consignor.Name As MVT_ConsignorLegalName
		,ConsignorControlName.GnrlCnfgMulti As MVT_ConsignorNameControl

		,'FEIN' as MVT_PositionHolderIdType
		,PositionHolderFEIN.GnrlCnfgMulti As MVT_PositionHolderIdCode
		,convert(int, PositionHolder.BAID) As MVT_PositionHolderCustomId
		,PositionHolder.Abbreviation As MVT_PositionHolderTradeName
		,PositionHolder.Name As MVT_PositionHolderLegalName
		,PositionHolderControlName.GnrlCnfgMulti As MVT_PositionHolderNameControl

		,'FEIN' as MVT_Exch_PositionHolderIdType
		,ExchPositionHolderFEIN.GnrlCnfgMulti As MVT_Exch_PositionHolderIdCode
		,convert(int, ExchPositionHolder.BAID) As MVT_Exch_PositionHolderCustomId
		,ExchPositionHolder.Abbreviation As MVT_Exch_PositionHolderTradeName
		,ExchPositionHolder.Name As MVT_Exch_PositionHolderLegalName
		,ExchPositionHolderControlName.GnrlCnfgMulti As MVT_Exch_PositionHolderNameControl

		,'FEIN' as MVT_SellerIdType
		,SellerFEIN.GnrlCnfgMulti As MVT_SellerIdCode
		,convert(int, Seller.BAID) As MVT_SellerCustomId
		,Seller.Abbreviation As MVT_SellerTradeName
		,Seller.Name As MVT_SellerLegalName
		,SellerControlName.GnrlCnfgMulti As MVT_SellerNameControl
		
		,OriginTerminalCode.GnrlCnfgMulti As MVT_OriginTerminalCode
		,convert(int, OriginLocale.LcleID) as MVT_OriginCustomId
		,OriginLocale.LcleAbbrvtn As MVT_OriginDescription
		,case when (OriginLocaleType.LcleTpeDscrptn = 'City') then OriginLocale.LcleAbbrvtn else OriginTaxLocale.LocaleCity end As MVT_OriginCity
		,case when (OriginLocaleType.LcleTpeDscrptn = 'States')then OriginLocale.LcleAbbrvtn else OriginTaxLocale.LocaleState end As MVT_OriginJurisdiction
		,OriginZipCode.GnrlCnfgMulti As MVT_OriginPostalCode
		,case when (OriginLocaleType.LcleTpeDscrptn = 'Country') then OriginLocale.LcleAbbrvtn else OriginCountryCode.GnrlCnfgMulti end As MVT_OriginCountryCode
		,case when (OriginLocaleType.LcleTpeDscrptn = 'County') then OriginLocale.LcleAbbrvtn else OriginTaxLocale.LocaleCounty end As MVT_OriginCounty
		,OriginCountyCode.GnrlCnfgMulti As MVT_OriginCountyCode
		,OriginLocaleType.LcleTpeDscrptn As MVT_OriginLocationType

		,DestinationTerminalCode.GnrlCnfgMulti As MVT_DestinationTerminalCode
		,convert(int, DestinationLocale.LcleID) as MVT_DestinationCustomId
		,DestinationLocale.LcleAbbrvtn As MVT_DestinationDescription
		,case when (DestinationSoldToShipTo.ShipToAddress is not null) then DestinationSoldToShipTo.ShipToAddress else DestinationAddress1.GnrlCnfgMulti end As MVT_DestinationAddress1
		,case when (DestinationSoldToShipTo.ShipToAddress1 is not null) then DestinationSoldToShipTo.ShipToAddress1 else DestinationAddress2.GnrlCnfgMulti end As MVT_DestinationAddress2
		,case when (DestinationLocaleType.LcleTpeDscrptn = 'City') then DestinationLocale.LcleAbbrvtn else DestinationTaxLocale.LocaleCity end As MVT_DestinationCity
		,case when (DestinationLocaleType.LcleTpeDscrptn = 'States') then DestinationLocale.LcleAbbrvtn else DestinationTaxLocale.LocaleState end As MVT_DestinationJurisdiction
		,case when (DestinationSoldToShipTo.ShipToZip is not null) then DestinationSoldToShipTo.ShipToZip else DestinationZipCode.GnrlCnfgMulti end As MVT_DestinationPostalCode
		,case when (DestinationLocaleType.LcleTpeDscrptn = 'Country') then DestinationLocale.LcleAbbrvtn else DestinationCountryCode.GnrlCnfgMulti end As MVT_DestinationCountryCode
		,case when (DestinationLocaleType.LcleTpeDscrptn = 'County') then DestinationLocale.LcleAbbrvtn else DestinationTaxLocale.LocaleCounty end As MVT_DestinationCounty
		,DestinationCountyCode.GnrlCnfgMulti As MVT_DestinationCountyCode
		,DestinationLocaleType.LcleTpeDscrptn As MVT_DestinationLocationType

		,'' As MVT_DivTerminalCode -- Will be empty
		,'' As MVT_DivDestination -- Will be empty
		,'' As MVT_DivJurisdiction -- Will be empty

		,'' As MVT_Alt_Document_Number -- Not External Batch ??
		,case when (DealHeader.DlHdrTyp = 20) then 'Y' else 'N' end as MVT_exchange_ind
		,MovementHeader.ExternalBatch As MVT_Pipeline_Batch_Number
		,Vehicle.VhcleNme As MVT_Vessel_Name
		,case when(Vehicle.VhcleTpe = 'V') then ISNULL(VehicleVessel.USCGID, VehicleVessel.ExternalSourceID) else ISNULL(VehicleBarge.USCGID,VehicleBarge.ExternalSourceID) end As MVT_Vessel_Number
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then cast(TransactionHeader.XHdrDte as date) else cast(TaxTransactionHeader.XHdrDte as date) end as MVT_Movement_Posted_Date

		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then DATEPART(year, TransactionHeader.XHdrDte) else DATEPART(year, TaxTransactionHeader.XHdrDte) end as MVT_Transaction_Year
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then DATEPART(month, TransactionHeader.XHdrDte) else DATEPART(month, TaxTransactionHeader.XHdrDte) end as MVT_Transaction_Month
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then convert(int, TransactionHeader.XHdrID) else convert(int, TaxTransactionHeader.XHdrID) end As MVT_Transaction_ID
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then convert(int, TransactionHeader.XHdrChldXHdrID) else convert(int, TaxTransactionHeader.XHdrChldXHdrID) end as MVT_Transaction_Child_Id

		,DATEPART(year, MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlTrnsctnDte) As MVT_Accounting_Year
		,DATEPART(month, MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlTrnsctnDte) As MVT_Accounting_Month
		
		,TransactionDetail.XDtlID As MVT_BOL_Item_Number
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end as MVT_RD_Type
		,DealType.Description As MVT_Deal_Type
		,CommoditySubGroup.Name As MVT_Tax_Commodity_Code
		,MovementHeaderType.Name As MVT_Movement_Type
		,DealHeader.DlHdrIntrnlNbr As MVT_Deal
		,case when (TaxRALocaleType.LcleTpeID = 109) then 'Yes' else 'No' end as MVT_Equity_Terminal -- check to see if the Location type is TERMINAL-EQUITY
		,case when (DealType.Description like '%3rd Party%') then 'Yes' else 'No' end as MVT_Is_Third_Party

		,PayableHeader.InvoiceNumber As MVT_Purchase_Order_Number
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlID As MVT_Account_DetailID
		,ExternalBA.BANme As MVT_ExternalBA
		,SAPSoldTo.SoldTo As MVT_GSAP_CustomerNumber
		,SAPSoldTo.VendorNumber As MVT_GSAP_VendorNumber
		,ExtBASCAC.GnrlCnfgMulti As MVT_SCAC
		,ProductMaterialCode.GnrlCnfgMulti As MVT_SAP_Material_Code
		,case when (VehicleVessel.USCGID is not null OR VehicleBarge.USCGID is not null) then 'No' else 'Yes' end as MVT_Foreign_Vessel_Identifier
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'C') then 'Complete' when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X' AND TransactionHeader.XHdrStat = 'R') then 'Reversed' 
		 when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'C') then 'Complete' when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble != 'X' AND TaxTransactionHeader.XHdrStat = 'R') then 'Reversed' end as MVT_Transaction_Status
		,ProductGrade.GnrlCnfgMulti As MVT_Product_Grade
		,convert(int, MovementHeader.MvtHdrLcleID) as MVT_Location_ID
		,Product.PrdctNme As MVT_Product_Name
		,TransactionType.TrnsctnTypDesc As MVT_Transaction_Type
		,AccountingReasonCode.Description As MVT_Reason_Code
		,case when (TransactionType.TrnsctnTypDesc = 'Purchase-Crude') then ProductCrudeType.GnrlCnfgMulti else "" end as MVT_Crude_Type
		
		------Accounting Fields
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then convert(int, TransactionHeader.XHdrID) else convert(int, TaxTransactionHeader.XHdrID) end as Acct_MVT_Transaction_Unique_Identifier
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then convert(int, TransactionHeader.XHdrChldXHdrID) else convert(int, TaxTransactionHeader.XHdrChldXHdrID) end as Acct_MVT_Transaction_Child_Id
		,convert(int, MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlID) As Acct_DtlID
		,ExternalBA.BANme As Acct_ExtBA
		,DealHeader.DlHdrIntrnlNbr As Acct_Deal
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlTrnsctnDte As Acct_TktDate
		,MovementDocument.MvtDcmntExtrnlDcmntNbr As Acct_BOL
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionHeader.MovementDate else TaxTransactionHeader.MovementDate end As Acct_BOL_Date

		,AccountDetailLocation.LcleAbbrvtn As Acct_AcctDtlLoc
		,Product.PrdctNme As Acct_Product
		,ProductCode.GnrlCnfgMulti As Acct_ProductCode
		,CommoditySubGroup.Name As Acct_Tax_Commodity
		,TransactionType.TrnsctnTypDesc As Acct_TransactionType
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Volume = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.NetQuantity) then 'N' else 'G' end as Acct_NG
		,convert(DECIMAL(20, 10), #TaxRates.TaxRate) as Acct_Rate
		,convert(DECIMAL(15,3), MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Value) As Acct_Tran_Amt

		,OriginLocale.LcleAbbrvtn As Acct_Origin
		,DestinationLocale.LcleAbbrvtn As Acct_Destination
		,SalesInvoiceHeader.SlsInvceHdrNmbr as Acct_SlsInv
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.NetQuantity as Acct_Net
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.GrossQuantity as Acct_Gross
		,convert(varchar(20), AccountingPeriod.AccntngPrdPrd) + "/" + AccountingPeriod.AccntngPrdYr as Acct_AcctPeriod
		,Currency.CrrncyNme as Acct_Curr
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Reversed as Acct_Rev
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlTxStts = 'R') then 'Evaluated' else 'Not Evaluated' end as Acct_Taxed
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble as Acct_Source
		,InternalBA.BANme as Acct_IntBA
		,TaxRuleSet.InvoicingDescription As Acct_Invoice_Description
		,Term.TrmVrbge as Acct_Billing_Term
		,SalesInvoiceHeader.SlsInvceHdrNmbr as Acct_SalesInvoiceNumber
		,PayableHeader.InvoiceNumber as Acct_PurchaseInvoiceNumber
		,cast(SalesInvoiceHeader.SlsInvceHdrCrtnDte as date) as Acct_InvoiceDate
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.PayableMatchingStatus as Acct_Payable_Matching_Status
		,MovementHeaderType.Name as Acct_MovementType
		,DealType.Description as Acct_DealType
		,OriginTaxLocale.LocaleState as Acct_OriginState
		,DestinationTaxLocale.LocaleState as Acct_DestinationState
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlAcctCdeStts as Acct_AcctCodeStatus
		,OriginTaxLocale.LocaleCity as Acct_OriginCity
		,OriginTaxLocale.LocaleCounty as Acct_OriginCounty
		,DestinationTaxLocale.LocaleCity as Acct_DestinationCity
		,DestinationTaxLocale.LocaleCounty as Acct_DestinationCounty
		,TaxLocale.LocaleState as Acct_Title_Transfer
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Volume as Acct_BilledGallons
		,case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrTyp else TaxTransactionHeader.XHdrTyp end as Acct_R_D
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.Reversed as Acct_Reversed
		,convert(varchar(50), DATEPART(month, TransactionHeader.MovementDate)) + "/" + convert(varchar(50),DATEPART(year, TransactionHeader.MovementDate)) as Acct_Movement_Year_Month
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlTrnsctnDte as Acct_Movement_Posting_Date
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.CreatedDate as Acct_GL_Posting_Date
		,convert(int, Buyer.BAID) as Acct_Buyer_CustomID
		,convert(int, Seller.BAID) as Acct_Seller_CustomID
		,ExternalBA.Name as Acct_External_BA
		,convert(int, ExternalBA.BAID) as Acct_External_BAID
		,Buyer.Name as Acct_Buyer_LegalName
		,BuyerFEIN.GnrlCnfgMulti as Acct_Buyer_ID
		,Seller.Name as Acct_Seller_LegalName
		,SellerFEIN.GnrlCnfgMulti as Acct_Seller_ID
		,TransactionDetail.XDtlLstInChn as MVT_Last_In_Chain
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlTxStts as Acct_Detail_Status
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlPrntID as Account_Detail_ParentID
		,Users.UserDBMnkr as MVT_Changed_By
		,TaxLocale.LocaleCounty as MVT_TitleTransferCounty
		,TaxLocale.LocaleCity as MVT_TitleTransferCity
		,(select stuff((
			        select '| ' + p.PrdctNme
			        from Chemical t  (NoLock) 
					inner join Product p (NoLock) on t.ChmclChdPrdctID = p.PrdctID
			        where t.ChmclParPrdctID = Chemical.ChmclParPrdctID
			        order by t.ChmclParPrdctID
			        for xml path('')
			    ),1,1,'') as Chemical
			from Chemical  (NoLock) 
			where ChmclParPrdctID = Product.PrdctID
			group by ChmclParPrdctID) As Chemicals
			,(select stuff((
			        select '| ' + gc.GnrlCnfgMulti
			        from Chemical t  (NoLock) 
					inner join GeneralConfiguration gc (NoLock) on
					    gc.GnrlCnfgHdrID = t.ChmclChdPrdctID
						and gc.GnrlCnfgTblNme = 'Product'
						and gc.GnrlCnfgQlfr = 'FTAProductCode'
			        where t.ChmclParPrdctID = Chemical.ChmclParPrdctID
			        order by t.ChmclParPrdctID
			        for xml path('')
			    ),1,1,'') as Chemical
			from Chemical  (NoLock) 
			where ChmclParPrdctID = Product.PrdctID
			group by ChmclParPrdctID) As ChemicalFTACode
			,(select stuff((
			        select '| ' + csg.Name
			        from Chemical t  (NoLock) 
					inner join Product p (NoLock) on t.ChmclChdPrdctID = p.PrdctID
					inner join CommoditySubGroup csg (NoLock) on csg.CmmdtySbGrpID = p.TaxCmmdtySbGrpID
			        where t.ChmclParPrdctID = Chemical.ChmclParPrdctID
			        order by t.ChmclParPrdctID
			        for xml path('')
			    ),1,1,'') as Chemical
			from Chemical  (NoLock) 
			where ChmclParPrdctID = Product.PrdctID
			group by ChmclParPrdctID)  As ChemicalTaxCommodity
		,case when (TransactionType.TrnsctnTypDesc = 'Purchase-Crude') then ProductCrudeType.GnrlCnfgMulti else "" end as Acct_Crude_Type
		,getdate() as CreatedDate
		,@userId as UserID
		,'N' as ProcessedStatus
		,NULL as PublishedDate
		,0 as InterfaceID
		, 'A' as RecordType
		,MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.PrvsnNme 
	From	MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing (NoLock)
		Left Join [TransactionDetailLog] (NoLock) On
			MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceID = [TransactionDetailLog].XDtlLgID And MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X'
		Left Join [TransactionHeader] (NoLock) On
			TransactionDetailLog.XDtlLgXDtlXHdrID = TransactionHeader.XHdrID
		Left Join TaxDetailLog (NoLock) On
			MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceID = [TaxDetailLog].TxDtlLgID And MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'T'
		Left Join TaxDetail (NoLock) On
			TaxDetail.TxDtlID = TaxDetailLog.TxDtlLgTxDtlID
		Left Join [TransactionHeader] As TaxTransactionHeader (NoLock) On
			TaxTransactionHeader.XHdrID = case	when (TaxDetail.TxDtlSrceTble = 'X') then TaxDetail.txdtlsrceid
												else TaxDetail.TxDtlXhdrID end
		Left Join [PlannedTransfer] (NoLock) On
			[PlannedTransfer].[PlnndTrnsfrID] = case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrPlnndTrnsfrID
													 else TaxTransactionHeader.XHdrPlnndTrnsfrID end
		Left Join DealHeader (NoLock) On
			[PlannedTransfer].[PlnndTrnsfrObDlDtlDlHdrID] = [DealHeader].[DlHdrID]
		Left Join [MovementHeader] (NoLock) On
			MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlMvtHdrID = [MovementHeader].[MvtHdrID]
		Left join [DealDetail] (NoLock) On
				DealDetail.DealDetailID = case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionHeader.DealDetailID
													else TaxTransactionHeader.DealDetailID end
		Left Join [BusinessAssociate] As Buyer (NoLock) On
				Buyer.BAID = Case	When MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.SupplyDemand = 'R' Then  MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.InternalBAID
									When MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.SupplyDemand = 'D' Then  MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.ExternalBAID 
							Else	MovementHeader.MvtHdrSrchBAID 	End
		Left Join GeneralConfiguration As BuyerFEIN (NoLock) On
				BuyerFEIN.GnrlCnfgQlfr = 'FederalTaxID'
				And BuyerFEIN.GnrlCnfgTblNme = 'BusinessAssociate'
				And BuyerFEIN.GnrlCnfgHdrID = Buyer.BAID
		Left Join [GeneralConfiguration] As BuyerControlName (NoLock) On
				BuyerControlName.[GnrlCnfgQlfr] = 'SCAC'
				And BuyerControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And BuyerControlName.[GnrlCnfgHdrID] = Buyer.BAID
							
		Left Join [GeneralConfiguration] As CarrierFEIN (NoLock) On
				[CarrierFEIN].[GnrlCnfgQlfr] = 'FederalTaxID'
				And [CarrierFEIN].[GnrlCnfgTblNme] = 'BusinessAssociate'
				And [CarrierFEIN].[GnrlCnfgHdrID] = [MovementHeader].[MvtHdrCrrrBAID]
		Left Join [GeneralConfiguration] As CarrierControlName (NoLock) On
				CarrierControlName.[GnrlCnfgQlfr] = 'SCAC'
				And CarrierControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And CarrierControlName.[GnrlCnfgHdrID] = [MovementHeader].[MvtHdrCrrrBAID]
		Left Join [BusinessAssociate] As Carrier (NoLock) On
				Carrier.BAID = [MovementHeader].[MvtHdrCrrrBAID]
				
		Left Join [BusinessAssociate] As PositionHolder (NoLock) On
				PositionHolder.BAID = Case	When DealHeader.DlHdrTyp = 171 Or DealHeader.DlHdrTyp = 173 Then DealHeader.DlHdrExtrnlBAID 
											Else DealHeader.DlHdrIntrnlBAID End
		Left Join [GeneralConfiguration] As PositionHolderFEIN (NoLock) On
				PositionHolderFEIN.[GnrlCnfgQlfr] = 'FederalTaxID'
				And PositionHolderFEIN.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And PositionHolderFEIN.[GnrlCnfgHdrID] = PositionHolder.BAID
		Left Join [GeneralConfiguration] As PositionHolderControlName (NoLock) On
				PositionHolderControlName.[GnrlCnfgQlfr] = 'SCAC'
				And PositionHolderControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And PositionHolderControlName.[GnrlCnfgHdrID] = PositionHolder.BAID

		Left Join BusinessAssociate As ExchPositionHolder (NoLock) On
				ExchPositionHolder.BAID = Case When DealHeader.DlHdrTyp = 20 Then DealHeader.DlHdrExtrnlBAID Else 0 End
		Left Join [GeneralConfiguration] As ExchPositionHolderFEIN (NoLock) On
				ExchPositionHolderFEIN.[GnrlCnfgQlfr] = 'FederalTaxID'
				And ExchPositionHolderFEIN.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And ExchPositionHolderFEIN.[GnrlCnfgHdrID] = ExchPositionHolder.BAID
		Left Join [GeneralConfiguration] As ExchPositionHolderControlName (NoLock) On
				ExchPositionHolderControlName.[GnrlCnfgQlfr] = 'SCAC'
				And ExchPositionHolderControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And ExchPositionHolderControlName.[GnrlCnfgHdrID] = ExchPositionHolder.BAID
				
		Left Join [BusinessAssociate] As Seller (NoLock) On
				Seller.BAID = Case	When MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.SupplyDemand = 'D' Then  MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.InternalBAID
									When MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.SupplyDemand = 'R' Then  MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.ExternalBAID 
							  Else MovementHeader.MvtHdrSrchBAID End
		Left Join [GeneralConfiguration] As SellerFEIN (NoLock) On
				SellerFEIN.[GnrlCnfgQlfr] = 'FederalTaxID'
				And SellerFEIN.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And SellerFEIN.[GnrlCnfgHdrID] = Seller.BAID
		Left Join [GeneralConfiguration] As SellerControlName (NoLock) On
				SellerControlName.[GnrlCnfgQlfr] = 'SCAC'
				And SellerControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And SellerControlName.[GnrlCnfgHdrID] = Seller.BAID
		
		Left Join BusinessAssociate As Consignor (NoLock) On
				   Consignor.BAID = Case When DealDetail.DlDtlLcleID = Isnull(IsNull(MovementHeader.MvtHdrOrgnLcleID, MovementHeader.MvtHdrLcleID),0)	Then Buyer.BAID
										 When DealDetail.DlDtlLcleID = Isnull(IsNull(TransactionHeader.DestinationLcleID,TransactionHeader.MovementLcleID),0)	Then Seller.BAID
									Else Buyer.BAID  End
		Left Join [GeneralConfiguration] As ConsignorFEIN (NoLock) On
				[ConsignorFEIN].[GnrlCnfgQlfr] = 'FederalTaxID'
				And [ConsignorFEIN].[GnrlCnfgTblNme] = 'BusinessAssociate'
				And [ConsignorFEIN].[GnrlCnfgHdrID] = Consignor.BAID
		Left Join [GeneralConfiguration] As ConsignorControlName (NoLock) On
				ConsignorControlName.[GnrlCnfgQlfr] = 'SCAC'
				And ConsignorControlName.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And ConsignorControlName.[GnrlCnfgHdrID] = Consignor.BAID
		
		--IsNull(MovementHeader.MvtHdrLcleID, MovementHeader.MvtHdrOrgnLcleID)
		Left Join Locale As OriginLocale (NoLock) On
				MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlLcleID = OriginLocale.LcleID
		Left Join LocaleType As OriginLocaleType (NoLock) On
				OriginLocale.LcleTpeID = OriginLocaleType.LcleTpeID
		Left Join #TaxLocaleStructure As OriginTaxLocale (NoLock) On
				OriginTaxLocale.LcleID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlLcleID
		Left Join GeneralConfiguration As OriginTerminalCode (NoLock) On
				OriginTerminalCode.GnrlCnfgQlfr = 'TCN'
				And OriginTerminalCode.GnrlCnfgTblNme = 'Locale'
				And OriginTerminalCode.GnrlCnfgHdrID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlLcleID
		Left Join [GeneralConfiguration] As OriginCountyCode (NoLock) On
				OriginCountyCode.[GnrlCnfgQlfr] = 'USFedCountyCode'
				And OriginCountyCode.[GnrlCnfgTblNme] = 'Locale'
				And OriginCountyCode.[GnrlCnfgHdrID] = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlLcleID
		Left Join [GeneralConfiguration] As OriginCountryCode (NoLock) On
				OriginCountryCode.[GnrlCnfgQlfr] = 'CountryCode'
				And OriginCountryCode.[GnrlCnfgTblNme] = 'Locale'
				And OriginCountryCode.[GnrlCnfgHdrID] =  MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlLcleID

		Left Join GeneralConfiguration As SAPMvtSoldToNumber (NoLock) On
				SAPMvtSoldToNumber.GnrlCnfgQlfr = 'SAPMvtSoldToNumber'
				And SAPMvtSoldToNumber.GnrlCnfgTblNme = 'MovementHeader'
				And SAPMvtSoldToNumber.GnrlCnfgHdrID = MovementHeader.MvtHdrPrdctID
				And SAPMvtSoldToNumber.GnrlCnfgMulti != 'X'
		Left Join MTVSAPBASoldTo As SAPBASoldTo (NoLock) On
				SAPBASoldTo.SoldTo = SAPMvtSoldToNumber.GnrlCnfgMulti
		-- Get the Destination Locale information from the Sold To Ship To Maintenance
		Left Join MTVSAPSoldToShipTo As DestinationSoldToShipTo (NoLock) On
				DestinationSoldToShipTo.MTVSAPBASoldToID = SAPBASoldTo.ID
				And DestinationSoldToShipTo.RALocaleID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID

		Left Join [GeneralConfiguration] As OriginZipCode (NoLock) On
				OriginZipCode.[GnrlCnfgQlfr] = 'PostalCode'
				And OriginZipCode.[GnrlCnfgTblNme] = 'Locale'
				And OriginZipCode.[GnrlCnfgHdrID] =  MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlLcleID

		Left Join Locale As DestinationLocale (NoLock) On
				MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID = DestinationLocale.LcleID
		Left Join LocaleType As DestinationLocaleType (NoLock) On
				DestinationLocale.LcleTpeID = DestinationLocaleType.LcleTpeID
		Left Join #TaxLocaleStructure As DestinationTaxLocale (NoLock) On
				DestinationTaxLocale.LcleID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationTerminalCode (NoLock) On
				DestinationTerminalCode.[GnrlCnfgQlfr] = 'TCN'
				And DestinationTerminalCode.[GnrlCnfgTblNme] = 'Locale'
				And DestinationTerminalCode.[GnrlCnfgHdrID] = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID

		Left Join GeneralConfiguration As DestinationAddress1 (NoLock) On
				DestinationAddress1.[GnrlCnfgQlfr] = 'AddrLine1'
				And DestinationAddress1.[GnrlCnfgTblNme] = 'Locale'
				And DestinationAddress1.[GnrlCnfgHdrID] = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationAddress2 (NoLock) On
				DestinationAddress2.[GnrlCnfgQlfr] = 'AddrLine2'
				And DestinationAddress2.[GnrlCnfgTblNme] = 'Locale'
				And DestinationAddress2.[GnrlCnfgHdrID] = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationCountyCode (NoLock) On
				DestinationCountyCode.[GnrlCnfgQlfr] = 'USFedCountyCode'
				And DestinationCountyCode.[GnrlCnfgTblNme] = 'Locale'
				And DestinationCountyCode.[GnrlCnfgHdrID] = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationCountryCode (NoLock) On
				DestinationCountryCode.[GnrlCnfgQlfr] = 'CountryCode'
				And DestinationCountryCode.[GnrlCnfgTblNme] = 'Locale'
				And DestinationCountryCode.[GnrlCnfgHdrID] = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID
		Left Join [GeneralConfiguration] As DestinationZipCode (NoLock) On
				DestinationZipCode.[GnrlCnfgQlfr] = 'PostalCode'
				And DestinationZipCode.[GnrlCnfgTblNme] = 'Locale'
				And DestinationZipCode.[GnrlCnfgHdrID] = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDestinationLcleID

		Left Join [DealType] (NoLock) On
				DealType.DlTypID = DealHeader.DlHdrTyp
		Left Join [Product] (NoLock) On
				MovementHeader.MvtHdrPrdctID = Product.PrdctID
		Left Join [GeneralConfiguration] As ProductCode (NoLock) On
				[ProductCode].[GnrlCnfgQlfr] = 'FTAProductCode'
				And [ProductCode].[GnrlCnfgTblNme] = 'Product'
				And [ProductCode].[GnrlCnfgHdrID] = [MovementHeader].[MvtHdrPrdctID]
		Left Join [GeneralConfiguration] As ProductMaterialCode (NoLock) On
				ProductMaterialCode.GnrlCnfgQlfr = 'SAPMaterialCode'
				And ProductMaterialCode.GnrlCnfgTblNme = 'Product'
				And ProductMaterialCode.GnrlCnfgHdrID = [MovementHeader].[MvtHdrPrdctID]
		Left Join [GeneralConfiguration] As ProductGrade (NoLock) On
				ProductGrade.GnrlCnfgQlfr = 'ProductGrade'
				And ProductGrade.GnrlCnfgTblNme = 'Product'
				And ProductGrade.GnrlCnfgHdrID = [MovementHeader].[MvtHdrPrdctID]
		Left Join [GeneralConfiguration] As ProductCrudeType (NoLock) On
				ProductCrudeType.GnrlCnfgQlfr = 'CrudeType'
				And ProductCrudeType.GnrlCnfgTblNme = 'Product'
				And ProductCrudeType.GnrlCnfgHdrID = [MovementHeader].[MvtHdrPrdctID]
		Left Join CommoditySubGroup (NoLock) On
				CommoditySubGroup.CmmdtySbGrpID = Product.TaxCmmdtySbGrpID
		Left Join MovementHeaderType (NoLock) On
				MovementHeader.MvtHdrTyp = MovementHeaderType.MvtHdrTyp
				
-- Start the joins with the Accounting tables this will result in pulling all the Accounting txns for each Transaction Header ... Transaction Detail (all provisions) 1... 1. Account Detail
		Left Join TransactionDetail (NoLock) On
				TransactionDetail.TransactionDetailID = case 
															when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionDetailLog.XDtlLgXDtlID
															else TaxDetailLog.TxDtlLgTxDtlID end
		Left Join SalesInvoiceHeader (NoLock) On	
				SalesInvoiceHeader.SlsInvceHdrID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSlsInvceHdrID
		Left Join PayableHeader (NoLock) On
				PayableHeader.PybleHdrID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlPrchseInvceHdrID
		Left Join TransactionType (NoLock) On
				MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlTrnsctnTypID = TransactionType.TrnsctnTypID
		Left Join Locale As AccountDetailLocation (NoLock) On
				AccountDetailLocation.LcleID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlLcleID
		Left Join AccountingPeriod (NoLock) On
				MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlAccntngPrdID = AccountingPeriod.AccntngPrdID
		Left Join Currency (NoLock) On
				Currency.CrrncyID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.CrrncyID
		Left Join BusinessAssociate As ExternalBA (NoLock) On
				MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.ExternalBAID = ExternalBA.BAID
		Left Join GeneralConfiguration As ExtBASAPCustomerNumber (NoLock) On
				ExtBASAPCustomerNumber.GnrlCnfgQlfr = 'SAPSoldTo'
				And ExtBASAPCustomerNumber.GnrlCnfgTblNme = 'DealHeader'
				And ExtBASAPCustomerNumber.GnrlCnfgHdrID = MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlDlDtlDlHdrID
				And ExtBASAPCustomerNumber.GnrlCnfgMulti != 'X'
		Left Join MTVSAPBASoldTo As SAPSoldTo (NoLock) On
				SAPSoldTo.ID = ExtBASAPCustomerNumber.GnrlCnfgMulti
		Left Join [GeneralConfiguration] As ExtBASCAC (NoLock) On
				ExtBASCAC.[GnrlCnfgQlfr] = 'SCAC'
				And ExtBASCAC.[GnrlCnfgTblNme] = 'BusinessAssociate'
				And ExtBASCAC.[GnrlCnfgHdrID] = ExternalBA.BAID
		Left Join BusinessAssociate As InternalBA (NoLock) On
				MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.InternalBAID = InternalBA.BAID
		Left Join #TaxLocaleStructure As TaxLocale (NoLock) On
				TaxLocale.LcleID = MovementHeader.MvtHdrLcleID
		Left Join Locale As TaxRALocale (NoLock) On
				TaxRALocale.LcleID = TaxLocale.LcleID
		Left Join LocaleType As TaxRALocaleType (NoLock) On
				TaxRALocaleType.LcleTpeID = TaxRALocale.LcleTpeID
		Left Join PlannedMovement (NoLock) On
			PlannedTransfer.PlnndTrnsfrPlnndStPlnndMvtID = PlannedMovement.PlnndMvtID
		Left Join Vehicle (NoLock) On
				ISNULL(MovementHeader.MvtHdrVhcleID, PlannedMovement.VehicleID) = Vehicle.VhcleID
		Left Join VehicleVessel (NoLock) On
				Vehicle.VhcleID = VehicleVessel.VhcleVsslVhcleID
		Left Join VehicleBarge (NoLock) On
				Vehicle.VhcleID = VehicleBarge.VhcleBrgeVhcleID
		Left Join Term (NoLock) On
				Term.TrmID = SalesInvoiceHeader.SlsInvceHdrTrmID

		Left Join #TaxRates (NoLock) On
				MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlID = #TaxRates.AcctDtlID
		Left Join Users (NoLock) On
				MovementHeader.UserID = Users.UserID

		Left Join MovementHeader As DocMovementHeader (NoLock) On
				DocMovementHeader.MvtHdrID = case when (MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.AcctDtlSrceTble = 'X') then TransactionHeader.XHdrMvtDtlMvtHdrID 
													else TaxTransactionHeader.XHdrMvtDtlMvtHdrID end
		Left Join MovementDocument (NoLock) On
				DocMovementHeader.MvtHdrMvtDcmntID = MovementDocument.[MvtDcmntID]
		Left Join TaxRuleSet (NoLock) on TaxRuleSet.TxRleStID = TaxDetail.TxRleStID
		Left Join (select th.XHdrID, MAX(InventoryReconcile.InvntryRcncleRsnCde) InvntryRcncleRsnCde
					from TransactionHeader TH (NoLock) 
					Left Join InventoryReconcile (NoLock) 
					ON InvntryRcncleSrceID = XHdrID
					and InvntryRcncleSrceTble = 'X'
					GROUP BY th.XHdrID
					) InventoryReconcileList
					ON InventoryReconcileList.XHdrID = TransactionHeader.XHdrID
		Left Join AccountingReasonCode (NoLock) On
				InventoryReconcileList.InvntryRcncleRsnCde = Code

--Log
INSERT	eventlog (Source,EventDateTime,EventType,Tier,SecurityIdentity,MachineName,Message,Data)
SELECT	'Transfer Price Interface'	,GETDATE(),'Stop','SQL','Sysuser',db_name(),'Complete','Inserting Eligable AccountDetails'


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF  OBJECT_ID(N'[dbo].[MTV_IncrementalTransferPrices]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_IncrementalTransferPrices.sql'
			PRINT '<<< ALTERED Procedure MTV_IncrementalTransferPrices >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on Procedure MTV_IncrementalTransferPrices >>>'
	  END

--End of Script: sp_MTV_IncrementalTransferPrices.sql
