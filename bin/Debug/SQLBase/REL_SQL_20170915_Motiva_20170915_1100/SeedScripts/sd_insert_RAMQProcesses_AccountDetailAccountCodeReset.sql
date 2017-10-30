/****** Object:  StoredProcedure [dbo].[MTV_reset_last_accountcoded_accountdetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_reset_last_accountcoded_accountdetail.sql.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO
-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	sd_insert_RAMQProcesses_AccountDetailAccountCodeReset           Copyright 2003 SolArc
-- Overview:    Sees in Process Item to reset Accountdetail so it can re-accountcode.
-- Created by:	Ryan Borgman
-- History:     07/10/2008 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
set Quoted_Identifier off

declare	@i_id	int

------------------------------------------------------------------------------------------------------------------------------
-- First for the TransactionHeader Inserted message
------------------------------------------------------------------------------------------------------------------------------
if (select count(*) from ProcessItem where PrcssItmNme = 'MTV AccountDetail Reset') = 0
begin
	exec	sp_getkey 'ProcessItem', @i_id OUT
	
	insert into ProcessItem (PrcssItmID, PrcssItmNme, PrcssItmDscrptn, PrcssItmCmmndLne, PrcssItmCmmndTpe, PrcssItmPrmtrDscrptn, PrcssItmStts, ParameterGUIObject)
	Values (@i_id, 
			'MTV AccountDetail Reset', 
			'This process item resets the last account detail ID that has not been accountcoded. The account code process will then pick up the account detail and account code them.', 
			'MTV_reset_last_accountcoded_accountdetail',
			'S',
			'',
			'A',
			null)

	exec	sp_insert_processgroup_and_relation @i_id

end
