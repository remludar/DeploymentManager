---Start of Script: MTVFPSFuelSalesVolStagingArchive.table.sql
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

Print 'Start Script=MTVFPSFuelSalesVolStagingArchive.table.sql  Domain=MPC  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

--****************************************************************************************************************
-- Name:       MTVFPSFuelSalesVolStaging                                             Copyright 2012 SolArc
-- Overview:   Table Creation Script: MTVFPSFuelSalesVolStaging 
-- History:    8 Aug - First Created
--****************************************************************************************************************
-- Date         Modified        Issue#      Modification
-- -----------  --------------  ----------  -----------------------------------------------------------------------
-- 19 Jul 2016   Isaac Jacob       N/A         Initial Creation
------------------------------------------------------------------------------------------------------------------


CREATE TABLE dbo.tmp_MTVFPSFuelSalesVolStaging
	(
	FFSVSID				INT	IDENTITY
	,CIIMssgQID			INT
	,Prefix				VARCHAR(80)
	,SequenceNumber		INT
	,SavRecType			VARCHAR(20)
	,SavCouCode			VARCHAR(20)  --
	,RABAID				INT		
	,SavSoldToCode		VARCHAR(20)
	,RATaxLocaleId		INT
	,SavSitCode			VARCHAR(20)
	,SavSitRefFlag		VARCHAR(1)
	,RALocaleId			INT
	,SavPlantCodeId		INT
	,SavPlantCode		VARCHAR(20)
	,RAProductId		INT
	,SavProCodeId		INT
	,SavProCode			VARCHAR(20)
	,SavProRefFlag		VARCHAR(1)
	,SavVolume			FLOAT
	,SavNetVolume		FLOAT
	,SavDateFrom		VARCHAR(8)
	,SavTimeFrom		VARCHAR(6)
	,SavDateTo			VARCHAR(8)
	,SavTimeTo			VARCHAR(7)
	,SavRangeFlag		VARCHAR(1)
	,SavType			VARCHAR(1)
	,SavInvNo			VARCHAR(20)
	,SavInvItem			VARCHAR(20)
	,FPSStatus			VARCHAR(1)
	,CreatedDate		SMALLDATETIME
	,UserId				INT
	,ModifiedDate		SMALLDATETIME
	,PublishedDate		SMALLDATETIME
	,Status				VARCHAR(1)
	,Message			VARCHAR(MAX)
	,InterfaceID		Int
	,MvtHdrDte			Smalldatetime NULL
	,AcctDtlID			INT 
	,DlHdrID			INT   
	,DtlDlDtlID			INT 
	,DealDetailID		INT 
	,MvtHdrID			INT)
GO


SET IDENTITY_INSERT dbo.tmp_MTVFPSFuelSalesVolStaging ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVFPSFuelSalesVolStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    IF EXISTS(SELECT * FROM dbo.MTVFPSFuelSalesVolStaging)
        EXEC('
         INSERT INTO [dbo].[tmp_MTVFPSFuelSalesVolStaging]
        (  [FFSVSID]
		   ,[CIIMssgQID]
           ,[Prefix]
           ,[SequenceNumber]
           ,[SavRecType]
           ,[SavCouCode]
           ,[RABAID]
           ,[SavSoldToCode]
           ,[RATaxLocaleId]
           ,[SavSitCode]
           ,[SavSitRefFlag]
           ,[RALocaleId]
           ,[SavPlantCodeId]
           ,[SavPlantCode]
           ,[RAProductId]
           ,[SavProCodeId]
           ,[SavProCode]
           ,[SavProRefFlag]
           ,[SavVolume]
           ,[SavNetVolume]
           ,[SavDateFrom]
           ,[SavTimeFrom]
           ,[SavDateTo]
           ,[SavTimeTo]
           ,[SavRangeFlag]
           ,[SavType]
           ,[SavInvNo]
           ,[SavInvItem]
           ,[FPSStatus]
           ,[CreatedDate]
           ,[UserId]
           ,[ModifiedDate]
           ,[PublishedDate]
           ,[Status]
           ,[Message]
           ,[InterfaceID]
		   ,[MvtHdrDte]
	       ,[AcctDtlID]
		   ,[DlHdrID]
		   ,[DtlDlDtlID]
		   ,[DealDetailID]
		   ,[MvtHdrID]
		   )
   SELECT
	   [FFSVSID]
      ,[CIIMssgQID]
      ,[Prefix]
      ,[SequenceNumber]
      ,[SavRecType]
      ,[SavCouCode]
      ,[RABAID]
      ,[SavSoldToCode]
      ,[RATaxLocaleId]
      ,[SavSitCode]
      ,[SavSitRefFlag]
      ,[RALocaleId]
      ,[SavPlantCodeId]
      ,[SavPlantCode]
      ,[RAProductId]
      ,[SavProCodeId]
      ,[SavProCode]
      ,[SavProRefFlag]
      ,[SavVolume]
      ,[SavNetVolume]
      ,[SavDateFrom]
      ,[SavTimeFrom]
      ,[SavDateTo]
      ,[SavTimeTo]
      ,[SavRangeFlag]
      ,[SavType]
      ,[SavInvNo]
      ,[SavInvItem]
      ,[FPSStatus]
      ,[CreatedDate]
      ,[UserId]
      ,[ModifiedDate]
      ,[PublishedDate]
      ,[Status]
      ,[Message]
      ,[InterfaceID]
	  ,Null
	  ,Null
	  ,Null
	  ,Null
	  ,Null
	  ,Null
  FROM [dbo].[MTVFPSFuelSalesVolStaging]
  WITH   (HOLDLOCK TABLOCKX)')
            
    IF @@ROWCOUNT >= 0
        PRINT 'Records copied from original table: ' + cast(@@ROWCOUNT as varchar)

  End
GO
SET IDENTITY_INSERT dbo.tmp_MTVFPSFuelSalesVolStaging OFF
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVFPSFuelSalesVolStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    DROP TABLE dbo.MTVFPSFuelSalesVolStaging
    PRINT '<<< DROPPED TABLE MTVFPSFuelSalesVolStaging >>>'
  End
GO
EXECUTE sp_rename N'dbo.tmp_MTVFPSFuelSalesVolStaging', N'MTVFPSFuelSalesVolStaging', 'OBJECT' 
GO

ALTER TABLE dbo.MTVFPSFuelSalesVolStaging WITH NOCHECK
    ADD CONSTRAINT [PK_MTVFPSFuelSalesVolStaging] PRIMARY KEY  CLUSTERED 
    (	[FFSVSID]  ASC )WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_MTVFPSFuelSalesVolStaging]    Script Date: 7/18/2017 4:07:25 PM ******/
CREATE NONCLUSTERED INDEX [IX_MTVFPSFuelSalesVolStaging] ON [dbo].[MTVFPSFuelSalesVolStaging]
(
	[CIIMssgQID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_MTVFPSFuelSalesVolStaging_1]    Script Date: 7/18/2017 4:07:25 PM ******/
CREATE NONCLUSTERED INDEX [IX_MTVFPSFuelSalesVolStaging_1] ON [dbo].[MTVFPSFuelSalesVolStaging]
(
	[CreatedDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


--select * from dbo.MTVFPSFuelSalesVolStaging 
/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights to public and notify user
--------------------------------------------*/
If OBJECT_ID('MTVFPSFuelSalesVolStaging') Is NOT Null
  BEGIN
    PRINT '<<< CREATED TABLE MTVFPSFuelSalesVolStaging >>>'
    if exists (select * from dbo.sysusers where name = N'sysuser')
        Grant select, insert, update, delete on dbo.MTVFPSFuelSalesVolStaging to sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating Table MTVFPSFuelSalesVolStaging>>>'
GO




