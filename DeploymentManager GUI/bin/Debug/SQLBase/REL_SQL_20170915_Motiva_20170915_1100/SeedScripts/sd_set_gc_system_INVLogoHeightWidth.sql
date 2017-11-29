--REPLACE SCRIPTNAME WITH YOUR NAME
Print 'Start Script=sd_set_gc_system_INVLogoHeightWidth.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO


	  Update  GeneralConfiguration
Set     GnrlCnfgMulti = 160
Where   GnrlCnfgTblNme = 'System'
And     GnrlCnfgQlfr = 'InvLogoHeight'

Update  GeneralConfiguration
Set     GnrlCnfgMulti =745
Where   GnrlCnfgTblNme = 'System'
And     GnrlCnfgQlfr = 'InvLogoWidth'

GO