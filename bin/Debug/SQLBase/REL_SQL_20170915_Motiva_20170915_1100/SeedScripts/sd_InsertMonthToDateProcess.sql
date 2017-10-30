---------------------------------------------------------------------------------------------
---- Declaring Processing Variables
---------------------------------------------------------------------------------------------
--DECLARE       @AcctPrdId    INT

---------------------------------------------------------------------------------------------
---- SET Processing Variables
---------------------------------------------------------------------------------------------
--SELECT @AcctPrdId = LTRIM(SUBSTRING(@vc255_arg,CHARINDEX('=', @vc255_arg, 0)+1
--                                        ,CHARINDEX(',', @vc255_arg, 0) - CHARINDEX('=', @vc255_arg, 0)-1))


-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:  sd_InsertMonthToDateProcess           Copyright 2003 SolArc
-- Overview:    Seeds in the subscription to the "AccountDetail Inserted" message for the custom process to kick off the Tax Transaction Staging Process
-- Created by:       Sanjay Kumar
-- History:     08/25/2016 - First Created
--
--     Date Modified        Modified By   Issue# Modification
--     12/10/2016           Sanjay Kumar  Remove and re-add the Month End Motiva Task subscription.
--     --------------- --------------    ------ -------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
set Quoted_Identifier off

declare       @i_id  int

-- First time setup of the Process Item group
if (select count(*) from ProcessItem where PrcssItmNme = 'MTV Start Month To Date Task') = 0
begin
	   exec   sp_getkey 'ProcessItem', @i_id OUT
	   
	   insert into ProcessItem (PrcssItmID, PrcssItmNme, PrcssItmDscrptn, PrcssItmCmmndLne, PrcssItmCmmndTpe, PrcssItmPrmtrDscrptn, PrcssItmStts, ParameterGUIObject)
	   Values (@i_id, 
					 'MTV Start Month To Date Task', 
					 'This process should only run as a part of the Month End Close process.', 
					 'MTV_mtd_tax_transactions_stage',
					 'S',
					 '',
					 'A',
					 null)

	   exec   sp_insert_processgroup_and_relation @i_id
	   print 'Insert Process Item and Group and Relation'

	   --insert into Subscription
	   --select (select PrcssGrpID from ProcessGroup where PrcssGrpNme = 'MTV Start Month To Date Task'),
	   --              (select SbSystmID from SubSystem where Name = 'Accounting'),
	   --              (Select MssgeID from Message where Name = 'AccountingPeriod Closed'),
	   --              'Primary',
	   --              'N',
	   --              'A'    
end


-- Un-register the subscription to the 'AccountingPeriod Closed' message.
if (select count(*) from Subscription where MssgeID = (Select MssgeID from Message where Name = 'AccountingPeriod Closed')
and PrcssGrpID = (select PrcssGrpID from ProcessGroup where PrcssGrpNme = 'MTV Start Month To Date Task')) != 0
begin
		delete from Subscription where MssgeID = (Select MssgeID from Message where Name = 'AccountingPeriod Closed') 
		and PrcssGrpID = (select PrcssGrpID from ProcessGroup where PrcssGrpNme = 'MTV Start Month To Date Task')

		Print 'Un-register the subscription to the AccountingPeriod Closed message.'
end

-- Insert the 'AccountingPeriod Closed Motiva' Message  into the Message table
if (select count(*) from Message where Name = 'AccountingPeriod Closed Motiva') = 0
begin
	insert into Message 
	select 'AccountingPeriod Closed Motiva', null, null, null

	Print 'Insert the AccountingPeriod Closed Motiva Message  into the Message table'
end

-- Register the MTV Start Month To Date Task to the 'AccountingPeriod Closed Motiva' message
if (select count(*) from Subscription where MssgeID = (Select MssgeID from Message where Name = 'AccountingPeriod Closed Motiva')) = 0
begin
	insert into Subscription
	select (select PrcssGrpID from ProcessGroup where PrcssGrpNme = 'MTV Start Month To Date Task'),
		   (select SbSystmID from SubSystem where Name = 'Accounting'),
		   (Select MssgeID from Message where Name = 'AccountingPeriod Closed Motiva'),
		   'Primary', 'N', 'A' 

	Print 'Register the MTV Start Month To Date Task to the AccountingPeriod Closed Motiva message'
end
