
Delete	EntityAudit
Where	EntityAuditInstanceId in (Select EntityAuditInstanceId From EntityAuditInstance Where EntityAuditTypeId in (Select EntityAuditTypeId From EntityAuditType WHere PrimaryTable in ('MTVSAPARStaging','MTVSAPAPStaging')))

Delete	EntityAuditInstance
Where	EntityAuditTypeId in (Select EntityAuditTypeId From EntityAuditType WHere PrimaryTable in ('MTVSAPARStaging','MTVSAPAPStaging'))

Delete	EntityAuditType
Where	PrimaryTable in ('MTVSAPARStaging','MTVSAPAPStaging')

insert EntityAuditType (AuditEnabled, Name, ServiceName, PrimaryTable, DescriptionColumn)
select 1, 'SAP AR Staging', 'MTVSAPARStagingService', 'MTVSAPARStaging', 'DocNumber'

insert EntityAuditType (AuditEnabled, Name, ServiceName, PrimaryTable, DescriptionColumn)
select 1, 'SAP AP Staging', 'MTVSAPAPStagingService', 'MTVSAPAPStaging', 'DocNumber'

