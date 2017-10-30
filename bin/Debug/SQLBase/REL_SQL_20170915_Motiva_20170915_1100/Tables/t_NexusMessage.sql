/*
*****************************************************************************************************
--USE FIND AND REPLACE ON NexusMessage WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[NexusMessage]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_NexusMessage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[NexusMessage]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[NexusMessage]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[NexusMessage]
    PRINT '<<< DROPPED TABLE [NexusMessage >>>'
END

/****** Object:  Table [dbo].[NexusMessage]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NexusMessage](
	[MessageID] [int] NOT NULL,
	[InterfaceID] [int] NOT NULL,
	[RouterID] [int] NOT NULL,
	[Message] [varchar](MAX) NOT NULL,
 CONSTRAINT [PK_NexusMessage] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  Index [IX_NexusMessage]    Script Date: 5/26/2016 11:18:52 AM ******/
CREATE NONCLUSTERED INDEX [IX_NexusMessage] ON [dbo].[NexusMessage]
(
	[InterfaceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_NexusMessageUniqe] ON [dbo].[NexusMessage]
(
	[InterfaceID] ASC,
	[RouterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[NexusMessage]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_NexusMessage.sql'
    PRINT '<<< CREATED TABLE NexusMessage >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE NexusMessage >>>'
GO