/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVDataLakeMasterSendBA WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVDataLakeMasterSendBA]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVDataLakeMasterSendBA.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVDataLakeMasterSendBA]    Script Date: 05/04/2016 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVDataLakeMasterSendBA]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVDataLakeMasterSendBA]
    PRINT '<<< DROPPED TABLE MTVDataLakeMasterSendBA >>>'
END



/****** Object:  Table [dbo].[MTVDataLakeMasterSendBA]    Script Date: 05/04/2016 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MTVDataLakeMasterSendBA](
	[ID] [int] IDENTITY
	,[BAID] [int] NOT NULL
	,[BAStts] Varchar(1)
	,[Name]   Varchar(100)
	,[Abbreviation]   Varchar(45)
	,[FEIN] Varchar(255)
	,[SCAC]  Varchar(255)
 CONSTRAINT [PK_MTVDataLakeMasterSendBA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVDataLakeMasterSendBA]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVDataLakeMasterSendBA.sql'
    PRINT '<<< CREATED TABLE MTVDataLakeMasterSendBA >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVDataLakeMasterSendBA >>>'


