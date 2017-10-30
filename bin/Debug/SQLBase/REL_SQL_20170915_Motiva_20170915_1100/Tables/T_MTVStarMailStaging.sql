/*
*****************************************************************************************************
--USE FIND AND REPLACE ON CompanyNameTABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVStarMailStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVStarMailStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVStarMailStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVStarMailStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVStarMailStaging]
    PRINT '<<< DROPPED TABLE MTVStarMailStaging >>>'
END


/****** Object:  Table [dbo].[MTVStarMailStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create table MTVStarMailStaging
	(
	ID							Int		Identity,
	CIIMssgQID					Int,
	InvoiceLevel				Char(1),
	IntBAID						Int,
	IntBACode					Varchar(11),		-- CompanyCode
	IntBAName					Varchar(80),
	ExtBAID						Int,
	ExtBACode					Varchar(11),
	ExtBAName					Varchar(80),
	ExtBAAddress1				Varchar(80),
	ExtBAAddress2				Varchar(80),
	ExtBAAddress3				Varchar(80),

	PlantCode					Varchar(5),
	DocumentNumber				Varchar(10),
	InvoiceNumber				Varchar(20),		-- Message number
	InvoiceDate					SmallDateTime,		-- Document date
	InvoiceAmount				Decimal(19,6),		-- Document amount
	InvoiceCurrency				Varchar(8),
	InvoiceComments				Varchar(80),
	DueDate						SmallDateTime,
	LineItemDesc				Varchar(80),
	GrossVol					Decimal(19,6),
	NetVol						Decimal(19,6),
	PerUnitValue				Decimal(19,6),
	TotalValue					Decimal(19,6),

	ShipFromAddress1			Varchar(80),
	ShipFromAddress2			Varchar(80),
	ShipFromAddress3			Varchar(80),
	ShipToAddress1				Varchar(80),
	ShipToAddress2				Varchar(80),
	ShipToAddress3				Varchar(80),
	ParentInvoiceNumber			Varchar(80),
	PaymentMethod				Varchar(80),
	PaymentTerms				Varchar(255),
	ProductCode					Varchar(80),
	DebitAccount				Varchar(80),
	CreditAccount				Varchar(80),
	BOLNumber					Varchar(80),
	BOLDate						SmallDateTime,
	DiscountAmount				Decimal(19,6),
	DiscountDate				SmallDateTime,

	ExtractDate					SmallDateTime		DEFAULT GetDate(),
	FileCreationDate			SmallDateTime,
	FileName					Varchar(200),
	InterfaceStatus				Char(1),
	InterfaceMessage			VarChar(500),
	ApprovalUserID				Int,
	ApprovalDate				SmallDateTime,
	SCAC						Varchar(80),
	InvoiceDesc					Varchar(80),
	Remit1						Varchar(200),
	Remit2						Varchar(200),
	Remit3						Varchar(200),
	Remit4						Varchar(200),
	Remit5						Varchar(200),
	Remit6						Varchar(200),
	Remit7						Varchar(200),
	Remit8						Varchar(200)

CONSTRAINT [PK_MTVStarMailStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVStarMailStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVStarMailStaging.sql'
    PRINT '<<< CREATED TABLE MTVStarMailStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVStarMailStaging >>>'

