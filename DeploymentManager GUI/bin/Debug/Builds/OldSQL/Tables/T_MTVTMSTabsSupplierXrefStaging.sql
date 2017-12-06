-- Object:  Table [dbo].[MTVTMSTabsSupplierXrefStaging]
PRINT 'Start Script=MTVTMSTabsSupplierXrefStaging.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSTabsSupplierXrefStaging]    ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSTabsSupplierXrefStaging]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].MTVTMSTabsSupplierXrefStaging
	PRINT '<<< DROPPED TABLE [MTVTMSTabsSupplierXrefStaging] >>>'
END

/****** Object:  Table [dbo].[MTVTMSTabsSupplierXrefStaging]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO




create table [dbo].MTVTMSTabsSupplierXrefStaging
( idnty   int  identity(1,1)
, TMSFileIdnty        int
, DlHdrID           int
, DlDtlID             int
, DealDetailID        int
, ACTION	[char](1)default space(5)
, seller_no [char](10) default space(10)
, supplier_no [char](10) default space(10)	
, term_id	[char](7) default space(7)
, consignee	[char](14) default space(14)
, rec_no    [char](1) default space(1)
, cust_no	[char](10) default space(10)
, acct_no	[char](10) default space(10)
, dest_no   [char](10) default space(10)
, approve_now [char](1) default space(1)
, order_now [char](1) default space(1)
, sold_or_buy [char](1) default space(1)
, chain_id [char](1) default space(1)
, chain_consignee [char](14) default space(14)
, filler      [char] (1176) default space(1176)
, sellerxrefline char(1267) default space(1267)


 CONSTRAINT [PK_MTVTMSTabsSupplierXrefStaging] PRIMARY KEY CLUSTERED 
(
	[Idnty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

grant insert,update,delete,select on [dbo].MTVTMSTabsSupplierXrefStaging to RightaNGLEaCCESS, sysuser
GO