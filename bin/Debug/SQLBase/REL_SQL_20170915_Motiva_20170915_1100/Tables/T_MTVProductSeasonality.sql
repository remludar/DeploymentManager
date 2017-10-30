/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVProductSeasonality WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVProductSeasonality]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVProductSeasonality.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVProductSeasonality]    Script Date: 05/04/2016 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVProductSeasonality]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVProductSeasonality]
    PRINT '<<< DROPPED TABLE MTVProductSeasonality >>>'
END


/****** Object:  Table [dbo].[MTVProductSeasonality]    Script Date: 05/04/2016 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVProductSeasonality
(
PSID				INT				IDENTITY
,RAProductId		INT				NULL
,RALocaleID			INT				NULL
,SAPMaterialNumber  VARCHAR(256)	NULL
,County				INT		        NULL
,State			    INT				NULL
,SAPPlantNumber	    VARCHAR(256)	NULL
,EPAFromDate		VARCHAR(5)
,EPAToDate			VARCHAR(5)
,CreatedDate   		SMALLDATETIME
,CreatedBy          INT             NULL
,UpdatedDate   		SMALLDATETIME   
,UpdatedBy          INT				NULL
CONSTRAINT [PK_MTVProductSeasonality] PRIMARY KEY CLUSTERED 
(
	[PSID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVProductSeasonality]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVProductSeasonality.sql'
    PRINT '<<< CREATED TABLE MTVProductSeasonality >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVProductSeasonality >>>'

