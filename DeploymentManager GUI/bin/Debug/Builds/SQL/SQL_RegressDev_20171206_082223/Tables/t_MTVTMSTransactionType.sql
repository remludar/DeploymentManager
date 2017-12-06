PRINT 'Start Script=T_MTVTMSTransactionType.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO


PRINT 'Creating Table = MTVTMSTransactionType'
GO

If	Exists(Select * From dbo.sysobjects Where id = object_id(N'dbo.MTVTMSTransactionType') And OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Begin
		exec SRA_Drop_Table @s_table='MTVTMSTransactionType',@onlySQL='N',@verbose='Y';
	End
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[MTVTMSTransactionType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TransTypeID] varchar(10) NOT NULL,
	[TranDescription] [varchar](50) NOT NULL,
	[Status] [char](1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[Message] [varchar](256) NULL,
 CONSTRAINT [PK_MTVTMSTransactionType_ID] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_MTVTMSTransactionType] UNIQUE NONCLUSTERED 
(
	[TransTypeID] ASC,
	[StartDate] ASC,
	[EndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

IF  OBJECT_ID(N'[dbo].[MTVTMSTransactionType]') IS NOT NULL
  BEGIN
    GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[MTVTMSTransactionType] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVTMSTransactionType >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVTMSTransactionType >>>'
GO    

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSTransactionType]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTMSTransactionType.sql'
    PRINT '<<< CREATED TABLE MTVTMSTransactionType >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTMSTransactionType >>>'
			    
GO

