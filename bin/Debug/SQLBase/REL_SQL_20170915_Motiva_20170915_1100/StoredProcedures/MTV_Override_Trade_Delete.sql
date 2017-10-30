/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Trade_Delete WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Override_Trade_Delete]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Trade_Delete.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Trade_Delete]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Override_Trade_Delete] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Override_Trade_Delete >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Override_Trade_Delete]
							@i_P_EODEstmtedAccntDtlVleID	Int

AS


-----------------------------------------------------------------------------------------------------------------------------
-- SP:            MTV_Override_Trade_Delete
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

Delete	MTV_RiskOverride_Trade
Where	MTV_RiskOverride_Trade.P_EODEstmtedAccntDtlVleID = @i_P_EODEstmtedAccntDtlVleID


Set NoCount OFF

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Trade_Delete]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Override_Trade_Delete.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Override_Trade_Delete >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Override_Trade_Delete >>>'
	  END