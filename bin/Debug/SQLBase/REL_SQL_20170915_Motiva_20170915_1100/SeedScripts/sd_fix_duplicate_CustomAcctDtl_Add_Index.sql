
Delete	CustomAccountDetailAttribute
Where	Exists	(
				select	1
				from	customaccountdetailattribute cada2
				where	cada2.cadid = CustomAccountDetailAttribute.cadid
				and		cada2.id	> CustomAccountDetailAttribute.id
				)

if exists (select 1 from sysindexes where name = 'idx_CustomAccountDetailAttribute_CADID')
begin
	drop index idx_CustomAccountDetailAttribute_CADID on dbo.CustomAccountDetailAttribute

	Create unique nonclustered index idx_CustomAccountDetailAttribute_CADID on dbo.CustomAccountDetailAttribute(CADID)
end

if not exists (select 1 from sysindexes where name = 'idx_CustomAccountDetail_InterfaceMessageID')
	Create Nonclustered Index idx_CustomAccountDetail_InterfaceMessageID on dbo.CustomAccountDetail(InterfaceMessageID)

if not exists (select 1 from sysindexes where name = 'idx_CustomAccountDetail_AcctDtlID')
	Create Nonclustered Index idx_CustomAccountDetail_AcctDtlID on dbo.CustomAccountDetail(AcctDtlID)

if not exists (select 1 from sysindexes where name = 'idx_CustomAccountDetail_AcctDtlSrceID')
	Create Nonclustered Index idx_CustomAccountDetail_AcctDtlSrceID on dbo.CustomAccountDetail(AcctDtlSrceID) Include (ID, AcctDtlID, TrnsctnTypID)