declare @SrceSystmID int
declare @SrceSystmElmntIDR int
declare @SrceSystmElmntIDD int

select @SrceSystmID = ( select SrceSystmID from sourcesystem where name = 'TMS')
select @SrceSystmElmntIDR = ( select SrceSystmElmntID from sourcesystemelement where ElementName = 'ModeOfTransportReceipt' )
if @SrceSystmElmntIDR is null
begin
   exec sp_getkey 'Sourcesystemelement', @SrceSystmElmntIDR out
   insert into sourcesystemelement  select @SrceSystmElmntIDR,@SrceSystmID,'ModeOfTransportReceipt','dddw.dddw_deal_transportationtype.DynSnglLstBxDesc.DynSnglLstBxSnglChrTyp'
end


select @SrceSystmElmntIDD = ( select SrceSystmElmntID from sourcesystemelement where ElementName = 'ModeOfTransportDelivery' )
if @SrceSystmElmntIDD is null
begin
   exec sp_getkey 'Sourcesystemelement', @SrceSystmElmntIDD out
   insert into sourcesystemelement  select @SrceSystmElmntIDD,@SrceSystmID,'ModeOfTransportDelivery','dddw.dddw_deal_transportationtype.DynSnglLstBxDesc.DynSnglLstBxSnglChrTyp'
end

