
/****** Object:  View [dbo].[v_mtv_AccountDetailStatement]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AccountDetailSoldToVendorNumber.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_mtv_AccountDetailStatement]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_mtv_AccountDetailStatement] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_mtv_AccountDetailStatement >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:        DKeeton
-- Create date:	  2/13/2017
-- Description:   Allows external column on accountdetail to get the 3rd party storage fees statementnumber
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------



ALTER view dbo.v_mtv_AccountDetailStatement
as
select  acctdtlid , tdl.XDtlLgXDtlXHdrID XhdrID, sis.SlsInvceSttmntSlsInvceHdrID, sih.SlSInvceHdrNmbr 
from accountdetail with (nolock)
     inner join transactiondetaillog tdl with (nolock) on tdl.XDtlLgAcctDtlID = AccountDetail.AcctDtlID
     inner join transactiondetail td with (nolock) on td.XDtlXHdrID = tdl.XDtlLgXDtlXHdrID              
	                                             and td.XDtlID = tdl.XDtlLgXDtlID
												  and td.XDtlDlDtlPrvsnID = tdl.XDtlLgXDtlDlDtlPrvsnID
	 inner join SalesInvoiceStatement SIS with (Nolock) on SIS.SlsInvceSttmntXHdrID = td.XDtlXHdrID
	                                                --   and SIS.SlsInvceSttmntRvrsd = 'N'
	 inner join ( select distinct SttmntBlnceSlsInvceHdrID,SttmntBlnceDlHdrID, SttmntBlnceAccntngPrdID AccntngPrdID 
	             From StatementBalance  with (Nolock) ) SB on   SB.SttmntBlnceSlsInvceHdrID = SIS.SlsInvceSttmntSlsInvceHdrID 
				 AND accountdetail.AcctDtlAccntngPrdID = AccntngPrdID
	 inner join  SalesInvoiceHeader SIH With (NoLock) on SIH.SlsInvceHdrID = SIS.SlsInvceSttmntSlsInvceHdrID 
	 inner join DealHeader DH with (NoLock) ON DH.DlHdrID = SB.SttmntBlnceDlHdrID
Where AccountDetail.ExternalBAID = DH.DlHdrExtrnlBaid
go




SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_mtv_AccountDetailStatement]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_mtv_AccountDetailStatement.sql'
			PRINT '<<< ALTERED View v_mtv_AccountDetailStatement >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_mtv_AccountDetailStatement >>>'
	  END

