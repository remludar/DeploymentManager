---Start of Script: T_MTVSAPSoldToShipTo.sql
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON
GO

BEGIN TRANSACTION

Print 'Start Script=T_MTVSAPSoldToShipTo.sql  Domain=MPC  Time=' + Convert(varchar(50), getdate(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

		Create Table	dbo.tmp_MTVSAPSoldToShipTo
						([ID] [int] IDENTITY(1,1) NOT NULL,
						[MTVSAPBASoldToID] [int] NOT NULL,
						[ShipTo] [varchar](256) NOT NULL,
						[RALocaleID] [int] NOT NULL,
						[CareOf] [varchar](256) NULL,
						[FromDate] [datetime] NULL,
						[ToDate] [datetime] NULL,
						[TMSOverrideEDIConsigneeNbr] [varchar](14) NULL,
						[ShipToAccountName] [varchar](256) NULL,
						[ShipToShortAccountName] [varchar](256) NULL,
						[ShipToCountry] [int] NULL,
						[ShipToAddress] [varchar](256) NULL,
						[ShipToAddress1] [varchar](256) NULL,
						[ShipToAddress2] [varchar](256) NULL,
						[ShipToCity] [varchar](256) NULL,
						[ShipToState] [varchar](3) NULL,
						[ShipToZip] [varchar](10) NULL,
						[ShipToPhone] [varchar](20) NULL,
						[LastUpdateUserID] [int] NULL,
						[LastUpdateDate] [datetime] NULL,
						[Status] [char](1) NOT NULL,
						)	On 'Default'

						
SET IDENTITY_INSERT dbo.tmp_MTVSAPSoldToShipTo ON
GO
if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVSAPSoldToShipTo') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    IF EXISTS(SELECT * FROM dbo.MTVSAPSoldToShipTo)
        EXEC('
            INSERT  dbo.tmp_MTVSAPSoldToShipTo (
                    ID
					,MTVSAPBASoldToID
					,ShipTo
					,RALocaleID
					,CareOf
					,FromDate
					,ToDate
					,TMSOverrideEDIConsigneeNbr
					,ShipToAccountName
					,ShipToShortAccountName
					,ShipToCountry
					,ShipToAddress
					,ShipToAddress1
					,ShipToAddress2
					,ShipToCity
					,ShipToState
					,ShipToZip
					,ShipToPhone
					,LastUpdateUserID
					,LastUpdateDate
					,Status			
                    )
            Select  ID
					,MTVSAPBASoldToID
					,ShipTo
					,RALocaleID
					,CareOf
					,FromDate
					,ToDate
					,TMSOverrideEDIConsigneeNbr
					,ShipToAccountName
					,ShipToShortAccountName
					,ShipToCountry
					,ShipToAddress
					,ShipToAddress1
					,ShipToAddress2
					,ShipToCity
					,ShipToState
					,ShipToZip
					,ShipToPhone
					,LastUpdateUserID
					,LastUpdateDate
					,Status
            FROM    MTVSAPSoldToShipTo
            WITH    (HOLDLOCK TABLOCKX)')
            
    IF @@ROWCOUNT >= 0
        PRINT 'Records copied from original table: ' + cast(@@ROWCOUNT as varchar)

  End
GO
SET IDENTITY_INSERT dbo.tmp_MTVSAPSoldToShipTo OFF
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVSAPSoldToShipTo') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    DROP TABLE dbo.MTVSAPSoldToShipTo
    PRINT '<<< DROPPED TABLE MTVSAPSoldToShipTo >>>'
  End
GO
EXECUTE sp_rename N'dbo.tmp_MTVSAPSoldToShipTo', N'MTVSAPSoldToShipTo', 'OBJECT' 
GO

ALTER TABLE dbo.MTVSAPSoldToShipTo WITH NOCHECK ADD
CONSTRAINT [PK_MTVSAPSoldToShipTo] PRIMARY KEY CLUSTERED (ID)
GO

/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights to public and notify user
--------------------------------------------*/
If OBJECT_ID('MTVSAPSoldToShipTo') Is NOT Null
  BEGIN
    PRINT '<<< CREATED TABLE MTVSAPSoldToShipTo >>>'
    if exists (select * from dbo.sysusers where name = N'sysuser')
        Grant select, insert, update, delete on dbo.MTVSAPSoldToShipTo to sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating Table MTVSAPSoldToShipTo>>>'
GO


COMMIT TRANSACTION