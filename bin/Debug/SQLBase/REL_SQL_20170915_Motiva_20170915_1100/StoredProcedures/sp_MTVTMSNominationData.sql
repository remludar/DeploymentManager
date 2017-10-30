
/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTVTMSNominationData WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MTVTMSNominationData]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTMSNominationData.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSNominationData]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTVTMSNominationData] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTV_TMSNominationData >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



--exec sp_MTVTMSNominationData 5051
ALTER PROCEDURE [dbo].sp_MTVTMSNominationData @orderid int
As

select  convert(int,PlannedSet.PlnndStSqnceNmbr) sequence, (Select Registry.RgstryDtaVle From Registry where RgstryKyNme = 'MotivaAccountNo') MotivaAccountNo
 , (select max( ps2.PlnndStSqnceNmbr ) from PlannedSet ps2 where ps2.PlnndStPlnndMvtID = pm.PlnndMvtID ) UnlikeSequence
                        , ( select gc2.gnrlcnfgmulti 
                              from plannedset ps2 
                                   inner join locale l2 on l2.lcleid = ps2.PlnndStLcleID 
	                               inner join GeneralConfiguration gc2 on gc2.gnrlcnfghdrid = l2.lcleid
	                                          and gc2.gnrlcnfgqlfr = 'SapPlantCode'
										      and gc2.gnrlcnfgtblnme = 'locale'
                            where ps2.PlnndStSqnceNmbr = case when plannedset.PlnndStSqnceNmbr = 2 then 1 else 2 end 
                              and ps2.PlnndStPlnndMvtID = pm.PlnndMvtID 
                           ) unlikedestination

                         , ptor.PTReceiptDelivery recdel_r
                         , ptod.PTReceiptDelivery recdel_d                    
                         , dd_r.dldtlprdctid prod_id_r  --???? Product Eq. Term: product 2 - regrade
                         , dd_d.dldtlprdctid prod_id_d  --???? Product Eq. Term: product 2 - regrade
                         , 'Delivery' recdel
                         , 'U' Action
                         , case when locale_d.lcleabbrvtn = Bomp.RgstryDtaVle then 'O' else 'I' end rec_type
                         , convert(varchar(10),pm.plnndmvtid) order_no
                         , isnull(SAPPlantCode_r.GnrlCnfgMulti,'N/A') sapplantcode_r
                         , isnull(SAPPlantCode_d.GnrlCnfgMulti,'N/A') sapplantcode_d
                         , ( select soldto From mtvsapbasoldto where id = convert(int,isnull(soldto_r.gnrlcnfgmulti,0))) soldto_r
                         , ( select soldto From mtvsapbasoldto where id = convert(int,isnull(soldto_d.gnrlcnfgmulti,0))) soldto_d
                         , isnull(ss_r.shipto,'') shipto_r
                         , isnull(ss_d.shipto,'') shipto_d
                         , pm.PlnndMvtRtePlnHdrID
                         , rtrim(dealtype_r.description) dealheadertype_r
                         , rtrim(dealtype_d.description) dealheadertype_d
                         , dealtype_r.IsLogistics islogistics_r
                         , dealtype_d.IsLogistics isLogistics_d
                         , dealtype_r.IsTransportation isTransport_r
                         , dealtype_d.IsTransportation isTransport_d
                         , baexternal_r.batpe externalbatpe_r
                         , baexternal_d.batpe externalbatpe_d
                         , substring(baexternal_r.Baabbrvtn,1,10) externalbaabbrvtn_r
                         , substring(baexternal_d.Baabbrvtn,1,10) externalbaabbrvtn_d
                         , substring( convert(char(4),datepart(yy,ptor.estimatedmovementdate)),3,2) +  case when datepart(mm,ptor.estimatedmovementdate) < 10 then '0' + convert(char(1),datepart(mm,ptor.estimatedmovementdate)) else  convert(char(2),datepart(mm,ptor.estimatedmovementdate)) end + 
                               case when datepart(dd,ptor.estimatedmovementdate) < 10 then '0' + convert(char(1),datepart(dd,ptor.estimatedmovementdate)) else  convert(char(2),datepart(dd,ptor.estimatedmovementdate)) end estimatedmovementdate_r
                         , substring( convert(char(4),datepart(yy,ptod.estimatedmovementdate)),3,2) +  case when datepart(mm,ptod.estimatedmovementdate) < 10 then '0' + convert(char(1),datepart(mm,ptod.estimatedmovementdate)) else  convert(char(2),datepart(mm,ptod.estimatedmovementdate)) end + 
                               case when datepart(dd,ptod.estimatedmovementdate) < 10 then '0' + convert(char(1),datepart(dd,ptod.estimatedmovementdate)) else  convert(char(2),datepart(dd,ptod.estimatedmovementdate)) end estimatedmovementdate_d

                         ,case when datepart(hh, ptor.estimatedmovementdate) < 10 then '0' + convert(char(1),datepart( hh, ptor.estimatedmovementdate)) else convert(char(2),datepart( hh, ptor.estimatedmovementdate)) end + case when datepart(hh,ptor.estimatedmovementdate) < 10 then '0' +  convert(char(1),datepart(mi, ptor.estimatedmovementdate)) else convert(char(2),datepart(mi, ptor.estimatedmovementdate)) end  estimatedmovementtime_r
                         ,case when datepart(hh, ptod.estimatedmovementdate) < 10 then '0' + convert(char(1),datepart( hh, ptod.estimatedmovementdate)) else convert(char(2),datepart( hh, ptod.estimatedmovementdate)) end + case when datepart(hh,ptod.estimatedmovementdate) < 10 then '0' +  convert(char(1),datepart(mi, ptod.estimatedmovementdate)) else convert(char(2),datepart(mi, ptod.estimatedmovementdate)) end  estimatedmovementtime_d
                         , pm.PlnndMvtFrmDte order_date
                         , case when len( TransType_R.DynLstBxAbbv) < 5 then isnull(TransType_R.DynLstBxAbbv,'')  + '     ' else TransType_R.DynLstBxAbbv end Transport_r  --xref transportationtransid ??
                         , case when len( TransType_D.DynLstBxAbbv) < 5 then isnull(TransType_D.DynLstBxAbbv,'') +  '      ' else TransType_D.DynLstBxAbbv end  Transport_d
                         , isnull(scac_r.gnrlcnfgmulti,'N/A') scac_r
                         , isnull(scac_d.gnrlcnfgmulti,'N/A') scac_d
                         , coalesce(scac_r.Gnrlcnfgmulti,scac_d.Gnrlcnfgmulti,'N/A') scac
                         , 'Y' UOM
                         , 'N' limit_order
                          , 'Y' validate_pidx_consignee
                         , substring(dh_r.dlhdrintrnlnbr,1,15) contract_number_r
                         , substring(dh_d.dlhdrintrnlnbr,1,15) contract_number_d
                         , convert(varchar(10),contractxref_r.TMSSupplierNO) TMSSupplierNO_r
                         , convert(varchar(10),contractxref_r.TMSCustomerNO) TMSCustomerNO_r
                         , case when contractxref_r.DlHdrID is null then 'N' else 'Y' end Is3rdPartyTA_r
                         , convert(varchar(10),contractxref_d.TMSSupplierNO) TMSSupplierNO_d
                         , convert(varchar(10),contractxref_d.TMSCustomerNO) TMSCustomerNO_d
                         , case when contractxref_d.DlHdrID is null then 'N' else 'Y' end Is3rdPartyTA_d
                         , cotmajor_d.VendorNumber vendor_d
                         , cotmajor_r.VendorNumber vendor_r
                         , pm.PlnndMvtFrmDte
                         , pm.PlnndMvtToDte
                         , pmb.name order_comments
                         , substring(hostpo.gnrlcnfgmulti,1,20) host_po_number
                         , substring(pm.PONumber,1,10) po_number
                         , substring(releaseno.gnrlcnfgmulti,1,10) release_no
                         , '0' compartment
                         ,  convert(varchar(10),round(convert(decimal,pm.PlnndMvtTtlQntty,0),0)) order_qtyg
                         , convert(varchar(10),round(pm.PlnndMvtTtlQntty / 42,0)) order_qtyb
                         , dd_r.DlDtlprdctID prod_id_r  
                         , dd_d.DlDtlPrdctID prod_id_d
                         , MatCode6_r.TMSCode  productcode_r
                         , MatCode6_d.TMSCode  productcode_d
                         , case when locale_d.lcleabbrvtn = Bomp.RgstryDtaVle then '0' else ' ' end Retained_a1  
                         , case when locale_d.lcleabbrvtn = Bomp.RgstryDtaVle then '0' else ' ' end Loaded_a1  
                         , case when locale_d.lcleabbrvtn = Bomp.RgstryDtaVle then '0' else ' ' end returned_a1  
                         , 'G' UOM
						 , vtweg_r.GnrlCnfgMulti vtweg_r
						 , vtweg_d.GnrlCnfgMulti vtweg_d
						 , cotminor_r.ClassOfTrade cotmin_r
						 , cotminor_d.ClassOfTrade cotmin_d
                         , sapcust_r.gnrlcnfgmulti sapcustomer_r
                         , sapcust_d.gnrlcnfgmulti sapcustomer_d
                         , case when deliveryterm_r.DynLstBxAbbv = 'FOB' then 'Y' else 'N' end isfob_r
                         , case when deliveryterm_d.DynLstBxAbbv = 'FOB' then 'Y' else 'N' end isfob_d
                         , substring(gcbaseplant_r.gnrlcnfgmulti,1,10) baseplant_r 
                         , substring(gcbaseplant_d.gnrlcnfgmulti,1,10) baseplant_d
						 , substring(trans_id_r.ElementValue,1,3) trans_id_r
						 , substring(trans_id_d.ElementValue,1,3) trans_id_d
                         , substring(externalbatch.GnrlCnfgMulti,1,30) order_batch_name
						 , bcv_d.BasePrdctid BasePrdctid_d
                         , MatCodeBase.TMSCode BaseProductCode
						 , bcv_d.RegradePercentage RegradePercentage_d
						 , case when contractxref_r.DlHdrID is not null AND dealtype_r.IsLogistics = 'Y' and dealtype_d.IsTransportation = 'N' and bcv_r.BasePrdctid <> dd_r.DlDtlPrdctID and bcv_r.RegradePercentage = 100 then 'Y'  
						        when baexternal_d.batpe = 'D' and dealtype_d.IsLogistics = 'Y' and dealtype_d.IsTransportation = 'N' and bcv_d.BasePrdctid <> dd_d.DlDtlPrdctID and bcv_d.RegradePercentage = 100 then 'Y' else 'N' end   IsRebrand
						 , case when bainternal_r.baabbrvtn = IsMotivaStl.RgstryDtaVle then 'Y' else 'N' end IsMotivaSTL_r
						 , case when bainternal_d.baabbrvtn = IsMotivaStl.RgstryDtaVle then 'Y' else 'N' end IsMotivaSTL_d
                     From dbo.PlannedMovement pm
                                 inner join dbo.PlannedSet on PlannedSet.PlnndStPlnndMvtID = pm.PlnndMvtID
                                 left outer join PlannedMovementInPlannedMovementBatch pmbpm on pmbpm.PlnndMvtID = pm.PlnndMvtID
                                 left outer join PlannedMovementBatch pmb on pmb.PlnndMvtBtchID = pmbpm.PlnndMvtBtchID
                                 inner join dbo.PlannedTransfer ptor on ptor.PlnndTrnsfrPlnndStPlnndMvtID = pm.PlnndMvtID and ptor.PlnndTrnsfrPlnndStSqnceNmbr = PlannedSet.PlnndStSqnceNmbr and ptor.PTReceiptDelivery = 'R'
                                 inner join dbo.PlannedTransfer ptod on ptod.PlnndTrnsfrPlnndStPlnndMvtID = pm.PlnndMvtID and ptod.PlnndTrnsfrPlnndStSqnceNmbr = PlannedSet.PlnndStSqnceNmbr and ptod.PTReceiptDelivery = 'D'
                                 inner join dbo.DealHeader dh_r on dh_r.dlhdrid = ptor.PlnndTrnsfrObDlDtlDlHdrID
                                 inner join dbo.DealHeader dh_d on dh_d.dlhdrid = ptod.PlnndTrnsfrObDlDtlDlHdrID
                                 inner join dbo.DealType dealtype_r on dealtype_r.DlTypID = dh_r.DlHdrTyp
                                 inner join dbo.DealType dealtype_d on dealtype_d.DlTypID = dh_d.DlHdrTyp
                                 inner join dbo.BusinessAssociate bainternal_r on bainternal_r.baid = dh_r.dlhdrintrnlbaid 
                                 inner join dbo.BusinessAssociate baexternal_r on baexternal_r.baid = dh_r.dlhdrextrnlbaid
                                 inner join dbo.BusinessAssociate bainternal_d on bainternal_d.baid = dh_d.dlhdrintrnlbaid
                                 inner join dbo.BusinessAssociate baexternal_d on baexternal_d.baid = dh_d.dlhdrextrnlbaid
                                 inner join dbo.Locale locale_r on locale_r.lcleid = ptor.PhysicalLcleID
                                 inner join dbo.locale locale_d on locale_d.lcleid = ptod.PhysicalLcleID
								 inner join dbo.DealDetail dd_r on dd_r.DlDtlDlHdrID = ptor.PlnndTrnsfrObDlDtlDlHdrID
								                             and dd_r.DlDtlID = ptor.PlnndTrnsfrObDlDtlID					             
								 inner join dbo.DealDetail dd_d on dd_d.DlDtlDlHdrID = ptod.PlnndTrnsfrObDlDtlDlHdrID
								                             and dd_d.DlDtlID = ptod.PlnndTrnsfrObDlDtlID			
                                 left outer join BalanceConfigView bcv_R on bcv_r.DlDtlDlHdrID = dd_r.DlDtlDlHdrID
                                                                        and bcv_r.DlDtlID = dd_r.DlDtlID
																		and bcv_r.RegradePercentage = ( select max(v2.regradepercentage)
																		                                  from BalanceConfigView v2
																										  where v2.DlDtlDlHdrID = bcv_r.DlDtlDlHdrID
																										    and v2.DlDtlID = bcv_r.DlDtlID )
                                 left outer join GeneralConfiguration gcbaseplant_r on  gcbaseplant_r.gnrlcnfghdrid = bcv_r.baselcleid
                                                                                  and 	gcbaseplant_r.gnrlcnfgqlfr = 'SAPPlantCode'
                                                                                  and   gcbaseplant_r.gnrlcnfgtblnme = 'locale'  
                                                                                  and    gcbaseplant_r.gnrlcnfgdtlid = 0
		
                                 left outer join BalanceConfigView bcv_d on bcv_d.DlDtlDlHdrID = dd_d.DlDtlDlHdrID
                                                                        and bcv_d.DlDtlID = dd_d.DlDtlID
																		and bcv_d.RegradePercentage = ( select max(v2.regradepercentage)
																		                                  from BalanceConfigView v2
																										  where v2.DlDtlDlHdrID = bcv_d.DlDtlDlHdrID
																										    and v2.DlDtlID = bcv_d.DlDtlID )
                                 left outer join GeneralConfiguration gcbaseplant_d on  gcbaseplant_d.gnrlcnfghdrid = bcv_d.baselcleid
                                                                                  and 	gcbaseplant_d.gnrlcnfgqlfr = 'SAPPlantCode'
                                                                                  and   gcbaseplant_d.gnrlcnfgtblnme = 'locale'  
                                                                                  and   gcbaseplant_d.gnrlcnfgdtlid = 0

                                 left outer join dbo.MTVDealDetailShipTo dds_r on dds_r.DealDetailID = dd_r.DealDetailID           
                                 left outer join dbo.MTVDealDetailShipTo dds_d on dds_d.DealDetailID = dd_d.DealDetailID
       					         left outer Join MTVSAPSoldToShipTo ss_r ON ss_r.ID = dds_r.SoldToShipToID
          					     left outer Join MTVSAPSoldToShipTo ss_d ON ss_d.ID = dds_d.SoldToShipToID
                   
                                 left outer join Generalconfiguration scac_r on scac_r.Gnrlcnfghdrid = dh_r.dlhdrextrnlbaid
                                                                            and scac_r.GnrlCnfgTblNme = 'BusinessAssociate'
                                                                            and scac_r.Gnrlcnfgqlfr = 'SCAC'
                                 left outer join Generalconfiguration scac_d on scac_d.Gnrlcnfghdrid = dh_d.dlhdrextrnlbaid
                                                                            and scac_d.GnrlCnfgTblNme = 'BusinessAssociate'
                                                                            and scac_d.Gnrlcnfgqlfr = 'SCAC'
                                 left outer join GeneralConfiguration SoldTo_r on SoldTo_r.GnrlCnfgHdrID = dh_r.DlHdrID
                                                                                 and SoldTo_r.GnrlcnfgTblNme ='DealHeader'
                                                                                 and SoldTo_r.GnrlCnfgQlfr = 'SAPSoldTo'
                                 left outer join GeneralConfiguration SoldTo_d on SoldTo_d.GnrlCnfgHdrID = dh_d.DlHdrID
                                                                                  and SoldTo_d.GnrlcnfgTblNme ='DealHeader'
                                                                                and  SoldTo_d.GnrlcnfgQlfr = 'SAPSoldTo'   
                                 left outer Join GeneralConfiguration SendTMSHostOrders_r on SendTMSHostOrders_r.GnrlCnfgHdrID = ptor.PlnndTrnsfrObDlDtlDlHdrID
                                                                                 and SendTMSHostOrders_r.GnrlCnfgDtlID = 0
                                                                                 and SendTMSHostOrders_r.GnrlCnfgTblNme = 'Locale'
                                                                                 and SendTMSHostOrders_r.GnrlCnfgQlfr = 'SendTMSHostOrders'


                                  left outer Join GeneralConfiguration SendTMSHostOrders_d on SendTMSHostOrders_r.GnrlCnfgHdrID = ptod.PlnndTrnsfrObDlDtlDlHdrID
                                                                                 and SendTMSHostOrders_d.GnrlCnfgDtlID = 0
                                                                                 and SendTMSHostOrders_d.GnrlCnfgTblNme = 'Locale'
                                                                                 and SendTMSHostOrders_d.GnrlCnfgQlfr = 'SendTMSHostOrders'
		                          left outer Join GeneralConfiguration SAPPlantCode_r on SAPPlantCode_r.GnrlCnfgHdrID = ptor.PhysicalLcleID
								                                                   and SAPPlantCode_r.GnrlCnfgDtlID = 0
																				   and SAPPlantCode_r.GnrlCnfgTblNme = 'Locale'
																				   and SAPPlantCode_r.GnrlCnfgQlfr = 'SAPPlantCode'

		                          left outer Join GeneralConfiguration SAPPlantCode_d on SAPPlantCode_d.GnrlCnfgHdrID = ptod.PhysicalLcleID
								                                                   and SAPPlantCode_d.GnrlCnfgDtlID = 0
																				   and SAPPlantCode_d.GnrlCnfgTblNme = 'Locale'
																				   and SAPPlantCode_d.GnrlCnfgQlfr = 'SAPPlantCode'


                                  left outer join MTVTMSSAPMaterialCodeXRef  MatCode6_r on MatCode6_r.RAProductID = dd_r.DlDtlPrdctID
                                                                                        and MatCode6_r.RALocaleID = ptor.PhysicalLcleID --dd_r.DlDtlLcleID 
                                                                                        and MatCode6_r.Sequence = '00'
                                 
                                  left outer join MTVTMSSAPMaterialCodeXRef  MatCode6_d on MatCode6_d.RAProductID = dd_d.DlDtlPrdctID
                                                                                        and MatCode6_d.RALocaleID = ptod.PhysicalLcleID --dd_d.DlDtlLcleID 
                                                                                        and MatCode6_d.Sequence = '00'
                                  left outer join MTVTMSSAPMaterialCodeXref MatCodeBase on MatCodeBase.RAProductID = bcv_d.BasePrdctID
                                                                                        and MatCodeBase.RALocaleID = ptod.PhysicalLcleID --dd_d.DlDtlLcleID
                                                                                        and MatCodeBase.Sequence = '00'
		                          left outer Join GeneralConfiguration hostpo on hostpo.GnrlCnfgHdrID = pm.plnndmvtid
								                                                   and hostpo.GnrlCnfgDtlID = 0
																				   and hostpo.GnrlCnfgTblNme = 'plannedmovement'
																				   and hostpo.GnrlCnfgQlfr = 'CounterpartyPONumber'
                                   left outer Join GeneralConfiguration releaseno on releaseno.GnrlCnfgHdrID = pm.plnndmvtid
								                                                   and releaseno.GnrlCnfgDtlID = 0
																				   and releaseno.GnrlCnfgTblNme = 'plannedmovement'
																				   and releaseno.GnrlCnfgQlfr = 'TruckTTNumber'

                                  left outer join DynamicListBox TransType_r on TransType_r.DynLstBxTyp = ptor.MethodTransportation
                                                                            and TransType_r.DynLstBxQlfr = 'TransportationMethod'
                                  left outer join DynamicListBox TransType_d on TransType_d.DynLstBxTyp = ptod.MethodTransportation
                                                                            and TransType_d.DynLstBxQlfr = 'TransportationMethod'
                                  left outer join GeneralConfiguration Equity on Equity.GnrlcnfgHdrID =  ptor.PhysicalLcleID
                                                                             and Equity.Gnrlcnfgqlfr = 'EquityTerminal'
                                                                             and Equity.GnrlcnfgTblnme = 'Locale'
                                  left outer join GeneralConfiguration VTWEG_r on VTWEG_r.GnrlcnfgHdrid = dh_r.DlHdrIntrnlBAID
								                                            and VTWEG_r.GnrlcnfgQlfr = 'DistributionChannel'
																			and VTWEG_r.GnrlCnfgQlfr = 'BusinessAssociate'
				                 -- Left outer join MTVSAPBASoldTo cotmajor_r on cotmajor_r.SoldTo = Soldto_r.GnrlCnfgMulti
								  Left outer join MTVSAPBASoldTo cotmajor_r on cotmajor_r.id = convert(int,Soldto_r.GnrlCnfgMulti)
								  left outer join MTVTMSClassOfTradeXRef cotminor_r on cotmajor_r.ClassOfTrade = cotminor_r.ClassOfTrade
								                                                   and cotminor_r.DistributionChannel = vtweg_r.GnrlCnfgMulti
                                 left outer join GeneralConfiguration VTWEG_d on VTWEG_d.GnrlcnfgHdrid = dh_d.DlHdrIntrnlBAID
								                                            and VTWEG_d.GnrlcnfgQlfr = 'DistributionChannel'
																			and VTWEG_d.GnrlCnfgQlfr = 'BusinessAssociate'
				                  Left outer join MTVSAPBASoldTo cotmajor_d on cotmajor_d.id = convert(int,Soldto_d.GnrlCnfgMulti)
								  left outer join MTVTMSClassOfTradeXRef cotminor_d on cotmajor_d.ClassOfTrade = cotminor_d.ClassOfTrade
								                                                   and cotminor_d.DistributionChannel = VTWEG_d.GnrlCnfgMulti
                                  left outer join GeneralConfiguration sapcust_r on sapcust_r.gnrlcnfghdrid = dh_r.dlhdrextrnlbaid
                                                                                   and sapcust_r.gnrlcnfgqlfr = 'SAPCustomerNumber'
                                                                                   and sapcust_r.gnrlcnfgtblnme = 'businessassociate'
                                  left outer join GeneralConfiguration sapcust_d on sapcust_d.gnrlcnfghdrid = dh_d.dlhdrextrnlbaid
                                                                                   and sapcust_d.gnrlcnfgqlfr = 'SAPCustomerNumber'
                                                                                   and sapcust_d.gnrlcnfgtblnme = 'businessassociate'

                                  left outer join GeneralConfiguration externalbatch on externalbatch.gnrlcnfghdrid = pm.PlnndMvtID
                                                                                   and externalbatch.gnrlcnfgqlfr = 'ExternalBatch'
                                                                                   and externalbatch.gnrlcnfgtblnme = 'PlannedMovement'
								  left outer join MTVTMSContractXref contractxref_r on contractxref_r.DlHdrID = dh_r.dlhdrid and contractxref_r.status = 'A'
								  left outer join MTVTMSContractXref contractxref_d on contractxref_d.DlHdrID = dh_d.dlhdrid and contractxref_d.status = 'A'
                                  left outer join dynamiclistbox deliveryterm_r on deliveryterm_r.DynLstBxTyp = dd_r.DeliveryTermId
                                                                               and deliveryterm_r.DynLstBxQlfr = 'DealDeliveryTerm'
                                                                               and deliveryterm_r.DynLstBxstts = 'A'
                                  left outer join dynamiclistbox deliveryterm_d on deliveryterm_d.DynLstBxTyp = dd_d.DeliveryTermId
                                                                               and deliveryterm_d.DynLstBxQlfr = 'DealDeliveryTerm'
                                                                               and deliveryterm_d.DynLstBxstts = 'A'

								   left outer join SourceSystemElementXref trans_id_r on trans_id_r.InternalValue = ptor.MethodTransportation
																			and trans_id_r.SrceSystmElmntID = (select sse.SrceSystmElmntID from sourcesystemelement sse
																			                   where sse.ElementName = 'ModeOfTransportReceipt' )
  																	                  and ptor.EstimatedMovementDate between trans_id_r.StartDate and trans_id_r.EndDate
								   left outer join SourceSystemElementXref trans_id_d on trans_id_d.InternalValue = ptod.MethodTransportation
																			and trans_id_d.SrceSystmElmntID = (select sse.SrceSystmElmntID from sourcesystemelement sse
																			                   where sse.ElementName = 'ModeOfTransportDelivery' )
  																	                  and ptod.EstimatedMovementDate between trans_id_d.StartDate and trans_id_d.EndDate
                                   left outer join Registry Bomp on Bomp.Rgstrykynme = 'BaseOilPlantAbbrvtn'
								   left outer join Registry IsMotivaStl on IsMotivaStl.RgstryKynme = 'MotivaSTLIntrnlBAName'

                           Where pm.PlnndMvtID = @orderID
                             and ( (dealtype_d.description = 'Sale Deal' and locale_d.lcleabbrvtn = Bomp.RgstryDtaVle )  OR   --baseoil
                                   (isnull(Equity.Gnrlcnfgmulti,'N') = 'Y'))

								   
Set NoCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSNominationData]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVTMSNominationData.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTVTMSNominationData >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTVTMSNominationData >>>'
	  END
	  go