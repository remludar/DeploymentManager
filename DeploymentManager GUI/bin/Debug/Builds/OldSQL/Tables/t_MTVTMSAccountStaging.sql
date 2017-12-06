-- Object:  Table [dbo].[MTVTMSAccountStaging]  
PRINT 'Start Script=MTVTMSAccountStaging.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSAccountStaging]     ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSAccountStaging]') IS NOT NULL
BEGIN

    select * into mtvtmsaccountstaging_temp from mtvtmsaccountstaging

	DROP TABLE [dbo].MTVTMSAccountStaging
	PRINT '<<< DROPPED TABLE [MTVTMSAccountStaging] >>>'
END

--select c.name, c.length from sysobjects o,syscolumns c where o.id = c.id and o.name = 'MTVTMSAccountStaging' order by colorder
/****** Object:  Table [dbo].[MTVTMSAccountStaging]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO



create table [dbo].MTVTMSAccountStaging
(idnty                  int identity(1,1)
,TMSFileIdnty           int
,DlHdrID                int
,DlDtlID                int
,DealDetailID           int
,InterfaceStatus        char(1) null
,ErrorMessage           varchar(8000) null
,ACTION                 char(1)       null
,supplier_no            varchar(10)   null
,cust_no	            varchar(10)   null
,acct_no	            varchar(10)   null
,acct_type              char(1)  null
,acct_name              varchar(50) null
,short_acct_name        varchar(10) null
,name1	                varchar(50)  null
,name2	                varchar(50)  null          
,addr1	                varchar(50)  null
,addr2	                varchar(50)  null            
,city	                varchar(50)  null
,state	                varchar(2)   null
,zip	                varchar(10)  null
,country                varchar(2)   null
,phone	                varchar(20)  null           
,fax_group              varchar(30)   null   
,email_group	        varchar(30)  null
,contact_name	        varchar(50)  null
,delv_instr	            varchar(40)  null
,equip_instr	        varchar(40)  null
,credit_risk	        char(1) null
,eff_date	            varchar(6) null
,exp_date	            varchar(6) null
,locked	                char(1) null
,lockout_date	        varchar(6) null
,lockout_reason	        varchar(40) null
,user_data_line1        varchar(20) null
,user_data_line2        varchar(20) null
,user_data_line3        varchar(20) null
,user_data_line4        varchar(20) null
,user_data_line5        varchar(20) null
,emergency_no	        varchar(20) null
,emergency_co	        varchar(50) null
,freight	            char(1) null
,cot_major	            varchar(2) null
,cot_minor	            varchar(3) null
,dest_splc_code	        varchar(9) null
,po_number	            varchar(20) null
,tax_cert_no	        varchar(15) null
,refiner_code	        varchar(10) null
,credit_status	        varchar(3) null
,host_po_number	        varchar(20) null
,contract_number	    varchar(20) null
,adv_ship_notice	    char(1) null
,zone	                varchar(2) null
,retail_site_num        varchar(10) null	
,def_transid	        varchar(3) null
,credit_id	            varchar(14) null
,irs_h637	            varchar(15) null
,fein	                varchar(15) null
,po_req	                char(1) null
,relno_req	            char(1) null
,gross_net	            char(1) null
,special_msg	        char(1) null
,prnt_reg_doc	        char(1) null
,is_consignor	        char(1)  null
,last_upd_usr	        varchar(10) null
,last_upd_dt	        varchar(19) null
,dirty_flag	            char(1) default space(1)
,pbl_no	                varchar(10)  null
,haulier_test_no	    varchar(50) null
,dispatch_test_no	    varchar(50) null
,vat_no	                varchar(20) null
,iso_language	        varchar(8) null
,veh_acct_comp	        varchar(10) null
,comp_reg_no	        varchar(30) null
,inherit_cust_prods	    char(1) null
,ulsd_epa_id            varchar(9) null
,DutyToNumber	        varchar(10) null
,ar_acct_no	            varchar(14) null
,co_station	            varchar(10) null
,_reserved	            char(1) null
,DestinationType	    char(1) null
,TransportArrangement   char(1) null
,INCOTerms              varchar(3) null
,SeasonalZone	        varchar(5) null

 CONSTRAINT [UK_MTVTMSAccountStaging] PRIMARY KEY CLUSTERED 
(
	[Idnty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


if not exists ( select 'x' from sysobjects where name = 'pk_MTVTMSAccountStaging' )
   create index pk_MTVTMSAccountStaging  on MTVTMSAccountStaging (TMSFileIdnty )
 go  

SET ANSI_PADDING OFF
GO

GRANT INSERT,UPDATE,DELETE,SELECT ON MTVTMSAccountStaging TO RIGHTANGLEACCESS
GO


if exists ( select 'x' from sysobjects where name = 'mtvtmsaccountstaging_temp')
begin

insert into dbo.mtvtmsaccountstaging
(TMSFileIdnty
,DlHdrID
,DlDtlID
,DealDetailID
,ACTION
,supplier_no
,cust_no
,acct_no
,acct_type
,acct_name
,short_acct_name
,name1
,name2
,addr1
,addr2
,city
,state
,zip
,country
,phone
,fax_group
,email_group
,contact_name
,delv_instr
,equip_instr
,credit_risk
,eff_date
,exp_date
,locked
,lockout_date
,lockout_reason
,user_data_line1
,user_data_line2
,user_data_line3
,user_data_line4
,user_data_line5
,emergency_no
,emergency_co
,freight
,cot_major
,cot_minor
,dest_splc_code
,po_number
,tax_cert_no
,refiner_code
,credit_status
,host_po_number
,contract_number
,adv_ship_notice
,zone
,retail_site_num
,def_transid
,credit_id
,irs_h637
,fein
,po_req
,relno_req
,gross_net
,special_msg
,prnt_reg_doc
,is_consignor
,last_upd_usr
,last_upd_dt
,dirty_flag
,pbl_no
,haulier_test_no
,dispatch_test_no
,vat_no
,iso_language
,veh_acct_comp
,comp_reg_no
,inherit_cust_prods
,ulsd_epa_id
,DutyToNumber
,ar_acct_no
,co_station
,_reserved
,DestinationType
,TransportArrangement
,INCOTerms
,SeasonalZone
)
select TMSFileIdnty
,DlHdrID
,DlDtlID
,DealDetailID
,ACTION
,supplier_no
,cust_no
,acct_no
,acct_type
,acct_name
,short_acct_name
,name1
,name2
,addr1
,addr2
,city
,state
,zip
,country
,phone
,fax_group
,email_group
,contact_name
,delv_instr
,equip_instr
,credit_risk
,eff_date
,exp_date
,locked
,lockout_date
,lockout_reason
,user_data_line1
,user_data_line2
,user_data_line3
,user_data_line4
,user_data_line5
,emergency_no
,emergency_co
,freight
,cot_major
,cot_minor
,dest_splc_code
,po_number
,tax_cert_no
,refiner_code
,credit_status
,host_po_number
,contract_number
,adv_ship_notice
,zone
,retail_site_num
,def_transid
,credit_id
,irs_h637
,fein
,po_req
,relno_req
,gross_net
,special_msg
,prnt_reg_doc
,is_consignor
,last_upd_usr
,last_upd_dt
,dirty_flag
,pbl_no
,haulier_test_no
,dispatch_test_no
,vat_no
,iso_language
,veh_acct_comp
,comp_reg_no
,inherit_cust_prods
,ulsd_epa_id
,DutyToNumber
,ar_acct_no
,co_station
,_reserved
,DestinationType
,TransportArrangement
,INCOTerms
,SeasonalZone
From mtvtmsaccountstaging_temp
order by idnty


drop table mtvtmsaccountstaging_temp

end
go