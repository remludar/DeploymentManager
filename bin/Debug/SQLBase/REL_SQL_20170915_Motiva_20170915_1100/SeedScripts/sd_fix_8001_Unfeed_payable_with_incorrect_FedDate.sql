declare @vc_scriptname varchar(100) = 'sd_fix_8001_Unfeed_payable_with_incorrect_FedDate'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end


update PayableHeader set feddate = null where pyblehdrid = 8956



BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END