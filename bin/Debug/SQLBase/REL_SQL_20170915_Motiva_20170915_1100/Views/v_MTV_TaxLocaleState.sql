SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

Print 'Start Script=v_MTV_TaxLocaleState.sql  Domain=MTV  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

If OBJECT_ID('v_MTV_TaxLocaleState') Is NOT Null
  Begin
    DROP VIEW dbo.v_MTV_TaxLocaleState
    PRINT '<<< DROPPED VIEW v_MTV_TaxLocaleState >>>'
  End
GO


Create View [dbo].[v_MTV_TaxLocaleState] AS 
--****************************************************************************************************************
-- Name:        v_MTV_TaxLocaleState												            Copyright 2016 OpenLink
-- Overview:    View of Locale and its related Tax State
-- Created by:  Sanjay S Kumar
-- History:     25 Mar 2016 - First Created
--****************************************************************************************************************
-- Date         Modified By     Issue#      Modification
-- -----------  --------------  ----------  ----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

Select  Locale.LcleID
	  , LocaleCounty = dbo.fn_MTV_GetLocaleStructureFlat(Locale.LcleID,'County')
      , LocaleState = IsNull(dbo.fn_MTV_GetLocaleStructureFlat(Locale.LcleID,'States'),dbo.fn_MTV_GetLocaleStructureFlat(Locale.LcleID,'Province'))
From    Locale

GO

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser and notify user
--------------------------------------------*/

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxLocaleState]') IS NOT NULL
  BEGIN
    GRANT  SELECT  ON dbo.v_MTV_TaxLocaleState TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on View v_MTV_TaxLocaleState >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on View v_MTV_TaxLocaleState >>>'
GO