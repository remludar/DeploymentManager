-- Object:  Table [dbo].[MTVTMSAcctProdStaging]
PRINT 'Start Script=MTVTMSAcctProd.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSAcctProdStaging]    ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSAcctProdStaging]') IS NOT NULL
BEGIN

    select * into mtvtmsacctprodstaging_temp from mtvtmsacctprodstaging

	DROP TABLE [dbo].MTVTMSAcctProdStaging
	PRINT '<<< DROPPED TABLE [MTVTMSAcctProdStaging] >>>'
END

/****** Object:  Table [dbo].[MTVTMSAcctProdStaging]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO




create table [dbo].[MTVTMSAcctProdStaging]
( idnty               int  identity(1,1)
, TMSFileIdnty        int
, DlHdrID             int
, DlDtlID             int
, DealDetailID        int
, InterfaceStatus     [char](1) null
, ErrorMessage        [varchar](8000) null
, ACTION              [char](1) NULL
, term_id             [varchar](7) NULL
, supplier_no         [varchar](10) NULL
, cust_no             [varchar](10) NULL
, acct_no             [varchar](10)  NULL
, prod_id             [varchar](6)  NULL
, spd_code            [varchar](2)  NULL
, contract_number     [varchar](20)  NULL
, active_enable       [varchar](1)  NULL
, auth_eff_dt         [varchar](6)  NULL
, auth_expr_dt        [varchar](6)  NULL
, last_upd_usr	      [varchar](10)  NULL
, last_upd_dt	      [varchar](19)  NULL
, dirty_flag	      [varchar](1)  NULL
, source	          [varchar](10)  NULL
, osp_interface_enabled	 [char](1) NULL
, ERPHandlingType	  [varchar](2)  NULL


 CONSTRAINT [UK_MTVTMSAcctProdStaging] PRIMARY KEY CLUSTERED 
(
	[Idnty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

if not exists ( select 'x' from sysobjects where name = 'pk_MTVTMSAcctProdStaging' )
   create index pk_mtvtmsAcctProdStaging  on  MTVTMSAcctProdStaging (TMSFileIdnty )
   

SET ANSI_PADDING OFF
GO

grant insert,update,delete,select on MTVTMSAcctProdStaging to RightaNGLEaCCESS
GO


if exists ( select 'x' from sysobjects where name = 'mtvtmsacctprodstaging_temp')
begin

insert into dbo.mtvtmsacctprodstaging
(TMSFileIdnty
,DlHdrID
,DlDtlID
,DealDetailID
,ACTION
,term_id
,supplier_no
,cust_no
,acct_no
,prod_id
,spd_code
,contract_number
,active_enable
,auth_eff_dt
,auth_expr_dt
,last_upd_usr
,last_upd_dt
,dirty_flag
,source
,osp_interface_enabled
,ERPHandlingType
)
select TMSFileIdnty
,DlHdrID
,DlDtlID
,DealDetailID
,ACTION
,term_id
,supplier_no
,cust_no
,acct_no
,prod_id
,spd_code
,contract_number
,active_enable
,auth_eff_dt
,auth_expr_dt
,last_upd_usr
,last_upd_dt
,dirty_flag
,source
,osp_interface_enabled
,ERPHandlingType
from dbo.mtvtmsacctprodstaging_temp


drop table mtvtmsacctprodstaging_temp



end
go