/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVOASProductionConsumptionStaging WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVOASProductionConsumptionStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOASProductionConsumptionStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVOASProductionConsumptionStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVOASProductionConsumptionStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVOASProductionConsumptionStaging]
    PRINT '<<< DROPPED TABLE [MTVOASProductionConsumptionStaging >>>'
END


/****** Object:  Table [dbo].[MTVOASProductionConsumptionStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO


SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVOASProductionConsumptionStaging
	(
	 OASProdConID			INT	IDENTITY	
	,DataType				VARCHAR(10)	
	,Sender					VARCHAR(50)	
	,Country				VARCHAR(50)		
	,RABAID					INT
	,Location				VARCHAR(50)		
	,OverRideLocation		VARCHAR(50)		
	,PostingDate			VARCHAR(8)		
	,PostingTime			VARCHAR(6)	
	,MovementDate 			SMALLDATETIME
	,CumulativeQty			VARCHAR(2)	
	,PersonToBeNotified		VARCHAR(50) 	
	,Comment				VARCHAR(Max)	
	,DummyField				VARCHAR(200)	
	,Plant					VARCHAR(50)  
	,RALocaleID				INT
	,StorageLocation		VARCHAR(50)  	
	,SAPMaterialNo			VARCHAR(50)	
	,RAPrdctID				INT
	,LegacyMaterialNo		VARCHAR(50)	
	,MaterialIndicator		VARCHAR(10)		
	,Batch					VARCHAR(2)
	,[Sign]					VARCHAR(1)
	,BaseQty				FLOAT
	,BaseUnitMeasurement	VARCHAR(10)
	,RAUOM					SMALLINT
	,Temperature			FLOAT
	,TemperatureUnit		Varchar(10)		
	,Density				FLOAT
	,AirBuoyancyIndicator	VARCHAR(2)
	,CostCenter				VARCHAR(50)
	,ReasonCode				VARCHAR(50)
	,DetailDummyField		VARCHAR(50)
	,QtyGALFAH				FLOAT
	,QtyBBLOBS				FLOAT
	,QtyLB					FLOAT	
	,QtyGALOBS				FLOAT
	,SourceInput			VARCHAR(20)
	,TicketStatus			CHAR(1)
	,ErrorMessage		VARCHAR(MAX)	
	,ImportDate			SMALLDATETIME
	,ModifiedDate		SMALLDATETIME
	,UserId				INT
	,ProcessedDate		SMALLDATETIME
	,InterfaceID		INT
	,MvmntDctID			INT
	,MvmntHdrID			INT
CONSTRAINT [PK_MTVOASProductionConsumptionStaging] PRIMARY KEY CLUSTERED 
(
	[OASProdConID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVOASProductionConsumptionStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVOASProductionConsumptionStaging.sql'
    PRINT '<<< CREATED TABLE MTVOASProductionConsumptionStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVOASProductionConsumptionStaging >>>'


