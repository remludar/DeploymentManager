-- Object:  Table [dbo].[MTVTMSAccountToTmsStaging]    
PRINT 'Start Script=MTVTMSAccountToTmsStaging.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSAccountToTmsStaging]     ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSAccountToTmsStaging]') IS NOT NULL
BEGIN

    select * into MTVTMSAccountToTMSStaging_temp from MTVTMSAccountToTmsStaging
    
	DROP TABLE [dbo].MTVTMSAccountToTmsStaging
	PRINT '<<< DROPPED TABLE MTVTMSAccountToTmsStaging >>>'
END

/****** Object:  Table [dbo].[MTVTMSAccountToTmsStaging]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


create table [dbo].MTVTMSAccountToTmsStaging
( TmsFileIdnty  int identity(1,1)
,InterfaceName varchar(80)
,InterfaceStatus char(1) null
,Action char(1)
,ErrorMessage varchar(1000)
,LastUpdateDate smalldatetime
,LastUserID int
,DlHdrID int null
,PlnndMvtID int null
,IsDataChanged char(1)
,MiddlewareID int null
,SendData text null
 CONSTRAINT [PK_MTVTMSAccountToTmsStaging] PRIMARY KEY CLUSTERED 
(
	[TmsFileIdnty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



GRANT INSERT,UPDATE,DELETE,SELECT ON MTVTMSAccountToTmsStaging TO RIGHTANGLEACCESS
GO



SET IDENTITY_INSERT MTVTMSAccountToTmsStaging ON
go

IF EXISTS ( SELECT 'X' FROM SYSOBJECTS WHERE NAME = 'MTVTMSACCOUNTTOTMSSTAGING_TEMP')
BEGIN
insert into MTVTMSAccountToTmsStaging
(TmsFileIdnty
,InterfaceName
,InterfaceStatus
,Action
,ErrorMessage
,LastUpdateDate
,LastUserID
,DlHdrID
,PlnndMvtID
,IsDataChanged
,MiddlewareID
,SendData)
select 
TmsFileIdnty
,InterfaceName
,InterfaceStatus
,Action
,ErrorMessage
,LastUpdateDate
,LastUserID
,DlHdrID
,PlnndMvtID
,IsDataChanged
,MiddlewareID
,SendData
 from MTVTMSAccountToTMSStaging_temp


DROP TABLE MTVTMSAccountToTMSStaging_temp
END

SET IDENTITY_INSERT MTVTMSAccountToTmsStaging OFF
go
