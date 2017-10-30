
/****** Object:  View [dbo].[v_MTV_AccountDetailSoldToVendorNumber]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AccountDetailSoldToVendorNumber.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_StorageFeeInvoiceDisplay]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_StorageFeeInvoiceDisplay] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_StorageFeeInvoiceDisplay >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:        DKeeton
-- Create date:	  12/27/2016
-- Description:   Allows external column on accountdetail to get the invoicedisplay for storage fees
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------


ALTER view  dbo.v_MTV_StorageFeeInvoiceDisplay
as

select AcctDtlID
, ID.GnrlCnfgMulti InvoiceDisplay
From AccountDetail WITH (NoLock)
     Inner Join TransactionType WITH (NoLock) ON TransactionType.TrnsctnTypID  = AccountDetail.AcctDtlTrnsctnTypID
	                                          AND TransactionType.TrnsctnTypDesc Like 'Storage%'
     Left Outer Join TransactionDetailLog TDL WITH (NoLock)
	      ON  TDL.XDtlLgAcctDtlID = AccountDetail.AcctDtlID
	 Left Outer Join TimeTransactionDetailLog TTDL WITH (NoLock)
	      ON TTDL.TmeXDtlLgAcctDtlID = AccountDetail.AcctDtlID
	 Left Outer Join TimeTransactionDetail TTD WITH (NoLock)
	     ON TTD.TmeXDtlID = TTDL.TmeXDtlLgTmeXDtlIdnty
	 Left Outer Join DealDetailProvision DDP WITH (NoLock)
	     ON DDP.DlDtlPrvsnID = isnull(TDL.XDtlLgXDtlDlDtlPrvsnID,TTD.TmeXDtlDlDtlPrvsnID)
     Left Outer Join GeneralConfiguration ID WITH (NoLock)
	      ON  ID.GnrlCnfgHdrID = DDP.DlDtlPrvsnPrvsnID
	     AND  ID.GnrlCnfgTblNme = 'Prvsn'
		 AND  ID.GnrlCnfgQlfr = 'InvoiceDisplay'


GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_StorageFeeInvoiceDisplay]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_StorageFeeInvoiceDisplay.sql'
			PRINT '<<< ALTERED View v_MTV_StorageFeeInvoiceDisplay >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_StorageFeeInvoiceDisplay >>>'
	  END


