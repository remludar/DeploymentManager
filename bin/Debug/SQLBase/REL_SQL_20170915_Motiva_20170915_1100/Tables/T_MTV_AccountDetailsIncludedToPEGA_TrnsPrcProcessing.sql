/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing]
    PRINT '<<< DROPPED TABLE MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing >>>'
END


/****** Object:  Table [dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing] (	[AcctDtlID] [int] NOT NULL,
												[AcctDtlSrceID] [int] NOT NULL,
												[AcctDtlTrnsctnTypID] [smallint] NOT NULL,
												[AcctDtlAccntngPrdID] [int] NULL,
												[AcctDtlSlsInvceHdrID] [int] NULL,
												[AcctDtlPrchseInvceHdrID] [int] NULL,
												[AcctDtlClseStts] [char](1) NOT NULL,
												[AcctDtlAcctCdeStts] [char](1) NOT NULL,
												[AcctDtlTxStts] [char](1) NOT NULL,
												[AcctDtlPrntID] [int] NOT NULL,
												[AcctDtlTrnsctnDte] [smalldatetime] NOT NULL,
												[InternalBAID] [int] NOT NULL,
												[ExternalBAID] [int] NOT NULL,
												[Volume] [decimal](19, 6) NOT NULL,
												[Value] [decimal](19, 6) NOT NULL,
												[CrrncyID] [int] NOT NULL,
												[ParentPrdctID] [int] NULL,
												[AcctDtlDlDtlDlHdrID] [int] NULL,
												[AcctDtlMvtHdrID] [int] NULL,
												[AcctDtlLcleID] [int] NOT NULL,
												[AcctDtlDestinationLcleID] [int] NULL,
												[PayableMatchingStatus] [char](1) NOT NULL,
												[CreatedDate] [smalldatetime] NOT NULL,
												[NetQuantity] [decimal](19, 6) NULL,
												[GrossQuantity] [decimal](19, 6) NULL,
												[Status] [int] NOT NULL,
												[AcctDtlSrceTble] [char](2) NOT NULL,
												[Reversed] [char](1) NULL,
												[SupplyDemand] [char](1) NULL
												--PRIMARY KEY CLUSTERED 
												--(
												--	[AcctDtlID] ASC
												--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
												--) ON [PRIMARY]
												)
	CREATE NONCLUSTERED INDEX [AcctDtlSlsInvceHdrID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing ([AcctDtlSlsInvceHdrID] ASC ) 
			WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON
			, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		CREATE NONCLUSTERED INDEX [AcctDtlSrceID_Idx] ON MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing ([AcctDtlSrceID] ASC, [AcctDtlSrceTble]) 
			WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON
			, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing.sql'
    PRINT '<<< CREATED TABLE MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTV_AccountDetailsIncludedToPEGA_TrnsPrcProcessing >>>'

