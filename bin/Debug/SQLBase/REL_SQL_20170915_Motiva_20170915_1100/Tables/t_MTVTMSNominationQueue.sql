-- Object:  Table [dbo].[MTVTMSContractQueue]    
PRINT 'Start Script=MTVTMSNominationQueue.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSNominationQueue]     ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSNominationQueue]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].MTVTMSNominationQueue
	PRINT '<<< DROPPED TABLE [MTVTMSNominationQueue] >>>'
END

/****** Object:  Table [dbo].[MTVTMSNominationQueue]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO





create table [dbo].MTVTMSNominationQueue
( idnty    int identity(1,1)
, OrderID             int
, Action              char(1)  -- A - Activate   U - Update   C - Cancel
, insertdate          datetime


 CONSTRAINT [PK_MTVTMSNominationQueue] PRIMARY KEY CLUSTERED 
(
	[Idnty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
GRANT INSERT,UPDATE,DELETE,SELECT ON [DBO].MTVTMSNominationQueue TO RIGHTANGLEACCESS
GO