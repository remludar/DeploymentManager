PRINT 'Start Script=SP_MTVProcessMovementLifeCycle.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

UPDATE mc SET mc.TMSIntefaceStatus = ms.TicketStatus
FROM MTVMovementLifeCycle mc
INNER JOIN MTVTMSMovementStaging ms
ON ms.MESID = mc.MESID
WHERE ISNULL(mc.TMSIntefaceStatus,'X') != ISNULL(ms.TicketStatus,'Y')

IF  OBJECT_ID(N'[dbo].[MTVProcessMovementLifeCycle]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVProcessMovementLifeCycle] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTVProcessMovementLifeCycle >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[MTVProcessMovementLifeCycle]
AS

-- =============================================
-- Author:        Alan Oldfield
-- Create date:	  04/14/2017
-- Description:   This SP pulls updates the TMS Movement Life Cycle
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------

-----------------------------------------------------------------------------

SET NOCOUNT ON

--Update Movement Documents info that the TMS process created.
UPDATE mc SET				mc.MvtHdrMvtDcmntID = ms.MvtHdrMvtDcmntID,
							mc.MvtHdrID = ms.MvtHdrID,
							mc.RAMvtDlvryBAID = ms.RAMvtDlvryBAID,
							mc.RATerminalLcleID = ms.RALcleID,
							mc.RAPrdctID = ms.RAPrdctID,
							mc.TMSIntefaceStatus = ms.TicketStatus,
							mc.TMSInterfaceProcessedDate = ms.ProcessedDate
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN dbo.MTVTMSMovementStaging ms (NOLOCK)
ON mc.MESID = ms.MESID
AND mc.MovementProcessComplete = 0

--Update Movement Document info that has been matched.
UPDATE mc SET mc.TransactionHeaderID = t.XhdrID
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN (
	SELECT mc.MESID,MAX(th.XHdrID) XHdrID
	FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
	INNER JOIN dbo.TransactionHeader th (NOLOCK)
	ON mc.MvtHdrID = th.XHdrMvtDtlMvtHdrID
	AND th.XHdrTyp = 'D'
	AND mc.MovementProcessComplete = 0
	GROUP BY mc.MESID
)
t
ON t.MESID = mc.MESID

UPDATE mc SET				mc.Matched = 'Y',
							mc.MatchedDateTime = th.XHdrDte,
							mc.TransactionHeaderStatus = th.XHdrStat,
							mc.TransactionHeaderDateTime = th.XHdrDte
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN dbo.TransactionHeader th (NOLOCK)
ON mc.TransactionHeaderID = th.XHdrID
AND mc.MovementProcessComplete = 0

--Update Movement Document info where the transactions have valued.
UPDATE mc SET				mc.TransactionDetailID = td.TransactionDetailID,
							mc.TransactionDetailStatus = td.XDtlStat,
							mc.TransactionDetailDateTime = td.LastValuationDate
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN dbo.TransactionDetail td (NOLOCK)
ON mc.TransactionHeaderID = td.XDtlXHdrID
AND td.XDtlTrnsctnTypID = 2042
AND td.XDtlLstInChn = 'Y'
AND mc.MovementProcessComplete = 0

--Update Movement Document account detail info.
UPDATE mc SET	mc.AccountDetailStatus = 'Y',
				mc.AccountDetailID = ad.AcctDtlID,
				mc.AccountDetailDateTime = ad.CreatedDate
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN dbo.TransactionDetailLog tdl (NOLOCK)
ON mc.TransactionHeaderID = tdl.XDtlLgXDtlXHdrID
INNER JOIN dbo.AccountDetail ad (NOLOCK)
ON tdl.XDtlLgAcctDtlID = ad.AcctDtlID
AND ad.AcctDtlTrnsctnTypID = 2042
AND mc.MovementProcessComplete = 0

--Get the invoice information.
UPDATE mc SET	mc.SalesInvoiceHeaderID = SD.SlsInvceDtlSlsInvceHdrID,
				mc.Invoiced = 'Y'
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN dbo.SalesInvoiceDetail sd (NOLOCK)
ON mc.AccountDetailID = SD.SlsInvceDtlAcctDtlID
AND mc.MovementProcessComplete = 0

--Keep trying to update invoice information until records are not sent.
UPDATE mc SET	mc.InvoiceNumber = sih.SlsInvceHdrNmbr,
				mc.InvoiceStatus = sih.SlsInvceHdrStts,
				mc.InvoiceCreationDate = sih.SlsInvceHdrCrtnDte,
				mc.InvoiceFeedDate = sih.SlsInvceHdrFdDte
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN SalesInvoiceHeader sih (NOLOCK)
ON sih.SlsInvceHdrID = mc.SalesInvoiceHeaderID
AND mc.MovementProcessComplete = 0
AND ISNULL(mc.InvoiceStatus,'X') != 'S'

--Update records sent to MSAP.
UPDATE mc SET mc.MSAPInterfaceStatus = 'Y'
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN dbo.MTVInvoiceInterfaceStatus mis (NOLOCK)
ON mc.InvoiceNumber = mis.InvoiceNumber
AND mc.MovementProcessComplete = 0
AND mis.ARAPExtracted = 1
AND mc.MSAPInterfaceStatus IS NULL

--Update records sent to Sales Force.
UPDATE mc SET mc.SalesForceInterfaceStatus = 'Y'
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
INNER JOIN dbo.MTVInvoiceInterfaceStatus mis (NOLOCK)
ON mc.InvoiceNumber = mis.InvoiceNumber
AND mc.MovementProcessComplete = 0
AND mis.SalesForceDataLakeExtracted = 1
AND mc.SalesForceInterfaceStatus IS NULL

--Mark process complete once records have flowed to MSAP and Sales Force.
UPDATE mc SET mc.MovementProcessComplete = 1
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
WHERE mc.MovementProcessComplete = 0
AND mc.SalesForceInterfaceStatus = 'Y'
AND mc.MSAPInterfaceStatus = 'Y'

--Mark the records complete that are older than 3 months so we dont keep trying to process them.
--They are most likely never going to complete.
UPDATE mc SET mc.MovementProcessComplete = 1
FROM dbo.MTVMovementLifeCycle mc (NOLOCK)
WHERE mc.MovementProcessComplete = 0
AND TMSLoadStartDateTime <= DATEADD(MONTH,-3,GETDATE())

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON
GO

IF  OBJECT_ID(N'[dbo].[MTVProcessMovementLifeCycle]') IS NOT NULL
BEGIN
	EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVProcessMovementLifeCycle.sql'
	PRINT '<<< ALTERED StoredProcedure MTVProcessMovementLifeCycle >>>'
END
ELSE
BEGIN
	PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVProcessMovementLifeCycle >>>'
END