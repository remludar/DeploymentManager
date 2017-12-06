-- Object:  Table [dbo].[MTVTMSNominationStaging]
PRINT 'Start Script=MTVTMSNominationStaging.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSNominationStaging]    ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSNominationStaging]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].MTVTMSNominationStaging
	PRINT '<<< DROPPED TABLE [MTVTMSNominationStaging] >>>'
END

/****** Object:  Table [dbo].[MTVTMSNominationStaging]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



if not exists ( select 'x' from sysobjects where name = 'MTVTMSNominationStaging' )
Begin

Create table dbo.MTVTMSNominationStaging
( idnty  int  identity(1,1)
,TMSFileIdnty int 
,TmsNominationType varchar(100)
,sequence int
,recdel char(49) default space(49)
,action	char(1) default space(1)
,rec_type	char(1) default space(1)
,supplier_no	char(10) default space(10)
,order_no	char(10) default space(10)
,term_id	char(7) default space(7)
,cust_no	char(10) default space(10)
,acct_no	char(10) default space(10)
,destination_no	char(10) default space(10)
,order_status	char(1) default space(1)
,order_comments	char(40) default space(40)
,sched_date	char(6) default space(6)
,order_date	char(6) default space(6)
,order_time	char(4) default space(4)
,po_number	char(10) default space(10)
,release_no	char(10) default space(10)
,total_qty	char(9) default space(9)
,driver_no	char(8) default space(8)
,carrier_no	char(7) default space(7)
,truck_no	char(10) default space(10)
,trailer1	char(10) default space(10)
,trailer2	char(10) default space(10)
,shift	char(1) default space(1)
,delv_seq_no	char(1) default space(1)
,disp_comments	char(40) default space(40)
,dest	char(9) default space(9)
,flood_load	char(1) default space(1)
,load_seq_no	char(4) default space(4)
,processed	char(1) default space(1)
,load_date	char(6) default space(6)
,load_start	char(4) default space(4)
,load_stop	char(4) default space(4)
,supplier_rack_no	char(10) default space(10)
,petroex_consignee	char(14) default space(14)
,additional_doc	char(1) default space(10)
,truck_driver	char(10) default space(10)
,seal1	char(5) default space(5)
,seal2	char(5) default space(5)
,preload_enabled char(1) default space(1)
,enable_ship_to_plan char(1) default space(1)
,filler	char(1) default space(1)
--A1
,trailer_A1	char(1) default space(1)
,compartment_A1	char(1) default space(1)
,flood_group_A1	char(1) default space(1)
,prod_id_A1	char(6) default space(6)
,Order_qty_A1	char(6) default space(6)
,retained_A1	char(6) default space(6)
,loaded_A1	char(6) default space(6)
,returned_A1	char(6) default space(6)
,status_A1	char(1) default space(1)
,seal_no_A1	char(5) default space(5)
,driver_adjusted_A1	char(1) default space(1)
,auto_adjusted_A1	char(1) default space(1)
,filler_A1	char(10) default space(10)
--A2
,trailer_A2	char(1) default space(1)
,compartment_A2	char(1) default space(1)
,flood_group_A2	char(1) default space(1)
,prod_id_A2	char(6) default space(6)
,Order_qty_A2	char(6) default space(6)
,retained_A2	char(6) default space(6)
,loaded_A2	char(6) default space(6)
,returned_A2	char(6) default space(6)
,status_A2	char(1) default space(1)
,seal_no_A2	char(5) default space(5)
,driver_adjusted_A2	char(1) default space(1)
,auto_adjusted_A2	char(1) default space(1)
,filler_A2	char(10) default space(10)
--A3
,trailer_A3	char(1) default space(1)
,compartment_A3	char(1) default space(1)
,flood_group_A3	char(1) default space(1)
,prod_id_A3	char(6) default space(6)
,Order_qty_A3	char(6) default space(6)
,retained_A3	char(6) default space(6)
,loaded_A3	char(6) default space(6)
,returned_A3	char(6) default space(6)
,status_A3	char(1) default space(1)
,seal_no_A3	char(5) default space(5)
,driver_adjusted_A3	char(1) default space(1)
,auto_adjusted_A3	char(1) default space(1)
,filler_A3	char(10) default space(10)
--A4
,trailer_A4	char(1) default space(1)
,compartment_A4	char(1) default space(1)
,flood_group_A4	char(1) default space(1)
,prod_id_A4	char(6) default space(6)
,Order_qty_A4	char(6) default space(6)
,retained_A4	char(6) default space(6)
,loaded_A4	char(6) default space(6)
,returned_A4	char(6) default space(6)
,status_A4	char(1) default space(1)
,seal_no_A4	char(5) default space(5)
,driver_adjusted_A4	char(1) default space(1)
,auto_adjusted_A4	char(1) default space(1)
,filler_A4	char(10) default space(10)
--A5
,trailer_A5	char(1) default space(1)
,compartment_A5	char(1) default space(1)
,flood_group_A5	char(1) default space(1)
,prod_id_A5	char(6) default space(6)
,Order_qty_A5	char(6) default space(6)
,retained_A5	char(6) default space(6)
,loaded_A5	char(6) default space(6)
,returned_A5 char(6) default space(6)
,status_A5	char(1) default space(1)
,seal_no_A5	char(5) default space(5)
,driver_adjusted_A5	char(1) default space(1)
,auto_adjusted_A5	char(1) default space(1)
,filler_A5	char(10) default space(10)
--A6
,trailer_A6	char(1) default space(1)
,compartment_A6	char(1) default space(1)
,flood_group_A6	char(1) default space(1)
,prod_id_A6	char(6) default space(6)
,Order_qty_A6	char(6) default space(6)
,retained_A6	char(6) default space(6)
,loaded_A6	char(6) default space(6)
,returned_A6	char(6) default space(6)
,status_A6	char(1) default space(1)
,seal_no_A6	char(5) default space(5)
,driver_adjusted_A6	char(1) default space(1)
,auto_adjusted_A6	char(1) default space(1)
,filler_A6	char(10) default space(10)
--A7
,trailer_A7	char(1) default space(1)
,compartment_A7	char(1) default space(1)
,flood_group_A7	char(1) default space(1)
,prod_id_A7	char(6) default space(6)
,Order_qty_A7	char(6) default space(6)
,retained_A7	char(6) default space(6)
,loaded_A7	char(6) default space(6)
,returned_A7	char(6) default space(6)
,status_A7	char(1) default space(1)
,seal_no_A7	char(5) default space(5)
,driver_adjusted_A7	char(1) default space(1)
,auto_adjusted_A7	char(1) default space(1)
,filler_A7	char(10) default space(10)
--A8
,trailer_A8	char(1) default space(1)
,compartment_A8	char(1) default space(1)
,flood_group_A8	char(1) default space(1)
,prod_id_A8	char(6) default space(6)
,Order_qty_A8	char(6) default space(6)
,retained_A8	char(6) default space(6)
,loaded_A8	char(6) default space(6)
,returned_A8	char(6) default space(6)
,status_A8	char(1) default space(1)
,seal_no_A8	char(5) default space(5)
,driver_adjusted_A8	char(1) default space(1)
,auto_adjusted_A8	char(1) default space(1)
,filler_A8	char(10) default space(10)
--A9
,trailer_A9	char(1) default space(1)
,compartment_A9 char(1) default space(1)
,flood_group_A9 char(1) default space(1)
,prod_id_A9	char(6) default space(6)
,Order_qty_A9	char(6) default space(6)
,retained_A9	char(6) default space(6)
,loaded_A9	char(6) default space(6)
,returned_A9	char(6) default space(6)
,status_A9	char(1) default space(1)
,seal_no_A9	char(5) default space(5)
,driver_adjusted_A9	char(1) default space(1)
,auto_adjusted_A9	char(1) default space(1)
,filler_A9	char(10) default space(10)
--A10
,trailer_A10	char(1) default space(1)
,compartment_A10	char(1) default space(1)
,flood_group_A10	char(1) default space(1)
,prod_id_A10	char(6) default space(6)
,Order_qty_A10	char(6) default space(6)
,retained_A10	char(6) default space(6)
,loaded_A10	char(6) default space(6)
,returned_A10	char(6) default space(6)
,status_A10	char(1) default space(1)
,seal_no_A10	char(5) default space(5)
,driver_adjusted_A10	char(1) default space(1)
,auto_adjusted_A10	char(1) default space(1)
,filler_A10	char(10) default space(10)
--A11
,trailer_A11	char(1) default space(1)
,compartment_A11	char(1) default space(1)
,flood_group_A11 char(1) default space(1)
,prod_id_A11	char(6) default space(6)
,Order_qty_A11	char(6) default space(6)
,retained_A11	char(6) default space(6)
,loaded_A11	char(6) default space(6)
,returned_A11	char(6) default space(6)
,status_A11	char(1) default space(1)
,seal_no_A11	char(5) default space(5)
,driver_adjusted_A11	char(1) default space(1)
,auto_adjusted_A11	char(1) default space(1)
,filler_A11	char(10) default space(10)
--A12
,trailer_A12	char(1) default space(1)
,compartment_A12	char(1) default space(1)
,flood_group_A12	char(1) default space(1)
,prod_id_A12	char(6) default space(6)
,Order_qty_A12	char(6) default space(6)
,retained_A12	char(6) default space(6)
,loaded_A12	char(6) default space(6)
,returned_A12	char(6) default space(6)
,status_A12	char(1) default space(1)
,seal_no_A12	char(5) default space(5)
,driver_adjusted_A12	char(1) default space(1)
,auto_adjusted_A12	char(1) default space(1)
,filler_A12	char(10) default space(10)
--
,host_order_no	char(20) default space(20)
--order_prod_dtl_def (max of 12)	
,sys_movement_id_A1	char(15) default space(15)
,line_item_date_A1	char(6) default space(6)
,line_item_time_A1  char(4) default space(4)
--
,sys_movement_id_A2	char(15) default space(15)
,line_item_date_A2	char(6) default space(6)
,line_item_time_A2  char(4) default space(4)
--
,sys_movement_id_A3	char(15) default space(15)
,line_item_date_A3	char(6) default space(6)
,line_item_time_A3  char(4) default space(4)
--
,sys_movement_id_A4	char(15) default space(15)
,line_item_date_A4	char(6) default space(6)
,line_item_time_A4  char(4) default space(4)
--
,sys_movement_id_A5	char(15) default space(15)
,line_item_date_A5	char(6) default space(6)
,line_item_time_A5  char(4) default space(4)
--
,sys_movement_id_A6	char(15) default space(15)
,line_item_date_A6	char(6) default space(6)
,line_item_time_A6  char(4) default space(4)
--
,sys_movement_id_A7	char(15) default space(15)
,line_item_date_A7	char(6) default space(6)
,line_item_time_A7  char(4) default space(4)
--
,sys_movement_id_A8	char(15) default space(15)
,line_item_date_A8	char(6) default space(6)
,line_item_time_A8  char(4) default space(4)
--
,sys_movement_id_A9	char(15) default space(15)
,line_item_date_A9	char(6) default space(6)
,line_item_time_A9  char(4) default space(4)
--
,sys_movement_id_A10	char(15) default space(15)
,line_item_date_A10	char(6) default space(6)
,line_item_time_A10  char(4) default space(4)
--
,sys_movement_id_A11	char(15) default space(15)
,line_item_date_A11	char(6) default space(6)
,line_item_time_A11  char(4) default space(4)
--
,sys_movement_id_A12	char(15) default space(15)
,line_item_date_A12	char(6) default space(6)
,line_item_time_A12  char(4) default space(4)


,limit_order	char(1) default space(1)
,verify_carrier	char(1) default space(1)
,sched_time	char(4) default space(4)
,trans_id	char(3) default space(3)
,contract_number	char(15) default space(15)
,selected_prod_id	char(6) default space(6)
,exp_date	char(6) default space(6)
,exp_time	char(4) default space(4)
,tare_wgt	char(6) default space(6)
,folio_mo	char(2) default space(2)
,folio_no	char(3) default space(3)
,inv_no	char(7) default space(7)
,host_po_number	char(20) default space(20)
,UOM	char(1) default space(1)
,trans_seq_no	char(4) default space(4)
,delv_zone	char(6) default space(6)
,distance	char(6) default space(6)
,delv_date char(6) default space(6)
,delv_time char(4) default space(4)
,load_configrmed	char(1) default space(1)
,dispatch_customer_tupe char(1) default space(1)
,validate_pidx_consignee	char(1) default space(1)
,date_added  char(6) default space(6)
,nominationline char(3000)

--Delivery                                         UO00000000020184344402000J91900123166910012320720                                                         1510081139                                                                                                                                                           12320720                               0 509292  6500     0     0     0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          


 CONSTRAINT [PK_MTVTMSNominationStaging] PRIMARY KEY CLUSTERED 
(
	[Idnty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
end

GO

if not exists ( select 'x' from sysobjects where name = 'NK_MTVTMSNominationStaging' )
   create index NK_MTVTMSNominationStaging on dbo.MTVTMSNominationStaging ( TMSFILEIDNTY )

SET ANSI_PADDING OFF
GO

grant insert,update,delete,select on [dbo].MTVTMSNominationStaging to RightaNGLEaCCESS
GO