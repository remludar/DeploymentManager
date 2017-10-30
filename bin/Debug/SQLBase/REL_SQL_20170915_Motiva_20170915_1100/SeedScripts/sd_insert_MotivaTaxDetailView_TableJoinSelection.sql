--Declare Variables
DECLARE @ID					INT
		,@CreateTable		VARCHAR(128)
		,@CreateTableAbbv	VARCHAR(4)
		,@CreateTableDesc	VARCHAR(255)
		,@JoinTable			VARCHAR(128)
		,@JoinType			VARCHAR(20)
		,@LeftOuterJoin		CHAR(1)
		,@RelationshipPrefix	VARCHAR(50)
		,@JoinSyntax		VARCHAR(7500)
		,@Bidirectional		CHAR(1)

--SET Varibles
--CREATE TABLE INFORMATION
SET		@CreateTable		= 'v_MTV_TaxDetail'
SET		@CreateTableAbbv	= 'MTTD'
SET		@CreateTableDesc	= 'Motiva Tax Detail'

--JOIN TABLE INFORMATION
SET		@JoinTable			= 'AccountDetail'
SET		@JoinType			= 'ManyToOne'	-- 'ManyToOne'
SET		@LeftOuterJoin		= 'Y'
SET		@RelationshipPrefix	= NULL
SET		@JoinSyntax			= '[v_MTV_TaxDetail].OriginalAccountDetailID = [AccountDetail].AcctDtlID'
SET		@Bidirectional		= 'Y'

SELECT  @ID	=	Idnty
			FROM  ColumnSelectionTable 
			where   TableName = @CreateTable
PRINT ' '
PRINT 'Deleting any existing entries for ' + @CreateTable
DELETE
--select *
FROM    ColumnSelectionTableJoin 
WHERE  ColumnSelectionTableJoin.ToClmnSlctnTbleIdnty      = @ID

DELETE 
--SELECT *
from ColumnSelectionTable where TableName = @CreateTable

PRINT ' '
PRINT 'Inserting new entries for ' + @CreateTable
Insert	ColumnSelectionTable
	(
	TableName
	,TableAbbreviation
	,TableDescription
	,Datawindow
	)
Select	@CreateTable
	,@CreateTableAbbv
	,@CreateTableDesc
	,''
Where	Not Exists	(
			Select	''''
			From	ColumnSelectionTable	(NoLock)
			Where	ColumnSelectionTable.TableName		= @CreateTable
			Or	ColumnSelectionTable.TableAbbreviation	= @CreateTableAbbv
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
	Where	ColumnSelectionTable.TableName		= @JoinTable
	)
	,(
	Select	ColumnSelectionTable.Idnty
	From	ColumnSelectionTable	(NoLock)
	Where	ColumnSelectionTable.TableName		= @CreateTable
	)
	,@JoinType
	,@LeftOuterJoin
	,@RelationshipPrefix
	,@JoinSyntax
	,@Bidirectional

Where	Not Exists	(
			Select	''''
			From	ColumnSelectionTableJoin	(NoLock)
			Where	ColumnSelectionTableJoin.JoinSyntax	= @JoinSyntax
			)


SELECT	*
FROM		ColumnSelectionTable
LEFT OUTER JOIN ColumnSelectionTableJoin
ON		ColumnSelectionTable.Idnty		= ColumnSelectionTableJoin.ToClmnSlctnTbleIdnty
WHERE	ColumnSelectionTable.TableName	= @CreateTable