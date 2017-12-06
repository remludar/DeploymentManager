

/****** Object:  Table [dbo].[MTVCreditCurveStaging]    Script Date: 5/12/2016 2:28:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVCreditCurveStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVCreditCurveStaging]
    PRINT '<<< DROPPED TABLE MTVCreditCurveStaging >>>'
END

CREATE TABLE [dbo].[MTVCreditCurveStaging](
	[CurveID] [int] IDENTITY(1,1) NOT NULL,
	[PriceID] [int] null,
	[QuoteFromDate] [datetime] NULL,
	[QuoteToDate] [datetime] NULL,
	[DlvryFromDate] [datetime] NULL,
	[DlvryToDate] [datetime] NULL,
	[Type] [varchar](50) NULL,
	[PriceType] [varchar](50) NULL,
	[OriginalUom] [int] null,
	[OriginalCur] [int] null,
	[Value] [float] NULL,
	[SentToParagon] [bit] NULL,
	[CurveName] [varchar](256) NULL,
CONSTRAINT [CurveID] PRIMARY KEY CLUSTERED 
(
	[CurveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
 ON [PRIMARY]
GO

SET ANSI_PADDING OFF
GO


