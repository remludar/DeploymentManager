If OBJECT_ID('dbo.v_GV_Price_Data') Is Not NULL
Begin 
    DROP View dbo.v_GV_Price_Data
    PRINT '<<< DROPPED View dbo.v_GV_Price_Data >>>'
End
GO

--Select * from v_GV_Price_Data
Create View dbo.v_GV_Price_Data
As

Select
    RPH.RPHdrID
  , LTRIM(RTRIM(RPH.RPHdrAbbv)) RPHdrAbbv
  , LTRIM(RTRIM(RPL.RPLcleIntrfceCde)) RPLcleIntrfceCde
  , LTRIM(RTRIM(RPL.RPLcleIntrfceCde)) InstrumentID
  , NULL "PLATTSOffset"
  , RPL.RwPrceLcleID
  , Replace(LQ.GnrlCnfgMulti, ' ', '') GVQuoteType
  , Replace(RQ.GnrlCnfgMulti, ' ', '') GVRAQuoteType
  , Convert(VarChar(80),'GlobalView') "Source"
  , GV.GnrlCnfgMulti GVMultiplier
  , IsNull(RT.GnrlCnfgMulti, 'GetDaily') GVRequestType
--Select *  
From RawPriceLocale RPL
  Inner Join RawPriceHeader RPH (NoLock) on RPH.RPHdrID = RPL.RPLcleRPHdrID
  Inner Join GeneralConfiguration GC (NoLock) on GC.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and GC.GnrlCnfgQlfr = 'PriceSourceGV'
                                             and GC.GnrlCnfgHdrID = RPL.RwPrceLcleID
                                             and GC.GnrlCnfgMulti = 'Y'
  Inner Join GeneralConfiguration LQ (NoLock) on LQ.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and LQ.GnrlCnfgQlfr = 'GVQuoteType'
                                             and LQ.GnrlCnfgHdrID = RPL.RwPrceLcleID
  Inner Join GeneralConfiguration RQ (NoLock) on RQ.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and RQ.GnrlCnfgQlfr = 'GVRAQuoteType'
                                             and RQ.GnrlCnfgHdrID = RPL.RwPrceLcleID
  Left Join GeneralConfiguration GV (NoLock) on GV.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and GV.GnrlCnfgQlfr = 'GVMultiplier'
                                             and GV.GnrlCnfgHdrID = RPL.RwPrceLcleID
  Left Join GeneralConfiguration RT (NoLock) on RT.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and RT.GnrlCnfgQlfr = 'GVRequestType'
                                             and RT.GnrlCnfgHdrID = RPL.RwPrceLcleID
  --Select * from GeneralConfiguration where gnrlcnfghdrid = 0 and gnrlcnfgtblnme = 'RawPriceLocale'
Where 1 = 1
  And RPL.Status = 'A'
  And IsNull(RPL.RPLcleIntrfceCde, '') <> ''
UNION
Select
    vPCD.RPHdrID
  , LTRIM(RTRIM(vPCD.Service))
  , LTRIM(RTRIM(vPCD.OrigInterfaceCode))
  , LTRIM(RTRIM(vPCD.NewInterfaceCode))
  , NULL "PLATTSOffset"
  , vPCD.RwPrceLcleID
  , Replace(LQ.GnrlCnfgMulti, ' ', '') GVQuoteType
  , Replace(RQ.GnrlCnfgMulti, ' ', '') RAQuoteType
  , Convert(VarChar(80),'GlobalView') "Source"
  , GV.GnrlCnfgMulti GVMultiplier
  , IsNull(RT.GnrlCnfgMulti, 'GetDaily') GVRequestType
--Select * 
From v_GV_Price_Curve_Data vPCD
  Inner Join GeneralConfiguration GC (NoLock) on GC.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and GC.GnrlCnfgQlfr = 'PriceSourceGV'
                                             and GC.GnrlCnfgHdrID = vPCD.RwPrceLcleID
                                             and GC.GnrlCnfgMulti = 'Y'
  Inner Join GeneralConfiguration LQ (NoLock) on LQ.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and LQ.GnrlCnfgQlfr = 'GVQuoteType'
                                             and LQ.GnrlCnfgHdrID = vPCD.RwPrceLcleID
  Inner Join GeneralConfiguration RQ (NoLock) on RQ.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and RQ.GnrlCnfgQlfr = 'GVRAQuoteType'
                                             and RQ.GnrlCnfgHdrID = vPCD.RwPrceLcleID
  Left Join GeneralConfiguration GV (NoLock) on GV.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and GV.GnrlCnfgQlfr = 'GVMultiplier'
                                             and GV.GnrlCnfgHdrID = vPCD.RwPrceLcleID
  Left Join GeneralConfiguration RT (NoLock) on RT.GnrlCnfgTblNme = 'RawPriceLocale'
                                             and RT.GnrlCnfgQlfr = 'GVRequestType'
                                             and RT.GnrlCnfgHdrID = vPCD.RwPrceLcleID
  Left Outer Join SourceSystem SS (NoLock) on SS.Name = 'GlobalView'
UNION
Select
    RPHdrID 
  , RPHdrAbbv 
  , RPLcleIntrfceCde 
  , InstrumentID 
  , PLATTSOffset
  , RwPrceLcleID 
  , Replace(GVQuoteType, ' ', '') 
  , Replace(GVRAQuoteType, ' ', '') 
  , Source 
  , GVMultiplier 
  , GVRequestType 
From CUSTOM_GV_DATASET vGDS
Where 1 = 1
  and vGDS.Status = 'A'
Go


/*--------------------------------------------
-- If the procedure was successfully created then grant execute 
-- rights to sysuser log it and notify user
--------------------------------------------*/
If OBJECT_ID('dbo.v_GV_Price_Data') Is NOT Null
BEGIN
	PRINT '<<< CREATED View dbo.v_GV_Price_Data >>>'
	Grant Select On dbo.v_GV_Price_Data to SYSUSER
	Grant Select On dbo.v_GV_Price_Data to RightAngleAccess
END
ELSE
	Print '<<<Failed Creating View dbo.v_GV_Price_Data >>>'
GO

