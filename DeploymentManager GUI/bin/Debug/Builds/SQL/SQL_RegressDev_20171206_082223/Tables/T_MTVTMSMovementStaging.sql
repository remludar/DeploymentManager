/****** Object:  ViewName [dbo].[T_MTVTMSMovementStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVTMSMovementStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO


--PRINT 'Creating Table = MTVTMSHeaderRawData'
--GO
--If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSHeaderRawData') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
--	Begin
--		--exec SRA_Drop_Table @s_table='MTVTMSHeaderRawData',@onlySQL='N',@verbose='Y';
--	End
--GO

If	not Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSHeaderRawData') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	PRINT 'Creating Table = MTVTMSHeaderRawData'
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVTMSHeaderRawData',
@s_sql=' (
TMSHDRID				int				Identity,
Staged					char(1)			NULL,
FileName			    varchar(255)	NULL,
LineID				    varchar(10)		NULL,
Data					varchar(MAX)	NULL,
CreatedDate				smalldatetime		NOT NULL,
recordType				char(1) NULL,
term_id					varchar(7)		NULL,
folio_yr				varchar(4)		NULL,
folio_mo				char(2)			NULL,
folio_no				char(3)			NULL,
trans_seq_no			varchar(4)		NULL,
trans_ref_no			varchar(10)		NULL,
doc_no					varchar(10)		NULL,
doc_no_suf				char(2)			NULL,
source					char(1)			NULL,
trans_id				char(3)			NULL,
reason					char(3)			NULL,
out_seq_no				varchar(4)		NULL,
supplier_no varchar(10) NULL,
cust_no varchar(10) NULL,
acct_no varchar(10) NULL,
destination_no varchar(10) NULL,
carrier varchar(7) NULL,
carrier_scac varchar(4) NULL,
driver varchar(8) NULL,
loader varchar(8) NULL,
order_rec_type char(1) NULL,
order_no varchar(10) NULL,
delv_seq char(2) NULL,
delv_confirmed char(1) NULL,
shift char(2) NULL,
contract_number varchar(20) NULL,
retail_site_num varchar(10) NULL,
credit_id varchar(14) NULL,
trip_no varchar(8) NULL,
truck varchar(10) NULL,
trailer1 varchar(10) NULL,
trailer2 varchar(10) NULL,
trailer3 varchar(10) NULL,
po_num varchar(15) NULL,
transaction_date varchar(6) NULL,
transaction_time varchar(4) NULL,
load_start_date varchar(6) NULL,
load_start_time varchar(4) NULL,
load_stop_date varchar(6) NULL,
load_stop_time varchar(4) NULL,
entry_date varchar(6) NULL,
entry_time varchar(4) NULL,
exit_date varchar(6) NULL,
exit_time varchar(4) NULL,
osp_ticket_no varchar(9) NULL,
delv_country char(2) NULL,
delv_state char(2) NULL,
delv_zone varchar(5) NULL,
cot_major char(2) NULL,
cot_minor char(3) NULL,
freight char(1) NULL,
err_code char(3) NULL,
supplier_type char(1) NULL,
cust_type char(1) NULL,
acct_type char(1) NULL,
edi_dest_code_id char(2) NULL,
edi_dest_comp_id varchar(5) NULL,
edi_dest_consignee varchar(14) NULL,
edi_auth_no varchar(8) NULL,
release_no varchar(10) NULL,
dest_splc_code varchar(9) NULL,
action char(1) NULL,
cancel_rebill char(1) NULL,
orig_doc_no varchar(10) NULL,
cancel_flag char(1) NULL,
input_no varchar(4) NULL,
tare_weight varchar(9) NULL,
auto_trans_ind char(1) NULL,
valuation_type varchar(10) NULL,
shipment_no varchar(10) NULL,
rec_type char(1) NULL,
detail_cnt char(2) NULL,
carrier_fein varchar(10) NULL,
tpt_ulsd_epa_id varchar(9) NULL,
acct_cons_ulsd_epa_id varchar(9) NULL,
chained_equity char(1) NULL,
orig_trans_id char(3) NULL,
supplier_id varchar(5) NULL,
host_seq_no varchar(6) NULL,
host_po_num varchar(20) NULL,
DutyToNumber varchar(10) NULL,
BadgeNumber varchar(4) NULL,
MOT char(1) NULL,
shipment_rec_type char(1) NULL,
freeform_txt varchar(25) NULL,
seal_type varchar(15) NULL,
bol_per_batch char(1) NULL,
UserID varchar(10) NULL,
ManualDateCreated varchar(10) NULL,
seal_total char(2) NULL,
vru_status char(1) NULL,
ShipmentOrigin char(2) NULL,
WeighMasterSeqNo varchar(14) NULL,
ar_acct_no varchar(14) NULL
	)';
PRINT '<<< CREATED TABLE MTVTMSHeaderRawData >>>'
END	
GO

Execute SRA_Index_Check @s_table	= 'MTVTMSHeaderRawData', 
				    @s_index		= 'PK_MTVTMSHeaderRawData_TMSHDRID',
				    @s_keys			= 'TMSHDRID',
				    @c_unique		= 'Y',
				    @c_clustered	= 'Y',
				    @c_primarykey	= 'Y',
				    @c_uniquekey	= 'Y',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';
				    
GO

SET ANSI_PADDING OFF
GO

--If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSProductRawData') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
--	Begin
----		exec SRA_Drop_Table @s_table='MTVTMSProductRawData',@onlySQL='N',@verbose='Y';
--	End
--GO




If	NOT Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSProductRawData') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	PRINT 'Creating Table = MTVTMSProductRawData'
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVTMSProductRawData',
@s_sql=' (
TMSPRDID				int				Identity,
TMSPRDHDRID				int				NOT NULL,
MVTTMSSTGID				int				NULL,
LineID					varchar(10)		NULL,
Data					varchar(MAX)  NULL,
CreatedDate				smalldatetime		NOT NULL, 
recordType char(1) NULL,	
trans_ref_no varchar(10) NULL,	
prod_rec_no char(2) NULL,	
prod_id varchar(6) NULL,	
pidx_prod char(3) NULL,	
on_spec char(1) NULL,	
uom char(1) NULL,	
sign char(1) NULL,	
gross varchar(9) NULL,	
net varchar(9) NULL,	
temperature varchar(6) NULL,	
grav_density varchar(6) NULL,	
gross_net_ind char(1) NULL,	
prod_name varchar(50) NULL,	
prod_group varchar(5) NULL,	
hazard varchar(5) NULL,	
blend_flag char(1) NULL,	
comp_count char(1) NULL,	
prod_type char(1) NULL,	
ticket_no varchar(10) NULL,	
gas_laden_vapor char(1) NULL,	
sys_movement_id varchar(15) NULL,	
prod_sub_group char(2) NULL,	
tare_wgt varchar(9) NULL,	
conductivity varchar(6) NULL,	
retain_qty varchar(9) NULL,	
trans_gl varchar(9) NULL,	
pqm_unadd_flg char(1) NULL,	
pqm_blend_flg char(1) NULL,	
pqm_addtv_flg char(1) NULL,	
retain_flg char(1) NULL,	
bsw varchar(6) NULL,	
temp_uom char(3) NULL,	
tax_status varchar(10) NULL,	
compartment char(2) NULL,	
order_no varchar(10) NULL,	
shipment_no varchar(10) NULL,	
rec_type char(1) NULL,	
handling_type varchar(4) NULL,	
product_grade varchar(8) NULL,	
product_attribute varchar(4) NULL,	
ERPHandlingType char(2) NULL,	
DutyGroup char(2) NULL,	
railcar_no varchar(10) NULL,	
receipt_date varchar(6) NULL,	
vehicle varchar(10) NULL,	
product_weight varchar(9) NULL,	
retain_bol varchar(10) NULL,	
retain_order varchar(10) NULL,	
LocationNo varchar(10) NULL,	
ContractLoadID varchar(30) NULL,	
ContainerType char(1) NULL,	
ContainerID varchar(20) NULL,	
ContractNumber varchar(20) NULL,	
ContractItemNumber varchar(10) NULL,	
order_rec_type char(1) NULL,	
seal_no_1 varchar(20) NULL,	
seal_no_2 varchar(20) NULL,	
freeform_txt varchar(25) NULL,	
vru_required_flag char(1) NULL,	
BOL_per_batch_bol_no varchar(7) NULL,	
obs_mass varchar(9) NULL,	
aad_no varchar(11) NULL,	
weight_unit varchar(6) NULL,	
ARCNumber varchar(21) NULL,	
LRNumber varchar(22) NULL,	
WaiverCode varchar(30) NULL,	
order_item_no varchar(10) NULL,	
shipment_item_no varchar(10) NULL,	
	)';
PRINT '<<< CREATED TABLE MTVTMSProductRawData >>>'					 	
END	
GO

Execute SRA_Index_Check @s_table	= 'MTVTMSProductRawData', 
				    @s_index		= 'PK_MTVTMSProductRawData_TMSPRDID',
				    @s_keys			= 'TMSPRDID',
				    @c_unique		= 'Y',
				    @c_clustered	= 'Y',
				    @c_primarykey	= 'Y',
				    @c_uniquekey	= 'Y',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';
				    
GO

EXECUTE SRA_FK_Check @s_fkname = 'FK_MTVTMSProductRawData_TMSHDRID',
					 @s_parent_table = 'MTVTMSHeaderRawData',
					 @s_parent_column = 'TMSHDRID',
					 @s_child_table = 'MTVTMSProductRawData',
					 @s_child_column= 'TMSPRDHDRID'
					 
 
SET ANSI_PADDING OFF
GO


SET ANSI_PADDING OFF
GO

--If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSCommentRawData') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
--	Begin
----		exec SRA_Drop_Table @s_table='MTVTMSCommentRawData',@onlySQL='N',@verbose='Y';
--	End
--GO


--GO

If	NOT Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSCommentRawData') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	PRINT 'Creating Table = MTVTMSCommentRawData'
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVTMSCommentRawData',
@s_sql=' (
TMSCMTID				int				Identity,
TMSCMTHDRID				int				NOT NULL,
LineID					varchar(10)		NULL,
Data					varchar(MAX)  NULL,
CreatedDate				smalldatetime		NOT NULL, 
recordType				varchar(1)		NULL,
trans_ref_no			varchar(10)		NULL,
comment_rec_no			varchar(2)		NULL,
comment_type			varchar(2)		NULL,
comment					varchar(40)		NULL,
rec_type				varchar(1)		NULL
)';
 PRINT '<<< CREATED TABLE MTVTMSCommentRawData >>>'
END
GO

Execute SRA_Index_Check @s_table	= 'MTVTMSCommentRawData', 
				    @s_index		= 'PK_MTVTMSCommentRawData_TMSCMTID',
				    @s_keys			= 'TMSCMTID',
				    @c_unique		= 'Y',
				    @c_clustered	= 'Y',
				    @c_primarykey	= 'Y',
				    @c_uniquekey	= 'Y',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';
				    
GO

EXECUTE SRA_FK_Check @s_fkname = 'FK_MTVTMSCommentRawData_TMSHDRID',
					 @s_parent_table = 'MTVTMSHeaderRawData',
					 @s_parent_column = 'TMSHDRID',
					 @s_child_table = 'MTVTMSCommentRawData',
					 @s_child_column= 'TMSCMTHDRID'
					 
					 
SET ANSI_PADDING OFF
GO





--GO

--If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSMovementStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
--	Begin
----		exec SRA_Drop_Table @s_table='MTVTMSMovementStaging',@onlySQL='N',@verbose='Y';
--	End
--GO

If	NOT Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSMovementStaging') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
	PRINT 'Creating Table = MTVTMSMovementStaging'
exec SRA_Create_Table 
@vc_domain	='Interfaces',
@s_table='MTVTMSMovementStaging',
@s_sql=' (
MESID				int				Identity,
MvtTMSHDRID			int				NOT NULL,
RAMvtDcmntBAID		int				NULL,
RAMvtDcmntDte		datetime	NULL,
RALcleID			int				NULL,
RAPrdctID			int				NULL,
RAMvtHdrDte			datetime	NULL,
RAMvtHdrQty			float			NULL,
RAMvtHdrGrssQty		float			NULL,
RAMvtHdrDsplyUOM	smallint		NULL,
RAMvtHdrGrvty		float			NULL,
RAMvtHdrTemp		float			NULL,
RAMvtHdrTempScale	char(1)		NULL,
RAMvtHdrOrgnLcleID	int				NULL,
RAMvtHdrDstntnLcleID	int			NULL,
RAMvtHdrTyp			char(1)			NULL,
RAMvtHdrMtchngStts	char(1)			NULL,
RATemplateName			varchar(80)		NULL,
RAMvtHdrExternalDocNo	varchar(80)		NULL,
RAMvtHdrLftngNmbr		varchar(30)		NULL,
RAMvtPurchaseOrder		varchar(30)		NULL,
RAMvtHdrRcptDealNo		varchar(30)		NULL,
RAMvtHdrRcptDlHdrID		int				NULL,
RAMvtHdrRcptDlDtlID		int				NULL,
RAMvtHdrDlvryDealNo		varchar(30)		NULL,
RAMvtHdrDlvryDlHdrID		int			NULL,
RAMvtHdrDlvryDlDtlID		int			NULL,
RAMvtRcptBAID			int				NULL,
RAMvtDlvryBAID			int				NULL,
RAMvtHdrCrrrBAID		int				NULL,
RAMvtHdrNote			varchar(MAX)	NULL,
MvtHdrMvtDcmntID		int				NULL,
MvtHdrID				int				NULL,
term_id  varchar(7) NULL,
doc_no varchar(13) NULL,
trans_id varchar(3) NULL,
supplier_no varchar(10) NULL,
cust_no varchar(10) NULL,
acct_no varchar(10) NULL,
destination_no varchar(10) NULL,
delv_country char(2) NULL,
delv_state char(2) NULL,
delv_zone varchar(5) NULL,
carrier varchar(7) NULL,
carrier_scac varchar(4) NULL,
transaction_date varchar(6) NULL,
transaction_time varchar(4) NULL,
load_start_date varchar(6) NULL,
load_start_time varchar(4) NULL,
load_stop_date varchar(6) NULL,
acct_type char(1) NULL,
load_stop_time varchar(4) NULL,
prod_rec_no varchar(2) NULL,
prod_id varchar(6) NULL,
prod_name varchar(50) NULL,
prod_type char(1) NULL,
order_rec_type char(1) NULL,	
order_no varchar(10) NULL,	
uom varchar(1) NULL,
gross varchar(9) NULL,
net varchar(9) NULL,
LocationNo varchar(10) NULL,
ContractNumber varchar(20) NULL,
temperature varchar(6) NULL,
grav_density varchar(6) NULL,
temp_uom varchar(3) NULL,

TicketStatus			char(1)			NULL,
InterfaceAction			char(1)			NULL,
InterfaceMessage		varchar(MAX)	NULL,
InterfaceFile			varchar(255)	NULL,
InterfaceID				varchar(20)		NULL,
ImportDate				smalldatetime	Not Null Default Current_TimeStamp,
ModifyDate				smalldatetime	Null, 
UserId					int				Null,		
ProcessedDate			smalldatetime	NULL
	)';
PRINT '<<< CREATED TABLE MTVTMSMovementStaging >>>'	
END	
GO

Execute SRA_Index_Check @s_table	= 'MTVTMSMovementStaging', 
				    @s_index		= 'PK_MTVTMSMovementStaging_MESID',
				    @s_keys			= 'MESID',
				    @c_unique		= 'Y',
				    @c_clustered	= 'N',
				    @c_primarykey	= 'Y',
				    @c_uniquekey	= 'N',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';
				    
GO
Execute SRA_Index_Check @s_table	= 'MTVTMSMovementStaging', 
				    @s_index		= 'IE_MTVTMSMovementStaging_BOL',
				    @s_keys			= 'doc_no,term_id,InterfaceAction',
				    @c_unique		= 'N',
				    @c_clustered	= 'N',
				    @c_primarykey	= 'N',
				    @c_uniquekey	= 'N',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';
				    
GO

EXECUTE SRA_FK_Check @s_fkname = 'FK_MTVTMSMovementStaging_TMSHDRID',@s_parent_table = 'MTVTMSHeaderRawData',
                     @s_parent_column = 'TMSHDRID', @s_child_table = 'MTVTMSMovementStaging', @s_child_column='MvtTMSHDRID'
                     
EXECUTE SRA_FK_Check @s_fkname = 'FK_MTVTMSProductRawData_MVTTMSSTGID',@s_parent_table = 'MTVTMSMovementStaging',
                     @s_parent_column = 'MESID', @s_child_table = 'MTVTMSProductRawData', @s_child_column='MVTTMSSTGID'                     
			
SET ANSI_PADDING OFF
GO


IF  OBJECT_ID(N'[dbo].[MTVTMSMovementStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'T_MTVTMSMovementStaging.sql'
    PRINT '<<< CREATED TABLE MTVTMSMovementStaging >>>'	
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTMSMovementStaging >>>'

