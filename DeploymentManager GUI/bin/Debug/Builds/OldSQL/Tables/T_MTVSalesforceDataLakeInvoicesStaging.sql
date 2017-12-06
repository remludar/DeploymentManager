/*
*****************************************************************************************************
--USE FIND AND REPLACE ON CompanyNameTABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSalesforceDataLakeInvoicesStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSalesforceDataLakeInvoicesStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSalesforceDataLakeInvoicesStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDataLakeInvoicesStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVSalesforceDataLakeInvoicesStaging]
    PRINT '<<< DROPPED TABLE MTVSalesforceDataLakeInvoicesStaging >>>'
END


/****** Object:  Table [dbo].[MTVSalesforceDataLakeInvoicesStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create table MTVSalesforceDataLakeInvoicesStaging
	(
	ID						Int		Identity,
	TagIdentifier					Char(1),
	CIIMssgQID						Int,
	MotivaFEIN						Varchar(255),
	CompanyName						Varchar(255),
	MotivaARContactName				Varchar(40),
	ARContactEmail					Varchar(50),
	ARContactPhone					Varchar(25),
	BillToSoldToName				Varchar(100),
	BillToAddress					Varchar(255),
	BillToContact					Varchar(40),
	BillToSoldToNumber				Varchar(255),
	InvoiceNumber					Varchar(20),
	InvoiceDateTime					SmallDateTime,
	PaymentTerms					Varchar(255),
	DealNumber						Varchar(20),
	RemitTo							Varchar(1000),
	ShipFromTerminalAddress			Varchar(255),
	ShipToNumber					Varchar(255),
	ShipToAddress					Varchar(255),
	CustomerCharges					Varchar(80),
	ProductNumber					Varchar(255),
	ProductName						Varchar(50),
	OriginTerminal					Varchar(50),
	TerminalCode					Varchar(255),
	StandardCarrier					Varchar(255),
	CarrierName						Varchar(100),
	BOLNumber						Varchar(80),
	LoadDateTime					SmallDateTime,
	MovementType					Varchar(50),
	NetVolume						Decimal(19,6),
	GrossVolume						Decimal(19,6),
	BillingBasisIndicator			Varchar(10),
	UOM								Varchar(20),
	PerGallonBillingRate			Decimal(19,6),
	TotalProductCost				Decimal(19,6),
	TaxName							Varchar(80),
	TaxCode							Varchar(255),
	RelatedInvoiceNumber			Varchar(240),
	InvoiceDueDate					SmallDateTime,
	CashDiscountAmount				Decimal(19,6),
	InvoiceType						Varchar(20),
	CorrectingInvoiceNumber			Varchar(20),
	DeferredTaxInvoiceNumber		Varchar(240),
	DeferredTaxInvoiceDueDate		SmallDateTime,
	IsDeferred						char(1),
	RegulatoryText					Varchar(8000),
	EPAID							Varchar(255),
	DistributionChannel				Varchar(255),
	Division						Varchar(255),
	SalesOrg						Varchar(255),
	InvoiceTotalAmount				Float,
	TotalTax						Float,
	TransactionType					Varchar(80),
	TaxRate							Decimal(23,10),
	TaxableQuantity					Decimal(19,6),
	TaxAmount						Decimal(19,6),
	PaymentMethod					Varchar(100),
	ReportingGroups                 Varchar(10),
	NexusMessageId                  Int

CONSTRAINT [PK_MTVSalesforceDataLakeInvoicesStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVSalesforceDataLakeInvoicesStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVSalesforceDataLakeInvoicesStaging.sql'
    PRINT '<<< CREATED TABLE MTVSalesforceDataLakeInvoicesStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVSalesforceDataLakeInvoicesStaging >>>'

