if not exists (select 1 from sys.indexes where name = 'AK6_CustomGLInterface')
begin
	create nonclustered index AK6_CustomGLInterface on dbo.CustomGLInterface (AccntngPrdID)
	print 'Created index'
end
else
	print 'Index exists'