/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR view (NOTE:  Motiva_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[GetLatestDealHeaderArchiveApprovalDateforDlHdrId]    Script Date: DATECREATED ******/
PRINT 'Start Script=GetDeliveryPeriodRollOnBoardDate.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetDeliveryPeriodRollOnBoardDate]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDeliveryPeriodRollOnBoardDate] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure GetDeliveryPeriodRollOnBoardDate >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[GetDeliveryPeriodRollOnBoardDate]  
@TradePeriod VarChar (255),  
@RollOnBoardDate	SMALLDATETIME	OUTPUT
AS  
  
-- =============================================  
-- Description:   Gets the Roll On Date  
 --               for a given DeliveryPeriod  
-- =============================================  
-- Date         Modified By     Issue#  Modification  
-- -----------  --------------  ------  ---------------------------------------------------------------------  
-----------------------------------------------------------------------------  

SET @RollOnBoardDate = (select max([RollOnBoardDate])
									   From   [PricingPeriodCategoryVETradePeriod] (NoLock)
									   Join [VETradePeriod] (NoLock) On
											  VETradePeriod.VETradePeriodID = PricingPeriodCategoryVETradePeriod.VETradePeriodID
									   Left Join [PricingPeriodCategory] (NoLock) On
											  [PricingPeriodCategoryVETradePeriod].PricingPeriodCategoryID = [PricingPeriodCategory].PricingPeriodCategoryID
									   WHERE  [PricingPeriodCategoryVETradePeriod].PricingPeriodAbbv = @TradePeriod)

RETURN

GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

IF  OBJECT_ID(N'[dbo].[GetDeliveryPeriodRollOnBoardDate]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_GetDeliveryPeriodRollOnBoardDate.sql'
			PRINT '<<< ALTERED StoredProcedure GetDeliveryPeriodRollOnBoardDate >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure GetDeliveryPeriodRollOnBoardDate >>>'
	  END