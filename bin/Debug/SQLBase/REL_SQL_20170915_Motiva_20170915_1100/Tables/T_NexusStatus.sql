/*
*****************************************************************************************************
--USE FIND AND REPLACE ON NexusStatus WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[NexusStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_NexusStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[NexusStatus]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[NexusStatus]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[NexusStatus]
    PRINT '<<< DROPPED TABLE [NexusStatus >>>'
END

/****** Object:  Table [dbo].[NexusStatus]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NexusStatus](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[MessageID] [int] NOT NULL,
	[Status] char(1) NOT NULL,
	[Message] [varchar](max) NOT NULL,
	[IsInbound] bit NOT NULL,
	[CreateUserID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[ProcessStatus] char(1) NOT NULL,
	[ProcessMessage] [varchar](max) NOT NULL,
	[ProcessTryCount] [int] NOT NULL,
 CONSTRAINT [PK_NexusStatus] PRIMARY KEY CLUSTERED
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IX_NexusStatus] ON [dbo].[NexusStatus]
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_NexusStatusStatus]    Script Date: 5/26/2016 3:48:35 PM ******/
CREATE NONCLUSTERED INDEX [IX_NexusStatusStatus] ON [dbo].[NexusStatus]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[NexusStatus]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_NexusStatus.sql'
    PRINT '<<< CREATED TABLE NexusStatus >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE NexusStatus >>>'
GO


