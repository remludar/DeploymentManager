/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTMSContractXRef WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSContractXRef]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTMSContractXRef.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSContractXRef]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVTMSContractXRef]
    PRINT '<<< DROPPED TABLE MTVTMSContractXRef >>>'
END


/****** Object:  Table [dbo].[MTVTMSContractXRef]    Script Date: 2/19/2016 11:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVTMSContractXRef](
	ID INT	IDENTITY
	,DlHdrID INT
	,TMSSupplierNo   Int
	,TMSCustomerNo	  Int
	,ModifiedDate	SMALLDATETIME
	,UserId			INT
	,[Status]   	CHAR(1)
 CONSTRAINT [PK_MTVTMSContractXRef] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTMSContractXRef.sql'
    PRINT '<<< CREATED TABLE MTVTMSContractXRef >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTMSContractXRef >>>'

