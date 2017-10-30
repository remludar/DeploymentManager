/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTV_SAPSoldToShipTo WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTV_SAPSoldToShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_SAPSoldToShipTo.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_SAPSoldToShipTo]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_SAPSoldToShipTo] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_SAPSoldToShipTo >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTV_SAPSoldToShipTo]
AS
-- =============================================
-- Author:        YOURNAME
-- Create date:	  DATECREATED
-- Description:   SHORT DESCRIPTION OF WHAT THIS THINGS DOES\
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------

SELECT dd.DlDtlDlHdrID, 
dd.DlDtlID,
dh.DlHdrIntrnlNbr DealNo,
dd.DlDtlLcleID TitleTransferLocation,
dh.DlHdrTyp DealTypeID, 
dd.DlDtlPrdctID RAPrdctID, 
mt.BAID RASoldToBAID, 
mt.SoldTo, 
CASE WHEN mt.VendorNumber IS NULL THEN OnlyVendor.VendorNumber ELSE mt.VendorNumber END AS VendorNumber, 
mt.ClassOfTrade,
ddst.DealDetailID,
ddst.SoldToShipToID, 
dd.DlDtlFrmDte DealDetailFromDate, 
dd.DlDtlToDte DealDetailToDate,
sst.ShipTo, 
sst.RALocaleID RAShipToLcleID,
sst.FromDate EffectiveFromDate, 
sst.ToDate EffectiveToDate  
--select *
FROM DealHeader dh
INNER JOIN DealDetail dd
ON dh.DlHdrID = dd.DlDtlDlHdrID
AND dd.DlDtlStat = 'A'
LEFT OUTER JOIN GeneralConfiguration
ON	dh.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
AND GeneralConfiguration.GnrlCnfgHdrID <> 0
LEFT OUTER JOIN  MTVSAPBASoldTo AS mt 
ON GeneralConfiguration.GnrlCnfgMulti = mt.ID AND mt.[Status] = 'A'
LEFT OUTER JOIN MTVDealDetailShipTo AS ddst 
ON dd.DealDetailID = ddst.DealDetailID
LEFT OUTER JOIN  MTVSAPSoldToShipTo AS sst 
ON ddst.SoldToShipToID = sst.ID AND sst.[Status] = 'A'
LEFT OUTER JOIN
	(SELECT VendorNo.GnrlCnfgHdrID
			,mtvndr.VendorNumber
	 FROM	GeneralConfiguration VendorNo
	 INNER JOIN  MTVSAPBASoldTo AS mtvndr 
	 ON VendorNo.GnrlCnfgMulti = mtvndr.ID AND mtvndr.[Status] = 'A'
	 WHERE	VendorNo.GnrlCnfgTblNme = 'DealHeader'
	 AND	VendorNo.GnrlCnfgQlfr = 'SAPVendorNo'
	 AND	VendorNo.GnrlCnfgHdrID <> 0
	 ) AS OnlyVendor
ON	dh.DlHdrID	= OnlyVendor.GnrlCnfgHdrID

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_SAPSoldToShipTo]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_SAPSoldToShipTo.sql'
			PRINT '<<< ALTERED View v_MTV_SAPSoldToShipTo >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_SAPSoldToShipTo >>>'
	  END
