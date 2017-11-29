/****** Object:  ViewName [dbo].[MTVSAPARStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPARStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSAPARStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVSAPARStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVSAPARStaging]
    PRINT '<<< DROPPED TABLE MTVSAPARStaging >>>'
END


/****** Object:  Table [dbo].[MTVSAPARStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO

Create	Table	MTVSAPARStaging
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
				Customer				Varchar(20),
				ReferenceKey1			Varchar(20),
				ReferenceKey2			Varchar(20),
				ReferenceKey3			Varchar(20),
				Region					Char(2),
				TaxCode					Char(2),
				DocumentAmount			Decimal(19,6),
				Account					Varchar(10),
				LineItemText			Varchar(50),
				CostCenter				Varchar(10),
				ProfitCenter			Varchar(10),
				PaymentTerm				Char(4),
				PaymentReference		Varchar(30),
				PaymentMethod			Char(1),
				Material				Varchar(18),
				Plant					Char(4),
				DistributionChannel		Varchar(255),
				SalesOrg				Varchar(255),
				TaxJurisdiction			Varchar(15),
				Quantity				Decimal(19,6),
				BaseUnit				Char(3),
				ReversalReason			Char(2),
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

IF  OBJECT_ID(N'[dbo].[MTVSAPARStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVSAPARStaging.sql'
    PRINT '<<< CREATED TABLE MTVSAPARStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVSAPARStaging >>>'

