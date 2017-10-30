/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTV_GeneralComment WITH YOUR TABLE
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_GeneralComment]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTV_GeneralComment.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTV_GeneralComment]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTV_GeneralComment]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTV_GeneralComment]
    PRINT '<<< DROPPED TABLE MTV_GeneralComment >>>'
END


/****** Object:  Table [dbo].[MTV_GeneralComment]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*REPLACE WITH YOUR TABLE CREATION CODE*/
CREATE TABLE [dbo].[MTV_GeneralComment](
	[GnrlCmntQlfr] [varchar](50) NOT NULL,
	[GnrlCmntHdrID] [int] NOT NULL,
	[GnrlCmntDtlID] [smallint] NOT NULL,
	[GnrlCmntTxtOldValue] [varchar](max) NOT NULL,
	[GnrlCmntTxtNewValue] [varchar](max) NOT NULL,
 CONSTRAINT [PK_MTVGeneralComment] PRIMARY KEY CLUSTERED 
(
	[GnrlCmntQlfr] ASC,
	[GnrlCmntHdrID] ASC,
	[GnrlCmntDtlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTV_GeneralComment]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTV_GeneralComment.sql'
    PRINT '<<< CREATED TABLE MTV_GeneralComment >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTV_GeneralComment >>>'

