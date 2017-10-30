-----------------------------------------------------------------------------------------------------------------------------
-- Name:					116875_InventoryValuationSetup_CO.sql														Copyright 2015 OpenLink
-- Overview:      
-- Arguments:     
-- SPs:
-- Temp Tables:
-- Created by:    
-- Created on:    
--
-- Date Modified     Modified By       Issue#      Modification
-- ---------------   ------------     --------     --------------------------------------------------------------------------
--   2/16/2016			 SL			     116875			Added DealHeaderPCRule settings specific to request.  
-----------------------------------------------------------------------------------------------------------------------------
SET Quoted_Identifier OFF
SET NoCount ON

BEGIN TRANSACTION

if object_id('tempdb..#tmp') is not null
	drop table #tmp
go

Create table #tmp
(	 DlHdrType int  null 
	,DelValue int
	,RecValue int
	,GainValue int
	,LossValue int
	,LongEndBalValue int
	,ShortEndBalValue int
)
go

--Select * From DealHeaderPCRule

insert #tmp values (null,6,6,6,6,18,18) --These need to match the DealHeaderPCRule settings currently used.

declare @snapshot int
--select @snapshot = (select min(P_EODSnpShtID) from snapshot where isvalid = 'Y')

if @snapshot is not null
begin
	update dhpcr
	set dhpcr.DelValueMethod = #tmp.DelValue
	,dhpcr.RecValueMethod = #tmp.RecValue
	,dhpcr.GainValueMethod = #tmp.GainValue
	,dhpcr.LossValueMethod = #tmp.LossValue
	,dhpcr.LongEndBalValueMethod = #tmp.LongEndBalValue
	,dhpcr.ShortEndBalValueMethod = #tmp.ShortEndBalValue
	from dealheaderpcrule dhpcr, snapshot s, #tmp
	where InstanceDateTime between dhpcr.startdate and dhpcr.enddate
	and P_EODSnpShtID = @snapshot
	and #tmp.DlHdrType is null

	update dhpcr
	set dhpcr.DelValueMethod = #tmp.DelValue
	,dhpcr.RecValueMethod = #tmp.RecValue
	,dhpcr.GainValueMethod = #tmp.GainValue
	,dhpcr.LossValueMethod = #tmp.LossValue
	,dhpcr.LongEndBalValueMethod = #tmp.LongEndBalValue
	,dhpcr.ShortEndBalValueMethod = #tmp.ShortEndBalValue
	From Snapshot s
	Inner Join dealheaderpcrule dhpcr
		on s.InstanceDateTime between dhpcr.startdate and dhpcr.enddate
	Inner Join DealHeader dh
		on dh.DlHdrID = dhpcr.DlHdrID
	Inner Join #Tmp
		on #Tmp.DlHdrType = dh.DlHdrTyp
	where s.P_EODSnpShtID = @snapshot

end

Alter Table DealHeader Disable Trigger All
Go

Update	DealHeader
Set	DelValueMethod			= null,
	RecValueMethod			= null,
	GainValueMethod			= null,
	LossValueMethod			= null,
	LongEndBalValueMethod		= null,
	ShortEndBalValueMethod		= null

Update	DealHeader
Set	DelValueMethod			= DelValue
	,RecValueMethod			= RecValue
	,GainValueMethod			= GainValue
	,LossValueMethod			= LossValue
	,LongEndBalValueMethod		= LongEndBalValue
	,ShortEndBalValueMethod		= ShortEndBalValue
From	#tmp
Where	#tmp.DlHdrType is null
and exists
	(
	select	1
	from	DealDetailChemical DDC
	where	DDC. DlDtlChmclDlDtlDlHdrID = DealHeader. DlHdrID
	and	InventoryType in ('I','E')
	)

Update	DealHeader
Set	DelValueMethod			= DelValue
	,RecValueMethod			= RecValue
	,GainValueMethod		= GainValue
	,LossValueMethod		= LossValue
	,LongEndBalValueMethod		= LongEndBalValue
	,ShortEndBalValueMethod		= ShortEndBalValue
From	#tmp
Where	#tmp.DlHdrType is not null
and DealHeader.DlHdrTyp = #tmp.DlHdrType
and exists
	(
	select	1
	from	DealDetailChemical DDC
	where	DDC. DlDtlChmclDlDtlDlHdrID = DealHeader. DlHdrID
	and	InventoryType in ('I','E')
	)

go
Alter Table DealHeader enable Trigger All
Go

delete DealTypeProductCostingDefault

Insert	DealTypeProductCostingDefault
	(
	DlTypID,
	BAID,
	DelValueMethod,
	RecValueMethod,
	GainValueMethod,
	LossValueMethod,
	LongEndBalValueMethod,
	ShortEndBalValueMethod
	)
Select	DealType.DlTypID
	,BusinessAssociate.BAID
	,DelValue
	,RecValue
	,GainValue
	,LossValue
	,LongEndBalValue
	,ShortEndBalValue
From	BusinessAssociate		(NoLock)
	,DealType			(NoLock)
	,#tmp
Where	BusinessAssociate.BAStts 			= "A"
And	BusinessAssociate.BATpe 			= "D"
And	DealType.DlTypID				In (select dltypid from dealtype where islogistics = 'Y' or Description = 'Exchange Deal')
and 	#Tmp.DlHdrType is not null
and 	#Tmp.DlHdrType = DealType.DlTypID


Insert	DealTypeProductCostingDefault
	(
	DlTypID,
	BAID,
	DelValueMethod,
	RecValueMethod,
	GainValueMethod,
	LossValueMethod,
	LongEndBalValueMethod,
	ShortEndBalValueMethod
	)
Select	DealType.DlTypID
	,BusinessAssociate.BAID
	,DelValue
	,RecValue
	,GainValue
	,LossValue
	,LongEndBalValue
	,ShortEndBalValue
From	BusinessAssociate		(NoLock)
	,DealType			(NoLock)
	,#tmp
Where	BusinessAssociate.BAStts 			= "A"
And	BusinessAssociate.BATpe 			= "D"
And	DealType.DlTypID				In (select dltypid from dealtype where islogistics = 'Y' or Description = 'Exchange Deal')
and 	#Tmp.DlHdrType is null
and	not exists (
	select * from DealTypeProductCostingDefault
	where DealTypeProductCostingDefault.BAID = BusinessAssociate.BAID
	and DealTypeProductCostingDefault.DlTypID= DealType.DlTypID)


go

drop table #tmp
go



IF @@ERROR != 0
BEGIN
    ROLLBACK TRANSACTION
    RETURN
END
ELSE
	COMMIT TRANSACTION 
