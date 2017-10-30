/*
*****************************************************************************************************
USE FIND AND REPLACE ON STOREDPROCEDURENAME WITH YOUR view (NOTE:  Motiva_ is already set
*****************************************************************************************************
*/

/****** Object:  StoredProcedure [dbo].[GetLatestDealHeaderArchiveApprovalDateforDlHdrId]    Script Date: DATECREATED ******/
PRINT 'Start Script=GetDeliveryPeriodRollOffBoardDate.sql  Domain=Motiva  Time=' + CONVERT(VARCHAR(50), GETDATE(), 109) + ' on ' + @@SERVERNAME+'.'+db_name()
GO

IF  OBJECT_ID(N'[dbo].[GetDeliveryPeriodRollOffBoardDate]') IS NULL
      BEGIN
			EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[GetDeliveryPeriodRollOffBoardDate] AS SELECT 1'
			PRINT '<<< CREATED StoredProcedure GetDeliveryPeriodRollOffBoardDate >>>'
	  END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[GetDeliveryPeriodRollOffBoardDate]  
@TradePeriod VarChar (255),  
@RollOffBoardDate	SMALLDATETIME	OUTPUT
AS  
  
-- =============================================  
-- Description:   Gets the Roll Off Date  
 --               for a given DeliveryPeriod  
-- =============================================  
-- Date         Modified By     Issue#  Modification  
-- -----------  --------------  ------  ---------------------------------------------------------------------  
-----------------------------------------------------------------------------  

SET @RollOffBoardDate = (select max([RollOffBoardDate])
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

IF  OBJECT_ID(N'[dbo].[GetDeliveryPeriodRollOffBoardDate]') IS NOT NULL
      BEGIN
			EXECUTE	sp_MotivaBuildStatisticsInsertUpdateSQLScripts 'sp_GetDeliveryPeriodRollOffBoardDate.sql'
			PRINT '<<< ALTERED StoredProcedure GetDeliveryPeriodRollOffBoardDate >>>'
	  END
	  ELSE
	  BEGIN
			PRINT '<<< FAILED CREATE OR ALTER on StoredProcedure GetDeliveryPeriodRollOffBoardDate >>>'
	  END