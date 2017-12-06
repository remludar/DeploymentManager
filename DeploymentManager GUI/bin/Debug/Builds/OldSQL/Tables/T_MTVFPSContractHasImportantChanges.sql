/****** Object:  Table [dbo].[MTVFPSContractHasImportantChanges]    Script Date: 12/15/2015 9:40:03 AM ******/
PRINT 'Start Script=T_MTVFPSContractHasImportantChanges.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVFPSContractHasImportantChanges]    Script Date: 11/19/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVFPSContractHasImportantChanges]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].MTVFPSContractHasImportantChanges
	PRINT '<<< DROPPED TABLE MTVFPSContractHasImportantChanges >>>'
END

/****** Object:  Table [dbo].[MTVFPSContractHasImportantChanges]    Script Date: 12/15/2015 9:40:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVFPSContractHasImportantChanges](
	[DlHdrID] [int] NOT NULL,
	[HasImportantChanges] [varchar](50) NOT NULL,
 CONSTRAINT [PK_MTVFPSContractHasImportantChanges] PRIMARY KEY CLUSTERED 
(
	[DlHdrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


/*
*****************************************************************************************************
--USE FIND AND REPLACE ON TABLENAME WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[T_MTVFPSContractHasImportantChanges]    Script Date: DATECREATED ******/
PRINT 'Start Script=T_MTVFPSContractHasImportantChanges.GRANT.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVFPSContractHasImportantChanges]') IS NOT NULL
  BEGIN
    GRANT SELECT,ALTER, INSERT, UPDATE, DELETE ON [dbo].[MTVFPSContractHasImportantChanges] to sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on Table MTVFPSContractHasImportantChanges >>>'
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on Table MTVFPSContractHasImportantChanges >>>'

