/*
*****************************************************************************************************
--USE FIND AND REPLACE ON CompanyNameTABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVInvoiceInterfaceStatus]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVInvoiceInterfaceStatus.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVInvoiceInterfaceStatus]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVInvoiceInterfaceStatus]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVInvoiceInterfaceStatus]
    PRINT '<<< DROPPED TABLE MTVInvoiceInterfaceStatus >>>'
END


/****** Object:  Table [dbo].[MTVInvoiceInterfaceStatus]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create table MTVInvoiceInterfaceStatus
	(
	ID							Int				Identity,
	CIIMssgQID					Int				Not Null,
	InterfaceSource				char(2)			Not Null,
	InvoiceNumber				Varchar(20)		Not Null,
	StarMailStaged				Bit				Default 0,
	StarMailExtracted			Bit				Default 0,
	ARAPStaged					Bit				Default 0,
	ARAPExtracted				Bit				Default 0


CONSTRAINT [PK_MTVInvoiceInterfaceStatus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVInvoiceInterfaceStatus]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVInvoiceInterfaceStatus.sql'
    PRINT '<<< CREATED TABLE MTVInvoiceInterfaceStatus >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVInvoiceInterfaceStatus >>>'

