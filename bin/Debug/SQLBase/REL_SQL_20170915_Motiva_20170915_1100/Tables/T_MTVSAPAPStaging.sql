/****** Object:  ViewName [dbo].[MTVSAPAPStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPAPStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSAPAPStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVSAPAPStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVSAPAPStaging]
    PRINT '<<< DROPPED TABLE MTVSAPAPStaging >>>'
END


/****** Object:  Table [dbo].[MTVSAPAPStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO

Create	Table	MTVSAPAPStaging
				(
				ID						Int	Primary Key	IDENTITY,
				CIIMssgQID				Int,
				BatchID					Int,
				InvoiceLevel			Char(1),
				CompanyCode				Varchar(10),
				DocumentDate			SmallDateTime,
				PostingDate				SmallDateTime,
				Currency				Char(3),
				DocumentType			Char(2),
				DocumentHeaderText		Varchar(25),
				DocNumber				Varchar(50),
				ParentDocNumber			Varchar(50),
				PostingKey				Int,
				Vendor					Varchar(20),
				ReferenceKey1			Varchar(20),
				ReferenceKey2			Varchar(20),
				ReferenceKey3			Varchar(20),
				TaxCode					Char(2),
				DocumentAmount			Decimal(19,6),
				Account					Varchar(10),
				LineItemText			Varchar(50),
				CostCenter				Varchar(10),
				ProfitCenter			Varchar(10),
				PaymentTerm				Char(4),
				PaymentReference		Varchar(30),
				PaymentBank				Char(5),
				HouseBank				Char(5),
				Material				Varchar(18),
				Plant					Char(4),
				TaxJurisdiction			Varchar(15),
				Quantity				Decimal(19,6),
				BaseUnit				Char(3),
				DebitMemo				Char(1),
				BaselineDate			SmallDateTime,
				PaymentBlock			Char(1),
				RightAngleStatus		Varchar(50),
				MiddlewareStatus		Varchar(50),
				SAPStatus				Varchar(50),
				Message					Varchar(1000)
				)

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPAPStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVSAPAPStaging.sql'
    PRINT '<<< CREATED TABLE MTVSAPAPStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVSAPAPStaging >>>'

