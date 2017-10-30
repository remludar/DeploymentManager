/****** Object:  StoredProcedure [dbo].[MTVPurgeT4Tables]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVPurgeT4Tables.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + 
' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVPurgeT4Tables]') IS NULL
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVPurgeT4Tables] AS SELECT 1'
	PRINT '<<< CREATED StoredProcedure MTVPurgeT4Tables >>>'
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVPurgeT4Tables]
AS

-- =============================================
-- Author:        Matthew Vorm
-- Create date:	  05/02/2017
-- Description:   Returns the LineLoss attribute from PlnndTransfer if IsEstimate, otherwise from TransactionHeader.
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
--  
-- ----------------------------------------------------------------------------------------------------------

BEGIN

	delete from MTVT4NominationHeaderStaging
	where T4HdrID in (select T4HdrID FROM MTVT4NominationHeaderStaging 
		WHERE ImportDate <= DATEADD(dd, -60, GETDATE())
		AND (RecordStatus = 'I'
		OR (RecordStatus = 'C'
		AND (PipelineNominationVersionNumber is null Or PipelineNominationVersionNumber <=  
		(select (isnull(Max(PipelineNominationVersionNumber),0) - 1) From dbo.MTVT4NominationHeaderStaging SHdr (NOLOCK)
		where T4NominationNumber = SHdr.T4NominationNumber)))))

	delete from MTVT4LineItemsStaging
	where T4HdrID in (select T4HdrID FROM MTVT4NominationHeaderStaging 
		WHERE ImportDate <= DATEADD(dd, -60, GETDATE())
		AND (RecordStatus = 'I'
		OR (RecordStatus = 'C'
		AND (PipelineNominationVersionNumber is null Or PipelineNominationVersionNumber <=  
		(select (isnull(Max(PipelineNominationVersionNumber),0) - 1) From dbo.MTVT4NominationHeaderStaging SHdr (NOLOCK)
		where T4NominationNumber = SHdr.T4NominationNumber)))))

	DELETE MTVT4LineItemsStaging
	FROM MTVT4NominationHeaderStaging Hdr
	INNER JOIN MTVT4LineItemsStaging LI
	ON Hdr.T4HdrID = LI.T4HdrID
	WHERE Hdr.ImportDate <= DATEADD(dd, -60, GETDATE())
	AND LI.RecordStatus = 'I'

END

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVPurgeT4Tables]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_MTVPurgeT4Tables.sql'
	PRINT '<<< ALTERED StoredProcedure MTVPurgeT4Tables >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVPurgeT4Tables >>>'
END
 
PRINT 'Start Script=MTVPurgeT4Tables.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVPurgeT4Tables]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVPurgeT4Tables TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVPurgeT4Tables >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVPurgeT4Tables >>>'
GO
