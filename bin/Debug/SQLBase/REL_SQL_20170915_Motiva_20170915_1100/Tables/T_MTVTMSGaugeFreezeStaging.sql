/****** Object:  ViewName [dbo].[T_MTVTMSGaugeFreezeStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTMSGaugeFreezeStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSGaugeFreezeStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		PRINT '<<< Dropping Table: MTVTMSGaugeFreezeStaging >>>'
		exec SRA_Drop_Table @s_table='MTVTMSGaugeFreezeStaging',@onlySQL='N',@verbose='Y';
	End
GO
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVTMSGaugeFreezeStaging',
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
RADealDtlID	smallint		NULL,
RAPhysicalInventoryID int	NULL,

action char (1) NULL,
term_id varchar (7) NULL,
folio_mo varchar (2) NULL,
folio_no varchar (3) NULL,
tank    varchar (4) NULL,
prod_code varchar (6) NULL,
gals_bbls_ind char (1) NULL,
inv_date varchar (6) NULL,
inv_time varchar (4) NULL,
inv_user varchar (3) NULL,
inv_status char (1) NULL,
temperature varchar (6) NULL,
grav_density varchar (6) NULL,
water_level varchar (6) NULL,
prod_level varchar (6) NULL,
line_fill varchar (9) NULL,
net_inv varchar (9) NULL,
gross_inv varchar (9) NULL,
rvp varchar (3) NULL,
comments varchar(40) NULL,
bulk_receipts varchar(9) NULL,
bulk_disposals varchar(9) NULL,
other_receipts varchar(9) NULL,
other_disposals varchar(9) NULL,
rack_disposals varchar(9) NULL,
tank_book varchar(9) NULL,
memo_thruput varchar(9) NULL,
memo_receipts varchar(9) NULL,
ambient_temperature varchar(6) NULL,
user_id varchar(10) NULL,
FileCreationDate smalldatetime			NULL,
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

Execute SRA_Index_Check @s_table	= 'MTVTMSGaugeFreezeStaging', 
				    @s_index		= 'PK_MTVTMSGaugeFreezeStaging_MESID',
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

IF  OBJECT_ID(N'[dbo].[MTVTMSGaugeFreezeStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'T_MTVTMSGaugeFreezeStaging.sql'
    PRINT '<<< CREATED TABLE MTVTMSGaugeFreezeStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTMSGaugeFreezeStaging >>>'

