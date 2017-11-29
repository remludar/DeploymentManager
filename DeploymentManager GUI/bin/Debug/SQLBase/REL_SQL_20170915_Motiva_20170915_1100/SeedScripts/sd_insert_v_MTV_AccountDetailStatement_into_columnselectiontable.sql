Declare @FromTable int
Declare @ToTable int

select @FromTable = ( Select Idnty from columnselectiontable where tablename = 'AccountDetail' )
select @ToTable = ( Select Idnty From columnselectiontable where tablename = 'v_mtv_AccountDetailStatement' )


If @ToTable is null
begin
    insert into ColumnSelectionTable
	select 'v_mtv_AccountDetailStatement', 'MADS', 'Third Party Statement',null,'',null

	
   select @ToTable = ( Select Idnty From columnselectiontable where tablename = 'v_mtv_AccountDetailStatement' )
end

if not exists ( select 'x' from columnselectiontablejoin where FromClmnSlctnTbleIdnty = @FromTable and ToClmnSlctnTbleIdnty = @ToTable )
   insert into columnselectiontablejoin
   select @fromtable, @toTable, 'OneToOne', 'Y', '', '[AccountDetail].AcctDtlID = [v_mtv_AccountDetailStatement].AcctDtlID','Y' 


