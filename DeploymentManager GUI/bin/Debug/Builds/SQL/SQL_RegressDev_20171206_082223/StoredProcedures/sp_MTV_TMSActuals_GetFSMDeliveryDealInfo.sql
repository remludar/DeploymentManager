/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TMSActuals_GetFSMDeliveryDealInfo WITH YOUR Stored Procedure name
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[MTV_TMSActuals_GetFSMDeliveryDealInfo]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TMSActuals_GetFSMDeliveryDealInfo.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TMSActuals_GetFSMDeliveryDealInfo]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_TMSActuals_GetFSMDeliveryDealInfo] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_TMSActuals_GetFSMDeliveryDealInfo >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTV_TMSActuals_GetFSMDeliveryDealInfo]	
	@soldTo varchar(80),
	@shipTo varchar(80),
	@prdctID int,
	@lcleID int,
	@mvtDte datetime
AS

-----------------------------------------------------------------------------------------------------------------------------
-- Name			:MTV_TMSActuals_GetFSMDeliveryDealInfo          
-- Overview		:This Procedure will retrieve the Delivery deal info for TMS Actuals FSM records
-- Created by	:MattV
-- History		:06/22/2017 - First Created
-- 	Date Modified 	Modified By	Issue#	Modification
-- 	--------------- -------------- 	------	-------------------------------------------------------------------------


select Distinct DlHdrIntrnlNbr as 'DealNo', DlDtlDlHdrID, BAST.BAID as 'RASoldToBAID'
from MTVSAPBASoldTo BAST

inner join GeneralConfiguration SoldTo
on GnrlCnfgTblNme = 'DealHeader'
and GnrlCnfgMulti = BAST.ID
and GnrlCnfgMulti <> 'X'
and GnrlCnfgQlfr = 'SAPSoldTo'
and BAST.SoldTo = @soldTo

inner join DealHeader
on GnrlCnfgHdrID = DlHdrID
and DlHdrStat = 'A'

inner join DealDetail
on DlDtlDlHdrID = DlHdrID
and DlDtlPrdctID = @prdctID
and DlDtlLcleID = @lcleID
and @mvtDte between DlDtlFrmDte and DlDtlToDte
and DlDtlStat = 'A'

inner join MTVSAPSoldToShipTo STST
on BAST.ID = STST.MTVSAPBASoldToID
and STST.ShipTo = @shipTo
and @mvtDte between STST.FromDate and STST.ToDate


GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_TMSActuals_GetFSMDeliveryDealInfo]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_TMSActuals_GetFSMDeliveryDealInfo.sql'
			PRINT '<<< ALTERED StoredProcedure MTV_TMSActuals_GetFSMDeliveryDealInfo >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_TMSActuals_GetFSMDeliveryDealInfo >>>'
	  END

/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TMSActuals_GetFSMDeliveryDealInfo WITH YOUR stored procedure 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTV_TMSActuals_GetFSMDeliveryDealInfo]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_TMSActuals_GetFSMDeliveryDealInfo.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_TMSActuals_GetFSMDeliveryDealInfo]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTV_TMSActuals_GetFSMDeliveryDealInfo TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTV_TMSActuals_GetFSMDeliveryDealInfo >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTV_TMSActuals_GetFSMDeliveryDealInfo >>>'

