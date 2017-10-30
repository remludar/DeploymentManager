/****** Object:  Table [dbo].[MTVOASTruckTicketStaging]    Script Date: 12/15/2015 9:40:03 AM ******/
PRINT 'Start Script=T_MTVOASTruckTicketStaging.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVOASTruckTicketStaging]    Script Date: 11/19/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVOASTruckTicketStaging]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].MTVOASTruckTicketStaging
	PRINT '<<< DROPPED TABLE MTVOASTruckTicketStaging >>>'
END

/****** Object:  Table [dbo].[MTVOASTruckTicketStaging]    Script Date: 12/15/2015 9:40:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVOASTruckTicketStaging](
	[MTVOASTTID] [int] IDENTITY(1,1) NOT NULL,
	[MvtHdrId] [int] NULL,
	[ShipmentType] [char](2) NULL,
	[TransactionType] [char](1) NULL,
	[MvtLcleId] [int] NULL,
	[OASLocationName] [varchar](30) NULL,
	[MvtDate] [smalldatetime] NULL,
	[MvtDocExtNumber] [varchar](12) NULL,
	[MvtProductId] [char](10) NULL,
	[OASProductName] [varchar](21) NULL,
	[MvtProductWeight] [float] NULL,
	[MvtProductQuantity] [float] NULL,
	[MvtProductTemp] [float] NULL,
	[MvtProductTempUnit] [char](6) NULL,
	[InterfaceStatus] [char](1) NULL,
	[InterfaceMessage] [varchar](2000) NULL,
	[UserId] [int] NULL,
	[ModifyDate] [smalldatetime] NULL,
	[CreateDate] [smalldatetime] NULL,
 CONSTRAINT [PK_MTVOASTruckTicketStaging] PRIMARY KEY CLUSTERED 
(
	[MTVOASTTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


