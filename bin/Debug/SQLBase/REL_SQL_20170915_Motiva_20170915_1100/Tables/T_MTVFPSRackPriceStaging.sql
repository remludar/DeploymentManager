---Start of Script: T_MTVFPSRackPriceStaging.sql
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

BEGIN TRANSACTION

Print 'Start Script=T_MTVFPSRackPriceStaging.sql  Domain=MPC  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

--****************************************************************************************************************
-- Name:       MTVFPSRackPriceStaging                                              Copyright 2012 SolArc
-- Overview:   Table Creation Script: MTVFPSRackPriceStaging
-- Created by: Sean A. Brown
-- History:    19 Sep 2012 - First Created
--****************************************************************************************************************
-- Date         Modified        Issue#      Modification
-- -----------  --------------  ----------  -----------------------------------------------------------------------
-- 19 Sep 2012  S. Brown        N/A         Initial Creation
------------------------------------------------------------------------------------------------------------------

CREATE TABLE dbo.tmp_MTVFPSRackPriceStaging (
    [MFRPID] [int] IDENTITY(1,1) NOT NULL,
	[idi_id] [int] NULL,
	[idi_import] [int] NULL,
	[prefix] [varchar](80) NULL,
	[cou_code] [varchar](80) NULL,
	[sequence_number] [int] NULL,
	[record_number] [int] NULL,
	[idi_status] [varchar](80) NULL,
	[idi_rec_error] [varchar](80) NULL,
	[CreatedDate] [smalldatetime] NULL,
	[idi_gmt_processed_date] [smalldatetime] NULL,
	[i_ogs_id] [int] NULL,
	[i_ogs_idi_id] [int] NULL,
	[i_ogs_rec_type] [varchar](80) NULL,
	[i_ogs_condition_type] [varchar](80) NULL,
	[i_ogs_condition_table] [int] NULL,
	[i_ogs_cond_tab_usage] [varchar](80) NULL,
	[i_ogs_application] [varchar](80) NULL,
	[i_ogs_vakey] [varchar](80) NULL,
	[i_ogs_sales_org] [varchar](4) NULL,
	[i_ogs_dist_channel] [int] NULL,
	[i_ogs_sold_to_code] [varchar](80) NULL,
	[i_ogs_ship_to_code] [varchar](80) NULL,
	[i_ogs_plant_code] [varchar](80) NULL,
	[i_ogs_product] [varchar](80) NULL,
	[i_ogs_division] [varchar](80) NULL,
	[i_ogs_shipping_cond] [varchar](80) NULL,
	[i_ogs_cust_group] [varchar](80) NULL,
	[i_ogs_start_date] [varchar](80) NULL,
	[i_ogs_start_time] [varchar](80) NULL,
	[i_ogs_end_date] [varchar](80) NULL,
	[i_ogs_end_time] [varchar](80) NULL,
	[i_ogs_value] [float] NULL,
	[i_ogs_currency] [varchar](80) NULL,
	[i_ogs_quantity] [int] NULL,
	[i_ogs_uom] [varchar](80) NULL,
	[i_ogs_delete_flag] [char](1) NULL,
	[i_ogs_update_flag] [char](1) NULL,
	[i_ogs_sequence] [varchar](80) NULL,
	[RAPriceServiceID] [int] NULL,
	[RAProductID] [int] NULL,
	[RALocaleID] [int] NULL,
	[RAToLocaleID] [int] NULL,
	[RAPriceCurveID] [int] NULL,
	[RACurrencyID] [int] NULL,
	[RAUOMID] [int] NULL,
	[RAQuoteStart] [smalldatetime] NULL,
	[RAQuoteEnd] [smalldatetime] NULL,
	[RAValue] [float] NULL,
	[RecordStatus] [char](1) NOT NULL,
	[ErrorMessage] [varchar](max) NULL,
	[ImportDate] [smalldatetime] NULL,
	[ModifiedDate] [smalldatetime] NULL,
	[UserID] [int] NULL,
	[ProcessedDate] [smalldatetime] NULL,
	[RawPriceDtlIdnty] [int] NULL,
    )
GO

SET IDENTITY_INSERT dbo.tmp_MTVFPSRackPriceStaging ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVFPSRackPriceStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    IF EXISTS(SELECT * FROM dbo.MTVFPSRackPriceStaging)
        EXEC('
            INSERT  dbo.tmp_MTVFPSRackPriceStaging (
                    MFRPID
					,idi_id
					,idi_import
					,prefix
					,cou_code
					,sequence_number
					,record_number
					,idi_status
					,idi_rec_error
					,CreatedDate
					,idi_gmt_processed_date
					,i_ogs_id
					,i_ogs_idi_id
					,i_ogs_rec_type
					,i_ogs_condition_type
					,i_ogs_condition_table
					,i_ogs_cond_tab_usage
					,i_ogs_application
					,i_ogs_vakey
					,i_ogs_sales_org
					,i_ogs_dist_channel
					,i_ogs_sold_to_code
					,i_ogs_ship_to_code
					,i_ogs_plant_code
					,i_ogs_product
					,i_ogs_division
					,i_ogs_shipping_cond
					,i_ogs_cust_group
					,i_ogs_start_date
					,i_ogs_start_time
					,i_ogs_end_date
					,i_ogs_end_time
					,i_ogs_value
					,i_ogs_currency
					,i_ogs_quantity
					,i_ogs_uom
					,i_ogs_delete_flag
					,i_ogs_update_flag
					,i_ogs_sequence
					,RAPriceServiceID
					,RAProductID
					,RALocaleID
					,RAToLocaleID
					,RAPriceCurveID
					,RACurrencyID
					,RAUOMID
					,RAQuoteStart
					,RAQuoteEnd
					,RAValue
					,RecordStatus
					,ErrorMessage
					,ImportDate
					,ModifiedDate
					,UserID
					,ProcessedDate
					,RawPriceDtlIdnty
                    )
            Select  MFRPID
					,idi_id
					,idi_import
					,prefix
					,cou_code
					,sequence_number
					,record_number
					,idi_status
					,idi_rec_error
					,CreatedDate
					,idi_gmt_processed_date
					,i_ogs_id
					,i_ogs_idi_id
					,i_ogs_rec_type
					,i_ogs_condition_type
					,i_ogs_condition_table
					,i_ogs_cond_tab_usage
					,i_ogs_application
					,i_ogs_vakey
					,i_ogs_sales_org
					,i_ogs_dist_channel
					,i_ogs_sold_to_code
					,i_ogs_ship_to_code
					,i_ogs_plant_code
					,i_ogs_product
					,i_ogs_division
					,i_ogs_shipping_cond
					,i_ogs_cust_group
					,i_ogs_start_date
					,i_ogs_start_time
					,i_ogs_end_date
					,i_ogs_end_time
					,i_ogs_value
					,i_ogs_currency
					,i_ogs_quantity
					,i_ogs_uom
					,i_ogs_delete_flag
					,i_ogs_update_flag
					,i_ogs_sequence
					,RAPriceServiceID
					,RAProductID
					,RALocaleID
					,RAToLocaleID
					,RAPriceCurveID
					,RACurrencyID
					,RAUOMID
					,RAQuoteStart
					,RAQuoteEnd
					,RAValue
					,RecordStatus
					,ErrorMessage
					,ImportDate
					,ModifiedDate
					,UserID
					,ProcessedDate
					,RawPriceDtlIdnty
            FROM    MTVFPSRackPriceStaging
            WITH    (HOLDLOCK TABLOCKX)')
            
    IF @@ROWCOUNT >= 0
        PRINT 'Records copied from original table: ' + cast(@@ROWCOUNT as varchar)

  End
GO
SET IDENTITY_INSERT dbo.tmp_MTVFPSRackPriceStaging OFF
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVFPSRackPriceStaging') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    DROP TABLE dbo.MTVFPSRackPriceStaging
    PRINT '<<< DROPPED TABLE MTVFPSRackPriceStaging >>>'
  End
GO
EXECUTE sp_rename N'dbo.tmp_MTVFPSRackPriceStaging', N'MTVFPSRackPriceStaging', 'OBJECT' 
GO

ALTER TABLE dbo.MTVFPSRackPriceStaging WITH NOCHECK ADD
CONSTRAINT [PK_MTVFPSRackPriceStaging] PRIMARY KEY CLUSTERED (MFRPID)
GO

/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights to public and notify user
--------------------------------------------*/
If OBJECT_ID('MTVFPSRackPriceStaging') Is NOT Null
  BEGIN
    PRINT '<<< CREATED TABLE MTVFPSRackPriceStaging >>>'
    if exists (select * from dbo.sysusers where name = N'sysuser')
        Grant select, insert, update, delete on dbo.MTVFPSRackPriceStaging to sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating Table MTVFPSRackPriceStaging>>>'
GO


COMMIT TRANSACTION