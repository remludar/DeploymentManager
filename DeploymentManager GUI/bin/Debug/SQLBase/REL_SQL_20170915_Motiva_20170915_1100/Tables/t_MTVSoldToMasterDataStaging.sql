/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVCustomerMasterDataStaging WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSoldToMasterDataStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSoldToMasterDataStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSoldToShipMasterDataStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVSoldToMasterDataStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVSoldToMasterDataStaging]
    PRINT '<<< DROPPED TABLE MTVSoldToMasterDataStaging >>>'
END


/****** Object:  Table [dbo].[MTVSoldToMasterDataStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*REPLACE WITH YOUR TABLE CREATION CODE*/

CREATE TABLE [dbo].[MTVSoldToMasterDataStaging]
(
		[ID]									[INT] PRIMARY KEY IDENTITY(1,1),
		[MDMCustID]								[VARCHAR](256)		NULL,
		[BAID]									[int]				NULL,
		[SoldTo]								[varchar](256)		NULL,
		[VendorNumber]							[varchar](256)		NULL,
		[ClassOfTrade]							[varchar](256)		NULL,
		[CreditLock]							[char](1)			NULL,
		[LastCreditUpdateUserID]				[int]				NULL,
		[LastCreditUpdateDate]					[DateTime]			NULL,
		[Status]								[char](1)			NULL,
		[LastUpdateUserID]						[int]				NULL,
		[LastUpdateDate]						[DateTime] NULL,
		[BusinessAssociate]						[varchar](256) NULL,
		[InterfaceId]							INT NULL,
		[InterfaceAction]						VARCHAR(10) NULL,
		[ProcessedDate]							DATETIME NULL,
		[InterfaceStatus]						CHAR(1) NULL,
		[InterfaceMessage]						VARCHAR(MAX) NULL	
)

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVSoldToMasterDataStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVSoldToMasterDataStaging.sql'
    PRINT '<<< CREATED TABLE MTVSoldToMasterDataStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVSoldToMasterDataStaging >>>'

