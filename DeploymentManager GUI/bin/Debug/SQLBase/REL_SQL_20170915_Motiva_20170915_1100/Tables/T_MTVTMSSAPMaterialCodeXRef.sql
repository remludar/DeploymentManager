/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTMSSAPMaterialCodeXRef WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSSAPMaterialCodeXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTMSSAPMaterialCodeXRef.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSSAPMaterialCodeXRef]    Script Date:  11/18/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSSAPMaterialCodeXRef]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVTMSSAPMaterialCodeXRef]
    PRINT '<<< DROPPED TABLE MTVTMSSAPMaterialCodeXRef >>>'
END


/****** Object:  Table [dbo].[MTVTMSSAPMaterialCodeXRef]    Script Date: 11/18/2015 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVTMSSAPMaterialCodeXRef](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RALocaleID] [int] NOT NULL,
	[RAProductID] [int] NOT NULL,
	[TMSProductDesc] [varchar](50) NULL,
	[TMSCode] [varchar](6) NOT NULL,
	[Sequence] [varchar](2) NOT NULL,
	[Status] [char](1) NOT NULL,
	[ErrorMessage] [varchar](255) NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedUserID] [int] NULL,
 CONSTRAINT [PK_MTVTMSSAPMaterialCodeXRef] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_MTVTMSSAPMaterialCodeXRef]    Script Date: 5/16/2016 10:24:06 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MTVTMSSAPMaterialCodeXRef] ON [dbo].[MTVTMSSAPMaterialCodeXRef]
(
	[RALocaleID] ASC,
	[TMSCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_MTVTMSSAPMaterialCodeXRef_1]    Script Date: 5/16/2016 10:24:06 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MTVTMSSAPMaterialCodeXRef_1] ON [dbo].[MTVTMSSAPMaterialCodeXRef]
(
	[RALocaleID] ASC,
	[RAProductID] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


IF  OBJECT_ID(N'[dbo].[MTVTMSSAPMaterialCodeXRef]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTMSSAPMaterialCodeXRef.sql'
    PRINT '<<< CREATED TABLE MTVTMSSAPMaterialCodeXRef >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTMSSAPMaterialCodeXRef >>>'


