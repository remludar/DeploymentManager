/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDealPriceRowArchive WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDealPriceRowArchive]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDealPriceRowArchive.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDealPriceRowArchive]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDealPriceRowArchive]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDealPriceRowArchive]
    PRINT '<<< DROPPED TABLE MTVDealPriceRowArchive >>>'
END


/****** Object:  Table [dbo].[MTVDealPriceRowArchive]    Script Date: 2/19/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE MTVDealPriceRowArchive (
		PrvsnRwID INT NOT NULL,
		PrvsnID INT NOT NULL,
		RevisionID INT NOT NULL,
		ChangeType CHAR(1) NOT NULL,
		CostType CHAR(1) NOT NULL,
		RowNumber INT NOT NULL,
		RowText VARCHAR(5000),
		Differential FLOAT,
		PrceTpeIdnty INT NULL,
		RPHdrID INT,
		Actual CHAR(1),
		FixedValue FLOAT,
		DeemedDates VARCHAR(1000),
		RuleName VARCHAR(80),
		RuleDescription VARCHAR(1000),
		HolidayOption INT,
		HolidayOptionName VARCHAR(19),
		SaturdayOption INT,
		SaturdayOptionName VARCHAR(19),
		SundayOption INT,
		SundayOptionName VARCHAR(19),
		CurveName VARCHAR(500),
		LcleID INT,
		CrrncyID SMALLINT,
		comment VARCHAR(255),
		RevisionDate DATETIME NOT NULL,
		RevisionUserID INT NOT NULL,
		ColumnCheckSum INT NOT NULL,
		SecondaryCheckSum INT NOT NULL
)

IF (OBJECT_ID('PK_MTVDealPriceRowArchive') IS NULL)
ALTER TABLE [dbo].[MTVDealPriceRowArchive] ADD  CONSTRAINT [PK_MTVDealPriceRowArchive] PRIMARY KEY CLUSTERED 
(
	[PrvsnRwID] ASC,
	[RevisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


IF  OBJECT_ID(N'[dbo].[MTVDealPriceRowArchive]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDealPriceRowArchive.sql'
    PRINT '<<< CREATED TABLE MTVDealPriceRowArchive >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDealPriceRowArchive >>>'