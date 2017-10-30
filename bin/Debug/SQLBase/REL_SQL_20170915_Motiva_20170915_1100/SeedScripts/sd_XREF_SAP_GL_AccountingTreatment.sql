set nocount off
/********************************************
*********************************************
***** SAP GL Accounting Treatment *****
*********************************************
********************************************/

delete SourceSystemElementXref where SrceSystmElmntID in (Select SrceSystmElmntID from SourceSystemElement where srcesystmid = (Select SrceSystmID from SourceSystem where Name = 'SAP GL Accounting Treatment'))
delete SourceSystemElement where srcesystmid = (Select SrceSystmID from SourceSystem where Name = 'SAP GL Accounting Treatment')
delete SourceSystem where Name = 'SAP GL Accounting Treatment'

set nocount off

Insert SourceSystem (Name)
Select 'SAP GL Accounting Treatment'
where not exists (select 1 from SourceSystem where Name = 'SAP GL Accounting Treatment')
go

if not exists (select 1 from SourceSystemElement where ElementName = 'Accounting Treatment' and SrceSystmID = (select SrceSystmID from SourceSystem ss where Name = 'SAP GL Accounting Treatment'))
begin
declare @i_key int
exec sp_getkey 'SourceSystemElement', @i_key out

Insert SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
Select @i_key, (Select SrceSystmID from SourceSystem where Name = 'SAP GL Accounting Treatment'), 'Accounting Treatment', 'x'
end
go

/************************************************
-- Accounting Treatment
************************************************/
declare @i_ElementID int, @i_key int
Select @i_ElementID = SrceSystmElmntID From SourceSystem SS, SourceSystemElement SSE
Where SS.SrceSystmID = SSE.SrceSystmID and SS.Name = 'SAP GL Accounting Treatment' and SSE.ElementName = 'Accounting Treatment'

print 'SAP GL Accounting Treatment - Accounting Treatment'
begin
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, 'Derivative', 'Y', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, 'Non-Derivative', 'N', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, 'NPNS', 'N', 'I'
end


