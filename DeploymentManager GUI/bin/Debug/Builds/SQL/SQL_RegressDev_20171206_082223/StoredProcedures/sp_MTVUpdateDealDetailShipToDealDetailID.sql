/****** Object:  StoredProcedure [dbo].[MTVUpdateDealDetailShipToDealDetailID]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVUpdateDealDetailShipToDealDetailID.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVUpdateDealDetailShipToDealDetailID]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVUpdateDealDetailShipToDealDetailID] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTVUpdateDealDetailShipToDealDetailID >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVUpdateDealDetailShipToDealDetailID]
	@DlHdrID INT
AS

-- =============================================
-- Author:        Matthew Vorm
-- Create date:	  3/29/2016
-- Description:   Updates the DealDetailID on DealDetail Saved event using the DlHdrID, DlDtlID, SoldToShipToID
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--  
-- ----------------------------------------------------------------------------------------------------------

BEGIN
	UPDATE ddst SET ddst.DealDetailID = dd.DealDetailID
	FROM dbo.MTVDealDetailShipTo ddst (NOLOCK)
	INNER JOIN dbo.DealDetail dd (NOLOCK) 
		ON ddst.DlDtlID = dd.DlDtlID and ddst.DlHdrID = dd.DlDtlDlHdrID
	WHERE ddst.DlHdrID = @DlHdrID
END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVUpdateDealDetailShipToDealDetailID]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVUpdateDealDetailShipToDealDetailID.sql'
	PRINT '<<< ALTERED StoredProcedure MTVUpdateDealDetailShipToDealDetailID >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVUpdateDealDetailShipToDealDetailID >>>'
END
 
