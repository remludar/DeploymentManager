/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealHeaderArchive WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealHeaderArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealHeaderArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDealHeaderArchive]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDealHeaderArchive]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDealHeaderArchive]
    PRINT '<<< DROPPED TABLE MTVDealHeaderArchive >>>'
END


/****** Object:  Table [dbo].[MTVDealHeaderArchive]    Script Date: 2/19/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVDealHeaderArchive](
	[RevisionID] [int] NOT NULL,
	[DlHdrID] [int] NOT NULL,
	[DlHdrStat] [char](1) NOT NULL,
	[ChangeType] [char](1) NOT NULL,
	[DlHdrIntrnlNbr] [varchar](20) NOT NULL,
	[DlHdrDsplyDte] [datetime] NOT NULL,
	[DlHdrIntrnlBAID] [int] NULL,
	[DlHdrExtrnlBAID] [int] NULL,
	[DlHdrExtrnlCntctID] [int] NULL,
	[Term] [char](3) NULL,
	[DlHdrIntrnlUserID] [int] NULL,
	[MasterAgreement] [int] NULL,
	[Comment] [varchar](max) NULL,
	[Remarks] [varchar](max) NULL,
	[DlHdrCrtnDte] [datetime] NULL,
	[DlHdrTyp] [INT] NOT NULL,
	[DlHdrFrmDte] [datetime] NOT NULL,
	[DlHdrToDte] [datetime] NOT NULL,
	[RinsGenerator] [VARCHAR](255) NULL,
	[RevisionDate] [DATETIME] NOT NULL,
	[RevisionUserID] [INT] NOT NULL,
	[ColumnCheckSum] [INT] NOT NULL,
	[SecondaryCheckSum] [INT] NOT NULL
)

IF (OBJECT_ID('PK_MTVDealHeaderArchive') IS NULL)
ALTER TABLE [dbo].[MTVDealHeaderArchive] ADD  CONSTRAINT [PK_MTVDealHeaderArchive] PRIMARY KEY CLUSTERED 
(
	[RevisionID] ASC,
	[DlHdrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


IF  OBJECT_ID(N'[dbo].[MTVDealHeaderArchive]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDealHeaderArchive.sql'
    PRINT '<<< CREATED TABLE MTVDealHeaderArchive >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDealHeaderArchive >>>'