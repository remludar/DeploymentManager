/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDataLakeMasterTaxStaging WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeMasterTaxStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeMasterTaxStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDataLakeMasterTaxStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDataLakeMasterTaxStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDataLakeMasterTaxStaging]
    PRINT '<<< DROPPED TABLE [MTVDataLakeMasterTaxStaging >>>'
END

/****** Object:  Table [dbo].[MTVDataLakeMasterTaxStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[MTVDataLakeMasterTaxStaging](
	[DataLakeID] [int] IDENTITY(1,1) NOT NULL,
	[BAID] [int] NULL,
	[BAName] [varchar](100) NULL,
	[BAAbbv] [varchar](45) NULL,
	[BAStts] [varchar](1) NULL,
	[FederalTaxID] [varchar](255) NULL,
	[SCAC] [varchar](255) NULL,
	[LicenseName] [varchar](80) NULL,
	[LicenseDescription] [varchar](80) NULL,
	[FromDate] [smalldatetime] NULL,
	[ToDate] [smalldatetime] NULL,
	[Exemption] [varchar](3) NULL,
	[ExemptionTypeAbbreviation] [varchar](255) NULL,
	[ExemptionTypeDescription] [varchar](255) NULL,
	[DeferBilling] [varchar](3) NULL,
	[LicenseTypeDescription] [varchar](255) NULL,
	[LicenseTypeAbbreviation] [varchar](255) NULL,
	[AnnualLicenseNumber] [varchar](80) NULL,
	[PermanentLicenseNumber] [varchar](80) NULL,
	[Comments] [varchar](255) NULL,
	[Miscellaneous] [varchar](255) NULL,
	[CertificateUrl] [varchar](max) NULL,
	[LicenseID] [int] NULL,
	[UniqueID] [int] NULL,
	[ChangeType] [varchar](20) NULL,
	[DataLakeStatus] [varchar](1) NULL,
	[CreatedDate] [smalldatetime] NULL,
	[UserID] [int] NULL,
	[ModifiedDate] [smalldatetime] NULL,
	[PublishedDate] [smalldatetime] NULL,
	[ProcessedStatus] [varchar](1) NULL,
	[Message] [varchar](max) NULL,
	[InterfaceID] [int] NULL
 CONSTRAINT [PK_MTVDataLakeMasterTaxStaging ] PRIMARY KEY CLUSTERED 
(
	[DataLakeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeMasterTaxStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDataLakeMasterTaxStaging.sql'
    PRINT '<<< CREATED TABLE MTVDataLakeMasterTaxStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDataLakeMasterTaxStaging >>>'


