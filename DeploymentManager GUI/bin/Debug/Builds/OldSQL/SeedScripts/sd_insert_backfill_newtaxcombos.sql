---------------------------
-- backfill taxcombos
---------------------------
declare @dt_updatedate datetime

set @dt_updatedate = getdate()

insert into MTVTaxNewCombinationSummary    
( ExternalBaid, MTVSAPBASoldTo.SoldTo,  MTVSAPSoldToShipTo.ShipTo, PrdctID, OriginLcleID, DestinationLcleID , lastupdatedate)
Select DH.DlHdrExtrnlBaid, MTVSAPBASoldTo.SoldTo,  MTVSAPSoldToShipTo.ShipTo, DD.DlDtlPrdctID, DD.OriginLcleID,MTVSAPSoldToShipTo.RALocaleID, @dt_updatedate
From DealDetail DD (Nolock)
     inner join DealHeader DH (nolock) on DH.DlHdrID = DD.DlDtlDLHdrID
     inner join GeneralConfiguration SoldTO (nolock) on SoldTO.GnrlcnfgHdrID = DH.DlHdrID
                                           and SoldTo.GnrlCnfgTblNme = 'DealHeader'
                                           and SoldTo.GnrlCnfgQlfr = 'SAPSoldTo'
     inner join MTVSAPBASoldTo (nolock) on MTVSAPBASoldTo.ID = convert(int,SoldTo.GnrlCnfgMulti)
     inner join MTVDealDetailShipTO DDShipTo (Nolock) on DDShipTo.DlHdrID = DD.DlDtlDlHdrID
                                                   and DDShipTo.DlDtlID = DD.DlDtlID
    inner join MTVSAPSoldToShipTo (nolock) on MTVSAPSoldToShipTo.ID = DDShipTo.SoldToShipToID
Where DH.DLHDrStat = 'A'
group by  DH.DlHdrExtrnlBaid, MTVSAPBASoldTo.SoldTo, MTVSAPSoldToShipTo.ShipTo, DD.DlDtlPrdctID, DD.OriginLcleID, MTVSAPSoldToShipTo.RALocaleID
              
Union

Select DH.DlHdrExtrnlBaid, substring(SoldTo.GnrlcnfgMulti,1,10),  substring(ShipTo.GnrlcnfgMulti,1,10), MH.MvtHdrPrdctID, MH.MvtHdrLcleID, MTVSAPSoldToShipTo.RALocaleID, @dt_updatedate
From dbo.TransactionHeader TH (nolock) 
      inner join PlannedTransfer PT (nolock)  on PT.PlnndTrnsfrID = TH.XHdrPlnndTrnsfrID
      inner join MovementHeader MH (nolock)  on MH.MvtHdrID = TH.XHdrMvtDtlMvtHdrID
      inner join DealHeader DH (nolock)  on DH.DlHDrID = PT.PlnndTrnsfrObDlDtlDlHdrID
      inner join DealDetail DD (nolock)  on DD.DlDtlDlHdrID = PT.PlnndTrnsfrObDlDtlDlHdrID
                                        and DD.DlDtlID = PT.PlnndTrnsfrObDlDtlID
      inner join GeneralConfiguration SoldTO (nolock) on SoldTO.GnrlcnfgHdrID = DH.DlHdrID
                                           and SoldTo.GnrlCnfgTblNme = 'MovementHeader'
                                           and SoldTo.GnrlCnfgQlfr = 'SAPMvtSoldToNumber'
      inner join GeneralConfiguration ShipTO (nolock) on ShipTO.GnrlCnfgHdrID = MH.MvtHdrID
                                              and ShipTo.GnrlCnfgTblNme ='MovementHeader'
                                              and ShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo'
      inner join MTVSAPBASoldTO (Nolock) on MTVSAPBASoldTO.SoldTo = SoldTo.GnrlCnfgMulti
                                        and MTVSAPBASoldTO.BAID = DH.DlHdrExtrnlBaid
      inner join MTVSAPSoldToShipTo (Nolock) on MTVSAPSoldToShipTo.MTVSAPBASoldToID = MTVSAPBASoldTO.ID
                                            and MTVSAPSoldToShipTo.ShipTo = ShipTo.GnrlCnfgMulti
Group By DH.DlHdrExtrnlBaid, substring(SoldTo.GnrlcnfgMulti,1,10),  substring(ShipTo.GnrlcnfgMulti,1,10), MH.MvtHdrPrdctID, MH.MvtHdrLcleID, MTVSAPSoldToShipTo.RALocaleID


declare @regentry varchar(255)
set @RegEntry = convert(varchar,@dt_updatedate)
EXECUTE SP_Set_Registry_Value 'Motiva\TAX\NewCombination\LastUpdateDate',@RegEntry     



--EXECUTE SP_Set_Registry_Value 'Motiva\TAX\NewCombination\LastUpdateDate','01/01/2016'  
--select * from MTVTaxNewCombinationSummary
--select * from MTVTaxNewCombinationDetail
--delete from MTVTaxNewCombinationSummary
--delete from MTVTaxNewCombinationDetail
