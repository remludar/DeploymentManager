PRINT 'Start Script=SP_MTVNonDuplicateBOLsForMovementLifeCycle.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVNonDuplicateBOLsForMovementLifeCycle]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVNonDuplicateBOLsForMovementLifeCycle] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVNonDuplicateBOLsForMovementLifeCycle >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


ALTER PROCEDURE [dbo].[MTVNonDuplicateBOLsForMovementLifeCycle] (@ExportDate DATETIME = NULL)
AS
-- =============================================
-- Author:        Sanjay Kumar
-- Create date:	  04/18/2017
-- Description:   This SP retrieves the last complete loaded BOL with the same 
--                MvtHdrMvtDcmntID & MvtHdrID
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

SELECT	lc.InvoiceNumber,
		lc.BOLNumber TMSBolNumber, 
		lc.TMSTerminal TerminalNumber,
		CAST(InvoiceCreationDate AS DATE) InvoiceCreationDate,
		CAST(InvoiceCreationDate AS TIME) InvoiceCreationTime
FROM dbo.MTVMovementLifeCycle lc WITH (NOLOCK)
INNER JOIN (
	SELECT RATerminalLcleID,BOLNumber,MAX(MESID) MESID
	FROM dbo.MTVMovementLifeCycle WITH (NOLOCK)
	WHERE TMSIntefaceStatus != 'I'
	AND TMSLoadStartDateTime > ISNULL(@ExportDate,'3/1/2017')
	GROUP BY RATerminalLcleID,BOLNumber
) l
ON lc.MESID = l.MESID

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON
GO

IF  OBJECT_ID(N'[dbo].[MTVNonDuplicateBOLsForMovementLifeCycle]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVNonDuplicateBOLsForMovementLifeCycle.sql'
	PRINT '<<< ALTERED StoredProcedure MTVNonDuplicateBOLsForMovementLifeCycle >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVNonDuplicateBOLsForMovementLifeCycle >>>'
END