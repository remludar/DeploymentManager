---Start of Script: MTVOASActualStaging.table.sql
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

PRINT 'Start Script=t_MTVOASActualStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

--****************************************************************************************************************
-- Name:       MTVOASActualStaging                                             Copyright 2012 SolArc
-- Overview:   Table Creation Script: MTVOASActualStaging 
-- History:    19 Jul 2016 - First Created
--****************************************************************************************************************
-- Date         Modified        Issue#      Modification
-- -----------  --------------  ----------  -----------------------------------------------------------------------
-- 19 Jul 2016   Isaac Jacob       N/A         Initial Creation
------------------------------------------------------------------------------------------------------------------

if not exists (select top 1 * from sys.columns
					where object_id = OBJECT_ID('dbo.MTVOASActualStaging')
					and name = 'SoldTo')
		ALTER TABLE dbo.MTVOASActualStaging
		ADD SoldTo VARCHAR(80)

if not exists (select top 1 * from sys.columns
					where object_id = OBJECT_ID('dbo.MTVOASActualStaging')
					and name = 'ShipTo')
		ALTER TABLE dbo.MTVOASActualStaging
		ADD ShipTo VARCHAR(80)

CREATE TABLE dbo.tmp_MTVOASActualStaging
	(
	 OASID					INT	IDENTITY
	,[Action]				CHAR(1)	
	,Sender					VARCHAR(50)
	,RACompanyBAID			INT
	,Country				VARCHAR(50)
	,TicketNumber			VARCHAR(50)
	,[Version]				VARCHAR(50)
	,Location				VARCHAR(50)
	,RALocaleID				INT
	,OverRideLocation		VARCHAR(50)	
	,PostingDate			DATETIME
	,CumulativeQuantityMTON VARCHAR(50)
	,PersonToBeNotified		VARCHAR(50) 
	,RAContactID			INT
	,Comment				VARCHAR(200)
	,ScheduleItemType 		CHAR(1)
	,EndDate				SMALLDATETIME
	,TransportID			VARCHAR(50)
	,RAMovementType			VARCHAR(2)
	,Port					VARCHAR(50)
	,PortDesc				VARCHAR(200)
	,RADestLocaleID			INT
	,BOLNumber				VARCHAR(50)
	,SequencNumber			INT
	,TSWNomNumber			VARCHAR(50)--Not sure yet
	,TSWNomTk				VARCHAR(50)
	,TSWItemNo				VARCHAR(50)
	,CommerceGrade			VARCHAR(50)	
	,RAPrdctID				INT
	,ActualQty				FLOAT
	,ActualQtyUOM			VARCHAR(10)	
	,RAUOM					SMALLINT
	,ActualQtyMTOM			VARCHAR(10)
	,ActualQtyKL15			VARCHAR(10)
	,ActualQtyOBS			VARCHAR(10)
	,ActualQtyBBLS			FLOAT
	,ActualQtySITE			VARCHAR(50)
	,ActualQtySITEUOM		VARCHAR(50)
	,ActualQtyM15			VARCHAR(50)
	,ActualQtyL				VARCHAR(50)
	,ActualQtyL30			VARCHAR(50)
	,ActualQtyLBS			FLOAT
	,ActualQtyKG			VARCHAR(50)
	,ActualQtyBBL			FLOAT
	,ActualQtyUGL			FLOAT
	,ActualQtyGAL			FLOAT
	,AirBuoyancyIndicator	VARCHAR(50)
	,AirBuoyancyFactor		VARCHAR(50)
	,Density				VARCHAR(50)
	,Temperature			FLOAT
	,OBSTempMeasureUnitID	Varchar(10)		--Notsure	
	,TestTemperature		VARCHAR(50)
	,TestTemperatureUOM		VARCHAR(50)
	,TicketStatus			CHAR(1)
	,ErrorMessage		VARCHAR(MAX)	
	,ImportDate			SMALLDATETIME
	,ModifiedDate		SMALLDATETIME
	,UserId				INT
	,ProcessedDate		SMALLDATETIME
	,InterfaceID		INT
	,MvmntDctID			INT
	,MvmntHdrID			INT	
	,SoldTo				varchar(80)
	,ShipTo				varchar(80)
	)
GO

declare @OrigRowCount int
set @OrigRowCount = (select count(*) from MTVOASActualStaging)

SET IDENTITY_INSERT dbo.tmp_MTVOASActualStaging ON
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVOASActualStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    IF EXISTS(SELECT * FROM dbo.MTVOASActualStaging)
        EXEC('
         INSERT INTO [dbo].[tmp_MTVOASActualStaging]
           (OASID
           ,[Action]
           ,[Sender]
           ,[RACompanyBAID]
           ,[Country]
           ,[TicketNumber]
           ,[Version]
           ,[Location]
           ,[RALocaleID]
           ,[OverRideLocation]
           ,[PostingDate]
           ,[CumulativeQuantityMTON]
           ,[PersonToBeNotified]
           ,[RAContactID]
           ,[Comment]
           ,[ScheduleItemType]
           ,[EndDate]
           ,[TransportID]
           ,[RAMovementType]
           ,[Port]
           ,[PortDesc]
           ,[RADestLocaleID]
           ,[BOLNumber]
           ,[SequencNumber]
           ,[TSWNomNumber]
           ,[TSWNomTk]
           ,[TSWItemNo]
           ,[CommerceGrade]
           ,[RAPrdctID]
           ,[ActualQty]
           ,[ActualQtyUOM]
           ,[RAUOM]
           ,[ActualQtyMTOM]
           ,[ActualQtyKL15]
           ,[ActualQtyOBS]
           ,[ActualQtyBBLS]
           ,[ActualQtySITE]
           ,[ActualQtySITEUOM]
           ,[ActualQtyM15]
           ,[ActualQtyL]
           ,[ActualQtyL30]
           ,[ActualQtyLBS]
           ,[ActualQtyKG]
           ,[ActualQtyBBL]
           ,[ActualQtyUGL]
           ,[ActualQtyGAL]
           ,[AirBuoyancyIndicator]
           ,[AirBuoyancyFactor]
           ,[Density]
           ,[Temperature]
           ,[OBSTempMeasureUnitID]
           ,[TestTemperature]
           ,[TestTemperatureUOM]
           ,[TicketStatus]
           ,[ErrorMessage]
           ,[ImportDate]
           ,[ModifiedDate]
           ,[UserId]
           ,[ProcessedDate]
           ,[InterfaceID]
           ,[MvmntDctID]
           ,[MvmntHdrID]
		   ,[SoldTo]
		   ,[ShipTo]
		   )
   SELECT 
	  [OASID]
      ,[Action]
      ,[Sender]
      ,[RACompanyBAID]
      ,[Country]
      ,[TicketNumber]
      ,[Version]
      ,[Location]
      ,[RALocaleID]
      ,[OverRideLocation]
      ,[PostingDate]
      ,[CumulativeQuantityMTON]
      ,[PersonToBeNotified]
      ,[RAContactID]
      ,[Comment]
      ,[ScheduleItemType]
      ,[EndDate]
      ,[TransportID]
      ,[RAMovementType]
      ,[Port]
      ,[PortDesc]
      ,[RADestLocaleID]
      ,[BOLNumber]
      ,[SequencNumber]
      ,[TSWNomNumber]
      ,[TSWNomTk]
      ,[TSWItemNo]
      ,[CommerceGrade]
      ,[RAPrdctID]
      ,[ActualQty]
      ,[ActualQtyUOM]
      ,[RAUOM]
      ,[ActualQtyMTOM]
      ,[ActualQtyKL15]
      ,[ActualQtyOBS]
      ,[ActualQtyBBLS]
      ,[ActualQtySITE]
      ,[ActualQtySITEUOM]
      ,[ActualQtyM15]
      ,[ActualQtyL]
      ,[ActualQtyL30]
      ,[ActualQtyLBS]
      ,[ActualQtyKG]
      ,[ActualQtyBBL]
      ,[ActualQtyUGL]
      ,[ActualQtyGAL]
      ,[AirBuoyancyIndicator]
      ,[AirBuoyancyFactor]
      ,[Density]
      ,[Temperature]
      ,[OBSTempMeasureUnitID]
      ,[TestTemperature]
      ,[TestTemperatureUOM]
      ,[TicketStatus]
      ,[ErrorMessage]
      ,[ImportDate]
      ,[ModifiedDate]
      ,[UserId]
      ,[ProcessedDate]
      ,[InterfaceID]
      ,[MvmntDctID]
      ,[MvmntHdrID]
	  ,[SoldTo]
	  ,[ShipTo]
  FROM [dbo].[MTVOASActualStaging]
  WITH   (HOLDLOCK TABLOCKX)')
            
  End
SET IDENTITY_INSERT dbo.tmp_MTVOASActualStaging OFF

declare @TempRowCount int
set @TempRowCount = (select count(*) from tmp_MTVOASActualStaging)

PRINT 'Records copied from original table: ' + cast(@TempRowCount as varchar)

declare @Success char(1)
set @Success = 'N'

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.tmp_MTVOASActualStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
   and exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVOASActualStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
   and (@OrigRowCount = 0 or @OrigRowCount = @TempRowCount)
  Begin
    DROP TABLE dbo.MTVOASActualStaging
    PRINT '<<< DROPPED TABLE MTVOASActualStaging >>>'
	EXECUTE sp_rename N'dbo.tmp_MTVOASActualStaging', N'MTVOASActualStaging', 'OBJECT'

	ALTER TABLE dbo.MTVOASActualStaging WITH NOCHECK
    ADD CONSTRAINT [PK_MTVOasActualStaging] PRIMARY KEY  CLUSTERED 
    (	[OASID]  ASC )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [BOLNumber] ON [dbo].[MTVOASActualStaging]
	(
		[BOLNumber] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	If OBJECT_ID('MTVOASActualStaging') Is NOT Null
	  BEGIN
		EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVOASActualStaging.sql'
		PRINT '<<< CREATED TABLE MTVOASActualStaging >>>'
		if exists (select * from dbo.sysusers where name = N'sysuser')
			Grant select, insert, update, delete on dbo.MTVOASActualStaging to sysuser, RightAngleAccess
		set @Success = 'Y'
	  END

  ELSE
	PRINT '<<< Issue Creating Tables or Maintaining Values from original table >>>'
  End


/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights to public and notify user
--------------------------------------------*/
If @Success = 'N'
    PRINT '<<<Failed Creating Table MTVOASActualStaging>>>'
GO



--select * from dbo.MTVOASActualStaging 
--drop table tmp_MTVOASActualStaging