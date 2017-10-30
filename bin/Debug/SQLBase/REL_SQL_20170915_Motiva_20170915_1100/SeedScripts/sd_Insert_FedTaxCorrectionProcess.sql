-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	sd_MTV_Fedtax_correction_process           Copyright 2016 Openlink Financial LLC
-- Overview:    Seeds in the subscription to the "AccountDetail Inserted" message for the custom process to complete spot transfers
-- Created by:	Joseph McClean
-- History:     7/12/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
set Quoted_Identifier off

declare	@i_id	int

------------------------------------------------------------------------------------------------------------------------------
-- Insert Process Item
------------------------------------------------------------------------------------------------------------------------------
if (select count(*) from ProcessItem where PrcssItmNme = 'MTV Hold Erroneous Invoices') = 0
begin
	exec	sp_getkey 'ProcessItem', @i_id OUT
	
	insert into ProcessItem (PrcssItmID, PrcssItmNme, PrcssItmDscrptn, PrcssItmCmmndLne, PrcssItmCmmndTpe, PrcssItmPrmtrDscrptn, PrcssItmStts, ParameterGUIObject)
	Values (@i_id, 
			'MTV Hold Erroneous Invoices', 
			'Places FedTax sales invoices with incorrect due dates in hold for correction by another process.', 
			'MTV_FedTax_HoldErroneousInvoices',
			'S',
			'none',
			'A',
			null)

	exec	sp_insert_processgroup_and_relation @i_id

end

if (select count(*) from ProcessItem where PrcssItmNme = 'MTV Correct BillingTerm On Invoice') = 0
begin
	exec	sp_getkey 'ProcessItem', @i_id OUT
	
	insert into ProcessItem (PrcssItmID, PrcssItmNme, PrcssItmDscrptn, PrcssItmCmmndLne, PrcssItmCmmndTpe, PrcssItmPrmtrDscrptn, PrcssItmStts, ParameterGUIObject)
	Values (@i_id, 
			'MTV Correct BillingTerm On Invoice', 
			'Corrects FedTax invoices by overriding the current billing term with  more appropriate one.',
			'MTV_FedTax_CorrectBillingTermOnInvoices',
			'S',
			'none',
			'A',
			null)

	exec	sp_insert_processgroup_and_relation @i_id

end


if (select count(*) from ProcessItem where PrcssItmNme = 'MTV Place Corrected Invoice In Active Status') = 0
begin
	exec	sp_getkey 'ProcessItem', @i_id OUT
	
	insert into ProcessItem (PrcssItmID, PrcssItmNme, PrcssItmDscrptn, PrcssItmCmmndLne, PrcssItmCmmndTpe, PrcssItmPrmtrDscrptn, PrcssItmStts, ParameterGUIObject)
	Values (@i_id, 
			'MTV Place Corrected Invoice In Active Status', 
			'Places corrected invoices from hold status to active status.',
			'MTV_FedTax_PlaceInvoicesInActiveStatus',
			'S',
			'none',
			'A',
			null)

	exec	sp_insert_processgroup_and_relation @i_id

end


if (select count(*) from ProcessGroup where PrcssGrpNme = 'MTV FedTax Invoice Correction Process') = 0
begin
	exec	sp_getkey 'ProcessGroup', @i_id OUT

	INSERT INTO dbo.ProcessGroup
					(PrcssGrpID
					,PrcssGrpNme
					,PrcssGrpDscrptn
					,PrcssGrpSnglePrcss
					,PrcssGrpStts
					,TotalSeconds
					,RunCount
					,CanRunAsService)

	Values (@i_id, 
			'MTV FedTax Invoice Correction Process', 
			'Corrects FedTax invoices by overriding the current billing term with a the appropriate billing term.',
			'Y',
			'A',
			null,
			null,
			'Y')
end



------------------------------------------------------------------------------------------------------------------------------
-- Create Process Item Grouping
------------------------------------------------------------------------------------------------------------------------------
Declare @i_PrcssGrpID	int
Declare @i_PrcssGrpRltnID int
Declare @i_PrcssItmID int
Declare @i_groupingCount int


select @i_groupingCount =  count(*) from ProcessGroupRelation PGR 
inner join ProcessGroup PG on PG.PrcssGrpID = PGR.PrcssGrpRltnPrcssGrpID where PG.PrcssGrpNme='MTV FedTax Invoice Correction Process'

if @i_groupingCount = 0
Begin 
		select @i_PrcssGrpID = PrcssGrpID from ProcessGroup where ProcessGroup.PrcssGrpNme ='MTV FedTax Invoice Correction Process'

		if (select count(*) from ProcessItem where PrcssItmNme = 'MTV Hold Erroneous Invoices') > 0
		begin

		exec	sp_getkey 'ProcessGroupRelation', @i_PrcssGrpRltnID OUT

		select @i_PrcssItmID = PrcssItmID from ProcessItem where PrcssItmNme ='MTV Hold Erroneous Invoices'
		Insert 	ProcessGroupRelation
			   (PrcssGrpRltnID,
				PrcssGrpRltnPrcssItmID,
				PrcssGrpRltnPrcssGrpID,
				PrcssGrpRltnOrdr)

		Values (@i_PrcssGrpRltnID,
				@i_PrcssItmID,
				@i_PrcssGrpID,
				1)

		end


		If (select count(*) from ProcessItem where PrcssItmNme = 'MTV Correct BillingTerm On Invoice') > 0
		begin

		exec	sp_getkey 'ProcessGroupRelation', @i_PrcssGrpRltnID OUT

		select @i_PrcssItmID = PrcssItmID from ProcessItem where PrcssItmNme ='MTV Correct BillingTerm On Invoice'
		Insert 	ProcessGroupRelation
			   (PrcssGrpRltnID,
				PrcssGrpRltnPrcssItmID,
				PrcssGrpRltnPrcssGrpID,
				PrcssGrpRltnOrdr)

		Values (@i_PrcssGrpRltnID,
				@i_PrcssItmID,
				@i_PrcssGrpID,
				2)

		end


		if (select count(*) from ProcessItem where PrcssItmNme = 'MTV Place Corrected Invoice In Active Status') > 0
		begin

		exec	sp_getkey 'ProcessGroupRelation', @i_PrcssGrpRltnID OUT

			select @i_PrcssItmID = PrcssItmID from ProcessItem where PrcssItmNme ='MTV Place Corrected Invoice In Active Status'
			Insert 	ProcessGroupRelation
				   (PrcssGrpRltnID,
					PrcssGrpRltnPrcssItmID,
					PrcssGrpRltnPrcssGrpID,
					PrcssGrpRltnOrdr)

			Values (@i_PrcssGrpRltnID,
					@i_PrcssItmID,
					@i_PrcssGrpID,
					3)
		end
End

