/****** Object:  Table [dbo].[MTVCreditExposureInterfaceStats]    Script Date: 5/19/2016 1:12:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF  OBJECT_ID(N'[dbo].[MTVCreditExposureInterfaceStats]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVCreditExposureInterfaceStats]
    PRINT '<<< DROPPED TABLE MTVCreditExposureInterfaceStats >>>'
END
CREATE TABLE [dbo].[MTVCreditExposureInterfaceStats](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RunDateTime] [datetime] NULL,
	[RunType] [char](1) NULL,
	[Success] [bit] null,
	[Result] [varchar](128) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


