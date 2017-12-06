
Declare @accountDetailTableId int, @vAcctDtlStStID int, @CustomAccountDetailAttributeTableId int  

set @accountDetailTableId = (select Idnty from ColumnSelectionTable where TableName = 'AccountDetail')


if not exists(select '' from ColumnSelectionTable c where c.TableName = 'v_MTV_AccountDetailShipToSoldTo')
insert into ColumnSelectionTable (
TableName
,TableAbbreviation
,TableDescription
,EnttyID
,Datawindow
,SecurityColumns)
values
('v_MTV_AccountDetailShipToSoldTo','VAST','AccountDetailSoldToShipToView',null,'',null)

--Get the Idnty for each of the new rows
set @vAcctDtlStStID = (select Idnty from ColumnSelectionTable where TableName = 'v_MTV_AccountDetailShipToSoldTo')

--insert join syntax
if not exists(select '' from ColumnSelectionTableJoin cstj where cstj.FromClmnSlctnTbleIdnty = @vAcctDtlStStID and cstj.ToClmnSlctnTbleIdnty = @accountDetailTableId)
insert into ColumnSelectionTableJoin (
FromClmnSlctnTbleIdnty
,ToClmnSlctnTbleIdnty
,JoinType
,LeftOuterJoin
,RelationshipPrefix
,JoinSyntax
,Bidirectional)
values
(@vAcctDtlStStID,@accountDetailTableId,'ManyToOne','Y','','[v_MTV_AccountDetailShipToSoldTo].AcctDtlID = [AccountDetail].AcctDtlID','Y')
