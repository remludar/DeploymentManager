/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxRule_MOTValidForFreightRate WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_TaxRule_MOTValidForFreightRate]    Script Date: DATECREATED ******/
PRINT 'Start Script=sd_TaxRule_MOTValidForFreightRate.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

INSERT	GeneralConfiguration
SELECT	'DynamicListBox'
		,'IncludeTruckFreight'
		,0
		,0
		,'y/n'
WHERE NOT EXISTS (SELECT 1 FROM GeneralConfiguration WHERE GnrlCnfgTblNme = 'DynamicListBox' AND GnrlCnfgQlfr = 'IncludeTruckFreight' AND GnrlCnfgHdrID =0)

GO

Insert	TaxRule
		(
		[Type],
		Template,
		DataObject,
		[Description],
		TemplateArguments,
		ExcludeFromDealEstimate
		)
Select	'M',
		'u_dynamic_gui_tax_rule_sql',
		'n_dao_taxrulesetrule_sql',
		'MOT valid for Freight Rate',
		'Text=This rule passes if the MOT is valid for Freight Rate based of DynamicListBox Attribute:IncludeTruckFreight.||SQL=MTV_TaxRule_MOTValidForFreightRate',
		'Y'
Where	Not Exists
		(
		Select	1
		From	TaxRule
		Where	TaxRule.TemplateArguments like '%MTV_TaxRule_MOTValidForFreightRate%'
		)
go
