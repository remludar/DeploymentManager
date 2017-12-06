/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_Override_Trade_Insert WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_Override_Trade_Insert]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Override_Trade_Insert.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Override_Trade_Insert]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Override_Trade_Insert] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Override_Trade_Insert >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_Override_Trade_Insert]
							@i_P_EODEstmtedAccntDtlVleID	Int,
							@i_P_EODSnpShtID_From			Int,
							@i_UOMID						Int,
							@i_CrrncyID						Int,
							@i_UserID						Int,
							@dec_TradeValue					Decimal(19,6),
							@vc_Comments					Varchar(2000)=Null

AS

-----------------------------------------------------------------------------------------------------------------------------
-- SP:            MTV_Override_Trade_Insert
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

Execute dbo.MTV_Override_Trade_Delete @i_P_EODEstmtedAccntDtlVleID = @i_P_EODEstmtedAccntDtlVleID

If @@Error <> 0 Return

Insert	MTV_RiskOverride_Trade
	(
	P_EODEstmtedAccntDtlVleID,
	P_EODSnpShtID_From,
	TradeUOM,
	TradeValue,
	TradeCrrncyID,
	UserID,
	CreationDate,
	Comments
	)
Values	(
	@i_P_EODEstmtedAccntDtlVleID,
	@i_P_EODSnpShtID_From,
	@i_UOMID,
	@dec_TradeValue,
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

IF  OBJECT_ID(N'[dbo].[MTV_Override_Trade_Insert]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Override_Trade_Insert.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_Override_Trade_Insert >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Override_Trade_Insert >>>'
	  END