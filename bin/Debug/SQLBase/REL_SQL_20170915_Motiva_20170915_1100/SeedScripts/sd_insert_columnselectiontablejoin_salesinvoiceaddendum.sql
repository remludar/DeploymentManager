Declare @sia_idnty int, @sih_idnty int
Declare @ad_idnty int, @rm_idnty int

select @sia_idnty = ( select idnty from columnselectiontable where tablename = 'salesinvoiceaddendum')

select @sih_idnty = ( select idnty from columnselectiontable where tablename = 'salesinvoiceheader')

select @ad_idnty = ( select idnty from columnselectiontable where tablename = 'accountdetail')
select @rm_idnty = ( select idnty from ColumnSelectionTable where tablename = 'regulatorymessage')


if @sia_idnty is null
begin
   insert into ColumnSelectionTable
   select 'SalesInvoiceAddendum', 'SIA', 'Invoice Addendum', 10,'',null

   select @sia_idnty = ( select idnty from columnselectiontable where tablename = 'salesinvoiceaddendum')
end

if @rm_idnty is null
begin

   insert into ColumnSelectionTable
   select 'RegulatoryMessage', 'RM', 'Regulatory Message', null,'',null

   select @rm_idnty = ( select idnty from columnselectiontable where tablename = 'RegulatoryMessage')
end

if not exists ( select 'x' from ColumnSelectionTableJoin  where FromClmnSlctnTbleIdnty = @sih_idnty and ToClmnSlctnTbleIdnty = @sia_Idnty )
   insert into columnselectiontablejoin
   select @sih_idnty, @sia_idnty, 'OneToMany','Y','','[SalesInvoiceHeader].SlsInvceHdrID = [SalesInvoiceAddendum].SlsInvceHdrID','Y'



if not exists ( select 'x' from ColumnSelectionTableJoin  where FromClmnSlctnTbleIdnty = @ad_idnty and ToClmnSlctnTbleIdnty = @sia_Idnty )
   insert into columnselectiontablejoin
   select @ad_idnty, @sia_idnty, 'OneToMany','Y','','[AccountDetail].AcctDtlSlsInvceHdrID = [SalesInvoiceAddendum].SlsInvceHdrID','Y'
   
   
--select * from salesinvoiceaddendum     
--select * from regulatorymessage

if not exists ( select 'x' from ColumnSelectionTableJoin  where FromClmnSlctnTbleIdnty = @sia_idnty and ToClmnSlctnTbleIdnty = @rm_Idnty )
   insert into ColumnSelectionTableJoin
   select @sia_idnty, @rm_idnty, 'OneToMany','Y','','[SalesInvoiceAddendum].SrceID = [RegulatoryMessage].RgltryMssgeID and [SalesInvoiceAddendum].SrceTble = ''R''','Y'
else
   update columnselectiontablejoin
   set JoinSyntax = '[SalesInvoiceAddendum].SrceID = [RegulatoryMessage].RgltryMssgeID and [SalesInvoiceAddendum].SrceTble = ''R'''
   where FromClmnSlctnTbleIdnty = @sia_idnty and ToClmnSlctnTbleIdnty = @rm_Idnty
