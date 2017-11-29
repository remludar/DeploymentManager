/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVPhysicalDealArchiveEntries WITH YOUR TABLE (NOTE: GN is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVPhysicalDealArchiveEntries]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVPhysicalDealArchiveEntries.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVPhysicalDealArchiveEntries]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVPhysicalDealArchiveEntries]') IS NOT NULL
BEGIN
	Declare @Sql VARCHAR(max)

	IF EXISTS (SELECT 1 FROM syscolumns WHERE name = 'Trdr' AND id = object_id(N'MTVPhysicalDealArchiveEntries'))
	BEGIN
		SELECT @Sql = '
		Create Table #MTVPhysicalDealArchiveEntriesTemp
		(
			ID							Int,
			DlHdrID 					Int,
			DlHdrArchveID				Int,
			DlDtlArchveID				Int,
			DlHdrIntrnlUserID			Int,
			DlHdrExtrnlCntctID			Int,
			DlHdrIntrnlNbr 				VarChar(20),
			DlHdrIntrnlBAID				Int,
			DlHdrExtrnlBAID 			Int,
			DlHdrTyp 					SmallInt,
			Term 						Char(3),
			DlHdrDsplyDte				SmallDateTime,
			DlHdrFrmDte					SmallDateTime,
			DlHdrToDte					SmallDateTime,
			DlHdrStat 					Char(1),
			DlHdrIntrnlPpr 				Char(1),
			DlHdrRvsnUserID 			Int,
			DlHdrCrtnDte				SmallDateTime,
			DlHdrRvsnDte				SmallDateTime,
			DlHdrRvsnLvl 				SmallInt,
			DlDtlID 					SmallInt,
			DlDtlSpplyDmnd 				Char(1),
			DlDtlFrmDte					SmallDateTime,
			DlDtlToDte					SmallDateTime,
			DlDtlQntty					Float(8),
			DlDtlDsplyUOM 				SmallInt,
			DlDtlPrdctID 				Int,
			DlDtlLcleID 				Int,
			DlDtlMthdTrnsprttn 			Char(1),
			DlDtlTrmTrmID 				Int,
			DetailStatus				Char(1),
			DlDtlCrtnDte				SmallDateTime,
			DlDtlRvsnDte				SmallDateTime,
			DlDtlRvsnLvl 				SmallInt,
			StrtgyID					Int,
			DlDtlPrvsnID				Int,
			PrvsnDscrptn				VarChar(80),
			PricingText1				VarChar(5000),
			Actual						Char(1),
			CostType					Char(1),
			DlDtlPrvsnMntryDrctn		Char(1),
			DeletedDetailStatus			Char(1),
			DeletedDetailID				Int,
			DlDtlIntrnlUserID			Int,
			DeliveryTermID				Int NULL
		)

		INSERT INTO #MTVPhysicalDealArchiveEntriesTemp
		SELECT 
		ID						
		,DlHdrID 				
		,DlHdrArchveID	
		,null		
		,DlHdrIntrnlUserID		
		,DlHdrExtrnlCntctID		
		,DlHdrIntrnlNbr 	
		,(SELECT TOP 1 DlHdrIntrnlBAID from DealHeader where MTVPhysicalDealArchiveEntries.DlHdrID = DealHeader.DlHdrID)	
		,DlHdrExtrnlBAID 		
		,DlHdrTyp 				
		,Term 					
		,DlHdrDsplyDte			
		,DlHdrFrmDte				
		,DlHdrToDte				
		,DlHdrStat 				
		,DlHdrIntrnlPpr 			
		,DlHdrRvsnUserID 		
		,DlHdrCrtnDte			
		,DlHdrRvsnDte			
		,DlHdrRvsnLvl 			
		,DlDtlID 				
		,DlDtlSpplyDmnd 			
		,DlDtlFrmDte				
		,DlDtlToDte				
		,DlDtlQntty				
		,DlDtlDsplyUOM 			
		,DlDtlPrdctID 			
		,DlDtlLcleID 			
		,DlDtlMthdTrnsprttn 		
		,DlDtlTrmTrmID 			
		,DetailStatus			
		,DlDtlCrtnDte			
		,DlDtlRvsnDte			
		,DlDtlRvsnLvl 			
		,StrtgyID	
		,null			
		,PrvsnDscrptn			
		,PricingText1			
		,Actual					
		,CostType				
		,DlDtlPrvsnMntryDrctn	
		,DeletedDetailStatus		
		,DeletedDetailID			
		,(SELECT TOP 1 UserID from Users inner join Contact on UserCntctID = CntctID and CntctLstNme + '', '' + CntctFrstNme = Trdr)
		,DeliveryTermID			
		FROM MTVPhysicalDealArchiveEntries

		drop table MTVPhysicalDealArchiveEntries

		Create Table MTVPhysicalDealArchiveEntries
		(
			ID							Int IDENTITY(1,1) PRIMARY KEY,
			DlHdrID 					Int,
			DlHdrArchveID				Int,
			DlDtlArchveID				Int,
			DlHdrIntrnlUserID			Int,
			DlHdrExtrnlCntctID			Int,
			DlHdrIntrnlNbr 				VarChar(20),
			DlHdrIntrnlBAID				Int,
			DlHdrExtrnlBAID 			Int,
			DlHdrTyp 					SmallInt,
			Term 						Char(3),
			DlHdrDsplyDte				SmallDateTime,
			DlHdrFrmDte					SmallDateTime,
			DlHdrToDte					SmallDateTime,
			DlHdrStat 					Char(1),
			DlHdrIntrnlPpr 				Char(1),
			DlHdrRvsnUserID 			Int,
			DlHdrCrtnDte				SmallDateTime,
			DlHdrRvsnDte				SmallDateTime,
			DlHdrRvsnLvl 				SmallInt,
			DlDtlID 					SmallInt,
			DlDtlSpplyDmnd 				Char(1),
			DlDtlFrmDte					SmallDateTime,
			DlDtlToDte					SmallDateTime,
			DlDtlQntty					Float(8),
			DlDtlDsplyUOM 				SmallInt,
			DlDtlPrdctID 				Int,
			DlDtlLcleID 				Int,
			DlDtlMthdTrnsprttn 			Char(1),
			DlDtlTrmTrmID 				Int,
			DetailStatus				Char(1),
			DlDtlCrtnDte				SmallDateTime,
			DlDtlRvsnDte				SmallDateTime,
			DlDtlRvsnLvl 				SmallInt,
			StrtgyID					Int,
			DlDtlPrvsnID				Int,
			PrvsnDscrptn				VarChar(80),
			PricingText1				VarChar(5000),
			Actual						Char(1),
			CostType					Char(1),
			DlDtlPrvsnMntryDrctn		Char(1),
			DeletedDetailStatus			Char(1),
			DeletedDetailID				Int,
			DlDtlIntrnlUserID			Int,
			DeliveryTermID				Int NULL
		)
		CREATE NONCLUSTERED INDEX [IX_MTVPhysicalDealArchiveEntries] ON [dbo].[MTVPhysicalDealArchiveEntries]
		(
			[DlHdrID] ASC,
			[DlHdrRvsnDte] DESC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		--SELECT * FROM #MTVPhysicalDealArchiveEntriesTemp

		SET IDENTITY_INSERT MTVPhysicalDealArchiveEntries ON

		INSERT INTO MTVPhysicalDealArchiveEntries
		(
		ID,DlHdrID,DlHdrArchveID,DlDtlArchveID,DlHdrIntrnlUserID,DlHdrExtrnlCntctID,DlHdrIntrnlNbr,DlHdrIntrnlBAID,DlHdrExtrnlBAID,DlHdrTyp,Term,DlHdrDsplyDte		
		,DlHdrFrmDte,DlHdrToDte,DlHdrStat,DlHdrIntrnlPpr,DlHdrRvsnUserID,DlHdrCrtnDte,DlHdrRvsnDte,DlHdrRvsnLvl,DlDtlID,DlDtlSpplyDmnd,DlDtlFrmDte			
		,DlDtlToDte,DlDtlQntty,DlDtlDsplyUOM,DlDtlPrdctID,DlDtlLcleID,DlDtlMthdTrnsprttn,DlDtlTrmTrmID,DetailStatus,DlDtlCrtnDte,DlDtlRvsnDte		
		,DlDtlRvsnLvl,StrtgyID,DlDtlPrvsnID,PrvsnDscrptn,PricingText1,Actual,CostType,DlDtlPrvsnMntryDrctn,DeletedDetailStatus,DeletedDetailID,DlDtlIntrnlUserID	
		,DeliveryTermID)
		SELECT * FROM #MTVPhysicalDealArchiveEntriesTemp

		SET IDENTITY_INSERT MTVPhysicalDealArchiveEntries OFF

		--SELECT * FROM MTVPhysicalDealArchiveEntries'
		EXEC (@Sql)
	END
	ELSE IF NOT EXISTS (SELECT 1 FROM syscolumns WHERE name = 'DlDtlPrvsnID' AND id = object_id(N'MTVPhysicalDealArchiveEntries'))
	BEGIN
		SELECT @Sql = '
		Create Table #MTVPhysicalDealArchiveEntriesTemp
		(
			ID							Int,
			DlHdrID 					Int,
			DlHdrArchveID				Int,
			DlDtlArchveID				Int,
			DlHdrIntrnlUserID			Int,
			DlHdrExtrnlCntctID			Int,
			DlHdrIntrnlNbr 				VarChar(20),
			DlHdrIntrnlBAID				Int,
			DlHdrExtrnlBAID 			Int,
			DlHdrTyp 					SmallInt,
			Term 						Char(3),
			DlHdrDsplyDte				SmallDateTime,
			DlHdrFrmDte					SmallDateTime,
			DlHdrToDte					SmallDateTime,
			DlHdrStat 					Char(1),
			DlHdrIntrnlPpr 				Char(1),
			DlHdrRvsnUserID 			Int,
			DlHdrCrtnDte				SmallDateTime,
			DlHdrRvsnDte				SmallDateTime,
			DlHdrRvsnLvl 				SmallInt,
			DlDtlID 					SmallInt,
			DlDtlSpplyDmnd 				Char(1),
			DlDtlFrmDte					SmallDateTime,
			DlDtlToDte					SmallDateTime,
			DlDtlQntty					Float(8),
			DlDtlDsplyUOM 				SmallInt,
			DlDtlPrdctID 				Int,
			DlDtlLcleID 				Int,
			DlDtlMthdTrnsprttn 			Char(1),
			DlDtlTrmTrmID 				Int,
			DetailStatus				Char(1),
			DlDtlCrtnDte				SmallDateTime,
			DlDtlRvsnDte				SmallDateTime,
			DlDtlRvsnLvl 				SmallInt,
			StrtgyID					Int,
			DlDtlPrvsnID				Int,
			PrvsnDscrptn				VarChar(80),
			PricingText1				VarChar(5000),
			Actual						Char(1),
			CostType					Char(1),
			DlDtlPrvsnMntryDrctn		Char(1),
			DeletedDetailStatus			Char(1),
			DeletedDetailID				Int,
			DlDtlIntrnlUserID			Int,
			DeliveryTermID				Int NULL
		)

		INSERT INTO #MTVPhysicalDealArchiveEntriesTemp
		SELECT 
		ID						
		,DlHdrID 				
		,DlHdrArchveID	
		,null		
		,DlHdrIntrnlUserID		
		,DlHdrExtrnlCntctID		
		,DlHdrIntrnlNbr 	
		,(SELECT TOP 1 DlHdrIntrnlBAID from DealHeader where MTVPhysicalDealArchiveEntries.DlHdrID = DealHeader.DlHdrID)	
		,DlHdrExtrnlBAID 		
		,DlHdrTyp 				
		,Term 					
		,DlHdrDsplyDte			
		,DlHdrFrmDte				
		,DlHdrToDte				
		,DlHdrStat 				
		,DlHdrIntrnlPpr 			
		,DlHdrRvsnUserID 		
		,DlHdrCrtnDte			
		,DlHdrRvsnDte			
		,DlHdrRvsnLvl 			
		,DlDtlID 				
		,DlDtlSpplyDmnd 			
		,DlDtlFrmDte				
		,DlDtlToDte				
		,DlDtlQntty				
		,DlDtlDsplyUOM 			
		,DlDtlPrdctID 			
		,DlDtlLcleID 			
		,DlDtlMthdTrnsprttn 		
		,DlDtlTrmTrmID 			
		,DetailStatus			
		,DlDtlCrtnDte			
		,DlDtlRvsnDte			
		,DlDtlRvsnLvl 			
		,StrtgyID	
		,null			
		,PrvsnDscrptn			
		,PricingText1			
		,Actual					
		,CostType				
		,DlDtlPrvsnMntryDrctn	
		,DeletedDetailStatus		
		,DeletedDetailID			
		,DlDtlIntrnlUserID
		,DeliveryTermID			
		FROM MTVPhysicalDealArchiveEntries

		drop table MTVPhysicalDealArchiveEntries

		Create Table MTVPhysicalDealArchiveEntries
		(
			ID							Int IDENTITY(1,1) PRIMARY KEY,
			DlHdrID 					Int,
			DlHdrArchveID				Int,
			DlDtlArchveID				Int,
			DlHdrIntrnlUserID			Int,
			DlHdrExtrnlCntctID			Int,
			DlHdrIntrnlNbr 				VarChar(20),
			DlHdrIntrnlBAID				Int,
			DlHdrExtrnlBAID 			Int,
			DlHdrTyp 					SmallInt,
			Term 						Char(3),
			DlHdrDsplyDte				SmallDateTime,
			DlHdrFrmDte					SmallDateTime,
			DlHdrToDte					SmallDateTime,
			DlHdrStat 					Char(1),
			DlHdrIntrnlPpr 				Char(1),
			DlHdrRvsnUserID 			Int,
			DlHdrCrtnDte				SmallDateTime,
			DlHdrRvsnDte				SmallDateTime,
			DlHdrRvsnLvl 				SmallInt,
			DlDtlID 					SmallInt,
			DlDtlSpplyDmnd 				Char(1),
			DlDtlFrmDte					SmallDateTime,
			DlDtlToDte					SmallDateTime,
			DlDtlQntty					Float(8),
			DlDtlDsplyUOM 				SmallInt,
			DlDtlPrdctID 				Int,
			DlDtlLcleID 				Int,
			DlDtlMthdTrnsprttn 			Char(1),
			DlDtlTrmTrmID 				Int,
			DetailStatus				Char(1),
			DlDtlCrtnDte				SmallDateTime,
			DlDtlRvsnDte				SmallDateTime,
			DlDtlRvsnLvl 				SmallInt,
			StrtgyID					Int,
			DlDtlPrvsnID				Int,
			PrvsnDscrptn				VarChar(80),
			PricingText1				VarChar(5000),
			Actual						Char(1),
			CostType					Char(1),
			DlDtlPrvsnMntryDrctn		Char(1),
			DeletedDetailStatus			Char(1),
			DeletedDetailID				Int,
			DlDtlIntrnlUserID			Int,
			DeliveryTermID				Int NULL
		)
		CREATE NONCLUSTERED INDEX [IX_MTVPhysicalDealArchiveEntries] ON [dbo].[MTVPhysicalDealArchiveEntries]
		(
			[DlHdrID] ASC,
			[DlHdrRvsnDte] DESC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

		--SELECT * FROM #MTVPhysicalDealArchiveEntriesTemp

		SET IDENTITY_INSERT MTVPhysicalDealArchiveEntries ON

		INSERT INTO MTVPhysicalDealArchiveEntries
		(
		ID,DlHdrID,DlHdrArchveID,DlDtlArchveID,DlHdrIntrnlUserID,DlHdrExtrnlCntctID,DlHdrIntrnlNbr,DlHdrIntrnlBAID,DlHdrExtrnlBAID,DlHdrTyp,Term,DlHdrDsplyDte		
		,DlHdrFrmDte,DlHdrToDte,DlHdrStat,DlHdrIntrnlPpr,DlHdrRvsnUserID,DlHdrCrtnDte,DlHdrRvsnDte,DlHdrRvsnLvl,DlDtlID,DlDtlSpplyDmnd,DlDtlFrmDte			
		,DlDtlToDte,DlDtlQntty,DlDtlDsplyUOM,DlDtlPrdctID,DlDtlLcleID,DlDtlMthdTrnsprttn,DlDtlTrmTrmID,DetailStatus,DlDtlCrtnDte,DlDtlRvsnDte		
		,DlDtlRvsnLvl,StrtgyID,DlDtlPrvsnID,PrvsnDscrptn,PricingText1,Actual,CostType,DlDtlPrvsnMntryDrctn,DeletedDetailStatus,DeletedDetailID,DlDtlIntrnlUserID	
		,DeliveryTermID)
		SELECT * FROM #MTVPhysicalDealArchiveEntriesTemp

		SET IDENTITY_INSERT MTVPhysicalDealArchiveEntries OFF

		--SELECT * FROM MTVPhysicalDealArchiveEntries'
		EXEC (@Sql)
	END
	ELSE Print '<<< Necessary table columns exist on MTVPhysicalDealArchiveEntries, do nothing >>>'
END
ELSE
BEGIN
	Create Table MTVPhysicalDealArchiveEntries
	(
		ID							Int IDENTITY(1,1) PRIMARY KEY,
		DlHdrID 					Int,
		DlHdrArchveID				Int,
		DlDtlArchveID				Int,
		DlHdrIntrnlUserID			Int,
		DlHdrExtrnlCntctID			Int,
		DlHdrIntrnlNbr 				VarChar(20),
		DlHdrIntrnlBAID				Int,
		DlHdrExtrnlBAID 			Int,
		DlHdrTyp 					SmallInt,
		Term 						Char(3),
		DlHdrDsplyDte				SmallDateTime,
		DlHdrFrmDte					SmallDateTime,
		DlHdrToDte					SmallDateTime,
		DlHdrStat 					Char(1),
		DlHdrIntrnlPpr 				Char(1),
		DlHdrRvsnUserID 			Int,
		DlHdrCrtnDte				SmallDateTime,
		DlHdrRvsnDte				SmallDateTime,
		DlHdrRvsnLvl 				SmallInt,
		--DlHdrRvsnTpe 				VarChar(20),
		DlDtlID 					SmallInt,
		DlDtlSpplyDmnd 				Char(1),
		DlDtlFrmDte					SmallDateTime,
		DlDtlToDte					SmallDateTime,
		DlDtlQntty					Float(8),
		DlDtlDsplyUOM 				SmallInt,
		DlDtlPrdctID 				Int,
		DlDtlLcleID 				Int,
		DlDtlMthdTrnsprttn 			Char(1),
		DlDtlTrmTrmID 				Int,
		DetailStatus				Char(1),
		DlDtlCrtnDte				SmallDateTime,
		DlDtlRvsnDte				SmallDateTime,
		DlDtlRvsnLvl 				SmallInt,
		StrtgyID					Int,
		DlDtlPrvsnID				Int,
		PrvsnDscrptn				VarChar(80),
		PricingText1				VarChar(5000),
		Actual						Char(1),
		CostType					Char(1),
		DlDtlPrvsnMntryDrctn		Char(1),
		--PriceType					VarChar(5000),
		--PricingTextAll				VarChar(5000),
		DeletedDetailStatus			Char(1),
		DeletedDetailID				Int,
		DlDtlIntrnlUserID			Int,
		DeliveryTermID				Int NULL
		--RevisionLevelStatusType		VarChar(20),
	)


	/****** Object:  Index [IX_MTVPhysicalDealArchiveEntries]    Script Date: 9/21/2016 3:12:04 PM ******/
	CREATE NONCLUSTERED INDEX [IX_MTVPhysicalDealArchiveEntries] ON [dbo].[MTVPhysicalDealArchiveEntries]
	(
		[DlHdrID] ASC,
		[DlHdrRvsnDte] DESC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
GO

IF  OBJECT_ID(N'[dbo].[MTVPhysicalDealArchiveEntries]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVPhysicalDealArchiveEntries.sql'
    PRINT '<<< CREATED TABLE MTVPhysicalDealArchiveEntries >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVPhysicalDealArchiveEntries >>>'
