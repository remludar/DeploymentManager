PRINT 'Start Script=t_alter_MTVDLInvPricesStaging_AddColumns.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDLInvPricesStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

BEGIN TRANSACTION

Create table tmp_MTVDLInvPricesStaging
			(
			ID						Int	IDENTITY(1,1) NOT NULL,
			AccountingMonth			Varchar(20),
			Product					Varchar(20),
			MaterialCode			Varchar(255),
			Location				Varchar(120),
			PlantCode				Varchar(255),
			ProductGroup			Varchar(150),
			PriceService			Varchar(20),
			Subgroup				Varchar(150),
			Currency				Char(3),
			QuoteFromDate			Smalldatetime,
			QuoteToDate				Smalldatetime,
			DeliveryPeriod			Int,
			Price					Decimal(19,6),
			UOM						Varchar(20),
			StagingTableLoadDate	Smalldatetime,
			Status					Char(1),
			PricePerGallon			Decimal(19,6),
			MinEndOfDay				Smalldatetime,
			MaxEndOfDay				Smalldatetime
			)

GO
SET IDENTITY_INSERT dbo.tmp_MTVDLInvPricesStaging ON
GO

if exists(select 1 from dbo.sysobjects where id = object_id(N'dbo.MTVDLInvPricesStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		IF exists (select 1 from dbo.MTVDLInvPricesStaging)
			EXEC('
				INSERT dbo.tmp_MTVDLInvPricesStaging (
					ID
					,AccountingMonth
					,Product
					,Location
					,ProductGroup
					,PriceService
					,Subgroup
					,Currency
					,QuoteFromDate
					,QuoteToDate
					,DeliveryPeriod
					,Price
					,UOM
					,StagingTableLoadDate
					,Status
					,PricePerGallon
					,MinEndOfDay
					,MaxEndOfDay
					)
				SELECT	ID
						,AccountingMonth
						,Product
						,Location
						,ProductGroup
						,PriceService
						,Subgroup
						,Currency
						,QuoteFromDate
						,QuoteToDate
						,DeliveryPeriod
						,Price
						,UOM
						,StagingTableLoadDate
						,Status
						,PricePerGallon
						,MinEndOfDay
						,MaxEndOfDay
				FROM dbo.MTVDLInvPricesStaging
				WITH (HOLDLOCK TABLOCKX)')
		if @@ROWCOUNT >= 0
			PRINT 'Records copied from original table: ' + cast(@@ROWCOUNT as varchar)

	END
GO
SET IDENTITY_INSERT dbo.tmp_MTVDLInvPricesStaging OFF
GO

if exists (select 1 from dbo.sysobjects where id = object_id(N'dbo.MTVDLInvPricesStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    DROP TABLE dbo.MTVDLInvPricesStaging
    PRINT '<<< DROPPED TABLE MTVDLInvPricesStaging >>>'
  End
GO
EXECUTE sp_rename N'dbo.tmp_MTVDLInvPricesStaging', N'MTVDLInvPricesStaging', 'OBJECT' 
GO

ALTER TABLE dbo.MTVDLInvPricesStaging WITH NOCHECK ADD
CONSTRAINT [PK_MTVDLInvPricesStaging] PRIMARY KEY CLUSTERED (ID)
GO

/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights to public and notify user
--------------------------------------------*/
If OBJECT_ID('MTVDLInvPricesStaging') Is NOT Null
  BEGIN
    PRINT '<<< CREATED TABLE MTVDLInvPricesStaging >>>'
    if exists (select 1 from dbo.sysusers where name = N'sysuser')
        Grant select, insert, update, delete on dbo.MTVDLInvPricesStaging to sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating Table MTVDLInvPricesStaging >>>'
GO


COMMIT TRANSACTION