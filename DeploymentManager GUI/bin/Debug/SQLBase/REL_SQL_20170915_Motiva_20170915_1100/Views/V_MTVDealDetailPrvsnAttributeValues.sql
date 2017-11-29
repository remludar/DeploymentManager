/*
*****************************************************************************************************
USE FIND AND REPLACE ON VIEWNAME WITH YOUR view (NOTE:  v_CompanyName_ is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[V_MTVDealDetailPrvsnAttributeValues]    Script Date: DATECREATED ******/
PRINT 'Start Script=V_MTVDealDetailPrvsnAttributeValues.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[V_MTVDealDetailPrvsnAttributeValues]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[V_MTVDealDetailPrvsnAttributeValues] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View V_MTVDealDetailPrvsnAttributeValues >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


Alter VIEW [dbo].[V_MTVDealDetailPrvsnAttributeValues]
AS
-- =============================================
-- Author:        YOURNAME
-- Create date:	  DATECREATED
-- Description:   SHORT DESCRIPTION OF WHAT THIS THINGS DOES\
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------
SELECT  DealDetailProvision.DlDtlPrvsnID DealDetailProvisionID,
		PrvsnAttributeType.PrvsnAttrTpeNme,
        PrvsnAttributeType.PrvsnAttrTpeDscrptn, 
        DealDetailPrvsnAttribute.DlDtlPnAttrDta
	--select *
FROM	DealDetailPrvsnAttribute
Inner Join 
	PrvsnAttributeType On        
	PrvsnAttributeType.PrvsnAttrTpeID = DealDetailPrvsnAttribute.DlDtlPnAttrPrvsnAttrTpeID
	AND PrvsnAttributeType.PrvsnAttrTpeNme IN ('Fixed','FlatFixed')
Inner Join DealDetailProvision
ON	DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnDlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
AND DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnDlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
AND	DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnID	= DealDetailProvision.DlDtlPrvsnID
WHERE DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID not in (select DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnDlDtlDlHdrID from DealDetailPrvsnAttribute where 
 DealDetailPrvsnAttribute.DlDtlPnAttrDta = 'TAS')
UNION All
Select
DealDetailProvision.DlDtlPrvsnID DealDetailProvisionID,
		PrvsnAttributeType.PrvsnAttrTpeNme,
        PrvsnAttributeType.PrvsnAttrTpeDscrptn, 
		(select
           42 * Sum(TmeXDtlTtlVal) / 	    
            Case
                When	IsNull(Sum(TmeXDtlQntty), 0) = 0
                Then 	1
                Else	Sum(TmeXDtlQntty)
            End
            from 	timetransactiondetail (NoLock)
            where 	timetransactiondetail.TmeXDtlLstInChn = 'Y' 
            and 	timetransactiondetail.TmeXDtlStat <> 'R'  
            and	    timetransactiondetail.TmeXDtlDlDtlPrvsnID = DealDetailProvision.DlDtlPrvsnID
            and		Exists	(
			select	1
			From	TimeTransactionDetailExposure  with (NoLock)
			where	TimeTransactionDetailExposure.TmeXDtlIdnty = timetransactiondetail.TmeXDtlIdnty
			and	Exists (
						select	1
						From	FormulaEvaluationQuote with (NoLock)
						Inner Join RawPriceDetail with (NoLock) on	TimeTransactionDetailExposure.RwPrceLcleID = RawPriceDetail.RwPrceLcleID
						and	FormulaEvaluationQuote.QuoteDate between 	RawPriceDetail.RPDtlQteFrmDte and RawPriceDetail.RPDtlQteToDte
						and	FormulaEvaluationQuote.VETradePeriodID	= RawPriceDetail. VETradePeriodID
						and	RawPriceDetail.RPDtlTpe = 'A'
						and	RawPriceDetail.RPDtlStts = 'A'		
						where	TimeTransactionDetailExposure.FormulaEvaluationID = FormulaEvaluationQuote.FormulaEvaluationID
						)
			)) DlDtlPnAttrDta
			FROM	DealDetailPrvsnAttribute
Inner Join 
	PrvsnAttributeType On        
	PrvsnAttributeType.PrvsnAttrTpeID = DealDetailPrvsnAttribute.DlDtlPnAttrPrvsnAttrTpeID
	AND PrvsnAttributeType.PrvsnAttrTpeNme IN ('Fixed','FlatFixed')
Inner Join DealDetailProvision
ON	DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnDlDtlDlHdrID = DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID
AND DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnDlDtlID = DealDetailProvision.DlDtlPrvsnDlDtlID
AND	DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnID	= DealDetailProvision.DlDtlPrvsnID

WHERE DealDetailProvision.DlDtlPrvsnDlDtlDlHdrID  in (select DealDetailPrvsnAttribute.DlDtlPnAttrDlDtlPnDlDtlDlHdrID from DealDetailPrvsnAttribute where 
 DealDetailPrvsnAttribute.DlDtlPnAttrDta = 'TAS')

GO





SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
