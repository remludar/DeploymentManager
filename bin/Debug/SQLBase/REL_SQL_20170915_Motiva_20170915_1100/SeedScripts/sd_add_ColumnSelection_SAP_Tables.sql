Declare @i_idnty int

select @i_idnty = ( select idnty from columnselectiontable where tablename = 'CustomInvoiceInterface')

if @i_idnty is null
begin
   insert into ColumnSelectionTable
   select 'CustomInvoiceInterface', 'CII', 'Custom Invoice Interface', null, '', null

   select @i_idnty = ( select idnty from columnselectiontable where tablename = 'CustomInvoiceInterface')
end

--select @i_idnty = ( select idnty from columnselectiontable where tablename = 'CustomGLInterface')

--if @i_idnty is null
--begin
--   insert into ColumnSelectionTable
--   select 'CustomGLInterface', 'CGLI', 'Custom GL Interface', null, '', null

--   select @i_idnty = ( select idnty from columnselectiontable where tablename = 'CustomGLInterface')
--end

select @i_idnty = ( select idnty from columnselectiontable where tablename = 'MTVSAPARStaging')

if @i_idnty is null
begin
   insert into ColumnSelectionTable
   select 'MTVSAPARStaging', 'MSAR', 'SAP AR Staging', null, '', null

   select @i_idnty = ( select idnty from columnselectiontable where tablename = 'MTVSAPARStaging')
end


select @i_idnty = ( select idnty from columnselectiontable where tablename = 'MTVSAPAPStaging')

if @i_idnty is null
begin
   insert into ColumnSelectionTable
   select 'MTVSAPAPStaging', 'MSAP', 'SAP AP Staging', null, '', null

   select @i_idnty = ( select idnty from columnselectiontable where tablename = 'MTVSAPAPStaging')
end




if not exists (
				select	1
				from	ColumnSelectionTableJoin
				where	FromClmnSlctnTbleIdnty = (select idnty from columnselectiontable where tablename = 'AccountDetail')
				and		ToClmnSlctnTbleIdnty = (select idnty from columnselectiontable where tablename = 'CustomInvoiceInterface')
				)
   insert into columnselectiontablejoin
   select	(select idnty from columnselectiontable where tablename = 'AccountDetail'),
			(select idnty from columnselectiontable where tablename = 'CustomInvoiceInterface'),
			'OneToOne',
			'Y',
			'',
			'[AccountDetail].AcctDtlID = [CustomInvoiceInterface].AcctDtlID and IsNull([CustomInvoiceInterface].RunningNumber,1) <> 999',
			'Y'


if not exists (
				select	1
				from	ColumnSelectionTableJoin
				where	FromClmnSlctnTbleIdnty = (select idnty from columnselectiontable where tablename = 'CustomInvoiceInterface')
				and		ToClmnSlctnTbleIdnty = (select idnty from columnselectiontable where tablename = 'MTVSAPARStaging')
				)
   insert into columnselectiontablejoin
   select	(select idnty from columnselectiontable where tablename = 'CustomInvoiceInterface'),
			(select idnty from columnselectiontable where tablename = 'MTVSAPARStaging'),
			'OneToOne',
			'Y',
			'',
			'[CustomInvoiceInterface].ID = [MTVSAPARStaging].CIIID',
			'Y'

if not exists (
				select	1
				from	ColumnSelectionTableJoin
				where	FromClmnSlctnTbleIdnty = (select idnty from columnselectiontable where tablename = 'CustomInvoiceInterface')
				and		ToClmnSlctnTbleIdnty = (select idnty from columnselectiontable where tablename = 'MTVSAPAPStaging')
				)
   insert into columnselectiontablejoin
   select	(select idnty from columnselectiontable where tablename = 'CustomInvoiceInterface'),
			(select idnty from columnselectiontable where tablename = 'MTVSAPAPStaging'),
			'OneToOne',
			'Y',
			'',
			'[CustomInvoiceInterface].ID = [MTVSAPAPStaging].CIIID',
			'Y'

