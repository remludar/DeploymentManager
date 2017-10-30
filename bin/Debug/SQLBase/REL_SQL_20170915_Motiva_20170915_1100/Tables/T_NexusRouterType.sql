/*
*****************************************************************************************************
--USE FIND AND REPLACE ON NexusRouterType WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[NexusRouterType]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_NexusRouterType.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[NexusRouterType]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[NexusRouterType]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[NexusRouterType]
    PRINT '<<< DROPPED TABLE [NexusRouterType >>>'
END

/****** Object:  Table [dbo].[NexusRouterType]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[NexusRouterType](
	[RouterID] [int] IDENTITY(1,1) NOT NULL,
	[RouterName] [varchar](50) NOT NULL,
	[RouterDescription] [varchar](200) NOT NULL,
	[WebAddress] [varchar](max) NULL,
	[CallBackClass] [varchar](max) NULL,
	[PostMethod] [char](1) NOT NULL,
	[FilePath] [varchar](255) NULL,
	[ArchiveFilePath] [varchar](255) NULL,
	[FileExtension] [char](3) NULL,
 CONSTRAINT [PK_NexusRouterType] PRIMARY KEY CLUSTERED 
(
	[RouterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[NexusRouterType]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_NexusRouterType.sql'
    PRINT '<<< CREATED TABLE NexusRouterType >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE NexusRouterType >>>'
GO