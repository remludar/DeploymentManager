/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVT4NominationHeaderStaging WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVT4NominationHeaderStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVT4NominationHeaderStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVT4NominationHeaderStaging]    Script Date:  11/18/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVT4NominationHeaderStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVT4NominationHeaderStaging]
    PRINT '<<< DROPPED TABLE [MTVT4NominationHeaderStaging >>>'
END


/****** Object:  Table [dbo].[MTVT4NominationHeaderStaging]    Script Date: 11/18/2015 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVT4NominationHeaderStaging
	(
	 T4HdrID						INT	IDENTITY	
	,T4NominationNumber				VARCHAR(50)
	,ShipperNominationNumber		VARCHAR(50)
	,CarrierNominationNumber		VARCHAR(50)				
	,PipelineNominationChangeCode	 VARCHAR(50)			--only for change			
	,PipelineNominationVersionNumber INT
	,NominationType					VARCHAR(50)
	,CarrierReferenceBatchID		VARCHAR(50)
	,CreatedByUser					VARCHAR(50)
	,CreatedByName					VARCHAR(50)
	,ChangedByUser					VARCHAR(50)
	,ChangedByName					VARCHAR(50) 
	,EventDate						DATETIME
	,FinalRecipient					VARCHAR(50)
	,FinalRecipientDunsNumber		VARCHAR(50) 	
	,Shipper						VARCHAR(50) 
	,ShipperDunsNumber				VARCHAR(50)
	,RAShipperBAID					INT
	,Carrier						VARCHAR(50) 
	,CarrierDunsNumber				VARCHAR(50)
	,RACarrierBAID					INT 
	,Product						VARCHAR(50)
	,ProductDescription				VARCHAR(100)
	,RAPrdctID						INT
	,PipelineCycle					VARCHAR(50)
	,PipelineCycleYear				VARCHAR(50)
	,PipelineSequence				FLOAT
	,SCD							VARCHAR(10)	
	,TotalLineItems					INT
	--,TotalDeliveryQuantity			FLOAT
	--,TotalReceiptQuantity			FLOAT	
	,RecordStatus			CHAR(1)			-- below is common
	,RAMessage				VARCHAR(MAX)   -- Error message and Message
	,RawXML					TEXT
	,InterfaceID Int
	,ImportDate			SMALLDATETIME	--,Interfaced
	,ModifiedDate		SMALLDATETIME   --ModifiedByRaUserDateTime
	,UserId				INT				--ModifiedByRAUserid
	,ProcessedDate		SMALLDATETIME 	
	
CONSTRAINT [PK_MTVT4NominationHeaderStaging] PRIMARY KEY CLUSTERED 
(
	T4HdrID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVT4NominationHeaderStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVT4NominationHeaderStaging.sql'
    PRINT '<<< CREATED TABLE MTVT4NominationHeaderStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVT4NominationHeaderStaging >>>'


