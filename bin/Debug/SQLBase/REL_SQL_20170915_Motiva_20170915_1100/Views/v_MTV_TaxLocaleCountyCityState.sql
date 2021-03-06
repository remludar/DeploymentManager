/*
*****************************************************************************************************
USE FIND AND REPLACE ON FunctionName WITH YOUR Function (NOTE:  Motiva_FN_ is already set
*****************************************************************************************************
*/

/****** Object:  Function [dbo].[v_MTV_TaxLocaleCountyCityState]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxLocaleCountyCityState.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxLocaleCountyCityState]') IS NULL
	  BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[v_MTV_TaxLocaleCountyCityState] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_TaxLocaleCountyCityState >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER   View [dbo].[v_MTV_TaxLocaleCountyCityState] AS 
--****************************************************************************************************************
-- Name:        v_MTV_TaxLocaleCountyCityState									           Copyright 2016 OpenLink
-- Overview:    View of Locale and its related Tax Country, State, County, City
-- Created by:  Sanjay S Kumar
-- History:     1 Mar 2016 - First Created
--****************************************************************************************************************
-- Date         Modified By     Issue#      Modification
-- -----------  --------------  ----------  ----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------

Select  Locale.LcleID
	  , LocaleCounty = dbo.fn_MTV_GetTaxLocaleStructureFlat(Locale.LcleID,'County')
	  , LocaleCity = dbo.fn_MTV_GetTaxLocaleStructureFlat(Locale.LcleID,'City')
	  , LocaleState = dbo.fn_MTV_GetTaxLocaleStructureFlat(Locale.LcleID,'States')
From    Locale (NoLock)

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxLocaleCountyCityState]') IS NOT NULL
	  BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_TaxLocaleCountyCityState.sql'
			PRINT '<<< ALTERED View v_MTV_TaxLocaleCountyCityState >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_TaxLocaleCountyCityState >>>'
	  END