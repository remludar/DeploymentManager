
set nocount on
--drop table #feddate
--drop table #errored
-- update statistics MTVSAPARStaging with fullscan 
-- update statistics EventLog with fullscan

Select	*
Into	#feddate
From	EventLog (NoLock)
Where	Message like 'Error: SAP update failed%'
and		data not like '%null%'

raiserror('feddate loaded', -1, -1) with nowait

Select	*
Into	#errored
From	EventLog (NoLock)
Where	Message like 'Error: SAP update failed%'
and		data like '%null%'

raiserror('errored loaded', -1, -1) with nowait


alter table #feddate add batchid int
update #feddate set batchid = convert(int, replace(replace(replace(stuff(data, 1, len(data)-8, ''), char(13), ''), char(10), ''), '=', ''))

raiserror('batchid set', -1, -1) with nowait


declare @sdt_date smalldatetime, @vc_sql nvarchar(max)
select @sdt_date = min(eventdatetime) from #feddate
while @sdt_date is not null
begin
	select @vc_sql = convert(varchar, @sdt_date)

	Update	dbo.SalesInvoiceHeader
    Set		SlsInvceHdrFdDte = convert(smalldatetime, convert(varchar, @sdt_date, 0))
    From	dbo.MTVSAPARStaging (NoLock)
		    Inner Join dbo.CustomMessageQueue (NoLock)
			    on	CustomMessageQueue.ID		= MTVSAPARStaging.CIIMssgQID
			    and	CustomMessageQueue.Entity	= 'SH'
		    Inner Join dbo.SalesInvoiceHeader (NoLock)
			    on	CustomMessageQueue.EntityID	= SalesInvoiceHeader.SlsInvceHdrID
    Where	MTVSAPARStaging.InvoiceLevel	= 'H'
    And		MTVSAPARStaging.BatchID			in (select sub.batchid from #feddate sub where datediff(minute, @sdt_date, sub.EventDateTime) < 1 )
                                            
	delete #feddate where datediff(minute, @sdt_date, EventDateTime) < 1 
	select @sdt_date = min(eventdatetime) from #feddate
end
raiserror('feddate processed', -1, -1) with nowait



declare @i_int int
select @i_int = min(eventlogid) from #errored
while @i_int is not null
begin
	select @vc_sql = data from #errored where eventlogid = @i_int
	exec sp_executesql @vc_sql
	delete #errored where eventlogid = @i_int
	select @i_int = min(eventlogid) from #errored
end
raiserror('errors processed', -1, -1) with nowait



Update	SalesInvoiceHeader
Set		SlsInvceHdrFdDte = NexusStatus.CreateDate
-- Select	*
From	MTVSAPARStaging (nolock)
		inner join SalesInvoiceHeader (nolock)
			on	SalesInvoiceHeader.SlsInvceHdrNmbr = MTVSAPARStaging.DocNumber
		inner join NexusStatus (nolock)
			on	NexusStatus.MessageID	= MTVSAPARStaging.BatchID
			and	NexusStatus.Message		like '%Document posted successfully%'
Where	SalesInvoiceHeader.SlsInvceHdrFdDte	is null
And		MTVSAPARStaging.RightAngleStatus	= 'c'
and		MTVSAPARStaging.SAPStatus			= 'c'
raiserror('missing EventLog records processed', -1, -1) with nowait



Update	SalesInvoiceHeader
Set		SlsInvceHdrFdDte = NexusStatus.CreateDate
-- Select	*
From	MTVSAPARStaging (nolock)
		inner join SalesInvoiceHeader (nolock)
			on	SalesInvoiceHeader.SlsInvceHdrNmbr = MTVSAPARStaging.DocNumber
		inner join NexusStatus (nolock)
			on	NexusStatus.MessageID	= MTVSAPARStaging.BatchID
			and	NexusStatus.Status		= 'S'
Where	SalesInvoiceHeader.SlsInvceHdrFdDte	is null
--and		SalesInvoiceHeader.SlsInvceHdrNmbr	= '1700000020'
And		MTVSAPARStaging.RightAngleStatus	= 'c'
and		MTVSAPARStaging.SAPStatus			= 'c'
and		MTVSAPARStaging.InvoiceLevel		= 'H'
raiserror('SAP sent "Success" records processed', -1, -1) with nowait