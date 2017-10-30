/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_CurrentNexusStatus WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_CurrentNexusStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_CurrentNexusStatus.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[CurrentNexusStatus]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[CurrentNexusStatus] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_CurrentNexusStatus >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[CurrentNexusStatus]
AS 
	SELECT	s.StatusID,s.MessageID,nm.InterfaceID,
			CASE s.Status WHEN 'E' THEN s.Status ELSE s.ProcessStatus END CurrentStatus,
			CASE s.Status WHEN 'E' THEN s.Message ELSE s.ProcessMessage END CurrentMessage,s.Status,
			s.Message,s.IsInbound,s.CreateUserID,s.CreateDate,s.ProcessStatus,s.ProcessMessage,
			s.ProcessTryCount,r.RouterName,r.RouterDescription,r.WebAddress,r.CallBackClass,
			CASE r.PostMethod WHEN 'F' THEN 'File' WHEN 'W' THEN 'Web Service' ELSE 'UnKnown' END PostMethod,
			r.FilePath,r.ArchiveFilePath,r.FileExtension
	FROM dbo.NexusStatus s (NOLOCK)
	INNER JOIN dbo.NexusMessage nm (NOLOCK)
	ON nm.MessageID = s.MessageID
	INNER JOIN dbo.NexusRouterType r (NOLOCK)
	ON nm.RouterID = r.RouterID
	WHERE StatusID = (SELECT MAX(StatusID) FROM dbo.NexusStatus (NOLOCK) WHERE MessageID = s.MessageID)
GO

GRANT SELECT ON [dbo].[CurrentNexusStatus] TO [RightAngleAccess] AS [dbo]
GO

GRANT SELECT ON [dbo].[CurrentNexusStatus] TO [sysuser] AS [dbo]
GO

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[CurrentNexusStatus]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_CurrentNexusStatus.sql'
			PRINT '<<< ALTERED View v_CurrentNexusStatus >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_CurrentNexusStatus >>>'
	  END



