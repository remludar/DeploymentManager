---Start of Script: MTVOASInventoryStaging.table.sql
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

PRINT 'Start Script=t_MTVOASInventoryStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

--****************************************************************************************************************
-- Name:       MTVOASInventoryStaging                                             Copyright 2012 SolArc
-- Overview:   Table Creation Script: MTVOASInventoryStaging 
-- History:    19 Jul 2016 - First Created
--****************************************************************************************************************
-- Date         Modified        Issue#      Modification
-- -----------  --------------  ----------  -----------------------------------------------------------------------
-- 22 Sep 2016   Isaac Jacob       N/A         Initial Creation
------------------------------------------------------------------------------------------------------------------



Create Table dbo.tmp_MTVOASInventoryStaging
	(
	 OASInvID					INT	IDENTITY	
	,DataType					VARCHAR(10)	
	,Sender						VARCHAR(50)
	,Country					VARCHAR(50)		
	,RABAID						INT	
	,Location					VARCHAR(50)
	,RAInvLcleID				INT
	,OverRideLocation			VARCHAR(50)	
	,PostingDate				VARCHAR(8)		
	--,PostingTime				VARCHAR(6)	
	,MovementDate				SMALLDATETIME
	,Dummy						VARCHAR(200)
	,SpecialStockIndicator		VARCHAR(2)	
	,PersonToBeNotified			VARCHAR(50) 	
	,Comment					VARCHAR(200)
	,DummyField					VARCHAR(200)	
	,Plant						VARCHAR(50)  
	,RALocaleID					INT	
	,StorageLocation			VARCHAR(50)  	
	,SAPMaterialNumber			VARCHAR(50)	
	,RAPrdctID					INT
	,LegacyMaterialNumber		VARCHAR(50)	
	,DetailDummyFieldObsolete1	VARCHAR(10)
	--,MaterialIndicator		VARCHAR(10)	
	,Batch						VARCHAR(2)
	,[Sign]						VARCHAR(1)
	,BaseQty					FLOAT
	,BaseUnitMeasurement		VARCHAR(10)
	,RAUOM						SMALLINT
	,Temperature				FLOAT
	,TemperatureUnit			VARCHAR(10)		
	,Density					FLOAT
	,AirBuoyancyIndicator		VARCHAR(2)	
	,TimeOfCount				VARCHAR(50)
	,DetailDummyFieldObsolete2	VARCHAR(50)
	,DetailDummyField			VARCHAR(50)
	,QtyGALFAH					FLOAT	
	,QtyBBLOBS					FLOAT
	,QtyLB						FLOAT	
	,QtyGALOBS					FLOAT
	,SourceInput				VARCHAR(20)
	,TicketStatus				CHAR(1)
	,ErrorMessage				VARCHAR(MAX)	
	,ImportDate					SMALLDATETIME
	,ModifiedDate				SMALLDATETIME
	,UserId						INT
	,ProcessedDate				SMALLDATETIME
	,InterfaceID				INT
	,MvmntDctID					INT
	,MvmntHdrID					INT)
GO


SET IDENTITY_INSERT dbo.tmp_MTVOASInventoryStaging ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVOASInventoryStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    IF EXISTS(SELECT * FROM dbo.MTVOASInventoryStaging)
        EXEC('
			INSERT INTO [dbo].[tmp_MTVOASInventoryStaging]
           (OASInvID
		   ,[DataType]
           ,[Sender]
           ,[Country]
           ,[RABAID]
           ,[Location]
           ,[RAInvLcleID]
		   ,[OverRideLocation]
           ,[PostingDate]
           ,[MovementDate]
           ,[Dummy]
           ,[SpecialStockIndicator]
           ,[PersonToBeNotified]
           ,[Comment]
           ,[DummyField]
           ,[Plant]
           ,[RALocaleID]
           ,[StorageLocation]
           ,[SAPMaterialNumber]
           ,[RAPrdctID]
           ,[LegacyMaterialNumber]
           ,[DetailDummyFieldObsolete1]
           ,[Batch]
           ,[Sign]
           ,[BaseQty]
           ,[BaseUnitMeasurement]
           ,[RAUOM]
           ,[Temperature]
           ,[TemperatureUnit]
           ,[Density]
           ,[AirBuoyancyIndicator]
           ,[TimeOfCount]
           ,[DetailDummyFieldObsolete2]
           ,[DetailDummyField]
           ,[QtyGALFAH]
           ,[QtyBBLOBS]
           ,[QtyLB]
           ,[QtyGALOBS]
           ,[SourceInput]
           ,[TicketStatus]
           ,[ErrorMessage]
           ,[ImportDate]
           ,[ModifiedDate]
           ,[UserId]
           ,[ProcessedDate]
           ,[InterfaceID]
           ,[MvmntDctID]
           ,[MvmntHdrID])
SELECT [OASInvID]
      ,[DataType]
      ,[Sender]
      ,[Country]
      ,[RABAID]
      ,[Location]
      ,[RAInvLcleID]
	  ,NUll
      ,[PostingDate]
      ,[MovementDate]
      ,[Dummy]
      ,[SpecialStockIndicator]
      ,[PersonToBeNotified]
      ,[Comment]
      ,[DummyField]
      ,[Plant]
      ,[RALocaleID]
      ,[StorageLocation]
      ,[SAPMaterialNumber]
      ,[RAPrdctID]
      ,[LegacyMaterialNumber]
      ,[DetailDummyFieldObsolete1]
      ,[Batch]
      ,[Sign]
      ,[BaseQty]
      ,[BaseUnitMeasurement]
      ,[RAUOM]
      ,[Temperature]
      ,[TemperatureUnit]
      ,[Density]
      ,[AirBuoyancyIndicator]
      ,[TimeOfCount]
      ,[DetailDummyFieldObsolete2]
      ,[DetailDummyField]
      ,[QtyGALFAH]
      ,[QtyBBLOBS]
      ,[QtyLB]
      ,[QtyGALOBS]
      ,[SourceInput]
      ,[TicketStatus]
      ,[ErrorMessage]
      ,[ImportDate]
      ,[ModifiedDate]
      ,[UserId]
      ,[ProcessedDate]
      ,[InterfaceID]
      ,[MvmntDctID]
      ,[MvmntHdrID]
  FROM [dbo].[MTVOASInventoryStaging]
  WITH   (HOLDLOCK TABLOCKX)')
            
    IF @@ROWCOUNT >= 0
        PRINT 'Records copied from original table: ' + cast(@@ROWCOUNT as varchar)

  End

  GO
SET IDENTITY_INSERT dbo.tmp_MTVOASInventoryStaging OFF
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVOASInventoryStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    DROP TABLE dbo.MTVOASInventoryStaging
    PRINT '<<< DROPPED TABLE MTVOASInventoryStaging >>>'
  End
GO
EXECUTE sp_rename N'dbo.tmp_MTVOASInventoryStaging', N'MTVOASInventoryStaging', 'OBJECT' 
GO

ALTER TABLE dbo.MTVOASInventoryStaging WITH NOCHECK
    ADD CONSTRAINT [PK_MTVOASInventoryStaging] PRIMARY KEY CLUSTERED 
    ([OASInvID] ASC )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO


/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights to public and notify user
--------------------------------------------*/
If OBJECT_ID('MTVOASInventoryStaging') Is NOT Null
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVOASInventoryStaging.sql'
    PRINT '<<< CREATED TABLE MTVOASInventoryStaging >>>'
    if exists (select * from dbo.sysusers where name = N'sysuser')
        Grant select, insert, update, delete on dbo.MTVOASInventoryStaging to sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating Table MTVOASInventoryStaging>>>'
GO



