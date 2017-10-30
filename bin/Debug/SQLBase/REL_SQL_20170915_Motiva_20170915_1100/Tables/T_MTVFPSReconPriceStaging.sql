/****** Object:  ViewName [dbo].[T_MTVFPSReconPriceStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVFPSReconPriceStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVFPSReconPriceStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
    Begin
        exec SRA_Drop_Table @s_table='MTVFPSReconPriceStaging',@onlySQL='N',@verbose='Y';
    End
GO
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVFPSReconPriceStaging',
@s_sql=' (
SID						int				Identity,
RunID					int				NULL,
InterfaceStatus			char(1)			NULL,
InterfaceMessage		varchar(max)	NULL,
InterfaceFile			varchar(255)	NULL,
ExportDate				smalldatetime	NULL,
ModifyDate				smalldatetime	Null, 
UserId					int				Null,		
CreatedDate				smalldatetime	Not Null Default Current_TimeStamp,
	i_gpr_PriceCurveId  INT NULL,
	StageID  INT NULL,
	i_gpr_condition_type VARCHAR(10) NOT NULL,
	CurrentValue FLOAT NOT NULL,
	CreatedOrModifiedDate SMALLDATETIME NOT NULL,
	RALocaleID INT  NULL,
	RAProductID INT NULL,
	RABAID INT  NULL,
	RAUOMID smallint  NULL,
	RACurrencyID INT NULL,
	ValidFromDate SMALLDATETIME NULL,
	ValidToDate	SMALLDATETIME NULL,
	i_gpr_rec_type varchar(10) NULL,
	i_gpr_cou_code varchar(10) NULL,
	i_gpr_condition_table varchar(10) NULL,
	i_gpr_sold_to_code varchar(20) NULL,
    i_gpr_ship_to_code varchar(20) NULL,
	i_gpr_product varchar(20) NULL,
	i_gpr_plant_code varchar(10) NULL,
	i_gpr_UOM varchar(10) NULL,
	i_gpr_currency varchar(10) NULL,
	i_gpr_calculation_type varchar(5) NULL,
	i_gpr_rate FLOAT NULL,
	i_gpr_rate_unit varchar(10) NULL,
	i_gpr_kosrt varchar(20) NULL,
	i_gpr_validfrom varchar(10) NULL,
	i_gpr_validto varchar(10) NULL,
	i_gpr_start_time varchar(10) NULL,
	i_gpr_end_time varchar(10) NULL,
	i_gpr_quantity varchar(20) NULL,
	i_gpr_cond_tab_usage varchar(5) NULL,
	RawPriceDtlIdnty varchar(20) NULL
    )';
GO

Execute SRA_Index_Check @s_table	= 'MTVFPSReconPriceStaging', 
                    @s_index		= 'PK_MTVFPSReconPriceStaging_SID',
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

IF  OBJECT_ID(N'[dbo].[MTVFPSReconPriceStaging]') IS NOT NULL
  BEGIN
    EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'T_MTVFPSReconPriceStaging.sql'
    PRINT '<<< CREATED TABLE MTVFPSReconPriceStaging >>>'
  END
ELSE
     PRINT '<<< FAILED CREATING TABLE MTVFPSReconPriceStaging >>>'

