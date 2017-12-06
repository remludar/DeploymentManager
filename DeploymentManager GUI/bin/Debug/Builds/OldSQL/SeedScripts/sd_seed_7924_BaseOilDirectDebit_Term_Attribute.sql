declare @vc_scriptname varchar(100) = 'sd_seed_7924_BaseOilDirectDebit_Term_Attribute'
if exists (Select 1 From MotivaBuildStatistics Where Script = @vc_scriptname)
begin
	print 'Script ' + @vc_scriptname + ' has already been run!'
	return
end


Insert	GeneralConfiguration (GnrlCnfgTblNme, GnrlCnfgQlfr, GnrlCnfgHdrID, GnrlCnfgDtlID, GnrlCnfgMulti)
Select	'Term', 'BaseOilDirectDebit',0,0,'X'
Where	Not Exists	(
					Select	1
					From	GeneralConfiguration
					Where	GnrlCnfgTblNme		= 'Term'
					and		GnrlCnfgQlfr		= 'BaseOilDirectDebit'
					and		GnrlCnfgHdrID		= 0
					and		GnrlCnfgDtlID		= 0
					)

BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts @vc_scriptname
END