declare @vc_scriptname varchar(100) = 'sd_8242_Change_PreAgg_ExtColumn_JoinSyntax'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end

update	ColumnSelectionTableJoin
Set		JoinSyntax = JoinSyntax + '
and not exists	(	select	1
					from	MTVSAPGLStagingPreAggregate sub
					where	sub.AcctDtlID = [MTVSAPGLStagingPreAggregate].AcctDtlID
					and		sub.PostingKey = [MTVSAPGLStagingPreAggregate].PostingKey
					and		CharIndex(''R'', sub.DocumentHeaderText) = CharIndex(''R'', [MTVSAPGLStagingPreAggregate].DocumentHeaderText)
					and		sub.AccntngPrdID > [MTVSAPGLStagingPreAggregate].AccntngPrdID
					)'
where ToClmnSlctnTbleIdnty = (select Idnty from ColumnSelectionTable where TableName = 'MTVSAPGLStagingPreAggregate')

BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END