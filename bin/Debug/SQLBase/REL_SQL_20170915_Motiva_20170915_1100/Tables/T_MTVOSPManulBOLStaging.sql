PRINT 'Start Script=t_MTVOSPManulBOLStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVOSPManulBOLStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVOSPManulBOLStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVOSPManulBOLStaging]
    PRINT '<<< DROPPED TABLE MTVOSPManulBOLStaging >>>'
END


/****** Object:  Table [dbo].[MTVOSPManulBOLStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE MTVOSPManulBOLStaging
			(
			MOMBSID				INT	IDENTITY
			,DocumentID				VARCHAR(32)	NULL
			,DocumentSequence		VARCHAR(20)	NULL
			,PartnerFrom			VARCHAR(60)	NULL
			,RAPartnerFromBAID		INT	NULL
			,PartnerTo				VARCHAR(60)	NULL
			,RAPartnerToBAID		INT	NULL
			,SourceDate				SMALLDATETIME	NULL
			--,SourceTime			VARCHAR(8)
			--,RecordType			VARCHAR(4)
			,ActionCode				VARCHAR(4)	NULL
			,LoadIdNumber			VARCHAR(60)	NULL
			,DocumentCategory		VARCHAR(60)	NULL
			,DocumentNumber			VARCHAR(60)	NULL
			,RADocumentID			INT	NULL
			,LoadEndDate			SMALLDATETIME	NULL
			--,LoadEndTime			VARCHAR(8)
			,LoadDepot				VARCHAR(60)	NULL
			,RALocaleId				INT	NULL
			,StLoc					VARCHAR(60)	NULL
			,RAStorageLcleID		INT	NULL
			,ModeofTransport		VARCHAR(60)	NULL
			,RAMvtHdrType			CHAR(2)	NULL
			,RADestLocaleId			INT	NULL
			,RACarrierBAID			INT	NULL
			,TruckID				VARCHAR(20)	NULL
			,TruckLic				VARCHAR(60)	NULL
			,TrailerID				VARCHAR(20)	NULL
			,TrailerLic				VARCHAR(60)	NULL
			,DriverID				VARCHAR(20)	NULL
			,DriverName				VARCHAR(80)	NULL
			,Compartment			VARCHAR(4)	NULL
			,BOLNumber				VARCHAR(32)	NULL
			,PartnerType1			VARCHAR(60)	NULL
			,PartnerID1				VARCHAR(20)	NULL
			,PartnerName1			VARCHAR(60)	NULL
			,RAPartner1BAID			INT	NULL
			,PartnerType2			VARCHAR(60)	NULL
			,PartnerID2				VARCHAR(20)	NULL
			,PartnerName2			VARCHAR(60)	NULL
			,RAPartner2BAID			INT	NULL
			,PartnerType3			VARCHAR(60)	NULL
			,PartnerID3				VARCHAR(20)	NULL
			,PartnerName3			VARCHAR(60)	NULL
			,RAPartner3BAID			INT	NULL
			,PartnerType4			VARCHAR(60)	NULL
			,PartnerID4				VARCHAR(20)	NULL
			,PartnerName4			VARCHAR(60)	NULL
			,RAPartner4BAID			INT	NULL
			,PartnerType5			VARCHAR(60)	NULL
			,PartnerID5				VARCHAR(20)	NULL
			,PartnerName5			VARCHAR(60)	NULL
			,RAPartner5BAID			INT	NULL
			,PartnerType6			VARCHAR(60)	NULL
			,PartnerID6				VARCHAR(20)	NULL
			,PartnerName6			VARCHAR(60)	NULL
			,RAPartner6BAID			INT	NULL
			,PartnerType7			VARCHAR(60)	NULL
			,PartnerID7				VARCHAR(20)	NULL
			,PartnerName7			VARCHAR(60)	NULL
			,RAPartner7BAID			INT	NULL
			,PartnerType8			VARCHAR(60)	NULL
			,PartnerID8				VARCHAR(20)	NULL
			,PartnerName8			VARCHAR(60)	NULL
			,RAPartner8BAID			INT	NULL
			,ProductCode			VARCHAR(60)	NULL
			,RAPrdctID				INT	NULL
			,ProductQuantity		FLOAT	NULL
			,UnitofMeasure			VARCHAR(12)	NULL
			,RAUOM					INT	NULL
			,ProductQuantity2		FLOAT	NULL
			,UnitofMeasure2			VARCHAR(12)	NULL
			,RAUOM2					INT	NULL
			,ProductQuantity3		FLOAT	NULL
			,UnitofMeasure3			VARCHAR(12)	NULL
			,RAUOM3					INT	NULL
			,ProductDensityTemp		FLOAT	NULL
			,ProdDensity			FLOAT	NULL
			,ProdDensityUoM			VARCHAR(12)	NULL
			,RAProdDensityUoM		INT	NULL
			,ProdTemp				FLOAT	NULL
			,ProdTempUoM			VARCHAR(12)		NULL
			,RAProdTempUoM			INT	NULL
			,AirBouncyInd			VARCHAR(20)	NULL
			,CompType1				VARCHAR(60)	NULL
			,CompCode1				VARCHAR(60)	NULL
			,RACompCode1			INT	NULL
			,Comp1Qty_1				FLOAT	NULL
			,Comp1UoM_1				VARCHAR(12)	NULL
			,RAComp1UoM_1			INT	NULL
			,Comp1Qty_2				FLOAT	NULL
			,Comp1UoM_2				VARCHAR(12)	NULL
			,RAComp1UoM_2			INT	NULL
			,Comp1Qty_3				FLOAT	NULL
			,Comp1UoM_3				VARCHAR(12)	NULL
			,RAComp1UoM_3			INT	NULL
			,CompType2				VARCHAR(60)	NULL
			,CompCode2				VARCHAR(60)	NULL
			,RACompCode2			INT	NULL
			,Comp2Qty_1				FLOAT	NULL
			,Comp2UoM_1				VARCHAR(12)	NULL
			,RAComp2UoM_1			INT	NULL
			,Comp2Qty_2				FLOAT	NULL
			,Comp2UoM_2				VARCHAR(12)	NULL
			,RAComp2UoM_2			INT	NULL
			,Comp2Qty_3				FLOAT	NULL
			,Comp2UoM_3				VARCHAR(12)	NULL
			,RAComp2UoM_3			INT	NULL
			,CompType3				VARCHAR(60)	NULL
			,CompCode3				VARCHAR(60)	NULL
			,RACompCode3			INT	NULL
			,Comp3Qty_1				FLOAT	NULL
			,Comp3UoM_1				VARCHAR(12)	NULL
			,RAComp3UoM_1			INT	NULL
			,Comp3Qty_2				FLOAT	NULL
			,Comp3UoM_2				VARCHAR(12)	NULL
			,RAComp3UoM_2			INT	NULL
			,Comp3Qty_3				FLOAT	NULL
			,Comp3UoM_3				VARCHAR(12)	NULL
			,RAComp3UoM_3			INT	NULL
			,CompType4				VARCHAR(60)	NULL
			,CompCode4				VARCHAR(60)	NULL
			,RACompCode4			INT	NULL
			,Comp4Qty_1				FLOAT	NULL
			,Comp4UoM_1				VARCHAR(12)	NULL
			,RAComp4UoM_1			INT	NULL
			,Comp4Qty_2				FLOAT	NULL
			,Comp4UoM_2				VARCHAR(12)	NULL
			,RAComp4UoM_2			INT	NULL
			,Comp4Qty_3				FLOAT	NULL
			,Comp4UoM_3				VARCHAR(12)	NULL
			,RAComp4UoM_3			INT	NULL
			,RefType1				VARCHAR(60)	NULL
			,RefNum1				VARCHAR(60)	NULL
			,RefItem1				VARCHAR(60)	NULL
			,RefType2				VARCHAR(60)	NULL
			,RefNum2				VARCHAR(60)	NULL
			,RefItem2				VARCHAR(60)	NULL
			,RefType3				VARCHAR(60)	NULL
			,RefNum3				VARCHAR(60)	NULL
			,RefItem3				VARCHAR(60)	NULL
			,RefType4				VARCHAR(60)	NULL
			,RefNum4				VARCHAR(60)	NULL
			,RefItem4				VARCHAR(60)	NULL
			,RefType5				VARCHAR(60)	NULL
			,RefNum5				VARCHAR(60)	NULL
			,RefItem5				VARCHAR(60)	NULL
			,RefType6				VARCHAR(60)	NULL
			,RefNum6				VARCHAR(60)	NULL
			,RefItem6				VARCHAR(60)	NULL
			,RefType7				VARCHAR(60)	NULL
			,RefNum7				VARCHAR(60)	NULL
			,RefItem7				VARCHAR(60)	NULL
			,RefType8				VARCHAR(60)	NULL
			,RefNum8				VARCHAR(60)	NULL
			,RefItem8				VARCHAR(60)	NULL
			,RefType9				VARCHAR(60)	NULL
			,RefNum9				VARCHAR(60)	NULL
			,RefItem9				VARCHAR(60)	NULL
			,RefType10				VARCHAR(60)	NULL
			,RefNum10				VARCHAR(60)	NULL
			,RefItem10				VARCHAR(60)	NULL
			,TicketStatus			CHAR(1)	NULL
			,ErrorMessage			VARCHAR(MAX)	NULL
			,ImportDate				SMALLDATETIME	NULL
			,ModifiedDate			SMALLDATETIME	NULL
			,UserId					INT	NULL
			,ProcessedDate			SMALLDATETIME	NULL
			,MvmntDctID				INT	NULL
	CONSTRAINT [PK_MTVOSPManulBOLStaging] PRIMARY KEY CLUSTERED 
(
	[MOMBSID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVOSPManulBOLStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVOSPManulBOLStaging.sql'
    PRINT '<<< CREATED TABLE MTVOSPManulBOLStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVOSPManulBOLStaging >>>'

