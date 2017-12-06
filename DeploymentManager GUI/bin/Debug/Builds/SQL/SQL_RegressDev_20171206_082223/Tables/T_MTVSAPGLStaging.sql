
/****** Object:  ViewName [dbo].[MTVSAPGLStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVSAPGLStaging.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVSAPGLStaging]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVSAPGLStaging]') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[MTVSAPGLStaging]
    PRINT '<<< DROPPED TABLE MTVSAPGLStaging >>>'
END


/****** Object:  Table [dbo].[MTVSAPGLStaging]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO

Create	Table	MTVSAPGLStaging
				(
				ID						Int	Primary Key	IDENTITY,
				CGLIID					Int,
				BatchID					Int,
				CompanyCode				Varchar(10),
				DocumentDate			SmallDateTime,
				PostingDate				SmallDateTime,
				Currency				Char(3),
				DocumentType			Char(2),
				DocumentHeaderText		Varchar(25),
				ReferenceDocument		Varchar(50),
				PostingKey				Int,
				Customer				Varchar(20),
				ReferenceKey1			Varchar(20),
				ReferenceKey2			Varchar(20),
				ReferenceKey3			Varchar(20),
				TaxCode					Char(2),
				DocumentAmount			Decimal(19,6),
				Account					Varchar(10),
				LineItemText			Varchar(50),
				CostCenter				Varchar(10),
				ProfitCenter			Varchar(10),
				Material				Varchar(18),
				Plant					Char(4),
				Quantity				Decimal(19,6),
				BaseUnit				Char(3),
				RightAngleStatus		Varchar(50),
				MiddlewareStatus		Varchar(50),
				SAPStatus				Varchar(50),
				Message					Varchar(1000)
				)

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVSAPGLStaging]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVSAPGLStaging.sql'
    PRINT '<<< CREATED TABLE MTVSAPGLStaging >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVSAPGLStaging >>>'

