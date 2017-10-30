
insert ColumnSelectionTableJoin (FromClmnSlctnTbleIdnty, ToClmnSlctnTbleIdnty, JoinType, LeftOuterJoin, RelationshipPrefix, JoinSyntax, Bidirectional)
Select	CSTFrom.Idnty, CSTTo.Idnty, 'ManyToOne', 'N', '', '[AccountDetail].AcctDtlStrtgyID = [StrategyHeader].StrtgyID', 'N'
From	ColumnSelectionTable CSTFrom
		Inner Join ColumnSelectionTable CSTTo
			on	CSTTo.TableName = 'StrategyHeader'
Where	CSTFrom.TableName = 'AccountDetail'
and		not exists	(
					Select	1
					From	ColumnSelectionTableJoin
					Where	FromClmnSlctnTbleIdnty		= CSTFrom.Idnty
					and		ToClmnSlctnTbleIdnty		= CSTTo.Idnty
					and		JoinSyntax					= '[AccountDetail].AcctDtlStrtgyID = [StrategyHeader].StrtgyID')
