/****** Object:  ViewName [dbo].[MTVFPSFuelSalesVolStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVOrionNominationStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVOrionNominationStaging]    Script Date: 09/03/2015 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVOrionNominationStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].MTVOrionNominationStaging
    PRINT '<<< DROPPED TABLE MTVOrionNominationStaging >>>'
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[MTVOrionNominationStaging](
	[ID] [INT] IDENTITY(1,1) NOT NULL,
	[PlnndMvtID] [INT] NOT NULL,
	[PlnndTrnsfrID] [INT] NOT NULL,
	[LocaleID] [INT] NOT NULL,
	[PrdctID] [INT] NOT NULL,
	[PUMP_DATE] [DATETIME] NOT NULL,
	[VOLUME] [FLOAT] NOT NULL,
	[VESSEL] [NVARCHAR](100) NULL,
	[RDIndicator] [CHAR](1) NOT NULL,
	[MethodTransportation] [CHAR](2) NOT NULL,
	[ChangeDate] [datetime] NOT NULL
) ON [PRIMARY]


GO

Execute SRA_Index_Check @s_table	= 'MTVOrionNominationStaging', 
				    @s_index		= 'PK_MTVOrionNominationStaging_ID',
				    @s_keys			= 'ID',
				    @c_unique		= 'Y',
				    @c_clustered	= 'N',
				    @c_primarykey	= 'Y',
				    @c_uniquekey	= 'Y',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';

Execute SRA_Index_Check @s_table	= 'MTVOrionNominationStaging', 
				    @s_index		= 'IK_MTVOrionNominationStaging',
				    @s_keys			= 'LocaleID,PUMP_DATE',
				    @c_unique		= 'N',
				    @c_clustered	= 'Y',
				    @c_primarykey	= 'N',
				    @c_uniquekey	= 'N',
				    @c_build_index	= 'Y',
				    @vc_domain		= 'Interfaces';

GO


IF  OBJECT_ID(N'[dbo].[MTVOrionNominationStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'T_MTVOrionNominationStaging.sql'
    PRINT '<<< CREATED TABLE MTVOrionNominationStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVOrionNominationStaging >>>'


