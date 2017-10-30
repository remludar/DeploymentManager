set QUOTED_IDENTIFIER OFF
GO

IF OBJECT_ID('[dbo].[P_GV_PLATTS_TRADEPERIODS]') Is Not NULL
BEGIN
    DROP PROC [dbo].[P_GV_PLATTS_TRADEPERIODS]
    PRINT '<<< DROPPED PROC [dbo].[P_GV_PLATTS_TRADEPERIODS] >>>'
END
GO

Create Procedure P_GV_PLATTS_TRADEPERIODS (@vc_Service VarChar(100), 
                                           @vc_InterfaceCode VarChar(100), 
                                           @dt_TradeDate DateTime)
AS
BEGIN

  /*
  Declare @vc_Service VarChar(100)
  Declare @vc_InterfaceCode VarChar(100)
  Declare @dt_TradeDate DateTime

  Set @vc_Service = 'OPIS'
  Set @vc_InterfaceCode = '#PA00026689'
  Set @dt_TradeDate = '2016-11-15 00:00'

  exec P_GV_PLATTS_TRADEPERIODS @vc_Service = 'OPIS', @vc_InterfaceCode = '#PA00026689', @dt_TradeDate = '2016-11-15 00:00'

  */

  Create Table #Periods (ID Int Identity, ServiceID int, [Service] VarChar(100), 
                          InterfaceCode VarChar(100), CurveID Int, RollOnDate DateTime,
                          RollOffDate DateTime, BeginTradePeriod DateTime, EndTradePeriod DateTime,
                          Offset Int)

  Insert Into #Periods (ServiceID, [Service], InterfaceCode, CurveID, RollOnDate,
                        RollOffDate, BeginTradePeriod, EndTradePeriod)
  Select 
    Distinct 
        vPD.RPHdrID "ServiceID"
      , vPD.RPHdrAbbv "Service"
      , vPD.RPLcleIntrfceCde "InterfaceCode"
      , vPD.RwPrceLcleID "CurveID"
      , PPCVTP.RollOnBoardDate "RollOnDate"
      , PPCVtp.RollOffBoardDate "RollOffDate"
      , VTP.StartDate "BeginTradePeriod"
      , VTP.EndDate "EndTradePeriod"
  from v_GV_Price_Data vPD (NoLock)
    Inner Join RawPriceLocale RPL (NoLock) on RPL.RwPrceLcleID = vPD.RwPrceLcleID
    Inner Join PricingPeriodCategoryGroup PPCG (NoLock) on PPCG.PricingPeriodCategoryGroupID = RPL.PricingPeriodCategoryGroupID
                                                        and PPCG.IsSettlement = 1
    Inner Join PricingPeriodCategoryVETradePeriod PPCVTP (NoLock) on PPCVTP.PricingPeriodCategoryID = PPCG.PricingPeriodCategoryID
                                                                  and @dt_TradeDate <= PPCVtp.RollOffBoardDate
    Inner Join VETradePeriod VTP (NoLock) on VTP.VETradePeriodID = PPCVTP.VETradePeriodID
                                          and VTP.Status = 'A'
  Where 1 = 1
    and vPD.RPHdrAbbv = @vc_Service
    and vPD.RPLcleIntrfceCde = @vc_InterfaceCode
    and vPD.PLATTSOffset IS NOT NULL
  Order By 5

  Update #Periods Set Offset = ID - 1

  Select * from #Periods

  Drop Table #Periods

END
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

If OBJECT_ID('[dbo].[P_GV_PLATTS_TRADEPERIODS]') Is NOT Null
BEGIN
            PRINT '<<< CREATED PROC [dbo].[P_GV_PLATTS_TRADEPERIODS] >>>'
            Grant execute on [dbo].[P_GV_PLATTS_TRADEPERIODS] to SYSUSER
            Grant execute on [dbo].[P_GV_PLATTS_TRADEPERIODS] to PUBLIC
END
ELSE
            Print '<<<Failed Creating Procedure [dbo].[P_GV_PLATTS_TRADEPERIODS]>>>'

GO

