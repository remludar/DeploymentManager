set nocount off
/********************************************
*********************************************
***** SAP GL Account Override *****
*********************************************
********************************************/

delete SourceSystemElementXref where SrceSystmElmntID in (Select SrceSystmElmntID from SourceSystemElement where srcesystmid = (Select SrceSystmID from SourceSystem where Name = 'SAP Account Override'))
delete SourceSystemElement where srcesystmid = (Select SrceSystmID from SourceSystem where Name = 'SAP Account Override')
delete SourceSystem where Name = 'SAP Account Override'

set nocount on

Insert SourceSystem (Name)
Select 'SAP Account Override'
where not exists (select 1 from SourceSystem where Name = 'SAP Account Override')
go

if not exists (select 1 from SourceSystemElement where ElementName = 'NonTaxAccount' and SrceSystmID = (select SrceSystmID from SourceSystem ss where Name = 'SAP Account Override'))
begin
declare @i_key int
exec sp_getkey 'SourceSystemElement', @i_key out

Insert SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
Select @i_key, (Select SrceSystmID from SourceSystem where Name = 'SAP Account Override'), 'NonTaxAccount', 'x'
end
go
if not exists (select 1 from SourceSystemElement where ElementName = 'TaxAccount' and SrceSystmID = (select SrceSystmID from SourceSystem ss where Name = 'SAP Account Override'))
begin
declare @i_key int
exec sp_getkey 'SourceSystemElement', @i_key out

Insert SourceSystemElement (SrceSystmElmntID, SrceSystmID, ElementName, DisplayStyle)
Select @i_key, (Select SrceSystmID from SourceSystem where Name = 'SAP Account Override'), 'TaxAccount', 'x'
end
go


/************************************************
-- NonTaxAccount
************************************************/
declare @i_ElementID int, @i_key int
Select @i_ElementID = SrceSystmElmntID From SourceSystem SS, SourceSystemElement SSE
Where SS.SrceSystmID = SSE.SrceSystmID and SS.Name = 'SAP Account Override' and SSE.ElementName = 'NonTaxAccount'

print 'SAP Account Override - NonTaxAccount'
begin
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6340010', '3170705', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6000300', '2370000', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6000100', '2370000', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6000200', '2370000', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6009920', '2370000', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6380202', '6380302', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6355025', '6355525', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6355050', '6355552', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6355040', '6355540', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6355100', '6355600', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6341143', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6341144', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6341145', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6341146', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6301330', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6301310', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240200', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240150', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240250', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240251', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7220700', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240410', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240300', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6341141', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240100', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6341148', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240070', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '6341147', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240600', '3180700', 'I'
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '7240610', '3180700', 'I'
end

/************************************************
-- TaxAccount
************************************************/
Select @i_ElementID = SrceSystmElmntID From SourceSystem SS, SourceSystemElement SSE
Where SS.SrceSystmID = SSE.SrceSystmID and SS.Name = 'SAP Account Override' and SSE.ElementName = 'TaxAccount'

print 'SAP Account Override - TaxAccount'
begin
exec sp_getkey 'SourceSystemElementXref', @i_key out Insert SourceSystemElementXref (SrceSystmElmntXrfID, SrceSystmElmntID, ElementValue, InternalValue, ElementDirection) Select @i_key, @i_ElementID, '3680101', '6211200', 'I'

end

