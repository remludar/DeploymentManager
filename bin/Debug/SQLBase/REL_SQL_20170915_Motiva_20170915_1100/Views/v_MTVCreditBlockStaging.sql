/*
*****************************************************************************************************
USE FIND AND REPLACE ON v_MTVCreditBlockStaging WITH YOUR view (NOTE:   is already set
*****************************************************************************************************
*/

/****** Object:  View [dbo].[v_MTVCreditBlockStaging]    Script Date: DATECREATED ******/
PRINT 'Start Script=v_MTVCreditBlockStaging.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[v_MTVCreditBlockStaging]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE View [dbo].[v_MTVCreditBlockStaging] AS SELECT 1 AS Result'
			PRINT '<<< CREATED View v_MTVCreditBlockStaging >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER VIEW [dbo].[v_MTVCreditBlockStaging]
AS

SELECT ID,'O' Direction,SoldTo,SupplierNo,CASE CreditBlockFlag WHEN 1 THEN 'Y' ELSE 'N' END CreditBlockFlag,InterfaceStatus,Message,ProcessedDate,NexusMessageID
FROM dbo.MTVOutboundCreditBlockStaging (NOLOCK)
UNION ALL
SELECT ID,'I' Direction,SoldTo,NULL,CASE CreditBlockFlag WHEN 1 THEN 'Y' ELSE 'N' END,InterfaceStatus,Message,ProcessedDate,NexusMessageID
FROM dbo.MTVInboundCreditBlockStaging (NOLOCK)

GO




SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[v_MTVCreditBlockStaging]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'v_MTVCreditBlockStaging.sql'
			PRINT '<<< ALTERED View v_MTVCreditBlockStaging >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on View v_MTVCreditBlockStaging >>>'
	  END
