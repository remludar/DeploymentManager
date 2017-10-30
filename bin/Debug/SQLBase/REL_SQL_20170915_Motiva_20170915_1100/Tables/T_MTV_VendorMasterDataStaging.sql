/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTV_VendorMasterDataStaging WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_VendorMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_VendorMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTV_VendorMasterDataStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTV_VendorMasterDataStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTV_VendorMasterDataStaging]
    PRINT '<<< DROPPED TABLE MTV_VendorMasterDataStaging >>>'
END


/****** Object:  Table [dbo].[MTV_VendorMasterDataStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*REPLACE WITH YOUR TABLE CREATION CODE*/

CREATE TABLE [dbo].[MTV_VendorMasterDataStaging]
(
		[ID]									INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[MDMVendID]								INT,
		[Name]									VARCHAR(255) ,
		Abbreviation							VARCHAR(255) ,
		[Type]									CHAR,
		ParentId								INT,
		ClassOfTrade							CHAR,
		TaxPayerID								VARCHAR(255),
		SCACCode								VARCHAR(255),
		AddressType								CHAR,
		AddressLine1							VARCHAR(255),
		AddressLine2							VARCHAR(255),
		Country									VARCHAR(255),
		Electronic								CHAR,
		BankName								VARCHAR(255),
		ZipCode									VARCHAR(255) ,
		City									VARCHAR(255),
		RegionOrState							VARCHAR(255),
		Relations							    CHAR,
		PaymentType								CHAR,
		TaxLicense								VARCHAR(255),
		TaxExemptionType						CHAR(1),
		TaxLicenseType							VARCHAR(255),
		TaxLicenseEffectiveFromDate				DATETIME,
		TaxLicenseEffectiveToDate				DATETIME,
		TaxDeferredBilling						CHAR(1),
		--ExemptionType							CHAR,
		--LicenseType							VARCHAR(255),
		--EffectiveDate							DATETIME,
		--ToDate								DATETIME,
		--DefferredBilling						CHAR,
		[Status]								CHAR,
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

IF  OBJECT_ID(N'[dbo].[MTV_VendorMasterDataStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTV_VendorMasterDataStaging.sql'
    PRINT '<<< CREATED TABLE MTV_VendorMasterDataStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTV_VendorMasterDataStaging >>>'

