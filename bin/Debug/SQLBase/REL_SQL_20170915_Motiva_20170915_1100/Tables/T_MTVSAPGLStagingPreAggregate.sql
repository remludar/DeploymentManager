If Object_ID('dbo.MTVSAPGLStagingPreAggregate') is null
begin
	Select * Into [dbo].MTVSAPGLStagingPreAggregate From MTVSAPGLStaging Where 1=2
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVSAPGLStagingPreAggregate] to sysuser, RightAngleAccess
end

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.name = 'dbo.MTVSAPGLStagingPreAggregate' and sc.name = 'AccntngPrdID')
begin
	Alter Table MTVSAPGLStagingPreAggregate Add AccntngPrdID int not null
	Create nonclustered index IDX1_MTVSAPGLStagingPreAggregate_AccntngPrdID on dbo.MTVSAPGLStagingPreAggregate (AccntngPrdID)
end

if not exists (select 1 from syscolumns sc, sysobjects so where so.id = sc.id and so.name = 'MTVSAPGLStagingPreAggregate' and sc.name = 'AcctDtlID')
begin
	Alter Table [dbo].[MTVSAPGLStagingPreAggregate] Add AcctDtlID Int null

	Update	MTVSAPGLStagingPreAggregate Set AcctDtlID = Convert(Int, Replace(substring(DocumentHeaderText,0,charindex('-', DocumentHeaderText)), 'R', '')) Where charindex('-', DocumentHeaderText) > 0 and AcctDtlID is null
	Update	MTVSAPGLStagingPreAggregate Set AcctDtlID = Convert(Int, Replace(DocumentHeaderText, 'R', '')) Where charindex('-', DocumentHeaderText) = 0 and AcctDtlID is null

	Alter Table [dbo].[MTVSAPGLStagingPreAggregate] Alter Column AcctDtlID Int not null
	Create Nonclustered Index AK_MTVSAPGLStagingPreAggregate_AcctDtlID on [dbo].[MTVSAPGLStagingPreAggregate](AcctDtlID)
end
