/****** Object:  StoredProcedure [dbo].[MTV_GetForecastDealsObligation]    Script Date: 4/27/2016 8:05:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  OBJECT_ID(N'[dbo].[MTV_GetForecastDealsObligation]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTV_GetForecastDealsObligation] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure MTV_GetForecastDealsObligation >>>'
	  END
GO

ALTER procedure [dbo].[MTV_GetForecastDealsObligation] @DlHdrID INT,@DlDtlID INT,@LcleID INT,@PrdctID INT,@CustomTransferStatus VARCHAR(3),@ReceiptDeliveryFlag VARCHAR(1),@TransferDate DATETIME
AS  
-- ==========================================================================
-- Author:        Alan Oldfield
-- Create date:	  8/23/2017
-- Description:   
-- =============================================
-- Date         Modified By     Issue#  Modification
-- MTV_GetForecastDealsObligation @DlHdrID = 5442,@DlDtlID = 17,@LcleID = 4175,@PrdctID = 92,@CustomTransferStatus = 'T',@ReceiptDeliveryFlag = 'R',@TransferDate = '4/3/2017'
-- -----------  --------------  ------  -------------------------------------
-----------------------------------------------------------------------------
set nocount on
set Quoted_Identifier OFF

DECLARE @Value INT 
--If the custom status is not in the registrys defined statuses do not process.
SELECT @Value = PATINDEX('%''' + @CustomTransferStatus + '''%',RgstryDtaVle) 
FROM dbo.registry WITH (NOLOCK)
WHERE RgstryFllKyNme = 'Motiva\CustomTransferStatus\'
AND RgstryKyNme = 'CustomTransferStatus'

IF (ISNULL(@Value,0) < 1) RETURN

--Only process for certian types of deals.
SELECT @Value = COUNT(1)
FROM dbo.DealHeader dh WITH (NOLOCK)
INNER JOIN dbo.DealType dt WITH (NOLOCK)
ON dt.DlTypID = dh.DlHdrTyp
WHERE dt.Description IN ('3rd Party Blending Deal','Exchange Deal')
AND dh.DlHdrID = @DlHdrID

IF (ISNULL(@Value,0) < 1) RETURN

--Find the mathing blend deals obligation id for the 
--	product,location,date and receipt delivery flag.
SELECT	pt.PlnndTrnsfrObDlDtlDlHdrID DlHdrID,
		pt.PlnndTrnsfrObDlDtlID DlDtlID,
		MAX(pt.SchdlngOblgtnID) SchdlngOblgtnID
FROM dbo.PlannedTransfer pt WITH (NOLOCK)
INNER JOIN dbo.DealHeader dh WITH (NOLOCK)
ON dh.DlHdrID = pt.PlnndTrnsfrObDlDtlDlHdrID
AND dh.DlHdrStat = 'A'
AND pt.Status = 'A'
AND pt.AliasPrdctID = @PrdctID
AND pt.PhysicalLcleID = @LcleID
AND pt.ptreceiptdelivery = @ReceiptDeliveryFlag
AND @TransferDate BETWEEN pt.FromDate AND pt.ToDate
AND dh.DlHdrID != @DlHdrID
INNER JOIN dbo.DealType dt WITH (NOLOCK)
ON dt.DlTypID = dh.DlHdrTyp
AND dt.Description LIKE '%Blending%'
GROUP BY pt.PlnndTrnsfrObDlDtlDlHdrID,pt.PlnndTrnsfrObDlDtlID

GO

--Warning
--More (or none) than one blending deal transfer exists for the product location and date, cannot create blending deal forcast transfer
