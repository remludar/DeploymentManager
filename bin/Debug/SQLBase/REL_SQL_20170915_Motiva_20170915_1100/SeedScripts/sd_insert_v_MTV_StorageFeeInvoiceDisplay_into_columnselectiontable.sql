Declare @FromTable int
Declare @ToTable int

select @FromTable = ( Select Idnty from columnselectiontable where tablename = 'AccountDetail' )
select @ToTable = ( Select Idnty From columnselectiontable where tablename = 'v_MTV_StorageFeeInvoiceDisplay' )



If @ToTable is null
begin
    insert into ColumnSelectionTable
	select 'v_MTV_StorageFeeInvoiceDisplay', 'SFID', 'Storage Fee Invoice Display',null,'',null

	
   select @ToTable = ( Select Idnty From columnselectiontable where tablename = 'v_MTV_StorageFeeInvoiceDisplay' )
end

if not exists ( select 'x' from columnselectiontablejoin where FromClmnSlctnTbleIdnty = @FromTable and ToClmnSlctnTbleIdnty = @ToTable )
   insert into columnselectiontablejoin
   select @fromtable, @toTable, 'OneToOne', 'Y', '', '[AccountDetail].AcctDtlID = [v_MTV_StorageFeeInvoiceDisplay].AcctDtlID','Y' 

