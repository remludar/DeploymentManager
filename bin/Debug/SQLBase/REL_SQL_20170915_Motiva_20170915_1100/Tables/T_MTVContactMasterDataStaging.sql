/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVContactMasterDataStaging WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVContactMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVContactMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVContactMasterDataStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVContactMasterDataStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].MTVContactMasterDataStaging
    PRINT '<<< DROPPED TABLE MTVContactMasterDataStaging >>>'
END


/****** Object:  Table [dbo].[MTVContactMasterDataStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*REPLACE WITH YOUR TABLE CREATION CODE*/

CREATE TABLE [dbo].[MTVContactMasterDataStaging]
(
		ID										INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
		MDMCustID								INT,
		[Name]									VARCHAR(255),
		Abbreviation							VARCHAR(255),
		ContactRole								VARCHAR(255),
		ContactPhone							VARCHAR(255),
		FirstName								VARCHAR(255),
		LastName								VARCHAR(255),
		[MDMFunction]								VARCHAR(MAX),
		Fax										VARCHAR(255),
		Email									VARCHAR(255),
		EmailArchiveTypeId						INT,
		EmailArchiveType						VARCHAR(255),
		MobilePhone								VARCHAR(255),
		ContactType								VARCHAR(255),
		ContactStatus							CHAR,
		Office									VARCHAR(255),
		OfficeLocaleId							INT,
		BACode									VARCHAR(255),
		ContactID								INT,								
		Department								VARCHAR(255),
		CommunicatonMethod						VARCHAR(255),
		DistributionMethod						VARCHAR(500),
		InterfaceId								INT,
		InterfaceAction							VARCHAR(15),
		ProcessedDate							DateTime,
		InterfaceStatus							CHAR,
		InterfaceMessage						VARCHAR(MAX)
)

GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVContactMasterDataStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVContactMasterDataStaging.sql'
    PRINT '<<< CREATED TABLE MTVContactMasterDataStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVContactMasterDataStaging >>>'

