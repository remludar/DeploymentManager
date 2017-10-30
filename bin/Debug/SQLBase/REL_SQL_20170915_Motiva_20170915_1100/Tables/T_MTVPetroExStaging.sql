/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVPetroExStaging WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPetroExStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPetroExStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVPetroExStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVPetroExStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVPetroExStaging]
    PRINT '<<< DROPPED TABLE MTVPetroExStaging >>>'
END


/****** Object:  Table [dbo].[MTVPetroExStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVPetroExStaging
	(
	MPESID				INT	IDENTITY
	,RecordType			VARCHAR(1)
	,CompanyID			VARCHAR(2)
	,RACompanyBAID		INT
	,TerminalID			VARCHAR(6)
	,RALocaleId			INT
	,RADestLocaleId		INT
	,BOLNumber			VARCHAR(9)
	,ProductCode		VARCHAR(3)
	,RAPrdctID			INT
	,LoadDate			VARCHAR(6)
	,Consignee			VARCHAR(14)
	,CarrierID			VARCHAR(4)
	,RACarrierBAID		INT
	,GrossQuantity		FLOAT(8)
	,NetQuantity		FLOAT(8)
	,CreditIndicator	VARCHAR(1)
	,BlendIndicator		VARCHAR(1)
	,TruckNumber		VARCHAR(6)
	,LoadTime			VARCHAR(4)
	,PlaceHolder		VARCHAR(7)
	,RAMovementDate		SMALLDATETIME
	,TicketStatus		CHAR(1)
	,ErrorMessage		VARCHAR(MAX)
	,ImportDate			SMALLDATETIME
	,ModifiedDate		SMALLDATETIME
	,UserId				INT
	,ProcessedDate		SMALLDATETIME
	,MvmntDctID			INT
	,MvmntHdrID			INT
CONSTRAINT [PK_MTVPetroExStaging] PRIMARY KEY CLUSTERED 
(
	[MPESID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Index [BOLNumber]    Script Date: 7/21/2015 8:46:37 AM ******/
CREATE NONCLUSTERED INDEX [BOLNumber] ON [dbo].[MTVPetroExStaging]
(
	[BOLNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVPetroExStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVPetroExStaging.sql'
    PRINT '<<< CREATED TABLE MTVPetroExStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVPetroExStaging >>>'

