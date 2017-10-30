/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTMSContractXRef_CustomerNo WITH YOUR TABLE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSContractXRef_CustomerNo]    Script Date: DATECREATED ******/
PRINT 'Start Script=t_MTVTMSContractXRef_CustomerNo.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSContractXRef_CustomerNo]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef_CustomerNo]') IS NOT NULL
BEGIN
    DROP SEQUENCE [dbo].[MTVTMSContractXRef_CustomerNo]
    PRINT '<<< DROPPED TABLE [MTVTMSContractXRef_CustomerNo >>>'
END

/****** Object:  Table [dbo].[MTVTMSContractXRef_CustomerNo]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE SEQUENCE dbo.MTVTMSContractXRef_CustomerNo
    START WITH 5200001
    INCREMENT BY 1 ;
GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef_CustomerNo]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTMSContractXRef_CustomerNo.sql'
    PRINT '<<< CREATED TABLE MTVTMSContractXRef_CustomerNo >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING TABLE MTVTMSContractXRef_CustomerNo >>>'


