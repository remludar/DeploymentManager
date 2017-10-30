/*
*****************************************************************************************************
USE FIND AND REPLACE ON p_invoice_template_details_mtv2_bulk WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_details_mtv2_bulk]   Script Date: DATECREATED ******/
PRINT 'Start Script=[sp_invoice_template_details_mtv2_bulk].sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv2_bulk]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_details_mtv2_bulk] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure [sp_invoice_template_details_mtv2_bulk] >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_details_mtv2_bulk]    Script Date: 5/16/2016 11:48:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER  Procedure [dbo].[sp_invoice_template_details_mtv2_bulk] @i_slsinvcehdrid int, @c_showsql char(1) = 'N'
As
--select * from salesinvoicedetail where SlsInvceDtlSlsInvceHdrID = 12
----exec sp_invoice_template_details_mtv2_bulk 22376,@c_showsql = 'y'
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_details 24     
-- Overview:	DocumentFunctionalityHere
-- Arguments:	@i_slsinvcehdrid	Sales Invoice Header ID
-- SPs:
-- Temp Tables:
-- Created by:	
-- History:	
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
Set NoCount ON

Declare @vc_value varchar(10),
	@i_DecimalPlaces int,
	@vc_UOMAbbv varchar(10),
	@vc_Key varchar(50),
	@vc_sql_select1 varchar(8000),		-- 65163
	@vc_sql_from1 varchar(8000),		-- 65163
	@vc_sql_where1 varchar(8000),		-- 65163
	@vc_sql_from1_b varchar(8000),
	@vc_sql_select2 varchar(8000),		-- 65163
	@vc_sql_from2 varchar(8000),		-- 65163
	@vc_sql_where2 varchar(8000),		-- 65163
	@vc_sql_from_M varchar(8000),
	@vc_sql_SELECT_m VARCHAR(8000),
	@VC_SQL_WHERE_M VARCHAR(8000),
	@UseDeliveryLocation char(1)
/*
Select @vc_UOMAbbv = UOMAbbv 
From	SalesInvoiceHeader
	Inner Join UnitofMeasure on (SlsInvceHdrUOM = UOM)
Where	SlsInvceHdrID = @i_slsinvcehdrid

select @vc_key = 'System\SalesInvoicing\UOMQttyDecimals\' + @vc_UOMAbbv

Exec sp_get_registry_value @vc_key, @vc_value out

if @vc_value is not null
 	Select @i_DecimalPlaces = Convert(int, @vc_value)
--         , SalesInvoiceDetail.SlsInvceDtlPrUntVle / ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + ' 'dtlpruntvle'  -- 65163
--	 , ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + '  -- 65163

*/
set @vc_sql_SELECT1= '
Set @vc_sql_from1 = '
set @vc_sql_from1_b = '
set @VC_SQL_WHERE1 = '

set @vc_sql_SELECT_m = '
Set @vc_sql_from_M = '
set @VC_SQL_WHERE_M = '

set @vc_sql_SELECT2= '
Set @vc_sql_from2 = '
set @VC_SQL_WHERE2 = '

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
  and AccountDetail.AcctDtlSrceTble not in ( 'T','I')
UNION ALL
select distinct acctdtlid,
	       dbo.MTV_FN_GetUOMConversionFactorSQLAsValue(convert(int,GeneralConfiguration.GnrlCnfgMulti),SalesInvoiceHeader.SlsInvceHdrUOM, ChildProduct.PrdctSpcfcGrvty, ChildProduct.PrdctEnrgy) conversionFactor, AccountDetail.AcctDtlSrceTble, 'Y'
From AccountDetail
         Inner Join ManualSalesInvoiceDetailLog   on MnlSlsInvceDtlLgID = accountdetail.AcctDtlSrceID
                                                 and AccountDetail.AcctDtlSrceTble = 'I'
		 Inner Join ManualSalesInvoiceDetail On ManualSalesInvoiceDetail.MnlSlsInvceDtlID = ManualSalesInvoiceDetailLog.MnlSlsInvceDtlID
		 Inner Join SalesInvoiceHeader on SalesInvoiceHeader.SlsInvceHdrID = ManualSalesInvoiceDetailLog.SlsInvceHdrID                                     
	     Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme		=	'System'		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	'DBMSUOM'	-- 65163
         left outer Join Product ChildProduct		On 	ManualSalesInvoiceDetail.MnlSlsInvceDtlPrdctID 		= 	ChildProduct.PrdctID
Where Accountdetail.AcctDtlSlsInvceHdrid = @i_slsinvcehdrid
UNION ALL
select distinct acctdtlid, dbo.MTV_FN_GetUOMConversionFactorSQLAsValue(convert(int,GeneralConfiguration.GnrlCnfgMulti),AccountDetail.AcctDtlUOMID, SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty, coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)) conversionFactor, AccountDetail.AcctDtlSrceTble, 'Y'
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				= 	'T'
	     Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme		=	'System'		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	'DBMSUOM'	-- 65163
         Inner Join Currency Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.CrrncyID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID		= 	ChildProduct.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID				= 	UnitOfMeasure.UOM
         Inner Join Contact 				On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
	 Inner Join TaxDetailLog			On	TaxDetailLog.TxDtlLgID 					= 	AccountDetail.AcctDtlSrceID
	 Inner Join TaxDetail				On	TaxDetail.TxDtlID					= 	TaxDetailLog.TxDtlLgTxDtlID
	 Inner Join TransactionHeader       On  TransactionHeader.XhdrID = TaxDetail.TxdtlXhdrID
	 left outer join TaxRuleSet on taxDetail.TxID = TaxRuleSet.TxID
	                             and TaxDetail.TxRleStID = TaxRuleSet.TxRleStID
	 left outer join MovementDocument on MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	 left outer join MovementHeader MH on MH.MvtHdrMvtDcmntID = MovementDocument.MvtDcmntID
Where accountdetail.acctdtlslsinvcehdrid = @i_slsinvcehdrid
  and AccountDetail.AcctDtlSrceTble = 'T'


Select @UseDeliveryLocation = ( Select 'Y'
   From SalesInvoiceHeader
        inner join BusinessAssociate ON Baid = SlsInvceHdrIntrnlBAID
  where Baabbrvtn in  (select delloc.RgstryDtaVle From Registry delloc where delloc.RgstryKyNme = 'UseDeliveryLocationShipTo')
  and slsinvcehdrid = @i_slsinvcehdrid
  )
  

 Update #uomconversion
 set taxonly = 'N'
 where exists  ( select 'x' from #uomconversion where AcctDtlSrceTble <> 'T' )  
  
if @UseDeliveryLocation is null 
   set @UseDeliveryLocation = 'N' 
   

--select @vc_sql_select1 = '
SELECT '0' 'RecordType'
	 , SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 'ContractNumberInternal'
	 , MTVSAPBASoldTo.SoldTo 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) 'OriginLcleID'
	 , Isnull(Origin. LcleAbbrvtn,'') + isnull(Origin. LcleAbbrvtnExtension,'') 'Origin'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 'DestinationLcleID'
	 , Isnull(Destination. LcleAbbrvtn,'') + isnull(Destination. LcleAbbrvtnExtension,'') 'Destination'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 'TransferPointLcleID'
	 , Case  
	      When  DynamicListBox.DynLstBxAbbv  is null then ''
	      Else Isnull(TransferPoint. LcleAbbrvtn,'') + isnull(TransferPoint. LcleAbbrvtnExtension,'')
	    End 'TransferPoint'
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ExternalContact'
         , SalesInvoiceDetail.SlsInvceDtlMvtHdrDte 'TransactionDate'
         , coalesce(TransactionHeader.XHdrQty,ttd.TmeXDtlQntty,0) * isnull(#uomconversion.ConversionFactor ,1) 'NetQuantity'
		 , coalesce(TransactionHeader.XHdrGrssQty,ttd.TmeXDtlQntty,0) * isnull(#uomconversion.ConversionFactor,1) 'GrossQuantity'
		 , round( ( sum(accountdetail.Value) / sum(accountdetail.volume))  *     1/min(isnull(#uomconversion.conversionFactor,1)), SalesInvoiceDetail.PerUnitDecimals)  * -1 
         , sum ( SalesInvoiceDetail.SlsInvceDtlTrnsctnVle  ) 'dtltrnsctnvle'
         , sum( slsinvcedtltrnsctnqntty) volume
		 , DynamicListBox.DynLstBxDesc 'DeliveryTerm'
         , case when DealDetailProvision.CostType = 'P' then product.prdctnme when prvsn.prvsnnme like '%prepay%' then product.prdctnme else TransactionType.TrnsctnTypDesc  end 'Description'
         , max(SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty) 'SpecificGravity'
         , UnitOfMeasure.UOMDesc 'UOMDesc'
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 'UOMSingularDesc'
         , Currency.CrrncySmbl 'Currency'
         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID 'PrdctID'
         , case when pt.PlnndTrnsfrLneUpSmmry is not null then pt.PlnndTrnsfrLneUpSmmry else MovementDocument.MvtDcmntExtrnlDcmntNbr end  'ExtMovementDocument'
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 'DetailType'
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals
	 , 1 converstionfactor
	, UnitOfMeasure.UOMAbbv
	, ChildProduct.PrdctEnrgy 'Energy'
	, isnull(SapMatcode.GnrlcnfgMulti,'')   SapMaterialCode
	, isnull(SCACCode.GnrlcnfgMulti,'') scac
	, case when @UseDeliveryLocation = 'Y'  then
      isnull(DestAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(DestAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(DestCityName.GnrlCnfgMulti,'') +  case isnull(DestCityName.GnrlCnfgMulti,'') when '' then ' ' else ', '  end +
          isnull(DestStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(DestPostalCode.GnrlcnfgMulti,'')  	
	else
		isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + case isnull(MTVSAPSoldToShipTo.ShipToCity,'') when '' then ' ' else ', ' end + 
		isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') 
	 end ShipTo
	, isnull(origin.LcleNme,'') + isnull(origin.LcleNmeExtension,'') PlantCode
	, DealDetailProvision.CostType costtype 
	, isnull(Carrier.Baabbrvtn,' ') Carrier
	, '' Taxruletype
    , Product.prdctnme  'ProductDescription'
    , substring(customerpo.gnrlcnfgmulti,1,20) customerpo
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + case isnull(plantcityname.GnrlCnfgMulti,'') when '' then ' ' else ', ' end +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  PlantAddress
    , case when transactiondetail.quantitybasis = 'N' then 'Net' else 'Gross' end netgross
	, mht.name movementtype
	, substring(railcar.gnrlcnfgmulti,1,30) railcar
	, pt.PlnndTrnsfrPlnndStPlnndMvtID
	, MH.LineNumber	
	,#uomconversion.TaxOnly


--select @vc_sql_from1 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
	     Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				not in ('I','T')
         left outer join PlannedTransfer pt on pt.PlnndTrnsfrID = AccountDetail.AcctDtlPlnndTrnsfrID
		 Left outer Join transactiondetaillog on XDtlLgAcctDtlID = AccountDetail.AcctDtlid
         left outer join timetransactiondetaillog ttdl on ttdl.TmeXDtlLgAcctDtlID = AccountDetail.AcctDtlID
         left outer join timetransactiondetail ttd on ttd.TmeXDtlIdnty = ttdl.TmeXDtlLgTmeXDtlIdnty 
		 left outer Join DealDetailProvision on dldtlprvsnid = isnull(XDtlLgXDtlDlDtlPrvsnID,TmeXDtlDlDtlPrvsnID)
		 left outer join prvsn on prvsn.prvsnid = DealDetailProvision.DlDtlPrvsnPrvsnID
         Inner Join Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.crrncyid
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID 		= 	ChildProduct.PrdctID
		 Inner Join Product				On SalesInvoiceDetail.SlsInvceDtlPrntPrdctID = Product.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID	 			= 	UnitOfMeasure.UOM
         Left Outer Join Contact 			On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
         Left outer join GeneralConfiguration SapMatCode on SapMatCode.GnrlcnfgHdrid = AccountDetail.ParentPrdctID
	                                               and SapMatCode.GnrlcnfgQlfr = 'SAPMATERIALCODE'
												   and SapMatCode.GnrlcnfgTblnme = 'Product'
	 Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	 Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	 Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	'DealDeliveryTerm'
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
     left outer join #uomconversion on #uomconversion.acctdtlid = accountdetail.acctdtlid
     left outer join GeneralConfiguration  plantAddrLine1 on plantAddrLine1.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine1.GnrlCnfgTblNme = 'Locale' and plantAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
     left outer join GeneralConfiguration  plantAddrLine2 on plantAddrLine2.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine2.GnrlCnfgTblNme = 'Locale' and plantAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
     left outer join GeneralConfiguration  plantCityName  on plantCityName.GnrlCnfgHdrID = origin.lcleid  and plantCityName.GnrlCnfgTblNme = 'Locale' and plantCityName.GnrlCnfgQlfr = 'CityName'
     left outer join GeneralConfiguration  plantStateAbbreviation on plantStateAbbreviation.GnrlCnfgHdrID = origin.lcleid  and plantStateAbbreviation.GnrlCnfgTblNme = 'Locale' and plantStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
     left outer join GeneralConfiguration  plantPostalCode on plantPostalCode.GnrlCnfgHdrID = origin.lcleid  and plantPostalCode.GnrlCnfgTblNme = 'Locale' and plantPostalCode.GnrlCnfgQlfr = 'PostalCode'
	Left Outer Join	TransactionDetail	(NoLock) On	TransactionDetail. XDtlXHdrID 				= TransactionDetailLog. XDtlLgXDtlXHdrID
								and	TransactionDetail. XDtlDlDtlPrvsnID 		= TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID
								and	TransactionDetail. XDtlID 			= TransactionDetailLog. XDtlLgXDtlID
	Left Outer Join	TransactionHeader	(NoLock) On	TransactionDetailLog. XDtlLgXDtlXHdrID			= TransactionHeader. XHdrID
	Left Outer Join MovementHeader MH On TransactionHeader.XHdrMvtDtlMvtHdrID = MH.MvtHdrID
	left outer join MovementHeadertype mht on mht.mvthdrtyp = mh.mvthdrtyp 
	Left Outer Join MovementDocument on MvtDcmntID = MH.MvtHdrMvtDcmntID
	Left outer join businessassociate carrier on carrier.baid = MH.MvtHdrCrrrBAID
	left outer join BusinessAssociate Internal on Internal.Baid = SalesInvoiceHeader.SlsInvceHdrIntrnlBAID
	Left Outer Join dbo.GeneralConfiguration	as SCACCode	on SCACCode.GnrlCnfgHdrID =carrier.baid
								and  SCACCode.GnrlCnfgTblNme = 'BusinessAssociate'
								and  SCACCode.GnrlCnfgQlfr = 'SCAC' 
	left outer join GeneralConfiguration  railcar on railcar.GnrlcnfgHdrID = mh.mvthdrid and railcar.GnrlcnfgQlfr = 'RailcarNumber' and railcar.gnrlcnfgtblnme = 'movementheader'
	inner join dealdetail on dealdetail.dldtldlhdrid = accountdetail.AcctDtlDlDtlDlHdrID
	                     and dealdetail.dldtlid = accountdetail.AcctDtlDlDtlID
	left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = 'SapPlantCode'
												  and PlantCode.GnrlcnfgTblNme = 'Locale'
    left outer join GeneralConfiguration  customerpo on customerpo.gnrlcnfghdrid = pt.PlnndTrnsfrPlnndStPlnndMvtID
                                                     and customerpo.Gnrlcnfgtblnme = 'plannedmovement'
                                                     and customerpo.GnrlcnfgQlfr = 'counterpartynumber'
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
	                                         
--select @vc_sql_from1_b = @vc_sql_from1_b + '
	left outer join Locale DestLocale on DestLocale.LcleID = mh.MvtHdrDstntnLcleID
	left outer join GeneralConfiguration DestAddrLine1 on 	DestAddrLine1.GnrlcnfgHdrID = DestLocale.LcleID
	                                                  and   DestAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
	                                                  and   DestAddrLine1.GnrlCnfgTblNme = 'Locale'					  
	left outer join GeneralConfiguration DestAddrLine2 on 	DestAddrLine2.GnrlcnfgHdrID = DestLocale.LcleID
	                                                  and   DestAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
	                                                  and   DestAddrLine2.GnrlCnfgTblNme = 'Locale'					  
	left outer join GeneralConfiguration DestCityName on    DestCityName.GnrlCnfgHdrID = DestLocale.LcleID
	                                                 and    DestCityName.GnrlCnfgQlfr = 'CityName'
	                                                 and    DestCityName.GnrlCnfgTblNme = 'Locale'
    left outer join GeneralConfiguration DestStateAbbreviation on DestStateAbbreviation.GnrlCnfgHdrID = DestLocale.LcleID
                                                     and    DestStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
                                                     and    DestStateAbbreviation.GnrlCnfgTblNme = 'Locale'
	left outer join GeneralConfiguration DestPostalCode on DestPostalCode.GnrlCnfgHdrID = DestLocale.LcleiD
	                                                 and    DestPostalCode.GnrlcnfgQlfr = 'PostalCode'
	                                                 and    DestPostalCode.GnrlCnfgTblNme = 'Locale'
	                                                 
--select @vc_sql_where1 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID  = @i_slsinvcehdrid
 Group BY
	   SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 
	 , MTVSAPBASoldTo.SoldTo 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) 
	 , Isnull(Origin. LcleAbbrvtn,'') + isnull(Origin. LcleAbbrvtnExtension,'') 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 
	 , Isnull(Destination. LcleAbbrvtn,'') + isnull(Destination. LcleAbbrvtnExtension,'') 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 
	 , Case  
	      When  DynamicListBox.DynLstBxAbbv  is null then ''
	      Else Isnull(TransferPoint. LcleAbbrvtn,'') + isnull(TransferPoint. LcleAbbrvtnExtension,'')
	    End 
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 
         , SalesInvoiceDetail.SlsInvceDtlMvtHdrDte 

         , coalesce(TransactionHeader.XHdrQty,ttd.TmeXDtlQntty,0) * isnull(#uomconversion.ConversionFactor ,1) 
		 , coalesce(TransactionHeader.XHdrGrssQty,ttd.TmeXDtlQntty,0) * isnull(#uomconversion.ConversionFactor,1) 
		 		 , SalesInvoiceDetail.SlsInvceDtlPrUntVle
		 , DynamicListBox.DynLstBxDesc 
         , case when DealDetailProvision.CostType = 'P' then product.prdctnme when prvsn.prvsnnme like '%prepay%' then product.prdctnme else TransactionType.TrnsctnTypDesc  end 
         , UnitOfMeasure.UOMDesc 
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 
         , Currency.CrrncySmbl 
         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID 
         , case when pt.PlnndTrnsfrLneUpSmmry is not null then pt.PlnndTrnsfrLneUpSmmry else MovementDocument.MvtDcmntExtrnlDcmntNbr end 
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals
	, UnitOfMeasure.UOMAbbv
	, ChildProduct.PrdctEnrgy 
	, isnull(SapMatcode.GnrlcnfgMulti,'')   
	, isnull(SCACCode.GnrlcnfgMulti,'') 
	, case when @UseDeliveryLocation = 'Y'  then
      isnull(DestAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(DestAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(DestCityName.GnrlCnfgMulti,'') +  case isnull(DestCityName.GnrlCnfgMulti,'') when '' then ' ' else ', '  end +
          isnull(DestStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(DestPostalCode.GnrlcnfgMulti,'')  	
	else
		isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + Case isnull(MTVSAPSoldToShipTo.ShipToCity,'') when '' then ' ' else ', '  end +
		 isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') 
	 end
	, isnull(origin.LcleNme,'') + isnull(origin.LcleNmeExtension,'') 
	, DealDetailProvision.CostType  
	, isnull(Carrier.Baabbrvtn,' ') 
    , Product.prdctnme  
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + case  isnull(plantcityname.GnrlCnfgMulti,'') when '' then ' ' else ', ' end +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' +  isnull(plantPostalCode.GnrlcnfgMulti,'')
    , case when transactiondetail.quantitybasis = 'N' then 'Net' else 'Gross' end 
	, mht.name  
	, substring(railcar.gnrlcnfgmulti,1,30)
	, substring(customerpo.gnrlcnfgmulti,1,20)
	, pt.PlnndTrnsfrPlnndStPlnndMvtID
	, MH.LineNumber
	,#uomconversion.TaxOnly


--MANUAL
--select @vc_sql_select_M = '
UNION ALL
 SELECT '0' 'RecordType'
	 , DealHeader.DlHdrIntrnlNbr 'ContractNumberInternal'
	 , MTVSAPBASoldTo.SoldTo 
	 , Isnull(ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID,0) 'OriginLcleID'
	 , Isnull(Origin. LcleAbbrvtn,'') + isnull(Origin. LcleAbbrvtnExtension,'') 'Origin'
	 , Isnull(ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID,0) 'DestinationLcleID'
	 , Isnull(Destination. LcleAbbrvtn,'') + isnull(Destination. LcleAbbrvtnExtension,'') 'Destination'
	 , Isnull(ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID,0) 'TransferPointLcleID'
	 , Isnull(TransferPoint. LcleAbbrvtn,'') + isnull(TransferPoint. LcleAbbrvtnExtension,'') 'TransferPoint'
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ExternalContact'
         , ManualSalesInvoiceDetail.MnlSlsInvceDtlDte 'TransactionDate'
         , ManualSalesInvoiceDetail.MnlSlsInvceDtlQntty * isnull(#UOMConversion.conversionFactor,1) 'NetQuantity'
		 , ManualSalesInvoiceDetail.MnlSlsInvceDtlQntty * isnull(#UOMConversion.conversionFactor,1) 'GrossQuantity'
	 , ManualSalesInvoiceDetail.MnlSlsInvceDtlVle  * 1/ isnull(#uomconversion.conversionFactor,1) 'dtlpruntvle'
         ,  ManualSalesInvoiceDetail.MnlSlsInvceDtlVle * ManualSalesInvoiceDetail.MnlSlsInvceDtlQntty   'dtltrnsctnvle'

         , ManualSalesInvoiceDetail.MnlSlsInvceDtlQntty * isnull(#uomconversion.conversionFactor,1) volume
         , ' ' DeliveryTerm
	     ,ManualSalesInvoiceDetail.MnlSlsInvceDtlDscrptn
         , ChildProduct.PrdctSpcfcGrvty 'SpecificGravity'
         , UnitOfMeasure.UOMDesc 'UOMDesc'
         , ' ' 'UOMSingularDesc'
         , Currency.CrrncySmbl 'Currency'
         , ManualSalesInvoiceDetail.MnlSlsInvceDtlPrdctID 'PrdctID'
         , ' ' 'ExtMovementDocument'
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 'DetailType'
	 , 2
	 , 2
	 ,#uomconversion.conversionFactor converstionfactor
	, UnitOfMeasure.UOMAbbv
	, ChildProduct.PrdctEnrgy 'Energy'
	, SapMatcode.GnrlcnfgMulti   SapMaterialCode
	, ' ' scac
	, case when @UseDeliveryLocation = 'Y'  then
      isnull(DestAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(DestAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(DestCityName.GnrlCnfgMulti,'') + case isnull(DestCityName.GnrlCnfgMulti,'') when '' then ' ' else ', ' end +
          isnull(DestStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(DestPostalCode.GnrlcnfgMulti,'')  	
	else
   ''	 
  end 
	, isnull(origin.LcleNme,'') + isnull(origin.LcleNmeExtension,'') plantcode
	, 'S' costtype 
	, ' ' Carrier
	, '' Taxruletype
    , Product.prdctnme  'ProductDescription'
    , ' ' customerpo
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + case isnull(plantCityName.GnrlCnfgMulti,'') when '' then ' ' else ', ' end +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  PlantAddress
    ,  'Net'   netgross
	, '' movementtype
	, '' railcar
	, null --PlnndMvtID
	, 1
	,#uomconversion.TaxOnly

--select @vc_sql_from_M = '
    FROM ManualSalesInvoiceDetail 
         Inner Join SalesInvoiceHeader 			On 	ManualSalesInvoiceDetail.MnlSlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         inner join ManualSalesInvoiceDetailLog lg on lg.MnlSlsInvceDtlID = ManualSalesInvoiceDetail.MnlSlsInvceDtlID
                                         and lg.SlsInvceHdrId = ManualSalesInvoiceDetail.MnlSlsInvceDtlSlsInvceHdrID
          inner join AccountDetail on AccountDetail.AcctDtlSrceID = lg.MnlSlsInvceDtlLgID
                        and AccountDetail.AcctDtlSrceTble = 'I'
         left outer join #UOMConversion on #UOMConversion.AcctDtlID = AccountDetail.AcctDtlID
         left outer  Join DealHeader on DealHeader.DlHdrID = ManualSalesInvoiceDetail.MnlSlsInvceDtlDlHdrID
         Inner Join Currency			    On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.crrncyid
         left outer join BusinessAssociate Internal on Internal.Baid = SalesInvoiceHeader.SlsInvceHdrIntrnlBAID
         Left Outer Join Product ChildProduct on ChildProduct.PrdctID = ManualSalesInvoiceDetail.MnlSlsInvceDtlChldPrdctID
		 Inner Join Product				    On ManualSalesInvoiceDetail.MnlSlsInvceDtlPrdctID = Product.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID	 			= 	UnitOfMeasure.UOM
         Left Outer Join Contact 			On 	ManualSalesInvoiceDetail.MnlSlsInvceDtlUsrID 	= 	Contact.CntctID
         Inner Join TransactionType 		On 	ManualSalesInvoiceDetail.MnlSlsInvceDtlTrnsctnTpeID 		= 	TransactionType.TrnsctnTypID
         Left outer join GeneralConfiguration SapMatCode on SapMatCode.GnrlcnfgHdrid = Product.prdctID
	                                               and SapMatCode.GnrlcnfgQlfr = 'SAPMATERIALCODE'
												   and SapMatCode.GnrlcnfgTblnme = 'Product'
         Left Outer Join Locale as Origin 		On 	ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID 		= 	Origin. LcleID
	     Left Outer Join Locale as Destination 		On 	ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID 		= 	Destination. LcleID  --JLR added
	     Left Outer Join Locale as TransferPoint 	On 	ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID 		= 	TransferPoint. LcleID
         left outer join GeneralConfiguration  plantAddrLine1 on plantAddrLine1.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine1.GnrlCnfgTblNme = 'Locale' and plantAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
         left outer join GeneralConfiguration  plantAddrLine2 on plantAddrLine2.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine2.GnrlCnfgTblNme = 'Locale' and plantAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
         left outer join GeneralConfiguration  plantCityName  on plantCityName.GnrlCnfgHdrID = origin.lcleid  and plantCityName.GnrlCnfgTblNme = 'Locale' and plantCityName.GnrlCnfgQlfr = 'CityName'
         left outer join GeneralConfiguration  plantStateAbbreviation on plantStateAbbreviation.GnrlCnfgHdrID = origin.lcleid  and plantStateAbbreviation.GnrlCnfgTblNme = 'Locale' and plantStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
         left outer join GeneralConfiguration  plantPostalCode on plantPostalCode.GnrlCnfgHdrID = origin.lcleid  and plantPostalCode.GnrlCnfgTblNme = 'Locale' and plantPostalCode.GnrlCnfgQlfr = 'PostalCode'
 	     left outer join GeneralConfiguration SoldTo on SoldTo.GnrlCnfgHdrID = ManualSalesInvoiceDetail.MnlSlsInvceDtlDlHdrID
	                                           and SoldTo.GnrlCnfgTblNme = 'DealHeader'
	                                           and SoldTo.GnrlCnfgQlfr = 'SapSoldto'
	     left outer join MTVSAPBaSoldTo on convert(varchar,MTVSAPBaSoldTo.ID) = SoldTo.Gnrlcnfgmulti							
	     left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = 'SapPlantCode'
												  and PlantCode.GnrlcnfgTblNme = 'Locale'
	left outer join GeneralConfiguration DestAddrLine1 on 	DestAddrLine1.GnrlcnfgHdrID = Destination.LcleID
	                                                  and   DestAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
	                                                  and   DestAddrLine1.GnrlCnfgTblNme = 'Locale'					  
	left outer join GeneralConfiguration DestAddrLine2 on 	DestAddrLine2.GnrlcnfgHdrID = Destination.LcleID
	                                                  and   DestAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
	                                                  and   DestAddrLine2.GnrlCnfgTblNme = 'Locale'					  
	left outer join GeneralConfiguration DestCityName on    DestCityName.GnrlCnfgHdrID = Destination.LcleID
	                                                 and    DestCityName.GnrlCnfgQlfr = 'CityName'
	                                                 and    DestCityName.GnrlCnfgTblNme = 'Locale'
    left outer join GeneralConfiguration DestStateAbbreviation on DestStateAbbreviation.GnrlCnfgHdrID = Destination.LcleID
                                                     and    DestStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
                                                     and    DestStateAbbreviation.GnrlCnfgTblNme = 'Locale'
	left outer join GeneralConfiguration DestPostalCode on DestPostalCode.GnrlCnfgHdrID = Destination.LcleiD
	                                                 and    DestPostalCode.GnrlcnfgQlfr = 'PostalCode'
	                                                 and    DestPostalCode.GnrlCnfgTblNme = 'Locale'
												  
	
--select @vc_sql_where_M = '
   WHERE ManualSalesInvoiceDetail.MnlSlsInvceDtlSlsInvceHdrID 	 = @i_slsinvcehdrid
 /*Group by
	  DealHeader.DlHdrIntrnlNbr 
	  ,#UOMConversion.conversionFactor
	 , MTVSAPBASoldTo.SoldTo 
	 , Isnull(ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID,0) 
	 , Isnull(Origin. LcleAbbrvtn,'') + isnull(Origin. LcleAbbrvtnExtension,'') 
	 , Isnull(ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID,0) 
	 , Isnull(Destination. LcleAbbrvtn,'') + isnull(Destination. LcleAbbrvtnExtension,'') 
	 , Isnull(ManualSalesInvoiceDetail.MnlSlsInvceDtlLcleID,0)
	 , Isnull(TransferPoint. LcleAbbrvtn ,'')+ isnull(TransferPoint. LcleAbbrvtnExtension,'') 
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 
         , ManualSalesInvoiceDetail.MnlSlsInvceDtlDte 
         , AccountDetail.Volume * isnull(#UOMConversion.conversionFactor,1)
		 , AccountDetail.Volume * isnull(#UOMConversion.conversionFactor,1)
	     ,ManualSalesInvoiceDetail.MnlSlsInvceDtlDscrptn
         , ChildProduct.PrdctSpcfcGrvty 
         , UnitOfMeasure.UOMDesc
         , Currency.CrrncySmbl 
         , ManualSalesInvoiceDetail.MnlSlsInvceDtlPrdctID 
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 
	, UnitOfMeasure.UOMAbbv
	, ChildProduct.PrdctEnrgy 
	, SapMatcode.GnrlcnfgMulti   
	, case when @UseDeliveryLocation = 'Y'  then
      isnull(DestAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(DestAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(DestCityName.GnrlCnfgMulti,'') + case isnull(DestCityName.GnrlCnfgMulti,'') when '' then ' ' else ', ' end +
          isnull(DestStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(DestPostalCode.GnrlcnfgMulti,'')  	
	else
   ''	 
  end 
	, isnull(origin.LcleNme,'') + isnull(origin.LcleNmeExtension,'') 
    , Product.prdctnme  
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + case isnull(plantCityName.GnrlCnfgMulti,'') when '' then ' ' else ', ' end +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  
	,#uomconversion.TaxOnly
*/



--select @vc_sql_select2 = '

UNION ALL
 SELECT  '1' 'RecordType'
	 , SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr 'ContractNumberInternal'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlNbr,'') 'ContractNumberExternal'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) 'OriginLcleID'
	 , Isnull(Origin. LcleAbbrvtn,'') + isnull(Origin. LcleAbbrvtnExtension,'') 'Origin'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) 'DestinationLcleID'
	 , Isnull(Destination. LcleAbbrvtn,'') + isnull(Destination. LcleAbbrvtnExtension,'') 'Destination'
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 'TransferPointLcleID'
	 , Case  
	      	When  DynamicListBox.DynLstBxAbbv  is null then ''
	      	Else Isnull(TransferPoint. LcleAbbrvtn,'') + isnull(TransferPoint. LcleAbbrvtnExtension,'')
	    End 'TransferPoint'
	 , Contact.CntctFrstNme + ' ' + Contact.CntctLstNme 'ExternalContact'
     , MH.MvtHdrDte 'TransactionDate'
         , isnull(TransactionHeader.XHdrQty,0) * isnull(#uomconversion.ConversionFactor,1) 'NetQuantity'
		 , isnull(TransactionHeader.XHdrGrssQty,0) * isnull(#uomconversion.ConversionFactor,1) 'GrossQuantity'
         , isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate )
         , sum ( SalesInvoiceDetail.SlsInvceDtlTrnsctnVle  ) 'dtltrnsctnvle'
         , sum( slsinvcedtltrnsctnqntty) volume
		 , DynamicListBox.DynLstBxDesc 'DeliveryTerm'
         , TaxRuleSet.InvoicingDescription 'Description'
         , 0 /*SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty*/ 'SpecificGravity'
         , UnitOfMeasure.UOMDesc 'UOMDesc'
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When 's' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 'UOMSingularDesc'
         , Currency.CrrncySmbl 'Currency'
         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID 'PrdctID'
         , case when pt.PlnndTrnsfrLneUpSmmry is not null then pt.PlnndTrnsfrLneUpSmmry else MovementDocument.MvtDcmntExtrnlDcmntNbr end  'ExtMovementDocument'
         , Case AccountDetail.AcctDtlSrceTble 
                When 'T' then 'Tax' 
                Else TransactionType.TrnsctnTypCtgry
           End 'DetailType'
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals 'QuantityDecimalPlaces' -- , @i_DecimalPlaces 'QuantityDecimalPlaces''
	 , 1 
	, case when TaxRuleSet.Type = 'F' then '%' else UnitOfMeasure.UOMAbbv end
	, ChildProduct.PrdctEnrgy 'Energy'
	, SapMatcode.GnrlcnfgMulti   SapMaterialCode
	, isnull(SCACCode.GnrlcnfgMulti,' ') 
	, case when @UseDeliveryLocation = 'Y'  then
      isnull(DestAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(DestAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(DestCityName.GnrlCnfgMulti,'') +  case isnull(DestCityName.GnrlCnfgMulti,'') when '' then ' ' else ', '  end +
          isnull(DestStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(DestPostalCode.GnrlcnfgMulti,'')  	
	else
		isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + case isnull(MTVSAPSoldToShipTo.ShipToCity,'') when '' then ' ' else ', ' end + isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') 
	 end 	
	 , isnull(Origin.LcleNme,'') + isnull(origin.LcleNmeExtension,'') plantcode
	, 'S'
	, isnull(Carrier.Baabbrvtn,' ') Carrier
    , TaxRuleSet.Type 'TaxType'
    , Product.prdctnme  'ProductDescription'
    , substring(customerpo.gnrlcnfgmulti,1,20) customerpo
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + case isnull(plantcityname.GnrlCnfgMulti,'') when '' then ' ' else ', ' end +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  PlantAddress
    , case when dealDetailProvision.QuantityBasis = 'N' then 'Net' else 'Gross' end netgross
	, mht.name movementtype
	, substring(railcar.gnrlcnfgmulti,1,30) railcar
	, pt.PlnndTrnsfrPlnndStPlnndMvtID
	, MH.LineNumber
	,#uomconversion.TaxOnly


--select	@vc_sql_from2 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				= 	'T'
         Inner Join Product on Product.PrdctiD = SalesInvoiceDetail.SlsInvceDtlPrntPrdctID                             
         Inner Join Currency Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.CrrncyID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID		= 	ChildProduct.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID				= 	UnitOfMeasure.UOM
         Inner Join Contact 				On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
     left outer join #uomconversion on #uomconversion.acctdtlid = accountdetail.acctdtlid
	 Inner Join TaxDetailLog			On	TaxDetailLog.TxDtlLgID 					= 	AccountDetail.AcctDtlSrceID
	 Inner Join TaxDetail				On	TaxDetail.TxDtlID					= 	TaxDetailLog.TxDtlLgTxDtlID
	 left outer Join TransactionHeader       On  TransactionHeader.XhdrID = TaxDetail.TxdtlXhdrID
	 left outer join PlannedTransfer pt on pt.PlnndTrnsfrID = transactionheader.XHdrPlnndTrnsfrID
	 left outer join Dealdetail on dealdetail.dldtldlhdrid = pt.PlnndTrnsfrObDlDtlDlHdrID
	                           and dealdetail.dldtlid = pt.PlnndTrnsfrObDlDtlID
	 left outer join DealDetailProvision on DealDetailProvision.DlDtlPrvsnPrvsnID = taxdetail.DlDtlPrvsnID
	                                    and DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID = 0
	                                     and DealDetailProvision.DlDtlPrvsnDlDtlID = 0
	 left outer join TaxRuleSet on taxDetail.TxID = TaxRuleSet.TxID
	                             and TaxDetail.TxRleStID = TaxRuleSet.TxRleStID
	 left outer join MovementDocument on MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	 left outer join MovementHeader MH on MH.MvtHdrMvtDcmntID = MovementDocument.MvtDcmntID
	 	                                  and MH.MvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
 	 Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	 Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	 Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	'DealDeliveryTerm'
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
	
	left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = 'SapPlantCode'
												  and PlantCode.GnrlcnfgTblNme = 'Locale'
    
     LEFT OUTER JOIN v_MTV_TaxRates ON v_MTV_TaxRates.acctdtlid = accountdetail.acctdtlid
     LEFT OUTER JOIN MTV_AccountDetailTaxRateArchive ON MTV_AccountDetailTaxRateArchive.AcctDtlID = AccountDetail.AcctDtlID
    
     left outer join GeneralConfiguration  plantAddrLine1 on plantAddrLine1.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine1.GnrlCnfgTblNme = 'Locale' and plantAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
     left outer join GeneralConfiguration  plantAddrLine2 on plantAddrLine2.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine2.GnrlCnfgTblNme = 'Locale' and plantAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
     left outer join GeneralConfiguration  plantCityName  on plantCityName.GnrlCnfgHdrID = origin.lcleid  and plantCityName.GnrlCnfgTblNme = 'Locale' and plantCityName.GnrlCnfgQlfr = 'CityName'
     left outer join GeneralConfiguration  plantStateAbbreviation on plantStateAbbreviation.GnrlCnfgHdrID = origin.lcleid  and plantStateAbbreviation.GnrlCnfgTblNme = 'Locale' and plantStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
     left outer join GeneralConfiguration  plantPostalCode on plantPostalCode.GnrlCnfgHdrID = origin.lcleid  and plantPostalCode.GnrlCnfgTblNme = 'Locale' and plantPostalCode.GnrlCnfgQlfr = 'PostalCode'
     left outer join MovementHeadertype mht on mht.mvthdrtyp = mh.mvthdrtyp 
	 Left outer join businessassociate carrier on carrier.baid = MH.MvtHdrCrrrBAID
	 Left Outer Join dbo.GeneralConfiguration	as SCACCode	on SCACCode.GnrlCnfgHdrID =carrier.baid
								and  SCACCode.GnrlCnfgTblNme = 'BusinessAssociate'
								and  SCACCode.GnrlCnfgQlfr = 'SCAC' 
	 left outer join GeneralConfiguration  railcar on railcar.GnrlcnfgHdrID = mh.mvthdrid and railcar.GnrlcnfgQlfr = 'RailcarNumber' and railcar.gnrlcnfgtblnme = 'movementheader'
     left outer join GeneralConfiguration  customerpo on customerpo.gnrlcnfghdrid = pt.PlnndTrnsfrPlnndStPlnndMvtID
                                                     and customerpo.Gnrlcnfgtblnme = 'plannedmovement'
                                                     and customerpo.GnrlcnfgQlfr = 'counterpartynumber'
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
    Left outer join GeneralConfiguration SapMatCode on SapMatCode.GnrlcnfgHdrid = AccountDetail.ParentPrdctID
	                                               and SapMatCode.GnrlcnfgQlfr = 'SAPMATERIALCODE'
												   and SapMatCode.GnrlcnfgTblnme = 'Product'
	left outer join Locale DestLocale on DestLocale.LcleID = mh.MvtHdrDstntnLcleID
	left outer join GeneralConfiguration DestAddrLine1 on 	DestAddrLine1.GnrlcnfgHdrID = DestLocale.LcleID
	                                                  and   DestAddrLine1.GnrlCnfgQlfr = 'AddrLine1'
	                                                  and   DestAddrLine1.GnrlCnfgTblNme = 'Locale'					  
	left outer join GeneralConfiguration DestAddrLine2 on 	DestAddrLine2.GnrlcnfgHdrID = DestLocale.LcleID
	                                                  and   DestAddrLine2.GnrlCnfgQlfr = 'AddrLine2'
	                                                  and   DestAddrLine2.GnrlCnfgTblNme = 'Locale'					  
	left outer join GeneralConfiguration DestCityName on    DestCityName.GnrlCnfgHdrID = DestLocale.LcleID
	                                                 and    DestCityName.GnrlCnfgQlfr = 'CityName'
	                                                 and    DestCityName.GnrlCnfgTblNme = 'Locale'
    left outer join GeneralConfiguration DestStateAbbreviation on DestStateAbbreviation.GnrlCnfgHdrID = DestLocale.LcleID
                                                     and    DestStateAbbreviation.GnrlCnfgQlfr = 'StateAbbreviation'
                                                     and    DestStateAbbreviation.GnrlCnfgTblNme = 'Locale'
	left outer join GeneralConfiguration DestPostalCode on DestPostalCode.GnrlCnfgHdrID = DestLocale.LcleiD
	                                                 and    DestPostalCode.GnrlcnfgQlfr = 'PostalCode'
	                                                 and    DestPostalCode.GnrlCnfgTblNme = 'Locale'


--select @vc_sql_where2 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID  = @i_slsinvcehdrid
	group by 
      SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr
	, DynamicListBox.DynLstBxDesc 
    , case when pt.PlnndTrnsfrLneUpSmmry is not null then pt.PlnndTrnsfrLneUpSmmry else MovementDocument.MvtDcmntExtrnlDcmntNbr end 
	,  isnull(MTV_AccountDetailTaxRateArchive.TaxRate,v_MTV_TaxRates.TaxRate)
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) 
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0)
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0)
 	 , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID
     , TransactionType.TrnsctnTypDesc
	 , AccountDetail.AcctDtlSrceTble
	 , TransactionType.TrnsctnTypCtgry
	 , TaxRuleSet.InvoicingDescription
	 , SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlNbr
	 , SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals
	 , Origin.LcleAbbrvtn
	 , MH.MvtHdrDte
	 , TransferPoint.LcleAbbrvtn
	 , Contact.CntctFrstNme 
	 , Origin.LcleAbbrvtnExtension
	 , DynamicListBox.DynLstBxAbbv
	 , TaxRuleSet.InvoicingDescription
	 , TransferPoint.LcleAbbrvtn
	 , TransferPoint.LcleAbbrvtnExtension
	 , Contact.CntctFrstNme, Contact.CntctLstNme 
	 , UnitOfMeasure.UOMDesc
     , case when TaxRuleSet.Type = 'F' then '%' else UnitOfMeasure.UOMAbbv end
	 , AccountDetail.AcctDtlUOMID
	 , TransactionHeader.Energy
	 , ChildProduct.PrdctEnrgy
	 , Currency.CrrncySmbl
     , isnull(TransactionHeader.XHdrQty,0) * isnull(#uomconversion.ConversionFactor ,1)
	 , isnull(TransactionHeader.XHdrGrssQty,0) * isnull(#uomconversion.ConversionFactor ,1)
  	 , isnull(ORIGIN.LcleNme,'') + isnull(origin.LcleNmeExtension,'') 	
	 , TaxRuleSet.Type
 	, MH.LineNumber 	
 	, SapMatcode.GnrlcnfgMulti   
	, isnull(SCACCode.GnrlcnfgMulti,' ') 
	, case when @UseDeliveryLocation = 'Y'  then
      isnull(DestAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(DestAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(DestCityName.GnrlCnfgMulti,'') +  case isnull(DestCityName.GnrlCnfgMulti,'') when '' then ' ' else ', '  end +
          isnull(DestStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(DestPostalCode.GnrlcnfgMulti,'')  	
	else
		isnull(MTVSAPSoldToShipTo.ShipTo,'') + '  ' + isnull(MTVSAPSoldToShipTo.ShipToAddress,'') + ' ' +  isnull(MTVSAPSoldToShipTo.ShipToCity,'') + case isnull(MTVSAPSoldToShipTo.ShipToCity,'') when '' then ' ' else ', ' end + isnull(MTVSAPSoldToShipTo.ShipToState,'') + ' ' + isnull(MTVSAPSoldToShipTo.ShipToZip,'') 
	 end 
	 	, isnull(Carrier.Baabbrvtn,' ') 
    , Product.prdctnme  
    , substring(customerpo.gnrlcnfgmulti,1,20) 
    , isnull(plantAddrLine1.GnrlCnfgMulti,'') + ' ' + isnull(plantAddrLine2.GnrlCnfgMulti,'') + '  ' + isnull(plantCityName.GnrlCnfgMulti,'') + case isnull(plantcityname.GnrlCnfgMulti,'') when '' then ' ' else ', ' end +
          isnull(plantStateAbbreviation.GnrlcnfgMulti,'') + '  ' + isnull(plantPostalCode.GnrlcnfgMulti,'')  
    , case when dealdetailprovision.quantitybasis = 'N' then 'Net' else 'Gross' end 
	, mht.name 
	, substring(railcar.gnrlcnfgmulti,1,30) 
	, pt.PlnndTrnsfrPlnndStPlnndMvtID
   , Isnull(Destination. LcleAbbrvtn,'') + isnull(Destination. LcleAbbrvtnExtension,'')
	,#uomconversion.TaxOnly
    order by  34, 24, 1,18   --plantcode, bol, recordtype,description
	

/*
if upper(@c_showsql) = 'Y'
begin
	select @vc_sql_select1
	select @vc_sql_from1
	select @vc_sql_from1_b
	select @vc_sql_where1
    select @vc_sql_select_M
	select @vc_sql_from_M
	select @vc_sql_where_M
	select @vc_sql_select2
	select @vc_sql_from2
	select @vc_sql_where2
end
else
	execute (@vc_sql_select1 + @vc_sql_from1 +  @vc_sql_from1_b + @vc_sql_where1 + @vc_sql_select_M + @vc_sql_from_M + @vc_sql_where_M + @vc_sql_select2 + @vc_sql_from2 + @vc_sql_where2 )
*/

GO

