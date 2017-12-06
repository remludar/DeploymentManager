-- Object:  Table [dbo].[MTVTMSDealDetailShipToDeletedQueue]    
PRINT 'Start Script=MTVTMSDealDetailShipToDeletedQueue.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSDealDetailShipToDeletedQueue]     ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSDealDetailShipToDeletedQueue]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].MTVTMSDealDetailShipToDeletedQueue
	PRINT '<<< DROPPED TABLE [MTVTMSDealDetailShipToDeletedQueue] >>>'
END

/****** Object:  Table [dbo].[MTVTMSDealDetailShipToDeletedQueue]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO





create table [dbo].MTVTMSDealDetailShipToDeletedQueue
( idnty    int identity(1,1)
, DlHdrID             int
, DealDetailID        int
, SoldToShipToID      int
, FromDate            datetime
, ToDate              datetime 
, insertdate          datetime


 CONSTRAINT [PK_MTVTMSDealDetailShipToDeletedQueue] PRIMARY KEY CLUSTERED 
(
	[Idnty] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
GRANT INSERT,UPDATE,DELETE,SELECT ON [DBO].MTVTMSDealDetailShipToDeletedQueue TO RIGHTANGLEACCESS
GO