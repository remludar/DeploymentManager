-- sd_alter_MTVDLInvTransactionsStaging_MovementDocumentDate
if exists (select 1 from sysobjects so, syscolumns sc where so.id = sc.id and so.name = 'MTVDLInvTransactionsStaging' and sc.name = 'MovementDocumentDate')
begin
	exec sp_rename 'dbo.MTVDLInvTransactionsStaging.MovementDocumentDate' , 'MovementDate', 'column'
end
