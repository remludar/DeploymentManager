/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Market_Insert WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Override_Market_Insert]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Market_Insert.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Market_Insert]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Override_Market_Insert] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Override_Market_Insert >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Override_Market_Insert]
							@sdt_COB			SmallDateTime,
							@i_P_EODEstmtedAccntDtlID	Int,
							@i_UOMID			Int,
							@i_CrrncyID			Int,
							@i_UserID			Int,
							@dec_MarketValue		Decimal(19,6),
							@vc_Comments			Varchar(2000)=Null
AS



-----------------------------------------------------------------------------------------------------------------------------
-- SP:            MTV_Override_Market_Insert
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

Execute dbo.MTV_Override_Market_Delete @sdt_COB = @sdt_COB, @i_P_EODEstmtedAccntDtlID = @i_P_EODEstmtedAccntDtlID

If @@Error <> 0 Return

Insert	MTV_RiskOverride
	(
	EndOfDay,
	P_EODEstmtedAccntDtlID,
	MarketUOM,
	MarketValue,
	MarketCrrncyID,
	UserID,
	CreationDate,
	Comments
	)
Values	(
	@sdt_COB,
	@i_P_EODEstmtedAccntDtlID,
	@i_UOMID,
	@dec_MarketValue,
	@i_CrrncyID,
	@i_UserID,
	GetDate(),
	@vc_Comments
	)

Set NoCount OFF


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Market_Insert]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Override_Market_Insert.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Override_Market_Insert >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Override_Market_Insert >>>'
	  END