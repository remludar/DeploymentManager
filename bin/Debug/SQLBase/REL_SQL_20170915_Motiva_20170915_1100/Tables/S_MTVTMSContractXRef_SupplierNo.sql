/*
*****************************************************************************************************
--USE FIND AND REPLACE ON MTVTMSContractXRef_SupplierNo WITH YOUR SEQUENCE (NOTE: CompanyName is already there)
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVTMSContractXRef_SupplierNo]    Script Date: DATECREATED ******/
PRINT 'Start Script=s_MTVTMSContractXRef_SupplierNo.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

/****** Object:  Table [dbo].[MTVTMSContractXRef_SupplierNo]    Script Date: 02/11/2013 ******/
SET QUOTED_IDENTIFIER OFF
SET ANSI_NULLS ON

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef_SupplierNo]') IS NOT NULL
BEGIN
    DROP SEQUENCE [dbo].[MTVTMSContractXRef_SupplierNo]
    PRINT '<<< DROPPED SEQUENCE [MTVTMSContractXRef_SupplierNo >>>'
END

/****** Object:  Table [dbo].[MTVTMSContractXRef_SupplierNo]    Script Date: 02/11/2013 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE SEQUENCE dbo.MTVTMSContractXRef_SupplierNo
    START WITH 1
    INCREMENT BY 1 ;
GO

GO

SET ANSI_PADDING OFF
GO

IF  OBJECT_ID(N'[dbo].[MTVTMSContractXRef_SupplierNo]') IS NOT NULL
  BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 't_MTVTMSContractXRef_SupplierNo.sql'
    PRINT '<<< CREATED SEQUENCE MTVTMSContractXRef_SupplierNo >>>'
  END
ELSE
	 PRINT '<<< FAILED CREATING SEQUENCE MTVTMSContractXRef_SupplierNo >>>'


