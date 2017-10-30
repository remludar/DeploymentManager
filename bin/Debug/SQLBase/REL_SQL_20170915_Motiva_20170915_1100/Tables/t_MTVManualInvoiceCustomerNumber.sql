
/****** Object:  ViewName [dbo].[MTVManualInvoiceCustomerNumber]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVManualInvoiceCustomerNumber.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVManualInvoiceCustomerNumber]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVManualInvoiceCustomerNumber]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVManualInvoiceCustomerNumber]
    PRINT '<<< DROPPED TABLE MTVManualInvoiceCustomerNumber >>>'
END


/****** Object:  Table [dbo].[MTVManualInvoiceCustomerNumber]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

	create table dbo.MTVManualInvoiceCustomerNumber
		(
			ID					int not null IDENTITY(1,1) PRIMARY KEY,
			SlsInvceHdrID		int not null,
			SAPCustomerNumber	varchar(255)
		)

	Create Unique Index idx_MnlInvCustNmbr_SlsInvceHdrID on dbo.MTVManualInvoiceCustomerNumber (SlsInvceHdrID)

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVManualInvoiceCustomerNumber]') IS NOT NULL
  BEGIN
    PRINT '<<< CREATED TABLE MTVManualInvoiceCustomerNumber >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVManualInvoiceCustomerNumber >>>'

