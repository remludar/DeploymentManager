/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealDetailShipTo WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealDetailShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailShipTo.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDealDetailShipTo]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDealDetailShipTo]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDealDetailShipTo]
    PRINT '<<< DROPPED TABLE MTVDealDetailShipTo >>>'
END


/****** Object:  Table [dbo].[MTVDealDetailShipTo]    Script Date: 2/19/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVDealDetailShipTo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DlHdrID] [int] NOT NULL,
	[DlDtlID] [int] NOT NULL,
	[DealDetailID] [int] NULL,
	[SoldToShipToID] [int] NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[LastUpdateUserID] [int] NULL,
	[LastUpdateDate] [datetime] NULL,
	[Status] [char](1) NOT NULL,
 CONSTRAINT [PK_MTVDealDetailShipTo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Index [IX_MTVDealDetailShipTo_DealDetail]    Script Date: 2/19/2016 11:19:55 AM ******/
CREATE NONCLUSTERED INDEX [IX_MTVDealDetailShipTo_DealDetail] ON [dbo].[MTVDealDetailShipTo]
(
	[DealDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_MTVDealDetailShipTo_DealDetailSoldToShipToID]    Script Date: 2/19/2016 11:19:55 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MTVDealDetailShipTo_DealDetailSoldToShipToID] ON [dbo].[MTVDealDetailShipTo]
(
	[DlHdrID] ASC,
	[DlDtlID] ASC,
	[DealDetailID] ASC,
	[SoldToShipToID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF  OBJECT_ID(N'[dbo].[MTVDealDetailShipTo]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDealDetailShipTo.sql'
    PRINT '<<< CREATED TABLE MTVDealDetailShipTo >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDealDetailShipTo >>>'

