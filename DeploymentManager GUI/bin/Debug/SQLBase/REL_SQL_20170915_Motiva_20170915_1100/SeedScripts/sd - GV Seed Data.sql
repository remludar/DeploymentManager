Insert Into GeneralConfiguration
Select
    'RawPriceLocale'
  , 'GVRequestType'
  , 0
  , 0
  , 'x'
--Select *  
Where 1 = 1
  And Not Exists (Select 'x' From GeneralConfiguration
                  where GnrlCnfgTblNme = 'RawPriceLocale'
                    and GnrlCnfgQlfr = 'GVRequestType'
                    and GnrlCnfgHdrID = 0)
GO


Insert Into GeneralConfiguration
Select
    'RawPriceLocale'
  , 'LoadGVFuture'
  , 0
  , 0
  , 'y/n'
--Select *  
Where 1 = 1
  And Not Exists (Select 'x' From GeneralConfiguration
                  where GnrlCnfgTblNme = 'RawPriceLocale'
                    and GnrlCnfgQlfr = 'LoadGVFuture'
                    and GnrlCnfgHdrID = 0)
GO

Insert Into GeneralConfiguration
Select
    'RawPriceLocale'
  , 'PriceSourceGV'
  , 0
  , 0
  , 'y/n'
Where 1 = 1
  And Not Exists (Select 'x' From GeneralConfiguration
                  where GnrlCnfgTblNme = 'RawPriceLocale'
                    and GnrlCnfgQlfr = 'PriceSourceGV'
                    and GnrlCnfgHdrID = 0)
GO

Insert Into GeneralConfiguration
Select
    'RawPriceLocale'
  , 'GVQuoteType'
  , 0
  , 0
  , 'x'
Where 1 = 1
  And Not Exists (Select 'x' From GeneralConfiguration
                  where GnrlCnfgTblNme = 'RawPriceLocale'
                    and GnrlCnfgQlfr = 'GVQuoteType'
                    and GnrlCnfgHdrID = 0)
GO

Insert Into GeneralConfiguration
Select
    'RawPriceLocale'
  , 'GVRAQuoteType'
  , 0
  , 0
  , 'x'
Where 1 = 1
  And Not Exists (Select 'x' From GeneralConfiguration
                  where GnrlCnfgTblNme = 'RawPriceLocale'
                    and GnrlCnfgQlfr = 'GVRAQuoteType'
                    and GnrlCnfgHdrID = 0)
GO

Insert Into GeneralConfiguration
Select
    'RawPriceLocale'
  , 'GVMultiplier'
  , 0
  , 0
  , '1'
Where 1 = 1
  And Not Exists (Select 'x' From GeneralConfiguration
                  where GnrlCnfgTblNme = 'RawPriceLocale'
                    and GnrlCnfgQlfr = 'GVMultiplier'
                    and GnrlCnfgHdrID = 0)
GO

Insert Into SourceSystem (Name)
Select
  'GlobalView'
where 1 = 1
  and Not Exists (Select 'x' from SourceSystem where name = 'GlobalView')
GO

Insert Into CUSTOM_GV_SETTINGS 
Select 
  'URL', 
  'http://webapi.gvsi.com/services/mv2'
Where 1 = 1
  and Not Exists (Select 'x' From CUSTOM_GV_SETTINGS i 
                  Where i.Setting = 'URL')
GO

Insert Into CUSTOM_GV_SETTINGS 
Select 
  'URL', 
  'http://webapi.gvsi.com/services/mv2'
Where 1 = 1
  and Not Exists (Select 'x' From CUSTOM_GV_SETTINGS i 
                  Where i.Setting = 'URL')
GO

Insert Into CUSTOM_GV_SETTINGS 
Select 
  'LOGIN', 
  'GV Loginid'
Where 1 = 1
  and Not Exists (Select 'x' From CUSTOM_GV_SETTINGS i 
                  Where i.Setting = 'LOGIN')
GO


Insert Into CUSTOM_GV_SETTINGS 
Select 
  'PASSWORD', 
  'password'
Where 1 = 1
  and Not Exists (Select 'x' From CUSTOM_GV_SETTINGS i 
                  Where i.Setting = 'PASSWORD')
GO
