/****** Object:  View [dbo].[v_MTV_AcctDtl_AcctCodes]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTV_AcctDtl_AcctCodes.sql  Domain=MTV  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AcctDtl_AcctCodes]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_AcctDtl_AcctCodes] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_AcctDtl_AcctCodes >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTV_AcctDtl_AcctCodes]
AS
-- =============================================
-- Author:        YOURNAME
-- Create date:	  DATECREATED
-- Description:   SHORT DESCRIPTION OF WHAT THIS THINGS DOES\
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  -----------------------------------------------------------------------------

Select	AccountDetail.AcctDtlID,
		max(case AcctDtlAcctCdeBlnceTpe
				when 'D' then case when (OldStyleValue) < 0 then 0 else AcctDtlAcctCdeCde end
				when 'C' then case when (-1 * OldStyleValue) > 0 then AcctDtlAcctCdeCde else 0 end
			end) as DebitAccount,
		max(case AcctDtlAcctCdeBlnceTpe
				when 'D' then case when (OldStyleValue) < 0 then AcctDtlAcctCdeCde else 0 end
				when 'C' then case when (-1 * OldStyleValue) > 0 then 0 else AcctDtlAcctCdeCde end
			end) as CreditAccount
From	AccountDetailAccountCode with (NoLock)
		Inner Join AccountDetail with (NoLock)
			on	AccountDetail.AcctDtlID		= AccountDetailAccountCode.AcctDtlAcctCdeAcctDtlID

Group By AccountDetail.AcctDtlID

GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_AcctDtl_AcctCodes]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_AcctDtl_AcctCodes.sql'
			PRINT '<<< ALTERED View v_MTV_AcctDtl_AcctCodes >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_AcctDtl_AcctCodes >>>'
	  END
