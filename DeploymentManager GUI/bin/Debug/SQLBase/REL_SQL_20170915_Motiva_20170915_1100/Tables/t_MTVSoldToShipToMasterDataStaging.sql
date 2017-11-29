/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSoldToShipToMasterDataStaging WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSoldToShipToMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSoldToShipToMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSoldToShipToMasterDataStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVSoldToShipToMasterDataStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVSoldToShipToMasterDataStaging]
    PRINT '<<< DROPPED TABLE MTVSoldToShipToMasterDataStaging >>>'
END


/****** Object:  Table [dbo].[MTVSoldToShipToMasterDataStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*REPLACE WITH YOUR TABLE CREATION CODE*/

CREATE TABLE [dbo].[MTVSoldToShipToMasterDataStaging]
(
		[ID]									[int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
		[MDMCustID]								[VARCHAR](256)	NULL,
		[MTVSAPBASoldToID]						[int]			NULL,
		[BASoldTo]								[varchar](256)  NULL, 
		[TheirCompany]							[varchar](256)  NULL, 
		[ShipTo]								[varchar](256)  NULL,
		[RALocaleID]							[int]			NULL,
		[Location]								[varchar](256)	NULL,
		[CareOf]								[varchar](256)	NULL,
		[FromDate]								[datetime]		NULL,
		[ToDate]								[datetime]		NULL,
		[TMSOverrideEDIConsigneeNbr]			[varchar](256)	NULL,
		[ShipToAccountName]						[varchar](256)	NULL,
		[ShipToShortAccountName]				[varchar](256)	NULL,
		[ShipToCountry]							[varchar](256)	NULL,
		[ShipToAddress]							[varchar](256)	NULL,
		[ShipToAddress1]						[varchar](256)	NULL,
		[ShipToAddress2]						[varchar](256)	NULL,
		[ShipToCity]							[varchar](256)	NULL,
		[ShipToState]							[varchar](256)	NULL,
		[ShipToZip]								[varchar](256)	NULL,
		[ShipToPhone]							[varchar](256)	NULL,
		[LastUpdateUserID]						[int]			NULL,
		[LastUpdateDate]						[datetime]		NULL,
		[Status]								[varchar](256)	NULL, 
		[InterfaceId]							INT				NULL,
		[InterfaceAction]						VARCHAR(10)		NULL,
		[ProcessedDate]							DATETIME		NULL,
		[InterfaceStatus]						CHAR(1)			NULL,
		[InterfaceMessage]						VARCHAR(MAX)	NULL	
)

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVSoldToShipToMasterDataStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVSoldToShipToMasterDataStaging.sql'
    PRINT '<<< CREATED TABLE MTVSoldToShipToMasterDataStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVSoldToShipToMasterDataStaging >>>'

