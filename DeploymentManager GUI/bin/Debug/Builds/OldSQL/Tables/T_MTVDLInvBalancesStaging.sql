/*
*****************************************************************************************************
--USE FIND AND REPLACE ON CompanyNameTABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDLInvBalancesStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDLInvBalancesStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDLInvBalancesStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDLInvBalancesStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDLInvBalancesStaging]
    PRINT '<<< DROPPED TABLE MTVDLInvBalancesStaging >>>'
END


/****** Object:  Table [dbo].[MTVDLInvBalancesStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create table MTVDLInvBalancesStaging
			(
			ID										Int	IDENTITY,
			AccountingMonth							Varchar(20),
			DealNumber								Varchar(20),
			DetailNumber							Int,
			BlendProduct							Char(3),
			ThirdPartyFlag							Varchar(255),
			EquityTerminalIndicator					Varchar(255),
			DealType								Varchar(80),
			StorageLocation							Varchar(255),
			ProductName								Varchar(150),
			RegradeProductName						Varchar(150),
			ProductGroup							Varchar(150),
			Subgroup								Varchar(150),
			MSAPPlantNumber							Varchar(255),
			MSAPMaterialNumber						Varchar(255),
			TradingBook								Varchar(120),
			ProfitCenter							Varchar(255),
			BegInvVolume							Decimal(19,6),
			EndingInvVolume							Decimal(19,6),
			UOM										Varchar(20),
			PerUnitValue							Decimal(19,6),
			EndingInvValue							Decimal(19,6),
			LocationCity							Varchar(255),
			LocationState							Varchar(255),
			LocationAddress							Varchar(255),
			LocationTCN								Varchar(255),
			LocationZip								Varchar(255),
			LocationType							Varchar(80),
			TerminalOperator						Varchar(255),
			PositionHolderName						Varchar(70),
			PositionHolderFEIN						Varchar(255),
			PositionHolderNameControl				Varchar(255),
			PositionHolderID						Varchar(255),
			LocationID								Int,
			FTAProductCode							Varchar(255),
			RATaxCommodity							Varchar(80),
			RegradeProductFTACode					Varchar(255),
			RegradeProductTaxCommodity				Varchar(80),
			TotalReceipts							Decimal(19,6),
			TotalDisbursement						Decimal(19,6),
			TotalBlend								Decimal(19,6),
			GainLoss								Decimal(19,6),
			BookAdjReason							Varchar(255),
			EndingPhysicalBalance					Decimal(19,6),
			GradeOfProduct							Varchar(255),
			StagingTableLoadDate					Smalldatetime,
			Status									Char(1)

CONSTRAINT [PK_MTVDLInvBalancesStaging] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDLInvBalancesStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDLInvBalancesStaging.sql'
    PRINT '<<< CREATED TABLE MTVDLInvBalancesStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDLInvBalancesStaging >>>'

