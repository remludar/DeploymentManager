declare @vc_scriptname varchar(100) = 'sd_8128_Load_AR_and_AP_PostingDate_old_periods'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end

Update	MTVSAPARStaging
Set		PostingDate = NexusStatus.CreateDate
From	MTVSAPARStaging
		Inner Join NexusStatus
			on	NexusStatus.MessageID = MTVSAPARStaging.BatchID
Where	MTVSAPARStaging.PostingDate	is null
And		NexusStatus.Status = 'C'
And		NexusStatus.Message	= 'Message Created'


Update	MTVSAPAPStaging
Set		PostingDate = NexusStatus.CreateDate
From	MTVSAPAPStaging
		Inner Join NexusStatus
			on	NexusStatus.MessageID = MTVSAPAPStaging.BatchID
Where	MTVSAPAPStaging.PostingDate	is null
And		NexusStatus.Status = 'C'
And		NexusStatus.Message	= 'Message Created'

BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END