/****** Object:  ViewName [dbo].[T_MTVTMSGaugeStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTMSGaugeStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSGaugeStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		exec SRA_Drop_Table @s_table='MTVTMSGaugeStaging',@onlySQL='N',@verbose='Y';
	End
GO
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVTMSGaugeStaging',
@s_sql=' (
MESID				int				Identity,
RALcleID			int				NULL,
RAMvtTyp			char(1)			NULL,
RAMeasureDte		datetime		NULL,
RAPrdctID			int				NULL,
RABAID		int				NULL,
RASupplyDemand		char(1)  NULL,
RANetQty			float			NULL,
RAGrssQty		float			NULL,
RAUOM	smallint		NULL,
RAGravity		float			NULL,
RATemp		float			NULL,
RATempScale	char(1)			NULL,
RANote		varchar(MAX)	NULL,
RADealNo	varchar(50)		NULL,
RADealHdrID int				NULL,
RADealDtlID	int				NULL,
RAPhysicalInventoryID int	NULL,

recordType char (1) NULL,
term_id varchar (7) NULL,
folio_yr varchar (4) NULL,
folio_mo varchar (2) NULL,
folio_no varchar (3) NULL,
source char (1) NULL,
trans_seq_no varchar (4) NULL,
trans_ref_no varchar (10) NULL,
rec_no varchar (2) NULL,
trans_id varchar (3) NULL,
inv_no varchar (7) NULL,
out_seq_no varchar (4) NULL,
tran_date varchar (6) NULL,
tran_time varchar (4) NULL,
prod_id varchar (6) NULL,
prod_type char (1) NULL,
inv_status char (1) NULL,
sign char (1) NULL,
net_inv varchar (9) NULL,
gross_inv varchar (9) NULL,
supplier_no varchar (10) NULL,
gals_bbls_ind char (1) NULL,
tank varchar (4) NULL,
rvp varchar (3) NULL,
temperature varchar (6) NULL,
grav_density varchar (6) NULL,
water_level varchar (6) NULL,
prod_level varchar (6) NULL,
line_fill varchar (9) NULL,
tank_group varchar (4) NULL,


InterfaceStatus			char(1)			NULL,
InterfaceMessage		varchar(MAX)	NULL,
InterfaceFile			varchar(255)	NULL,
InterfaceID				varchar(20)		NULL,
Data					varchar(MAX)  NULL,
ImportDate				smalldatetime	Not Null Default Current_TimeStamp,
ModifyDate				smalldatetime	Null, 
UserId					int				Null,		
ProcessedDate			smalldatetime	NULL
	)';
GO

Execute SRA_Index_Check @s_table	= 'MTVTMSGaugeStaging', 
				    @s_index		= 'PK_MTVTMSGaugeStaging_MESID',
				    @s_keys			= 'MESID',
				    @c_unique		= 'Y',
				    @c_clustered	= 'N',
				    @c_primarykey	= 'Y',
				    @c_uniquekey	= 'N',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';
				    
GO

			
SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSGaugeStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'T_MTVTMSGaugeStaging.sql'
    PRINT '<<< CREATED TABLE MTVTMSGaugeStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTMSGaugeStaging >>>'

