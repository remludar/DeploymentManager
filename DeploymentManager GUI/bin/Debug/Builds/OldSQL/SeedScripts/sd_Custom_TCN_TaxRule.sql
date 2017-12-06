------------------------------------------------------------------------------------------------------------------------------
--
--  This section will insert the necessary record to register the tax rule in the RightAngle application
--
------------------------------------------------------------------------------------------------------------------------------

If Not Exists ( Select 1
                From    TaxRule
                Where   Description = 'Location Origin IS NOT TCN')
  Begin
    Insert  TaxRule (
            Type
          , Template
          , DataObject
          , Description
          , TemplateArguments
          , ExcludeFromDealEstimate
            )
    Select  'M'
          , 'u_dynamic_gui_tax_rule_sql'
          , 'n_dao_taxrulesetrule_sql'
          , 'Location Origin IS NOT TCN '
          , 'Text=This rule set validates that the Origin location does not have the product attribute TCN populated.||SQL=MTV_Tax_LocationOrigin_NotTCN'
          , 'N'
  End
Else
  Begin
    Update  TaxRule
    Set     Type = 'M'
          , Template = 'u_dynamic_gui_tax_rule_sql'
          , DataObject = 'n_dao_taxrulesetrule_sql'
          , TemplateArguments = 'Text=This rule set validates that the Origin location does not have the product attribute TCN populated.||SQL=MTV_Tax_LocationOrigin_NotTCN'
          , ExcludeFromDealEstimate = 'N'
    Where   Description = 'Location Origin IS NOT TCN'
  End


GO
If Not Exists ( Select 1
                From    TaxRule
                Where   Description = 'Location Origin IS TCN')
  Begin
    Insert  TaxRule (
            Type
          , Template
          , DataObject
          , Description
          , TemplateArguments
          , ExcludeFromDealEstimate
            )
    Select  'M'
          , 'u_dynamic_gui_tax_rule_sql'
          , 'n_dao_taxrulesetrule_sql'
          , 'Location Origin IS TCN '
          , 'Text=This rule set validates that the Origin location does have the product attribute TCN populated.||SQL=MTV_Tax_LocationOrigin_TCN'
          , 'N'
  End
Else
  Begin
    Update  TaxRule
    Set     Type = 'M'
          , Template = 'u_dynamic_gui_tax_rule_sql'
          , DataObject = 'n_dao_taxrulesetrule_sql'
          , TemplateArguments = 'Text=This rule set validates that the Origin location does have the product attribute TCN populated.||SQL=MTV_Tax_LocationOrigin_TCN'
          , ExcludeFromDealEstimate = 'N'
    Where   Description = 'Location Origin IS TCN'
  End

GO
If Not Exists ( Select 1
                From    TaxRule
                Where   Description = 'Location Destination IS NOT TCN')
  Begin
    Insert  TaxRule (
            Type
          , Template
          , DataObject
          , Description
          , TemplateArguments
          , ExcludeFromDealEstimate
            )
    Select  'M'
          , 'u_dynamic_gui_tax_rule_sql'
          , 'n_dao_taxrulesetrule_sql'
          , 'Location Destination IS NOT TCN '
          , 'Text=This rule set validates that the Destination location does not have the product attribute TCN populated.||SQL=MTV_Tax_LocationDestination_NotTCN'
          , 'N'
  End
Else
  Begin
    Update  TaxRule
    Set     Type = 'M'
          , Template = 'u_dynamic_gui_tax_rule_sql'
          , DataObject = 'n_dao_taxrulesetrule_sql'
          , TemplateArguments = 'Text=This rule set validates that the Destination location does not have the product attribute TCN populated.||SQL=MTV_Tax_LocationDestination_NotTCN'
          , ExcludeFromDealEstimate = 'N'
    Where   Description = 'Location Destination IS NOT TCN'
  End


GO
If Not Exists ( Select 1
                From    TaxRule
                Where   Description = 'Location Destination IS TCN')
  Begin
    Insert  TaxRule (
            Type
          , Template
          , DataObject
          , Description
          , TemplateArguments
          , ExcludeFromDealEstimate
            )
    Select  'M'
          , 'u_dynamic_gui_tax_rule_sql'
          , 'n_dao_taxrulesetrule_sql'
          , 'Location Destination IS TCN '
          , 'Text=This rule set validates that the Origin location does have the product attribute TCN populated.||SQL=MTV_Tax_LocationDestination_TCN'
          , 'N'
  End
Else
  Begin
    Update  TaxRule
    Set     Type = 'M'
          , Template = 'u_dynamic_gui_tax_rule_sql'
          , DataObject = 'n_dao_taxrulesetrule_sql'
          , TemplateArguments = 'Text=This rule set validates that the Destination location does have the product attribute TCN populated.||SQL=MTV_Tax_LocationDestination_TCN'
          , ExcludeFromDealEstimate = 'N'
    Where   Description = 'Location Origin IS TCN'
  End


GO