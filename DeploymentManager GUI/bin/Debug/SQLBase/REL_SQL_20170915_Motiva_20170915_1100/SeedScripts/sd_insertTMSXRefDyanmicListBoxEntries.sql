delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'TMSHostCode'

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'04',
		'04 - Other',
		'04 - Other',
		'10',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'02',
		'02 - Wholesale',
		'02 - Wholesale',
		'20',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'03',
		'03 - Commercial',
		'03 - Commercial',
		'30',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'09',
		'09 - Commercial Contract',
		'09 - Commercial Contract',
		'40',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'01',
		'01 - Retail',
		'01 - Retail',
		'50',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'05',
		'05 - Aviation',
		'05 - Aviation',
		'60',
		'V',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSHostCode', 
		'06',
		'06 - Asphalt',
		'06 - Asphalt',
		'70',
		'V',
		'A')

GO



delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'DistributionChannel'

GO 
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'DistributionChannel','14','Retail','Retail','20','V','A')
GO 
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'DistributionChannel','03','Aviation','Aviation','30','V','A')
GO 
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'DistributionChannel','13','Bitumen','Bitumen','40','V','A')
GO
DECLARE @i_id INT exec sp_getkey 'dynamiclistbox', @i_id OUT insert into dynamiclistbox ( DynLstBxID     ,DynLstBxQlfr     ,DynLstBxTyp     ,DynLstBxDesc     ,DynLstBxAbbv     ,DynLstBxOrdr     ,DynLstBxTblTyp     ,DynLstBxStts )  Values (@i_id,    'DistributionChannel','00','All Other Values','All Other Values','10','V','A')
GO
		


delete 
--select *
from dynamiclistbox where DynLstBxQlfr = 'TMSBrandType'

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSBrandType', 
		'S',
		'S',
		'S',
		'10',
		'S',
		'A')

GO

DECLARE	@i_id	INT
exec	sp_getkey 'dynamiclistbox', @i_id OUT
insert into dynamiclistbox (	DynLstBxID
				,DynLstBxQlfr
				,DynLstBxTyp
				,DynLstBxDesc
				,DynLstBxAbbv
				,DynLstBxOrdr
				,DynLstBxTblTyp
				,DynLstBxStts )
	Values (@i_id, 
		'TMSBrandType', 
		'U',
		'U',
		'U',
		'20',
		'S',
		'A')

GO



delete from dbo.MTVTMSClassOfTradeXRef

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('14', '01', '02', 'N', 'S', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('14', '02', '03', 'Y', 'U', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('14', '03', '03', 'Y', 'U', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('14', '05', '09', 'Y', 'U', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('14', '06', '09', 'Y', 'U', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('14', '00', '01', 'N', 'S', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('03', '00', '05', 'N', 'S', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('13', '00', '06', 'N', 'S', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

insert into dbo.MTVTMSClassOfTradeXRef
(DistributionChannel, ClassOfTrade, TMSHostCode, CommercialFuelIndicator, BrandType, EffectiveFrom, EffectiveTo, LastUpdateUserID, LastUpdateDate, Status)
values ('00', '00', '04', 'N', 'S', '2016-01-01 00:00:00.000', '2049-12-31 00:00:00.000', 1429, '2016-05-31 10:20:34.763', 'A')

