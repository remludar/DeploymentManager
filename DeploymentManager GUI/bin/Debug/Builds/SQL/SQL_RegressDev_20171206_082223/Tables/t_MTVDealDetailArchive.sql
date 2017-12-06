/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealDetailArchive WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealDetailArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealDetailArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDealDetailArchive]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDealDetailArchive]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDealDetailArchive]
    PRINT '<<< DROPPED TABLE MTVDealDetailArchive >>>'
END


/****** Object:  Table [dbo].[MTVDealDetailArchive]    Script Date: 2/19/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE MTVDealDetailArchive (
	RevisionID INT NOT NULL,
	DlHdrID INT NOT NULL,
	DlDtlID INT NOT NULL,
	ChangeType CHAR(1) NOT NULL,
	DlDtlTrmTrmID INT,
	DlDtlPrdctID INT,
	DlDtlQntty FLOAT,
	DlDtlVlmeTrmTpe CHAR(1),
	SchedulingQuantityTerm CHAR(1),
	DlDtlDsplyUOM SMALLINT,
	DlDtlApprxmteQntty CHAR(1),
	VolumeToleranceDirection CHAR(1),
	ToleranceWhoseOption CHAR(1),
	VolumeToleranceQuantity FLOAT,
	DlDtlLcleID INT,
	OriginLcleID INT,
	DestinationLcleID INT,
	DeliveryTermID INT,
	DlDtlMthdTrnsprttn CHAR(1),
	DlDtlFrmDte DATETIME,
	DlDtlToDte DATETIME,
	RevisionComment VARCHAR(MAX),
	SubType VARCHAR(4),
	DlDtlSpplyDmnd CHAR(1),
	PipeLineName VARCHAR(80),
	SAPSoldToShipTo VARCHAR(10),
	LoadingFromDate DATETIME,
	LoadingToDate DATETIME,
	PipelineCycle VARCHAR(2000),
	Ratio FLOAT,
	DemurrageAnalyst INT,
	Scheduler INT,
	RevisionDate DATETIME NOT NULL,
	RevisionUserID INT NOT NULL,
	ColumnCheckSum INT NOT NULL,
	SecondaryCheckSum INT NOT NULL
)

IF (OBJECT_ID('PK_MTVDealDetailArchive') IS NULL)
ALTER TABLE [dbo].[MTVDealDetailArchive] ADD  CONSTRAINT [PK_MTVDealDetailArchive] PRIMARY KEY CLUSTERED 
(
	[RevisionID] ASC,
	[DlHdrID] ASC,
	[DlDtlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


IF  OBJECT_ID(N'[dbo].[MTVDealDetailArchive]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDealDetailArchive.sql'
    PRINT '<<< CREATED TABLE MTVDealDetailArchive >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDealDetailArchive >>>'