/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVArchiveRevisionLevels WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVArchiveRevisionLevels]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVArchiveRevisionLevels.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVArchiveRevisionLevels]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVArchiveRevisionLevels]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVArchiveRevisionLevels]
    PRINT '<<< DROPPED TABLE MTVArchiveRevisionLevels >>>'
END


/****** Object:  Table [dbo].[MTVArchiveRevisionLevels]    Script Date: 2/19/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE MTVArchiveRevisionLevels (
	ArchiveID INT IDENTITY(1,1),
	RevisionLevel INT NOT NULL,
	ChangeType CHAR(1) NOT NULL,
	DlHdrID INT NOT NULL,
	DlDtlID INT NOT NULL,
	PrvsnRowID INT,
	DlHdrRevisionID INT NOT NULL,
	DlDtlRevisionID INT NOT NULL,
	PrvsnRowRevisionID INT,
	PrvsnIsPrimary BIT,
	RevisionDate DATETIME NOT NULL,
	RevisionUserID INT NOT NULL
)

IF (OBJECT_ID('PK_MTVArchiveRevisionLevels') IS NULL)
ALTER TABLE [dbo].[MTVArchiveRevisionLevels] ADD  CONSTRAINT [PK_MTVArchiveRevisionLevels] PRIMARY KEY CLUSTERED 
(
	[ArchiveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_MTVArchiveRevisionLevels_DlHdr' AND object_id = OBJECT_ID('MTVContractChangeStage'))
CREATE NONCLUSTERED INDEX [IX_MTVArchiveRevisionLevels_DlHdr] ON [dbo].[MTVArchiveRevisionLevels]
(
	[DlHdrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name = 'IX_MTVArchiveRevisionLevels_DlDtl' AND object_id = OBJECT_ID('MTVContractChangeStage'))
CREATE NONCLUSTERED INDEX [IX_MTVArchiveRevisionLevels_DlDtl] ON [dbo].[MTVArchiveRevisionLevels]
(
	[DlHdrID] ASC,
	[DlDtlID] ASC,
	[RevisionLevel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF (OBJECT_ID('MTVDealHeaderArchive') IS NOT NULL)
	TRUNCATE TABLE MTVDealHeaderArchive
	
IF (OBJECT_ID('MTVDealDetailArchive') IS NOT NULL)
	TRUNCATE TABLE MTVDealDetailArchive

IF (OBJECT_ID('MTVDealPriceRowArchive') IS NOT NULL)
	TRUNCATE TABLE MTVDealPriceRowArchive

IF (OBJECT_ID('MTVArchiveRevisionLevels') IS NOT NULL)
	TRUNCATE TABLE MTVArchiveRevisionLevels

IF (OBJECT_ID('MTVContractChangeStage') IS NOT NULL)
	TRUNCATE TABLE MTVContractChangeStage

IF  OBJECT_ID(N'[dbo].[MTVArchiveRevisionLevels]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVArchiveRevisionLevels.sql'
    PRINT '<<< CREATED TABLE MTVArchiveRevisionLevels >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVArchiveRevisionLevels >>>'