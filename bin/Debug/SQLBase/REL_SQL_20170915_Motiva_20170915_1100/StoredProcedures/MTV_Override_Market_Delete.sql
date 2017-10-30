/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Market_Delete WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Override_Market_Delete]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Market_Delete.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Market_Delete]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Override_Market_Delete] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Override_Market_Delete >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Override_Market_Delete]
							@sdt_COB			SmallDateTime,
							@i_P_EODEstmtedAccntDtlID	Int
AS


-----------------------------------------------------------------------------------------------------------------------------
-- SP:            MTV_Override_Market_Delete
-- Arguments:	 
-- Tables:         Tables
-- Indexes: LIST ANY INDEXES used in OPTIMIZER hints
-- Stored Procs:   StoredProcedures
-- Dynamic Tables: DynamicTables
-- Overview:       DocumentFunctionalityHere
--
-- Created by:     Matt Perry
-- Issues
-- ------------- ------------------ -------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
Set NoCount ON
Set Quoted_Identifier off

Delete	MTV_RiskOverride
Where	MTV_RiskOverride.EndOfDay = @sdt_COB
And		MTV_RiskOverride.P_EODEstmtedAccntDtlID = @i_P_EODEstmtedAccntDtlID


Set NoCount OFF


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Market_Delete]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Override_Market_Delete.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Override_Market_Delete >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Override_Market_Delete >>>'
	  END