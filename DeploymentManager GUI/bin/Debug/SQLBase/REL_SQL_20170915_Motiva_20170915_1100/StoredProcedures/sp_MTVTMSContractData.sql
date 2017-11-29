

/*
*****************************************************************************************************
USE FIND AND REPLACE ON sp_MTVTMSContractData WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[sp_MTVTMSContractData]    Script Date: DATECREATED ******/
PRINT 'Start Script=sp_MTVTMSContractData.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSContractData]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_MTVTMSContractData] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure sp_MTVTMSContractData >>>'
	  END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


--select * from businessassociate where banme in ( 'motiva-base oils','motiva-fsm')
--exec sp_MTVTMSContractData 251, 'U',21,22
ALTER PROCEDURE [dbo].sp_MTVTMSContractData @dlhdrid int, @action char(1), @BaseOilBaid int, @FSMBaid int
As
--DA0 10/31/2016 Prefixed the plant code with '000'


Select @action action
                             , DH.DlHdrID
                             , DD.DlDtlID
                             , DD.DealDetailID
                             , DD.DlDtlPrdctID
                             , DH.DlHdrIntrnlNbr contract_number
                             , '0000000039' seller_no
                             , 'SR00000002' supplier_no
                             , isnull(MTVSAPSoldToShipTo.ShipTo ,'')    acct_no
                             , MTVSAPBASoldTo.SoldTo cust_no
                             , isnull(MTVSAPSoldToShipTo.RALocaleID  ,'0') RALocaleID        
                             , convert(varchar(6),DH.DlHdrFrmDte,12) dealheader_eff_date
                             , convert(varchar(6),MTVDealDetailShipTo.FromDate,12) DDShipto_eff_date
                             , convert(varchar(6),MTVSAPSoldToShipTo.FromDate,12) ShipTo_eff_date
                             , case when dh.DlHdrRnwlPrd = 'N' then convert(varchar(6),dh.dlhdrtodte,12) else  isnull(convert(varchar(6),convert(date,RegistryEndDate.RgstryDtaVle),12),'500101') end  dealheader_exp_date
                             , case when MTVSAPSoldToShipTo.ToDate <  convert(date,RegistryEndDate.RgstryDtaVle)  then convert(varchar(6),MTVSAPSoldToShipTo.ToDate,12) else case when dh.DlHdrRnwlPrd = 'N' then convert(varchar(6),dh.dlhdrtodte,12) else isnull(convert(varchar(6),convert(date,RegistryEndDate.RgstryDtaVle),12),'500101') end end shipto_exp_date
                             , case when dd.dldtltodte < dh.dlhdrtodte then convert(varchar(6),dd.dldtltodte ,12)
                                    when MTVDealDetailShipTo.ToDate < dd.dldtltodte then convert(varchar(6),MTVDealDetailShipTo.ToDate,12)
                                  else case when dh.DlHdrRnwlPrd = 'N' then convert(varchar(6),dh.dlhdrtodte,12) else isnull(convert(varchar(6),convert(date,RegistryEndDate.RgstryDtaVle),12),'500101') end end DDShipTo_exp_date
                             , case when Ba.Baid = @FSMBaid  then 'R' 
                                    when Ba.Baid = @BaseOilBaid then 'D' 
									else 'R' end cust_type
                             , isnull(substring(bae.baabbrvtn,1,50),'') cust_name
                             , isnull(substring(bae.baabbrvtn,1,50),'') short_cust_name
                             , isnull(substring(MTVSAPSoldToShipTo.shiptoaccountname,1,50),'') acct_name
                             , isnull(substring(MTVSAPSoldToShipTo.shiptoshortaccountname,1,10),'') short_acct_name
                             , isnull(substring(ba.baabbrvtn,1,50),'')  internalname1
                             , isnull(substring(baaddress.AddrssLne1,1,50),'') internalbaaddr1
                             , isnull(substring(baaddress.AddrssLne2,1,50),'') internalbaaddr2
                             , isnull(substring(baaddress.AddrssCty,1,50),'') internalbacity
                             , isnull(substring(bastate.lcleabbrvtn,1,2),'') internalbastate
                             , isnull(substring(baaddress.AddrssPstlCde,1,10),'') internalbazip
                             , '  ' internalbacountry
                             , isnull(baoffice.OffceVcePhne,'') phone --change to internalcontact phone
                             , isnull(MTVSAPSoldToShipTo.ShipToAddress,'') ShipToAddress
                             , isnull(MTVSAPSoldToShipTo.ShipToAddress1,'') ShipToAddress1
                             , isnull(MTVSAPSoldToShipTo.ShipToAddress2,'') ShipToAddress2
                             , isnull(MTVSAPSoldToShipTo.ShipToCity,'') ShipToCity
                             , isnull(MTVSAPSoldToShipTo.shipToState,'') ShipToState
                             , isnull(MTVSAPSoldToShipTo.shipTozip,'') shipTozip
                             , isnull(MTVSAPSoldToShipTo.shiptophone,'') shiptophone
                             , '  ' shiptocountry
                             , isnull(MTVSAPSoldToShipTo.ShipToPhone,'') ShipToPhone
                             , isnull(substring(MTVSAPSoldToShipTo.shiptoshortaccountname,1,10),'') shiptoshortaccountname
                             , isnull(MTVSAPSoldToShipTo.shiptoaccountname,'') shiptoaccountname
                             , isnull(substring(bae.baabbrvtn,1,50),'')  internalname1
                             , isnull(substring(baeaddress.AddrssLne1,1,50),'') externalbaaddr1
                             , isnull(substring(baeaddress.AddrssLne2,1,50),'') externalbaaddr2
                             , isnull(substring(baeaddress.AddrssCty,1,50),'') externalbacity
                             , isnull(substring(baestate.lcleabbrvtn,1,2),'') externalbastate
                             , isnull(substring(baeaddress.AddrssPstlCde,1,10),'') externalbazip
                             , '  ' externalbacountry
                            -- , isnull(baeoffice.OffceVcePhne,'')  externalcontact phone
                             , isnull(externalcontact.CntctVcePhne,'') externalcontactphone

                             , DD.DlDtlFrmDte fromdate
                             , DD.DlDtlToDte todate
                             , ISNULL(MTVSAPBASoldTo.CreditLock,'N') locked  
                             , 'N' credit_risk -- get from soldtoshiptto tables?
                             , 'N' freight
                             , 'N' po_req
                             , 'N' relno_req
                             , 'N' gross_net
                             , 'Y' active_enable
                             , splc.GnrlcnfgMulti  dest_splc_code
							 , '000' + isnull(SAPPlantCode.GnrlCnfgMulti,'') sapplantcode
                             , 'Y' dirty_flag
                             , '99' edi_code_id
                             , '1' edi_enable
                             , 0 edi_auth_ovrd
                             , isnull(MTVSAPSoldToShipTo.TMSOverrideEDIConsigneeNbr,MTVSAPSoldToShipTo.ShipTo) consignee
                             , ( select RgstryDtaVle from registry
                                 where RgstryFllKyNme = 'Motiva\TMS\Trading\route_cd_type\'
                                   and RgstryKyNme = 'route_cd_type' ) route_cd_type

                             , case when LocaleSendTmsOrders.GnrlCnfgMulti is not null then 'Y' else 'N' end inherit_cust_prods
                             , 'Y' inherit_supplier_prod
                             ,  case when ba.BAID = @FSMBaid then 'Y' else 'N' end osp_interface_enabled
                             , ( select RgstryDtaVle from registry
                                 where RgstryFllKyNme = 'Motiva\TMS\Trading\EmergencyNumber\'
                                   and RgstryKyNme = 'EmergencyNumber' ) emergency_no
                             , ( select RgstryDtaVle from registry
                                 where RgstryFllKyNme = 'Motiva\TMS\Trading\EmergencyCompany\'
                                   and RgstryKyNme = 'EmergencyCompany' ) emergency_co 
						  , REPLICATE('0', 3 - LEN(MTVTMSClassOfTradeXRef.ClassOfTrade)) + MTVTMSClassOfTradeXRef.ClassOfTrade cot_minor
                          , MTVTMSClassOfTradeXRef.TMSHostCode cot_major 
                          , 'RightAngle' last_upd_usr
                          , convert(varchar(19), getdate(), 126) last_upd_dt
                         , MatCode6.TMSCode  productcode
                         
                             From DealHeader DH
                             --internal
                                  Inner Join BusinessAssociate BA on BA.Baid = DH.DlHdrIntrnlBaid
                                  Inner join Businessassociate bae on bae.baid = dh.dlhdrextrnlbaid
                                  Inner Join Office baOffice on baOffice.OffceBaid = BA.Baid
                                  Inner Join Address baAddress on baAddress.AddrssOffceLcleID = baOffice.OffceLcleID
                                                    and baAddress.AddrssTpe = 'M'
                              --external
                                  Inner Join Office baeOffice on baeOffice.OffceBaid = bae.baid
                                  Inner Join Address baeAddress on baeAddress.AddrssOffceLcleID = baeOffice.OffceLcleID
                                                    and baeAddress.AddrssTpe = 'M'
							     -- left outer Join Locale baCountry on baCountry.lclenme = baaddress.AddrssCntry
							     -- left outer Join Locale baeCountry on baeCountry.lclenme = baeaddress.AddrssCntry
							      left outer Join Locale bastate on bastate.lclenme = baaddress.AddrssStte
							      left outer Join Locale baestate on baestate.lclenme = baeaddress.AddrssStte
                                  Inner Join DealDetail DD ON DD.DlDtlDlHdrID = DH.DlHdrID
                                  Inner Join Contact ExternalContact on ExternalContact.cntctid = dh.dlhdrextrnlcntctid
                               --soldto/shipto
								  Inner Join MTVDealDetailShipTo ON MTVDealDetailShipTo.DealDetailID = DD.DealDetailID
								  Inner Join MTVSAPSoldToShipTo ON MTVSAPSoldToShipTo.ID = MTVDealDetailShipTo.SoldToShipToID
                                  Inner Join GeneralConfiguration soldto on soldto.GnrlCnfgHdrID = dh.dlhdrid
                                                                        and soldto.GnrlCnfgQlfr = 'SAPSoldTo'
                                                                        and soldto.GnrlCnfgTblNme = 'DealHeader'
                                  left outer Join MTVSAPBASoldTo on MTVSAPBASoldTo.ID = soldto.gnrlcnfgmulti
                               --   left outer Join Locale ShipTocountry on ShipTocountry.lcleid = MTVSAPSoldToShipTo.ShipToCountry
                                  left outer join GeneralConfiguration splc on splc.GnrlCnfgHdrID = DD.DlDtlLcleID
                                                                           and splc.GnrlCnfgTblNme = 'Locale'
                                                                           and splc.GnrlCnfgQlfr = 'SPLCCode'
--                                  Inner Join GeneralConfiguration Custno on Custno.GnrlcnfgHdrID = DH.DlHdrID
  --                                                                      and Custno.GnrlCnfgDtlID = 0
    --                                                                    and Custno.GnrlCnfgTblNme = 'DealHeader'
      --                                                                  and Custno.GnrlCnfgQlfr = 'SAPSoldTO'        
		                          left outer Join GeneralConfiguration SAPPlantCode on SAPPlantCode.GnrlCnfgHdrID = DD.DlDtlLcleID
								                                                   and SAPPlantCode.GnrlCnfgDtlID = 0
																				   and SAPPlantCode.GnrlCnfgTblNme = 'Locale'
																				   and SAPPlantCode.GnrlCnfgQlfr = 'SAPPlantCode'
                                  left outer Join GeneralConfiguration DetailSendToTms on DetailSendToTms.GnrlCnfgHdrID = DD.DlDtlDlHdrID
                                                                                 and DetailSendToTms.GnrlCnfgDtlID = DD.DlDtlID
                                                                                 and DetailSendToTms.GnrlCnfgTblNme = 'DealDetail'
                                                                                 and DetailSendToTms.GnrlCnfgQlfr = 'SendToTms'
                                  left outer Join GeneralConfiguration LocaleSendTmsOrders on LocaleSendTmsOrders.GnrlCnfgHdrID = DD.DlDtlLcleID
                                                                                 and LocaleSendTmsOrders.GnrlCnfgDtlID = 0
                                                                                 and LocaleSendTmsOrders.GnrlCnfgTblNme = 'Locale'
                                                                                 and LocaleSendTmsOrders.GnrlCnfgQlfr = 'SendTMSHostOrders'
                                  left outer join GeneralConfiguration cot on cot.GnrlcnfgHdrid = dh.DlHdrIntrnlBaid
                                                                                 and cot.GnrlcnfgQlfr = 'DistributionChannel'
                                                                                 and cot.GnrlcnfgTblNme = 'BusinessAssociate'
                                left outer join MTVTMSClassOfTradeXRef on MTVTMSClassOfTradeXRef.DistributionChannel = cot.gnrlcnfgmulti
								                                   and MTVTMSClassOfTradeXRef.ClassOfTrade = MTVSAPBASoldTo.ClassOfTrade
                                left outer join MTVTMSSAPMaterialCodeXRef  MatCode6 on MatCode6.RAProductID = dd.DlDtlPrdctID
                                                                                          and MatCode6.RALocaleID = dd.DlDtlLcleID
                                                                                          and MatCode6.Sequence = ( case when DH.DlHdrIntrnlBaid = @FSMBaid then '01' else '00' end )
                                  left outer join Registry RegistryEndDate on RegistryEndDate.RgstryFllKynme = 'Motiva\TMS\Trading\ContractEndDate\'

                             --if you are here you have already determined this is a valid contract - now you need to determine
                             --which details on the contract should be sent

                             Where DH.DlHdrID = @dlHdrID
                               and ((isnull(LocaleSendTmsOrders.GnrlCnfgMulti,'N') ='Y' and isnull(DetailSendToTMS.GnrlCnfgMulti,'N') = 'Y' and DH.DlHdrIntrnlBaid = @BaseOilBaid ) OR
                                    (isnull(DetailSendToTMS.GnrlCnfgMulti,'N') = 'Y' and DH.DlHdrIntrnlBaid = @FSMBaid) )


Set NoCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[sp_MTVTMSContractData]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVTMSContractData.sql'
			PRINT '<<< ALTERED StoredProcedure sp_MTVTMSContractData >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure sp_MTVTMSContractData >>>'
	  END
	  go