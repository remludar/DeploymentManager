/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxRule_CarrierEqualsTaxingAuthority WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_TaxRule_CarrierEqualsTaxingAuthority]    Script Date: DATECREATED ******/
PRINT 'Start Script=sd_TaxRule_CarrierEqualsTaxingAuthority.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
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
		'Carrier equals Taxing Authority',
		'Text=This rule passes if the carrier on the movement equals the taxing authority BA on the Tax record.||SQL=MTV_TaxRule_CarrierEqualsTaxingAuthority',
		'Y'
Where	Not Exists
		(
		Select	1
		From	TaxRule
		Where	TaxRule.TemplateArguments like '%MTV_TaxRule_CarrierEqualsTaxingAuthority%'
		)
go
