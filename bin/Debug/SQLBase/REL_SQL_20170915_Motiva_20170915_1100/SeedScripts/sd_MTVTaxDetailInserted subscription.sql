
---------------------------------------------------------------------------------------------------------------------------------------------
if not exists ( select 'x' from ProcessGroup where PrcssGrpNme = 'Custom Tax Detail Inserted' )
begin

declare @i_key int
exec sp_getkey 'ProcessGroup',@i_key out

insert into ProcessGroup
(PrcssGrpID
,PrcssGrpNme
,PrcssGrpDscrptn
,PrcssGrpSnglePrcss
,PrcssGrpStts
,TotalSeconds
,RunCount
,CanRunAsService
)
select @i_key
,'Custom Tax Detail Inserted'
,'Custom Tax Detail Inserted'
,'Y'
,'A'
,0
,0
,'Y'

exec sp_getkey 'ProcessItem',@i_key out
insert into ProcessItem
( PrcssItmID
,PrcssItmNme
,PrcssItmDscrptn
,PrcssItmCmmndLne
,PrcssItmCmmndTpe
,PrcssItmPrmtrDscrptn
,PrcssItmStts
,ParameterGUIObject)
select @i_key, 'Custom Tax Detail Inserted','Archive Inserted Tax Rate','sp_MTVTaxDetailInserted','S','(none)','A',NULL


end
--select * from subsystem
--
declare @i_prcssgrpid int
declare @i_mssgeid    int
declare @i_PrcssItmID int
select @i_prcssgrpid = ( Select prcssgrpid from ProcessGroup where PrcssGrpNme = 'Custom Tax Detail Inserted' )
select @i_PrcssItmID = ( select PrcssItmID from ProcessItem where PrcssItmNme = 'Custom Tax Detail Inserted' )
select @i_mssgeid = ( select Mssgeid from Message where message.Name = 'AccountDetail Inserted' ) --'TransactionDetailLog Inserted'
if not exists ( select 'x' from processgrouprelation where PrcssGrpRltnPrcssGrpID = @i_prcssgrpid)
begin
    exec sp_getkey 'ProcessGroupRelation', @i_key out
    insert into processgrouprelation
    select @i_key, @i_PrcssItmID, @i_PrcssGrpID, 1
end

if not exists ( select 'x' from Subscription where MssgeID = @i_mssgeid and PrcssGrpID = @i_prcssgrpid )
  insert into subscription
  select @i_prcssgrpid,(select SbsystmID from subsystem where name = 'Accounting' )  ,@i_mssgeid,'Accounting','N','A'
  
go
