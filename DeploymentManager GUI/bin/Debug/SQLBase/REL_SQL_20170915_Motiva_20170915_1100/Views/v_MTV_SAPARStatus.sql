PRINT 'Start Script=v_MTV_SAPARStatus.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_SAPARStatus]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTV_SAPARStatus] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTV_SAPARStatus >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTV_SAPARStatus]
AS
--------------------------------------------------------------------------------------------------------------
-- Purpose:  To allow navigation from the Search Event Log report to the Search Event Log Data report  
-- Created By: Pat Newgent  
-- Created:    6/10/2009  
--------------------------------------------------------------------------------------------------------------
Select	AccountDetail.AcctDtlID, MTVSAPARStaging.RightAngleStatus, MTVSAPARStaging.SAPStatus, MTVSAPARStaging.Message
From	MTVSAPARStaging (NoLock)
		Inner Join SalesInvoiceHeader (NoLock)
			on	SalesInvoiceHeader.SlsInvceHdrNmbr		= MTVSAPARStaging.DocNumber
		Inner Join AccountDetail (NoLock)
			on	AccountDetail.AcctDtlSlsInvceHdrID		= SalesInvoiceHeader.SlsInvceHdrID
			and	Abs(AccountDetail.Value)				= Abs(MTVSAPARStaging.DocumentAmount)
		Inner Join TransactionType (NoLock)
			on	TransactionType.TrnsctnTypID			= AccountDetail.AcctDtlTrnsctnTypID
			and	Left(TransactionType.TrnsctnTypDesc, 50)= MTVSAPARStaging.LineItemText
		Inner Join GeneralConfiguration (NoLock)
			on	GeneralConfiguration.GnrlCnfgTblNme		= 'Product'
			and	GeneralConfiguration.GnrlCnfgQlfr		= 'SAPMaterialCode'
			and	GeneralConfiguration.GnrlCnfgMulti		= MTVSAPARStaging.Material
			and	GeneralConfiguration.GnrlCnfgHdrID		= AccountDetail.ChildPrdctID
GO


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTV_SAPARStatus]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTV_SAPARStatus.sql'
			PRINT '<<< ALTERED View v_MTV_SAPARStatus >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTV_SAPARStatus >>>'
	  END
