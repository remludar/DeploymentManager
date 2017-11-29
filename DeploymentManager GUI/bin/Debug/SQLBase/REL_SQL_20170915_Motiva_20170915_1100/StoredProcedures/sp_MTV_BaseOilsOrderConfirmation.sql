/****** Object:  StoredProcedure [dbo].[MTV_BaseOilsOrderConfirmation]    Script Date: 4/27/2016 8:05:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_BaseOilsOrderConfirmation]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_BaseOilsOrderConfirmation] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_BaseOilsOrderConfirmation >>>'
	  END
GO

ALTER procedure [dbo].[MTV_BaseOilsOrderConfirmation] @orderid int
AS  
-- ==========================================================================
-- Author:        Craig Albright
-- Create date:	  1/06/2016
-- Description:   Get Base Oils Sales Order data for generation of Base Oils Order Confirmation Report
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -------------------------------------
-- execute MTV_BaseOilsOrderConfirmation 42244
-----------------------------------------------------------------------------
set nocount on
set Quoted_Identifier OFF  


--cleanup betwixt runs

If(object_id('tempdb..#tempContactInfo') Is Not Null)
begin
    drop table #tempContactInfo
end

If(object_id('tempdb..#tempaddress') Is Not Null)
begin
    drop table #tempaddress
end

if OBJECT_ID('tempdb..#BaseOilsTemp') Is not null
	drop table #BaseOilsTemp

if OBJECT_ID('tempdb..#BaseOilsTempReturn') Is not null
	drop table #BaseOilsTempReturn
if OBJECT_ID('tempdb..#BaseOilsTempReturn1') Is not null
	drop table #BaseOilsTempReturn1
--end cleanup

--Create Temp tables

begin
select CntctVcePhne, CntctEMlAddrss
 into #tempContactInfo
 From Contact (NOLOCK)
 where CntctFrstNme = 'Base Oils Accounting' and CntctLstNme = 'Department'
  
 select address.AddrssLne1, address.AddrssLne2, address.AddrssCty, address.AddrssStte, address.AddrssCntry, address.AddrssPstlCde, address.AddrssOffceLcleID
 into #tempaddress
 from address (NOLOCK)
 where AddrssTpe = 'M'
 and address.AddrssOffceLcleID in
 (select distinct OffceLcleID from office (NOLOCK) union all select distinct PlnndMvtOrgnLcleID from PlannedMovement (NOLOCK)
 union all 
 select distinct PlnndMvtDstntnLcleID  from PlannedMovement (NOLOCK))
 end
 begin
 select dh.DlHdrIntrnlNbr as deal,
 dh.DlHdrExtrnlBAID as externalBAID,
 dh.DlHdrIntrnlBAID as internalBAID,
 (case when baext.Banme like '%Motiva%' then 'Motiva Enterprises LLC' else baext.BANme + baext.BanmeExtended end )as externalbaname,
 (case when baint.Banme like '%Motiva%' then 'Motiva Enterprises LLC' else baint.Banme + + baint.BanmeExtended end ) as internalbaname,
 ISNULL(support.CntctVcePhne, '') as supportphone,
 ISNULL(support.CntctEMlAddrss, '') as supportemail,
 (select gc.gnrlcnfgmulti from GeneralConfiguration (NOLOCK) gc where gc.gnrlcnfgtblnme = 'Product' and gc.GnrlCnfgQlfr = 'SAPMaterialCode' and gc.GnrlCnfgHdrID = PM.PlnndMvtPrdctID )as productid,
 p.PrdctNme as productname,
 case when PM.PlnndMvtStts = 'A' then 'ACTIVE' when PM.PlnndMvtStts = 'I' then 'INACTIVE' when PM.PlnndMvtStts ='C' then 'COMPLETE' end as status,
 PM.PlnndMvtID as orderid, 
 PM.PlnndMvtCrtnDte as Orderdate,
 PM.PlnndMvtNme, 
 gcacct.GnrlCnfgMulti as Accountnumber,
 gcpyr.GnrlCnfgMulti as Payernumber,
 PM.PlnndMvtOrgnLcleID,
 PM.PONumber,
 PM.PlnndMvtTtlQntty as QuantityOrdered,
 PT.PlnndTrnsfrActlQty as ConfirmedQuantity,
 (select top 1 (t.TrmAbbrvtn)) as PaymentTerms,
 PT.EstimatedMovementDate as Loaddate,
 PM.PlnndMvtToDte as Deliverdate,
 OrgnLcle.Lclenme as origin,
 /*Origin address*/
(select  concat(#tempaddress.AddrssLne1,' ', #tempaddress.AddrssLne2,' ' +char(13) + char(10), #tempaddress.AddrssCty, ', ', #tempaddress.AddrssStte,' ', 
#tempaddress.AddrssCntry,' ', #tempaddress.AddrssPstlCde) 
from #tempaddress where #tempaddress.AddrssOffceLcleID = OrgnLcle.LcleID) as originaddress,
/*Internal BAID address*/
(select concat(#tempaddress.AddrssLne1,' ', #tempaddress.AddrssLne2,' ' +char(13) + char(10), #tempaddress.AddrssCty, ', ', #tempaddress.AddrssStte,' ', 
#tempaddress.AddrssCntry,' ', #tempaddress.AddrssPstlCde) 
from #tempaddress where #tempaddress.AddrssOffceLcleID = intoff.OffceLcleID) as intoffaddress,
--intoff.OffceLcleID,
--OrgnLcle.LcleID,
--extoff.OffceLcleID,
PM.PlnndMvtDstntnLcleID ,
DestnLcle.Lclenme as destination , 
PM.PlnndMvtTtlQntty  as quantity,
(select dlb.DynLstBxDesc from DynamicListBox dlb (NOLOCK) where dlb.DynLstBxQlfr = 'TransportationMethod' and dlb.DynLstBxTyp =PT.MethodTransportation) transportationmethod,
uom.uomdesc,
dd.DlDtlDsplyUOM uomid,
/*Destination address*/
(select concat(#tempaddress.AddrssLne1,' ',#tempaddress.AddrssLne2,' ' + char(13) + char(10),
#tempaddress.AddrssCty,' ',#tempaddress.AddrssStte,', ',#tempaddress.AddrssCntry,' ',#tempaddress.AddrssPstlCde) 
from #tempaddress where #tempaddress.AddrssOffceLcleID = DestnLcle.LcleID) as destinationaddress,
/*External BAID address*/
(select concat(#tempaddress.AddrssLne1,' ',#tempaddress.AddrssLne2,' ' +char(13) + char(10),
#tempaddress.AddrssCty,' ',#tempaddress.AddrssStte,', ',#tempaddress.AddrssCntry,' ',#tempaddress.AddrssPstlCde) 
from #tempaddress where #tempaddress.AddrssOffceLcleID = (select top 1 o.OffceLcleID from Office o (NOLOCK) where o.OffceBAID = dh.DlHdrExtrnlBAID)) as extoffaddress,
 PM.PlnndMvtCrtnDte , 
 PM.Note as pmnote, 
 PM.PlnndMvtFrmDte,
 PM.PlnndMvtToDte, 
 PM.IsTransshipmentConnectionOrder as transship,
PM.FacilityBAID as facility, 
dh.DlHdrExtrnlCntctID extCntct,
ISNULL(ms.CareOf, 'No Care Of') as contactname, 
ISNULL(cntct.CntctEMlAddrss, '') as cntcteml,
cntct.CntctVcePhne as cntctphne,
ISNULL(cntct.CntctFxPhne, '(XXX) XXX-XXXX') as cntctfax, 
COALESCE(mba.SoldTo,mba.VendorNumber,'No Sold To') as soldto,
 ISNULL(ms.ShipTo, 'No Ship To') as ShipTo,
 ISNULL(ms.ShipToAddress, 'No Ship To Address')as ShipToAddress,
 ISNULL(ms.ShipToCity, 'No Ship To City')as ShipToCity,
 ISNULL(ms.ShipToState, '') as ShipToState,
 ISNULL(ms.ShipToZip, '') as ShipToZip,
 (select dlb.DynLstBxDesc from DynamicListBox dlb (NOLOCK) where dlb.DynLstBxQlfr = 'DealDeliveryTerm' and dlb.DynLstBxTyp = dd.DeliveryTermID) DeliveryTermID,
  dd.DlDtlSpplyDmnd,
 PT.DlDtlSgmntID,
PT.DealDetailID,
ps.PlnndStSqnceNmbr,
dh.EntityTemplateID,
et.TemplateName,
PT.EstimatedMovementDate,
bac.BaNme CarrierName,
v.VhcleNme VehicleName,
bai.BaNme Inspector,
gcv.GnrlCnfgMulti VettingNumber,
gcb.GnrlCnfgMulti ExternalBatch
into #BaseOilsTemp
from PlannedMovement PM (NOLOCK) 
join PlannedTransfer PT (nolock) On PT.PlnndTrnsfrPlnndStPlnndMvtID = PM.PlnndMvtID
join DealHeader dh (nolock) on dh.DlhdrID = PT.PlnndTrnsfrObDlDtlDlHdrID
inner join dbo.EntityTemplate et (NOLOCK) ON et.EntityTemplateID = dh.EntityTemplateID
join DealDetail dd (nolock) on dd.DlDtlDlHdrID = PT.PlnndTrnsfrObDlDtlDlHdrID and dd.DlDtlID = PT.PlnndTrnsfrObDlDtlID
left join DealDetailProvision ddp on ddp.DlDtlPrvsnDlDtlDlHdrID = dh.DlHdrID and dd.DlDtlID = ddp.DlDtlPrvsnDlDtlID
join PlannedSet ps (NOLOCK) on ps.PlnndStPlnndMvtID = pm.PlnndMvtID and pt.PlnndTrnsfrPlnndStSqnceNmbr = ps.PlnndStSqnceNmbr
left join Locale OrgnLcle (nolock) on OrgnLcle.LcleID = PM.PlnndMvtOrgnLcleID and OrgnLcle.UseOnDealFlg = 1
left join Locale DestnLcle (nolock) on  (DestnLcle.LcleID = pt.PhysicalLcleID and DestnLcle.UseOnDealFlg = 1) --OR DestnLcle.LcleID = PM.PlnndMvtDstntnLcleID and DestnLcle.UseOnDealFlg = 1
left join BusinessAssociate baint (nolock) on baint.BAID = dh.DlHdrIntrnlBAID
left join BusinessAssociate baext (nolock) on baext.BAID = dh.DlHdrextrnlBAID
left join office extoff (nolock) on extoff.OffceBAID = baext.BAID
left join office intoff (nolock) on intoff.OffceBAID = baint.BAID
left join product p (nolock) on p.PrdctID = PM.PlnndMvtPrdctID
left join contact cntct (nolock) on cntct.cntctid = dh.dlhdrextrnlcntctid
left Join GeneralConfiguration gc (NOLOCK) on gc.GnrlCnfgQlfr = 'SAPSoldTo' and Gc.GnrlCnfgHdrID = dh.dlhdrid and GnrlCnfgHdrID > 0
left Join MTVSAPBASoldTo mba (NOLOCK) on mba.BAID = dh.DlHdrExtrnlBAID and mba.ID = gc.GnrlCnfgMulti
left join MTVDealDetailShipTo m (NOLOCK) on m.DlDtlID = dd.DlDtlID and m.DlHdrID = dd.DlDtlDlHdrID 
left join MTVSAPSoldToShipTo ms (NOLOCK) on m.SoldToShipToID = ms.ID
left join term t (nolock) on t.trmid = dd.DlDtlTrmTrmID
left join unitofmeasure uom (nolock) on uom.uom = dd.DlDtlDsplyUOM
left join GeneralConfiguration gcpyr (NOLOCK) on gcpyr.GnrlCnfgHdrID = baint.baid and gcpyr.GnrlCnfgQlfr = 'PayerNumber'
left join GeneralConfiguration gcacct (NOLOCK) on gcacct.GnrlCnfgHdrID = baext.baid and gcacct.GnrlCnfgQlfr = 'AccountNumber'
left join #tempContactInfo as support (NOLOCK) on 1=1
left join dbo.Vehicle v ON v.VhcleID = pm.VehicleID
left join GeneralConfiguration gci (NOLOCK) on gci.GnrlCnfgHdrID = pm.PlnndMvtID and gci.GnrlCnfgQlfr = 'Inspector' and gci.GnrlCnfgTblNme = 'PlannedMovement'
left join BusinessAssociate bai (NOLOCK) on gci.GnrlCnfgMulti = bai.baid
left join BusinessAssociate bac (NOLOCK) on bac.baid = pt.CarrierID
left join GeneralConfiguration gcv (NOLOCK) on gcv.GnrlCnfgHdrID = pm.PlnndMvtID and gcv.GnrlCnfgQlfr = 'VettingNumber' and gci.GnrlCnfgTblNme = 'PlannedMovement'
left join GeneralConfiguration gcb (NOLOCK) on gcb.GnrlCnfgHdrID = pm.PlnndMvtID and gcb.GnrlCnfgQlfr = 'ExternalBatch' and gcb.GnrlCnfgTblNme = 'PlannedMovement'
where (PM.PlnndMvtStts = 'A' or PM.PlnndMvtStts = 'C')-- and dh.DlHdrExtrnlBAID <> dh.DlHdrIntrnlBAID
AND et.TemplateName NOT LIKE '%Barge%'
AND TemplateName NOT LIKE '%Rail%'
and PM.PlnndMvtID = ISNULL(@orderid,PM.PlnndMvtID)
order by deal asc
end

UPDATE u SET	InternalBAID = IntBAID,InternalBAName = IntBAName,
				ExternalBAID = ExtBAID,ExternalBAName = ExtBAName
FROM #BaseOilsTemp u,
	(SELECT  TOP 1 CASE destination WHEN 'Port Arthur, TX BOMP' THEN InternalBAID ELSE ExternalBAID END IntBAID,
			CASE destination WHEN 'Port Arthur, TX BOMP' THEN Internalbaname ELSE Externalbaname END IntBAName
	FROM #BaseOilsTemp
	WHERE TemplateName LIKE '%Blend%'
	AND PlnndStSqnceNmbr = 1) IntBA,
	(SELECT  TOP 1 CASE destination WHEN 'Port Arthur, TX BOMP' THEN InternalBAID ELSE ExternalBAID END ExtBAID,
			CASE destination WHEN 'Port Arthur, TX BOMP' THEN Internalbaname ELSE Externalbaname END ExtBAName
	FROM #BaseOilsTemp
	WHERE TemplateName LIKE '%Blend%'
	AND PlnndStSqnceNmbr = 2) ExtBA
WHERE u.TemplateName LIKE '%Blend%'

UPDATE b SET	b.ShipToAddress = ISNULL(a.GnrlCnfgMulti,'') + ISNULL(aa.GnrlCnfgMulti,''),
				b.ShipToCity = ISNULL(c.GnrlCnfgMulti,''),
				b.ShipToState = ISNULL(s.GnrlCnfgMulti,''),
				b.ShipToZip = ISNULL(z.GnrlCnfgMulti,'')
FROM #BaseOilsTemp b
LEFT OUTER JOIN dbo.GeneralConfiguration a WITH (NOLOCK)
ON a.GnrlCnfgHdrID = b.PlnndMvtDstntnLcleID
AND a.GnrlCnfgTblNme = 'Locale'
AND a.GnrlCnfgQlfr = 'AddrLine1'
LEFT OUTER JOIN dbo.GeneralConfiguration aa WITH (NOLOCK)
ON aa.GnrlCnfgHdrID = b.PlnndMvtDstntnLcleID
AND aa.GnrlCnfgTblNme = 'Locale'
AND aa.GnrlCnfgQlfr = 'AddrLine2'
LEFT OUTER JOIN dbo.GeneralConfiguration c WITH (NOLOCK)
ON c.GnrlCnfgHdrID = b.PlnndMvtDstntnLcleID
AND c.GnrlCnfgTblNme = 'Locale'
AND c.GnrlCnfgQlfr = 'CityName'
LEFT OUTER JOIN dbo.GeneralConfiguration s WITH (NOLOCK)
ON s.GnrlCnfgHdrID = b.PlnndMvtDstntnLcleID
AND s.GnrlCnfgTblNme = 'Locale'
AND s.GnrlCnfgQlfr = 'StateAbbreviation'
LEFT OUTER JOIN dbo.GeneralConfiguration z WITH (NOLOCK)
ON z.GnrlCnfgHdrID = b.PlnndMvtDstntnLcleID
AND z.GnrlCnfgTblNme = 'Locale'
AND z.GnrlCnfgQlfr = 'PostalCode'
WHERE b.TemplateName LIKE '%Blend%'

UPDATE b SET	b.QuantityOrdered = b.QuantityOrdered * v.ConversionFactor,
				b.ConfirmedQuantity = b.ConfirmedQuantity * v.ConversionFactor,
				b.Quantity = b.Quantity * v.ConversionFactor
FROM #BaseOilsTemp b
INNER JOIN dbo.v_uomconversion v (NOLOCK)
ON v.FromUOM = 3
and v.ToUOM = b.uomid
AND b.uomid != 3

--end Create Temp tables
 --Main Query
select top 1 (#BaseOilsTemp.deal),#BaseOilsTemp.externalBAID,#BaseOilsTemp.internalBAID,#BaseOilsTemp.externalbaname,#BaseOilsTemp.internalbaname,
	 #BaseOilsTemp.supportphone,#BaseOilsTemp.supportemail,#BaseOilsTemp.productid,#BaseOilsTemp.productname,#BaseOilsTemp.status,
	 #BaseOilsTemp.orderid,#BaseOilsTemp.Orderdate,#BaseOilsTemp.PlnndMvtNme,#BaseOilsTemp.Accountnumber,#BaseOilsTemp.Payernumber,
	 #BaseOilsTemp.PlnndMvtOrgnLcleID,#BaseOilsTemp.PONumber,#BaseOilsTemp.QuantityOrdered,#BaseOilsTemp.ConfirmedQuantity,#BaseOilsTemp.PaymentTerms,
	 #BaseOilsTemp.Loaddate,#BaseOilsTemp.Deliverdate,#BaseOilsTemp.origin,#BaseOilsTemp.originaddress,#BaseOilsTemp.intoffaddress,
	 #BaseOilsTemp.PlnndMvtDstntnLcleID,#BaseOilsTemp.destination,#BaseOilsTemp.quantity,#BaseOilsTemp.transportationmethod,
	 #BaseOilsTemp.uomdesc,#BaseOilsTemp.destinationaddress,#BaseOilsTemp.extoffaddress,#BaseOilsTemp.PlnndMvtCrtnDte,#BaseOilsTemp.pmnote,
	 #BaseOilsTemp.PlnndMvtFrmDte,#BaseOilsTemp.PlnndMvtToDte,#BaseOilsTemp.transship,#BaseOilsTemp.facility,#BaseOilsTemp.extCntct,
	 #BaseOilsTemp.contactname,#BaseOilsTemp.cntcteml,#BaseOilsTemp.cntctphne,#BaseOilsTemp.cntctfax,#BaseOilsTemp.soldto,#BaseOilsTemp.ShipTo,
	 #BaseOilsTemp.ShipToAddress,#BaseOilsTemp.ShipToCity,#BaseOilsTemp.ShipToState,#BaseOilsTemp.ShipToZip,#BaseOilsTemp.DeliveryTermID,EstimatedMovementDate,CarrierName,VehicleName,Inspector,VettingNumber,ExternalBatch
into #BaseOilsTempReturn
from #BaseOilsTemp 
where #BaseOilsTemp.TemplateName like '%Sale%'

Declare @count int = @@ROWCOUNT

 if(@count = 0)
 Begin
  select top 1 ( deal),externalBAID,internalBAID,externalbaname,internalbaname,
		supportphone,supportemail,productid,productname,status,
		orderid,Orderdate,PlnndMvtNme,Accountnumber,Payernumber,
		PlnndMvtOrgnLcleID,PONumber,QuantityOrdered,ConfirmedQuantity,PaymentTerms,
		Loaddate,Deliverdate,origin,originaddress,intoffaddress,
		PlnndMvtDstntnLcleID,destination,quantity,transportationmethod,
		uomdesc,destinationaddress,extoffaddress,PlnndMvtCrtnDte,pmnote,
		PlnndMvtFrmDte,PlnndMvtToDte,transship,facility,extCntct,
		contactname,cntcteml,cntctphne,cntctfax,soldto,ShipTo,
		ShipToAddress,ShipToCity,ShipToState,ShipToZip,DeliveryTermID,EstimatedMovementDate,CarrierName,VehicleName,Inspector,VettingNumber,ExternalBatch
	into #BaseOilsTempReturn1  
	from #BaseOilsTemp
	where #BaseOilsTemp.TemplateName like '%Blending%'

	--update #BaseOilsTempReturn1 set internalbaname = (select top 1 ( b.internalbaname) from #BaseOilsTemp b where b.EntityTemplateID in 
	-- (select et.EntityTemplateID  from EntityTemplate et where et.TemplateName like '%Blending%') and b.deal <> #BaseOilsTempReturn1.deal )
	update #BaseOilsTempReturn1 set intoffaddress = (select top 1 ( b.intoffaddress) from #BaseOilsTemp b where b.TemplateName like '%Blending%' and b.deal <> #BaseOilsTempReturn1.deal )
 End
else 
Begin
 update #BaseOilsTempReturn set internalbaname = (select top 1 ( b.internalbaname) from #BaseOilsTemp b where b.TemplateName like '%Blending%')
 update #BaseOilsTempReturn set intoffaddress = (select top 1 ( b.intoffaddress) from #BaseOilsTemp b where b.TemplateName like '%Blending%')
End
if(@count = 0)
Begin
 select deal,externalBAID,internalBAID,externalbaname,internalbaname,
 supportphone,supportemail,productid,productname,status,
 orderid,Orderdate,PlnndMvtNme,Accountnumber,Payernumber,
 PlnndMvtOrgnLcleID,PONumber,QuantityOrdered,ConfirmedQuantity,PaymentTerms,
 Loaddate,Deliverdate,origin,originaddress,intoffaddress,
 PlnndMvtDstntnLcleID,destination,quantity,transportationmethod,
 uomdesc,destinationaddress,extoffaddress,PlnndMvtCrtnDte,pmnote,
 PlnndMvtFrmDte,PlnndMvtToDte,transship,facility,extCntct,
 contactname,cntcteml,cntctphne,cntctfax,soldto,ShipTo,
 ShipToAddress,ShipToCity,ShipToState,ShipToZip,DeliveryTermID,EstimatedMovementDate,CarrierName,VehicleName,Inspector,VettingNumber,ExternalBatch
 from #BaseOilsTempReturn1
end
Else
Begin
 select deal,externalBAID,internalBAID,externalbaname,internalbaname,
 supportphone,supportemail,productid,productname,status,
 orderid,Orderdate,PlnndMvtNme,Accountnumber,Payernumber,
 PlnndMvtOrgnLcleID,PONumber,QuantityOrdered,ConfirmedQuantity,PaymentTerms,
 Loaddate,Deliverdate,origin,originaddress,intoffaddress,
 PlnndMvtDstntnLcleID,destination,quantity,transportationmethod,
 uomdesc,destinationaddress,extoffaddress,PlnndMvtCrtnDte,pmnote,
 PlnndMvtFrmDte,PlnndMvtToDte,transship,facility,extCntct,
 contactname,cntcteml,cntctphne,cntctfax,soldto,ShipTo,
 ShipToAddress,ShipToCity,ShipToState,ShipToZip,DeliveryTermID,EstimatedMovementDate,CarrierName,VehicleName,Inspector,VettingNumber,ExternalBatch
 from #BaseOilsTempReturn
End
if(object_id('tempdb..#tempContactInfo') is not null)
begin
    drop table #tempContactInfo
end

if(object_id('tempdb..#tempaddress') is not null)
begin
    drop table #tempaddress
end

GO
