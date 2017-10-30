/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVFPSContractPriceDates WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVFPSContractPriceDates]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVFPSContractPriceDates.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVFPSContractPriceDates]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVFPSContractPriceDates]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVFPSContractPriceDates]
    PRINT '<<< DROPPED TABLE MTVFPSContractPriceDates >>>'
END


/****** Object:  Table [dbo].[MTVFPSContractPriceDates]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVFPSContractPriceDates
(
MFCPDID				INT				IDENTITY
,RABAID				INT				NULL
,RAProductId		INT				NULL
,RALocaleID			INT				NULL
,RAToLocaleID		INT				NULL
,RACurrencyID		INT				NULL
,RAUOMID			INT				NULL
,ContractStartDate	SMALLDATETIME
,ContractEndDate	SMALLDATETIME
,FPSgmtcreateddate 	SMALLDATETIME
,FPSogsid 			INT
,FPSogsidiid 		INT
,FPSconditiontype 	VARCHAR(80)
,FPSconditiontable	INT
,FPSsalesorg 		VARCHAR(4)
,FPSdistchannel 	INT
,FPSsoldtocode		VARCHAR(80)
,FPSshiptocode 		VARCHAR(80)
,FPSplantcode		VARCHAR(80)
,FPSproduct 		VARCHAR(80)
,FPSdivision 		VARCHAR(80)
,FPSshippingcond	VARCHAR(80)
,FPScustgroup		VARCHAR(80)
,FPSvalue 			FLOAT
,Status				CHAR(1)
,UsedInValuation	CHAR(1)
,CreatedDate		SMALLDATETIME
,ModifiedDate		SMALLDATETIME
,UserID				INT
CONSTRAINT [PK_MTVFPSContractPriceDates] PRIMARY KEY CLUSTERED 
(
	[MFCPDID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSContractPriceDates]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVFPSContractPriceDates.sql'
    PRINT '<<< CREATED TABLE MTVFPSContractPriceDates >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVFPSContractPriceDates >>>'

