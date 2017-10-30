/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_details_mtv2 WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_details_mtv2_fsm]   Script Date: DATECREATED ******/
PRINT 'Start Script=[sp_invoice_template_details_mtv2_fsm].sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv2_fsm]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_details_mtv2_fsm] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure [sp_invoice_template_details_mtv2_fsm] >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_details_mtv2_fsm]    Script Date: 5/16/2016 11:48:12 PM ******/
SET ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER OFF
GO


ALTER  Procedure [dbo].[sp_invoice_template_details_mtv2_fsm] @i_slsinvcehdrid int, @c_showsql char(1) = 'N'
As
--select * from salesinvoiceheader where slsinvcehdrnmbr = '1600156905'
--select * from salesinvoiceheader where slsinvcehdrid = 156957
--exec sp_invoice_template_details_mtv2_fsm 156957,'y'
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_details 24          Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	@i_slsinvcehdrid	Sales Invoice Header ID
-- SPs:
-- Temp Tables:
-- Created by:	
-- History:	5/7/2002 - First Created
--
-- 	Date Modified 	Modified By	    Issue#	Modification
-- 	--------------- -------------- 	------	---------------------------------------------------------------------------------------
--  9/13/2016       DLK             2012    Gross/Net Indicator does not show on each line item
--                                  2073    Gross should not be displayed as the Billed Quantity on Page 2
--                                  
--  9/15/2016       DLK             2071    Collection Allowance should show the calculated rate from Accounting Transactions
--                                  
--  9/20/2016       DLK             23??    If sales tax then set taxtype to 'S' else set to taxtype.  We don't include taxtype 'S'
--                                          in perunit totals so need to exclude
----------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON

Declare @vc_value varchar(10),
	@i_DecimalPlaces int,
	@vc_UOMAbbv varchar(10),
	@vc_Key varchar(50),
	@vc_sql_select1 varchar(8000),		-- 65163
	@vc_sql_from1 varchar(8000),		-- 65163
	@vc_sql_where1 varchar(8000),		-- 65163
	@vc_sql_select2 varchar(8000),		-- 65163
	@vc_sql_from2 varchar(8000),		-- 65163
	@vc_sql_where2 varchar(8000),		-- 65163
	@vc_sql_orderby varchar(8000),
	@vc_pre varchar(8000)



select XgrpName, XTpeGrpXGrpID, TrnsctnTypID into #allowanceTG
         	          from TransactionType TT 
	                        inner join TransactionTypeGroup TGT on TGT.XTpeGrpTrnsctnTypID = TT.TrnsctnTypID
	                        inner join TransactionGroup allowanceTG on allowanceTG.XGrpID = TGT.XTpeGrpXGrpID
	                                        and allowanceTG.XGrpName = 'Collection Allowance for Invoice Printing'


select XgrpName, XTpeGrpXGrpID, TrnsctnTypID into #salesTaxTG
         	          from TransactionType TT 
	                        inner join TransactionTypeGroup TGT on TGT.XTpeGrpTrnsctnTypID = TT.TrnsctnTypID
	                        inner join TransactionGroup salesTaxTG on salesTaxTG.XGrpID = TGT.XTpeGrpXGrpID
	                                        and salesTaxTG.XGrpName = 'Sales Tax for Invoice Printing'


create table #tempseqno
( idx int identity(1,1), seqno int, PlantCodeName varchar(300), MvtDcmntExtrnlDcmntNbr varchar(80), LineNumber int )

Insert into #tempseqno
select  0 seqno,  isnull(PlantCode.GnrlCnfgMulti,'') PlantCodeName,MovementDocument.MvtDcmntExtrnlDcmntNbr, MH.LineNumber
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
	     Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				<>	'T'
		 Inner Join transactiondetaillog on XDtlLgAcctDtlID = AccountDetail.AcctDtlid
		 Inner Join DealDetailProvision on dldtlprvsnid = XDtlLgXDtlDlDtlPrvsnID
         Inner Join Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.crrncyid
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID 		= 	ChildProduct.PrdctID
		 Inner Join Product				On SalesInvoiceDetail.SlsInvceDtlPrntPrdctID = Product.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID	 			= 	UnitOfMeasure.UOM
         Left Outer Join Contact 			On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Left Outer Join	TransactionDetail	(NoLock) On	TransactionDetail. XDtlXHdrID 				= TransactionDetailLog. XDtlLgXDtlXHdrID
								and	TransactionDetail. XDtlDlDtlPrvsnID 		= TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID
								and	TransactionDetail. XDtlID 			= TransactionDetailLog. XDtlLgXDtlID
		 Left Outer Join	TransactionHeader	(NoLock) On	TransactionDetailLog. XDtlLgXDtlXHdrID			= TransactionHeader. XHdrID
		 Left Outer Join MovementHeader MH On TransactionHeader.XHdrMvtDtlMvtHdrID = MH.MvtHdrID
		 Left Outer Join MovementDocument on MvtDcmntID = MH.MvtHdrMvtDcmntID
		 Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
		 left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = 'SapPlantCode'
												  and PlantCode.GnrlcnfgTblNme = 'Locale'
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	 = @i_slsinvcehdrid
     and DealDetailProvision.CostType = 'P'
	 group by isnull(PlantCode.GnrlCnfgMulti,'') ,MovementDocument.MvtDcmntExtrnlDcmntNbr, MH.LineNumber
order by isnull(PlantCode.GnrlCnfgMulti,'') ,MovementDocument.MvtDcmntExtrnlDcmntNbr, MH.LineNumber


Insert into #tempseqno
select  0 seqno,  '',MovementDocument.MvtDcmntExtrnlDcmntNbr + ' For All LineItems', 0
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
	     Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				=	'T'
		 Inner Join TaxDetailLog on TxDtlLgID = AccountDetail.AcctDtlSrceID and AccountDetail.AcctDtlSrceTble = 'T'
		 inner join TaxDetail On TxDtlID = TxDtlLgTxDtlID 
         Inner Join Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.crrncyid
    	 left outer join DealDetailProvision TaxDDP on TAXDDP.DlDtlPrvsnID = TaxDetail.DlDtlPrvsnID
	     left outer join Prvsn TaxPrvsn     On  TaxPrvsn.PrvsnID = TaxDDP.DlDtlPrvsnPrvsnID
	     Inner Join TransactionHeader       On  TransactionHeader.XhdrID = TaxDetail.TxdtlXhdrID
	     left outer join PlannedTransfer on PlnndTrnsfrID = TransactionHeader.XHdrPlnndTrnsfrID
	     left outer join TaxRuleSet on taxDetail.TxID = TaxRuleSet.TxID
	                             and TaxDetail.TxRleStID = TaxRuleSet.TxRleStID
	     left outer join MovementDocument on MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	     left outer join MovementHeader MH on MH.MvtHdrMvtDcmntID = MovementDocument.MvtDcmntID
	 	                                  and MH.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	 = @i_slsinvcehdrid
	 group by MovementDocument.MvtDcmntExtrnlDcmntNbr + ' For All LineItems'


declare @seqno int = 0
declare @idx int = 0
select @idx = ( Select top 1 idx from #tempseqno order by plantcodename, MvtDcmntExtrnlDcmntNbr , LineNumber )
while @idx is not null
begin
  set @seqno = @seqno + 1
  update #tempseqno set seqno = @seqno where idx = @idx
   select @idx = ( Select top 1 idx from #tempseqno where isnull(seqno,0) = 0 order by plantcodename, MvtDcmntExtrnlDcmntNbr , LineNumber )
end  
select distinct acctdtlid,
	       dbo.MTV_FN_GetUOMConversionFactorSQLAsValue(convert(int,GeneralConfiguration.GnrlCnfgMulti),AccountDetail.AcctDtlUOMID, SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty, coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)) conversionFactor, AccountDetail.AcctDtlSrceTble, 'Y' TaxOnly
 into #uomconversion
From AccountDetail
         Inner Join SalesInvoiceDetail  on SlsInvceDtlAcctDtlID = accountdetail.acctdtlid
	     Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme		=	'System'		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	'DBMSUOM'	-- 65163
		 left outer Join transactiondetaillog on XDtlLgAcctDtlID = AccountDetail.AcctDtlid
		 left outer join TransactionHeader on transactionheader.xhdrid = XDtlLgXDtlXHdrID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID 		= 	ChildProduct.PrdctID
Where Accountdetail.AcctDtlSlsInvceHdrid = @i_slsinvcehdrid
  and AccountDetail.AcctDtlSrceTble <> 'T'

--now tax
insert into #uomconversion
select distinct acctdtlid, dbo.MTV_FN_GetUOMConversionFactorSQLAsValue(convert(int,GeneralConfiguration.GnrlCnfgMulti),AccountDetail.AcctDtlUOMID, SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty, coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)) conversionFactor, AccountDetail.AcctDtlSrceTble,'Y'
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				= 	'T'
         Inner Join Currency Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.CrrncyID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID		= 	ChildProduct.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID				= 	UnitOfMeasure.UOM
         Inner Join Contact 				On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
	     Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme		=	'System'		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	'DBMSUOM'	-- 65163
	 Inner Join TaxDetailLog			On	TaxDetailLog.TxDtlLgID 					= 	AccountDetail.AcctDtlSrceID
	 Inner Join TaxDetail				On	TaxDetail.TxDtlID					= 	TaxDetailLog.TxDtlLgTxDtlID
	 Inner Join TransactionHeader       On  TransactionHeader.XhdrID = TaxDetail.TxdtlXhdrID
	 left outer join TaxRuleSet on taxDetail.TxID = TaxRuleSet.TxID
	                             and TaxDetail.TxRleStID = TaxRuleSet.TxRleStID
	 left outer join MovementDocument on MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	 left outer join MovementHeader MH on MH.MvtHdrMvtDcmntID = MovementDocument.MvtDcmntID
Where accountdetail.acctdtlslsinvcehdrid = @i_slsinvcehdrid
 and AccountDetail.AcctDtlSrceTble = 'T'


 Update #uomconversion
 set taxonly = 'N'
 where exists  ( select 'x' from #uomconversion where AcctDtlSrceTble <> 'T' )
 



--select @vc_sql_select1 = '
 SELECT '0' RecordType
	 , SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 'ContractNumberInternal'
	 , MTVSAPBASoldTo.SoldTo -- SAPCustomerNumber.GnrlCnfgMulti 'ContractNumberExternal'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) 'OriginLcleID'
	 , Isnull(Origin. LcleAbbrvtn + Origin. LcleAbbrvtnExtension,'') 'Origin'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 'DestinationLcleID'
	 , Isnull(Destination. LcleAbbrvtn + Destination. LcleAbbrvtnExtension,'') 'Destination'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 'TransferPointLcleID'
	 , Case  
	      When  DynamicListBox.DynLstBxAbbv  is null then ''
	      Else Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'')
	    End 'TransferPoint'
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ExternalContact'
         , SalesInvoiceDetail.SlsInvceDtlMvtHdrDte 'TransactionDate'
         , (isnull(TransactionHeader.XHdrQty,0) * #UOMConversion.conversionFactor)
         , (isnull(TransactionHeader.XHdrGrssQty,0) * #UOMConversion.conversionFactor) 
		 , round( ( (accountdetail.Value) / (accountdetail.volume))  *     1/(isnull(#uomconversion.conversionFactor,1)), SalesInvoiceDetail.PerUnitDecimals)  * -1 
         , sum ( SalesInvoiceDetail.SlsInvceDtlTrnsctnVle  ) 'dtltrnsctnvle'
         , ( slsinvcedtltrnsctnqntty) volume
		 , DynamicListBox.DynLstBxDesc 'DeliveryTerm'
         , case when DealDetailProvision.CostType = 'P' then 'Unit Price' else TransactionType.TrnsctnTypDesc  end 'Description'
         , max(SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty) 'SpecificGravity'
         , UnitOfMeasure.UOMABBV 'UOMDesc'
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 'UOMSingularDesc'
         , Currency.CrrncySmbl 'Currency'
         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID 'PrdctID'
         , case when PlannedTransfer.PlnndTrnsfrLneUpSmmry is not null then PlannedTransfer.PlnndTrnsfrLneUpSmmry else MovementDocument.MvtDcmntExtrnlDcmntNbr end 'ExtMovementDocument'
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 'DetailType'
	 , SalesInvoiceDetail.PerUnitDecimals
	 , 2 --SalesInvoiceDetail.QuantityDecimals
	 , 1 converstionfactor
	, UnitOfMeasure.UOMAbbv
	, ChildProduct.PrdctEnrgy 'Energy'
	, SapMatcode.GnrlcnfgMulti   SapMaterialCode
	, isnull(SCACCode.GnrlcnfgMulti,' ') 
	, isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') 
	, 'Plant ' + isnull(PlantCode.GnrlCnfgMulti,'N/A') 
	, DealDetailProvision.CostType 
	, isnull(Carrier.Baabbrvtn,' ') 
	, '' Taxruletype
    , Product.prdctnme  
    , #tempseqno.seqno

    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + ', ' +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  
    , case transactiondetail.quantitybasis when 'N' then 'Net' when 'G' then 'Gross' else '' end 
    , ''
    ,''
    , null
    ,MH.LineNumber
	,#UomConversion.TaxOnly
	
	
	

--select @vc_sql_from1 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
	     Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				<> 	'T'
		 Inner Join transactiondetaillog on XDtlLgAcctDtlID = AccountDetail.AcctDtlid
		 Inner Join DealDetailProvision on dldtlprvsnid = XDtlLgXDtlDlDtlPrvsnID
         Inner Join Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.crrncyid
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID 		= 	ChildProduct.PrdctID
		 Inner Join Product				On SalesInvoiceDetail.SlsInvceDtlPrntPrdctID = Product.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID	 			= 	UnitOfMeasure.UOM
         inner join #uomconversion on #uomconversion.acctdtlid = accountdetail.acctdtlid
         Left Outer Join Contact 			On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
	     Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme			=	'System'		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	'DBMSUOM'		-- 65163
         Left outer join GeneralConfiguration SapMatCode on SapMatCode.GnrlcnfgHdrid = AccountDetail.ParentPrdctID
	                                               and SapMatCode.GnrlcnfgQlfr = 'SAPMATERIALCODE'
												   and SapMatCode.GnrlcnfgTblnme = 'Product'
	     Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
	     Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	     Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	     Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	'DealDeliveryTerm'
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID

         left outer join GeneralConfiguration  plantAddrLine1 on plantAddrLine1.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine1.GnrlCnfgTblNme = 'Locale' and plantAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
         left outer join GeneralConfiguration  plantAddrLine2 on plantAddrLine2.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine2.GnrlCnfgTblNme = 'Locale' and plantAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
         left outer join GeneralConfiguration  plantCityName  on plantCityName.GnrlCnfgHdrID = origin.lcleid  and plantCityName.GnrlCnfgTblNme = 'Locale' and plantCityName.GnrlCnfgQlfr = 'CityName'
         left outer join GeneralConfiguration  plantStateAbbreviation on plantStateAbbreviation.GnrlCnfgHdrID = origin.lcleid  and plantStateAbbreviation.GnrlCnfgTblNme = 'Locale' and plantStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
         left outer join GeneralConfiguration  plantPostalCode on plantPostalCode.GnrlCnfgHdrID = origin.lcleid  and plantPostalCode.GnrlCnfgTblNme = 'Locale' and plantPostalCode.GnrlCnfgQlfr = 'PostalCode'
 	     Left Outer Join	TransactionDetail	(NoLock) On	TransactionDetail. XDtlXHdrID 				= TransactionDetailLog. XDtlLgXDtlXHdrID
								and	TransactionDetail. XDtlDlDtlPrvsnID 		= TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID
								and	TransactionDetail. XDtlID 			= TransactionDetailLog. XDtlLgXDtlID
	Left Outer Join	TransactionHeader	(NoLock) On	TransactionDetailLog. XDtlLgXDtlXHdrID			= TransactionHeader. XHdrID
    Left Outer Join PlannedTransfer On PlannedTransfer.PlnndTrnsfrId = TransactionHeader.XHdrPlnndTrnsfrID
	Left Outer Join MovementHeader MH On TransactionHeader.XHdrMvtDtlMvtHdrID = MH.MvtHdrID
	Left Outer Join MovementDocument on MvtDcmntID = MH.MvtHdrMvtDcmntID
	Left outer join businessassociate carrier on carrier.baid = MH.MvtHdrCrrrBAID
	Left Outer Join dbo.GeneralConfiguration	as SCACCode	on SCACCode.GnrlCnfgHdrID = mh.MvtHdrCrrrBAID --mh.MvtHdrID
								and  SCACCode.GnrlCnfgTblNme = 'BusinessAssociate'  --'MovementHeader'
								and  SCACCode.GnrlCnfgQlfr = 'SCAC' 
	inner join dealdetail on dealdetail.dldtldlhdrid = accountdetail.AcctDtlDlDtlDlHdrID
	                     and dealdetail.dldtlid = accountdetail.AcctDtlDlDtlID
	Left Outer JOIN	GeneralConfiguration AS SAPSoldTO on	accountdetail.AcctDtlDlDtlDlHdrID = SAPSoldTO.GnrlCnfgHdrID
                                                 AND	SAPSoldTO.GnrlCnfgTblNme = 'DealHeader'
                                                 AND	SAPSoldTO.GnrlCnfgQlfr = 'SAPSoldTo'
                                                 AND	SAPSoldTO.GnrlCnfgHdrID <> 0
    LEFT OUTER JOIN MTVSAPBASoldTo ON	SAPSoldTO.GnrlCnfgMulti = convert(varchar,MTVSAPBASoldTo.ID)
	left outer join GeneralConfiguration MvtShipto on MvtShipto.GnrlcnfgHdrID = MH.MvtHdrID
	                                              and MvtShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo'
	                                              and MvtShipTo.GnrlCnfgTblNme = 'MovementHeader'
    left outer join MTVSAPSoldToShipTo on MTVSAPSoldToShipTo.MTVSAPBASoldToID = MTVSAPBASoldTo.id 
                                                   and MTVSAPSoldToShipTo.Shipto = MvtShipTo.GnrlcnfgMulti
	left outer join MTVDealDetailShipTo on MTVDealDetailShipTo.DealDetailID = dealdetail.dealdetailid
	                                         and mtvdealdetailshipto.SoldToShipToID = mtvsapsoldtoshipto.id
	left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = 'SapPlantCode'
												  and PlantCode.GnrlcnfgTblNme = 'Locale'
	left outer join #tempseqno on #tempseqno.plantcodename = plantcode.Gnrlcnfgmulti
	                          and #tempseqno.MvtDcmntExtrnlDcmntNbr = MovementDocument.MvtDcmntExtrnlDcmntNbr
	                          and #tempseqno.LineNumber = MH.LineNumber
	                          

--select @vc_sql_where1 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	= @i_slsinvceHdrID 
 Group BY
     #tempseqno.seqno
	,   SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 
	 , MTVSAPBASoldTo.SoldTo 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) 
	 , Isnull(Origin. LcleAbbrvtn + Origin. LcleAbbrvtnExtension,'') 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 
	 , Isnull(Destination. LcleAbbrvtn + Destination. LcleAbbrvtnExtension,'') 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 
	 , Case  
	      When  DynamicListBox.DynLstBxAbbv  is null then ''
	      Else Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'')
	    End 
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 
         , SalesInvoiceDetail.SlsInvceDtlMvtHdrDte 
         , SalesInvoiceDetail.SlsInvceDtlPrUntVle
		 , DynamicListBox.DynLstBxDesc 
         , case when DealDetailProvision.CostType = 'P' then 'Unit Price' else TransactionType.TrnsctnTypDesc end
         , UnitOfMeasure.UOMABBV
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 
         , Currency.CrrncySmbl 
         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID 
         , case when PlannedTransfer.PlnndTrnsfrLneUpSmmry is not null then PlannedTransfer.PlnndTrnsfrLneUpSmmry else MovementDocument.MvtDcmntExtrnlDcmntNbr end
		         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 
	 , SalesInvoiceDetail.PerUnitDecimals
		 , round( ( (accountdetail.Value) / (accountdetail.volume))  *     1/(isnull(#uomconversion.conversionFactor,1)), SalesInvoiceDetail.PerUnitDecimals)  * -1 
	, UnitOfMeasure.UOMAbbv
	, ChildProduct.PrdctEnrgy 
	, SapMatcode.GnrlcnfgMulti   
	, isnull(SCACCode.GnrlcnfgMulti,' ') 
	, isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') 
	, 'Plant ' + isnull(PlantCode.GnrlCnfgMulti,'N/A') 
	, DealDetailProvision.CostType  
	, isnull(Carrier.Baabbrvtn,' ') 
    , Product.prdctnme  
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + ', ' +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' +  isnull(plantPostalCode.GnrlcnfgMulti,'')
    , case transactiondetail.quantitybasis when 'N' then 'Net' when 'G' then 'Gross' else '' end 
    ,MH.LineNumber
	,#UomConversion.TaxOnly
	,TransactionHeader.XHdrQty
	,TransactionHeader.XHdrGrssQty
	,#uomconversion.conversionFactor
	,SalesInvoiceDetail.SlsInvceDtlTrnsctnQntty


--select @vc_sql_select2 = '

UNION ALL

 SELECT  '1' 'RecordType'
	 , SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 'ContractNumberInternal'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlNbr,'') 'ContractNumberExternal'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) 'OriginLcleID'
	 , Isnull(Origin. LcleAbbrvtn + Origin. LcleAbbrvtnExtension,'') 'Origin'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 'DestinationLcleID'
	 , null 'Destination'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 'TransferPointLcleID'
	 , Case  
	      	When  DynamicListBox.DynLstBxAbbv  is null then ''
	      	Else Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'')
	    End 'TransferPoint'
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ExternalContact'
     , MH.MvtHdrDte 'TransactionDate'
         , (isnull(TransactionHeader.XHdrQty,0) * isnull(#UOMConversion.conversionFactor,1)) XHdrQty
         , (isnull(TransactionHeader.XHdrGrssQty,0) * isnull(#UOMConversion.conversionFactor,1) ) XHdrGrssQty
         , isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate )
         ,  ( accountdetail.value ) 'dtltrnsctnvle'
         , ( slsinvcedtltrnsctnqntty) volume
		 , DynamicListBox.DynLstBxDesc 'DeliveryTerm'
         , TaxRuleSet.InvoicingDescription 'Description'
         , 0 /*SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty*/ 'SpecificGravity'
         , UnitOfMeasure.UOMABBV 'UOMDesc'
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 'UOMSingularDesc'
           --change back again - now they want currency
--	     , case TaxRuleSet.Type when 'F' then '   ' else Currency.CrrncySmbl end
         , currency.crrncysmbl
         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID 'PrdctID'
         , case when PlannedTransfer.PlnndTrnsfrLneUpSmmry is not null then PlannedTransfer.PlnndTrnsfrLneUpSmmry else MovementDocument.MvtDcmntExtrnlDcmntNbr end 
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 'DetailType'
	 , SalesInvoiceDetail.PerUnitDecimals
	 , 2 --SalesInvoiceDetail.QuantityDecimals 'QuantityDecimalPlaces' -- , @i_DecimalPlaces 'QuantityDecimalPlaces'
	 , 1 
	, case TaxRuleSet.Type when 'F' then '%' else UnitOfMeasure.UOMAbbv end
	, ChildProduct.PrdctEnrgy 'Energy'
	, SapMatcode.GnrlcnfgMulti   SapMaterialCode
	, isnull(SCACCode.GnrlcnfgMulti,' ') scac
	, isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') ShipTo
	, 'Plant ' + isnull(PlantCode.GnrlCnfgMulti,'N/A') plantcode
	, 'S' costtype 
	, isnull(Carrier.Baabbrvtn,' ') Carrier
	, case when salesTaxTG.XgrpName Is not null then 'S' else 'M' end --TaxruleSet.Type
    , Product.prdctnme  'ProductDescription'
    , #tempseqno.seqno
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + ', ' +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  PlantAddress
    , case TaxDetail.QuantityBasis When 'N' then 'Net' when 'G' then 'Gross' when 'V' then
	       case transactionDetail.QuantityBasis when 'N' then 'Net' When 'G' then 'Gross' else '' end end
    ,''
    ,''
    , null
    ,MH.LineNumber
	,#uomconversion.TaxOnly



--select	@vc_sql_from2 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				= 	'T'
         Inner Join Currency 			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.CrrncyID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID		= 	ChildProduct.PrdctID
		 Inner Join Product				On SalesInvoiceDetail.SlsInvceDtlPrntPrdctID = Product.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID				= 	UnitOfMeasure.UOM
         Inner Join Contact 				On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
         left outer join #uomconversion on #uomconversion.acctdtlid = accountdetail.acctdtlid
	 Inner Join TaxDetailLog			On	TaxDetailLog.TxDtlLgID 					= 	AccountDetail.AcctDtlSrceID
	 Inner Join TaxDetail				On	TaxDetail.TxDtlID					= 	TaxDetailLog.TxDtlLgTxDtlID
	 left outer join DealDetailProvision TaxDDP on TAXDDP.DlDtlPrvsnID = TaxDetail.DlDtlPrvsnID
	 left outer join Prvsn TaxPrvsn     On  TaxPrvsn.PrvsnID = TaxDDP.DlDtlPrvsnPrvsnID
	 Inner Join TransactionHeader       On  TransactionHeader.XhdrID = TaxDetail.TxdtlXhdrID
	 left outer join PlannedTransfer on PlnndTrnsfrID = TransactionHeader.XHdrPlnndTrnsfrID
	 left outer join TaxRuleSet on taxDetail.TxID = TaxRuleSet.TxID
	                             and TaxDetail.TxRleStID = TaxRuleSet.TxRleStID
	 left outer join MovementDocument on MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	 left outer join MovementHeader MH on MH.MvtHdrMvtDcmntID = MovementDocument.MvtDcmntID
	 	                                  and MH.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
     Left outer join businessassociate carrier on carrier.baid = MH.MvtHdrCrrrBAID
	 Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	 Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	 Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	'DealDeliveryTerm'
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
	 Left Outer Join dbo.GeneralConfiguration	as SCACCode	on SCACCode.GnrlCnfgHdrID = mh.MvtHdrCrrrBAID --mh.MvtHdrID
								and  SCACCode.GnrlCnfgTblNme = 'BusinessAssociate'  
								and  SCACCode.GnrlCnfgQlfr = 'SCAC' 
	 left outer join dealdetail on dealdetail.dldtldlhdrid = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
	                     and dealdetail.dldtlid = PlannedTransfer.PlnndTrnsfrObDlDtlID
	 left outer join transactiondetail on  TransactionDetail.XDtlXHdrID = TaxDetail.TxdtlXhdrID
 	                                  and TransactionDetail.XDtlDlDtlPrvsnID = ( select top 1 PrimaryProvision.DlDtlPrvsnID 
									                                              From DealDetailProvision PrimaryProvision
																				  Where PrimaryProvision.DlDtlPrvsnDlDtlDlHdrID = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
																				     and PrimaryProvision.DlDtlPrvsnDlDtlID = PlannedTransfer.PlnndTrnsfrObDlDtlID
																					 and PrimaryProvision.CostType = 'P'
																					 )
                                      and XDtlLstInChn = 'Y'
     left outer join GeneralConfiguration  plantAddrLine1 on plantAddrLine1.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine1.GnrlCnfgTblNme = 'Locale' and plantAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
     left outer join GeneralConfiguration  plantAddrLine2 on plantAddrLine2.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine2.GnrlCnfgTblNme = 'Locale' and plantAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
     left outer join GeneralConfiguration  plantCityName  on plantCityName.GnrlCnfgHdrID = origin.lcleid  and plantCityName.GnrlCnfgTblNme = 'Locale' and plantCityName.GnrlCnfgQlfr = 'CityName'
     left outer join GeneralConfiguration  plantStateAbbreviation on plantStateAbbreviation.GnrlCnfgHdrID = origin.lcleid  and plantStateAbbreviation.GnrlCnfgTblNme = 'Locale' and plantStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
     left outer join GeneralConfiguration  plantPostalCode on plantPostalCode.GnrlCnfgHdrID = origin.lcleid  and plantPostalCode.GnrlCnfgTblNme = 'Locale' and plantPostalCode.GnrlCnfgQlfr = 'PostalCode'
     Left Outer JOIN	GeneralConfiguration AS SAPSoldTO on	accountdetail.AcctDtlDlDtlDlHdrID = SAPSoldTO.GnrlCnfgHdrID
                                                 AND	SAPSoldTO.GnrlCnfgTblNme = 'DealHeader'
                                                 AND	SAPSoldTO.GnrlCnfgQlfr = 'SAPSoldTo'
                                                 AND	SAPSoldTO.GnrlCnfgHdrID <> 0
    LEFT OUTER JOIN MTVSAPBASoldTo ON	SAPSoldTO.GnrlCnfgMulti = convert(varchar,MTVSAPBASoldTo.ID)
	left outer join GeneralConfiguration MvtShipto on MvtShipto.GnrlcnfgHdrID = MH.MvtHdrID
	                                              and MvtShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo'
	                                              and MvtShipTo.GnrlCnfgTblNme = 'MovementHeader'
    left outer join MTVSAPSoldToShipTo on MTVSAPSoldToShipTo.MTVSAPBASoldToID = MTVSAPBASoldTo.id 
                                                   and MTVSAPSoldToShipTo.Shipto = MvtShipTo.GnrlcnfgMulti
	left outer join MTVDealDetailShipTo on MTVDealDetailShipTo.DealDetailID = dealdetail.dealdetailid
	                                         and mtvdealdetailshipto.SoldToShipToID = mtvsapsoldtoshipto.id
	     Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme			=	'System'		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	'DBMSUOM'		-- 65163

    Left outer join GeneralConfiguration SapMatCode on SapMatCode.GnrlcnfgHdrid = AccountDetail.ParentPrdctID
	                                               and SapMatCode.GnrlcnfgQlfr = 'SAPMATERIALCODE'
												   and SapMatCode.GnrlcnfgTblnme = 'Product'

	left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = 'SapPlantCode'
												  and PlantCode.GnrlcnfgTblNme = 'Locale'
	left outer join #tempseqno on #tempseqno.plantcodename = plantcode.Gnrlcnfgmulti
	                          and #tempseqno.MvtDcmntExtrnlDcmntNbr = MovementDocument.MvtDcmntExtrnlDcmntNbr
	                          and #tempseqno.LineNumber = MH.LineNumber
	                          
    LEFT OUTER JOIN v_MTV_TaxRates ON v_MTV_TaxRates.acctdtlid = accountdetail.acctdtlid
    left outer join MTV_AccountDetailTaxRateArchive on MTV_AccountDetailTaxRateArchive.AcctDtlID = AccountDetail.AcctDtlID
	left outer join #allowanceTG allowanceTG on allowanceTG.TrnsctntypID = AccountDetail.AcctDtlTrnsctnTypID
    left outer join #salesTaxTG SalesTaxTG on salesTaxTG.TrnsctntypID = AccountDetail.AcctDtlTrnsctnTypID


	

--select @vc_sql_where2 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	= @i_slsinvceHdrID 
     and TaxPrvsn.IsFlatFee = 'N'
    group by  SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlNbr,'') 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0)
	 , Isnull(Origin. LcleAbbrvtn + Origin. LcleAbbrvtnExtension,'') 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 
	 , Case  
	      	When  DynamicListBox.DynLstBxAbbv  is null then ''
	      	Else Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'')
	    End 
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 
     , MH.MvtHdrDte 
         , (isnull(TransactionHeader.XHdrQty,0) * isnull(#UOMConversion.conversionFactor,1))
         , (isnull(TransactionHeader.XHdrGrssQty,0) * isnull(#UOMConversion.conversionFactor,1) )
         , isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate )
	     , accountdetail.value
         , ( slsinvcedtltrnsctnqntty) 
		 , DynamicListBox.DynLstBxDesc 
         , TaxRuleSet.InvoicingDescription 
         , UnitOfMeasure.UOMABBV
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 
       --	, case TaxRuleSet.Type when 'F' then '   ' else Currency.CrrncySmbl end
         , currency.crrncysmbl

         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID 
         , case when PlannedTransfer.PlnndTrnsfrLneUpSmmry is not null then PlannedTransfer.PlnndTrnsfrLneUpSmmry else MovementDocument.MvtDcmntExtrnlDcmntNbr end 
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 
	 , SalesInvoiceDetail.PerUnitDecimals
	, case TaxRuleSet.Type when 'F' then '%' else UnitOfMeasure.UOMAbbv end
	, ChildProduct.PrdctEnrgy 
	, SapMatcode.GnrlcnfgMulti   
	, isnull(SCACCode.GnrlcnfgMulti,' ') 
	, isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') 
	, 'Plant ' + isnull(PlantCode.GnrlCnfgMulti,'N/A') 
	, isnull(Carrier.Baabbrvtn,' ') 
	, case when salesTaxTG.XgrpName Is not null then 'S' else 'M' end 
    , Product.prdctnme  
    , #tempseqno.seqno
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + ', ' +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  
    , case TaxDetail.QuantityBasis When 'N' then 'Net' when 'G' then 'Gross' when 'V' then
	       case transactionDetail.QuantityBasis when 'N' then 'Net' When 'G' then 'Gross' else '' end end
    ,MH.LineNumber
	,#uomconversion.TaxOnly
    
    
UNION ALL    
    
 SELECT  '2' 'RecordType'
	 , SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 'ContractNumberInternal'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlNbr,'') 'ContractNumberExternal'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) 'OriginLcleID'
	 , Isnull(Origin. LcleAbbrvtn + Origin. LcleAbbrvtnExtension,'') 'Origin'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 'DestinationLcleID'
	 , null 'Destination'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 'TransferPointLcleID'
	 , Case  
	      	When  DynamicListBox.DynLstBxAbbv  is null then ''
	      	Else Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'')
	    End 'TransferPoint'
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ExternalContact'
     , MIN(MH.MvtHdrDte) 'TransactionDate'
         , 0 --XHdrQty
         , 0 --XHdrGrssQty
--         , case when taxprvsn.isflatfee = 'Y' then Sum( isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate ) ) else isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate) end
         ,  sum ( isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate ))
--         ,  ( accountdetail.value ) 'dtltrnsctnvle'
	     , sum(accountdetail.value)
         , 0  -- slsinvcedtltrnsctnqntty
		 , DynamicListBox.DynLstBxDesc 'DeliveryTerm'
         , TaxRuleSet.InvoicingDescription 'Description'
         , 0 /*SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty*/ 'SpecificGravity'
         , UnitOfMeasure.UOMABBV 'UOMDesc'
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 'UOMSingularDesc'
           --change back again - now they want currency
--	     , case TaxRuleSet.Type when 'F' then '   ' else Currency.CrrncySmbl end
         , currency.crrncysmbl
--         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID 'PrdctID'
         , 0 --SalesInvoiceDetail.SlsInvceDtlPrntPrdctID

         , movementDocument.MvtDcmntExtrnlDcmntNbr + ' For All LineItems' 
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 'DetailType'
	 , SalesInvoiceDetail.PerUnitDecimals
	 , 2 --SalesInvoiceDetail.QuantityDecimals 'QuantityDecimalPlaces' -- , @i_DecimalPlaces 'QuantityDecimalPlaces'
	 , 1 
	, case TaxRuleSet.Type when 'F' then '%' else UnitOfMeasure.UOMAbbv end
	, 1 --ChildProduct.PrdctEnrgy 'Energy'
	, '' --SapMaterialCode
	, isnull(SCACCode.GnrlcnfgMulti,' ') scac
	, isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') ShipTo
	, 'Plant ' + isnull(PlantCode.GnrlCnfgMulti,'N/A') plantcode
	, 'S' costtype 
	, isnull(Carrier.Baabbrvtn,' ') Carrier
	, case when salesTaxTG.XgrpName Is not null then 'S' else 'M' end --TaxruleSet.Type
    , 'Document Flat Fee' -- 'ProductDescription'
    , #tempseqno.seqno
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + ', ' +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  PlantAddress
    ,'' 
    ,''
    ,''
    , null
    ,0 -- MH.LineNumber end
	,'N'--#uomconversion.TaxOnly



--select	@vc_sql_from2 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				= 	'T'
         Inner Join Currency 			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.CrrncyID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID		= 	ChildProduct.PrdctID
		 Inner Join Product				On SalesInvoiceDetail.SlsInvceDtlPrntPrdctID = Product.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID				= 	UnitOfMeasure.UOM
         Inner Join Contact 				On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
         left outer join #uomconversion on #uomconversion.acctdtlid = accountdetail.acctdtlid
	 Inner Join TaxDetailLog			On	TaxDetailLog.TxDtlLgID 					= 	AccountDetail.AcctDtlSrceID
	 Inner Join TaxDetail				On	TaxDetail.TxDtlID					= 	TaxDetailLog.TxDtlLgTxDtlID
	 left outer join DealDetailProvision TaxDDP on TAXDDP.DlDtlPrvsnID = TaxDetail.DlDtlPrvsnID
	 left outer join Prvsn TaxPrvsn     On  TaxPrvsn.PrvsnID = TaxDDP.DlDtlPrvsnPrvsnID
	 Inner Join TransactionHeader       On  TransactionHeader.XhdrID = TaxDetail.TxdtlXhdrID
	 left outer join PlannedTransfer on PlnndTrnsfrID = TransactionHeader.XHdrPlnndTrnsfrID
	 left outer join TaxRuleSet on taxDetail.TxID = TaxRuleSet.TxID
	                             and TaxDetail.TxRleStID = TaxRuleSet.TxRleStID
	 left outer join MovementDocument on MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	 left outer join MovementHeader MH on MH.MvtHdrMvtDcmntID = MovementDocument.MvtDcmntID
	 	                                  and MH.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
     Left outer join businessassociate carrier on carrier.baid = MH.MvtHdrCrrrBAID
	 Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	 Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	 Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	'DealDeliveryTerm'
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
	 Left Outer Join dbo.GeneralConfiguration	as SCACCode	on SCACCode.GnrlCnfgHdrID = mh.MvtHdrCrrrBAID --mh.MvtHdrID
								and  SCACCode.GnrlCnfgTblNme = 'BusinessAssociate'  
								and  SCACCode.GnrlCnfgQlfr = 'SCAC' 
	 left outer join dealdetail on dealdetail.dldtldlhdrid = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
	                     and dealdetail.dldtlid = PlannedTransfer.PlnndTrnsfrObDlDtlID
	 left outer join transactiondetail on  TransactionDetail.XDtlXHdrID = TaxDetail.TxdtlXhdrID
 	                                  and TransactionDetail.XDtlDlDtlPrvsnID = ( select top 1 PrimaryProvision.DlDtlPrvsnID 
									                                              From DealDetailProvision PrimaryProvision
																				  Where PrimaryProvision.DlDtlPrvsnDlDtlDlHdrID = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
																				     and PrimaryProvision.DlDtlPrvsnDlDtlID = PlannedTransfer.PlnndTrnsfrObDlDtlID
																					 and PrimaryProvision.CostType = 'P'
																					 )
                                      and XDtlLstInChn = 'Y'
     left outer join GeneralConfiguration  plantAddrLine1 on plantAddrLine1.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine1.GnrlCnfgTblNme = 'Locale' and plantAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
     left outer join GeneralConfiguration  plantAddrLine2 on plantAddrLine2.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine2.GnrlCnfgTblNme = 'Locale' and plantAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
     left outer join GeneralConfiguration  plantCityName  on plantCityName.GnrlCnfgHdrID = origin.lcleid  and plantCityName.GnrlCnfgTblNme = 'Locale' and plantCityName.GnrlCnfgQlfr = 'CityName'
     left outer join GeneralConfiguration  plantStateAbbreviation on plantStateAbbreviation.GnrlCnfgHdrID = origin.lcleid  and plantStateAbbreviation.GnrlCnfgTblNme = 'Locale' and plantStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
     left outer join GeneralConfiguration  plantPostalCode on plantPostalCode.GnrlCnfgHdrID = origin.lcleid  and plantPostalCode.GnrlCnfgTblNme = 'Locale' and plantPostalCode.GnrlCnfgQlfr = 'PostalCode'
     Left Outer JOIN	GeneralConfiguration AS SAPSoldTO on	accountdetail.AcctDtlDlDtlDlHdrID = SAPSoldTO.GnrlCnfgHdrID
                                                 AND	SAPSoldTO.GnrlCnfgTblNme = 'DealHeader'
                                                 AND	SAPSoldTO.GnrlCnfgQlfr = 'SAPSoldTo'
                                                 AND	SAPSoldTO.GnrlCnfgHdrID <> 0
    LEFT OUTER JOIN MTVSAPBASoldTo ON	SAPSoldTO.GnrlCnfgMulti = convert(varchar,MTVSAPBASoldTo.ID)
	left outer join GeneralConfiguration MvtShipto on MvtShipto.GnrlcnfgHdrID = MH.MvtHdrID
	                                              and MvtShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo'
	                                              and MvtShipTo.GnrlCnfgTblNme = 'MovementHeader'
    left outer join MTVSAPSoldToShipTo on MTVSAPSoldToShipTo.MTVSAPBASoldToID = MTVSAPBASoldTo.id 
                                                   and MTVSAPSoldToShipTo.Shipto = MvtShipTo.GnrlcnfgMulti
	left outer join MTVDealDetailShipTo on MTVDealDetailShipTo.DealDetailID = dealdetail.dealdetailid
	                                         and mtvdealdetailshipto.SoldToShipToID = mtvsapsoldtoshipto.id
	     Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme			=	'System'		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	'DBMSUOM'		-- 65163

    Left outer join GeneralConfiguration SapMatCode on SapMatCode.GnrlcnfgHdrid = AccountDetail.ParentPrdctID
	                                               and SapMatCode.GnrlcnfgQlfr = 'SAPMATERIALCODE'
												   and SapMatCode.GnrlcnfgTblnme = 'Product'

	left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = 'SapPlantCode'
												  and PlantCode.GnrlcnfgTblNme = 'Locale'
	left outer join #tempseqno on #tempseqno.MvtDcmntExtrnlDcmntNbr = MovementDocument.MvtDcmntExtrnlDcmntNbr + ' For All LineItems'
	                          
    LEFT OUTER JOIN v_MTV_TaxRates ON v_MTV_TaxRates.acctdtlid = accountdetail.acctdtlid
    left outer join MTV_AccountDetailTaxRateArchive on MTV_AccountDetailTaxRateArchive.AcctDtlID = AccountDetail.AcctDtlID
	left outer join #allowanceTG allowanceTG on allowanceTG.TrnsctntypID = AccountDetail.AcctDtlTrnsctnTypID
    left outer join #salesTaxTG SalesTaxTG on salesTaxTG.TrnsctntypID = AccountDetail.AcctDtlTrnsctnTypID


	

--select @vc_sql_where2 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	= @i_slsinvceHdrID 
     and TaxPrvsn.IsFlatFee = 'Y'
    group by  SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 
    , #tempseqno.seqno
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlNbr,'') 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0)
	 , Isnull(Origin. LcleAbbrvtn + Origin. LcleAbbrvtnExtension,'') 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 
	 , Case  
	      	When  DynamicListBox.DynLstBxAbbv  is null then ''
	      	Else Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'')
	    End 
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 
		 , DynamicListBox.DynLstBxDesc 
         , TaxRuleSet.InvoicingDescription 
         , UnitOfMeasure.UOMABBV
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 
         , currency.crrncysmbl

         , movementDocument.MvtDcmntExtrnlDcmntNbr + ' For All LineItems' 
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 
	 , SalesInvoiceDetail.PerUnitDecimals
	, case TaxRuleSet.Type when 'F' then '%' else UnitOfMeasure.UOMAbbv end
	, isnull(SCACCode.GnrlcnfgMulti,' ') 
	, isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') 
	, 'Plant ' + isnull(PlantCode.GnrlCnfgMulti,'N/A') 
	, isnull(Carrier.Baabbrvtn,' ') 
	, case when salesTaxTG.XgrpName Is not null then 'S' else 'M' end 
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + ', ' +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  
    
    
    --select @vc_sql_orderby = '
    order by  39,45,1,35,18  -- lineno,mhlineno,recordtype, costtype, description
	
	
    
 drop table #allowanceTG
drop table #salesTaxTG
drop table #tempseqno
drop table #uomconversion

/*
if upper(@c_showsql) = 'Y'
begin
    select @vc_pre
	select @vc_sql_select1
	select @vc_sql_from1
	select @vc_sql_where1
	select @vc_sql_select2
	select @vc_sql_from2
	select @vc_sql_where2
	select @vc_sql_orderby
end
else
	execute (@vc_pre + @vc_sql_select1 + @vc_sql_from1 + @vc_sql_where1 + @vc_sql_select2 + @vc_sql_from2 + @vc_sql_where2 + @vc_sql_orderby)
*/

GO


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv2_fsm]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_invoice_template_details_mtv2_fsm.sql'
			PRINT '<<< ALTERED StoredProcedure sp_invoice_template_details_mtv2_fsm >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_invoice_template_details_mtv2_fsm >>>'
	  END
