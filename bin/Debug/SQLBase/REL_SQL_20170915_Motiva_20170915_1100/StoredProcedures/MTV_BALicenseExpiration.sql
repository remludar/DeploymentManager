/*
*****************************************************************************************************
USE FIND AND REPLACE ON mtv_search_ba_expiring_licenses WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[mtv_search_ba_expiring_licenses]    Script Date: DATECREATED ******/
PRINT 'Start Script=mtv_search_ba_expiring_licenses.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[mtv_search_ba_expiring_licenses]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[mtv_search_ba_expiring_licenses] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure mtv_search_ba_expiring_licenses >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

--drop procedure mtv_search_ba_expiring_licenses
Alter Procedure dbo.mtv_search_ba_expiring_licenses @ai_NumberOfDays int

As

-----------------------------------------------------------------------------------------------------------------------------
-- Name:	mtv_search_ba_expiring_licenses           Copyright 1997,1998,1999,2000,2001 SolArc
-- Overview:	DocumentFunctionalityHere
-- Arguments:	
-- SPs:
-- Temp Tables:
-- Created by:	Ryan Borgman
-- History:12/19/2016 - First Created
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------
-- execute mtv_search_ba_expiring_licenses 700
------------------------------------------------------------------------------------------------------------------------------

Set NoCount ON

SELECT  BAID,
	BusinessAssociateLicense.LcnseID,
	FromDate,
	ToDate,
	DateDiff(day, GetDate(), ToDate) DaysUntilExpiration,
	LicenseType,
	Comments,
	Miscellaneous
	--select DateDiff(day, GetDate(), ToDate) DaysUntilExpiration, *
FROM 	BusinessAssociateLicense
INNER JOIN	License
ON	BusinessAssociateLicense.LcnseID = License.LcnseID
Where 	DateDiff(day, GetDate(), ToDate) <= @ai_NumberOfDays
AND DateDiff(day, GetDate(), ToDate) >= 0

GO



SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[mtv_search_ba_expiring_licenses]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'mtv_search_ba_expiring_licenses.sql'
	PRINT '<<< ALTERED StoredProcedure mtv_search_ba_expiring_licenses >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure mtv_search_ba_expiring_licenses >>>'
END