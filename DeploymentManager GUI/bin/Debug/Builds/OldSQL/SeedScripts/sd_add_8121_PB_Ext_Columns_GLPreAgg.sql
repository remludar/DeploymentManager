declare @vc_scriptname varchar(100) = 'sd_add_8121_PB_Ext_Columns_GLPreAgg'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end


Declare @PreAggID int, @AcctDtlID int

select @PreAggID  = idnty from columnselectiontable where tablename = 'MTVSAPGLStagingPreAggregate'
select @AcctDtlID = idnty from columnselectiontable where tablename = 'AccountDetail'


if @PreAggID is null
begin
	insert into ColumnSelectionTable (TableName,TableAbbreviation,TableDescription,EnttyID,Datawindow,SecurityColumns)
	select 'MTVSAPGLStagingPreAggregate', 'GLPA', 'SAP GL Staging (PreAgg)', null,'',null

	select @PreAggID  = idnty from columnselectiontable where tablename = 'MTVSAPGLStagingPreAggregate'
end


if not exists	(
				select	1
				from	ColumnSelectionTableJoin
				where	FromClmnSlctnTbleIdnty	= @AcctDtlID
				and		ToClmnSlctnTbleIdnty	= @PreAggID
				and		RelationshipPrefix		= 'Credit -'
				)
   insert into columnselectiontablejoin (FromClmnSlctnTbleIdnty,ToClmnSlctnTbleIdnty,JoinType,LeftOuterJoin,RelationshipPrefix,JoinSyntax,Bidirectional)
   select	@AcctDtlID,
			@PreAggID,
			'OneToOne',
			'Y',
			'Credit -',
			'[AccountDetail].AcctDtlID = [MTVSAPGLStagingPreAggregate].AcctDtlID and [MTVSAPGLStagingPreAggregate].PostingKey = 50 and CharIndex(''R'', [MTVSAPGLStagingPreAggregate].DocumentHeaderText) = 0',
			'N'

if not exists	(
				select	1
				from	ColumnSelectionTableJoin
				where	FromClmnSlctnTbleIdnty	= @AcctDtlID
				and		ToClmnSlctnTbleIdnty	= @PreAggID
				and		RelationshipPrefix		= 'Debit -'
				)
   insert into columnselectiontablejoin (FromClmnSlctnTbleIdnty,ToClmnSlctnTbleIdnty,JoinType,LeftOuterJoin,RelationshipPrefix,JoinSyntax,Bidirectional)
   select	@AcctDtlID,
			@PreAggID,
			'OneToOne',
			'Y',
			'Debit -',
			'[AccountDetail].AcctDtlID = [MTVSAPGLStagingPreAggregate].AcctDtlID and [MTVSAPGLStagingPreAggregate].PostingKey = 40 and CharIndex(''R'', [MTVSAPGLStagingPreAggregate].DocumentHeaderText) = 0',
			'N'



if not exists	(
				select	1
				from	ColumnSelectionTableJoin
				where	FromClmnSlctnTbleIdnty	= @AcctDtlID
				and		ToClmnSlctnTbleIdnty	= @PreAggID
				and		RelationshipPrefix		= 'Credit Rev -'
				)
   insert into columnselectiontablejoin (FromClmnSlctnTbleIdnty,ToClmnSlctnTbleIdnty,JoinType,LeftOuterJoin,RelationshipPrefix,JoinSyntax,Bidirectional)
   select	@AcctDtlID,
			@PreAggID,
			'OneToOne',
			'Y',
			'Credit Rev -',
			'[AccountDetail].AcctDtlID = [MTVSAPGLStagingPreAggregate].AcctDtlID and [MTVSAPGLStagingPreAggregate].PostingKey = 50 and CharIndex(''R'', [MTVSAPGLStagingPreAggregate].DocumentHeaderText) > 0',
			'N'

if not exists	(
				select	1
				from	ColumnSelectionTableJoin
				where	FromClmnSlctnTbleIdnty	= @AcctDtlID
				and		ToClmnSlctnTbleIdnty	= @PreAggID
				and		RelationshipPrefix		= 'Debit Rev -'
				)
   insert into columnselectiontablejoin (FromClmnSlctnTbleIdnty,ToClmnSlctnTbleIdnty,JoinType,LeftOuterJoin,RelationshipPrefix,JoinSyntax,Bidirectional)
   select	@AcctDtlID,
			@PreAggID,
			'OneToOne',
			'Y',
			'Debit Rev -',
			'[AccountDetail].AcctDtlID = [MTVSAPGLStagingPreAggregate].AcctDtlID and [MTVSAPGLStagingPreAggregate].PostingKey = 40 and CharIndex(''R'', [MTVSAPGLStagingPreAggregate].DocumentHeaderText) > 0',
			'N'


BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END