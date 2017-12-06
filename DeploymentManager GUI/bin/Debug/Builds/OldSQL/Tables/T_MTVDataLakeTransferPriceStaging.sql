/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDataLakeTransferPriceStaging WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeTransferPriceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeTransferPriceStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDataLakeTransferPriceStaging]    Script Date: 12/17/2016 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTransferPriceStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDataLakeTransferPriceStaging]
    PRINT '<<< DROPPED TABLE MTVDataLakeTransferPriceStaging >>>'
END

/****** Object:  Table [dbo].[MTVDataLakeTransferPriceStaging]    Script Date: 12/17/2016 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVDataLakeTransferPriceStaging
	(
	  DataLakeTransID INT IDENTITY
	, MVT_TitleTransfer VARCHAR(50)
	, MVT_BilledUnits DECIMAL(20,2)
	, MVT_BillOfLading VARCHAR(80)
	, MVT_InternalDocumentNumber VARCHAR(80)
	, MVT_BillOfLadingDate SMALLDATETIME
	, MVT_GrossUnits FLOAT
	, MVT_InvoiceDate SMALLDATETIME
	, MVT_PurchaseInvoiceNumber VARCHAR(20)
	, MVT_NetUnits FLOAT
	, MVT_ProductCode VARCHAR(255)
	, MVT_UnitPrice DECIMAL(20,6)

	, MVT_BuyerIdType VARCHAR(10)
	, MVT_BuyerIdCode VARCHAR(255)
	, MVT_BuyerCustomId INT
	, MVT_BuyerTradeName VARCHAR(45)
	, MVT_BuyerLegalName VARCHAR(100)
	, MVT_BuyerNameControl VARCHAR(255)

	, MVT_CarrierIdType VARCHAR(10)
	, MVT_CarrierIdCode VARCHAR(255)
	, MVT_CarrierCustomId INT
	, MVT_CarrierTradeName VARCHAR(45)
	, MVT_CarrierLegalName VARCHAR(100)
	, MVT_CarrierNameControl VARCHAR(255)

	, MVT_ConsignorIdType VARCHAR(10)
	, MVT_ConsignorIdCode VARCHAR(255)
	, MVT_ConsignorCustomId INT
	, MVT_ConsignorTradeName VARCHAR(45)
	, MVT_ConsignorLegalName VARCHAR(100)
	, MVT_ConsignorNameControl VARCHAR(255)
	
	, MVT_PositionHolderIdType VARCHAR(10)
	, MVT_PositionHolderIdCode VARCHAR(255)
	, MVT_PositionHolderCustomId INT
	, MVT_PositionHolderTradeName VARCHAR(45)
	, MVT_PositionHolderLegalName VARCHAR(100)
	, MVT_PositionHolderNameControl VARCHAR(255)

	, MVT_Exch_PositionHolderIdType VARCHAR(10)
	, MVT_Exch_PositionHolderIdCode VARCHAR(255)
	, MVT_Exch_PositionHolderCustomId INT
	, MVT_Exch_PositionHolderTradeName VARCHAR(45)
	, MVT_Exch_PositionHolderLegalName VARCHAR(100)
	, MVT_Exch_PositionHolderNameControl VARCHAR(255)
	
	, MVT_SellerIdType VARCHAR(10)
	, MVT_SellerIdCode VARCHAR(255)
	, MVT_SellerCustomId INT
	, MVT_SellerTradeName VARCHAR(45)
	, MVT_SellerLegalName VARCHAR(100)
	, MVT_SellerNameControl VARCHAR(255)

	, MVT_OriginTerminalCode VARCHAR(255)
	, MVT_OriginCustomId INT
	, MVT_OriginDescription VARCHAR(100)
	, MVT_OriginCity VARCHAR(50)
	, MVT_OriginJurisdiction VARCHAR(50)
	, MVT_OriginPostalCode VARCHAR(20)
	, MVT_OriginCountryCode VARCHAR(50)
	, MVT_OriginCounty VARCHAR(120)
	, MVT_OriginCountyCode VARCHAR(120)
	, MVT_OriginLocationType VARCHAR(80)

	, MVT_DestinationTerminalCode VARCHAR(255)
	, MVT_DestinationCustomId INT
	, MVT_DestinationDescription VARCHAR(100)
	, MVT_DestinationAddress1 VARCHAR(50)
	, MVT_DestinationAddress2 VARCHAR(50)
	, MVT_DestinationCity VARCHAR(50)
	, MVT_DestinationJurisdiction VARCHAR(50)
	, MVT_DestinationPostalCode VARCHAR(20)
	, MVT_DestinationCountryCode VARCHAR(50)
	, MVT_DestinationCounty VARCHAR(120)
	, MVT_DestinationCountyCode VARCHAR(120)
	, MVT_DestinationLocationType VARCHAR(80)
	
	, MVT_DivTerminalCode VARCHAR(100)
	, MVT_DivDestination VARCHAR(100)
	, MVT_DivJurisdiction VARCHAR(100)

	, MVT_Alt_Document_Number VARCHAR(30)
	, MVT_exchange_ind CHAR(1)
	, MVT_Pipeline_Batch_Number VARCHAR(30)
	
	, MVT_Vessel_Name VARCHAR(50)
	, MVT_Vessel_Number VARCHAR(10)
	, MVT_Movement_Posted_Date SMALLDATETIME

	, MVT_Transaction_Year INT
	, MVT_Transaction_Month INT
	, MVT_Transaction_ID INT
	, MVT_Transaction_Child_Id INT

	, MVT_Accounting_Year INT
	, MVT_Accounting_Month INT
	, MVT_BOL_Item_Number INT
	, MVT_RD_Type CHAR(1)

	, MVT_Deal_Type VARCHAR(128)
	, MVT_Tax_Commodity_Code VARCHAR(128)
	, MVT_Movement_Type VARCHAR(128)
	, MVT_Deal VARCHAR(128)
	, MVT_Equity_Terminal CHAR(5)
	, MVT_Is_Third_Party CHAR(5)
	
	, MVT_Purchase_Order_Number VARCHAR(128)
	, MVT_Account_DetailID VARCHAR(128)
	, MVT_ExternalBA VARCHAR(128)
	, MVT_GSAP_CustomerNumber VARCHAR(128)
	, MVT_GSAP_VendorNumber VARCHAR(128)
	, MVT_SCAC VARCHAR(128)
	, MVT_SAP_Material_Code VARCHAR(128)
	, MVT_Foreign_Vessel_Identifier CHAR(5)
	, MVT_Transaction_Status CHAR(20)
	, MVT_Product_Grade VARCHAR(20)
	, MVT_Location_ID INT
	
	, MVT_Product_Name VARCHAR(128)
	, MVT_Transaction_Type VARCHAR(128)
	, MVT_Reason_Code VARCHAR(80)
	, MVT_Crude_Type VARCHAR(80)
	
	, AcctMVT_Transaction_Unique_Identifier INT
	, AcctMVT_Transaction_Child_Id INT
	

	, AcctDtlID INT
	, AcctExtBA VARCHAR(50)
	, AcctDeal VARCHAR(20)
	, AcctTktDate SMALLDATETIME
	, AcctBOL VARCHAR(80)
	, AcctBOL_Date SMALLDATETIME
	, AcctAcctDtlLoc VARCHAR(50)
	, AcctProduct VARCHAR(50)
	, AcctProductCode VARCHAR(255)
	, AcctTax_Commodity VARCHAR(128)
	, AcctTransactionType VARCHAR(128)
	, AcctNG CHAR(1)
	, AcctRate DECIMAL(20,10)
	, AcctTran_Amt DECIMAL(20,3)
	, AcctOrigin VARCHAR(50)
	, AcctDestination VARCHAR(50)
	, AcctSlsInv VARCHAR(20)
	, AcctNet FLOAT
	, AcctGross FLOAT
	, AcctAcctPeriod VARCHAR(128)
	, AcctCurr VARCHAR(50)
	, AcctRev CHAR(1)
	, AcctTaxed CHAR(50)
	, AcctSource CHAR(2)
	, AcctIntBA VARCHAR(50)
	, AcctInvoice_Description VARCHAR(80)
	, AcctBilling_Term VARCHAR(255)
	, AcctSalesInvoiceNumber VARCHAR(20)
	, AcctPurchaseInvoiceNumber VARCHAR(20)
	, AcctInvoiceDate SMALLDATETIME
	, AcctPayable_Matching_Status CHAR(1)
	, AcctMovementType VARCHAR(128)
	, AcctDealType VARCHAR(128)

	, AcctOriginState VARCHAR(50)
	, AcctDestinationState VARCHAR(50)
	, AcctAcctCodeStatus VARCHAR(1)
	, AcctOriginCity VARCHAR(50)
	, AcctOriginCounty VARCHAR(50)
	, AcctDestinationCity VARCHAR(50)
	, AcctDestinationCounty VARCHAR(50)
	, AcctTitle_Transfer VARCHAR(50)
	, AcctBilledGallons FLOAT
	, AcctR_D VARCHAR(128)
	, AcctReversed CHAR(1)
	, AcctMovement_Year_Month VARCHAR(128)
	, AcctMovement_Posting_Date SMALLDATETIME
	, AcctGL_Posting_Date SMALLDATETIME
	, AcctBuyer_CustomID INT
	, AcctSeller_CustomID INT
	, AcctExternal_BA VARCHAR(128)
	, AcctExternal_BAID INT
	, AcctBuyer_LegalName VARCHAR(128)
	, AcctBuyer_ID VARCHAR(64)
	, AcctSeller_LegalName VARCHAR(128)
	, AcctSeller_ID VARCHAR(64)
	, MVT_Last_In_Chain CHAR(1)
	, AcctDetail_Status CHAR(1)
	, Account_Detail_ParentID int
	, MVT_Changed_By VARCHAR(80)
	, MVT_TitleTransferCounty VARCHAR(80)
	, MVT_TitleTransferCity VARCHAR(80)
	, Chemicals VARCHAR(200)
	, ChemicalFTACode VARCHAR(255)
	, ChemicalTaxCommodity VARCHAR(255)
	, Acct_Crude_Type VARCHAR(80)
	, CreatedDate SMALLDATETIME
	, UserID int
	, ProcessedStatus VARCHAR(1)
	, PublishedDate SMALLDATETIME
	, InterfaceID Int
	, RecordType VARCHAR(1)
CONSTRAINT [PK_MTVDataLakeTransferPriceStaging] PRIMARY KEY CLUSTERED 
(
	[DataLakeTransID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Index [DataLakeID]    Script Date: 7/21/2015 8:46:37 AM ******/
CREATE NONCLUSTERED INDEX [DataLakeTransID] ON [dbo].[MTVDataLakeTransferPriceStaging]
(
	[DataLakeTransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [RecordType_Idx] ON [dbo].[MTVDataLakeTransferPriceStaging] (RecordType)
CREATE NONCLUSTERED INDEX [MVT_Transaction_IDIdx] ON [dbo].[MTVDataLakeTransferPriceStaging] (MVT_Transaction_ID)
CREATE NONCLUSTERED INDEX [AcctDtlID_IDIdx] ON [dbo].[MTVDataLakeTransferPriceStaging] (AcctDtlID)

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTransferPriceStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDataLakeTransferPriceStaging.sql'
    PRINT '<<< CREATED TABLE MTVDataLakeTransferPriceStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDataLakeTransferPriceStaging >>>'


