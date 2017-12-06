/****** Object:  StoredProcedure [dbo].[MTV_Get_NewTaxCombinations]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTV_Get_NewTaxCombinations.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_NewTaxCombinations]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_Get_NewTaxCombinations] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_Get_NewTaxCombinations >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

SET NOCOUNT ON
GO

ALTER PROCEDURE [dbo].MTV_Get_NewTaxCombinations
AS
------------------------------------------------------------------------------------------------------------------
--  Procedure:  MOT_Get_NewTaxCombinations
--  Created By: Debbie Keeton
--  Created:    12/19/2016
--  Purpose:    looks for new tax combinations of externalba, soldto, shipto, prodctid, origin,destination
--              Look for any dealdetails or matched movements created or updated since the last run date
------------------------------------------------------------------------------------------------------------------


DECLARE @RegEntry VARCHAR(255)
DECLARE @dt_LastUpdateDate DATETIME
DECLARE @dt_UpdateDate DATETIME

EXECUTE SP_Get_Registry_Value 'Motiva\TAX\NewCombination\LastUpdateDate',@RegEntry OUT

SET @dt_LastUpdateDate = CONVERT(DATETIME,@RegEntry)
SET @dt_UpdateDate = GETDATE()

CREATE TABLE #tempcombos ( 
	ID  [INT] IDENTITY(1,1) NOT NULL,
	DealDetailID [INT] NULL,
	XhdrID [INT] NULL,
	ExternalBaid [INT] NULL,
	SoldTo [VARCHAR] (10) NULL,
	ShipTo [VARCHAR] (10)  NULL,
	PrdctID [INT]  NULL,
	Originlcleid [INT] NULL,
	DestinationLcleid [INT] NULL,
	DealDetailSoldToShipToID [INT] NULL
)

INSERT INTO #tempcombos (DealDetailID, XhdrID, ExternalBaid, SoldTo, ShipTo, PrdctID, OriginLcleID, DestinationLcleID)
SELECT dd.DealDetailID,TH.XhdrID,DH.DlHdrExtrnlBaid,
	SUBSTRING(SoldTo.GnrlCnfgMulti,1,10) SoldTo,
	SUBSTRING(ShipTo.GnrlCnfgMulti,1,10) ShipTo, 
	MH.MvtHdrPrdctID,mh.MvtHdrLcleID,
	MTVSAPSoldToShipTo.RALocaleID
FROM dbo.TransactionHeader TH (NOLOCK) 
INNER JOIN dbo.PlannedTransfer PT (NOLOCK)
ON PT.PlnndTrnsfrID = TH.XHdrPlnndTrnsfrID
AND TH.XHdrDte  > @dt_LastUpdateDate
AND TH.XhdrDte <= @dt_UpdateDate
INNER JOIN dbo.MovementHeader MH (NOLOCK)
ON MH.MvtHdrID = TH.XHdrMvtDtlMvtHdrID
INNER JOIN dbo.DealHeader DH (NOLOCK)
ON DH.DlHDrID = PT.PlnndTrnsfrObDlDtlDlHdrID
INNER JOIN dbo.DealDetail DD (NOLOCK)
ON DD.DlDtlDlHdrID = PT.PlnndTrnsfrObDlDtlDlHdrID
AND DD.DlDtlID = PT.PlnndTrnsfrObDlDtlID
INNER JOIN dbo.GeneralConfiguration SoldTO (NOLOCK)
ON SoldTO.GnrlcnfgHdrID = MH.MvtHdrID
AND SoldTo.GnrlCnfgTblNme = 'MovementHeader'
AND SoldTo.GnrlCnfgQlfr = 'SAPMvtSoldToNumber'
AND SoldTO.GnrlcnfgHdrID <> 0
INNER JOIN dbo.GeneralConfiguration ShipTO (NOLOCK)
ON ShipTO.GnrlCnfgHdrID = MH.MvtHdrID
AND ShipTo.GnrlCnfgTblNme ='MovementHeader'
AND ShipTo.GnrlCnfgQlfr = 'SAPMvtShipTo'
AND ShipTO.GnrlCnfgHdrID <> 0
LEFT OUTER JOIN dbo.MTVSAPBASoldTO (NOLOCK)
ON MTVSAPBASoldTO.SoldTo = SoldTo.GnrlCnfgMulti
AND MTVSAPBASoldTO.BAID = DH.DlHdrExtrnlBaid
LEFT OUTER JOIN dbo.MTVSAPSoldToShipTo (NOLOCK)
ON MTVSAPSoldToShipTo.MTVSAPBASoldToID = MTVSAPBASoldTO.ID
AND MTVSAPSoldToShipTo.ShipTo = ShipTo.GnrlCnfgMulti
LEFT OUTER JOIN dbo.MTVTaxNewCombinationSummary s (NOLOCK)
ON s.ExternalBaid = DH.DlHdrExtrnlBaid
AND s.SoldTo = SUBSTRING(SoldTo.GnrlCnfgMulti,1,10)
AND s.ShipTo = SUBSTRING(ShipTo.GnrlCnfgMulti,1,10)
AND s.PrdctID = MH.MvtHdrPrdctID
AND s.Originlcleid = mh.MvtHdrLcleID
AND ISNULL(s.DestinationLcleid,-1) = ISNULL(MTVSAPSoldToShipTo.RALocaleID,-1)
WHERE s.ID IS NULL

INSERT INTO #tempcombos (DealDetailID, ExternalBaid, SoldTo, ShipTo, PrdctID, OriginLcleID, DestinationLcleID)
SELECT DD.DealDetailID,DH.DlHdrExtrnlBaid,MTVSAPBASoldTo.SoldTo,MTVSAPSoldToShipTo.ShipTo,DD.DlDtlPrdctID,DD.OriginLcleID,MTVSAPSoldToShipTo.RALocaleID
From DealDetail DD (Nolock)
INNER JOIN dbo.DealHeader DH (nolock)
ON DH.DlHdrID = DD.DlDtlDLHdrID
AND DH.DLHDrStat = 'A'
--AND dh.DlHdrIntrnlBAID = 22 --Only FSM Deals
INNER JOIN dbo.GeneralConfiguration SoldTO (nolock) on SoldTO.GnrlcnfgHdrID = DH.DlHdrID
AND SoldTo.GnrlCnfgTblNme = 'DealHeader'
AND SoldTo.GnrlCnfgQlfr = 'SAPSoldTo'
AND SoldTO.GnrlcnfgHdrID <> 0
INNER JOIN dbo.MTVSAPBASoldTo (NOLOCK) ON MTVSAPBASoldTo.ID = CONVERT(INT,SoldTo.GnrlCnfgMulti)
INNER JOIN dbo.MTVDealDetailShipTO ShipTo (NOLOCK)
ON ShipTo.DlHdrID = DD.DlDtlDlHdrID
AND ShipTo.DlDtlID = DD.DlDtlID
AND ShipTo.LastUpdateDate > @dt_LastUpdateDate
AND ShipTo.LastUpdateDate <= @dt_UpdateDate 
INNER JOIN dbo.MTVSAPSoldToShipTo (NOLOCK)
ON dbo.MTVSAPSoldToShipTo.ID = ShipTo.SoldToShipToID
LEFT OUTER JOIN #tempcombos t
ON t.DealDetailID = DD.DealDetailID
AND t.SoldTo = MTVSAPBASoldTo.SoldTo
AND t.ShipTo = MTVSAPSoldToShipTo.ShipTo
LEFT OUTER JOIN dbo.MTVTaxNewCombinationSummary s (NOLOCK)
ON s.ExternalBaid = DH.DlHdrExtrnlBaid
AND s.SoldTo = MTVSAPBASoldTo.SoldTo
AND s.ShipTo = MTVSAPSoldToShipTo.ShipTo
AND s.PrdctID = DD.DlDtlPrdctID
AND s.Originlcleid = DD.OriginLcleID
AND s.DestinationLcleid = MTVSAPSoldToShipTo.RALocaleID
WHERE t.ID IS NULL
AND s.ID IS NULL

BEGIN TRANSACTION

	TRUNCATE TABLE dbo.MTVTaxNewCombinationDetail

	INSERT INTO dbo.MTVTaxNewCombinationDetail ( DealDetailID, XhdrID, SoldTo, ShipTo, OriginLcleID, DestinationLcleid, LastUpdateDate, IsNew )
	SELECT DISTINCT DealDetailID, XhdrID, SoldTo, ShipTo, OriginLcleid, DestinationLcleid,  @dt_UpdateDate, 'Y' FROM #tempcombos

	INSERT INTO MTVTaxNewCombinationSummary (ExternalBaid,SoldTo,ShipTo,PrdctID,Originlcleid,DestinationLcleid,LastUpdateDate)
	SELECT DISTINCT ExternalBaid,SoldTo,ShipTo,PrdctID,OriginLcleid,DestinationLcleid,@dt_UpdateDate FROM #tempcombos
	    
	SET @RegEntry = CONVERT(VARCHAR,@dt_UpdateDate)
	EXECUTE SP_Set_Registry_Value 'Motiva\TAX\NewCombination\LastUpdateDate',@RegEntry     

COMMIT TRANSACTION

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTV_Get_NewTaxCombinations]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTV_Get_NewTaxCombinations.sql'
	PRINT '<<< ALTERED StoredProcedure MTV_Get_NewTaxCombinations >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTV_Get_NewTaxCombinations >>>'
END
go

TRUNCATE TABLE dbo.MTVTaxNewCombinationSummary

EXECUTE SP_Set_Registry_Value 'Motiva\TAX\NewCombination\LastUpdateDate','1/1/2000'

EXECUTE MTV_Get_NewTaxCombinations

TRUNCATE TABLE dbo.MTVTaxNewCombinationDetail





