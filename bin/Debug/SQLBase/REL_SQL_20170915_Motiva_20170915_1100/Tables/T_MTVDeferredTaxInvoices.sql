/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDeferredTaxInvoices WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDeferredTaxInvoices]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVDeferredTaxInvoices.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDeferredTaxInvoices]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDeferredTaxInvoices]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDeferredTaxInvoices]
    PRINT '<<< DROPPED TABLE MTVDeferredTaxInvoices >>>'
END


/****** Object:  Table [dbo].[MTVDeferredTaxInvoices]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*REPLACE WITH YOUR TABLE CREATION CODE*/
CREATE TABLE MTVDeferredTaxInvoices
		(
					Id Int Identity(1,1) not null,
					SalesInvoiceHeaderId INT,
					SalesInvoiceHeaderNumber varchar(20),
					SalesInvoiceHeaderStatus varchar(1),
					BillingTermID int,
					BillingTerm varchar(50),
					--InvoiceDueDate datetime,
					CalculatedDueDate datetime,
					MovementDate smalldatetime,
					--SalesDetailTransValue decimal(13, 5), 
					BOL varchar(100), 
					HasBadDate bit,
					IsCorrected bit
		)
GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDeferredTaxInvoices]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVDeferredTaxInvoices.sql'
    PRINT '<<< CREATED TABLE MTVDeferredTaxInvoices >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDeferredTaxInvoices >>>'

