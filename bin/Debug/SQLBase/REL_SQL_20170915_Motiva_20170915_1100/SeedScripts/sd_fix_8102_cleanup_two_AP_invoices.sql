declare @vc_scriptname varchar(100) = 'sd_fix_8102_cleanup_two_AP_invoices'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end


Delete	MTVSAPAPStaging
Where	DocNumber in ('201721','201722')
And		CIIMssgQID in (289556, 316270, 289559, 316278)
And		Not Exists (Select 1 From CustomMessageQueue Where ID = CIIMssgQID)

Update	MTVSAPAPStaging
Set		SAPStatus = 'C'
Where	DocNumber in ('201721','201722')
And		CIIMssgQID in (289556, 316270, 289559, 316278)


BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END