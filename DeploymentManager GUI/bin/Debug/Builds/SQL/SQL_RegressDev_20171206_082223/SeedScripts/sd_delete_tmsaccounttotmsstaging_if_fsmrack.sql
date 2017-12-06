delete  from mtvtmsaccounttotmsstaging
where exists ( select 'x' 
                 From plannedtransfer 
				      inner join DealHeader dh on DH.DlHdrID = PlannedTransfer.PlnndTrnsfrObDlDtlDlHdrID
                                                      and DH.DlHdrTyp = 2
                                                      and PlannedTransfer.PTReceiptDelivery = 'D'
                      inner join businessassociate on baid = dh.dlhdrintrnlbaid
                                                      and BaAbbrvtn = ( Select RgstryDtaVle
                                                                         From Registry
                                                                       Where Registry.RgstryKyNme = 'MotivaFSMIntrnlBAName'
                                                                      )
                Where plannedtransfer.PlnndTrnsfrPlnndStPlnndMvtID = mtvtmsaccounttotmsstaging.plnndmvtid
              )
                    
and interfacestatus = 'E'
and interfacename = 'nomination'
