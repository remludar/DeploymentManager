/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVFPSDiscountSurcharge WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVFPSDiscountSurcharge]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVFPSDiscountSurcharge.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVFPSDiscountSurcharge]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVFPSDiscountSurcharge]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVFPSDiscountSurcharge]
    PRINT '<<< DROPPED TABLE MTVFPSDiscountSurcharge >>>'
END


/****** Object:  Table [dbo].[MTVFPSDiscountSurcharge]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVFPSDiscountSurcharge
(
MFDSID					INT	IDENTITY
,RABAID					INT NULL
,RAProductId			INT NULL
,RALocaleID				INT NULL
,RAToLocaleID			INT NULL
,RACurrencyID			INT NULL
,RAUOMID				INT NULL
,Value					FLOAT
,StartDate				SMALLDATETIME
,EndDate				SMALLDATETIME
,FPSgmtcreateddate 		SMALLDATETIME
,FPSogsid 				INT
,FPSogsidiid 			INT
,FPSconditiontype 		VARCHAR(80)
,FPSconditiontable		INT
,FPSsalesorg 			VARCHAR(4)
,FPSdistchannel 		INT
,FPSsoldtocode			VARCHAR(80)
,FPSshiptocode 			VARCHAR(80)
,FPSplantcode			VARCHAR(80)
,FPSproduct 			VARCHAR(80)
,FPSdivision 			VARCHAR(80)
,FPSshippingcond		VARCHAR(80)
,FPScustgroup			VARCHAR(80)
,Status					CHAR(1)
,UsedInValuation		CHAR(1)
,CreatedDate			SMALLDATETIME
,ModifiedDate			SMALLDATETIME
,UserID					INT

CONSTRAINT [PK_MTVFPSDiscountSurcharge] PRIMARY KEY CLUSTERED 
(
	[MFDSID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSDiscountSurcharge]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVFPSDiscountSurcharge.sql'
    PRINT '<<< CREATED TABLE MTVFPSDiscountSurcharge >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVFPSDiscountSurcharge >>>'

