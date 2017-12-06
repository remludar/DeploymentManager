
/****** Object:  Table [dbo].[MTVDemandForecastStaging]    Script Date: 11/19/2015 4:33:53 PM ******/
PRINT 'Start Script=T_MTVDemandForecastStaging.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDemandForecastStaging]    Script Date: 11/19/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDemandForecastStaging]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].[MTVDemandForecastStaging]
	PRINT '<<< DROPPED TABLE MTVDemandForecastStaging >>>'
END

/****** Object:  Table [dbo].[MTVDemandForecastStaging]    Script Date: 11/19/2015 4:33:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[MTVDemandForecastStaging](
	[ForecastID] [int] IDENTITY(1,1) NOT NULL,
	[ForecastDate] [datetime] NULL,
	[SalesOrganizationLocCode] [varchar](256) NULL,
	[RALocaleId] [int] NULL,
	[Partner] [varchar](50) NULL,
	[RABAID] [int] NULL,
	[Contract] [varchar](50) NULL,
	[ContractType] [varchar](50) NULL,
	[RADealTypeId] [int] NULL,
	[AccountingDepotLocalCode] [varchar](256) NULL,
	[RABAID1] [int] NULL,
	[MarketingMaterial] [varchar](50) NULL,
	[RAProductID] [int] NULL,
	[MarketingCustomer] [varchar](50) NULL,
	[RABAID2] [int] NULL,
	[TransportMode] [varchar](50) NULL,
	[RAMovementType] [char](1) NULL,
	[ForecastType] [int] NULL,
	[Quantity] [int] NULL,
	[UnitofMeasure] [varchar](50) NULL,
	[RAUOM] [int] NULL,
	[PlanningCycle] [varchar](10) NULL,
	[GlobalProduct] [varchar](50) NULL,
	[RACommodityId] [int] NULL,
	[FileName] [varchar](300) NULL,
	[Status] [varchar](20) NULL,
	[CreationDate] [datetime] NULL,
	[ProcessedDate] [datetime] NULL,
	[ModifyDate] [datetime] NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[InterfaceMessage] [varchar](2000) NULL,
	[InterfaceID] [varchar](20) NULL,
 CONSTRAINT [PK_MTVDemandForecastStaging] PRIMARY KEY CLUSTERED 
(
	[ForecastID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


