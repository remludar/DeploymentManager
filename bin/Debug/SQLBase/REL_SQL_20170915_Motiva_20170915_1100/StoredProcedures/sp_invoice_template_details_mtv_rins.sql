/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_invoice_template_details_mtv_rins WITH YOUR (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_details_mtv_rins]   Script Date: DATECREATED ******/
PRINT 'Start Script=[sp_invoice_template_details_mtv_rins].sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv_rins]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_invoice_template_details_mtv_rins] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure [sp_invoice_template_details_mtv_rins] >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[sp_invoice_template_details_mtv2_bulk]    Script Date: 5/16/2016 11:48:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


ALTER Procedure [dbo].[sp_invoice_template_details_mtv_rins] @i_slsinvcehdrid int, @c_showsql char(1) = 'N'
As
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	sp_invoice_template_details 24          Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	@i_slsinvcehdrid	Sales Invoice Header ID
-- SPs:
-- Temp Tables:
-- Created by:	Tracy Baird
-- History:	5/7/2002 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
-- 	06/10/2002	JLR			changed the join for destination locales.
--	06/28/2002	HMD		27307	If we have no non-tax details and at least one tax detail,
--						get the location and contact info with a union all
--	06/28/2002	HMD		27650	If the delivery term ID is null, do not bring back a transfer point location
--	01/06/2003	HMD		29304	If tax is being invoiced alone, if possible, get description from related product detail
--	10/28/2003	HMD		43705	For union when taxes are invoiced alone, use left outer join to TransactionHeader
--						in case the parent transaction is a time transaction
-- 	5/20/2004	TSB		29616	Added column UOMAbbv so that I can show each details UOM in case of multiple UOMS.
--	06/16/2004	JLR		49651	added energy.
--	08/02/2006	Jk		65163	Convert UOM using GetUOMConversionFactorSQL function; change to dynamic sql to incorporate function call;
--						convert from system UOM instead of assuming gallons
--	05/30/2007	TSB		71114	Changed the join to Product to be joining on SalesInvoiceDetail.Child Prdct ID.  It was join on some currency ID
------------------------------------------------------------------------------------------------------------------------------
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
	@vc_sql_where2 varchar(8000)		-- 65163
/*
Select @vc_UOMAbbv = UOMAbbv 
From	SalesInvoiceHeader
	Inner Join UnitofMeasure on (SlsInvceHdrUOM = UOM)
Where	SlsInvceHdrID = @i_slsinvcehdrid

select @vc_key = 'System\SalesInvoicing\UOMQttyDecimals\' + @vc_UOMAbbv

Exec sp_get_registry_value @vc_key, @vc_value out

if @vc_value is not null
 	Select @i_DecimalPlaces = Convert(int, @vc_value)
*/
select @vc_sql_select1 = '
 SELECT SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr ''ContractNumberInternal''
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlNbr,'''') ''ContractNumberExternal''
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) ''OriginLcleID''
	 , Isnull(Origin. LcleAbbrvtn + Origin. LcleAbbrvtnExtension,'''') ''Origin''
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) ''DestinationLcleID''
	 , Isnull(Destination. LcleAbbrvtn + Destination. LcleAbbrvtnExtension,'''') ''Destination''
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) ''TransferPointLcleID''
	 --, Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'') ''TransferPoint''
	 , Case  
	      When  DynamicListBox.DynLstBxAbbv  is null then ''''
	      Else Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'''')
	    End ''TransferPoint''
	 , Contact.CntctFrstNme + '' '' + Contact.CntctLstNme ''ExternalContact''
         , SalesInvoiceDetail.SlsInvceDtlMvtHdrDte ''TransactionDate''
         , Case AccountDetail.AcctDtlSrceTble
              When ''T'' then 0
	      Else SalesInvoiceDetail.SlsInvceDtlTrnsctnQntty * ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + '  -- 65163
           End ''dtltrnsctnqntty''
         , SalesInvoiceDetail.SlsInvceDtlPrUntVle / ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + ' ''dtlpruntvle''  -- 65163
         , SalesInvoiceDetail.SlsInvceDtlTrnsctnVle ''dtltrnsctnvle''
         , DynamicListBox.DynLstBxAbbv + Case When DynamicListBox.DynLstBxAbbv Is Null Then '''' Else '':'' End ''DeliveryTerm''
         , SalesInvoiceDetail.DescriptionColumn ''Description''
         , SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty ''SpecificGravity''
         , UnitOfMeasure.UOMDesc ''UOMDesc''
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When ''s'' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End ''UOMSingularDesc''
         , Currency.PrdctAbbv ''Currency''
         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID ''PrdctID''
         , SalesInvoiceDetail.SlsInvceDtlMvtDcmntExtrnlDcmnt ''ExtMovementDocument''
         , Case AccountDetail.AcctDtlSrceTble 
                When ''T'' then ''Tax'' 
                Else TransactionType.TrnsctnTypCtgry
           End ''DetailType''
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals
	 , ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + '  -- 65163
	, UnitOfMeasure.UOMAbbv
	, ChildProduct.PrdctEnrgy ''Energy''
	, prodGenConfig.GnrlCnfgMulti as ''ProductCode''
	, localeGenConfig.GnrlCnfgMulti as ''PlantCode''
	,childproduct.PrdctNme
	'

select @vc_sql_from1 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
	 Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				<> 	''T''
         Inner Join Product Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.PrdctID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID 		= 	ChildProduct.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID	 			= 	UnitOfMeasure.UOM
         Left Outer Join Contact 			On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
	 Inner Join GeneralConfiguration		On	GeneralConfiguration.GnrlCnfgTblNme			=	''System''		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	''DBMSUOM''		-- 65163

	--MV Start
	 --MV Start
	left Join GeneralConfiguration	 prodGenConfig	On	prodGenConfig.GnrlCnfgTblNme			=	''Product''		
							And	prodGenConfig.GnrlCnfgQlfr 			= 	''SAPMaterialCode''		
							And prodGenConfig.GnrlCnfgHdrID			=	SalesInvoiceDetail.SlsInvceDtlPrntPrdctID

	left Join GeneralConfiguration	 localeGenConfig		On	localeGenConfig.GnrlCnfgTblNme			=	''Locale''		
							And	localeGenConfig.GnrlCnfgQlfr 			= 	''SAPPlantCode''		
							And localeGenConfig.GnrlCnfgHdrID			=	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID

	--MV End
	 Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
--JLR	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Destination. LcleID
	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	 Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	 Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	''DealDeliveryTerm''
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
--	 Inner Join v_UOMConversion			on 	AccountDetail.AcctDtlUOMID				= 	v_UOMConversion.ToUOM		-- 65163 Use function instead
--							And	v_UOMConversion.FromUOM					= 	3
--JLR start
	Left Outer Join	TransactionDetailLog	(NoLock) On 	AccountDetail. AcctDtlSrceID 				= TransactionDetailLog. XDtlLgID
	Left Outer Join	TransactionDetail	(NoLock) On	TransactionDetail. XDtlXHdrID 				= TransactionDetailLog. XDtlLgXDtlXHdrID
								and	TransactionDetail. XDtlDlDtlPrvsnID 		= TransactionDetailLog. XDtlLgXDtlDlDtlPrvsnID
								and	TransactionDetail. XDtlID 			= TransactionDetailLog. XDtlLgXDtlID
	Left Outer Join	TransactionHeader	(NoLock) On	TransactionDetailLog. XDtlLgXDtlXHdrID			= TransactionHeader. XHdrID
--JLR end
	'
select @vc_sql_where1 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	' + case when @i_slsinvceHdrID is null then 'is null ' else ' = ' + IsNull(convert(varchar,@i_slsinvcehdrid),'''') end + '  -- 65163 Changed for dynamic sql

'

select @vc_sql_select2 = '

UNION ALL

 SELECT  Distinct SalesInvoiceDetail.SlsInvceDtlDlHdrIntrnlNbr ''ContractNumberInternal''
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlNbr,'''') ''ContractNumberExternal''
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlOrgnLcleID,0) ''OriginLcleID''
	 , Isnull(Origin. LcleAbbrvtn + Origin. LcleAbbrvtnExtension,'''') ''Origin''
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlDstntnLcleID,0) ''DestinationLcleID''
	 , Isnull(Destination. LcleAbbrvtn + Destination. LcleAbbrvtnExtension,'''') ''Destination''
	 , Isnull(SalesInvoiceDetail.SlsInvceDtlFOBLcleID,0) ''TransferPointLcleID''
	 --, Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'') ''TransferPoint''
	 , Case  
	      	When  DynamicListBox.DynLstBxAbbv  is null then ''''
	      	Else Isnull(TransferPoint. LcleAbbrvtn + TransferPoint. LcleAbbrvtnExtension,'''')
	    End ''TransferPoint''
	 , Contact.CntctFrstNme + '' '' + Contact.CntctLstNme ''ExternalContact''
         , SalesInvoiceDetail.SlsInvceDtlMvtHdrDte ''TransactionDate''
	 , SalesInvoiceDetail.SlsInvceDtlTrnsctnQntty * ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + ' ''dtltrnsctnqntty''  -- 65163

         , 0 /*Case 
		When FromUOMTpe <> TOUOMTpe then (SlsInvceDtlPrUntVle / SlsInvceDtlSpcfcGrvty) / ConversionFactor
		Else SlsInvceDtlPrUntVle / ConversionFactor
	   End*/ ''dtlpruntvle''
         , 0 /*SalesInvoiceDetail.SlsInvceDtlTrnsctnVle*/ ''dtltrnsctnvle''
         , DynamicListBox.DynLstBxAbbv + Case When DynamicListBox.DynLstBxAbbv Is Null Then '''' Else '':'' End ''DeliveryTerm''
         , Case
		When TaxDetail.TxDtlSrceTble = "A" And ParentSID.DescriptionColumn 	Is Not Null Then ParentSID.DescriptionColumn
		When TaxDetail.TxDtlSrceTble = "X" And RelatedSID.DescriptionColumn 	Is Not Null Then RelatedSID.DescriptionColumn
		Else SalesInvoiceDetail.SlsInvceDtlMvtDcmntExtrnlDcmnt 
	   End ''Description''
         , 0 /*SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty*/ ''SpecificGravity''
         , UnitOfMeasure.UOMDesc ''UOMDesc''
         , Case lower(Right(UnitOfmeasure.UOMDesc,1) )
              When ''s'' then Left(UnitOfMeasure.UOMDesc,Len(UnitOfMeasure.UOMDesc)-1) 
              else UnitOfMeasure.UOMDesc
           End ''UOMSingularDesc''
         , Currency.PrdctAbbv ''Currency''
         , SalesInvoiceDetail.SlsInvceDtlPrntPrdctID ''PrdctID''
         , SalesInvoiceDetail.SlsInvceDtlMvtDcmntExtrnlDcmnt ''ExtMovementDocument''
         , Case AccountDetail.AcctDtlSrceTble 
                When ''T'' then ''Tax'' 
                Else TransactionType.TrnsctnTypCtgry
           End ''DetailType''
	 , SalesInvoiceDetail.PerUnitDecimals
	 , SalesInvoiceDetail.QuantityDecimals ''QuantityDecimalPlaces'' -- , @i_DecimalPlaces ''QuantityDecimalPlaces''
	 , ' + dbo.GetUOMConversionFactorSQL('convert(int,GeneralConfiguration.GnrlCnfgMulti)', 'AccountDetail.AcctDtlUOMID', 'SalesInvoiceDetail.SlsInvceDtlSpcfcGrvty', 'coalesce(TransactionHeader.Energy,ChildProduct.PrdctEnrgy)') + '  -- 65163
	, UnitOfMeasure.UOMAbbv
	, ChildProduct.PrdctEnrgy ''Energy''
	, prodGenConfig.GnrlCnfgMulti as ''ProductCode''
	, localeGenConfig.GnrlCnfgMulti as ''PlantCode''
	,childproduct.PrdctNme
	'

select	@vc_sql_from2 = '
    FROM SalesInvoiceDetail
         Inner Join SalesInvoiceHeader 			On 	SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 		= 	SalesInvoiceHeader.SlsInvceHdrID
         Inner Join AccountDetail 			On  	SalesInvoiceDetail.SlsInvceDtlAcctDtlID 		= 	AccountDetail.AcctDtlID
                                  			And  	AccountDetail.AcctDtlSrceTble 				= 	''T''
         Inner Join Product Currency			On 	SalesInvoiceHeader.SlsInvceHdrCrrncyID 			= 	Currency.PrdctID
         Inner Join Product ChildProduct		On 	SalesInvoiceDetail.SlsInvceDtlChldPrdctID		= 	ChildProduct.PrdctID
         Inner Join UnitOfMeasure 			On 	AccountDetail.AcctDtlUOMID				= 	UnitOfMeasure.UOM
         Inner Join Contact 				On 	SalesInvoiceDetail.SlsInvceDtlDlHdrExtrnlCntctID 	= 	Contact.CntctID
         Inner Join TransactionType 			On 	SalesInvoiceDetail.SlsInvceDtlTrnsctnTypID 		= 	TransactionType.TrnsctnTypID
	 Inner Join TaxDetailLog			On	TaxDetailLog.TxDtlLgID 					= 	AccountDetail.AcctDtlSrceID
	 Inner Join TaxDetail				On	TaxDetail.TxDtlID					= 	TaxDetailLog.TxDtlLgTxDtlID
	 Inner Join GeneralConfiguration		On	GeneralConfiguration.GnrlCnfgTblNme			=	''System''		-- 65163
							And	GeneralConfiguration.GnrlCnfgQlfr 			= 	''DBMSUOM''		-- 65163

	 --MV Start
	left Join GeneralConfiguration	 prodGenConfig	On	prodGenConfig.GnrlCnfgTblNme			=	''Product''		
							And	prodGenConfig.GnrlCnfgQlfr 			= 	''SAPMaterialCode''		
							And prodGenConfig.GnrlCnfgHdrID			=	SalesInvoiceDetail.SlsInvceDtlPrntPrdctID

	left Join GeneralConfiguration	 localeGenConfig		On	localeGenConfig.GnrlCnfgTblNme			=	''Locale''		
							And	localeGenConfig.GnrlCnfgQlfr 			= 	''SAPPlantCode''		
							And localeGenConfig.GnrlCnfgHdrID			=	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID

	--MV End

	 Left Outer Join TransactionHeader		On	TaxDetail.TxDtlXHdrID					= 	TransactionHeader.XHdrID
	 Left Outer Join Locale as Origin 		On 	SalesInvoiceDetail.SlsInvceDtlOrgnLcleID 		= 	Origin. LcleID
	 Left Outer Join Locale as Destination 		On 	SalesInvoiceDetail.SlsInvceDtlDstntnLcleID 		= 	Destination. LcleID  --JLR added
	 Left Outer Join Locale as TransferPoint 	On 	SalesInvoiceDetail.SlsInvceDtlFOBLcleID 		= 	TransferPoint. LcleID
	 Left Outer Join DynamicListBox 		On 	DynamicListBox.DynLstBxQlfr 				= 	''DealDeliveryTerm''
                                        		And 	DynamicListBox.DynLstBxTyp 				= 	SalesInvoiceDetail.SlsInvceDtlDlvryTrmID
--	 Inner Join v_UOMConversion			on 	SalesInvoiceHeader.SlsInvceHdrUOM			= 	v_UOMConversion.ToUOM		-- 65613 Use function instead
--							And	v_UOMConversion.FromUOM					= 	3				-- 65613
	 Left Outer Join AccountDetail ParentAD		On	AccountDetail.AcctDtlPrntID				= 	ParentAD.AcctDtlID
	 Left Outer Join SalesInvoiceDetail ParentSID	On	ParentAD.AcctDtlID					= 	ParentSID.SlsInvceDtlAcctDtlID
	 Left Outer Join TransactionDetail		On	TransactionHeader.XHdrID				= 	TransactionDetail.XDtlXHdrID
							And	TransactionDetail.XDtlLstInChn				= 	''Y''
	 Left Outer Join DealDetailProvision		On	TransactionDetail.XDtlDlDtlPrvsnID			= 	DealDetailProvision.DlDtlPrvsnID
							And	DealDetailProvision.CostType				= 	''P''
	 Left Outer Join TransactionDetailLog		On	TransactionDetail.XDtlXHdrID				= 	TransactionDetailLog.XDtlLgXDtlXHdrID
							And	TransactionDetail.XDtlID				= 	TransactionDetailLog.XDtlLgXDtlID
							And	TransactionDetail.XDtlDlDtlPrvsnID			= 	TransactionDetailLog.XDtlLgXDtlDlDtlPrvsnID
							And	TransactionDetailLog.XDtlLgRvrsd			= 	''N''
	 Left Outer Join AccountDetail RelatedAD	On	TransactionDetailLog.XDtlLgID				= 	RelatedAD.AcctDtlSrceID
							And	RelatedAD.AcctDtlSrceTble				= 	''X''
	 Left Outer Join SalesInvoiceDetail RelatedSID	On	RelatedAD.AcctDtlID					= 	RelatedSID.SlsInvceDtlAcctDtlID
	'

select @vc_sql_where2 = '
   WHERE SalesInvoiceDetail.SlsInvceDtlSlsInvceHdrID 	' + case when @i_slsinvceHdrID is null then 'is null ' else ' = ' + IsNull(convert(varchar,@i_slsinvcehdrid),'''') end + ' -- 65163 Changed for dynamic sql
	AND NOT EXISTS (Select 	'''' 
			From 	AccountDetail 
			Where 	AcctDtlSlsInvceHdrID 	' + case when @i_slsinvceHdrID is null then 'is null ' else ' = ' + IsNull(convert(varchar,@i_slsinvcehdrid),'''') end + ' -- 65163
			And 	AcctDtlSrceTble 	<> ''T'' )

	'

if upper(@c_showsql) = 'Y'
begin
	select @vc_sql_select1
	select @vc_sql_from1
	select @vc_sql_where1
	select @vc_sql_select2
	select @vc_sql_from2
	select @vc_sql_where2
end
else
	execute (@vc_sql_select1 + @vc_sql_from1 + @vc_sql_where1 + @vc_sql_select2 + @vc_sql_from2 + @vc_sql_where2)

GO


IF  OBJECT_ID(N'[dbo].[sp_invoice_template_details_mtv_rins]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_invoice_template_details_mtv_rins.sql'
	PRINT '<<< ALTERED StoredProcedure sp_invoice_template_details_mtv_rins >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_invoice_template_details_mtv_rins >>>'
END
 


GO


