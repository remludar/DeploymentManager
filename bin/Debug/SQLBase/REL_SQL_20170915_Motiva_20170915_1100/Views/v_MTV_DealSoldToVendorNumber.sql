/*
*****************************************************************************************************
USE FIND AND REPLACE ON DealSoldToVendorNumber WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTV_DealSoldToVendorNumber]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_DealSoldToVendorNumber.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_DealSoldToVendorNumber]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_DealSoldToVendorNumber] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_DealSoldToVendorNumber >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTV_DealSoldToVendorNumber]
AS
-- =============================================
-- Author:        YOURNAME
-- Create date:	  DATECREATED
-- Description:   SHORT DESCRIPTION OF WHAT THIS THINGS DOES\
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------

select	DealHeader.DlHdrID
		,MTVSAPBASoldTo.SoldTo as DealSoldTo
		,MTVSAPBASoldTo.VendorNumber as DealVendorNumber
		,DynamicListBox.DynLstBxDesc as ClassOfTrade
from	DealHeader (NoLock)
INNER JOIN	GeneralConfiguration (NoLock)
ON	DealHeader.DlHdrID = GeneralConfiguration.GnrlCnfgHdrID
AND	GeneralConfiguration.GnrlCnfgQlfr = 'SAPSoldTo'
AND	GeneralConfiguration.GnrlCnfgTblNme = 'DealHeader'
AND	GeneralConfiguration.GnrlCnfgHdrID <> 0
INNER JOIN	MTVSAPBASoldTo (NoLock)
ON	GeneralConfiguration.GnrlCnfgMulti = MTVSAPBASoldTo.ID
LEFT OUTER JOIN	MTVSAPBASoldToClassOfTrade (NoLock)
ON	MTVSAPBASoldTo.ID = MTVSAPBASoldToClassOfTrade.BASoldToID
INNER JOIN	DynamicListBox (NoLock)
ON	MTVSAPBASoldTo.ClassOfTrade = DynamicListBox.DynLstBxTyp
AND	DynamicListBox.DynLstBxQlfr = 'BASoldToClassOfTrade'


GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_DealSoldToVendorNumber]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_DealSoldToVendorNumber.sql'
			PRINT '<<< ALTERED View v_MTV_DealSoldToVendorNumber >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_DealSoldToVendorNumber >>>'
	  END
