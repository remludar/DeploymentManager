/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_BAProdOriginLocDealDetails WITH YOUR view 
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_BAProdOriginLocDealDetails]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_BAProdOriginLocDealDetails.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_BAProdOriginLocDealDetails]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_BAProdOriginLocDealDetails] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_BAProdOriginLocDealDetails >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_BAProdOriginLocDealDetails]
AS

SELECT Min(th.XHdrDte) as MinCreationDate, 
       dd.ExternalBAID, 
       dd.OriginLcleID, 
       dd.DlDtlPrdctID 
FROM   DealDetail dd
inner join PlannedTransfer pt on pt.PlnndTrnsfrObDlDtlDlHdrID = dd.DlDtlDlHdrID AND pt.PlnndTrnsfrObDlDtlID = dd.DlDtlID
left join TransactionHeader th on th.XHdrPlnndTrnsfrID = pt.PlnndTrnsfrID
GROUP  BY ExternalBAID, 
          dd.OriginLcleID, 
          dd.DlDtlPrdctID 

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_BAProdOriginLocDealDetails]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_BAProdOriginLocDealDetails.sql'
			PRINT '<<< ALTERED View v_BAProdOriginLocDealDetails >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_BAProdOriginLocDealDetails >>>'
	  END
