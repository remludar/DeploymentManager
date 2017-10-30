IF (OBJECT_ID('MTVContractChangeStage') IS NOT NULL)
	DROP TABLE MTVContractChangeStage

CREATE TABLE [dbo].[MTVContractChangeStage](
	[DlHdrID] [int] NOT NULL,
	[RevisionLevel] [int] NOT NULL,
	[UnLocked] [bit] NOT NULL,
	[DocumentStatus] [int] NULL,
	[EmptorisID] [varchar](25) NULL,
	[DealActionEvent] [int] NULL,
	[AnalystComments] [int] NULL,
	[AnalystCommentsText] [varchar](max) NULL,
	[SecondaryReviewRequired] [bit] NOT NULL,
	[SecondaryReviewer] [int] NULL,
	[AnalystInputError] [bit] NOT NULL,
	[TraderInputError] [bit] NOT NULL,
	[DealDisputed] [bit] NOT NULL,
	[DisputeResolution] [varchar](max) NULL,
	[AuditAnalyst] [int] NULL,
	[AuditingNotes] [varchar](max) NULL,
	[LogisticsReconciliation] [bit] NOT NULL,
	[InterfaceStatus] [char](1) NULL,
	[InterfaceMessage] [varchar](max) NULL,
	[InterfaceSent] [datetime] NULL,
	[IntefaceRecievedSuccess] [datetime] NULL,
	[InterfaceUserID] [int] NULL,
	[NexusMessageID] [int] NULL,
	[ConcurrencyToken] [timestamp] NOT NULL,
	[ContractAnalyst] [int] NULL,
	[LastUpdateUserID] [int] NOT NULL,
	[LastUpdateDateTime] [DateTime] NOT NULL
 CONSTRAINT [PK_MTVContractChangeStage] PRIMARY KEY CLUSTERED
(
	[DlHdrID] ASC,[RevisionLevel] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_MTVContractChangeStage' AND object_id = OBJECT_ID('MTVContractChangeStage'))
/****** Object:  Index [IX_MTVContractChangeStage]    Script Date: 7/15/2016 10:13:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_MTVContractChangeStage] ON [dbo].[MTVContractChangeStage]
(
	[DlHdrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

