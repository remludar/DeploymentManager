/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVCustomerMasterDataStaging WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVCustomerMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVCustomerMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVCustomerMasterDataStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVCustomerMasterDataStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVCustomerMasterDataStaging]
    PRINT '<<< DROPPED TABLE MTVCustomerMasterDataStaging >>>'
END


/****** Object:  Table [dbo].[MTVCustomerMasterDataStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*REPLACE WITH YOUR TABLE CREATION CODE*/

CREATE TABLE [dbo].[MTVCustomerMasterDataStaging]
(
		ID										INT PRIMARY KEY IDENTITY(1,1) ,
		[MDMCustID]								INT,
		[Name]									VARCHAR(255),
		Abbreviation							VARCHAR(255),
		Code									VARCHAR(255),
		[Type]									CHAR(1),
		ParentId								INT,
		ClassOfTrade							CHAR(1),
		TaxPayerID								VARCHAR(255),
		ExcludeFromInhouseRules					CHAR(1),
		Attributes								VARCHAR(255),
		SCACCode								VARCHAR(255),
		BuildingName							VARCHAR(255),
		BuildingAbbreviation					VARCHAR(255),
		BuildingOfficePhone						VARCHAR(255),
		BuildingFax								VARCHAR(255),
		AddressType								CHAR(1),
		AddressLine1							VARCHAR(255),
		AddressLine2							VARCHAR(255),
		Country									VARCHAR(255),
		Electronic								CHAR(1),
		ZipCode									VARCHAR(255),
		City									VARCHAR(255),
		RegionOrState							VARCHAR(255),
		Relations								CHAR(1),
		PaymentType								CHAR(1),
		[InvoiceSetupConfigurationDescription]	VARCHAR(MAX),
		InvoiceSetupContact						INT,
		FallbackConfiguration					CHAR(1),
		ARNumber								VARCHAR(255),
		GroupDetailsOnInvoiceBy					CHAR(1),
		DeliveryMethod							VARCHAR(255),
		[InvoiceStatus]							CHAR(1),
		SplitCorrections						CHAR(1),
		InvoiceSetupSingleAcctPeriod			CHAR(1),
		MaximumNumberOfBOL						SMALLINT,
		Securitized								CHAR(1),
		RemitTo									INT,
		BasedOn									VARCHAR(255),
		InvoiceCorrections						CHAR(1),
		PrintHoldStatus							CHAR(1),
		AllRelations							CHAR(1),
		AllInternalBAs							CHAR(1),
		AllCommodities							CHAR(1),
		Wire									VARCHAR(255),
		InvoiceFrequency						VARCHAR(2000),
		DaysAfterInvoiceCreate					INT,
		BAStatus								CHAR(1),
		TaxLicense								VARCHAR(255),
		TaxExemptionType						CHAR(1),
		TaxLicenseType							varchar(255),
		TaxLicenseEffectiveFromDate				DATETIME,
		TaxLicenseEffectiveToDate				DATETIME,
		TaxDeferredBilling						CHAR(1),

		--ExemptionType							CHAR,
		--LicenseType							VARCHAR(255),
		--EffectiveDate							DATETIME,
		--ToDate								DATETIME,
		--DefferredBilling						CHAR,
	
		InterfaceId								INT,
		InterfaceAction							VARCHAR(10),
		ProcessedDate							DateTime,
		InterfaceStatus							CHAR(1),
		InterfaceMessage						VARCHAR(MAX)
)

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVCustomerMasterDataStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVCustomerMasterDataStaging.sql'
    PRINT '<<< CREATED TABLE MTVCustomerMasterDataStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVCustomerMasterDataStaging >>>'

