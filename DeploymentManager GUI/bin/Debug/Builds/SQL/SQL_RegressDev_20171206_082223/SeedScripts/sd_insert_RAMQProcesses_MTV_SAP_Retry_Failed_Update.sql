-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	sd_insert_RAMQProcesses_MTV_SAP_Retry_Failed_Update           Copyright 2003 SolArc
-- Overview:    Seeds in Process Item to retry a failed SAP status update
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
if (select count(1) from ProcessItem where PrcssItmNme = 'MTV SAP Retry Failed Update') = 0
begin
	exec	sp_getkey 'ProcessItem', @i_id OUT
	
	insert into ProcessItem (PrcssItmID, PrcssItmNme, PrcssItmDscrptn, PrcssItmCmmndLne, PrcssItmCmmndTpe, PrcssItmPrmtrDscrptn, PrcssItmStts, ParameterGUIObject)
	Values (@i_id, 
			'MTV SAP Retry Failed Update', 
			'This process retries a failed SAP update message.  Do not schedule this process directly -- it should only be created from a failed update.', 
			'MTV_SAP_MsgHandler',
			'S',
			'',
			'A',
			null)

	exec	sp_insert_processgroup_and_relation @i_id

end
