declare @vc_scriptname varchar(100) = 'sd_fix_8079_Change_IsAdjustment_on_XHdr'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end


Update	TransactionHeader
Set		IsAdjustment = 'Y'
Where	IsAdjustment = 'N'
And		Exists	(
				Select	1
				From	TransactionHeader Adjustment
				Where	Adjustment.XHdrMvtDtlMvtHdrID = TransactionHeader.XHdrMvtDtlMvtHdrID
				And		Adjustment.IsAdjustment = 'Y'
				)

BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END