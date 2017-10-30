/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVCirDetail WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTVCirDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVCirDetail.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVCirDetail]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[MTVCirDetail] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTVCirDetail >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[MTVCirDetail]
AS 
	SELECT	a.ChangeType,a.ArchiveID,a.RevisionLevel,a.DlHdrID,a.DlDtlID,a.PrvsnRowID,a.PrvsnIsPrimary,h.DlHdrIntrnlNbr,
			h.DlHdrDsplyDte,h.DlHdrIntrnlBAID,h.DlHdrExtrnlCntctID,h.Term,h.DlHdrIntrnlUserID,d.DemurrageAnalyst,
			h.MasterAgreement,d.DlDtlTrmTrmID,p.RowText,p.Differential,p.PrceTpeIdnty,p.RPHdrID,
			p.Actual,p.FixedValue,p.DeemedDates,p.RuleName,p.RuleDescription,p.HolidayOptionName,p.SaturdayOptionName,
			p.SundayOptionName,p.PrvsnID,--prv.PrvsnNme,
			p.CurveName,d.DlDtlPrdctID,d.DlDtlQntty,d.DlDtlVlmeTrmTpe,d.SchedulingQuantityTerm,
			d.DlDtlDsplyUOM,d.DlDtlApprxmteQntty,d.VolumeToleranceDirection,d.ToleranceWhoseOption,d.VolumeToleranceQuantity,
			D.DlDtlLcleID,D.OriginLcleID,d.DestinationLcleID,d.SAPSoldToShipTo,d.DeliveryTermID,p.LcleID,d.DlDtlMthdTrnsprttn,
			d.LoadingFromDate LoadingFrmDte,d.LoadingToDate LoadingToDte,d.DlDtlFrmDte,d.DlDtlToDte,h.Comment DealComment,
			h.Remarks,h.DlHdrCrtnDte,d.SubType,d.DlDtlSpplyDmnd,p.CrrncyID,h.DlHdrTyp,d.PipeLineName,p.comment PriceComment,
			d.PipelineCycle,d.Ratio,d.Scheduler,h.RinsGenerator,p.EventReference
	FROM dbo.MTVArchiveRevisionLevels a (NOLOCK)
	INNER JOIN dbo.MTVDealHeaderArchive h (NOLOCK)
	ON a.DlHdrID = h.DlHdrID
	AND a.DlHdrRevisionID = h.RevisionID
	--AND a.PrvsnIsPrimary = 1
	INNER JOIN dbo.MTVDealDetailArchive d (NOLOCK)
	ON a.DlHdrID = d.DlHdrID
	AND a.DlDtlID = d.DlDtlID
	AND a.DlDtlRevisionID = d.RevisionID
	LEFT OUTER JOIN dbo.MTVDealPriceRowArchive p (NOLOCK)
	ON a.PrvsnRowID = p.PrvsnRwID
	AND a.PrvsnRowRevisionID = p.RevisionID
	--LEFT OUTER JOIN dbo.Prvsn prv (NOLOCK)
	--ON prv.PrvsnID = p.PrvsnID
GO

GRANT SELECT ON [dbo].[MTVCirDetail] TO [RightAngleAccess] AS [dbo]
GO

GRANT SELECT ON [dbo].[MTVCirDetail] TO [sysuser] AS [dbo]
GO

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVCirDetail]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTVCirDetail.sql'
			PRINT '<<< ALTERED View v_MTVCirDetail >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTVCirDetail >>>'
	  END



