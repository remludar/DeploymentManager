If OBJECT_ID('dbo.v_GV_Price_Curve_Data') Is Not NULL
Begin 
    DROP View dbo.v_GV_Price_Curve_Data
    PRINT '<<< DROPPED View dbo.v_GV_Price_Curve_Data >>>'
End
GO

Create View dbo.v_GV_Price_Curve_Data
As
Select
    RPH.RPHdrAbbv "Service"
  , RPL.RPLcleIntrfceCde "OrigInterfaceCode"
  , Ltrim(Rtrim(RPL.RPLcleIntrfceCde)) + '[' + CONVERT(Varchar(4), VTP.VETradePeriodID - 1) + ']'  "NewInterfaceCode"
  , PPC.Name "RuleSet"
  , CONVERT(Int, FTR.PriceAttribute20) "MonthsOut"
--  , VTP.StartDate "PeriodStartDate"
--  , VTP.EndDate "PeriodEndDate"
  , 'Y' "IsFuture"
  , RPH.RPHdrID
  , RPL.RwPrceLcleID
--Select *
From RawPriceLocale RPL
  Inner Join RawPriceHeader RPH (NoLock) on RPH.RPHdrID = RPL.RPLcleRPHdrID
  Inner Join Calendar C (NoLock) on C.CalendarID = RPL.CalendarID
  Inner Join PricingPeriodCategoryGroup PPCG (NoLock) on PPCG.PricingPeriodCategoryGroupID = RPL.PricingPeriodCategoryGroupID
  Inner Join PricingPeriodCategory PPC (NoLock) on PPC.PricingPeriodCategoryID = PPCG.PricingPeriodCategoryID
  Inner Join FormulaTabletRule FTR (NoLock) on FTR.FrmlaTbltRleID = PPC.FrmlaTbltRleID
  Inner Join VETradePeriod VTP (NoLock) on VTP.VETradePeriodID <= CONVERT(Int, FTR.PriceAttribute20)
--  Inner Join PricingPeriodCategoryVETradePeriod  PPCTP (NoLock) on PPCTP.PricingPeriodCategoryID = PPCG.PricingPeriodCategoryID
--  Inner Join VETradePeriod VTP (NoLock) on VTP.VETradePeriodID = PPCTP.VETradePeriodID
  Inner Join GeneralConfiguration GC (NoLock) on GC.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and GC.GnrlCnfgQlfr = 'GVRequestType'
                                             and GC.GnrlCnfgHdrID = RPL.RwPrceLcleID
                                             and GC.GnrlCnfgMulti = 'NYMEXFUTURE'
Where 1 = 1
  And SubString(RPL.RPLcleIntrfceCde, 1, 1) IN ('/', '#')-- ('CL', 'HO', 'NG')
  And PPCG.IsSettlement = 1
  And RPL.Status = 'A'
Go

/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.v_GV_Price_Curve_Data') Is NOT Null
BEGIN
	PRINT '<<< CREATED View dbo.v_GV_Price_Curve_Data >>>'
	Grant Select On dbo.v_GV_Price_Curve_Data to SYSUSER
END
ELSE
	Print '<<<Failed Creating View dbo.v_GV_Price_Curve_Data >>>'
GO

