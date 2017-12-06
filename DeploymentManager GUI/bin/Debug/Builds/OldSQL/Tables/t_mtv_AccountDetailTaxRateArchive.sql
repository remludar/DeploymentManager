
/****** Object:  Table [dbo].[TaxRateDetail]    Script Date: 12/01/2016 11:28:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if exists ( select 'x' from sysobjects where name = 'mtv_AccountDetailTaxRateArchive' )
begin
    IF OBJECT_ID('tempdb..#temptra') IS NOT NULL
       DROP TABLE #temptra
    select * into #temptra from dbo.mtv_AccountDetailTaxRateArchive
    drop table dbo.mtv_AccountDetailTaxRateArchive
end
go

create table dbo.mtv_AccountDetailTaxRateArchive
( [AcctDtlID] [int] not null
, [TaxRate] [decimal](20, 10) NOT NULL
, [crdate] datetime not null
 CONSTRAINT [PK_mtv_AccountDetailTaxRateArchive] PRIMARY KEY NONCLUSTERED 
(
	[AcctDtlID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF OBJECT_ID('tempdb..#temptra') IS NOT NULL
begin
   insert into mtv_AccountDetailTaxRateArchive
   select * from #temptra
   
   drop table #temptra
end
go



