/*Author:	Chris Nettles
Date:		9/8/2017
Purpose:	This script will create a new PB process item that is to be used with the 
			invoice from queue process.  
*/

declare @i_Key				int
declare @i_processGroupID	int
declare @vc_processName		varchar(50) = 'MTV Invoice Prevalidation'

--Create new PB Process Item
if not exists
(
	select	1 
	from	ProcessItem
	where	ProcessItem.PrcssItmNme	=	@vc_processName
)
begin
	exec sp_getkey 'ProcessItem', @i_Key out

	insert ProcessItem
	(
		PrcssItmID
		,PrcssItmNme
		,PrcssItmDscrptn
		,PrcssItmCmmndLne
		,PrcssItmCmmndTpe
		,PrcssItmPrmtrDscrptn
		,PrcssItmStts
	)
	select	@i_Key
			,@vc_processName
			,'Sets thresholds for results of various reports to prevent invoicing jobs from running if limit breached. Run type should either be InvoiceQueue or InvoicePrint'
			,'MTV_InvoicePrevalidation'
			,'S'
			,'Run type, Tax Limit, Sat Limit, Move Xtr Limit, Inv Debug Limit.  Example: ''InvoiceQueue'', 100, 200, 300, 400'
			,'A'
end

--Create new process group that process item will be associated with
if not exists
(
	select	1 
	from	ProcessGroup
	where	ProcessGroup.PrcssGrpNme	=	@vc_processName
)
begin
	exec sp_getkey 'ProcessGroup', @i_Key out

	insert	ProcessGroup
	(
		PrcssGrpID
		,PrcssGrpNme
		,PrcssGrpDscrptn
		,PrcssGrpSnglePrcss
		,PrcssGrpStts
		,TotalSeconds
		,RunCount
		,CanRunAsService
	)
	select	@i_Key
			,@vc_processName
			,'Sets thresholds for results of various reports to prevent invoicing jobs from running if over. Will go back 24 hours from time task is run.  Reference technical documentation for additional params.'
			,'Y'
			,'A'
			,0
			,0
			,'Y'
end

--Associate the process item with the process group
if not exists
(
	select	1
	from	ProcessGroupRelation PGR
		inner join ProcessGroup PG	on		PG.PrcssGrpNme	=	@vc_processName 
		inner join ProcessItem PRI	on		PRI.PrcssItmNme =	@vc_processName
	where	PGR.PrcssGrpRltnPrcssGrpID	=	PG.PrcssGrpID
		and	PGR.PrcssGrpRltnPrcssItmID	=	PRI.PrcssItmID
)
begin
	exec sp_getkey 'ProcessGroupRelation', @i_Key out

	insert ProcessGroupRelation
	(
		PrcssGrpRltnID
		,PrcssGrpRltnOrdr
		,PrcssGrpRltnPrcssGrpID
		,PrcssGrpRltnPrcssItmID
	)
	select	@i_Key
			,1
			,(select PrcssGrpID		from ProcessGroup	where PrcssGrpNme	=	@vc_processName)
			,(select PrcssItmID		from ProcessItem	where PrcssItmNme	=	@vc_processName)

end	

