/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealDetailShipToStaging WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealDetailShipToStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailShipToStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDealDetailShipToStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDealDetailShipToStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDealDetailShipToStaging]
    PRINT '<<< DROPPED TABLE MTVDealDetailShipToStaging >>>'
END


/****** Object:  Table [dbo].[MTVDealDetailShipToStaging]    Script Date: 2/19/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVDealDetailShipToStaging](
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
	[Action] [char](1) NOT NULL,
	[StagedUserID] [int] NOT NULL,
	[StagedFromDealOrReport] [char](1) NOT NULL
 CONSTRAINT [PK_MTVDealDetailShipToStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDealDetailShipToStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDealDetailShipToStaging.sql'
    PRINT '<<< CREATED TABLE MTVDealDetailShipToStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDealDetailShipToStaging >>>'

