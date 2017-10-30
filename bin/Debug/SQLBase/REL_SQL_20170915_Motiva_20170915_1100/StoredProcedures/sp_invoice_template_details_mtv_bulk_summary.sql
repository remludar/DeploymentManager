/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_details_mtv_bulk_summary WITH YOUR view (NOTE:  sp_ is already set
sp_invoice_template_details_mtv_bulk_summary
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_details_mtv_bulk_summary]   Script Date: DATECREATED ******/
PRINT 'Start Script=[sp_invoice_template_details_mtv_bulk_summary].sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv_bulk_summary]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_details_mtv_bulk_summary] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure [sp_invoice_template_details_mtv_bulk_summary] >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_details_mtv_bulk_summary;]    Script Date: 5/16/2016 11:48:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



ALTER  Procedure [dbo].sp_invoice_template_details_mtv_bulk_summary @i_slsinvcehdrid int, @c_showsql char(1) = 'N'
as
--exec sp_invoice_template_details_mtv_bulk_summary 536
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_details_mtv_bulk_summary; 24     
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
	@vc_sql_select2 varchar(8000),		-- 65163
	@vc_sql_from2 varchar(8000),		-- 65163
	@vc_sql_where2 varchar(8000),		-- 65163
	
	@vc_sql_select3 varchar(8000),		-- 65163
	@vc_sql_from3 varchar(8000),		-- 65163
	@vc_sql_where3 varchar(8000)		-- 65163
/*
Select @vc_UOMAbbv = UOMAbbv 
From	SalesInvoiceHeader
	Inner Join UnitofMeasure on (SlsInvceHdrUOM = UOM)
Where	SlsInvceHdrID = @i_slsinvcehdrid

select @vc_key = 'System\SalesInvoicing\UOMQttyDecimals\' + @vc_UOMAbbv

Exec sp_get_registry_value @vc_key, @vc_value out

if @vc_value is not null
 	Select @i_DecimalPlaces = Convert(int, @vc_value)
--         , SalesInvoiceDetail.SlsInvceDtlPrUntVle / ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + ' ''dtlpruntvle''  -- 65163
--	 , ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + '  -- 65163
*/

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



--select * from #uomconversion
--	   , (case when (TransactionHeader.XHdrTyp = ''D'') then (TransactionHeader.XHdrGrssQty * -1) Else TransactionHeader.XHdrGrssQty End )  * #uomconversion.conversionFactor ''GrossQuantity''

select @vc_sql_select1 = '
 SELECT  sum(coalesce(TransactionHeader.XHdrQty,ttd.TmeXDTLQntty,0)  * isnull(#uomconversion.conversionFactor,1)) ''NetQuantity''
	   , sum(coalesce(TransactionHeader.XHdrGrssQty,ttd.TmeXDTLQntty,0)  * isnull(#uomconversion.conversionFactor,1)) ''GrossQuantity''
		 , round( ( sum(accountdetail.Value) / sum(accountdetail.volume))  *     1/min(isnull(#uomconversion.conversionFactor,1)), SalesInvoiceDetail.PerUnitDecimals)  * -1 
         , sum ( SalesInvoiceDetail.SlsInvceDtlTrnsctnVle  ) ''dtltrnsctnvle''
         , sum( slsinvcedtltrnsctnqntty) volume
         , case when DealDetailProvision.CostType = ''P'' then product.prdctnme when prvsn.prvsnnme like ''%prepay%'' then product.prdctnme else TransactionType.TrnsctnTypDesc  end 
         , UnitOfMeasure.UOMDesc ''UOMDesc''
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When ''s'' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End ''UOMSingularDesc''
         , Currency.CrrncySmbl ''Currency''
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals
	 , 1 converstionfactor
	, UnitOfMeasure.UOMAbbv
	,0 recordtype
	,dealdetailprovision.costtype
	'

select @vc_sql_from1 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
	     Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				<> 	''T''
		 left outer join  transactiondetaillog on XDtlLgAcctDtlID = AccountDetail.AcctDtlid
         left outer join timetransactiondetaillog ttdl on ttdl.TmeXDtlLgAcctDtlID = AccountDetail.AcctDtlID
         left outer join timetransactiondetail ttd on ttd.TmeXDtlIdnty = ttdl.TmeXDtlLgTmeXDtlIdnty 
		 Inner Join DealDetailProvision on dldtlprvsnid = isnull(XDtlLgXDtlDlDtlPrvsnID,TmeXDtlDlDtlPrvsnID)
		 left outer join prvsn on prvsn.prvsnid = DealDetailProvision.DlDtlPrvsnPrvsnID
         Inner Join Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.crrncyid
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID 		= 	ChildProduct.PrdctID
		 Inner Join Product				On SalesInvoiceDetail.SlsInvceDtlPrntPrdctID = Product.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID	 			= 	UnitOfMeasure.UOM
         Left Outer Join Contact 			On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
	     Inner Join GeneralConfiguration	On	GeneralConfiguration.GnrlCnfgTblNme			=	''System''		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	''DBMSUOM''		-- 65163
	     Left Outer JOIN	GeneralConfiguration AS SAPCustomerNumber on	accountdetail.AcctDtlDlDtlDlHdrID = SAPCustomerNumber.GnrlCnfgHdrID
                                                 AND	SAPCustomerNumber.GnrlCnfgTblNme = ''DealHeader''
                                                 AND	SAPCustomerNumber.GnrlCnfgQlfr = ''SAPSoldTo''
                                                 AND	SAPCustomerNumber.GnrlCnfgHdrID <> 0
    Left outer join GeneralConfiguration SapMatCode on SapMatCode.GnrlcnfgHdrid = AccountDetail.ParentPrdctID
	                                               and SapMatCode.GnrlcnfgQlfr = ''SAPMATERIALCODE''
												   and SapMatCode.GnrlcnfgTblnme = ''Product''
    LEFT OUTER JOIN MTVSAPBASoldTo ON	SAPCustomerNumber.GnrlCnfgMulti = MTVSAPBASoldTo.ID
	Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	 Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	 Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	''DealDeliveryTerm''
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID

     left outer join GeneralConfiguration  plantAddrLine1 on plantAddrLine1.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine1.GnrlCnfgTblNme = ''Locale'' and plantAddrLine1.GnrlCnfgQlfr = ''AddrLine1''
     left outer join GeneralConfiguration  plantAddrLine2 on plantAddrLine2.GnrlCnfgHdrID = origin.lcleid  and plantAddrLine2.GnrlCnfgTblNme = ''Locale'' and plantAddrLine2.GnrlCnfgQlfr = ''AddrLine2''
     left outer join GeneralConfiguration  plantCityName  on plantCityName.GnrlCnfgHdrID = origin.lcleid  and plantCityName.GnrlCnfgTblNme = ''Locale'' and plantCityName.GnrlCnfgQlfr = ''CityName''
     left outer join GeneralConfiguration  plantStateAbbreviation on plantStateAbbreviation.GnrlCnfgHdrID = origin.lcleid  and plantStateAbbreviation.GnrlCnfgTblNme = ''Locale'' and plantStateAbbreviation.GnrlCnfgQlfr = ''StateAbbreviation''
     left outer join GeneralConfiguration  plantPostalCode on plantPostalCode.GnrlCnfgHdrID = origin.lcleid  and plantPostalCode.GnrlCnfgTblNme = ''Locale'' and plantPostalCode.GnrlCnfgQlfr = ''PostalCode''
     left outer join #uomconversion on #uomconversion.acctdtlid = accountdetail.acctdtlid
	Left Outer Join	TransactionDetail	(NoLock) On	TransactionDetail. XDtlXHdrID 				= TransactionDetailLog. XDtlLgXDtlXHdrID
								and	TransactionDetail. XDtlDlDtlPrvsnID 		= TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID
								and	TransactionDetail. XDtlID 			= TransactionDetailLog. XDtlLgXDtlID
	Left Outer Join	TransactionHeader	(NoLock) On	TransactionDetailLog. XDtlLgXDtlXHdrID			= TransactionHeader. XHdrID
--JLR end
-- Do the extra join to Movement Header to get Net and Gross Quantity
	Left Outer Join MovementHeader MH On TransactionHeader.XHdrMvtDtlMvtHdrID = MH.MvtHdrID
	/* REMOVED - RLB CAUSING MULTIPLE SUMS OF TAXES, NOT USED Left Outer Join MovementDocument on MvtDcmntID = MH.MvtHdrMvtDcmntID*/
	Left outer join businessassociate carrier on carrier.baid = MH.MvtHdrCrrrBAID
	Left Outer Join dbo.GeneralConfiguration	as SCACCode	on SCACCode.GnrlCnfgHdrID = mh.MvtHdrID
								and  SCACCode.GnrlCnfgTblNme = ''MovementHeader''
								and  SCACCode.GnrlCnfgQlfr = ''SCAC'' 
	inner join dealdetail on dealdetail.dldtldlhdrid = accountdetail.AcctDtlDlDtlDlHdrID
	                     and dealdetail.dldtlid = accountdetail.AcctDtlDlDtlID
	left outer join GeneralConfiguration MvtShipto on MvtShipto.GnrlcnfgHdrID = MH.MvtHdrID
	                                              and MvtShipTo.GnrlCnfgQlfr = ''SAPMvtShipTo''
	                                              and MvtShipTo.GnrlCnfgTblNme = ''MovementHeader''
	left outer join MTVDealDetailShipTo on MTVDealDetailShipTo.DealDetailID = dealdetail.dealdetailid
    left outer join MTVSAPSoldToShipTo on MTVSAPSoldToShipTo.ID = SoldToShipToID
                                                   and MTVSAPSoldToShipTo.ShipTo = MvtShipTo.GnrlcnfgMulti
	left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = ''SapPlantCode''
												  and PlantCode.GnrlcnfgTblNme = ''Locale''
	'
select @vc_sql_where1 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	' + case when @i_slsinvceHdrID is null then 'is null ' else ' = ' + IsNull(convert(varchar,@i_slsinvcehdrid),'''') end + '  -- 65163 Changed for dynamic sql
 Group BY UnitOfMeasure.UOMDesc 
 --SalesInvoiceDetail.SlsInvceDtlPrUntVle
 --TransactionHeader.XHdrQty  * #uomconversion.conversionFactor
--	   , TransactionHeader.XHdrGrssQty  * #uomconversion.conversionFactor 
	,dealdetailprovision.costtype
         , case when DealDetailProvision.CostType = ''P'' then product.prdctnme when prvsn.prvsnnme like ''%prepay%'' then product.prdctnme else TransactionType.TrnsctnTypDesc  end 
		 
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When ''s'' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End 
         , Currency.CrrncySmbl 
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals
	, UnitOfMeasure.UOMAbbv

'

select @vc_sql_select2 = '

UNION ALL

 SELECT  sum(TransactionHeader.XHdrQty  * isnull(#uomconversion.conversionFactor,1)) ''NetQuantity''
	   , sum(TransactionHeader.XHdrGrssQty  * isnull(#uomconversion.conversionFactor,1)) ''GrossQuantity''
--		 , round( sum(accountdetail.value) / sum(accountdetail.volume  * isnull(#uomconversion.conversionFactor,1)), SalesInvoiceDetail.PerUnitDecimals) * -1 ''dtlpruntvle''
        , isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate )
         , sum ( SalesInvoiceDetail.SlsInvceDtlTrnsctnVle  ) ''dtltrnsctnvle''
         , sum( slsinvcedtltrnsctnqntty) volume
         , TaxRuleSet.InvoicingDescription ''Description''
         , UnitOfMeasure.UOMDesc ''UOMDesc''
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When ''s'' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End ''UOMSingularDesc''
         , Currency.CrrncySmbl ''Currency''
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals ''QuantityDecimalPlaces'' -- , @i_DecimalPlaces ''QuantityDecimalPlaces''
	 , 1 
	, case when TaxRuleSet.Type = ''F'' then ''%'' else UnitOfMeasure.UOMAbbv end
	, 1 recordtype
	, ''S''
    	'

select	@vc_sql_from2 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				= 	''T''
         Inner Join Currency Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.CrrncyID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID		= 	ChildProduct.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID				= 	UnitOfMeasure.UOM
         Inner Join Contact 				On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
	 Inner Join TaxDetailLog			On	TaxDetailLog.TxDtlLgID 					= 	AccountDetail.AcctDtlSrceID
	 Inner Join TaxDetail				On	TaxDetail.TxDtlID					= 	TaxDetailLog.TxDtlLgTxDtlID
	 left outer Join TransactionHeader       On  TransactionHeader.XhdrID = TaxDetail.TxDtlXHdrID
	 left outer join TaxRuleSet on taxDetail.TxID = TaxRuleSet.TxID
	                             and TaxDetail.TxRleStID = TaxRuleSet.TxRleStID
	 left outer join MovementDocument on MovementDocument.MvtDcmntID = TransactionHeader.XHdrMvtDcmntID
	 /* REMOVED - RLB CAUSING MULTIPLE SUMS OF TAXES, NOT USED Left Outer Join MovementDocument on MvtDcmntID = MH.MvtHdrMvtDcmntID*/
	 Inner Join GeneralConfiguration		On	GeneralConfiguration.GnrlCnfgTblNme			=	''System''		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	''DBMSUOM''		-- 65163
	Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	 Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	 Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	''DealDeliveryTerm''
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
	left outer join #UOMConversion on #UOMConversion.acctdtlid = accountdetail.acctdtlid
	left outer join GeneralConfiguration Plantcode on PlantCode.GnrlCnfgHdrID = origin.lcleid 
	                                              and PlantCode.GnrlCnfgQlfr = ''SapPlantCode''
												  and PlantCode.GnrlcnfgTblNme = ''Locale''
    left outer join v_MTV_TaxRates on v_mtv_taxrates.acctdtlid = accountdetail.acctdtlid
    left outer join MTV_AccountDetailTaxRateArchive on MTV_AccountDetailTaxRateArchive.AcctDtlID = AccountDetail.acctdtlid
	'

select @vc_sql_where2 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	' + case when @i_slsinvceHdrID is null then 'is null ' else ' = ' + IsNull(convert(varchar,@i_slsinvcehdrid),'''') end + ' -- 65163 Changed for dynamic sql
	group by
	  TaxRuleSet.InvoicingDescription
     , isnull(MTV_AccountDetailTaxRateArchive.TaxRate, v_MTV_TaxRates.TaxRate )
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals
	 , UnitOfMeasure.UOMDesc
	 , case when TaxRuleSet.Type = ''F'' then ''%'' else UnitOfMeasure.UOMAbbv end
	 , AccountDetail.AcctDtlUOMID
	 , Currency.CrrncySmbl
	'

select @vc_sql_Select3 = '
UNION ALL
 SELECT  sum(MnlSlsInvceDtlQntty) ''NetQuantity''
	   , sum(MnlSlsInvceDtlQntty ''GrossQuantity''
		 , (sum(accountdetail.value) / sum(accountdetail.volume )) *-1 ''dtlpruntvle''
         , sum ( MnlSlsInvceDtlVle ) ''dtltrnsctnvle''
         , sum( MnlSlsInvceDtlQntty) volume
		 , MnlSlsInvceDtlDscrptn ''Description''
         , UnitOfMeasure.UOMDesc ''UOMDesc''
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When ''s'' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End ''UOMSingularDesc''
         , Currency.CrrncySmbl ''Currency''
	 , 2
	 , 2
	 , 1 converstionfactor
	, UnitOfMeasure.UOMAbbv
	,0 recordtype
	,''S''
'
Select  @vc_sql_From3 = '
   FROM ManualSalesInvoiceDetail 
         Inner Join SalesInvoiceHeader 			On 	ManualSalesInvoiceDetail.MnlSlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         inner join ManualSalesInvoiceDetailLog lg on lg.MnlSlsInvceDtlID = ManualSalesInvoiceDetail.MnlSlsInvceDtlID
                                         and lg.SlsInvceHdrId = ManualSalesInvoiceDetail.MnlSlsInvceDtlSlsInvceHdrID
          inner join AccountDetail on AccountDetail.AcctDtlSrceID = lg.MnlSlsInvceDtlLgID
                        and AccountDetail.AcctDtlSrceTble = ''I''
         left outer  Join DealHeader on DealHeader.DlHdrID = ManualSalesInvoiceDetail.MnlSlsInvceDtlDlHdrID
         Inner Join Currency			    On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.crrncyid
         left outer join BusinessAssociate Internal on Internal.Baid = SalesInvoiceHeader.SlsInvceHdrIntrnlBAID
         Left Outer Join Product ChildProduct on ChildProduct.PrdctID = ManualSalesInvoiceDetail.MnlSlsInvceDtlChldPrdctID
		 Inner Join Product				    On ManualSalesInvoiceDetail.MnlSlsInvceDtlPrdctID = Product.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID	 			= 	UnitOfMeasure.UOM
												  
	'
select @vc_sql_where3 = '
   WHERE ManualSalesInvoiceDetail.MnlSlsInvceDtlSlsInvceHdrID 	' + case when @i_slsinvceHdrID is null then 'is null ' else ' = ' + IsNull(convert(varchar,@i_slsinvcehdrid),'''') end + '  -- 65163 Changed for dynamic sql
 Group BY
	  MnlSlsInvceDtlDscrptn
	 , UnitOfMeasure.UOMDesc, UnitOfMeasure.UOMAbbv
	 , AccountDetail.AcctDtlUOMID
	 , Currency.CrrncySmbl
order by   14,15,6 --RecordType , costtype, description
 
 '



if upper(@c_showsql) = 'Y'
begin
	select @vc_sql_select1
	select @vc_sql_from1
	select @vc_sql_where1
	select @vc_sql_select2
	select @vc_sql_from2
	select @vc_sql_where2
	select @vc_sql_select3
	select @vc_sql_from3
	select @vc_sql_where3
end
else
	execute (@vc_sql_select1 + @vc_sql_from1 + @vc_sql_where1 + @vc_sql_select2 + @vc_sql_from2 + @vc_sql_where2)


GO

