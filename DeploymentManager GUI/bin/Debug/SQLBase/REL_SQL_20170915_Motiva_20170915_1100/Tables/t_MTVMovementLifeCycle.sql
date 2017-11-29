/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVMovementLifeCycle WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVMovementLifeCycle]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVMovementLifeCycle.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVMovementLifeCycle]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVMovementLifeCycle]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVMovementLifeCycle]
    PRINT '<<< DROPPED TABLE MTVMovementLifeCycle >>>'
END


/****** Object:  Table [dbo].[MTVMovementLifeCycle]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVMovementLifeCycle](
	[MESID] [int] NOT NULL,
	[MovementProcessComplete] [bit] NOT NULL,
	[BOLNumber] [varchar](80) NOT NULL,
	[TMSLoadStartDateTime] [datetime] NOT NULL,
	[TMSSoldTo] [varchar](80) NOT NULL,
	[TMSProdID] [varchar](80) NOT NULL,
	[TMSTerminal] [varchar](80) NOT NULL,
	[MvtHdrMvtDcmntID] [int] NULL,
	[MvtHdrID] [int] NULL,
	[RAMvtDlvryBAID] [int] NULL,
	[RATerminalLcleID] [int] NULL,
	[RAPrdctID] [int] NULL,
	[TMSIntefaceStatus] [char](1) NULL,
	[TMSInterfaceImportDate] [smalldatetime] NULL,
	[TMSInterfaceProcessedDate] [smalldatetime] NULL,
	[Matched] [char](1) NULL,
	[MatchedDateTime] [smalldatetime] NULL,
	[TransactionHeaderID] [int] NULL,
	[TransactionHeaderStatus] [char](1) NULL,
	[TransactionHeaderDateTime] [smalldatetime] NULL,
	[TransactionDetailID] [int] NULL,
	[TransactionDetailStatus] [char](1) NULL,
	[TransactionDetailDateTime] [smalldatetime] NULL,
	[AccountDetailID] [int] NULL,
	[AccountDetailStatus] [char](1) NULL,
	[AccountDetailDateTime] [smalldatetime] NULL,
	[SalesInvoiceHeaderID] [int] NULL,
	[InvoiceNumber] [varchar](20) NULL,
	[Invoiced] [char](1) NULL,
	[InvoiceStatus] [char](1) NULL,
	[InvoiceCreationDate] [smalldatetime] NULL,
	[InvoiceFeedDate] [smalldatetime] NULL,
	[MSAPInterfaceStatus] [char](1) NULL,
	[SalesForceInterfaceStatus] [char](1) NULL,
 CONSTRAINT [PK_MTVMovementLifeCycle] PRIMARY KEY NONCLUSTERED 
(
	[MESID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_MTVMovementLifeCycle]    Script Date: 4/14/2017 10:03:03 AM ******/
CREATE NONCLUSTERED INDEX [IX_MTVMovementLifeCycle] ON [dbo].[MTVMovementLifeCycle]
(
	[MESID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

/****** Object:  Index [IX_MTVMovementLifeCycleMovementProcessComplete]    Script Date: 4/14/2017 10:03:27 AM ******/
CREATE NONCLUSTERED INDEX [IX_MTVMovementLifeCycleMovementProcessComplete] ON [dbo].[MTVMovementLifeCycle]
(
	[MovementProcessComplete] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

/****** Object:  Index [IX_MTVMovementLifeCycleMvtHdrID]    Script Date: 4/14/2017 10:07:10 AM ******/
CREATE NONCLUSTERED INDEX [IX_MTVMovementLifeCycleMvtHdrID] ON [dbo].[MTVMovementLifeCycle]
(
	[MvtHdrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVMovementLifeCycle]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVMovementLifeCycle.sql'
    PRINT '<<< CREATED TABLE MTVMovementLifeCycle >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVMovementLifeCycle >>>'