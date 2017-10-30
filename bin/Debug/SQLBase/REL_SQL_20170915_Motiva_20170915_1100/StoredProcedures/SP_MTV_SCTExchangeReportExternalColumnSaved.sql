/*
*****************************************************************************************************
USE FIND AND REPLACE ON T4GetPlannedTransfers WITH YOUR view (NOTE:  MTV_sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_SCTExchangeReportExternalColumnSaved]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SCTExchangeReportExternalColumnSaved.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SCTExchangeReportExternalColumnSaved]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SCTExchangeReportExternalColumnSaved] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SCTExchangeReportExternalColumnSaved >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SCTExchangeReportExternalColumnSaved] 
		@DlDtlDlHdrID int
		,@DlDtlID	int
		,@ChemicalID	int
		,@InventoryDT 	DateTime
		,@PlnndTrnsfrID int = Null
		,@Planned  float = Null
		,@BulkPayBack float = null
AS
-- =============================================
-- Author:        Isaac Jacob
-- Create date:	  12/21/2015
-- Description:   To update the Planned Movement and Planned Movement Batch ID
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

--Declare @DlDtlDlHdrID int
--Declare @DlDtlID int
--Declare @PlnndTrnsfrID int
--Declare @Planned varchar(200)
--Declare @BulkPayBack varchar(200)

IF Exists (Select *  from MTVSCTExchangeReportExternalColumn MSCTEREC					 
						where MSCTEREC.DlDtlDlHdrID = @DlDtlDlHdrID
						and MSCTEREC.DlDtlID = @DlDtlID
						and MSCTEREC.ChemicalID = @ChemicalID
						and MSCTEREC.InventoryDT= @InventoryDT )
BEGIN
	
		UPDATE	MTVSCTExchangeReportExternalColumn
		SET		Planned = @Planned
				,BulkPayBack = @BulkPayBack
				,PlnndTrnsfrID  = @PlnndTrnsfrID 
		WHERE	DlDtlDlHdrID= @DlDtlDlHdrID
		AND		DlDtlID	= @DlDtlID
		AND		ChemicalID	= @ChemicalID
		AND		InventoryDT	= @InventoryDT
END
ELSE
BEGIN
		INSERT INTO [dbo].[MTVSCTExchangeReportExternalColumn]
			(DlDtlDlHdrID
			,DlDtlID
			,ChemicalID
			,InventoryDT
			,PlnndTrnsfrID
			,Planned
			,BulkPayBack)
		VALUES
			(@DlDtlDlHdrID
			,@DlDtlID
			,@ChemicalID
			,@InventoryDT
			,@PlnndTrnsfrID
			,@Planned
			,@BulkPayBack)
END


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SCTExchangeReportExternalColumnSaved]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTV_SCTExchangeReportExternalColumnSaved.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SCTExchangeReportExternalColumnSaved >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SCTExchangeReportExternalColumnSaved >>>'
	  END


	 
	 