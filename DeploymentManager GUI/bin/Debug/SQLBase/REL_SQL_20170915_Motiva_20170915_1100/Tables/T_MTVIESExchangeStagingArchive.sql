
/****** Object:  Table [dbo].[MTVIESExchangeStagingArchive]    Script Date: 11/9/2015 4:33:53 PM ******/
PRINT 'Start Script=T_MTVIESExchangeStagingArchive.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVIESExchangeStagingArchive]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVIESExchangeStagingArchive]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].[MTVIESExchangeStagingArchive]
	PRINT '<<< DROPPED TABLE MTVIESExchangeStagingArchive >>>'
END

/****** Object:  Table [dbo].[MTVIESExchangeStagingArchive]    Script Date: 11/9/2015 4:33:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVIESExchangeStagingArchive](
	[MTVIESExchArchiveID][int] IDENTITY(1,1) NOT NULL,
	[MTVIESExchID] [int] NULL,
	[SlsInvceSttmntSlsInvceHdrID] [int] NULL,
	[SlsInvceSttmntXHdrID] [int] NULL,
	[SlsInvceSttmntRvrsd] [char](1) NULL,
	[DlHdrExtrnlNbr] [varchar](20) NULL,
	[DlHdrIntrnlNbr] [varchar](20) NULL,
	[ParentPrdctAbbv] [varchar](20) NULL,
	[ChildPrdctID] [int] NULL,
	[ChildPrdcAbbv] [varchar](20) NULL,
	[OriginLcleAbbrvtn] [varchar](20) NULL,
	[DestinationLcleAbbrvtn] [varchar](20) NULL,
	[FOBLcleAbbrvtn] [varchar](20) NULL,
	[Quantity] [float] NULL,
	[MvtDcmntExtrnlDcmntNbr] [varchar](80) NULL,
	[MvtHdrDte] [smalldatetime] NULL,
	[XHdrTyp] [char](1) NULL,
	[InvntryRcncleClsdAccntngPrdID] [int] NULL,
	[ChildPrdctOrder] [smallint] NULL,
	[Description] [varchar](150) NULL,
	[TransactionDesc] [varchar](50) NULL,
	[XchDiffGrpID1] [int] NULL,
	[XchDiffGrpName1] [varchar](50) NULL,
	[XchUnitValue1] [float] NULL,
	[XchDiffGrpID2] [int] NULL,
	[XchDiffGrpName2] [varchar](50) NULL,
	[XchUnitValue2] [float] NULL,
	[XchDiffGrpID3] [int] NULL,
	[XchDiffGrpName3] [varchar](50) NULL,
	[XchUnitValue3] [float] NULL,
	[XchDiffGrpID4] [int] NULL,
	[XchDiffGrpName4] [varchar](50) NULL,
	[XchUnitValue4] [float] NULL,
	[XchDiffGrpID5] [int] NULL,
	[XchDiffGrpName5] [varchar](50) NULL,
	[XchUnitValue5] [float] NULL,
	[LastMonthsBalance] [float] NULL,
	[ThisMonthsbalance] [float] NULL,
	[Balance] [float] NULL,
	[DynLstBxDesc] [varchar](50) NULL,
	[TotalValue] [float] NULL,
	[ContractContact] [varchar](50) NULL,
	[UOMAbbv] [varchar](20) NULL,
	[MovementTypeDesc] [varchar](50) NULL,
	[PerUnitDecimalPlaces] [int] NULL,
	[QuantityDecimalPlaces] [int] NULL,
	[AccountPeriod] [int] NULL,
	[ExternalBAID] [int] NULL,
	[Action] [nvarchar](10) NULL,
	[InterfaceMessage] [varchar](2000) NULL,
	[InterfaceFile] [varchar](255) NULL,
	[InterfaceID] [varchar](20) NULL,
	[ImportDate] [smalldatetime] NULL,
	[ModifiedDate] [smalldatetime] NULL,
	[UserId] [int] NULL,
	[ProcessedDate] [smalldatetime] NULL,
	[ArchivedDate] [datetime] NULL
 CONSTRAINT [PK_MTVIESExchangeStagingArchive] PRIMARY KEY CLUSTERED 
(
	[MTVIESExchArchiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVIESExchangeStagingArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVIESExchangeStagingArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVIESExchangeStagingArchive]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVIESExchangeStagingArchive] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVIESExchangeStagingArchive >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVIESExchangeStagingArchive >>>'


