/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_UpdateYPPriceCurveUseForRiskFlag WITH YOUR view (NOTE:  sp_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag]   Script Date: DATECREATED ******/
PRINT 'Start Script=[MTV_UpdateYPPriceCurveUseForRiskFlag].sql  Domain=  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure [MTV_UpdateYPPriceCurveUseForRiskFlag] >>>'
	  END
GO

/****** Object:  StoredProcedure [dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag]    Script Date: 5/16/2016 11:48:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER  PROCEDURE [dbo].MTV_UpdateYPPriceCurveUseForRiskFlag
AS

-- exec MTV_UpdateYPPriceCurveUseForRiskFlag 'AccountDetail Inserted:AcctDtlID=27634||AcctDtlSrceID=18934||AcctDtlSrceTble=T ||AcctDtlTrnsctnTypID=2449||Reversed=N||AcctDtlPrntID=27633||AcctDtlTrnsctnDte=Oct  1 2016  1:54:00||AcctDtlAccntngPrdID=||AcctDtlTxStts=N'
-----------------------------------------------------------------------------------------------------------------------------
-- Name:	MTV_UpdateYPPriceCurveUseForRiskFlag txdtlid:xxxxx     
-- Overview:	Updated the Use For Risk flag to Y for YP06 and YP02 FPS Conditions.
-- Created by:	Alan Oldfield  1/30/2017
-- History:	
--
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------
-----------------------------------------------------------------------------------------------------------------------------
SET NOCOUNT ON

UPDATE rpl SET rpl.UseForRisk = 'N'
FROM dbo.RawPriceHeader rph (NOLOCK)
INNER JOIN dbo.GeneralConfiguration gc (NOLOCK)
ON gc.GnrlCnfgHdrID = rph.RPHdrID
AND gc.GnrlCnfgTblNme = 'RawPriceHeader'
AND gc.GnrlCnfgQlfr = 'FPSConditionType'
AND gc.GnrlCnfgMulti IN ('YP02','YP06')
INNER JOIN dbo.RawPriceLocale rpl
ON rpl.RPLcleRPHdrID = rph.RPHdrID
AND rpl.UseForRisk = 'Y'

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_UpdateYPPriceCurveUseForRiskFlag]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_UpdateYPPriceCurveUseForRiskFlag.sql'
	PRINT '<<< ALTERED StoredProcedure MTV_UpdateYPPriceCurveUseForRiskFlag >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_UpdateYPPriceCurveUseForRiskFlag >>>'
END