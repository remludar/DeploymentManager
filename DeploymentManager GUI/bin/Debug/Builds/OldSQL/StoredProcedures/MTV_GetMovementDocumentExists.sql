/****** Object:  StoredProcedure [dbo].[MTV_GetMovementDocExists]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_GetMovementDocExists.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetMovementDocExists]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_GetMovementDocExists] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_GetMovementDocExists >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_GetMovementDocExists]   @MovementDocumentLineItemID INT,@DlHdrID INT,@XctnHdrID INT
AS
SET NOCOUNT ON
-- =============================================
-- Author:        Alan Oldfield
-- Create date:	  5/17/2017
-- Description:   Determines if the current transaction is the minimum transaction for a movement bol so that the fee can be added for a single movement.
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  --------------------------------------
-----------------------------------------------------------------------------
DECLARE @MvtDcmntID INT,@MinXHdrID INT

SELECT @MvtDcmntID = MvtHdrMvtDcmntID FROM MovementHeader WITH (NOLOCK) WHERE MvtHdrTyp IN ('D','R') AND MvtHdrID = @MovementDocumentLineItemID

IF (@MvtDcmntID IS NULL)
BEGIN
	SELECT 0
	RETURN
END

SELECT @MinXHdrID = MIN(th.XHdrID)
FROM dbo.MovementHeader mh WITH (NOLOCK)
INNER JOIN dbo.TransactionHeader th WITH (NOLOCK)
ON th.XHdrMvtDcmntID = mh.MvtHdrMvtDcmntID
AND mh.MvtHdrMvtDcmntID = @MvtDcmntID
AND mh.MvtHdrTyp IN ('D','R')
AND th.XHdrStat = 'C'
AND mh.MvtHdrStat = 'A'
INNER JOIN dbo.DealDetail dd WITH (NOLOCK)
ON dd.DealDetailID = th.DealDetailID
AND dd.DlDtlDlHdrID = @DlHdrID

SELECT CASE ISNULL(@MinXHdrID,-1) WHEN @XctnHdrID THEN 1 ELSE 0 END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetMovementDocExists]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_GetMovementDocExists.sql'
	PRINT '<<< ALTERED StoredProcedure MTV_GetMovementDocExists >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_GetMovementDocExists >>>'
END