SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


Print 'Start Script=v_MTV_TaxLocale.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

If OBJECT_ID('v_MTV_TaxLocale') Is NOT Null
  Begin
    DROP VIEW dbo.v_MTV_TaxLocale
    PRINT '<<< DROPPED VIEW v_MTV_TaxLocale >>>'
  End
GO



Create View [dbo].[v_MTV_TaxLocale] AS 
--****************************************************************************************************************
-- Name:        v_MTV_TaxLocale												            Copyright 2016 OpenLink
-- Overview:    View of Locale and its related Tax Country, State, County, City
-- Created by:  Sanjay S Kumar
-- History:     1 Mar 2016 - First Created
--****************************************************************************************************************
-- Date         Modified By     Issue#      Modification
-- -----------  --------------  ----------  ----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

--  select * from v_MPC_LocaleState

Select  Locale.LcleID
	  , LocaleCounty = dbo.fn_MTV_GetLocaleStructureFlat(Locale.LcleID,'County')
	  , LocaleCity = dbo.fn_MTV_GetLocaleStructureFlat(Locale.LcleID,'City')
      , LocaleState = IsNull(dbo.fn_MTV_GetLocaleStructureFlat(Locale.LcleID,'States'),dbo.fn_MTV_GetLocaleStructureFlat(Locale.LcleID,'Province'))
	  , LocaleCountry = dbo.fn_MTV_GetLocaleStructureFlat(Locale.LcleID,'Country')
From    Locale


GO


/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser and notify user
--------------------------------------------*/
If OBJECT_ID('v_MTV_TaxLocale') Is NOT Null
  BEGIN
    PRINT '<<< CREATED VIEW v_MTV_TaxLocale >>>'
    GRANT  SELECT  ON dbo.v_MTV_TaxLocale TO sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating VIEW v_MTV_TaxLocale>>>'
GO


--End of Script: v_MTV_TaxLocale.sql