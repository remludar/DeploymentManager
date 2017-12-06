/****** Object:  ViewName [dbo].[MTVDealDetailShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOutboundCreditBlockStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDealDetailShipTo]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVOutboundCreditBlockStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVOutboundCreditBlockStaging]
    PRINT '<<< DROPPED TABLE MTVOutboundCreditBlockStaging >>>'
END

/****** Object:  Table [dbo].[MTVOutboundCreditBlockStaging]    Script Date: 5/5/2016 3:28:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVOutboundCreditBlockStaging](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SupplierNo] VARCHAR(10) NOT NULL,
	[SoldTo] VARCHAR(10) NOT NULL,
	[CreditBlockFlag] [bit] NOT NULL,
	[InterfaceStatus] [char](1) NOT NULL,
	[Message] [varchar](max) NULL,
	[ProcessedDate] [datetime] NOT NULL,
	[NexusMessageID] [int] NULL
 CONSTRAINT [PK_MTVOutboundCreditBlockStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)

GO

SET ANSI_PADDING OFF
GO

ALTER AUTHORIZATION ON [dbo].[MTVOutboundCreditBlockStaging] TO  SCHEMA OWNER 
GO


