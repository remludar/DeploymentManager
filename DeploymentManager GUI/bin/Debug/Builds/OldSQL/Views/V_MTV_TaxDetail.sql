/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTV_TaxDetail WITH YOUR view (NOTE:  v_MTV_ is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTV_TaxDetail]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_TaxDetail.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxDetail]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_TaxDetail] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_TaxDetail >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTV_TaxDetail]
AS
-- =============================================
-- Author:        rlb
-- Create date:	  03/06/2016
-- Description:   Expose all columns from Tax Detail
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------
--select * from v_MTV_TaxDetail

select	TxDtlID			AS 'TaxDetailID'
,TxDtlOrgnlAcctDtlID			AS 'OriginalAccountDetailID'
,TxDtlTxMstrID			AS 'TaxMasterID'
,TxDtlTrnsctnTypID			AS 'TransactionType'
,TxDtlVle			AS 'Value'
,TxDtlLstInChn			AS 'LastInChain'
,TxDtlUsd			AS 'Used'
,TxDtlRmt			AS 'Remit'
,TxDtlChldTxDtlID			AS 'ChildTaxDetailID'
,TxDtlCrrncyID			AS 'Currency'
,TxDtlMnl			AS 'Manual'
,TxDtlStts			AS 'Status'
,TxDtlSrceID			AS 'SourceID'
,TxDtlSrceTble			AS 'SourceTable'
,TxDtlDffrdBllng			AS 'DeferredBilling'
,TxID			AS 'TaxID'
,TxRleStID			AS 'TaxRuleSetID'
,DlDtlPrvsnID			AS 'ProvisionID'
,WePayTheyPay			AS 'WePayTheyPay'
,TxDtlXHdrID			AS 'TransactionHeaderID'
,QuantityBasis			AS 'QuantityBasis'
,TransactionDate			AS 'TransactionDate'
,IsLoadFee			AS 'IsLoadFee'
,IsCappedTax			AS 'IsCappedTax'
,BaseExchangeRate			AS 'BaseExchangeRate'
,IsEmbeddedTax			AS 'IsEmbeddedTax'

from	taxdetail

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_TaxDetail]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_TaxDetail.sql'
			PRINT '<<< ALTERED View v_MTV_TaxDetail >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_TaxDetail >>>'
	  END
