declare @vc_scriptname varchar(100) = 'sd_8235_Enable_GLStaging_Audit'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end

insert EntityAuditType (AuditEnabled, Name, ServiceName, PrimaryTable, DescriptionColumn)
select 1, 'SAP GL Staging', 'MTVSAPGLStagingService', 'MTVSAPGLStaging', 'DocumentHeaderText'

BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END
