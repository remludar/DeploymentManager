IF OBJECT_ID('dbo.SRNTC_Create_ExternalColumn_JoinSyntax') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.SRNTC_Create_ExternalColumn_JoinSyntax
    IF OBJECT_ID('dbo.SRNTC_Create_ExternalColumn_JoinSyntax') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.SRNTC_Create_ExternalColumn_JoinSyntax >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.SRNTC_Create_ExternalColumn_JoinSyntax >>>'
END
go
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON
go
Create Procedure [dbo].[SRNTC_Create_ExternalColumn_JoinSyntax] @vc_FromTable varchar(128) = null,
																@vc_ToTable varchar(128) = null,
																@vc_TableAbbrv varchar(4) = null,
																@vc_TableDesc varchar(255) = null,
																@vc_JoinType varchar(20) = null,
																@vc_JoinSyntax varchar(7500) = null

As
Set NoCount ON
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	SRNTC_Create_ExternalColumn_JoinSyntax           Copyright 2009 SolArc
-- Overview:	Create Batch for Deal XML extract.
-- Arguments:		
-- Created by:	Ron Garrison
-- For comments or questions related to this procedure, contact Ron Garrison – RGarrison@SolArc.com
-- History:	02/13/2009 - First Created
--
-- 	Date Modified 	Modified By		Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
--	02-13-2009		Ron Garrison			Initial Version
-------------------------------------------------------------------------------------------------------------------------

 --exec SRNTC_Create_ExternalColumn_JoinSyntax @vc_FromTable = 'DealHeader',
	--											 @vc_ToTable = 'v_DealHeader_Attr',
	--											 @vc_TableAbbrv = 'DHA1',
	--											 @vc_TableDesc = 'DealHeader Attributes',
	--											 @vc_JoinType = 'OneToOne',
	--											 @vc_JoinSyntax = '[DealHeader].DlHdrID = [v_DealHeader_Attr].GnrlCnfgHdrID and [v_DealHeader_Attr].GnrlCnfgDtlID = 0'

Insert	ColumnSelectionTable
	(
	TableName,
	TableAbbreviation,
	TableDescription,
	Datawindow
	)
Select	@vc_ToTable,
	@vc_TableAbbrv,
	@vc_TableDesc,
	''
Where	Not Exists	(
			Select	''
			From	ColumnSelectionTable	(NoLock)
			Where	ColumnSelectionTable.TableName		= @vc_ToTable
			Or	ColumnSelectionTable.TableAbbreviation	= @vc_TableAbbrv
			)

--  Add Primary Cost Provision link to DealDetail Table
Insert	ColumnSelectionTableJoin
	(
	FromClmnSlctnTbleIdnty,
	ToClmnSlctnTbleIdnty,
	JoinType,
	LeftOuterJoin,
	RelationshipPrefix,
	JoinSyntax,
	Bidirectional
	)
Select	(
	Select	ColumnSelectionTable.Idnty
	From	ColumnSelectionTable	(NoLock)
	Where	ColumnSelectionTable.TableName		= @vc_FromTable
	),
	(
	Select	ColumnSelectionTable.Idnty
	From	ColumnSelectionTable	(NoLock)
	Where	ColumnSelectionTable.TableName		= @vc_ToTable
	),
	@vc_JoinType,
	'Y',
	'',
	@vc_JoinSyntax,
	'Y'
Where	Not Exists	(
			Select	''
			From	ColumnSelectionTableJoin	(NoLock)
			Where	ColumnSelectionTableJoin.JoinSyntax	= @vc_JoinSyntax
			)

create table #TempConfig
	(Row1 varchar(2000))

select 
'******************************************************************************************
**** Copy the XML below to the DataDictionaryConfiguration.config file                 ***
**** located in the ...\OpenLink\RightAngle.NET\ConfigurationData\System\Override folder ***
******************************************************************************************'

insert #TempConfig
select 
'<?xml version="1.0" standalone="yes"?>
<DataDictionaryDataSet xmlns="http://tempuri.org/DataDictionaryDataSet.xsd">'

insert #TempConfig
select 
'	<TableEntity>
		<TableName>' + @vc_ToTable + '</TableName>
		<TableAlias>' + @vc_TableAbbrv + '</TableAlias>
	</TableEntity>
	<ColumnJoinInformation>
		<JoinKey>' + @vc_FromTable + '@' + @vc_ToTable + '</JoinKey>
		<JoinFromTableName>' + @vc_FromTable + '</JoinFromTableName>
		<JoinFromTableDescription>' + @vc_FromTable + '</JoinFromTableDescription>
		<JoinToTableName>' + @vc_ToTable + '</JoinToTableName>
		<JoinToTableDescription>' + @vc_TableDesc + '</JoinToTableDescription>
		<JoinSyntax>' + @vc_JoinSyntax + '</JoinSyntax>
		<JoinType>' + @vc_JoinType + '</JoinType>
	</ColumnJoinInformation>'

insert #TempConfig
select '</DataDictionaryDataSet>'

select Row1 from #TempConfig

drop table #TempConfig

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
IF OBJECT_ID('dbo.SRNTC_Create_ExternalColumn_JoinSyntax') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.SRNTC_Create_ExternalColumn_JoinSyntax >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.SRNTC_Create_ExternalColumn_JoinSyntax >>>'
go
GRANT EXECUTE ON dbo.SRNTC_Create_ExternalColumn_JoinSyntax TO sysuser
go
