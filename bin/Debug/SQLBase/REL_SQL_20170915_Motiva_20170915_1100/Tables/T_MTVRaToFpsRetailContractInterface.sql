
/****** Object:  Table [dbo].[MTVRetailContractRAToFPSStaging]    Script Date: 3/29/2016 8:55:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailContractRAToFPSStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVRetailContractRAToFPSStaging]
    PRINT '<<< DROPPED TABLE MTVRetailContractRAToFPSStaging >>>'
END


CREATE TABLE [dbo].[MTVRetailContractRAToFPSStaging](
	[StagingID] [int] IDENTITY(1,1) NOT NULL,
	[REC_TYPE] [varchar](50) NULL,
	[COU_CODE] [varchar](50) NULL,
	[SALES_ORG] [varchar](50) NULL,
	[DISTRIBUTION_CHANNEL] [varchar](50) NULL,
	[DIVISION] [varchar](50) NULL,
	[CUSTOMER_GROUP] [varchar](50) NULL,
	[CONTRACT_NUMBER] [varchar](50) NULL,
	[CONTRACT_TYPE] [varchar](50) NULL,
	[CUSTOMER_NUMBER] [varchar](10) NULL,
	[PARTNER_CUSTOMER] [varchar](10) NULL,
	[PLANT_CODE] [varchar](50) NULL,
	[PRODUCT_CODE] [varchar](50) NULL,
	[PRO_REF_FLAG] [int] NULL,
	[PRODUCT_GPC_CODE] [varchar](50) NULL,
	[TARGET] [float] NULL,
	[UOM_CODE] [varchar](50) NULL,
	[DATE_FROM] [int] NULL,
	[DATE_TO] [int] NULL,
	[CONTRACT_ITEM] [int] NULL,
	[REJECTION_FLAG] [varchar](2) NULL,
	[HANDLING_TYPE] [varchar](50) NULL,
	[PAYMENT_TERM] [varchar](50) NULL,
	[SHIPPING_CONDITION] [varchar](50) NULL,
	[Partner_Function] [varchar](50) NULL,
	[SentToFps] [bit] NULL,
	[InternalBaId] [int] NULL,
	[SentDate] [datetime] NULL,
	[InterfaceRunId] [int] NULL,
	[RecordInfo] [varchar](256) NULL,
	[UserID] [varchar](32) NULL,
	[ShipToSoldTo] [varchar](8) NULL,
	[MustSend] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[StagingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

/****** Object:  Table [dbo].[MTVRetailContractInterfaceResults]    Script Date: 4/6/2016 12:45:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailContractInterfaceResults]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVRetailContractInterfaceResults]
    PRINT '<<< DROPPED TABLE MTVRetailContractInterfaceResults >>>'
END

CREATE TABLE [dbo].[MTVRetailContractInterfaceResults](
	[InterfaceRunId] [int] NOT NULL Identity,
	[RowsProcessed] [int] NOT NULL,
	[RunDate] [date] NOT NULL,
	[Result] [varchar](1024) NULL,
PRIMARY KEY CLUSTERED 
(
	[InterfaceRunId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

