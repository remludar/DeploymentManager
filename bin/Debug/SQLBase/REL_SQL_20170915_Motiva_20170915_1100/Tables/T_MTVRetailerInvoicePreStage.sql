/*
*****************************************************************************************************
--USE FIND AND REPLACE ON CompanyNameTABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  Table [dbo].[MTVRetailerInvoicePreStage]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVRetailerInvoicePreStage.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVRetailerInvoicePreStage]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVRetailerInvoicePreStage]
    PRINT '<<< DROPPED TABLE MTVRetailerInvoicePreStage >>>'
END


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVRetailerInvoicePreStage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TagIdentifier] [char](1) NULL,
	[CIIMssgQID] [int] NULL,
	[MotivaFEIN] [varchar](255) NULL,
	[CompanyName] [varchar](255) NULL,
	[MotivaARContactName] [varchar](40) NULL,
	[ARContactEmail] [varchar](50) NULL,
	[ARContactPhone] [varchar](25) NULL,
	[BillToSoldToName] [varchar](100) NULL,
	[BillToAddress] [varchar](255) NULL,
	[BillToContact] [varchar](40) NULL,
	[BillToSoldToNumber] [varchar](255) NULL,
	[InvoiceNumber] [varchar](20) NULL,
	[InvoiceDateTime] [smalldatetime] NULL,
	[PaymentTerms] [varchar](255) NULL,
	[DealNumber] [varchar](20) NULL,
	[RemitTo] [varchar](1000) NULL,
	[ShipFromTerminalAddress] [varchar](255) NULL,
	[ShipToNumber] [varchar](255) NULL,
	[ShipToAddress] [varchar](255) NULL,
	[CustomerCharges] [varchar](80) NULL,
	[ProductNumber] [varchar](255) NULL,
	[ProductName] [varchar](50) NULL,
	[OriginTerminal] [varchar](50) NULL,
	[TerminalCode] [varchar](255) NULL,
	[StandardCarrier] [varchar](255) NULL,
	[CarrierName] [varchar](100) NULL,
	[BOLNumber] [varchar](80) NULL,
	[LoadDateTime] [smalldatetime] NULL,
	[MovementType] [varchar](50) NULL,
	[NetVolume] [decimal](19, 6) NULL,
	[GrossVolume] [decimal](19, 6) NULL,
	[BillingBasisIndicator] [varchar](10) NULL,
	[UOM] [varchar](20) NULL,
	[PerGallonBillingRate] [decimal](19, 6) NULL,
	[TotalProductCost] [decimal](19, 6) NULL,
	[TaxName] [varchar](80) NULL,
	[TaxCode] [varchar](255) NULL,
	[RelatedInvoiceNumber] [varchar](240) NULL,
	[InvoiceDueDate] [smalldatetime] NULL,
	[CashDiscountAmount] [decimal](19, 6) NULL,
	[InvoiceType] [varchar](20) NULL,
	[CorrectingInvoiceNumber] [varchar](20) NULL,
	[DeferredTaxInvoiceNumber] [varchar](240) NULL,
	[DeferredTaxInvoiceDueDate] [smalldatetime] NULL,
	[IsDeferred] [char](1) NULL,
	[RegulatoryText] [varchar](8000) NULL,
	[EPAID] [varchar](255) NULL,
	[DistributionChannel] [varchar](255) NULL,
	[Division] [varchar](255) NULL,
	[SalesOrg] [varchar](255) NULL,
	[InvoiceTotalAmount] [float] NULL,
	[TotalTax] [float] NULL,
	[TransactionType] [varchar](80) NULL,
	[TaxRate] [decimal](23, 10) NULL,
	[TaxableQuantity] [decimal](19, 6) NULL,
	[TaxAmount] [decimal](19, 6) NULL,
	[PaymentMethod] [varchar](100) NULL,
	[ReportingGroups] [varchar](10) NULL,
	[NetAmount] [decimal](19, 6) NULL,
	[NexusMessageId] [int] NULL,
	[CreationDate] [datetime] NULL,
 CONSTRAINT [PK_MTVRetailerInvoicePreStage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVRetailerInvoicePreStage]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVRetailerInvoicePreStage.sql'
    PRINT '<<< CREATED TABLE MTVRetailerInvoicePreStage >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVRetailerInvoicePreStage >>>'




