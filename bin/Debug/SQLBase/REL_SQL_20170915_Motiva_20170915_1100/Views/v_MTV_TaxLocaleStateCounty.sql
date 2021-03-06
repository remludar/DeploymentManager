/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_TaxLocaleStateCounty WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTV_TaxLocaleStateCounty]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxLocaleStateCounty.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxLocaleStateCounty]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_TaxLocaleStateCounty] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_TaxLocaleStateCounty >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER  View [dbo].[v_MTV_TaxLocaleStateCounty] AS 
--****************************************************************************************************************
-- Name:        v_MTV_TaxLocaleStateCounty												            Copyright 2016 OpenLink
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxLocaleStateCounty]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_TaxLocaleStateCounty.sql'
			PRINT '<<< ALTERED View v_MTV_TaxLocaleStateCounty >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_TaxLocaleStateCounty >>>'
	  END