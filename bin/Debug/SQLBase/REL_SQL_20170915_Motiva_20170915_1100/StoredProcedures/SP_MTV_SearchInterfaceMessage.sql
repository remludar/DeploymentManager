/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_SearchInterfaceMessage WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_SearchInterfaceMessage]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_SearchInterfaceMessage.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchInterfaceMessage]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_SearchInterfaceMessage] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_SearchInterfaceMessage >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_SearchInterfaceMessage]
		@InternalMessageID INT = NULL
		,@Router VARCHAR(50) = NULL
		,@CreatedFromDate SMALLDATETIME = '1/1/1900'
		,@CreatedToDate SMALLDATETIME = '12/31/2078'
		,@Debug CHAR(1) = 'N'
AS

-- =============================================
-- Author:        rlb
-- Create date:	  6/23/2016
-- Description:   Used against Nexus Framework to retrieve message status
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------
--execute MTV_SearchInterfaceMessage @CreatedFromDate = '6/23/2016 00:00:00', @CreatedToDate = '6/23/2016 23:59:00'
DECLARE	@DYN_SELECT	VARCHAR(MAX)
		,@DYN_FROM VARCHAR(MAX)
		,@DYN_WHERE VARCHAR(MAX)

SELECT	@DYN_SELECT = 
'select	NexusRouterType.RouterID
		,NexusRouterType.RouterName
		,NexusRouterType.WebAddress
		,CASE WHEN PostMethod = ''W'' THEN ''WebService'' ELSE ''File'' END AS PostMethod
		,CASE WHEN PostMethod = ''F'' THEN NexusRouterType.FilePath ELSE NULL END AS FilePath
		,NexusRouterType.FileExtension
		,NexusMessage.MessageID AS InternalMessageID
		,CASE WHEN NexusStatus.IsInbound = 0 THEN NexusMessage.InterfaceID ELSE NULL END AS ToMiddleWareMessageID
		,CASE WHEN NexusStatus.IsInbound = 1 THEN NexusMessage.InterfaceID ELSE NULL END AS FromMiddleWareMessageID
		,CASE WHEN NexusStatus.IsInbound = 0 THEN ''Outbound'' ELSE ''Inbound'' END AS Direction
		,NexusStatus.Status
		,CAST(NexusStatus.Message AS VARCHAR(8000)) StatusMessage
		,NexusStatus.ProcessStatus
		,CAST(NexusStatus.ProcessMessage AS VARCHAR(5000)) ProcessMessage
		,NexusStatus.CreateDate
		,NexusStatus.StatusID
		,NexusStatus.ProcessTryCount
		'

SELECT	@DYN_FROM = 
'FROM dbo.NexusRouterType (NOLOCK)
INNER JOIN	dbo.NexusMessage (NOLOCK)
ON	NexusRouterType.RouterID = NexusMessage.RouterID
INNER JOIN dbo.NexusStatus (NOLOCK)
ON	NexusMessage.MessageID = NexusStatus.MessageID
'
IF @Router IS NULL OR LEN(@Router) = 0
	SELECT @DYN_WHERE = 'WHERE 1 = 1 '
ELSE
	SELECT @DYN_WHERE = 'WHERE NexusRouterType.RouterName LIKE ''%'  + @Router  + '%'''

IF (@InternalMessageID IS NOT NULL)
	SELECT	@DYN_WHERE = @DYN_WHERE + ' AND NexusMessage.MessageID = ' + CAST(@InternalMessageID AS VARCHAR)
	

SELECT	@DYN_WHERE = @DYN_WHERE + ' AND NexusStatus.CreateDate BETWEEN ' + '''' + CONVERT(VARCHAR,@CreatedFromDate) + '''' +  + ' AND ' + '''' + CONVERT(VARCHAR,@CreatedToDate) +''''

IF @Debug = 'Y'
BEGIN
	SELECT	@DYN_SELECT	+ @DYN_FROM + @DYN_WHERE
END
ELSE
	EXEC(@DYN_SELECT	+ @DYN_FROM + @DYN_WHERE)


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_SearchInterfaceMessage]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_SearchInterfaceMessage.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_SearchInterfaceMessage >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_SearchInterfaceMessage >>>'
	  END