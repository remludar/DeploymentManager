IF EXISTS (
SELECT *
FROM tempdb.dbo.sysobjects
WHERE ID = OBJECT_ID(N'tempdb..#CountyState')
)
BEGIN
    DROP TABLE #CountyState
    PRINT '<<< DROPPED TABLE #CountyState >>>'
END

create table #CountyState (localeId int, localeCounty varchar(120) , localeState varchar(120))
Insert into #CountyState select LcleID,LocaleCounty,LocaleState from v_MTV_TaxLocaleStateCounty
GO

Insert Into MTVProductSeasonality (RAProductId,RALocaleID,SAPMaterialNumber,County,State,SAPPlantNumber,EPAFromDate,EPAToDate,CreatedDate,CreatedBy,UpdatedDate,UpdatedBy)
Select 
p.PrdctID,
l.LcleID,
gcmc.GnrlCnfgMulti,
--county.localeCounty,
l2.LcleID as localeCountyId,
--state.localeState,
l3.LcleID as localeStateId,
gcpc.GnrlCnfgMulti,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL
From ProductLocale pl
Join Product p On   pl.PrdctID = p.PrdctID 
Left Join Locale l  On   pl.LcleID = l.LcleID 
Left Join GeneralConfiguration gcr  On  p.PrdctID = gcr.GnrlCnfgHdrID AND gcr.GnrlCnfgQlfr = 'RetailProduct' AND gcr.GnrlCnfgTblNme = 'Product' AND gcr.GnrlCnfgHdrID <> 0 
Left Join GeneralConfiguration gcmc  On  p.PrdctID = gcmc.GnrlCnfgHdrID AND gcmc.GnrlCnfgQlfr = 'SAPMaterialCode' AND gcmc.GnrlCnfgTblNme = 'Product' AND gcmc.GnrlCnfgHdrID <> 0 
Left Join GeneralConfiguration gcpc  On  l.LcleID = gcpc.GnrlCnfgHdrID AND gcpc.GnrlCnfgQlfr = 'SAPPlantCode' AND gcpc.GnrlCnfgTblNme = 'Locale' AND gcpc.GnrlCnfgHdrID <> 0 
left join #CountyState county on l.LcleID =  county.localeId
left join #CountyState state on l.LcleID =  state.localeId
left join Locale l2 on l2.LcleAbbrvtn=county.localeCounty
left join Locale l3 on l3.LcleAbbrvtn=state.localeState
Where 
gcpc.GnrlCnfgMulti is not null
and gcr.GnrlCnfgMulti='Y'  order by PrdctID
GO