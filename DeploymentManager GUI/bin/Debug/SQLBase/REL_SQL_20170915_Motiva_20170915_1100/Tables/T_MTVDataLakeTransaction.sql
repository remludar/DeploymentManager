/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDataLakeTransaction WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeTransaction]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeTransaction.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDataLakeTransaction]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTransaction]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDataLakeTransaction]
    PRINT '<<< DROPPED TABLE [MTVDataLakeTransaction >>>'
END

/****** Object:  Table [dbo].[MTVDataLakeTransaction]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVDataLakeTransaction
	(
	 ID			INT	IDENTITY	
      ,[Source] VARCHAR(2)
      ,[T4BatchId] VARCHAR(54)
      ,[PlnndTrnsfrID] Int
       ,[Status]	VARCHAR(54)
      ,[Quantity]	Float
      ,[QuantityScheduled]	Float
      ,[RemainingToSchedule] Float	
CONSTRAINT [PK_MTVDataLakeTransaction] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeTransaction]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDataLakeTransaction.sql'
    PRINT '<<< CREATED TABLE MTVDataLakeTransaction >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDataLakeTransaction >>>'


