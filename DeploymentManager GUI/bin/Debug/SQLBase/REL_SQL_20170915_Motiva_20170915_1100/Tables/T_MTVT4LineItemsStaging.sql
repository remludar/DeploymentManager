/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVT4LineItemsStaging WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVT4LineItemsStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVT4LineItemsStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVT4LineItemsStaging]    Script Date:  11/18/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVT4LineItemsStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVT4LineItemsStaging]
    PRINT '<<< DROPPED TABLE [MTVT4LineItemsStaging >>>'
END


/****** Object:  Table [dbo].[MTVT4LineItemsStaging]    Script Date: 11/18/2015 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVT4LineItemsStaging
	(
	 LineItemID							INT	IDENTITY
	,T4HdrID							INT
	,LineItemNumber						INT
	,T4LineItemNumber					INT
	,ItemDetailChangeCode				VARCHAR(50)		
	,Quantity							FLOAT			
	,QuantityUnitOfMeasure				VARCHAR(50)	
	,RAUOM								INT
	,Supplier							VARCHAR(50)
	,RASupplierBAID						INT
	,SupplierDunsNumber					VARCHAR(50)
	,SupplierConfirmationStatus			VARCHAR(50)
	,SupplierConfirmationStatusDate		DateTime		
	,Consignee							VARCHAR(50)
	,RAConsigneeBAID					INT	
	,ConsigneeDunsNumber				VARCHAR(50)
	,ConsigneeConfirmationStatus		VARCHAR(50)
	,ConsigneeConfirmationStatusDate	DateTime	
	,Tankage							VARCHAR(50) 
	,RATankageBAID						INT
	,TankageDunsNumber					VARCHAR(50)
	,TankageConfirmationStatus			VARCHAR(50) 
	,TankageConfirmationStatusDate		DateTime	
	,Carrier							VARCHAR(50) 
	,CarrierDunsNumber					VARCHAR(50)
	,CarrierConfirmationStatus			VARCHAR(50) 
	,CarrierConfirmationStatusDate		DateTime	
	,CustodyLocation					VARCHAR(50)
	,RALocaleID							INT
	,CustodyLocationDescription			VARCHAR(50)
	,ScheduleDateTime					DateTime
	,ScheduleRequestedDateTime			DateTime
	,PipelineEvent						VARCHAR(50)
	,PipelineEventVolumeAffect			VARCHAR(50)
	,PipelineEventStatus				VARCHAR(50)
	,PipelineEventDescription			VARCHAR(50)
	,CustodyEventFlag					VARCHAR(50)
	,AllowPartnerChangeFlag				VARCHAR(50)
	,AffectShipperInventoryFlag			VARCHAR(50)
	,QuantityScheduled					FLOAT
	,RecordStatus			CHAR(1)			-- below is common
	,RAMessage				VARCHAR(MAX)   -- Error message and Message
	,PlnndMvtID							INT
	--,RawXML					TEXT
	--,ImportDate			SMALLDATETIME	--,Interfaced
	--,ModifiedDate		SMALLDATETIME   --ModifiedByRaUserDateTime
	--,UserId				INT				--ModifiedByRAUserid
	--,ProcessedDate		SMALLDATETIME 	
	
CONSTRAINT [PK_MTVT4LineItemsStaging] PRIMARY KEY CLUSTERED 
(
	LineItemID ASC,
	T4HdrID ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVT4LineItemsStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVT4LineItemsStaging.sql'
    PRINT '<<< CREATED TABLE MTVT4LineItemsStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVT4LineItemsStaging >>>'


