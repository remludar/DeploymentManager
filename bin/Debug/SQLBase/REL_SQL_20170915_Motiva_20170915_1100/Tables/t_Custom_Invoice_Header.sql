PRINT '***BEGIN***'
PRINT 'Server: ' + @@SERVERNAME
PRINT 'Database: ' + DB_NAME()
PRINT 'User: ' + SYSTEM_USER
PRINT 'Date: ' + CONVERT(VARCHAR(10),GETDATE(),101) + ' @ ' + CONVERT(VARCHAR(10),GETDATE(),108)
PRINT '***********'
PRINT ''

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceHeader') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		Drop Table	CustomInvoiceHeader
	End

Go

-----------------------------------------------------------------------------------------------------------------------------
-- SeedData:	t_CustomInvoiceHeader       Copyright 2014 SolArc
-- Overview:    DocumentWhatThisDataIsFor
-- Created by:	Joshua Weber
-- History:     12/09/2013 - First Created 
--
-- Date         Modified By		Issue#		Modification
-- -----------  -----------		------		-----------------------------------------------------------------------------
--	2013.12.16	rpollard		None		Added PRINT statements for future error checking.
--	2013.12.30	rpollard		None		Reformatted table create script.
--	2014.01.27	rpollard		None		Changed script based on newly reformatted table and foreign keys.
--	2014.01.27	rpollard		None		Modified varchar sizes based on Josh notes.  Brought fields inline with #CustomAccountDetail.
--	2014.02.12	rpollard		None		Added Internal and External BA columns.
--	2014.02.27	rpollard		None		Modified columns to match new SAP fields from Josh.
--	2014.03.16	rpollard		None		Additional changes per Josh email directive.
------------------------------------------------------------------------------------------------------------------

If	Not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceHeader') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin 
		CREATE TABLE [dbo].[CustomInvoiceHeader](
			[SlsInvceHdrID] [int] NOT NULL,
			[InvoiceType] [varchar](10) NULL,
			[InternalBAName] [varchar](150) NULL,
			[ExternalBAName] [varchar](150) NULL,
			[InvoiceDate] [smalldatetime] NULL,
			[NewInvoiceDate] [smalldatetime] NULL,
			[LoadPort] [varchar](150) NULL,
			[NewLoadPort] [varchar](150) NULL,
			[DischargePort] [varchar](150) NULL,
			[NewDischargePort] [varchar](150) NULL,
			[LCNumber] [varchar](80) NULL,
			[NewLCNumber] [varchar](80) NULL,
			[IssuingBank] [varchar](100) NULL,
			[NewIssuingBank] [varchar](100) NULL,
			[IssuingDate] [smalldatetime] NULL,
			[NewIssuingDate] [smalldatetime] NULL,
			[FinanceText] [varchar](255) NULL,
			[SAPPostedDate] [datetime] NULL,
			[NewSAPPostedDate] [datetime] NULL,
			[FXFromCurrency] char(3) NULL,
			[NewFXFromCurrencyId] [int] NULL,
			[FXToCurrency] char(3) NULL,
			[NewFXToCurrencyId] [int] NULL,
			[FXRate] decimal(28,13) NULL,
			[NewFXRate] decimal(28,13) NULL,
			[FXDate] smalldatetime NULL,
			[NewFXDate] smalldatetime NULL,
			[SAPSaleType] [varchar](50) NULL,
			[NewSAPSaleType] [varchar](50) NULL,
			[SAPLineType] [varchar](4) NULL,
			[NewSAPLineType] [varchar](4) NULL,
			[UpdateUserId] [int] NOT NULL,
			[UpdateDate] [datetime] NOT NULL,
		 CONSTRAINT [PK_CustomInvoiceHeader_1] PRIMARY KEY CLUSTERED 
		(
			[SlsInvceHdrID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

		SET ANSI_PADDING OFF

		ALTER TABLE [dbo].[CustomInvoiceHeader]  WITH CHECK ADD  CONSTRAINT [FK_CustomInvoiceHeader_CustomInvoiceHeader] FOREIGN KEY([SlsInvceHdrID])
		REFERENCES [dbo].[SalesInvoiceHeader] ([SlsInvceHdrID])
		ON DELETE CASCADE

		ALTER TABLE [dbo].[CustomInvoiceHeader] CHECK CONSTRAINT [FK_CustomInvoiceHeader_CustomInvoiceHeader]

		ALTER TABLE [dbo].[CustomInvoiceHeader] ADD  CONSTRAINT [DF_CustomInvoiceHeader_UpdateUserId]  DEFAULT ((-1)) FOR [UpdateUserId]

		ALTER TABLE [dbo].[CustomInvoiceHeader] ADD  CONSTRAINT [DF_CustomInvoiceHeader_UpdateDate]  DEFAULT (getdate()) FOR [UpdateDate]
	End
GO

IF	EXISTS(Select * From dbo.sysobjects Where id = object_id(N'dbo.CustomInvoiceHeader') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		Grant Select On dbo.CustomInvoiceHeader To RightAngleAccess
		Grant Insert On dbo.CustomInvoiceHeader To RightAngleAccess
		Grant Update On dbo.CustomInvoiceHeader To RightAngleAccess
		Grant Delete On dbo.CustomInvoiceHeader To RightAngleAccess
	END
GO

PRINT ''
PRINT '***********'
PRINT 'Date: ' + CONVERT(VARCHAR(10),GETDATE(),101) + ' @ ' + CONVERT(VARCHAR(10),GETDATE(),108)
PRINT '****END****'
PRINT ''										