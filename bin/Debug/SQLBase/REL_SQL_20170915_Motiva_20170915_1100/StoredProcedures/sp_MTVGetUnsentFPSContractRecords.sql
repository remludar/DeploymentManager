PRINT 'Start Script=MTVGetUnsentFPSContractRecords.sql  Domain=CompanyName  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVGetUnsentFPSContractRecords]') IS NULL
      BEGIN
                     EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[MTVGetUnsentFPSContractRecords] AS SELECT 1'
                     PRINT '<<< CREATED StoredProcedure MTVGetUnsentFPSContractRecords >>>'
         END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].MTVGetUnsentFPSContractRecords	
	@ShipToConsolidation VARCHAR(1)
with execute as 'dbo' AS

-- =============================================
-- Author:        Matt Vorm
-- Create date:   05/25/2017
-- Description:   This SP is used to get the unsent FPS Contract data in the desired format
-- =============================================
-- Date         Modified By     Issue#  Modification
-- -----------  --------------  ------  ---------------------------------------------------------------------
-----------------------------------------------------------------------------

BEGIN

--DECLARE @ShipToConsolidation VARCHAR(1)
--SELECT @ShipToConsolidation = 'N'

IF @ShipToConsolidation = 'Y' 
BEGIN
	
	SELECT * 
	FROM MTVRetailContractRAToFPSStaging (NOLOCK)
	WHERE SentToFps = 0 AND REC_TYPE = '619'

	UNION SELECT StagingID,REC_TYPE,COU_CODE,SALES_ORG,DISTRIBUTION_CHANNEL,DIVISION,CUSTOMER_GROUP,CONTRACT_NUMBER
				,CONTRACT_TYPE,CUSTOMER_NUMBER,PARTNER_CUSTOMER,PLANT_CODE,PRODUCT_CODE,PRO_REF_FLAG,PRODUCT_GPC_CODE
				,TARGET,UOM_CODE,DATE_FROM,DATE_TO,CONTRACT_ITEM,REJECTION_FLAG,HANDLING_TYPE,PAYMENT_TERM,SHIPPING_CONDITION
				,Partner_Function,SentToFps,InternalBaId,SentDate,InterfaceRunId,RecordInfo,UserID,ShipToSoldTo,MustSend
	FROM 
	(SELECT *, 
		Row_Number() OVER (PARTITION BY CONTRACT_NUMBER, PARTNER_CUSTOMER, PLANT_CODE ORDER BY StagingID) AS ROWID
	FROM MTVRetailContractRAToFPSStaging (NOLOCK)
	WHERE SentToFps = 0 AND REC_TYPE = '619_CPF') 
	AS DT WHERE DT.ROWID = 1

	ORDER BY CONTRACT_NUMBER, REC_TYPE, CONTRACT_ITEM
	
END

ELSE
BEGIN

	SELECT *
	FROM MTVRetailContractRAToFPSStaging (NOLOCK)
	WHERE SentToFps = 0 
	ORDER BY CONTRACT_NUMBER, REC_TYPE, CONTRACT_ITEM

END

END


SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[MTVGetUnsentFPSContractRecords]') IS NOT NULL
BEGIN
            EXECUTE       sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'MTVGetUnsentFPSContractRecords.sql'
            PRINT '<<< ALTERED StoredProcedure MTVGetUnsentFPSContractRecords >>>'
END
ELSE
BEGIN
            PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure MTVGetUnsentFPSContractRecords >>>'
END    


/*
*****************************************************************************************************
USE FIND AND REPLACE ON MTVGetUnsentFPSContractRecords 
*****************************************************************************************************
*/

/****** Object:  ViewName [dbo].[MTVGetUnsentFPSContractRecords]    Script Date: DATECREATED ******/
PRINT 'Start Script=MTVGetUnsentFPSContractRecords.GRANT.sql  Domain=GN  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[MTVGetUnsentFPSContractRecords]') IS NOT NULL
  BEGIN
    GRANT  EXECUTE  ON dbo.MTVGetUnsentFPSContractRecords TO sysuser, RightAngleAccess
    PRINT '<<< GRANTED RIGHTS on StoredProcedure MTVGetUnsentFPSContractRecords >>>' 
  END
ELSE
    PRINT '<<< FAILED GRANTING RIGHTS on StoredProcedure MTVGetUnsentFPSContractRecords >>>'
