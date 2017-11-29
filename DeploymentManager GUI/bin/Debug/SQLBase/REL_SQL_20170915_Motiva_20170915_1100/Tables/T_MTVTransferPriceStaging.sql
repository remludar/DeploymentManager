/****** Object:  ViewName [dbo].[T_MTVTransferPriceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTransferPriceStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTransferPriceStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
    Begin
        exec SRA_Drop_Table @s_table='MTVTransferPriceStaging',@onlySQL='N',@verbose='Y';
    End
GO
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVTransferPriceStaging',
@s_sql=' (
SID						int				Identity,
RunID					int				NULL,
RASnapshotID			int				NULL,
RASnapshotEOD			smalldatetime		NULL,
RAPriceCurveID			int				NULL,
RAPriceType				varchar(20)		NULL,
RARiskCurveID			int				NULL,
RARiskCurveValueID		int				NULL,
RARiskCurveValueEOD		smalldatetime		NULL,
RAProductID				int				NULL,
RALcleID				int				NULL,
RAQuoteFromDate			smalldatetime		NULL,
RAQuoteToDate			smalldatetime		NULL,
RAValue					float			NULL,
RAUOM					int				NULL,
RACurveName				varchar(100)	NULL,
RACurveType				varchar(20)		NULL,
TPEffectiveFromDate		smalldatetime	NULL,
TPEffectiveToDate		smalldatetime	NULL,
TPPlantCode				Varchar(20)		NULL,
TPSiteRefFlag			Varchar(10)		NULL,
TPIntSalesDistrictCode	Varchar(10)		NULL,
TPProdCode				Varchar(20)		NULL,
TPProdRefFlag			Varchar(10)		NULL,
TPCountryCode			Varchar(5)		NULL,
TPRecType				Varchar(20)		NULL,
TPCondTab				Varchar(10)		NULL,
TPValue					float			NULL,
TPUOM					varchar(10)		NULL,
TPPriceCode				varchar(10)     NULL,
PriceErrors				char(1)			Not Null Default ''N'',
PriceValidationMessage  varchar(max)	NULL,
InterfaceAction			char(1)			NULL,
InterfaceStatus			char(1)			NULL,
InterfaceMessage		varchar(max)	NULL,
InterfaceFile			varchar(255)	NULL,
InterfaceID				varchar(20)		NULL,
ExportDate				smalldatetime	NULL,
ModifyDate				smalldatetime	Null, 
UserId					int				Null,		
CreatedDate				smalldatetime	Not Null Default Current_TimeStamp
    )';
GO

Execute SRA_Index_Check @s_table	= 'MTVTransferPriceStaging', 
                    @s_index		= 'PK_MTVTransferPriceStaging_SID',
                    @s_keys			= 'SID',
                    @c_unique		= 'Y',
                    @c_clustered	= 'N',
                    @c_primarykey	= 'Y',
                    @c_uniquekey	= 'N',
                    @c_build_index	= 'Y',
                    @vc_domain		= 'Interfaces';
                    
GO
        
    
SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVTransferPriceStaging]') IS NOT NULL
  BEGIN
    EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'T_MTVTransferPriceStaging.sql'
    PRINT '<<< CREATED TABLE MTVTransferPriceStaging >>>'
  END
ELSE
     PRINT '<<< FAILED CREATING TABLE MTVTransferPriceStaging >>>'

