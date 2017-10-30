-- Object:  Table [dbo].[MTVTMSCustomerStaging]    
PRINT 'Start Script=MTVTMSCustomerStaging.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

--select * from dbo.mtvtmscustomerstaging_temp

/****** Object:  Table [dbo].[MTVTMSCustomerStaging]     ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSCustomerStaging]') IS NOT NULL
BEGIN
    select * into mtvtmscustomerstaging_temp
	 from dbo.mtvtmscustomerstaging

	DROP TABLE [dbo].MTVTMSCustomerStaging
	PRINT '<<< DROPPED TABLE [MTVTMSCustomerStaging] >>>'
END

/****** Object:  Table [dbo].[MTVTMSCustomerStaging]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO




create table [dbo].MTVTMSCustomerStaging
( idnty  [int] IDENTITY(1,1) NOT NULL
, TMSFileIdnty              int
, DlHdrID                   int
, DlDtlID                   int
, DealDetailID              int
, InterfaceStatus           char(1) null
,ErrorMessage               [varchar](8000) null
, ACTION                    [char](1) null
, supplier_no               [varchar](10) null
, cust_no                   [varchar](10) null
, cust_type                 [char](1) null
, cust_name                 [varchar](50) null
, short_cust_name           [varchar](50) null
, name1                     [varchar](50) null
, name2                     [varchar](50) null
, addr1                     [varchar](50) null
, addr2                     [varchar](50) null
, city                      [varchar](50) null
, state                     [varchar](2) null
, zip                       [varchar](10) null
, country                   [varchar](2) null
, phone                     [varchar](20) null
, fax_group                 [varchar](30) null
, mail_group                [varchar](30) null
, contact_name              [varchar](50) null
, eff_date                  [varchar](6) null
, exp_date                  [varchar](6) null
, locked                    [varchar](1) null
, lockout_date              [varchar](6) null
, lockout_reason            [varchar](40) null
, user_data_line1           [varchar](20) null
, user_data_line2           [varchar](20) null
, user_data_line3           [varchar](20) null
, user_data_line4           [varchar](20) null
, user_data_line5           [varchar](20) null
, freight                   [varchar](1) null
, cot_major                 [varchar](2) null
, cot_minor                 [varchar](3) null
, tax_cert_no               [varchar](15) null
, refiner_code              [varchar](10) null
, credit_status             [varchar](3) null
, emergency_no              [varchar](20) null
, emergency_co              [varchar](50) null
, dest_splc_code            [varchar](9) null
, credit_risk               [varchar](1) null
, credit_id                 [varchar](14) null
, irs_h637                  [varchar](15) null
, fein                      [varchar](15)  null
, last_upd_usr              [varchar](10)  null
, last_upd_dt               [varchar](19)  null
, dirty_flag                [char](1)  null
, vat_no                    [varchar](20)  null
, iso_language              [varchar](8)  null
, comp_reg_no               [varchar](30)  null
, inherit_supplier_prod     [char](1) null 
, is_consignor              [char](1)  null
, DutyToNumber              [varchar](10)  null
, contractrequired          [char](1) null
, ar_acct_no                [varchar](14)  null
, co_station                [varchar](6)  null
, agree_no                  [varchar](20)  null
, print_fsii_data           [char](1)  null
, SuppressComponentPrinting [char](1)  null
, SeasonalZone              [varchar](5)  null
--, filler                    [varchar](286)  null
--, CustomerLine              [varchar](1267)  null

 CONSTRAINT [UK_MTVTMSCustomerStaging] PRIMARY KEY CLUSTERED 
(
	[Idnty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


if not exists ( select 'x' from sysobjects where name = 'pk_MTVTMSCustomerStaging' )
   create index pk_MTVTMSCustomerStaging  on MTVTMSCustomerStaging (TMSFileIdnty )
 go  

SET ANSI_PADDING OFF
GO


GRANT INSERT,UPDATE,DELETE,SELECT ON dbo.MTVTMSCustomerStaging TO RIGHTANGLEACCESS
GO

if exists ( select 'x' from sysobjects where name = 'mtvtmscustomerstaging_temp')
begin

 insert into dbo.mtvtmscustomerstaging
 (TMSFileIdnty
,DlHdrID
,DlDtlID
,DealDetailID
,ACTION
,supplier_no
,cust_no
,cust_type
,cust_name
,short_cust_name
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
,mail_group
,contact_name
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
,freight
,cot_major
,cot_minor
,tax_cert_no
,refiner_code
,credit_status
,emergency_no
,emergency_co
,dest_splc_code
,credit_risk
,credit_id
,irs_h637
,fein
,last_upd_usr
,last_upd_dt
,dirty_flag
,vat_no
,iso_language
,comp_reg_no
,inherit_supplier_prod
,is_consignor
,DutyToNumber
,contractrequired
,ar_acct_no
,co_station
,agree_no
,print_fsii_data
,SuppressComponentPrinting
,SeasonalZone
)
 select TMSFileIdnty
,DlHdrID
,DlDtlID
,DealDetailID
,ACTION
,supplier_no
,cust_no
,cust_type
,cust_name
,short_cust_name
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
,mail_group
,contact_name
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
,freight
,cot_major
,cot_minor
,tax_cert_no
,refiner_code
,credit_status
,emergency_no
,emergency_co
,dest_splc_code
,credit_risk
,credit_id
,irs_h637
,fein
,last_upd_usr
,last_upd_dt
,dirty_flag
,vat_no
,iso_language
,comp_reg_no
,inherit_supplier_prod
,is_consignor
,DutyToNumber
,contractrequired
,ar_acct_no
,co_station
,agree_no
,print_fsii_data
,SuppressComponentPrinting
,SeasonalZone
--,filler
--,CustomerLine
from mtvtmscustomerstaging_temp
order by idnty

drop table mtvtmscustomerstaging_temp

end

go