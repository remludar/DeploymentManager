/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MPC_Statement_Detail_Mtv_TA WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MPC_Statement_Detail_Mtv_TA]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MPC_Statement_Detail_Mtv_TA.sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_Detail_Mtv_TA]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MPC_Statement_Detail_Mtv_TA] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>'
	  END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--sp_mpc_statement_detail_mtv_ta 24679
--select * from salesinvoicestatement where SlsInvceSttmntXHdrID = 162326

/*--------------------------------------------------------------------------------------------------
-- rules:   get all xhdrids that are in salesinvoicestatement 
--          get all accountdetails that are tied to that xhdrid
--          only show the qty once per xhdrid
--          if it is reversed ( value = 0 ) don't show it
--          if you don't have any accountdetails you must pull the transactionheader quantity 
-- Notes:   if they close the accountingperiod with incomplete transactiondetails ( not priced yet)
--          you will show the item in that accounting period with a 0 value - if you were to
--          try to balance with search accounting transactions for the following period you would
--          be off that period as well because those values would be in that accountingperiod
-----------------------------------------------------------------------------------------------------          
*/

ALTER Procedure [dbo].[sp_MPC_Statement_Detail_Mtv_TA] @i_SalesInvoiceHeaderID Int
As
Set NoCount ON  

set Quoted_Identifier OFF  

declare @yyyymm varchar(80)
declare @i_AccntngPrdID int 
declare @dlhdrid int


Select @i_SalesInvoiceHeaderID = ISNULL(@i_SalesInvoiceHeaderID, -1)  

select @dlhdrid = ( Select top 1 SttmntBlnceDlHdrID From StatementBalance where SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID )

Select @yyyymm =  ( select top 1 datepart(yyyy,AccntngPrdBgnDte) + '-' + case when datepart(mm,AccntngPrdBgnDte) < 10 then '0' else '' end + convert(varchar,datepart(mm,AccntngPrdBgnDte))
                      From StatementBalance (nolock) inner join AccountingPeriod (Nolock) on AccountingPeriod.AccntngPrdID = SttmntBlnceAccntngPrdID
					   where SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID
					   )

select @i_AccntngPrdID = ( Select top 1 AccountingPeriod.AccntngPrdID From StatementBalance (nolock) inner join AccountingPeriod (Nolock) on AccountingPeriod.AccntngPrdID = SttmntBlnceAccntngPrdID
					   where SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID
					   )

Select TT.TrnsctnTypID, tt.TrnsctnTypDesc, tg.XGrpName
into #txnTypes
From TransactionType TT
	 inner join TransactionTypeGroup TTG on TTG.XTpeGrpTrnsctnTypID = tt.TrnsctnTypID
     inner join TransactionGroup TG on TG.XgrpID = TTG.XTpeGrpXGrpID
	 inner join DynamicListBox on DynLstBxTyp = convert(char,TG.XGrpID )
                and DynLstBxQlfr = 'TA Stmt Txn Groups'

Create Table #slsinvcedtl  
 (
 ID INT IDENTITY(1,1),
 DtlSlsInvceHdrID  int   NULL,  
 XHdrID     int   NULL,  
 DtlDlHdrID    int   NULL,  
 DtlDlHdrExtrnlNbr  varchar(20) NULL,  
 DtlDlHdrIntrnlNbr  varchar(20) NULL,  
 DtlDlHdrExtrnlCntctID int   NULL,  
 DtlPrntPrdctID   int   NULL,  
 Product     varchar(20) NULL,  
 DtlChldPrdctID   int   NULL,  
 Chemical    varchar(20) NULL,  
 DtlOrgnLcleID   int   NULL,  
 DtlDstntnLcleID   int   NULL,  
 DtlFOBLcleID   int   NULL,  
 DtlTrnsctnVle   money  NULL,  
 DtlPrUntVle    float  NULL,  
 DtlTrnsctnQntty   float  NULL,  
 DtlTrnsctnTypID   int   NULL,  
 DtlMvtDcmntExtrnlDcmnt varchar(80) NULL,  
 DtlMvtHdrDte   datetime NULL,  
 DtlMvtHdrTyp   char(2)  NULL,  
 DtlMvtHdrTypNme   varchar(50) NULL,  
 DtlSpplyDmnd   char(1)  NULL,  
 DtlCrrncyID    int   NULL,  
 DtlStrtngBlnce   float  NULL,  
 DtlMvtHdrVhcleID  int   NULL,  
 SttmntEndngBlnce  float  NULL,  
 TrnsctnTypCtgry   char(1)  NULL,  
 AccntngPrdID   Int   NULL,  
 ProductOrder   int   NULL,  
 SttmntBlnceTotal  float  NULL,  
 DlDtlDsplyUOMID   int   NULL,  
 UOMAbbv     varchar(10) NULL,  
 LeaseName    varchar(80) NULL,  
 MvtDcmntIssuedBy  int   NULL,  
 HdrID     int   NULL,  
 HdrPrntID    int   NULL,  
 OriginLcleNme   varchar(50) NULL,  
 DestinationLcleNme  varchar(50) NULL,  
 FOBLcleNme    varchar(50) NULL,  
 ContractContact   varchar(50) NULL,  
 DeliveryTerm   varchar(50) NULL,  
 IsAdjustment   char(1)  NULL,
 RemitToInstructions varchar(2100) NULL,
 TransactionDescription varchar(80) NULL,
 XDtlStat  char(1)  NULL,
 IsTopLevel BIT,
 ProvisionQuantity float null
 )  
  
--------------------------------------------------------------------------
-- time transactions
--------------------------------------------------------------------------
Insert #slsinvcedtl  
 (  
 DtlSlsInvceHdrID,  
 XHdrID,  
 DtlDlHdrID,  
 DtlDlHdrExtrnlNbr,  
 DtlDlHdrIntrnlNbr,  
 DtlDlHdrExtrnlCntctID,  
 DtlPrntPrdctID,  
 Product,
 DtlChldPrdctID,  
 DtlOrgnLcleID,  
 DtlDstntnLcleID,  
 DtlFOBLcleID,  
 DtlTrnsctnVle,  
 DtlPrUntVle,  
 DtlTrnsctnQntty,  
 DtlTrnsctnTypID,  
 DtlMvtDcmntExtrnlDcmnt,  
 DtlMvtHdrDte,  
 DtlMvtHdrTyp,  
 DtlMvtHdrTypNme,  
 DtlSpplyDmnd,  
 DtlCrrncyID,  
 DtlStrtngBlnce,  
 DtlMvtHdrVhcleID,  
 SttmntEndngBlnce,  
 TrnsctnTypCtgry,  
 AccntngPrdID,  
 ProductOrder,  
 SttmntBlnceTotal,  
 DlDtlDsplyUOMID,  
 LeaseName,  
 MvtDcmntIssuedBy,  
 HdrID,  
 HdrPrntID,  
 OriginLcleNme,  
 DestinationLcleNme,  
 FOBLcleNme,  
 ContractContact,  
 DeliveryTerm,  
 IsAdjustment,
 RemitToInstructions,
 TransactionDescription,
 XDtlStat,
 IsTopLevel,
 ProvisionQuantity
 )  
 select slsinvcehdrid,
  TimeTransactionDetail.TmeXDtlIdnty,  
  DealHeader.DlHdrID,  
  DealHeader.DlHdrExtrnlNbr,  
  DealHeader.DlHdrIntrnlNbr,   
  DealHeader.DlHdrExtrnlCntctID,  
  AccountDetail.ParentPrdctID,  
  product.PrdctAbbv,
  AccountDetail.ChildPrdctID,   
  AccountDetail.AcctDtlLcleID,  
  AccountDetail.AcctDtlDestinationLcleID,  
  AccountDetail.AcctDtlLcleID 'DtlFOBLcleID',  
  AccountDetail.Value,
 FixedPriceTA.PriceAttribute1,  --ISNULL(CASE SlsInvceSttmntRvrsd WHEN 'Y' THEN -TransactionDetail.XDtlPrUntVal ELSE TransactionDetail.XDtlPrUntVal END,0),
  accountdetail.volume,
  AccountDetail.AcctDtlTrnsctnTypID, -- DtlTrnsctnTypID  
  '',   
  AccountDetail.AcctDtlTrnsctnDte,  
  '',  
  '',  
  CASE WHEN DealDetailPrvsnAttribute.DlDtlPnAttrDta = 'Delivery' THEN 'D' ELSE 'R' END, --'',  --DtlSpplyDmnd  
  3, -- DtlCrrncyID  
  0, -- DtlStrtngBlnce  
  null,  
  0,--SttmntBlnceEndngBlnce, /*TODO UOM Conversion ? */  
  'N',  
  AccountDetail.AcctDtlAccntngPrdID,  
  PrdctOrder,  
  NULL, -- SttmntBlnceTotal  
  DDP.CrrncyID, -- DlDtlDsplyUOMID  
  '',  
  '', -- MvtDcmntIssuedBy  
  SlsInvceHdrID,  
  SlsInvceHdrPrntID,  
  FOB.LcleNme,  
  Destination.LcleNme,  
  FOB.LcleNme,  
  Contact.CntctFrstNme + ' ' + Contact.CntctLstNme,  
  Convert(VarChar,DynamicListBox.DynLstBxDesc), -- DeliveryTerm  
  '' IsAdjustment,
  Case 
		When Term.TrmPymntMthd in ('E', 'W') or Left(isnull(GeneralConfiguration.GnrlCnfgMulti,'n'),1) = 'y' then 
			Case 
				When MasterAgreementInvoiceSetup.MasterAgreementID is not null Then
					'Wire Transfer Information:' + char(13) + 
					MasterAgreementInvoiceSetup.WireTransferBank + char(13) +  
					MasterAgreementInvoiceSetup.WireTransferABA + char(13) +  
					MasterAgreementInvoiceSetup.WireTransferAccount + char(13) 
				Else		
					Case When SlsInvceVrbgeLne1 is null or SlsInvceVrbgeLne1 = '' then '' else SlsInvceVrbgeLne1 + char(13) end + 
					Case When SlsInvceVrbgeLne2 is null or SlsInvceVrbgeLne2 = '' then '' else SlsInvceVrbgeLne2 + char(13) end + 
					Case When SlsInvceVrbgeLne3 is null or SlsInvceVrbgeLne3 = '' then '' else SlsInvceVrbgeLne3 + char(13) end + 
					Case When SlsInvceVrbgeLne4 is null or SlsInvceVrbgeLne4 = '' then '' else SlsInvceVrbgeLne4 + char(13) end + 
					Case When SlsInvceVrbgeLne5 is null or SlsInvceVrbgeLne5 = '' then '' else SlsInvceVrbgeLne5 + char(13) end + 
					Case When SlsInvceVrbgeLne6 is null or SlsInvceVrbgeLne6 = '' then '' else SlsInvceVrbgeLne6 + char(13) end + 
					Case When SlsInvceVrbgeLne7 is null or SlsInvceVrbgeLne7 = '' then '' else SlsInvceVrbgeLne7 + char(13) end + 
					Case When SlsInvceVrbgeLne8 is null or SlsInvceVrbgeLne8 = '' then '' else SlsInvceVrbgeLne8 end
				End
		Else ''
	End 'RemitToInstructions',
	isnull( prvsndesc.GnrlCnfgMulti,TransactionType.TrnsctnTypDesc),
	TimeTransactionDetail.TmeXDtlStat,
	0 IsTopLevel,
   accountdetail.volume ProvisionQuantity
From SalesInvoiceHeader (NoLock)  
  Inner Join DealHeader (NoLock)  on  DealHeader.DlHDrID  = ( select top 1 SttmntBlnceDlHdrID From StatementBalance where SttmntBlnceSlsInvceHdrID = @i_salesinvoiceheaderID )
  Inner Join DealDetailProvision ddp
    on ddp.DlDtlPrvsnDlDtlDlHdrID = DealHeader.DlHdrID
  Inner Join TimeTransactionDetail
    on TimeTransactionDetail.TmeXDtlDlDtlPrvsnID = ddp.DlDtlPrvsnID
  Inner Join TimeTransactionDetailLog
    on TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty = TimeTransactionDetail.TmeXDtlIdnty
  Inner Join AccountDetail
    on AccountDetail.AcctDtlID = TimeTransactionDetailLog.TmeXDtlLgAcctDtlID
   and AccountDetail.AcctDtlAccntngPrdID = @i_AccntngPrdID
   and AccountDetail.AcctDtlsrcetble = 'TT'
   and AccountDetail.ExternalBAID = DealHeader.DlHdrExtrnlBaid
  Inner Join Product (NoLock)  
    on Product.PrdctID  = accountdetail.ParentPrdctID 
  Left outer join Locale FOB on FOB.LcleID = AccountDetail.AcctDtlLcleID
  left outer join locale Destination on Destination.Lcleid = AccountDetail.AcctDtlDestinationLcleID
  Inner Join TransactionType on TransactionType.TrnsctnTypID = AccountDetail.AcctDtlTrnsctnTypID
  Inner Join Contact (NoLock)  
    on Contact.CntctID        = DealHeader.DlHdrExtrnlCntctID  
  Inner Join DealDetail (NoLock)  
    on DealDetail.DLDtlDlhdrID = ddp.DlDtlPrvsnDlDtlDlHdrID
	and DealDetail.Dldtlid = ddp.DlDtlPrvsnDlDtlID  
  Left Outer Join DynamicListBox (NoLock)  
    on DynamicListBox.DynLstBxQlfr     = 'DealDeliveryTerm' 
    And DynamicListBox.DynLstBxTyp     = DealDetail.DeliveryTermID  
  Left Outer Join SalesInvoiceVerbiage (NoLock) on ( WireSlsInvceVrbgeID = SlsInvceVrbgeID)
  Left Outer Join GeneralConfiguration (NoLock) on (GnrlCnfgQlfr = 'AlwaysPrintWireInst' and GnrlCnfgTblNme = 'System')
  Left Outer Join MasterAgreementInvoiceSetup (NoLock)	On MasterAgreementInvoiceSetup.MasterAgreementID	= SalesInvoiceHeader.SlsInvceHdrStpID
							And SalesInvoiceHeader.SlsInvceHdrStpTble		= 'M'
  Inner Join Term on (SalesInvoiceHeader.SlsInvceHdrTrmID = Term.TrmID)
  left outer join prvsn on prvsn.prvsnid = ddp.DlDtlPrvsnPrvsnID
  left outer join GeneralConfiguration prvsndesc on prvsndesc.GnrlcnfgHdrID = prvsn.prvsnID
                                                and prvsndesc.GnrlcnfgTblNme = 'Prvsn'
                                                and prvsndesc.GnrlcnfgQlfr = 'InvoiceDisplay'
  Inner Join #txnTypes on #txnTypes.TrnsctnTypID = AcctDtlTrnsctnTypID
LEFT OUTER JOIN	DealDetailProvisionRow (NOLOCK) FixedPriceTA
ON	FixedPriceTA.DlDtlPrvsnID	= TimeTransactionDetail.TmeXDtlDlDtlPrvsnID
AND	FixedPriceTA.DlDtlPrvsnRwID = TimeTransactionDetail.TmeXDtlDlDtlPrvsnRwID
  LEFT OUTER JOIN DealDetailPrvsnAttribute (NoLock)
  on	TimeTransactionDetail.TmeXDtlDlDtlPrvsnID = DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnID
  AND	ddp.DlDtlPrvsnDlDtlDlHdrID	= DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnDlDtlDlHdrID
  AND	DealDetail.Dldtlid = DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnDlDtlID
  AND	DlDtlPnAttrPrvsnAttrTpeID IN (2239,2141)
  AND	DealDetailPrvsnAttribute.RowNumber = 1
Where  SlsInvceHdrID = @i_SalesInvoiceHeaderID  
Order by product.PrdctAbbv, 
	isnull( prvsndesc.GnrlCnfgMulti,TransactionType.TrnsctnTypDesc)



 SELECT	DISTINCT StatementBalance.SttmntBlnceDlHdrID
 INTO	#TADEAL
 FROM	SalesInvoiceHeader
 --INNER JOIN SalesInvoiceStatement
 --ON	SalesInvoiceHeader.SlsInvceHdrID = SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID
  Inner Join StatementBalance(NoLock)  
    on StatementBalance.SttmntBlnceSlsInvceHdrID = SalesInvoiceHeader.SlsInvceHdrID
   WHERE	SalesInvoiceHeader.SlsInvceHdrID = @i_SalesInvoiceHeaderID
 
 --------------------------------------------------------------------------  
-- Insert xhdrids and accountdetails
--------------------------------------------------------------------------  
Insert #slsinvcedtl  
 (  
 DtlSlsInvceHdrID,  
 XHdrID,  
 DtlDlHdrID,  
 DtlDlHdrExtrnlNbr,  
 DtlDlHdrIntrnlNbr,  
 DtlDlHdrExtrnlCntctID,  
 DtlPrntPrdctID,  
 Product,
 DtlChldPrdctID,  
 DtlOrgnLcleID,  
 DtlDstntnLcleID,  
 DtlFOBLcleID,  
 DtlTrnsctnVle,  
 DtlPrUntVle,  
 DtlTrnsctnQntty,  
 DtlTrnsctnTypID,  
 DtlMvtDcmntExtrnlDcmnt,  
 DtlMvtHdrDte,  
 DtlMvtHdrTyp,  
 DtlMvtHdrTypNme,  
 DtlSpplyDmnd,  
 DtlCrrncyID,  
 DtlStrtngBlnce,  
 DtlMvtHdrVhcleID,  
 SttmntEndngBlnce,  
 TrnsctnTypCtgry,  
 AccntngPrdID,  
 ProductOrder,  
 SttmntBlnceTotal,  
 DlDtlDsplyUOMID,  
 LeaseName,  
 MvtDcmntIssuedBy,  
 HdrID,  
 HdrPrntID,  
 OriginLcleNme,  
 DestinationLcleNme,  
 FOBLcleNme,  
 ContractContact,  
 DeliveryTerm,  
 IsAdjustment,
 RemitToInstructions,
 TransactionDescription,
 XDtlStat,
 IsTopLevel,
 ProvisionQuantity
 )  
 SELECT slsinvcehdrid,
  TransactionHeader.XHdrID,  
  StatementBalance.SttmntBlnceDlHdrID,  
  DealHeader.DlHdrExtrnlNbr,  
  DealHeader.DlHdrIntrnlNbr,   
  DealHeader.DlHdrExtrnlCntctID,  
  XHdrMvtDtlChmclParPrdctID,  
  product.PrdctAbbv,
  XHdrMvtDtlChmclChdPrdctID,   
  MvtHdrLcleID,  
  MvtHdrDstntnLcleID,  
  TransactionHeader.Movementlcleid 'DtlFOBLcleID',  
--  ISNULL(CASE SlsInvceSttmntRvrsd WHEN 'Y' THEN -TransactionDetail.XDtlTtlVal ELSE TransactionDetail.XDtlTtlVal END,0),
--  ISNULL(CASE SlsInvceSttmntRvrsd WHEN 'Y' THEN -TransactionDetail.XDtlPrUntVal ELSE TransactionDetail.XDtlPrUntVal END,0),
--  ISNULL(CASE XHdrTyp WHEN 'D' THEN -XHdrQty ELSE XHdrQty END * CASE SlsInvceSttmntRvrsd WHEN 'Y' THEN -1 ELSE 1 END,0),
  isnull(accountdetail.Value,0),
   ISNULL(FixedPriceTA.PriceAttribute1,0),
 --ISNULL(CASE XDtlLgRvrsd WHEN 'Y' THEN -TransactionDetail.XDtlPrUntVal ELSE TransactionDetail.XDtlPrUntVal END,0),
  case XDtlLgRvrsd WHEN 'Y' THEN -XHdrQty else XhdrQty end,
  TransactionDetail.XDtlTrnsctnTypID, -- DtlTrnsctnTypID  
  MovementDocument.MvtDcmntExtrnlDcmntNbr,   
  MovementHeader.MvtHdrDte,  
  MovementHeader.MvtHdrTyp,  
  MovementHeaderType. Name,  
  TransactionHeader.XHdrTyp,  
  3, -- DtlCrrncyID  
  0, -- DtlStrtngBlnce  
  MovementHeader.MvtHdrVhcleID,  
  SttmntBlnceEndngBlnce, /*TODO UOM Conversion ? */  
  'N',  
  AcctDtlAccntngPrdID, --SttmntBlnceAccntngPrdID,  ,  
  PrdctOrder,  
  NULL, -- SttmntBlnceTotal  
  TransactionDetail.XDtlCrrncyID, -- DlDtlDsplyUOMID  
  IsNull(MovementHeader.LeaseName,''),  
  MovementDocument.MvtDcmntBAID, -- MvtDcmntIssuedBy  
  SlsInvceHdrID,  
  SlsInvceHdrPrntID,  
  Origin.LcleNme,  
  Destination.LcleNme,  
  FOB.LcleNme,  
  Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ContractContact',  
  Convert(VarChar,DynamicListBox.DynLstBxDesc), -- DeliveryTerm  
  TransactionHeader.IsAdjustment,
  Case 
		When Term.TrmPymntMthd in ('E', 'W') or Left(isnull(GeneralConfiguration.GnrlCnfgMulti,'n'),1) = 'y' then 
			Case 
				When MasterAgreementInvoiceSetup.MasterAgreementID is not null Then
					'Wire Transfer Information:' + char(13) + 
					MasterAgreementInvoiceSetup.WireTransferBank + char(13) +  
					MasterAgreementInvoiceSetup.WireTransferABA + char(13) +  
					MasterAgreementInvoiceSetup.WireTransferAccount + char(13) 
				Else		
					Case When SlsInvceVrbgeLne1 is null or SlsInvceVrbgeLne1 = '' then '' else SlsInvceVrbgeLne1 + char(13) end + 
					Case When SlsInvceVrbgeLne2 is null or SlsInvceVrbgeLne2 = '' then '' else SlsInvceVrbgeLne2 + char(13) end + 
					Case When SlsInvceVrbgeLne3 is null or SlsInvceVrbgeLne3 = '' then '' else SlsInvceVrbgeLne3 + char(13) end + 
					Case When SlsInvceVrbgeLne4 is null or SlsInvceVrbgeLne4 = '' then '' else SlsInvceVrbgeLne4 + char(13) end + 
					Case When SlsInvceVrbgeLne5 is null or SlsInvceVrbgeLne5 = '' then '' else SlsInvceVrbgeLne5 + char(13) end + 
					Case When SlsInvceVrbgeLne6 is null or SlsInvceVrbgeLne6 = '' then '' else SlsInvceVrbgeLne6 + char(13) end + 
					Case When SlsInvceVrbgeLne7 is null or SlsInvceVrbgeLne7 = '' then '' else SlsInvceVrbgeLne7 + char(13) end + 
					Case When SlsInvceVrbgeLne8 is null or SlsInvceVrbgeLne8 = '' then '' else SlsInvceVrbgeLne8 end
				End
		Else ''
	End 'RemitToInstructions',
	isnull( prvsndesc.GnrlCnfgMulti,TransactionType.TrnsctnTypDesc),
	TransactionDetail.XDtlStat,
	0 IsTopLevel,
--	0 ProvisionQuantity
   XHdrQty
 FROM	DealHeader
 INNER JOIN	Dealdetail
 ON	DealHeader.DlHdrID = Dealdetail.DlDtlDlHdrID
 INNER JOIN	AccountDetail (NoLock)
 ON		Dealdetail.DlDtlDlHdrID = AccountDetail.AcctDtlDlDtlDlHdrID
 AND	Dealdetail.DlDtlID = AccountDetail.AcctDtlDlDtlID
 AND	AccountDetail.AcctDtlAccntngPrdID = @i_AccntngPrdID
 INNER JOIN	#txnTypes on #txnTypes.TrnsctnTypID = AcctDtlTrnsctnTypID
 INNER JOIN	#TADEAL
 ON	DealHeader.DlHdrID = #TADEAL.SttmntBlnceDlHdrID
 LEFT OUTER JOIN TransactionDetailLog (nolock)
 ON	AccountDetail.AcctDtlID = TransactionDetailLog.XDtlLgAcctDtlID
   LEFT OUTER JOIN TransactionDetail (NoLock)
     ON TransactionDetailLog.XDtlLgXDtlID = TransactionDetail.XDtlID 
	 AND TransactionDetailLog.XDtlLgXDtlXHdrID = TransactionDetail.XDtlXHdrID 
	 AND TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID = TransactionDetail.XDtlDlDtlPrvsnID
Inner loop Join	TransactionHeader	On	TransactionHeader.XHdrID			= TransactionDetail.XDtlXHdrID
   Left Outer Join MovementHeader (NoLock)  
    on MovementHeader.MvtHdrID      = TransactionHeader.XHdrMvtDtlMvtHdrID  
  Left Outer Join MovementDocument  
    on MovementDocument.MvtDcmntid     = TransactionHeader.XHdrMvtDcmntID  
  Left Outer Join Locale FOB (NoLock)  
    on FOB.LcleID         = TransactionHeader.Movementlcleid  
  Left Outer Join Locale Origin (NoLock)  
    on Origin.LcleID        = MovementHeader.MvtHdrLcleID  
  Left Outer Join Locale Destination (NoLock)  
    on Destination.LcleID       = MovementHeader.MvtHdrDstntnLcleID  
  Inner Join Contact (NoLock)  
    on Contact.CntctID        = DealHeader.DlHdrExtrnlCntctID  
  Left Outer Join DynamicListBox (NoLock)  
    on DynamicListBox.DynLstBxQlfr     = 'DealDeliveryTerm' 
    And DynamicListBox.DynLstBxTyp     = DealDetail.DeliveryTermID  
  Left Outer Join MovementHeaderType (NoLock)  
    on MovementHeader. MvtHdrTyp     = MovementHeaderType.MvtHdrTyp  
  Left Outer Join PlannedTransfer (NoLock)  
    on PlannedTransfer.PlnndTrnsfrID    = TransactionHeader.Xhdrplnndtrnsfrid  
    and PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID = DealHeader.DlHdrID  
    and PlannedTransfer.PlnndTrnsfrObDlDtlID  = DealDetail.DlDtlid   
  Left Outer Join ProductLocale (NoLock)  
    on ProductLocale.PrdctID      = XHdrMvtDtlChmclParPrdctID  
    and ProductLocale.LcleID      = MvtHdrLcleID  
  LEFT JOIN TransactionType (NoLock)
     ON TransactionDetail.XDtlTrnsctnTypID = TransactionType.TrnsctnTypID
  left outer join dealdetailprovision ddp on ddp.dldtlprvsnid = transactiondetail.XDtlDlDtlPrvsnID
	   left outer join prvsn on prvsn.prvsnid = ddp.DlDtlPrvsnPrvsnID
  left outer join GeneralConfiguration prvsndesc on prvsndesc.GnrlcnfgHdrID = prvsn.prvsnID
                                                and prvsndesc.GnrlcnfgTblNme = 'Prvsn'
                                                and prvsndesc.GnrlcnfgQlfr = 'InvoiceDisplay'
Left Outer Join GeneralConfiguration (NoLock) on (GeneralConfiguration.GnrlCnfgQlfr = 'AlwaysPrintWireInst' and GeneralConfiguration.GnrlCnfgTblNme = 'System')
INNER Join SalesInvoiceStatement (NoLock)  
    on TransactionHeader.XHdrID   = SalesInvoiceStatement.SlsInvceSttmntXHdrID
	AND	SalesInvoiceStatement.SlsInvceSttmntRvrsd <> 'Y'
INNER JOIN SalesInvoiceHeader (NoLock)
ON	SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID = SalesInvoiceHeader.SlsInvceHdrID
Inner Join StatementBalance(NoLock)  
    on SalesInvoiceHeader.SlsInvceHdrID = StatementBalance.SttmntBlnceSlsInvceHdrID
	and TransactionHeader.XHdrMvtDtlChmclChdPrdctID = StatementBalance.SttmntBlncePrdctID
  Inner Join Product (NoLock)  
    on Product.PrdctID  = StatementBalance.SttmntBlncePrdctID  
  Left Outer Join SalesInvoiceVerbiage (NoLock) on ( WireSlsInvceVrbgeID = SlsInvceVrbgeID)
  
  Left Outer Join MasterAgreementInvoiceSetup (NoLock)	On MasterAgreementInvoiceSetup.MasterAgreementID	= SalesInvoiceHeader.SlsInvceHdrStpID
							And SalesInvoiceHeader.SlsInvceHdrStpTble		= 'M'
  Inner Join Term on (SalesInvoiceHeader.SlsInvceHdrTrmID = Term.TrmID)


   --This will work for ALL FIXED PRICE PROVISIONS ONLY!!!!
 LEFT OUTER join DealDetailProvisionRow FixedPriceTA
		on	ddp.DlDtlPrvsnID = FixedPriceTA.DlDtlPrvsnID

-----------------------------------------------------------------------------------------------------------------------------------------------
--add any accountdetails that were excluded due to external ba,transaction type or incomplete and it was the only acctdtl
-----------------------------------------------------------------------------------------------------------------------------------------------
Insert #slsinvcedtl  
 (  
 DtlSlsInvceHdrID,  
 XHdrID,  
 DtlDlHdrID,  
 DtlDlHdrExtrnlNbr,  
 DtlDlHdrIntrnlNbr,  
 DtlDlHdrExtrnlCntctID,  
 DtlPrntPrdctID,  
 Product,
 DtlChldPrdctID,  
 DtlOrgnLcleID,  
 DtlDstntnLcleID,  
 DtlFOBLcleID,  
 DtlTrnsctnVle,  
 DtlPrUntVle,  
 DtlTrnsctnQntty,  
 DtlTrnsctnTypID,  
 DtlMvtDcmntExtrnlDcmnt,  
 DtlMvtHdrDte,  
 DtlMvtHdrTyp,  
 DtlMvtHdrTypNme,  
 DtlSpplyDmnd,  
 DtlCrrncyID,  
 DtlStrtngBlnce,  
 DtlMvtHdrVhcleID,  
 SttmntEndngBlnce,  
 TrnsctnTypCtgry,  
 AccntngPrdID,  
 ProductOrder,  
 SttmntBlnceTotal,  
 DlDtlDsplyUOMID,  
 LeaseName,  
 MvtDcmntIssuedBy,  
 HdrID,  
 HdrPrntID,  
 OriginLcleNme,  
 DestinationLcleNme,  
 FOBLcleNme,  
 ContractContact,  
 DeliveryTerm,  
 IsAdjustment,
 RemitToInstructions,
 TransactionDescription,
 XDtlStat,
 IsTopLevel,
 ProvisionQuantity
 )  
 select slsinvcehdrid,
  TransactionHeader.XHdrID,  
  SttmntBlnceDlHdrID,  
  DealHeader.DlHdrExtrnlNbr,  
  DealHeader.DlHdrIntrnlNbr,   
  DealHeader.DlHdrExtrnlCntctID,  
  XHdrMvtDtlChmclParPrdctID,  
  product.PrdctAbbv,
  XHdrMvtDtlChmclChdPrdctID,   
  MvtHdrLcleID,  
  MvtHdrDstntnLcleID,  
  TransactionHeader.Movementlcleid 'DtlFOBLcleID',  
--  ISNULL(CASE SlsInvceSttmntRvrsd WHEN 'Y' THEN -TransactionDetail.XDtlTtlVal ELSE TransactionDetail.XDtlTtlVal END,0),
--  ISNULL(CASE SlsInvceSttmntRvrsd WHEN 'Y' THEN -TransactionDetail.XDtlPrUntVal ELSE TransactionDetail.XDtlPrUntVal END,0),
--  ISNULL(CASE XHdrTyp WHEN 'D' THEN -XHdrQty ELSE XHdrQty END * CASE SlsInvceSttmntRvrsd WHEN 'Y' THEN -1 ELSE 1 END,0),
  0,
  0,
  ISNULL(CASE SlsInvceSttmntRvrsd WHEN 'Y' THEN -xhdrqty ELSE xhdrqty END,0) xhdrqty,
  '',--TransactionDetail.XDtlTrnsctnTypID, -- DtlTrnsctnTypID  
  MovementDocument.MvtDcmntExtrnlDcmntNbr,   
  MovementHeader.MvtHdrDte,  
  MovementHeader.MvtHdrTyp,  
  MovementHeaderType. Name,  
  TransactionHeader.XHdrTyp,  
  3, -- DtlCrrncyID  
  0, -- DtlStrtngBlnce  
  MovementHeader.MvtHdrVhcleID,  
  SttmntBlnceEndngBlnce, /*TODO UOM Conversion ? */  
  'N',  
  SttmntBlnceAccntngPrdID,  
  PrdctOrder,  
  NULL, -- SttmntBlnceTotal  
  null,--TransactionDetail.XDtlCrrncyID, -- DlDtlDsplyUOMID  
  IsNull(MovementHeader.LeaseName,''),  
  MovementDocument.MvtDcmntBAID, -- MvtDcmntIssuedBy  
  SlsInvceHdrID,  
  SlsInvceHdrPrntID,  
  Origin.LcleNme,  
  Destination.LcleNme,  
  FOB.LcleNme,  
  Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ContractContact',  
  Convert(VarChar,DynamicListBox.DynLstBxDesc), -- DeliveryTerm  
  TransactionHeader.IsAdjustment,
  Case 
		When Term.TrmPymntMthd in ('E', 'W') or Left(isnull(GeneralConfiguration.GnrlCnfgMulti,'n'),1) = 'y' then 
			Case 
				When MasterAgreementInvoiceSetup.MasterAgreementID is not null Then
					'Wire Transfer Information:' + char(13) + 
					MasterAgreementInvoiceSetup.WireTransferBank + char(13) +  
					MasterAgreementInvoiceSetup.WireTransferABA + char(13) +  
					MasterAgreementInvoiceSetup.WireTransferAccount + char(13) 
				Else		
					Case When SlsInvceVrbgeLne1 is null or SlsInvceVrbgeLne1 = '' then '' else SlsInvceVrbgeLne1 + char(13) end + 
					Case When SlsInvceVrbgeLne2 is null or SlsInvceVrbgeLne2 = '' then '' else SlsInvceVrbgeLne2 + char(13) end + 
					Case When SlsInvceVrbgeLne3 is null or SlsInvceVrbgeLne3 = '' then '' else SlsInvceVrbgeLne3 + char(13) end + 
					Case When SlsInvceVrbgeLne4 is null or SlsInvceVrbgeLne4 = '' then '' else SlsInvceVrbgeLne4 + char(13) end + 
					Case When SlsInvceVrbgeLne5 is null or SlsInvceVrbgeLne5 = '' then '' else SlsInvceVrbgeLne5 + char(13) end + 
					Case When SlsInvceVrbgeLne6 is null or SlsInvceVrbgeLne6 = '' then '' else SlsInvceVrbgeLne6 + char(13) end + 
					Case When SlsInvceVrbgeLne7 is null or SlsInvceVrbgeLne7 = '' then '' else SlsInvceVrbgeLne7 + char(13) end + 
					Case When SlsInvceVrbgeLne8 is null or SlsInvceVrbgeLne8 = '' then '' else SlsInvceVrbgeLne8 end
				End
		Else ''
	End 'RemitToInstructions',
	'',--isnull( prvsndesc.GnrlCnfgMulti,TransactionType.TrnsctnTypDesc),
	null,--TransactionDetail.XDtlStat,
	0 IsTopLevel,
--	0 ProvisionQuantity
   XHdrQty
From SalesInvoiceHeader (NoLock)  
  Inner Join SalesInvoiceStatement (NoLock)  
    on SalesInvoiceHeader.SlsInvceHdrID   = SalesInvoiceStatement.SlsInvceSttmntSlsInvceHdrID  
  Inner Join StatementBalance(NoLock)  
    on StatementBalance.SttmntBlnceSlsInvceHdrID = SalesInvoiceHeader.SlsInvceHdrID
	Inner loop Join	TransactionHeader	On	TransactionHeader.XHdrID			= SalesInvoiceStatement.SlsInvceSttmntXHdrID
 						    and StatementBalance.SttmntBlncePrdctID   = TransactionHeader.XHdrMvtDtlChmclChdPrdctID  
  Inner Join Product (NoLock)  
    on Product.PrdctID  = StatementBalance.SttmntBlncePrdctID  
  Inner Join DealHeader (NoLock)  
    on StatementBalance.SttmntBlnceDlHdrID   = DealHeader.DlHDrID  
  Left Outer Join MovementHeader (NoLock)  
    on MovementHeader.MvtHdrID      = TransactionHeader.XHdrMvtDtlMvtHdrID  
  Left Outer Join MovementDocument  
    on MovementDocument.MvtDcmntid     = TransactionHeader.XHdrMvtDcmntID  
  Left Outer Join Locale FOB (NoLock)  
    on FOB.LcleID         = TransactionHeader.Movementlcleid  
  Left Outer Join Locale Origin (NoLock)  
    on Origin.LcleID        = MovementHeader.MvtHdrLcleID  
  Left Outer Join Locale Destination (NoLock)  
    on Destination.LcleID       = MovementHeader.MvtHdrDstntnLcleID  
  Inner Join Contact (NoLock)  
    on Contact.CntctID        = DealHeader.DlHdrExtrnlCntctID  
  Inner Join DealDetail (NoLock)  
    on DealDetail.DealDetailID = TransactionHeader.DealDetailID  
  Left Outer Join DynamicListBox (NoLock)  
    on DynamicListBox.DynLstBxQlfr     = 'DealDeliveryTerm' 
    And DynamicListBox.DynLstBxTyp     = DealDetail.DeliveryTermID  
  Left Outer Join MovementHeaderType (NoLock)  
    on MovementHeader. MvtHdrTyp     = MovementHeaderType.MvtHdrTyp  
  Left Outer Join PlannedTransfer (NoLock)  
    on PlannedTransfer.PlnndTrnsfrID    = TransactionHeader.Xhdrplnndtrnsfrid  
    and PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID = DealHeader.DlHdrID  
    and PlannedTransfer.PlnndTrnsfrObDlDtlID  = DealDetail.DlDtlid   
  Left Outer Join ProductLocale (NoLock)  
    on ProductLocale.PrdctID      = XHdrMvtDtlChmclParPrdctID  
    and ProductLocale.LcleID      = MvtHdrLcleID  
  Left Outer Join SalesInvoiceVerbiage (NoLock) on ( WireSlsInvceVrbgeID = SlsInvceVrbgeID)
  Left Outer Join GeneralConfiguration (NoLock) on (GnrlCnfgQlfr = 'AlwaysPrintWireInst' and GnrlCnfgTblNme = 'System')
  Left Outer Join MasterAgreementInvoiceSetup (NoLock)	On MasterAgreementInvoiceSetup.MasterAgreementID	= SalesInvoiceHeader.SlsInvceHdrStpID
							And SalesInvoiceHeader.SlsInvceHdrStpTble		= 'M'
  Inner Join Term on (SalesInvoiceHeader.SlsInvceHdrTrmID = Term.TrmID)
Where  SlsInvceHdrID = @i_SalesInvoiceHeaderID  
and not exists ( select 'x' from #slsinvcedtl where #slsinvcedtl.xhdrid = TransactionHeader.XhdrID )

--SELECT *
--FROM #slsinvcedtl i
--INNER JOIN dbo.SalesInvoiceInternalBASetup bv
--ON i.SlsInvceIntrnlBAStpBAID = 


--UPDATE #slsinvcedtl SET RemitToInstructions = 'Test
--				fsdfsdfsdfsdfsdfsd
--				sdfsdfsdfsdf
--				sdfsdfsdfsdfsdfsdfsdfs
--				dsfsdffffffffffffffffffffffffffff'

UPDATE d SET SttmntEndngBlnce = SttmntEndngBlnce * v.ConversionFactor
, DtlTrnsctnQntty = DtlTrnsctnQntty * v.ConversionFactor
, provisionquantity = DtlTrnsctnQntty * v.ConversionFactor
FROM #slsinvcedtl d
INNER JOIN v_uomconversion v
ON FromUOM = 3  
and ToUOM = 2
--UPDATE #slsinvcedtl SET DtlTrnsctnVle = -DtlTrnsctnVle WHERE DtlSpplyDmnd = ''D''

Update #slsinvcedtl  
Set  Product = Prod.PrdctAbbv,  
  Chemical = Chem.PrdctAbbv  
From #slsinvcedtl  
  Inner Join Product Prod (NoLock)  
    on Prod.PrdctID = #SlsInvceDtl.DtlPrntPrdctID  
  Inner Join Product Chem (NoLock)  
    on Chem.PrdctID = #SlsInvceDtl.DtlChldPrdctID  

/*-----------------------------------------------------------   
-- Added Update the Starting Balance  
-----------------------------------------------------------*/  
UPDATE #slsinvcedtl  
SET  DlDtlDsplyUOMID = 2,  
  UOMAbbv   = (Select UOMAbbv From UnitOfMeasure (NoLock) Where UOM = 2),  
  DtlStrtngBlnce = ISNULL((SELECT SUM(SttmntBlnceEndngBlnce * v_UOMConversion.ConversionFactor)
        From StatementBalance (NoLock)  
      Inner Join v_uomconversion  
        on FromUOM = 3  
        and ToUOM = 2 
      Inner Join  Product (NoLock)  
        on Product.PrdctID = StatementBalance.SttmntBlncePrdctID  
        Where SttmntBlnceDlHdrID = #slsinvcedtl.DtlDlHdrID  
        AND   SttmntBlncePrdctID = #slsinvcedtl.DtlChldPrdctID  
        AND   SttmntBlnceAccntngPrdID = (Select max(SttmntBlnceLstAccntngPrdID)  
             From StatementBalance (NoLock)  
             Where SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID)),0)  
Where DtlSlsInvceHdrID = @i_SalesInvoiceHeaderID

UPDATE #slsinvcedtl 
SET TransactionDescription = CASE IsAdjustment WHEN 'Y' THEN 'Adjustment' ELSE DtlMvtDcmntExtrnlDcmnt END 
WHERE TransactionDescription IS NULL

--If no default wire information exists get it from the default setup.
IF ((SELECT COUNT(1) FROM #slsinvcedtl WHERE ISNULL(RemitToInstructions,'') != '') < 1)
BEGIN
	DECLARE @WireID INT

	EXEC sp_get_wire_verbiage @i_SalesInvoiceHeaderID, @i_WireID = @WireID OUTPUT

	UPDATE #slsinvcedtl SET RemitToInstructions = (

	SELECT Case When SlsInvceVrbgeLne1 is null or SlsInvceVrbgeLne1 = '' then '' else SlsInvceVrbgeLne1 + char(13) end + 
					Case When SlsInvceVrbgeLne2 is null or SlsInvceVrbgeLne2 = '' then '' else SlsInvceVrbgeLne2 + char(13) end + 
					Case When SlsInvceVrbgeLne3 is null or SlsInvceVrbgeLne3 = '' then '' else SlsInvceVrbgeLne3 + char(13) end + 
					Case When SlsInvceVrbgeLne4 is null or SlsInvceVrbgeLne4 = '' then '' else SlsInvceVrbgeLne4 + char(13) end + 
					Case When SlsInvceVrbgeLne5 is null or SlsInvceVrbgeLne5 = '' then '' else SlsInvceVrbgeLne5 + char(13) end + 
					Case When SlsInvceVrbgeLne6 is null or SlsInvceVrbgeLne6 = '' then '' else SlsInvceVrbgeLne6 + char(13) end + 
					Case When SlsInvceVrbgeLne7 is null or SlsInvceVrbgeLne7 = '' then '' else SlsInvceVrbgeLne7 + char(13) end + 
					Case When SlsInvceVrbgeLne8 is null or SlsInvceVrbgeLne8 = '' then '' else SlsInvceVrbgeLne8 end
	FROM SalesInvoiceVerbiage
	WHERE SlsInvceVrbgeTpe = 'W'
	AND SlsInvceVrbgeID = @WireID
	)
END

UPDATE i SET  RemitToInstructions =  ISNULL(RemitToInstructions,'') + '

Please reference customer account number: ' + st.SoldTo
FROM #slsinvcedtl i
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON i.DtlDlHdrID = gc.GnrlCnfgHdrID
AND gc.GnrlCnfgTblNme = 'DealHeader'
AND gc.GnrlCnfgQlfr = 'SAPSoldTo'
AND ISNUMERIC(gc.GnrlCnfgMulti)= 1
INNER JOIN dbo.MTVSAPBASoldTo st (NOLOCK)
ON st.ID = gc.GnrlCnfgMulti

SELECT  distinct DtlSlsInvceHdrID,  
   XHdrID,  
   DtlDlHdrID,  
   DtlDlHdrExtrnlNbr,  
   DtlDlHdrIntrnlNbr,  
   DtlDlHdrExtrnlCntctID,  
   DtlPrntPrdctID,  
   Product,  
   DtlChldPrdctID,  
   Chemical,  
   DtlOrgnLcleID,  
   DtlDstntnLcleID,  
   DtlFOBLcleID,  
   sum(ISNULL(DtlTrnsctnVle,0)) DtlTrnsctnVle,  
   --0 DtlPrUntVle,
  DtlPrUntVle,
   CAST(0.00 AS FLOAT) DtlTrnsctnQntty,
   DtlTrnsctnTypID,  
   DtlMvtDcmntExtrnlDcmnt,  
   DtlMvtHdrDte,  
   DtlMvtHdrTyp,  
   DtlMvtHdrTypNme,  
   DtlSpplyDmnd,  
   DtlCrrncyID,  
   -DtlStrtngBlnce DtlStrtngBlnce,  
   DtlMvtHdrVhcleID,  
   -SttmntEndngBlnce SttmntEndngBlnce,  
   TrnsctnTypCtgry,  
   AccntngPrdID,  
   ProductOrder,  
   SttmntBlnceTotal,  
   DlDtlDsplyUOMID,  
   UOMAbbv,  
   LeaseName,  
   MvtDcmntIssuedBy,  
   HdrID,  
   HdrPrntID,  
   OriginLcleNme,  
   DestinationLcleNme,  
   FOBLcleNme,  
   ContractContact,  
   DeliveryTerm,  
   IsAdjustment,
   RemitToInstructions,
   TransactionDescription,
   --CAST(0.00 AS FLOAT) as provisionquantity, --DtlTrnsctnQntty provisionquantity,
   SUM(provisionquantity) provisionquantity,
   IsTopLevel
into #slsinvcedtlsum
FROM #slsinvcedtl
Where xhdrid <> 0 
Group by  DtlSlsInvceHdrID,  
   XHdrID,  
   DtlDlHdrID,  
   DtlDlHdrExtrnlNbr,  
   DtlDlHdrIntrnlNbr,  
   DtlDlHdrExtrnlCntctID,  
   DtlPrntPrdctID,  
   Product,  
   DtlChldPrdctID,  
   Chemical,  
   DtlOrgnLcleID,  
   DtlDstntnLcleID,  
   DtlFOBLcleID,  
   DtlTrnsctnTypID,  
   DtlMvtDcmntExtrnlDcmnt,  
   DtlMvtHdrDte,  
   DtlMvtHdrTyp,  
   DtlMvtHdrTypNme,  
   DtlSpplyDmnd,  
   DtlCrrncyID,  
   DtlStrtngBlnce,  
   DtlMvtHdrVhcleID,  
   SttmntEndngBlnce,  
   TrnsctnTypCtgry,  
   AccntngPrdID,  
   ProductOrder,  
   SttmntBlnceTotal,  
   DlDtlDsplyUOMID,  
   UOMAbbv,  
   LeaseName,  
   MvtDcmntIssuedBy,  
   HdrID,  
   HdrPrntID,  
   OriginLcleNme,  
   DestinationLcleNme,  
   FOBLcleNme,  
   ContractContact,  
   DeliveryTerm,  
   IsAdjustment,
   RemitToInstructions,
   TransactionDescription,
   --DtlTrnsctnQntty,
   IsTopLevel,
   --provisionquantity,
   DtlPrUntVle
having sum(DtlTrnsctnVle) <> 0.0
Order by Product, isadjustment, DtlSpplyDmnd desc, DtlMvtHdrDte, DtlMvtDcmntExtrnlDcmnt, IsTopLevel desc, DtlMvtHdrTypNme,TransactionDescription

Update #slsinvcedtlsum  
Set  SttmntBlnceTotal = (Select Sum(SttmntBlnceEndngBlnce * v_UOMConversion.ConversionFactor)  
      From StatementBalance  (NoLock)  
     Inner Join v_uomconversion  
       on FromUOM = 3  
       and ToUOM = 2
     Inner Join  Product (NoLock)  
       on Product.PrdctID = StatementBalance.SttmntBlncePrdctID  
         Where SttmntBlnceSlsInvceHdrID = @i_SalesInvoiceHeaderID)

Delete from #slsinvcedtlsum 
where DtlTrnsctnVle = 0
 and exists ( select 'x' from #slsinvcedtlsum s2 where s2.xhdrid = #slsinvcedtlsum.xhdrid and s2.product = #slsinvcedtlsum.product and s2.DtlTrnsctnQntty <> 0 and s2.TransactionDescription <> #slsinvcedtlsum.TransactionDescription  and s2.DtlSpplyDmnd = #slsinvcedtlsum.DtlSpplyDmnd)

select xhdrid, min(transactiondescription) transactiondescription into #toplevel from #slsinvcedtlsum group by  xhdrid

UPDATE s SET s.IsTopLevel = 1
From #slsinvcedtlsum s
     inner join #toplevel t on t.xhdrid = s.xhdrid and t.transactiondescription = s.transactiondescription 

--Let's update the Top level volume for movement transactions.  This is done because of the summed table above and the grouping logic.
UPDATE	#slsinvcedtlsum
SET		#slsinvcedtlsum.DtlTrnsctnQntty = (InventoryReconcile.XhdrQty* v_UOMConversion.ConversionFactor) * InventoryReconcile.ComputedSign
		,#slsinvcedtlsum.provisionquantity = (InventoryReconcile.XhdrQty* v_UOMConversion.ConversionFactor) * InventoryReconcile.ComputedSign
		--select *,InventoryReconcile.XhdrQty* v_UOMConversion.ConversionFactor
FROM #slsinvcedtlsum
INNER JOIN InventoryReconcile (nolock)
ON	#slsinvcedtlsum.XHdrID = InventoryReconcile.InvntryRcncleSrceID
AND	#slsinvcedtlsum.AccntngPrdID = InventoryReconcile.InvntryRcncleClsdAccntngPrdID
AND	InventoryReconcile.InvntryRcncleSrceTble = 'X'
AND #slsinvcedtlsum.DtlDlHdrID = InventoryReconcile.DlHdrID
Inner Join v_uomconversion  
       on FromUOM = 3  
       and ToUOM = 2
--where	IsTopLevel = 1

--Let's update the Top level volume for time transactions.  This is done because of the summed table above and the grouping logic.
--Multiplying volume *-1, because it is switched back in the final select statement due to pulling from InventoryReconcile Transacton Volumes.
UPDATE	#slsinvcedtlsum
SET		#slsinvcedtlsum.DtlTrnsctnQntty = (AccountDetail.volume * v_UOMConversion.ConversionFactor) * -1  
		,#slsinvcedtlsum.provisionquantity = (AccountDetail.volume * v_UOMConversion.ConversionFactor) * -1
--SELECT	#slsinvcedtlsum.XHdrID, SUM(volume * v_UOMConversion.ConversionFactor)
FROM #slsinvcedtlsum
  Inner Join TimeTransactionDetailLog
    on TimeTransactionDetailLog.TmeXDtlLgTmeXDtlIdnty = #slsinvcedtlsum.XHdrID
  Inner Join AccountDetail
    on AccountDetail.AcctDtlID = TimeTransactionDetailLog.TmeXDtlLgAcctDtlID
   and AccountDetail.AcctDtlAccntngPrdID = @i_AccntngPrdID
   and AccountDetail.AcctDtlsrcetble = 'TT'
   --and AccountDetail.ExternalBAID = DealHeader.DlHdrExtrnlBaid
   Inner Join v_uomconversion  
       on FromUOM = 3  
       and ToUOM = 2
where #slsinvcedtlsum.DtlTrnsctnQntty IS NULL

--select * from #slsinvcedtl order by xhdrid, 
--update #slsinvcedtl set istoplevel = 0
--select * from #toplevel where xhdrid in ( 158880,158900) order by xhdrid


/*-----------------------------------------------------------   

-- Return temp table data to datawindow  

-----------------------------------------------------------*/  
SELECT  distinct DtlSlsInvceHdrID,  
   XHdrID,  
   DtlDlHdrID,  
   DtlDlHdrExtrnlNbr,  
   DtlDlHdrIntrnlNbr,  
   DtlDlHdrExtrnlCntctID,  
   DtlPrntPrdctID,  
   Product,  
   DtlChldPrdctID,  
   Chemical,  
   DtlOrgnLcleID,  
   DtlDstntnLcleID,  
   DtlFOBLcleID,  
   isnull(DtlTrnsctnVle,0.0) ,
   --DtlTrnsctnVle / isnull(DtlTrnsctnQntty,1) DtlPrUntVle,  
  DtlPrUntVle,
   DtlTrnsctnQntty * -1 AS DtlTrnsctnQntty,
   DtlTrnsctnTypID,  
   DtlMvtDcmntExtrnlDcmnt,  
   DtlMvtHdrDte,  
   DtlMvtHdrTyp,  
   DtlMvtHdrTypNme,  
   DtlSpplyDmnd,  
   DtlCrrncyID,  
   -DtlStrtngBlnce,  
   DtlMvtHdrVhcleID,  
   -SttmntEndngBlnce,  
   TrnsctnTypCtgry,  
   AccntngPrdID,  
   ProductOrder,  
   SttmntBlnceTotal,  
   DlDtlDsplyUOMID,  
   UOMAbbv,  
   LeaseName,  
   MvtDcmntIssuedBy,  
   HdrID,  
   HdrPrntID,  
   OriginLcleNme,  
   DestinationLcleNme,  
   FOBLcleNme,  
   ContractContact,  
   DeliveryTerm,  
   IsAdjustment,
   RemitToInstructions,
   TransactionDescription,
   ProvisionQuantity * -1 AS ProvisionQuantity,
   IsTopLevel
FROM #slsinvcedtlsum
UNION ALL
SELECT distinct DtlSlsInvceHdrID,  
   XHdrID,  
   DtlDlHdrID,  
   DtlDlHdrExtrnlNbr,  
   DtlDlHdrIntrnlNbr,  
   DtlDlHdrExtrnlCntctID,  
   DtlPrntPrdctID,  
   Product,  
   DtlChldPrdctID,  
   Chemical,  
   DtlOrgnLcleID,  
   DtlDstntnLcleID,  
   DtlFOBLcleID,  
   0,
   0,
   CASE WHEN DtlSpplyDmnd = 'D' THEN DtlTrnsctnQntty * -1 ELSE DtlTrnsctnQntty END AS DtlTrnsctnQntty, --* -1 AS DtlTrnsctnQntty,
   DtlTrnsctnTypID,  
   DtlMvtDcmntExtrnlDcmnt,  
   DtlMvtHdrDte,  
   DtlMvtHdrTyp,  
   DtlMvtHdrTypNme,  
   DtlSpplyDmnd,  
   DtlCrrncyID,  
   -DtlStrtngBlnce,  
   DtlMvtHdrVhcleID,  
   -SttmntEndngBlnce,  
   TrnsctnTypCtgry,  
   AccntngPrdID,  
   ProductOrder,  
   SttmntBlnceTotal,  
   DlDtlDsplyUOMID,  
   UOMAbbv,  
   LeaseName,  
   MvtDcmntIssuedBy,  
   HdrID,  
   HdrPrntID,  
   OriginLcleNme,  
   DestinationLcleNme,  
   FOBLcleNme,  
   ContractContact,  
   DeliveryTerm,  
   IsAdjustment,
   RemitToInstructions,
   TransactionDescription,
   CASE WHEN  DtlSpplyDmnd = 'D' THEN ProvisionQuantity * -1 ELSE ProvisionQuantity END AS ProvisionQuantity, --* -1 AS ProvisionQuantity,
   1
FROM #slsinvcedtl
where isnull(#slsinvcedtl.DtlTrnsctnTypID,'') = ''     --no transactiondetail (provision)
 and DtlTrnsctnQntty <> 0
Order by Product, isadjustment, DtlSpplyDmnd desc, DtlMvtHdrDte, DtlMvtDcmntExtrnlDcmnt, IsTopLevel desc, DtlMvtHdrTypNme,TransactionDescription
 
GO

IF  OBJECT_ID(N'[dbo].[sp_MPC_Statement_Detail_Mtv_TA]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MPC_Statement_Detail_Mtv_TA.sql'
	PRINT '<<< ALTERED StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MPC_Statement_Detail_Mtv_TA >>>'
END
 
GO