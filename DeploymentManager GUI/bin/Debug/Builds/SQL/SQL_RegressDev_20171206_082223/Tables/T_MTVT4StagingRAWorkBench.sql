/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVT4StagingRAWorkBench WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVT4StagingRAWorkBench]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVT4StagingRAWorkBench.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVT4StagingRAWorkBench]    Script Date:  11/18/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVT4StagingRAWorkBench]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVT4StagingRAWorkBench]
    PRINT '<<< DROPPED TABLE [MTVT4StagingRAWorkBench >>>'
END


/****** Object:  Table [dbo].[MTVT4StagingRAWorkBench]    Script Date: 11/18/2015 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

Create Table MTVT4StagingRAWorkBench
	(
	 T4WorkBenchID						INT	IDENTITY	
	,CarrierReferenceBatchID			VARCHAR(50)
	,LineItemNumber						INT			   
	,PlnndMvtID							INT
	,PlnndTrnsfrID						INT
	,DealDetailID						INT			
	,DLDtlID							INT
	,DlDtlDlHdrID						INT 	
	
CONSTRAINT [PK_MTVT4StagingRAWorkBench] PRIMARY KEY CLUSTERED 
(
	T4WorkBenchId ASC
	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVT4StagingRAWorkBench]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVT4StagingRAWorkBench.sql'
    PRINT '<<< CREATED TABLE MTVT4StagingRAWorkBench >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVT4StagingRAWorkBench >>>'


