/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPBASoldToClassOfTrade WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPBASoldToClassOfTrade]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPBASoldToClassOfTrade.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSAPBASoldToClassOfTrade]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVSAPBASoldToClassOfTrade]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVSAPBASoldToClassOfTrade]
    PRINT '<<< DROPPED TABLE MTVSAPBASoldToClassOfTrade >>>'
END


/****** Object:  Table [dbo].[MTVSAPBASoldToClassOfTrade]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVSAPBASoldToClassOfTrade](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BASoldToID] [int] NOT NULL,
	[Type] [varchar](40) NOT NULL,
 CONSTRAINT [PK_MTVSAPBASoldToClassOfTrade] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_MTVSAPBASoldToClassOfTrade]    Script Date: 2/19/2016 11:46:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MTVSAPBASoldToClassOfTrade] ON [dbo].[MTVSAPBASoldToClassOfTrade]
(
	[BASoldToID] ASC,
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPBASoldToClassOfTrade]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVSAPBASoldToClassOfTrade.sql'
    PRINT '<<< CREATED TABLE MTVSAPBASoldToClassOfTrade >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVSAPBASoldToClassOfTrade >>>'

