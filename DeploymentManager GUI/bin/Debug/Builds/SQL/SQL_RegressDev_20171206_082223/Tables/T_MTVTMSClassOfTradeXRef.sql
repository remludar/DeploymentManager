/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTMSClassOfTradeXRef WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSClassOfTradeXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTMSClassOfTradeXRef.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSClassOfTradeXRef]    Script Date:  11/18/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSClassOfTradeXRef]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVTMSClassOfTradeXRef]
    PRINT '<<< DROPPED TABLE MTVTMSClassOfTradeXRef >>>'
END


/****** Object:  Table [dbo].[MTVTMSClassOfTradeXRef]    Script Date: 11/18/2015 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVTMSClassOfTradeXRef](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DistributionChannel] [varchar](40) NOT NULL,
	[ClassOfTrade] [varchar](40) NOT NULL,
	[TMSHostCode] [varchar](40) NOT NULL,
	[CommercialFuelIndicator] [char](1) NOT NULL,
	[BrandType] [char](1) NOT NULL,
	[EffectiveFrom] [datetime] NOT NULL,
	[EffectiveTo] [datetime] NOT NULL,
	[LastUpdateUserID] [int] NULL,
	[LastUpdateDate] [datetime] NULL,
	[Status] [char](1) NOT NULL,
 CONSTRAINT [PK_MTVTMSClassOfTradeXRef] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_MTVTMSClassOfTradeXRef]    Script Date: 5/6/2016 2:51:25 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MTVTMSClassOfTradeXRef] ON [dbo].[MTVTMSClassOfTradeXRef]
(
	[DistributionChannel] ASC,
	[ClassOfTrade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



IF  OBJECT_ID(N'[dbo].[MTVTMSClassOfTradeXRef]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTMSClassOfTradeXRef.sql'
    PRINT '<<< CREATED TABLE MTVTMSClassOfTradeXRef >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTMSClassOfTradeXRef >>>'


