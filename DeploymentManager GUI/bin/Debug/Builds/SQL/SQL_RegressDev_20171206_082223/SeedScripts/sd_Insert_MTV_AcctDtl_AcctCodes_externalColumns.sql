-- sd_Insert_MTV_AcctDtl_AcctCodes_externalColumns

Insert	ColumnSelectionTable
		(
		TableName
		,TableAbbreviation
		,TableDescription
		,Datawindow
		)
Select	'V_MTV_AcctDtl_AcctCodes'
		,'MTAD'
		,'Motiva AcctCodes'
		,''
Where	Not Exists	(
					Select	1
					From	ColumnSelectionTable	(NoLock)
					Where	ColumnSelectionTable.TableName		= 'V_MTV_AcctDtl_AcctCodes'
					Or	ColumnSelectionTable.TableAbbreviation	= 'MTAD'
					)


Insert	ColumnSelectionTableJoin
		(
		FromClmnSlctnTbleIdnty
		,ToClmnSlctnTbleIdnty
		,JoinType
		,LeftOuterJoin
		,RelationshipPrefix
		,JoinSyntax
		,Bidirectional
		)
Select	(
		Select	ColumnSelectionTable.Idnty
		From	ColumnSelectionTable	(NoLock)
		Where	ColumnSelectionTable.TableName		= 'AccountDetail'
		)
		,(
		Select	ColumnSelectionTable.Idnty
		From	ColumnSelectionTable	(NoLock)
		Where	ColumnSelectionTable.TableName		= 'V_MTV_AcctDtl_AcctCodes'
		)
		,'OneToOne'
		,'Y'
		,NULL
		,'[V_MTV_AcctDtl_AcctCodes].AcctDtlID = [AccountDetail].AcctDtlID'
		,'N'

Where	Not Exists	(
					Select	1
					From	ColumnSelectionTableJoin	(NoLock)
					Where	ColumnSelectionTableJoin.JoinSyntax	= '[V_MTV_AcctDtl_AcctCodes].AcctDtlID = [AccountDetail].AcctDtlID'
					)

