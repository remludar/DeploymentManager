/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVSAPBASoldTo WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVSAPBASoldTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPBASoldTo.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSAPBASoldTo]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

BEGIN TRANSACTION

CREATE TABLE dbo.tmp_MTVSAPBASoldTo (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BAID] [int] NOT NULL,
	[SoldTo] [varchar](80) NULL,
	[VendorNumber] [varchar](80) NULL,
	[ClassOfTrade] [varchar](40) NOT NULL,
	[CreditLock] [char](1) NOT NULL,
	[LastCreditUpdateUserID] [int] NOT NULL,
	[LastCreditUpdateDate] [DateTime] NOT NULL,
	[Status] [char](1) NOT NULL,
	[LastUpdateUserID] [int] NULL,
	[LastUpdateDate] [DateTime] NULL
	)

GO

SET IDENTITY_INSERT dbo.tmp_MTVSAPBASoldTo ON
GO
if exists(select * from dbo.sysobjects where id = object_id(N'dbo.MTVSAPBASoldTo') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
		IF exists (select * from dbo.MTVSAPBASoldTo)
			EXEC('
				INSERT dbo.tmp_MTVSAPBASoldTo (
					ID
					,BAID
					,SoldTo
					,VendorNumber
					,ClassOfTrade
					,CreditLock
					,LastCreditUpdateUserID
					,LastCreditUpdateDate
					,Status
					,LastUpdateUserID
					,LastUpdateDate
					)
				SELECT ID
					,BAID
					,SoldTo
					,VendorNumber
					,ClassOfTrade
					,CreditLock
					,LastCreditUpdateUserID
					,LastCreditUpdateDate
					,Status
					,LastUpdateUserID
					,LastUpdateDate
				FROM dbo.MTVSAPBASoldTo
				WITH (HOLDLOCK TABLOCKX)')
		if @@ROWCOUNT >= 0
			PRINT 'Records copied from original table: ' + cast(@@ROWCOUNT as varchar)

	END
GO
SET IDENTITY_INSERT dbo.tmp_MTVSAPBASoldTo OFF
GO

if exists (select * from dbo.sysobjects where id = object_id(N'dbo.MTVSAPBASoldTo') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
  Begin
    DROP TABLE dbo.MTVSAPBASoldTo
    PRINT '<<< DROPPED TABLE MTVSAPBASoldTo >>>'
  End
GO
EXECUTE sp_rename N'dbo.tmp_MTVSAPBASoldTo', N'MTVSAPBASoldTo', 'OBJECT' 
GO

ALTER TABLE dbo.MTVSAPBASoldTo WITH NOCHECK ADD
CONSTRAINT [PK_MTVSAPBASoldTo] PRIMARY KEY CLUSTERED (ID)
GO

/*--------------------------------------------
-- If the table was successfully created then 
-- grant rights to public and notify user
--------------------------------------------*/
If OBJECT_ID('MTVSAPBASoldTo') Is NOT Null
  BEGIN
    PRINT '<<< CREATED TABLE MTVSAPBASoldTo >>>'
    if exists (select * from dbo.sysusers where name = N'sysuser')
        Grant select, insert, update, delete on dbo.MTVSAPBASoldTo to sysuser, RightAngleAccess
  END
ELSE
    PRINT '<<<Failed Creating Table MTVSAPBASoldTo>>>'
GO


COMMIT TRANSACTION