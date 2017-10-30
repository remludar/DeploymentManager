/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxDetail WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTV_DealDetailSoldToShipTo]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_DealDetailSoldToShipTo.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_DealDetailSoldToShipTo]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_DealDetailSoldToShipTo] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_DealDetailSoldToShipTo >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTV_DealDetailSoldToShipTo]
AS
-- =============================================
-- Author:        rchenna
-- Create date:	  04/06/2016
-- Description:   This view builds the composite of MTVSAPBASoldTo=>MTVSAPSoldToShipTo=>MTVDealDetailShipTo tables
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------
--select * from v_MTV_DealDetailSoldToShipTo

SELECT 
dd.DlDtlDlHdrID, 
dd.DlDtlID,
dh.DlHdrIntrnlNbr DealNo,
dd.DlDtlLcleID TitleTransferLocation, 
dd.DlDtlPrdctID RAPrdctID, 
mt.BAID RASoldToBAID, 
mt.SoldTo, 
mt.VendorNumber, 
mt.ClassOfTrade,
ddst.DealDetailID,
ddst.SoldToShipToID, 
dd.DlDtlFrmDte DealDetailFromDate, 
dd.DlDtlToDte DealDetailToDate,
sst.ShipTo, 
sst.RALocaleID RAShipToLcleID,
sst.FromDate EffectiveFromDate, 
sst.ToDate EffectiveToDate  
FROM MTVDealDetailShipTo AS ddst INNER JOIN DealDetail dd ON dd.DealDetailID = ddst.DealDetailID AND dd.DlDtlStat = 'A'
 INNER JOIN DealHeader dh ON dh.DlHdrID = dd.DlDtlDlHdrID
 INNER JOIN MTVSAPSoldToShipTo AS sst ON ddst.SoldToShipToID = sst.ID AND sst.[Status] = 'A'
 INNER JOIN MTVSAPBASoldTo AS mt ON sst.MTVSAPBASoldToID = mt.ID AND mt.[Status] = 'A'

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_DealDetailSoldToShipTo]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_DealDetailSoldToShipTo.sql'
			PRINT '<<< ALTERED View v_MTV_DealDetailSoldToShipTo >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_DealDetailSoldToShipTo >>>'
	  END
